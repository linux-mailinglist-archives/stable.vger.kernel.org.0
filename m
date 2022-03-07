Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22444CF6A7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238055AbiCGJms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239842AbiCGJkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE2F74850;
        Mon,  7 Mar 2022 01:36:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F63612EC;
        Mon,  7 Mar 2022 09:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA42C340E9;
        Mon,  7 Mar 2022 09:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645791;
        bh=QPUe18yDHt9ud+Sn6BhZ6z9MBS4enrRlDzVxFjImzZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCCDyjqsExTh5PYZQGtX0uP1Eu/M7eLydTz6PX22/UDwhfeLtZvzKuCzq0svEA5dI
         6rIsedl1O2U3SAkIKM0ubDVh10Rxv5kwrtztAxI077IMMDpQvikBZNyWM/jHjRvRM7
         7iDy8zvX8vKQvxi7TiXpXy3PRsxk+TjLraFFD4C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Xin Yin <yinxin.x@bytedance.com>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/262] ext4: fast commit may not fallback for ineligible commit
Date:   Mon,  7 Mar 2022 10:16:20 +0100
Message-Id: <20220307091703.544901888@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit e85c81ba8859a4c839bcd69c5d83b32954133a5b ]

For the follow scenario:
1. jbd start commit transaction n
2. task A get new handle for transaction n+1
3. task A do some ineligible actions and mark FC_INELIGIBLE
4. jbd complete transaction n and clean FC_INELIGIBLE
5. task A call fsync

In this case fast commit will not fallback to full commit and
transaction n+1 also not handled by jbd.

Make ext4_fc_mark_ineligible() also record transaction tid for
latest ineligible case, when call ext4_fc_cleanup() check
current transaction tid, if small than latest ineligible tid
do not clear the EXT4_MF_FC_INELIGIBLE.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Ritesh Harjani <riteshh@linux.ibm.com>
Suggested-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://lore.kernel.org/r/20220117093655.35160-2-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h        |  3 ++-
 fs/ext4/extents.c     |  4 ++--
 fs/ext4/fast_commit.c | 33 +++++++++++++++++++++++++--------
 fs/ext4/inode.c       |  4 ++--
 fs/ext4/ioctl.c       |  4 ++--
 fs/ext4/namei.c       |  4 ++--
 fs/ext4/super.c       |  1 +
 fs/ext4/xattr.c       |  6 +++---
 fs/jbd2/commit.c      |  2 +-
 fs/jbd2/journal.c     |  2 +-
 include/linux/jbd2.h  |  2 +-
 11 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7448e24cd5459..2b67c7d1677bb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1746,6 +1746,7 @@ struct ext4_sb_info {
 	spinlock_t s_fc_lock;
 	struct buffer_head *s_fc_bh;
 	struct ext4_fc_stats s_fc_stats;
+	tid_t s_fc_ineligible_tid;
 #ifdef CONFIG_EXT4_DEBUG
 	int s_fc_debug_max_replay;
 #endif
@@ -2923,7 +2924,7 @@ void __ext4_fc_track_create(handle_t *handle, struct inode *inode,
 			    struct dentry *dentry);
 void ext4_fc_track_create(handle_t *handle, struct dentry *dentry);
 void ext4_fc_track_inode(handle_t *handle, struct inode *inode);
-void ext4_fc_mark_ineligible(struct super_block *sb, int reason);
+void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handle);
 void ext4_fc_start_update(struct inode *inode);
 void ext4_fc_stop_update(struct inode *inode);
 void ext4_fc_del(struct inode *inode);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c19813402ce98..b81c008e66755 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5340,7 +5340,7 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_discard_preallocations(inode, 0);
@@ -5480,7 +5480,7 @@ static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = PTR_ERR(handle);
 		goto out_mmap;
 	}
-	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_FALLOC_RANGE, handle);
 
 	/* Expand file to avoid data loss if there is error while shifting */
 	inode->i_size += len;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index f8915dff82eee..96fac6ac18f46 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -302,18 +302,32 @@ void ext4_fc_del(struct inode *inode)
 }
 
 /*
- * Mark file system as fast commit ineligible. This means that next commit
- * operation would result in a full jbd2 commit.
+ * Mark file system as fast commit ineligible, and record latest
+ * ineligible transaction tid. This means until the recorded
+ * transaction, commit operation would result in a full jbd2 commit.
  */
-void ext4_fc_mark_ineligible(struct super_block *sb, int reason)
+void ext4_fc_mark_ineligible(struct super_block *sb, int reason, handle_t *handle)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	tid_t tid;
 
 	if (!test_opt2(sb, JOURNAL_FAST_COMMIT) ||
 	    (EXT4_SB(sb)->s_mount_state & EXT4_FC_REPLAY))
 		return;
 
 	ext4_set_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	if (handle && !IS_ERR(handle))
+		tid = handle->h_transaction->t_tid;
+	else {
+		read_lock(&sbi->s_journal->j_state_lock);
+		tid = sbi->s_journal->j_running_transaction ?
+				sbi->s_journal->j_running_transaction->t_tid : 0;
+		read_unlock(&sbi->s_journal->j_state_lock);
+	}
+	spin_lock(&sbi->s_fc_lock);
+	if (sbi->s_fc_ineligible_tid < tid)
+		sbi->s_fc_ineligible_tid = tid;
+	spin_unlock(&sbi->s_fc_lock);
 	WARN_ON(reason >= EXT4_FC_REASON_MAX);
 	sbi->s_fc_stats.fc_ineligible_reason_count[reason]++;
 }
