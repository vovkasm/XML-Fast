package XML::Fast;

use 5.008008;
use strict;
use warnings;
use Encode;

use base 'Exporter';
our @EXPORT_OK = our @EXPORT = qw( xml2hash );

our $VERSION = '0.01';

use XSLoader;
XSLoader::load('XML::Fast', $VERSION);

sub xml2hash($;%) {
	my $xml = shift;
	my %args = (
		order  => 0,        # not impl
		attr   => '-',      # ok
		text   => '#text',  # ok
		join   => '',       # ok
		trim   => 1,        # ok
		cdata  => undef,    # ok + fallback -> text
		comm   => undef,    # ok
		@_
	);
	_xml2hash($xml,\%args);
}

1;
__END__
=head1 NAME

XML::Fast - Simple and very fast XML to hash conversion

=head1 SYNOPSIS

  use XML::Fast;
  
  my $hash = xml2hash $xml;
  my $hash2 = xml2hash $xml, attr => '.', text => '~';

=head1 DESCRIPTION

This module implements simple, state machine based, XML parser written in C.

It could parse some kind of broken XML's. If you need XML validator, use L<XML::LibXML>

=head1 RATIONALE

Another similar module is L<XML::Bare>. I've used it for some time, but it have some failures:

=over 4

=item * If your XML have node with name 'value', you'll got a segfault

=item * If your XML have node with TextNode, then CDATANode, then again TextNode, you'll got broken value

=back

So, after count of tries to fix L<XML::Bare>, I've decided to write parser from scratch.

It is about 25% faster than L<XML::Bare> and about 90% faster, than L<XML::LibXML>

Here is some features and principles:

=over 4

=item * It uses minimal count of memory allocations.

=item * All XML is parsed in 1 scan.

=item * All values are copied from source XML only once (to destination keys/values)

=item * If some types of nodes (for ex comments) are ignored, there are no memory allocations/copy for them.

=back

=head1 EXPORT

=head2 xml2hash $xml, [ %options ]


=head1 SEE ALSO

=over 4

=item * L<XML::Bare>

Another fast parser, but have problems

=item * L<XML::LibXML>

The most powerful XML parser for perl. If you don't need to parse gigabytes of XML ;)

=item * L<XML::Hash::LX>

XML parser, that uses L<XML::LibXML> for parsing and then constructs hash structure, identical to one, generated by this module. (At least, it should ;))

=back

=head1 AUTHOR

Mons Anderson, E<lt>mons@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Vladimir Perepelitsa

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
