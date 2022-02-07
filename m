Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1914E4AB665
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 09:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237809AbiBGINW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 03:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347992AbiBGII6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 03:08:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A88EC043181
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 00:08:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB48060FC8
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 08:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A65C004E1;
        Mon,  7 Feb 2022 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644221337;
        bh=OuZH+hd798q+NQeZmH72wjLK7jbkkRfu0I1dgKt1icQ=;
        h=Subject:To:Cc:From:Date:From;
        b=2CFl/aNkD+rkik86Px3kh6g9ZHp1DKxvCw7WB+5otDTQRLyXK5y+QwFCwHdUuXca+
         UiyWiw6E1kpKQWzfeIiuko/PJybRSQIM+vw+I3vxIuY1RuocskoYu4OrreFZZqTyaC
         7WE0Z2tCotBDFh2cVZClGFfX7wkn4XqykZQtn7L4=
Subject: FAILED: patch "[PATCH] ext4: fast commit may miss file actions" failed to apply to 5.16-stable tree
To:     yinxin.x@bytedance.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Feb 2022 09:08:46 +0100
Message-ID: <16442213269758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bdc8a53a6f2f0b1cb5f991440f2100732299eb93 Mon Sep 17 00:00:00 2001
From: Xin Yin <yinxin.x@bytedance.com>
Date: Mon, 17 Jan 2022 17:36:55 +0800
Subject: [PATCH] ext4: fast commit may miss file actions

in the follow scenario:
1. jbd start transaction n
2. task A get new handle for transaction n+1
3. task A do some actions and add inode to FC_Q_MAIN fc_q
4. jbd complete transaction n and clear FC_Q_MAIN fc_q
5. task A call fsync

Fast commit will lost the file actions during a full commit.

we should also add updates to staging queue during a full commit.
and in ext4_fc_cleanup(), when reset a inode's fc track range, check
it's i_sync_tid, if it bigger than current transaction tid, do not
rest it, or we will lost the track range.

And EXT4_MF_FC_COMMITTING is not needed anymore, so drop it.

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://lore.kernel.org/r/20220117093655.35160-3-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d52295becda3..18cd5b3b4815 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1795,10 +1795,7 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 enum {
 	EXT4_MF_MNTDIR_SAMPLED,
 	EXT4_MF_FS_ABORTED,	/* Fatal error detected */
-	EXT4_MF_FC_INELIGIBLE,	/* Fast commit ineligible */
-	EXT4_MF_FC_COMMITTING	/* File system underoing a fast
-				 * commit.
-				 */
+	EXT4_MF_FC_INELIGIBLE	/* Fast commit ineligible */
 };
 
 static inline void ext4_set_mount_flag(struct super_block *sb, int bit)
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index e031afee42de..ccd2b216d6ba 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -375,7 +375,8 @@ static int ext4_fc_track_template(
 	spin_lock(&sbi->s_fc_lock);
 	if (list_empty(&EXT4_I(inode)->i_fc_list))
 		list_add_tail(&EXT4_I(inode)->i_fc_list,
-				(ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_COMMITTING)) ?
+				(sbi->s_journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
+				 sbi->s_journal->j_flags & JBD2_FAST_COMMIT_ONGOING) ?
 				&sbi->s_fc_q[FC_Q_STAGING] :
 				&sbi->s_fc_q[FC_Q_MAIN]);
 	spin_unlock(&sbi->s_fc_lock);
@@ -428,7 +429,8 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	node->fcd_name.len = dentry->d_name.len;
 
 	spin_lock(&sbi->s_fc_lock);
-	if (ext4_test_mount_flag(inode->i_sb, EXT4_MF_FC_COMMITTING))
+	if (sbi->s_journal->j_flags & JBD2_FULL_COMMIT_ONGOING ||
+		sbi->s_journal->j_flags & JBD2_FAST_COMMIT_ONGOING)
 		list_add_tail(&node->fcd_list,
 				&sbi->s_fc_dentry_q[FC_Q_STAGING]);
 	else
@@ -893,7 +895,6 @@ static int ext4_fc_submit_inode_data_all(journal_t *journal)
 	int ret = 0;
 
 	spin_lock(&sbi->s_fc_lock);
-	ext4_set_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	list_for_each_entry(ei, &sbi->s_fc_q[FC_Q_MAIN], i_fc_list) {
 		ext4_set_inode_state(&ei->vfs_inode, EXT4_STATE_FC_COMMITTING);
 		while (atomic_read(&ei->i_fc_updates)) {
@@ -1211,7 +1212,8 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 		list_del_init(&iter->i_fc_list);
 		ext4_clear_inode_state(&iter->vfs_inode,
 				       EXT4_STATE_FC_COMMITTING);
-		ext4_fc_reset_inode(&iter->vfs_inode);
+		if (iter->i_sync_tid <= tid)
+			ext4_fc_reset_inode(&iter->vfs_inode);
 		/* Make sure EXT4_STATE_FC_COMMITTING bit is clear */
 		smp_mb();
 #if (BITS_PER_LONG < 64)
@@ -1240,7 +1242,6 @@ static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 	list_splice_init(&sbi->s_fc_q[FC_Q_STAGING],
 				&sbi->s_fc_q[FC_Q_MAIN]);
 
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	if (tid >= sbi->s_fc_ineligible_tid) {
 		sbi->s_fc_ineligible_tid = 0;
 		ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6930b7737ce4..57914acc5402 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5083,7 +5083,6 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	INIT_LIST_HEAD(&sbi->s_fc_dentry_q[FC_Q_STAGING]);
 	sbi->s_fc_bytes = 0;
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
 	sbi->s_fc_ineligible_tid = 0;
 	spin_lock_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));

