Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A928BE6745
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfJ0VTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731452AbfJ0VT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D61520717;
        Sun, 27 Oct 2019 21:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211166;
        bh=2LmyhbCXVxyjU1oqCpnEO3Teoc6Sz9N58R4YWqEugEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjC4QtJ3+mPNg4HZmc72oo1eULJ0bAfJj+IBH+Dc328Xom7jNlpsN09RSTOahQr7X
         vPPgrsCOpW9mlODYy7rSQdy9immpHtDgUHKSCVNtrQDGPVq3OJXatzKzBFo6bkRT9s
         XPj7E6jZcF0G2EQeBEr86snl3ju6dyaXGJkJ4xKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 056/197] namespace: fix namespace.pl script to support relative paths
Date:   Sun, 27 Oct 2019 21:59:34 +0100
Message-Id: <20191027203354.698291506@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 82fdd12b95727640c9a8233c09d602e4518e71f7 ]

The namespace.pl script does not work properly if objtree is not set to
an absolute path. The do_nm function is run from within the find
function, which changes directories.

Because of this, appending objtree, $File::Find::dir, and $source, will
return a path which is not valid from the current directory.

This used to work when objtree was set to an absolute path when using
"make namespacecheck". It appears to have not worked when calling
./scripts/namespace.pl directly.

This behavior was changed in 7e1c04779efd ("kbuild: Use relative path
for $(objtree)", 2014-05-14)

Rather than fixing the Makefile to set objtree to an absolute path, just
fix namespace.pl to work when srctree and objtree are relative. Also fix
the script to use an absolute path for these by default.

Use the File::Spec module for this purpose. It's been part of perl
5 since 5.005.

The curdir() function is used to get the current directory when the
objtree and srctree aren't set in the environment.

rel2abs() is used to convert possibly relative objtree and srctree
environment variables to absolute paths.

Finally, the catfile() function is used instead of string appending
paths together, since this is more robust when joining paths together.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/namespace.pl | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/scripts/namespace.pl b/scripts/namespace.pl
index 6135574a6f394..1da7bca201a42 100755
--- a/scripts/namespace.pl
+++ b/scripts/namespace.pl
@@ -65,13 +65,14 @@
 use warnings;
 use strict;
 use File::Find;
+use File::Spec;
 
 my $nm = ($ENV{'NM'} || "nm") . " -p";
 my $objdump = ($ENV{'OBJDUMP'} || "objdump") . " -s -j .comment";
-my $srctree = "";
-my $objtree = "";
-$srctree = "$ENV{'srctree'}/" if (exists($ENV{'srctree'}));
-$objtree = "$ENV{'objtree'}/" if (exists($ENV{'objtree'}));
+my $srctree = File::Spec->curdir();
+my $objtree = File::Spec->curdir();
+$srctree = File::Spec->rel2abs($ENV{'srctree'}) if (exists($ENV{'srctree'}));
+$objtree = File::Spec->rel2abs($ENV{'objtree'}) if (exists($ENV{'objtree'}));
 
 if ($#ARGV != -1) {
 	print STDERR "usage: $0 takes no parameters\n";
@@ -231,9 +232,9 @@ sub do_nm
 	}
 	($source = $basename) =~ s/\.o$//;
 	if (-e "$source.c" || -e "$source.S") {
-		$source = "$objtree$File::Find::dir/$source";
+		$source = File::Spec->catfile($objtree, $File::Find::dir, $source)
 	} else {
-		$source = "$srctree$File::Find::dir/$source";
+		$source = File::Spec->catfile($srctree, $File::Find::dir, $source)
 	}
 	if (! -e "$source.c" && ! -e "$source.S") {
 		# No obvious source, exclude the object if it is conglomerate
-- 
2.20.1



