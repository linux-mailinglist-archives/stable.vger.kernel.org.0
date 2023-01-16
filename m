Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B104E66C990
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjAPQvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjAPQvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:51:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC6649968
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0FC6B8105D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC2CC433EF;
        Mon, 16 Jan 2023 16:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887013;
        bh=46GmbvqZyfMbBXBFuzoTJ4Dy+5jU9kzM+c/sfcb/2iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EtjCUd+qDLQ582UkI5o2GRanlF5FxACO/DzVg6QZPpa44+4NVDPGYdH+IXfyNRLAt
         x9Awnq8nEVY9sgZNNM7fAuwnh79m+QQqWH0J1SWKKhp3br7+ZOT/rhAmR53gwktn8q
         vXreeUqy7HbPw2Km/Iqr/SAZdf6q86CZGVK1NmfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 617/658] ext4: Provide function to handle transaction restarts
Date:   Mon, 16 Jan 2023 16:51:45 +0100
Message-Id: <20230116154937.721144092@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit a413036791d040e33badcc634453a4d0c0705499 ]

Provide ext4_journal_ensure_credits_fn() function to ensure transaction
has given amount of credits and call helper function to prepare for
restarting a transaction. This allows to remove some boilerplate code
from various places, add proper error handling for the case where
transaction extension or restart fails, and reduces following changes
needed for proper revoke record reservation tracking.

Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-10-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: d87a7b4c77a9 ("jbd2: use the correct print format")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h      |  4 +-
 fs/ext4/ext4_jbd2.c | 11 ++++++
 fs/ext4/ext4_jbd2.h | 48 +++++++++++++++++++++++
 fs/ext4/extents.c   | 68 +++++++++++++++++++-------------
 fs/ext4/indirect.c  | 93 +++++++++++++++++++++++++-------------------
 fs/ext4/inode.c     | 26 -------------
 fs/ext4/migrate.c   | 95 +++++++++++++++++----------------------------
 fs/ext4/resize.c    | 46 +++++-----------------
 fs/ext4/xattr.c     | 90 ++++++++++++++++--------------------------
 9 files changed, 234 insertions(+), 247 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 946804c3c4b1..6017a55b3834 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2634,7 +2634,6 @@ extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
 extern int ext4_break_layouts(struct inode *);
 extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
-extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
 extern void ext4_set_inode_flags(struct inode *);
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
@@ -3327,6 +3326,9 @@ extern int ext4_swap_extents(handle_t *handle, struct inode *inode1,
 			     ext4_lblk_t lblk2,  ext4_lblk_t count,
 			     int mark_unwritten,int *err);
 extern int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu);
+extern int ext4_datasem_ensure_credits(handle_t *handle, struct inode *inode,
+				       int check_cred, int restart_cred);
+
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 7c70b08d104c..2b98d893cda9 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -133,6 +133,17 @@ handle_t *__ext4_journal_start_reserved(handle_t *handle, unsigned int line,
 	return handle;
 }
 
+int __ext4_journal_ensure_credits(handle_t *handle, int check_cred,
+				  int extend_cred)
+{
+	if (!ext4_handle_valid(handle))
+		return 0;
+	if (handle->h_buffer_credits >= check_cred)
+		return 0;
+	return ext4_journal_extend(handle,
+				   extend_cred - handle->h_buffer_credits);
+}
+
 static void ext4_journal_abort_handle(const char *caller, unsigned int line,
 				      const char *err_fn,
 				      struct buffer_head *bh,
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index ef8fcf7d0d3b..481bf770a374 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -346,6 +346,54 @@ static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 	return 0;
 }
 
