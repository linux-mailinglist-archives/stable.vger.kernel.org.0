Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A4963150B
	for <lists+stable@lfdr.de>; Sun, 20 Nov 2022 16:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiKTPvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Nov 2022 10:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKTPvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Nov 2022 10:51:38 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301E823168
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 07:51:37 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p21so8527577plr.7
        for <stable@vger.kernel.org>; Sun, 20 Nov 2022 07:51:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OD9+pPNecFxKw7m+MIna2uoT2C3uR4joa+ZjFBqxtOg=;
        b=VrnL0EJ/yN6PyR7lOEiAQU2IJj7WO2JTZoDX0AEzJPPSdH6d3o43IE+VsNEGSsXh+7
         gGqdeKn3oO7H3LvCbb11m/GjVcVZygt2Vm9A1PvZEZVsR0pQZ/fOK8Jln3ekEIUlyndq
         l5UmHxCL5oTEfuaNdecjGDVtQBuKI2DZKGDIoWIBAhJRTN6MMQhlk3tTEH2JyxgEoeqZ
         6i0h3X1hJ4HTZiNPimas8pNifJceC8H0zPHlkDZElosFhspceYWfrppjbCbaDw5kyxTS
         4Al5YdKqEqL3EWpxfqWJM6S0k5J5SeMK0khUfksRK+LOx2UnPRVo4uC3UusPnTrpF+OQ
         Gkrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OD9+pPNecFxKw7m+MIna2uoT2C3uR4joa+ZjFBqxtOg=;
        b=bsfY1xQWjx/Jy5/PLLpMFdH+xZQs+PFiJHZvJLEI+xHR/hICDevJrQzZl2/oLx2OTE
         8oLKVar7I02Hr1mHlX7OnPfFoGeol+EgBTo0a/e6T0V2dBhXjM7lWM5lFWedwoc2VafM
         zcYgLMtWGmAr7RX4uva4k9BWbGu7Dnu5BeVpIilnqpiw/zpuYYBBWBryyiGD7eeZEqx9
         72g7WNMJNrQ/eT/X0IVhD0o+Gm+NVtEB1+Xz+iN+iSPvupAb0KI+R0D4jFLXpDkVSOAQ
         KxIBLPsVR+wt2GqEuWdBIBh36BPopsYTWBqD/RWm7gMM2DUdwvREtH6rNMDKkiKcfH6P
         nK2A==
X-Gm-Message-State: ANoB5pnMW7bMVXuuWbNWs7XPJ/0jpmPZFJK02Zc80jIGZBheSk3wGuTv
        VnF+nm5HcjTgrP70fwnViGw=
X-Google-Smtp-Source: AA0mqf7Y2rdi1c8Ty67aLVcYB3TIbm5kY/Z+Dm1CD/MhOZUoJ2pU4Je3p4KpzuzN2dg7sli394RuLQ==
X-Received: by 2002:a17:90a:b78b:b0:218:b258:f5a9 with SMTP id m11-20020a17090ab78b00b00218b258f5a9mr1188380pjr.173.1668959496381;
        Sun, 20 Nov 2022 07:51:36 -0800 (PST)
Received: from carrot.. (i220-108-44-211.s42.a014.ap.plala.or.jp. [220.108.44.211])
        by smtp.gmail.com with ESMTPSA id g8-20020aa79f08000000b0056bc5ad4862sm6823181pfr.28.2022.11.20.07.51.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Nov 2022 07:51:35 -0800 (PST)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14] nilfs2: fix use-after-free bug of ns_writer on remount
Date:   Mon, 21 Nov 2022 00:51:31 +0900
Message-Id: <20221120155131.23814-1-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8cccf05fe857a18ee26e20d11a8455a73ffd4efd upstream.

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
Please apply this patch to stable-4.14 instead of the patch that could
not be applied to it last time.

A rejected hunk has been manually resolved without noticeable change,
and testing against that stable tree was fine.

 fs/nilfs2/segment.c | 15 ++++++++-------
 fs/nilfs2/super.c   |  2 --
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index e5a2b04c77ad..bff7fca4762d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -331,7 +331,7 @@ void nilfs_relax_pressure_in_lock(struct super_block *sb)
 	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct nilfs_sc_info *sci = nilfs->ns_writer;
 
-	if (!sci || !sci->sc_flush_request)
+	if (sb_rdonly(sb) || unlikely(!sci) || !sci->sc_flush_request)
 		return;
 
 	set_bit(NILFS_SC_PRIOR_FLUSH, &sci->sc_flags);
@@ -2256,7 +2256,7 @@ int nilfs_construct_segment(struct super_block *sb)
 	struct nilfs_transaction_info *ti;
 	int err;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	/* A call inside transactions causes a deadlock. */
@@ -2295,7 +2295,7 @@ int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 	struct nilfs_transaction_info ti;
 	int err = 0;
 
-	if (!sci)
+	if (sb_rdonly(sb) || unlikely(!sci))
 		return -EROFS;
 
 	nilfs_transaction_lock(sb, &ti, 0);
@@ -2792,11 +2792,12 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 
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
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index af7d0d5cce50..36e60a45a1bf 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -1148,8 +1148,6 @@ static int nilfs_remount(struct super_block *sb, int *flags, char *data)
 	if ((bool)(*flags & MS_RDONLY) == sb_rdonly(sb))
 		goto out;
 	if (*flags & MS_RDONLY) {
-		/* Shutting down log writer */
-		nilfs_detach_log_writer(sb);
 		sb->s_flags |= MS_RDONLY;
 
 		/*
-- 
2.31.1

