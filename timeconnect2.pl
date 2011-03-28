#!/usr/bin/perl -w
use warnings;
use strict;
#
# Attempt a connection to a remote host and time the response
#

use Socket;
use FileHandle;
use Time::HiRes;

my ($rem_host, $rem_port) = ($ARGV[0], $ARGV[1]);

$| = 1;

$rem_host || die "Remote host not supplied";
$rem_port || die "Remote port not supplied";

while (1) {
	my $iaddr = inet_aton($rem_host);
	my $paddr = sockaddr_in($rem_port, $iaddr);
	my $proto = getprotobyname('tcp');
	my $fh    = new FileHandle;

	my $time1 = Time::HiRes::time;
	if (!socket($fh, PF_INET, SOCK_STREAM, $proto)) {
		print "socket error\n";
		next;
	}
	
	if (!connect($fh, $paddr)) {
		print "connect error\n";
		next;
	}

	$fh->autoflush(1);
	my $elapsed = Time::HiRes::time - $time1;

	print "". localtime time, ' ',
	  $rem_host, ':', $rem_port, "\t",
	  inet_ntoa($iaddr), "\t",
	  "$elapsed seconds\n";

	# easily allow only one probe per secons
	if ($elapsed <1) {
	  Time::HiRes::sleep(1-$elapsed);
	}
}

0;