+int __ext4_journal_ensure_credits(handle_t *handle, int check_cred,
+				  int extend_cred);
+
+
+/*
+ * Ensure @handle has at least @check_creds credits available. If not,
+ * transaction will be extended or restarted to contain at least @extend_cred
+ * credits. Before restarting transaction @fn is executed to allow for cleanup
+ * before the transaction is restarted.
+ *
+ * The return value is < 0 in case of error, 0 in case the handle has enough
+ * credits or transaction extension succeeded, 1 in case transaction had to be
+ * restarted.
+ */
+#define ext4_journal_ensure_credits_fn(handle, check_cred, extend_cred, fn) \
+({									\
+	__label__ __ensure_end;						\
+	int err = __ext4_journal_ensure_credits((handle), (check_cred),	\
+						(extend_cred));		\
+									\
+	if (err <= 0)							\
+		goto __ensure_end;					\
+	err = (fn);							\
+	if (err < 0)							\
+		goto __ensure_end;					\
+	err = ext4_journal_restart((handle), (extend_cred));		\
+	if (err == 0)							\
+		err = 1;						\
+__ensure_end:								\
+	err;								\
+})
+
+/*
+ * Ensure given handle has at least requested amount of credits available,
+ * possibly restarting transaction if needed.
+ */
+static inline int ext4_journal_ensure_credits(handle_t *handle, int credits)
+{
+	return ext4_journal_ensure_credits_fn(handle, credits, credits, 0);
+}
+
+static inline int ext4_journal_ensure_credits_batch(handle_t *handle,
+						    int credits)
+{
+	return ext4_journal_ensure_credits_fn(handle, credits,
+					      EXT4_MAX_TRANS_DATA, 0);
+}
+
 static inline int ext4_journal_blocks_per_page(struct inode *inode)
 {
 	if (EXT4_JOURNAL(inode) != NULL)
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 27760c39f70e..81226addfefe 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -100,29 +100,40 @@ static int ext4_split_extent_at(handle_t *handle,
 static int ext4_find_delayed_extent(struct inode *inode,
 				    struct extent_status *newes);
 
-static int ext4_ext_truncate_extend_restart(handle_t *handle,
-					    struct inode *inode,
-					    int needed)
+static int ext4_ext_trunc_restart_fn(struct inode *inode, int *dropped)
 {
-	int err;
-
-	if (!ext4_handle_valid(handle))
-		return 0;
-	if (handle->h_buffer_credits >= needed)
-		return 0;
 	/*
-	 * If we need to extend the journal get a few extra blocks
-	 * while we're at it for efficiency's sake.
+	 * Drop i_data_sem to avoid deadlock with ext4_map_blocks.  At this
+	 * moment, get_block can be called only for blocks inside i_size since
+	 * page cache has been already dropped and writes are blocked by
+	 * i_mutex. So we can safely drop the i_data_sem here.
 	 */
-	needed += 3;
-	err = ext4_journal_extend(handle, needed - handle->h_buffer_credits);
-	if (err <= 0)
-		return err;
-	err = ext4_truncate_restart_trans(handle, inode, needed);
-	if (err == 0)
-		err = -EAGAIN;
+	BUG_ON(EXT4_JOURNAL(inode) == NULL);
+	ext4_discard_preallocations(inode);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	*dropped = 1;
+	return 0;
+}
 
-	return err;
+/*
+ * Make sure 'handle' has at least 'check_cred' credits. If not, restart
+ * transaction with 'restart_cred' credits. The function drops i_data_sem
+ * when restarting transaction and gets it after transaction is restarted.
+ *
+ * The function returns 0 on success, 1 if transaction had to be restarted,
+ * and < 0 in case of fatal error.
+ */
+int ext4_datasem_ensure_credits(handle_t *handle, struct inode *inode,
+				int check_cred, int restart_cred)
+{
+	int ret;
+	int dropped = 0;
+
+	ret = ext4_journal_ensure_credits_fn(handle, check_cred, restart_cred,
+			ext4_ext_trunc_restart_fn(inode, &dropped));
+	if (dropped)
+		down_write(&EXT4_I(inode)->i_data_sem);
+	return ret;
 }
 
 /*
@@ -2868,9 +2879,13 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		}
 		credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
 
-		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
-		if (err)
+		err = ext4_datasem_ensure_credits(handle, inode, credits,
+						  credits);
+		if (err) {
+			if (err > 0)
+				err = -EAGAIN;
 			goto out;
+		}
 
 		err = ext4_ext_get_access(handle, inode, path + depth);
 		if (err)
@@ -5259,13 +5274,10 @@ ext4_access_path(handle_t *handle, struct inode *inode,
 	 * descriptor) for each block group; assume two block
 	 * groups
 	 */
-	if (handle->h_buffer_credits < 7) {
-		credits = ext4_writepage_trans_blocks(inode);
-		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
-		/* EAGAIN is success */
-		if (err && err != -EAGAIN)
-			return err;
-	}
+	credits = ext4_writepage_trans_blocks(inode);
+	err = ext4_datasem_ensure_credits(handle, inode, 7, credits);
+	if (err < 0)
+		return err;
 
 	err = ext4_ext_get_access(handle, inode, path);
 	return err;
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index a131d2781342..9e13e31a1a22 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -696,27 +696,62 @@ int ext4_ind_trans_blocks(struct inode *inode, int nrblocks)
 	return DIV_ROUND_UP(nrblocks, EXT4_ADDR_PER_BLOCK(inode->i_sb)) + 4;
 }
 
+static int ext4_ind_trunc_restart_fn(handle_t *handle, struct inode *inode,
+				     struct buffer_head *bh, int *dropped)
+{
+	int err;
+
+	if (bh) {
+		BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, inode, bh);
+		if (unlikely(err))
+			return err;
+	}
+	err = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(err))
+		return err;
+	/*
+	 * Drop i_data_sem to avoid deadlock with ext4_map_blocks.  At this
+	 * moment, get_block can be called only for blocks inside i_size since
+	 * page cache has been already dropped and writes are blocked by
+	 * i_mutex. So we can safely drop the i_data_sem here.
+	 */
+	BUG_ON(EXT4_JOURNAL(inode) == NULL);
+	ext4_discard_preallocations(inode);
+	up_write(&EXT4_I(inode)->i_data_sem);
+	*dropped = 1;
+	return 0;
+}
+
 /*
  * Truncate transactions can be complex and absolutely huge.  So we need to
  * be able to restart the transaction at a conventient checkpoint to make
  * sure we don't overflow the journal.
  *
  * Try to extend this transaction for the purposes of truncation.  If
- * extend fails, we need to propagate the failure up and restart the
- * transaction in the top-level truncate loop. --sct
- *
- * Returns 0 if we managed to create more room.  If we can't create more
- * room, and the transaction must be restarted we return 1.
+ * extend fails, we restart transaction.
  */
