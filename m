Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B890761A2A2
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 21:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiKDUpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 16:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiKDUpx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 16:45:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0262225291;
        Fri,  4 Nov 2022 13:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89E78621D5;
        Fri,  4 Nov 2022 20:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B5CC433C1;
        Fri,  4 Nov 2022 20:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667594751;
        bh=slrI1jYa2p/X5CpFs8jOIT0t0maKyz5B04GSCQTFNCQ=;
        h=Date:To:From:Subject:From;
        b=wk7PqUz9IWmnOB6RszZ1jlAvqaaOmhnJ7kSrNYVrAhzfxmduccGExtdadghnZDPrY
         YRsmTfKCbqFlGKfE0FNpHSlUc4CEBmh5ulb25ppo5NTcS+5CtFC1T7MzSjZnVSAutI
         COoYHyDfwRRqXrt1/j5kCSDrWrq2DYT16hvcZaTY=
Date:   Fri, 04 Nov 2022 13:45:50 -0700
To:     mm-commits@vger.kernel.org, syoshida@redhat.com,
        stable@vger.kernel.org, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch added to mm-hotfixes-unstable branch
Message-Id: <20221104204551.E1B5CC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: fix use-after-free bug of ns_writer on remount
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch

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

nilfs2-fix-deadlock-in-nilfs_count_free_blocks.patch
nilfs2-fix-use-after-free-bug-of-ns_writer-on-remount.patch
nilfs2-fix-shift-out-of-bounds-overflow-in-nilfs_sb2_bad_offset.patch
nilfs2-fix-shift-out-of-bounds-due-to-too-large-exponent-of-block-size.patch

