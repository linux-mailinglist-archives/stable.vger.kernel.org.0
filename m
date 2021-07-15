Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39ECA3CA9AC
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241588AbhGOTIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242369AbhGOTHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49802613D7;
        Thu, 15 Jul 2021 19:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375801;
        bh=XuDzwAQwpwMH6Rp/TWickEcCg9y6r77JvxH44Ini5Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ljMM8L6Gce29rcD4eZmRpWsAardL4QRAd/KjI/QpEpSVGWA3KoA+07Hgxv9nQ1qhN
         YZZYZy0FfVSgSJ9OwlwhHKa0c0O6B+sSk7jl4w0/DcfUSnl/MD4SFrdRtBEySgeVHX
         5WRsWRW9xrz+/LnuqH1F0eiJPE/1p+Pr+J5Xq0L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d9e482e303930fa4f6ff@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 241/242] ext4: fix memory leak in ext4_fill_super
Date:   Thu, 15 Jul 2021 20:40:03 +0200
Message-Id: <20210715182635.305393881@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 618f003199c6188e01472b03cdbba227f1dc5f24 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    4 ++++
 fs/ext4/mmp.c   |   28 +++++++++++++---------------
 fs/ext4/super.c |   10 ++++------
 3 files changed, 21 insertions(+), 21 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1490,6 +1490,7 @@ struct ext4_sb_info {
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
 	struct super_block *s_sb;
+	struct buffer_head *s_mmp_bh;
 
 	/* Journaling */
 	struct journal_s *s_journal;
@@ -3663,6 +3664,9 @@ extern struct ext4_io_end_vec *ext4_last
 /* mmp.c */
 extern int ext4_multi_mount_protect(struct super_block *, ext4_fsblk_t);
 
+/* mmp.c */
+extern void ext4_stop_mmpd(struct ext4_sb_info *sbi);
+
 /* verity.c */
 extern const struct fsverity_operations ext4_verityops;
 
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -127,9 +127,9 @@ void __dump_mmp_msg(struct super_block *
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
@@ -275,7 +281,6 @@ int ext4_multi_mount_protect(struct supe
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	struct buffer_head *bh = NULL;
 	struct mmp_struct *mmp = NULL;
-	struct mmpd_data *mmpd_data;
 	u32 seq;
 	unsigned int mmp_check_interval = le16_to_cpu(es->s_mmp_update_interval);
 	unsigned int wait_time = 0;
@@ -364,24 +369,17 @@ skip:
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
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1245,8 +1245,8 @@ static void ext4_put_super(struct super_
 	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
 	sbi->s_ea_block_cache = NULL;
 
-	if (sbi->s_mmp_tsk)
-		kthread_stop(sbi->s_mmp_tsk);
+	ext4_stop_mmpd(sbi);
+
 	brelse(sbi->s_sbh);
 	sb->s_fs_info = NULL;
 	/*
@@ -5168,8 +5168,7 @@ failed_mount3a:
 failed_mount3:
 	flush_work(&sbi->s_error_work);
 	del_timer_sync(&sbi->s_err_report);
-	if (sbi->s_mmp_tsk)
-		kthread_stop(sbi->s_mmp_tsk);
+	ext4_stop_mmpd(sbi);
 failed_mount2:
 	rcu_read_lock();
 	group_desc = rcu_dereference(sbi->s_group_desc);
@@ -5967,8 +5966,7 @@ static int ext4_remount(struct super_blo
 				 */
 				ext4_mark_recovery_complete(sb, es);
 			}
-			if (sbi->s_mmp_tsk)
-				kthread_stop(sbi->s_mmp_tsk);
+			ext4_stop_mmpd(sbi);
 		} else {
 			/* Make sure we can mount this feature set readwrite */
 			if (ext4_has_feature_readonly(sb) ||