-static int try_to_extend_transaction(handle_t *handle, struct inode *inode)
+static int ext4_ind_truncate_ensure_credits(handle_t *handle,
+					    struct inode *inode,
+					    struct buffer_head *bh)
 {
-	if (!ext4_handle_valid(handle))
-		return 0;
-	if (ext4_handle_has_enough_credits(handle, EXT4_RESERVE_TRANS_BLOCKS+1))
-		return 0;
-	if (!ext4_journal_extend(handle, ext4_blocks_for_truncate(inode)))
-		return 0;
-	return 1;
+	int ret;
+	int dropped = 0;
+
+	ret = ext4_journal_ensure_credits_fn(handle, EXT4_RESERVE_TRANS_BLOCKS,
+			ext4_blocks_for_truncate(inode),
+			ext4_ind_trunc_restart_fn(handle, inode, bh, &dropped));
+	if (dropped)
+		down_write(&EXT4_I(inode)->i_data_sem);
+	if (ret <= 0)
+		return ret;
+	if (bh) {
+		BUFFER_TRACE(bh, "retaking write access");
+		ret = ext4_journal_get_write_access(handle, bh);
+		if (unlikely(ret))
+			return ret;
+	}
+	return 0;
 }
 
 /*
@@ -851,27 +886,9 @@ static int ext4_clear_blocks(handle_t *handle, struct inode *inode,
 		return 1;
 	}
 
-	if (try_to_extend_transaction(handle, inode)) {
-		if (bh) {
-			BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
-			err = ext4_handle_dirty_metadata(handle, inode, bh);
-			if (unlikely(err))
-				goto out_err;
-		}
-		err = ext4_mark_inode_dirty(handle, inode);
-		if (unlikely(err))
-			goto out_err;
-		err = ext4_truncate_restart_trans(handle, inode,
-					ext4_blocks_for_truncate(inode));
-		if (unlikely(err))
-			goto out_err;
-		if (bh) {
-			BUFFER_TRACE(bh, "retaking write access");
-			err = ext4_journal_get_write_access(handle, bh);
-			if (unlikely(err))
-				goto out_err;
-		}
-	}
+	err = ext4_ind_truncate_ensure_credits(handle, inode, bh);
+	if (err < 0)
+		goto out_err;
 
 	for (p = first; p < last; p++)
 		*p = 0;
@@ -1054,11 +1071,9 @@ static void ext4_free_branches(handle_t *handle, struct inode *inode,
 			 */
 			if (ext4_handle_is_aborted(handle))
 				return;
