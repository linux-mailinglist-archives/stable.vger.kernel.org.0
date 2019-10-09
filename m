Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC37BD15FB
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732393AbfJIRYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731878AbfJIRYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:37 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D80121929;
        Wed,  9 Oct 2019 17:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641876;
        bh=+FTIqJfSl5gV5KQzwpjj7t5RyVOYnsyRblb+nrJ5iJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QO86CM2KT66nhDhKSaerhaQ6W/+f99pVNrN/u1QTj7S4Z4JfczGtxv17pYinss8I4
         NED0YC1nMSOTabZxEm2JVZEx5mOhuAkqaAHHJCDBpUuxVGuLQXEMdTOYHsm/uzBIml
         nQ22dhtmpwAmuePf7MTjDpQpsH+wsc9+4ssyKdVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 20/21] namespace: fix namespace.pl script to support relative paths
Date:   Wed,  9 Oct 2019 13:06:13 -0400
Message-Id: <20191009170615.32750-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170615.32750-1-sashal@kernel.org>
References: <20191009170615.32750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 729c547fc9e1e..30c43e639db8a 100755
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

