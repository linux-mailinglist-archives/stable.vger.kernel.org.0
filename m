Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9852362208C
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiKHX7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiKHX6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:58:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE1A1A4;
        Tue,  8 Nov 2022 15:58:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 611CA617C6;
        Tue,  8 Nov 2022 23:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8813C433C1;
        Tue,  8 Nov 2022 23:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667951903;
        bh=9JouXHHQZE4qoJcgW5pkf06utlkHVCVvNi9aIoKg2TA=;
        h=Date:To:From:Subject:From;
        b=tYKUiF0GLkR3ZtL8guDhCknW3lIPZsaC0qyP555WRXyGJRhNRvJRbsJ6z4kMVYwm4
         mnABy6g3LISZSxAOO6DcvluxtLSwZTQwWSesqSsND5nQFzaD0oTP5ZFG0C0HI5rSR+
         sPuOW+L7ZulzyZuUdkxxlV2uDcUmpzfP1UGBHZjY=
Date:   Tue, 08 Nov 2022 15:58:23 -0800
To:     mm-commits@vger.kernel.org, syoshida@redhat.com,
        stable@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch removed from -mm tree
Message-Id: <20221108235823.B8813C433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix use-after-free bug of ns_writer on remount
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix use-after-free bug of ns_writer on remount
Date: Fri, 4 Nov 2022 23:29:59 +0900

If a nilfs2 filesystem is downgraded to read-only due to metadata
corruption on disk and is remounted read/write, or if emergency read-only
remount is performed, detaching a log writer and synchronizing the
filesystem can be done at the same time.

In these cases, use-after-free of the log writer (hereinafter
nilfs->ns_writer) can happen as shown in the scenario below:

 Task1                               Task2
 --------------------------------    ------------------------------
 nilfs_construct_segment
   nilfs_segctor_sync
     init_wait
     init_waitqueue_entry
     add_wait_queue
     schedule
                                     nilfs_remount (R/W remount case)
				       nilfs_attach_log_writer
                                         nilfs_detach_log_writer
                                           nilfs_segctor_destroy
                                             kfree
     finish_wait
       _raw_spin_lock_irqsave
         __raw_spin_lock_irqsave
           do_raw_spin_lock
             debug_spin_lock_before  <-- use-after-free

While Task1 is sleeping, nilfs->ns_writer is freed by Task2.  After Task1
waked up, Task1 accesses nilfs->ns_writer which is already freed.  This
scenario diagram is based on the Shigeru Yoshida's post [1].

This patch fixes the issue by not detaching nilfs->ns_writer on remount so
that this UAF race doesn't happen.  Along with this change, this patch
also inserts a few necessary read-only checks with superblock instance
where only the ns_writer pointer was used to check if the filesystem is
read-only.

Link: https://syzkaller.appspot.com/bug?id=79a4c002e960419ca173d55e863bd09e8112df8b
Link: https://lkml.kernel.org/r/20221103141759.1836312-1-syoshida@redhat.com [1]
Link: https://lkml.kernel.org/r/20221104142959.28296-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+f816fa82f8783f7a02bb@syzkaller.appspotmail.com
Reported-by: Shigeru Yoshida <syoshida@redhat.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   15 ++++++++-------
 fs/nilfs2/super.c   |    2 --
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/fs/nilfs2/segment.c~nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount
+++ a/fs/nilfs2/segment.c
@@ -317,7 +317,7 @@ void nilfs_relax_pressure_in_lock(struct
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2242,7 +2242,7 @@ int nilfs_construct_segment(struct super
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 	struct nilfs_transaction_info *ti;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2280,7 +2280,7 @@ int nilfs_construct_dsync_segment(struct
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2776,11 +2776,12 @@ int nilfs_attach_log_writer(struct super
 
 	if (nilfs->ns_writer) {
 		/*
-		 * This happens if the filesystem was remounted
-		 * read/write after nilfs_error degenerated it into a
-		 * read-only mount.
+		 * This happens if the filesystem is made read-only by
+		 * __nilfs_error or nilfs_remount and then remounted
+		 * read/write.  In these cases, reuse the existing
+		 * writer.
 		 */
-		nilfs_detach_log_writer(sb);
+		return 0;
 	}
 
 	nilfs->ns_writer = nilfs_segctor_new(sb, root);
--- a/fs/nilfs2/super.c~nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount
+++ a/fs/nilfs2/super.c
@@ -1133,8 +1133,6 @@ static int nilfs_remount(struct super_bl
 	if ((bool)(*flags & SB_RDONLY) == sb_rdonly(sb))
 		goto out;
 	if (*flags & SB_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= SB_RDONLY;
 
 		/*
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-shift-out-of-bounds-overflow-in-nilfs_sb2_bad_offset.patch
nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