-			if (try_to_extend_transaction(handle, inode)) {
-				ext4_mark_inode_dirty(handle, inode);
-				ext4_truncate_restart_trans(handle, inode,
-					    ext4_blocks_for_truncate(inode));
-			}
+			if (ext4_ind_truncate_ensure_credits(handle, inode,
+							     NULL) < 0)
+				return;
 
 			/*
 			 * The forget flag here is critical because if
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b38427b8d083..a39567e03580 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -163,32 +163,6 @@ int ext4_inode_is_fast_symlink(struct inode *inode)
 	       (inode->i_size < EXT4_N_BLOCKS * 4);
 }
 
-/*
- * Restart the transaction associated with *handle.  This does a commit,
- * so before we call here everything must be consistently dirtied against
- * this transaction.
- */
-int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
-				 int nblocks)
-{
-	int ret;
-
-	/*
-	 * Drop i_data_sem to avoid deadlock with ext4_map_blocks.  At this
-	 * moment, get_block can be called only for blocks inside i_size since
-	 * page cache has been already dropped and writes are blocked by
-	 * i_mutex. So we can safely drop the i_data_sem here.
-	 */
-	BUG_ON(EXT4_JOURNAL(inode) == NULL);
-	jbd_debug(2, "restarting handle %p\n", handle);
-	up_write(&EXT4_I(inode)->i_data_sem);
-	ret = ext4_journal_restart(handle, nblocks);
-	down_write(&EXT4_I(inode)->i_data_sem);
-	ext4_discard_preallocations(inode);
-
-	return ret;
-}
-
 /*
  * Called at the last iput() if i_nlink is zero.
  */
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index dbba3c3a2f06..6d1243819ab3 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -50,29 +50,9 @@ static int finish_range(handle_t *handle, struct inode *inode,
 	needed = ext4_ext_calc_credits_for_single_extent(inode,
 		    lb->last_block - lb->first_block + 1, path);
 
-	/*
-	 * Make sure the credit we accumalated is not really high
-	 */
-	if (needed && ext4_handle_has_enough_credits(handle,
-						EXT4_RESERVE_TRANS_BLOCKS)) {
-		up_write((&EXT4_I(inode)->i_data_sem));
-		retval = ext4_journal_restart(handle, needed);
-		down_write((&EXT4_I(inode)->i_data_sem));
-		if (retval)
-			goto err_out;
-	} else if (needed) {
-		retval = ext4_journal_extend(handle, needed);
-		if (retval) {
-			/*
-			 * IF not able to extend the journal restart the journal
-			 */
-			up_write((&EXT4_I(inode)->i_data_sem));
-			retval = ext4_journal_restart(handle, needed);
-			down_write((&EXT4_I(inode)->i_data_sem));
-			if (retval)
-				goto err_out;
-		}
-	}
+	retval = ext4_datasem_ensure_credits(handle, inode, needed, needed);
+	if (retval < 0)
+		goto err_out;
 	retval = ext4_ext_insert_extent(handle, inode, &path, &newext, 0);
 err_out:
 	up_write((&EXT4_I(inode)->i_data_sem));
@@ -196,26 +176,6 @@ static int update_tind_extent_range(handle_t *handle, struct inode *inode,
 
 }
 
-static int extend_credit_for_blkdel(handle_t *handle, struct inode *inode)
-{
-	int retval = 0, needed;
-
-	if (ext4_handle_has_enough_credits(handle, EXT4_RESERVE_TRANS_BLOCKS+1))
-		return 0;
-	/*
-	 * We are freeing a blocks. During this we touch
-	 * superblock, group descriptor and block bitmap.
-	 * So allocate a credit of 3. We may update
-	 * quota (user and group).
-	 */
-	needed = 3 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
-
-	if (ext4_journal_extend(handle, needed) != 0)
-		retval = ext4_journal_restart(handle, needed);
-
-	return retval;
-}
-
 static int free_dind_blocks(handle_t *handle,
 				struct inode *inode, __le32 i_data)
 {
@@ -223,6 +183,7 @@ static int free_dind_blocks(handle_t *handle,
 	__le32 *tmp_idata;
 	struct buffer_head *bh;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+	int err;
 
 	bh = ext4_sb_bread(inode->i_sb, le32_to_cpu(i_data), 0);
 	if (IS_ERR(bh))
@@ -231,7 +192,12 @@ static int free_dind_blocks(handle_t *handle,
 	tmp_idata = (__le32 *)bh->b_data;
 	for (i = 0; i < max_entries; i++) {
 		if (tmp_idata[i]) {
-			extend_credit_for_blkdel(handle, inode);
+			err = ext4_journal_ensure_credits(handle,
+						EXT4_RESERVE_TRANS_BLOCKS);
+			if (err < 0) {
+				put_bh(bh);
+				return err;
+			}
 			ext4_free_blocks(handle, inode, NULL,
 					 le32_to_cpu(tmp_idata[i]), 1,
 					 EXT4_FREE_BLOCKS_METADATA |
@@ -239,7 +205,9 @@ static int free_dind_blocks(handle_t *handle,
 		}
 	}
 	put_bh(bh);
-	extend_credit_for_blkdel(handle, inode);
+	err = ext4_journal_ensure_credits(handle, EXT4_RESERVE_TRANS_BLOCKS);
+	if (err < 0)
+		return err;
 	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
 			 EXT4_FREE_BLOCKS_METADATA |
 			 EXT4_FREE_BLOCKS_FORGET);
@@ -270,7 +238,9 @@ static int free_tind_blocks(handle_t *handle,
 		}
 	}
 	put_bh(bh);
-	extend_credit_for_blkdel(handle, inode);
+	retval = ext4_journal_ensure_credits(handle, EXT4_RESERVE_TRANS_BLOCKS);
+	if (retval < 0)
+		return retval;
 	ext4_free_blocks(handle, inode, NULL, le32_to_cpu(i_data), 1,
 			 EXT4_FREE_BLOCKS_METADATA |
 			 EXT4_FREE_BLOCKS_FORGET);
@@ -283,7 +253,10 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
 
 	/* ei->i_data[EXT4_IND_BLOCK] */
 	if (i_data[0]) {
-		extend_credit_for_blkdel(handle, inode);
+		retval = ext4_journal_ensure_credits(handle,
+						     EXT4_RESERVE_TRANS_BLOCKS);
+		if (retval < 0)
+			return retval;
 		ext4_free_blocks(handle, inode, NULL,
 				le32_to_cpu(i_data[0]), 1,
 				 EXT4_FREE_BLOCKS_METADATA |
@@ -318,12 +291,9 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * One credit accounted for writing the
 	 * i_data field of the original inode
 	 */
-	retval = ext4_journal_extend(handle, 1);
-	if (retval) {
-		retval = ext4_journal_restart(handle, 1);
-		if (retval)
-			goto err_out;
-	}
+	retval = ext4_journal_ensure_credits(handle, 1);
+	if (retval < 0)
+		goto err_out;
 
 	i_data[0] = ei->i_data[EXT4_IND_BLOCK];
 	i_data[1] = ei->i_data[EXT4_DIND_BLOCK];
@@ -391,15 +361,19 @@ static int free_ext_idx(handle_t *handle, struct inode *inode,
 		ix = EXT_FIRST_INDEX(eh);
 		for (i = 0; i < le16_to_cpu(eh->eh_entries); i++, ix++) {
 			retval = free_ext_idx(handle, inode, ix);
-			if (retval)
-				break;
+			if (retval) {
+				put_bh(bh);
+				return retval;
+			}
 		}
 	}
 	put_bh(bh);
-	extend_credit_for_blkdel(handle, inode);
+	retval = ext4_journal_ensure_credits(handle, EXT4_RESERVE_TRANS_BLOCKS);
+	if (retval < 0)
+		return retval;
 	ext4_free_blocks(handle, inode, NULL, block, 1,
 			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
-	return retval;
+	return 0;
 }
 
 /*
@@ -578,9 +552,9 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 
 	/* We mark the tmp_inode dirty via ext4_ext_tree_init. */
-	if (ext4_journal_extend(handle, 1) != 0)
-		ext4_journal_restart(handle, 1);
-
+	retval = ext4_journal_ensure_credits(handle, 1);
+	if (retval < 0)
+		goto out_stop;
 	/*
 	 * Mark the tmp_inode as of size zero
 	 */
@@ -599,6 +573,7 @@ int ext4_ext_migrate(struct inode *inode)
 
 	/* Reset the extent details */
 	ext4_ext_tree_init(handle, tmp_inode);
+out_stop:
 	ext4_journal_stop(handle);
 out_tmp_inode:
 	unlock_new_inode(tmp_inode);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 880307ba0f27..44b52921f7f4 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -430,30 +430,6 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 	return bh;
 }
 
-/*
- * If we have fewer than thresh credits, extend by EXT4_MAX_TRANS_DATA.
- * If that fails, restart the transaction & regain write access for the
- * buffer head which is used for block_bitmap modifications.
- */
-static int extend_or_restart_transaction(handle_t *handle, int thresh)
-{
-	int err;
-
-	if (ext4_handle_has_enough_credits(handle, thresh))
-		return 0;
-
-	err = ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA);
-	if (err < 0)
-		return err;
-	if (err) {
-		err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA);
-		if (err)
-			return err;
-	}
-
-	return 0;
-}
-
 /*
  * set_flexbg_block_bitmap() mark clusters [@first_cluster, @last_cluster] used.
  *
@@ -493,8 +469,8 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 			continue;
 		}
 
-		err = extend_or_restart_transaction(handle, 1);
-		if (err)
+		err = ext4_journal_ensure_credits_batch(handle, 1);
+		if (err < 0)
 			return err;
 
 		bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);
@@ -586,8 +562,8 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 			struct buffer_head *gdb;
 
 			ext4_debug("update backup group %#04llx\n", block);
-			err = extend_or_restart_transaction(handle, 1);
-			if (err)
+			err = ext4_journal_ensure_credits_batch(handle, 1);
+			if (err < 0)
 				goto out;
 
 			gdb = sb_getblk(sb, block);
@@ -644,8 +620,8 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 
 		/* Initialize block bitmap of the @group */
 		block = group_data[i].block_bitmap;
-		err = extend_or_restart_transaction(handle, 1);
-		if (err)
+		err = ext4_journal_ensure_credits_batch(handle, 1);
+		if (err < 0)
 			goto out;
 
 		bh = bclean(handle, sb, block);
@@ -673,8 +649,8 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 
 		/* Initialize inode bitmap of the @group */
 		block = group_data[i].inode_bitmap;
-		err = extend_or_restart_transaction(handle, 1);
-		if (err)
+		err = ext4_journal_ensure_credits_batch(handle, 1);
+		if (err < 0)
 			goto out;
 		/* Mark unused entries in inode bitmap used */
 		bh = bclean(handle, sb, block);
@@ -1157,10 +1133,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		ext4_fsblk_t backup_block;
 
 		/* Out of journal space, and can't get more - abort - so sad */
-		if (ext4_handle_valid(handle) &&
-		    handle->h_buffer_credits == 0 &&
-		    ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA) &&
-		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
+		err = ext4_journal_ensure_credits_batch(handle, 1);
+		if (err < 0)
 			break;
 
 		if (meta_bg == 0)
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 78df2d65998e..cf1af6a4a567 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -982,55 +982,6 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 	return credits;
 }
 
-static int ext4_xattr_ensure_credits(handle_t *handle, struct inode *inode,
-				     int credits, struct buffer_head *bh,
-				     bool dirty, bool block_csum)
-{
-	int error;
-
-	if (!ext4_handle_valid(handle))
-		return 0;
-
-	if (handle->h_buffer_credits >= credits)
-		return 0;
-
-	error = ext4_journal_extend(handle, credits - handle->h_buffer_credits);
-	if (!error)
-		return 0;
-	if (error < 0) {
-		ext4_warning(inode->i_sb, "Extend journal (error %d)", error);
-		return error;
-	}
-
-	if (bh && dirty) {
-		if (block_csum)
-			ext4_xattr_block_csum_set(inode, bh);
-		error = ext4_handle_dirty_metadata(handle, NULL, bh);
-		if (error) {
-			ext4_warning(inode->i_sb, "Handle metadata (error %d)",
-				     error);
-			return error;
-		}
-	}
-
-	error = ext4_journal_restart(handle, credits);
-	if (error) {
-		ext4_warning(inode->i_sb, "Restart journal (error %d)", error);
-		return error;
-	}
-
-	if (bh) {
-		error = ext4_journal_get_write_access(handle, bh);
-		if (error) {
-			ext4_warning(inode->i_sb,
-				     "Get write access failed (error %d)",
-				     error);
-			return error;
-		}
-	}
-	return 0;
-}
-
 static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 				       int ref_change)
 {
@@ -1148,6 +1099,24 @@ static int ext4_xattr_inode_inc_ref_all(handle_t *handle, struct inode *parent,
 	return saved_err;
 }
 
+static int ext4_xattr_restart_fn(handle_t *handle, struct inode *inode,
+			struct buffer_head *bh, bool block_csum, bool dirty)
+{
+	int error;
+
+	if (bh && dirty) {
+		if (block_csum)
+			ext4_xattr_block_csum_set(inode, bh);
+		error = ext4_handle_dirty_metadata(handle, NULL, bh);
+		if (error) {
+			ext4_warning(inode->i_sb, "Handle metadata (error %d)",
+				     error);
+			return error;
+		}
+	}
+	return 0;
+}
+
 static void
 ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			     struct buffer_head *bh,
@@ -1184,13 +1153,23 @@ ext4_xattr_inode_dec_ref_all(handle_t *handle, struct inode *parent,
 			continue;
 		}
 
-		err = ext4_xattr_ensure_credits(handle, parent, credits, bh,
-						dirty, block_csum);
-		if (err) {
+		err = ext4_journal_ensure_credits_fn(handle, credits, credits,
+			ext4_xattr_restart_fn(handle, parent, bh, block_csum,
+					      dirty));
+		if (err < 0) {
 			ext4_warning_inode(ea_inode, "Ensure credits err=%d",
 					   err);
 			continue;
 		}
+		if (err > 0) {
+			err = ext4_journal_get_write_access(handle, bh);
+			if (err) {
+				ext4_warning_inode(ea_inode,
+						"Re-get write access err=%d",
+						err);
+				continue;
+			}
+		}
 
 		err = ext4_xattr_inode_dec_ref(handle, ea_inode);
 		if (err) {
@@ -2879,11 +2858,8 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 	struct inode *ea_inode;
 	int error;
 
-	error = ext4_xattr_ensure_credits(handle, inode, extra_credits,
-					  NULL /* bh */,
-					  false /* dirty */,
-					  false /* block_csum */);
-	if (error) {
+	error = ext4_journal_ensure_credits(handle, extra_credits);
+	if (error < 0) {
 		EXT4_ERROR_INODE(inode, "ensure credits (error %d)", error);
 		goto cleanup;
 	}
-- 
2.35.1



