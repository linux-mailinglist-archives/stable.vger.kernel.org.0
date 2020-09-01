Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5CA259775
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbgIAQOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731197AbgIAPfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:35:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 531AE205F4;
        Tue,  1 Sep 2020 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974513;
        bh=xZHIhGiqh1IX7MHaAbwOD2eKNT33pVE2Spr2PQ9iG6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqkxxUxL95SkDePsRjAkLHTdy7Oz9Pt1FgKBm3of2C8DTNxuWfCsE/VBD7vidRxnt
         wOqjmFy8C76dF/+iz240D4ZZK5eqwyrUocjSF/ZtOue2l5idE5OWIkXfbp4MM5AMvw
         9Hi53x47CNBpoLXT883JHRjhlSM2TkV4CgOn6jtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.4 206/214] kheaders: optimize md5sum calculation for in-tree builds
Date:   Tue,  1 Sep 2020 17:11:26 +0200
Message-Id: <20200901151002.799482306@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

commit 0e11773e76098729552b750ccff79374d1e62002 upstream.

This script computes md5sum of headers in srctree and in objtree.
However, when we are building in-tree, we know the srctree and the
objtree are the same. That is, we end up with the same computation
twice. In fact, the first two lines of kernel/kheaders.md5 are always
the same for in-tree builds.

Unify the two md5sum calculations.

For in-tree builds ($building_out_of_srctree is empty), we check
only two directories, "include", and "arch/$SRCARCH/include".

For out-of-tree builds ($building_out_of_srctree is 1), we check
4 directories, "$srctree/include", "$srctree/arch/$SRCARCH/include",
"include", and "arch/$SRCARCH/include" since we know they are all
different.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/gen_kheaders.sh |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/kernel/gen_kheaders.sh
+++ b/kernel/gen_kheaders.sh
@@ -21,29 +21,30 @@ arch/$SRCARCH/include/
 # Uncomment it for debugging.
 # if [ ! -f /tmp/iter ]; then iter=1; echo 1 > /tmp/iter;
 # else iter=$(($(cat /tmp/iter) + 1)); echo $iter > /tmp/iter; fi
-# find $src_file_list -name "*.h" | xargs ls -l > /tmp/src-ls-$iter
-# find $obj_file_list -name "*.h" | xargs ls -l > /tmp/obj-ls-$iter
+# find $all_dirs -name "*.h" | xargs ls -l > /tmp/ls-$iter
+
+all_dirs=
+if [ "$building_out_of_srctree" ]; then
+	for d in $dir_list; do
+		all_dirs="$all_dirs $srctree/$d"
+	done
+fi
+all_dirs="$all_dirs $dir_list"
 
 # include/generated/compile.h is ignored because it is touched even when none
 # of the source files changed. This causes pointless regeneration, so let us
 # ignore them for md5 calculation.
-pushd $srctree > /dev/null
-src_files_md5="$(find $dir_list -name "*.h"			   |
-		grep -v "include/generated/compile.h"		   |
-		grep -v "include/generated/autoconf.h"		   |
-		xargs ls -l | md5sum | cut -d ' ' -f1)"
-popd > /dev/null
-obj_files_md5="$(find $dir_list -name "*.h"			   |
-		grep -v "include/generated/compile.h"		   |
-		grep -v "include/generated/autoconf.h"		   |
+headers_md5="$(find $all_dirs -name "*.h"			|
+		grep -v "include/generated/compile.h"	|
+		grep -v "include/generated/autoconf.h"	|
 		xargs ls -l | md5sum | cut -d ' ' -f1)"
+
 # Any changes to this script will also cause a rebuild of the archive.
 this_file_md5="$(ls -l $sfile | md5sum | cut -d ' ' -f1)"
 if [ -f $tarfile ]; then tarfile_md5="$(md5sum $tarfile | cut -d ' ' -f1)"; fi
 if [ -f kernel/kheaders.md5 ] &&
-	[ "$(head -n 1 kernel/kheaders.md5)" = "$src_files_md5" ] &&
-	[ "$(head -n 2 kernel/kheaders.md5 | tail -n 1)" = "$obj_files_md5" ] &&
-	[ "$(head -n 3 kernel/kheaders.md5 | tail -n 1)" = "$this_file_md5" ] &&
+	[ "$(head -n 1 kernel/kheaders.md5)" = "$headers_md5" ] &&
+	[ "$(head -n 2 kernel/kheaders.md5 | tail -n 1)" = "$this_file_md5" ] &&
 	[ "$(tail -n 1 kernel/kheaders.md5)" = "$tarfile_md5" ]; then
 		exit
 fi
@@ -79,8 +80,7 @@ find $cpio_dir -printf "./%P\n" | LC_ALL
     --owner=0 --group=0 --numeric-owner --no-recursion \
     -Jcf $tarfile -C $cpio_dir/ -T - > /dev/null
 
-echo "$src_files_md5" >  kernel/kheaders.md5
-echo "$obj_files_md5" >> kernel/kheaders.md5
+echo $headers_md5 > kernel/kheaders.md5
 echo "$this_file_md5" >> kernel/kheaders.md5
 echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
 


