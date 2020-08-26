Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDDD32534E2
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 18:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHZQ2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 12:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgHZQ2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 12:28:42 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421EEC061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:41 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id f125so968273wma.3
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 09:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=E9ahC+bz9OJiuGWH+05TLgujNnBdc6v8wT5CCTVV9GU=;
        b=uB3jVsYX2AtKZMEEsiPsQDWLZpGHMCuFLoYF20Vg6lYbqdutEv4sAkw/6rC8abgiP+
         0TgBw3VXPuI/1NpAncTp8QXWM3NJ7xoRj0pvhcyr3tQ4pw/CyBlwOHdnJxfxj2OIcK0l
         c/dTqOpeXAWDtlpHTrusUNDms2z+VzopaIQcSdxouR+rvPOUebADKedu4SSomnyTlaxa
         TRa41TA/mElUqvDvhWDHR8tNyNRMDxOeJ4RomD84J7j7BIoEi9E5eqFNwny8rbg3Z8OQ
         hALLIhgDMSkxR+4BiLdz38i0K5SMdqwgDI/HJUGeomw/ZjEshks9HKcvjET0IBvKd5ge
         BsYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E9ahC+bz9OJiuGWH+05TLgujNnBdc6v8wT5CCTVV9GU=;
        b=JxTcFCi8ywBc1wF1HK9uJnfUS5Fc5K9cYCwT+JhlwQ9+6LtKhi96McN4IeGjnug7kd
         owIBJuaMejZDS/AAl6dhanvncYxxpLHypWTrSCrNaQs5AI0/Zi/UklK/t7AIDEbj9Yd9
         kSfphvvsc+OimmgR6EEbImHdMcSyYqTL00Do9CWMxAMplLJXwxrkYOmAZxvGKfua4g3d
         6Wy4XogmXUOBRSOJxF9jLwC56LkoJ2acz5iMZ+q/bAcD63y+ABK4JpkQK3bq/b9WaogV
         V6eRC0szY4JKYPM1TGEJCYmBShrX0mE8JMxikj+0YjoDQmBMKPSImi8U9gzbv+M2OuGQ
         8AjQ==
X-Gm-Message-State: AOAM531wz5pTCufc3VKXkJJryOXUy7AWlVCTrTbd5FyG6WDcWKv7LmFq
        Tni9Hin3o+dvcMOSUUJN6000SPpj25gPesLhOEOZ/KY5JFyeXBrG477LrlSOGtQ1AwR6XnRKRnr
        yjuqOGl8cn4uQ/2NGL63/c49HHHr4fITsv6cIm1hRqkfKTvtNq4L78uif2M0WaVB0ICg=
X-Google-Smtp-Source: ABdhPJy1kuGr/rxNgdCUGaLcgo8S4gGAdEAm/X1knugVfQs3Z7a2GLo1WuD5cFyebwmvUDQxbUfupevpjAyhsw==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:110:7220:84ff:fe09:a3aa])
 (user=maennich job=sendgmr) by 2002:a5d:638c:: with SMTP id
 p12mr15878484wru.17.1598459319132; Wed, 26 Aug 2020 09:28:39 -0700 (PDT)
Date:   Wed, 26 Aug 2020 17:28:24 +0100
In-Reply-To: <20200826162828.3330007-1-maennich@google.com>
Message-Id: <20200826162828.3330007-3-maennich@google.com>
Mime-Version: 1.0
References: <20200826162828.3330007-1-maennich@google.com>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v5.4 2/6] kheaders: optimize md5sum calculation for in-tree builds
From:   Matthias Maennich <maennich@google.com>
To:     stable@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        Denis Efremov <efremov@linux.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

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
(cherry picked from commit 0e11773e76098729552b750ccff79374d1e62002)
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 kernel/gen_kheaders.sh | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/gen_kheaders.sh b/kernel/gen_kheaders.sh
index b8054b0d5010..6ff86e62787f 100755
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
@@ -79,8 +80,7 @@ find $cpio_dir -printf "./%P\n" | LC_ALL=C sort | \
     --owner=0 --group=0 --numeric-owner --no-recursion \
     -Jcf $tarfile -C $cpio_dir/ -T - > /dev/null
 
-echo "$src_files_md5" >  kernel/kheaders.md5
-echo "$obj_files_md5" >> kernel/kheaders.md5
+echo $headers_md5 > kernel/kheaders.md5
 echo "$this_file_md5" >> kernel/kheaders.md5
 echo "$(md5sum $tarfile | cut -d ' ' -f1)" >> kernel/kheaders.md5
 
-- 
2.28.0.297.g1956fa8f8d-goog

