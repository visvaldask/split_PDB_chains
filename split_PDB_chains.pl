#!/usr/bin/perl -w
#
# A super simple perl script that
# splits protein into chains
# V Kairys, Vilnius University
#

my $pdbTemplate = 'A6 A5 x1 A4 A1 A3 x1 A1 A5 x3 A8 A8 A8 A6 A6 x6 A4 A2 A2';
my @pdbDescriptive = qw( record serial name altLoc resName chainID resSeq x y z
	occupancy tempFactor segID element charge );

if (@ARGV ne 1 ) {
	die "Usage: $0 pdbfile(s)\n";
}

foreach $file (@ARGV){

	(my $root = $file) =~ s/\..*$//; #remove extension
	print "pdb file $file $root\n";
	open(PROTEIN,"<$file") or die "Error while opening $file $!\n";
	#open(OUTF,">${pdb}_fragm.pdb") or die "Error while opening ${pdb}_fragm $!\n";
	my %chainlist=();
	while (<PROTEIN>){
		if(/^ATOM/ or /^HETAT/){
			#next if (/^ATOM.........H/); #skip hydrogens!
	 		my %atom=(); 

			@atom{ @pdbDescriptive } = unpack( $pdbTemplate, $_ );
                                                                                
			# Trim each value.
			s/^\s+// for values %atom;
  
			if($atom{'chainID'} eq ""){
				$atom{'chainID'} = "_";
			}
			$chainlist{$atom{'chainID'}}=1;
			#print "$atom{'chainID'}\n";
			#my $resnum= $atom{'resSeq'};
			#if(exists $reshash{$resnum} and $reshash{$resnum} == 1 and $atom{'chainID'} eq $ch){
			#	print OUTF "$_";
			#}

		}
	}
	#close(OUTF);

	foreach $chain ( keys %chainlist){
		print "chain $chain\n";
		open(OUTF,">${root}_${chain}.pdb") or die "Error while opening ${root}_${chain}.pdb $!\n";
		seek(PROTEIN,0,0);  #rewind
	while (<PROTEIN>){
		if(/^ATOM/ or /^HETAT/){
			#next if (/^ATOM.........H/); #skip hydrogens!
	 		my %atom=(); 

			@atom{ @pdbDescriptive } = unpack( $pdbTemplate, $_ );
                                                                                
			# Trim each value.
			s/^\s+// for values %atom;
  
			if($atom{'chainID'} eq ""){
				$atom{'chainID'} = "_";
			}
			$chainlist{$atom{'chainID'}}=1;
			print OUTF $_ if ($atom{'chainID'} eq $chain);
		}
	}
		close(OUTF);
	}
	#system("sheba ${root}_A.pdb ${root}_B.pdb");
	#system("sheba -x ${root}_A.pdb ${root}_B.pdb");



}

