Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1A6D2B4B
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 00:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjCaWZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 18:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbjCaWZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 18:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D129B21ABA;
        Fri, 31 Mar 2023 15:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89000B8326F;
        Fri, 31 Mar 2023 22:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4ECC433EF;
        Fri, 31 Mar 2023 22:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680301542;
        bh=8b4AACLvBtD9Wnuj9OeF8LKCAqENrit9laCC1RKASB4=;
        h=Date:To:From:Subject:From;
        b=C2+6N6XMpWZadJltd8A7lvNglMOOGyf+rBVi6dLzeWIfSVm6nkhal8RETPdcvvGD6
         /QR7RIcP4LvBgc5/4igBKbVG/1J3x3c7nDDgBuREywjZ2XdwW+9OGOxlhKxkEjmVg6
         UPnZfERO8nqBgb0lLoQqfJX39nUeCqvX72kr+cCQ=
Date:   Fri, 31 Mar 2023 15:25:41 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        slava@dubeyko.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-sysfs-interface-lifetime.patch added to mm-hotfixes-unstable branch
Message-Id: <20230331222542.3D4ECC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix sysfs interface lifetime
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-sysfs-interface-lifetime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-sysfs-interface-lifetime.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix sysfs interface lifetime
Date: Fri, 31 Mar 2023 05:55:15 +0900

The current nilfs2 sysfs support has issues with the timing of creation
and deletion of sysfs entries, potentially leading to null pointer
dereferences, use-after-free, and lockdep warnings.

Some of the sysfs attributes for nilfs2 per-filesystem instance refer to
metadata file "cpfile", "sufile", or "dat", but
nilfs_sysfs_create_device_group that creates those attributes is executed
before the inodes for these metadata files are loaded, and
nilfs_sysfs_delete_device_group which deletes these sysfs entries is
called after releasing their metadata file inodes.

Therefore, access to some of these sysfs attributes may occur outside of
the lifetime of these metadata files, resulting in inode NULL pointer
dereferences or use-after-free.

In addition, the call to nilfs_sysfs_create_device_group() is made during
the locking period of the semaphore "ns_sem" of nilfs object, so the
shrinker call caused by the memory allocation for the sysfs entries, may
derive lock dependencies "ns_sem" -> (shrinker) -> "locks acquired in
nilfs_evict_inode()".

Since nilfs2 may acquire "ns_sem" deep in the call stack holding other
locks via its error handler __nilfs_error(), this causes lockdep to report
circular locking.  This is a false positive and no circular locking
actually occurs as no inodes exist yet when
nilfs_sysfs_create_device_group() is called.  Fortunately, the lockdep
warnings can be resolved by simply moving the call to
nilfs_sysfs_create_device_group() out of "ns_sem".

This fixes these sysfs issues by revising where the device's sysfs
interface is created/deleted and keeping its lifetime within the lifetime
of the metadata files above.

Link: https://lkml.kernel.org/r/20230330205515.6167-1-konishi.ryusuke@gmail.com
Fixes: dd70edbde262 ("nilfs2: integrate sysfs support into driver")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+979fa7f9c0d086fdc282@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/0000000000003414b505f7885f7e@google.com
Reported-by: syzbot+5b7d542076d9bddc3c6a@syzkaller.appspotmail.com
  Link: https://lkml.kernel.org/r/0000000000006ac86605f5f44eb9@google.com
Cc: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c     |    2 ++
 fs/nilfs2/the_nilfs.c |   12 +++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/super.c~nilfs2-fix-sysfs-interface-lifetime
+++ a/fs/nilfs2/super.c
@@ -482,6 +482,7 @@ static void nilfs_put_super(struct super
 		up_write(&nilfs->ns_sem);
 	}
 
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
@@ -1105,6 +1106,7 @@ nilfs_fill_super(struct super_block *sb,
 	nilfs_put_root(fsroot);
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_dat);
--- a/fs/nilfs2/the_nilfs.c~nilfs2-fix-sysfs-interface-lifetime
+++ a/fs/nilfs2/the_nilfs.c
@@ -87,7 +87,6 @@ void destroy_nilfs(struct the_nilfs *nil
 {
 	might_sleep();
 	if (nilfs_init(nilfs)) {
-		nilfs_sysfs_delete_device_group(nilfs);
 		brelse(nilfs->ns_sbh[0]);
 		brelse(nilfs->ns_sbh[1]);
 	}
@@ -305,6 +304,10 @@ int load_nilfs(struct the_nilfs *nilfs,
 		goto failed;
 	}
 
+	err = nilfs_sysfs_create_device_group(sb);
+	if (unlikely(err))
+		goto sysfs_error;
+
 	if (valid_fs)
 		goto skip_recovery;
 
@@ -366,6 +369,9 @@ int load_nilfs(struct the_nilfs *nilfs,
 	goto failed;
 
  failed_unload:
+	nilfs_sysfs_delete_device_group(nilfs);
+
+ sysfs_error:
 	iput(nilfs->ns_cpfile);
 	iput(nilfs->ns_sufile);
 	iput(nilfs->ns_dat);
@@ -697,10 +703,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	if (err)
 		goto failed_sbh;
 
-	err = nilfs_sysfs_create_device_group(sb);
-	if (err)
-		goto failed_sbh;
-
 	set_nilfs_init(nilfs);
 	err = 0;
  out:
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-potential-uaf-of-struct-nilfs_sc_info-in-nilfs_segctor_thread.patch
nilfs2-fix-sysfs-interface-lifetime.patch