@@ -389,7 +403,7 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	mutex_unlock(&ei->i_fc_lock);
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
@@ -402,7 +416,7 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
 			ext4_fc_mark_ineligible(inode->i_sb,
-				EXT4_FC_REASON_NOMEM);
+				EXT4_FC_REASON_NOMEM, NULL);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -504,7 +518,7 @@ void ext4_fc_track_inode(handle_t *handle, struct inode *inode)
 
 	if (ext4_should_journal_data(inode)) {
 		ext4_fc_mark_ineligible(inode->i_sb,
-					EXT4_FC_REASON_INODE_JOURNAL_DATA);
+					EXT4_FC_REASON_INODE_JOURNAL_DATA, handle);
 		return;
 	}
 
@@ -1180,7 +1194,7 @@ int ext4_fc_commit(journal_t *journal, tid_t commit_tid)
  * Fast commit cleanup routine. This is called after every fast commit and
  * full commit. full is true if we are called after a full commit.
  */
-static void ext4_fc_cleanup(journal_t *journal, int full)
+static void ext4_fc_cleanup(journal_t *journal, int full, tid_t tid)
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1228,7 +1242,10 @@ static void ext4_fc_cleanup(journal_t *journal, int full)
 				&sbi->s_fc_q[FC_Q_MAIN]);
 
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
-	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	if (tid >= sbi->s_fc_ineligible_tid) {
+		sbi->s_fc_ineligible_tid = 0;
+		ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
+	}
 
 	if (full)
 		sbi->s_fc_bytes = 0;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b6746cc86cee3..22a5140546fb6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -337,7 +337,7 @@ void ext4_evict_inode(struct inode *inode)
 	return;
 no_delete:
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
 }
 
@@ -5969,7 +5969,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		return PTR_ERR(handle);
 
 	ext4_fc_mark_ineligible(inode->i_sb,
-		EXT4_FC_REASON_JOURNAL_FLAG_CHANGE);
+		EXT4_FC_REASON_JOURNAL_FLAG_CHANGE, handle);
 	err = ext4_mark_inode_dirty(handle, inode);
 	ext4_handle_sync(handle);
 	ext4_journal_stop(handle);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fd70bebb14370..f61b59045c6d3 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -169,7 +169,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		err = -EINVAL;
 		goto err_out;
 	}
-	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT);
+	ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_SWAP_BOOT, handle);
 
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
@@ -1075,7 +1075,7 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		err = ext4_resize_fs(sb, n_blocks_count);
 		if (EXT4_SB(sb)->s_journal) {
-			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE, NULL);
 			jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 			err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal, 0);
 			jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index da7698341d7d3..192ea90e757cc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3889,7 +3889,7 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		 * dirents in directories.
 		 */
 		ext4_fc_mark_ineligible(old.inode->i_sb,
-			EXT4_FC_REASON_RENAME_DIR);
+			EXT4_FC_REASON_RENAME_DIR, handle);
 	} else {
 		if (new.inode)
 			ext4_fc_track_unlink(handle, new.dentry);
@@ -4049,7 +4049,7 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlikely(retval))
 		goto end_rename;
 	ext4_fc_mark_ineligible(new.inode->i_sb,
-				EXT4_FC_REASON_CROSS_RENAME);
+				EXT4_FC_REASON_CROSS_RENAME, handle);
 	if (old.dir_bh) {
 		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
 		if (retval)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 538a33c3b1176..eb5d55cf277ce 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4620,6 +4620,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_fc_bytes = 0;
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_INELIGIBLE);
 	ext4_clear_mount_flag(sb, EXT4_MF_FC_COMMITTING);
+	sbi->s_fc_ineligible_tid = 0;
 	spin_lock_init(&sbi->s_fc_lock);
 	memset(&sbi->s_fc_stats, 0, sizeof(sbi->s_fc_stats));
 	sbi->s_fc_replay_state.fc_regions = NULL;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 1e0fc1ed845bf..0423253490986 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2408,7 +2408,7 @@ ext4_xattr_set_handle(handle_t *handle, struct inode *inode, int name_index,
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, handle);
 
 cleanup:
 	brelse(is.iloc.bh);
@@ -2486,7 +2486,7 @@ ext4_xattr_set(struct inode *inode, int name_index, const char *name,
 		if (error == 0)
 			error = error2;
 	}
-	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+	ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, NULL);
 
 	return error;
 }
@@ -2920,7 +2920,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 					 error);
 			goto cleanup;
 		}
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR);
+		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_XATTR, handle);
 	}
 	error = 0;
 cleanup:
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 3cc4ab2ba7f4f..d188fa913a075 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -1170,7 +1170,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 	if (journal->j_fc_cleanup_callback)
-		journal->j_fc_cleanup_callback(journal, 1);
+		journal->j_fc_cleanup_callback(journal, 1, commit_transaction->t_tid);
 
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index bd9ac98916043..1f8493ef181d6 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -769,7 +769,7 @@ EXPORT_SYMBOL(jbd2_fc_begin_commit);
 static int __jbd2_fc_end_commit(journal_t *journal, tid_t tid, bool fallback)
 {
 	if (journal->j_fc_cleanup_callback)
-		journal->j_fc_cleanup_callback(journal, 0);
+		journal->j_fc_cleanup_callback(journal, 0, tid);
 	write_lock(&journal->j_state_lock);
 	journal->j_flags &= ~JBD2_FAST_COMMIT_ONGOING;
 	if (fallback)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index fd933c45281af..d63b8106796e2 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1295,7 +1295,7 @@ struct journal_s
 	 * Clean-up after fast commit or full commit. JBD2 calls this function
 	 * after every commit operation.
 	 */
-	void (*j_fc_cleanup_callback)(struct journal_s *journal, int);
+	void (*j_fc_cleanup_callback)(struct journal_s *journal, int full, tid_t tid);
 
 	/**
 	 * @j_fc_replay_callback:
-- 
2.34.1



