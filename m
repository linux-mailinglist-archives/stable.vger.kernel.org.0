Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65E53BCCFE
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhGFLUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhGFLT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FBC561C4E;
        Tue,  6 Jul 2021 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570209;
        bh=TiBS7BZHbAAU14UL2RYcQXFdu19+vSJtSYDvA1SXX7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/MtR9M8saq/+Tm3HXcDb3wJn32BrRfFn45BVOmEFMQe3JlZRbSz8YI53MnDOUxm1
         H8cozQoWI6yNb76niGVR8xV7T1rqwQK2MUdrxwHa9KwDxanGLCHJNDPgLH0HqHMcnz
         AXiihdwSRaRMlT7wMCVwoQF0ZUvCz5XL3pw1Rp50QGJQXayzVM2hafDWtEdJiR+gSD
         aki98ogY3F6jrIk0UPbVnLM+ERC9/rn4mu1s5WlMr1eCYWKlqgeX/H921M3LAqrerY
         +lD5jeucNQYhgTsj1sQ6hJEGUuiqutMwQb5sHeQpObTxwYKc+frNvcpyoEVE9RMw7T
         ijxO0mzyqrOsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+d9e482e303930fa4f6ff@syzkaller.appspotmail.com,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 119/189] ext4: fix memory leak in ext4_fill_super
Date:   Tue,  6 Jul 2021 07:12:59 -0400
Message-Id: <20210706111409.2058071-119-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 618f003199c6188e01472b03cdbba227f1dc5f24 ]

static int kthread(void *_create) will return -ENOMEM
or -EINTR in case of internal failure or
kthread_stop() call happens before threadfn call.

To prevent fancy error checking and make code
more straightforward we moved all cleanup code out
of kmmpd threadfn.

Also, dropped struct mmpd_data at all. Now struct super_block
is a threadfn data and struct buffer_head embedded into
struct ext4_sb_info.

Reported-by: syzbot+d9e482e303930fa4f6ff@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/20210430185046.15742-1-paskripkin@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  4 ++++
 fs/ext4/mmp.c   | 28 +++++++++++++---------------
 fs/ext4/super.c | 10 ++++------
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 37002663d521..a179c0bbc12e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1488,6 +1488,7 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
+	struct buffer_head *s_mmp_bh;
 
 	/* Journaling */
 	struct journal_s *s_journal;
@@ -3720,6 +3721,9 @@ extern struct ext4_io_end_vec *ext4_last_io_end_vec(ext4_io_end_t *io_end);
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
 
+/* mmp.c */
+extern void ext4_stop_mmpd(struct ext4_sb_info *sbi);
+
 /* verity.c */
 extern const struct fsverity_operations ext4_verityops;
 
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index 68fbeedd627b..6cb598b549ca 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -127,9 +127,9 @@ void __dump_mmp_msg(struct super_block *sb, struct mmp_struct *mmp,
  */
 static int kmmpd(void *data)
 {
-	struct super_block *sb = ((struct mmpd_data *) data)->sb;
-	struct buffer_head *bh = ((struct mmpd_data *) data)->bh;
+	struct super_block *sb = (struct super_block *) data;
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct buffer_head *bh = EXT4_SB(sb)->s_mmp_bh;
 	struct mmp_struct *mmp;
 	ext4_fsblk_t mmp_block;
 	u32 seq = 0;
@@ -245,12 +245,18 @@ static int kmmpd(void *data)
 	retval = write_mmp_block(sb, bh);
 
 exit_thread:
-	EXT4_SB(sb)->s_mmp_tsk = NULL;
-	kfree(data);
-	brelse(bh);
 	return retval;
 }
 
+void ext4_stop_mmpd(struct ext4_sb_info *sbi)
+{
+	if (sbi->s_mmp_tsk) {
+		kthread_stop(sbi->s_mmp_tsk);
+		brelse(sbi->s_mmp_bh);
+		sbi->s_mmp_tsk = NULL;
+	}
+}
+
 /*
  * Get a random new sequence number but make sure it is not greater than
  * EXT4_MMP_SEQ_MAX.
@@ -275,7 +281,6 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct buffer_head *bh = NULL;
 	struct mmp_struct *mmp = NULL;
-	struct mmpd_data *mmpd_data;
 	u32 seq;
 	unsigned int mmp_check_interval = le16_to_cpu(es->s_mmp_update_interval);
 	unsigned int wait_time = 0;
@@ -364,24 +369,17 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		goto failed;
 	}
 
-	mmpd_data = kmalloc(sizeof(*mmpd_data), GFP_KERNEL);
-	if (!mmpd_data) {
-		ext4_warning(sb, "not enough memory for mmpd_data");
-		goto failed;
-	}
-	mmpd_data->sb = sb;
-	mmpd_data->bh = bh;
+	EXT4_SB(sb)->s_mmp_bh = bh;
 
 	/*
 	 * Start a kernel thread to update the MMP block periodically.
 	 */
-	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, mmpd_data, "kmmpd-%.*s",
+	EXT4_SB(sb)->s_mmp_tsk = kthread_run(kmmpd, sb, "kmmpd-%.*s",
 					     (int)sizeof(mmp->mmp_bdevname),
 					     bdevname(bh->b_bdev,
 						      mmp->mmp_bdevname));
 	if (IS_ERR(EXT4_SB(sb)->s_mmp_tsk)) {
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
-		kfree(mmpd_data);
 		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
 			     sb->s_id);
 		goto failed;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d29f6aa7d96e..b6fe1a027c78 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1245,8 +1245,8 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
 
-	if (sbi->s_mmp_tsk)
-		kthread_stop(sbi->s_mmp_tsk);
+	ext4_stop_mmpd(sbi);
+
 	brelse(sbi->s_sbh);
 	sb->s_fs_info = NULL;
 	/*
@@ -5186,8 +5186,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 failed_mount3:
 	flush_work(&sbi->s_error_work);
 	del_timer_sync(&sbi->s_err_report);
-	if (sbi->s_mmp_tsk)
-		kthread_stop(sbi->s_mmp_tsk);
+	ext4_stop_mmpd(sbi);
 failed_mount2:
 	rcu_read_lock();
 	group_desc = rcu_dereference(sbi->s_group_desc);
@@ -5989,8 +5988,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				 */
 				ext4_mark_recovery_complete(sb, es);
 			}
-			if (sbi->s_mmp_tsk)
-				kthread_stop(sbi->s_mmp_tsk);
+			ext4_stop_mmpd(sbi);
 		} else {
 			/* Make sure we can mount this feature set readwrite */
 			if (ext4_has_feature_readonly(sb) ||
-- 
2.30.2

