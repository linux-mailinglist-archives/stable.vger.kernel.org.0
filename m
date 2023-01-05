Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF85065E5DC
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjAEHRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbjAEHRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:17:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B095276F;
        Wed,  4 Jan 2023 23:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6199618F3;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB95C433F1;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672903028;
        bh=UrAy6pnOCiTeyJ2ivrlCRX/cAEO2z2ZdyXYMphjg5cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BlSfIH2adFlzojbZRHQwvKsM42AyQIHc278mkBLAgZM5e2OKVZOoKHYbgqjHmqh9d
         0Q3GU/LYHAulSUPiu/hqHTjxhAII47oReuN2jDrMUyY3BgUuavh+PPaLQlVgxBIA0T
         8yhz4IjRl3KVl5E6u192fbtq0LQBj6A4j5E5OlCch8W1P009uk1yUPUYluUgoRFPMH
         hfhbPtDrS+PYqJ8RMoE+ER+rVKz/BWcaHYiTSVJlbgHA0Y/aZi3ZIj9dXvyVyw73py
         QDUB/0rpZFE3+liClLWzPyMq9o6YPXg76HWaA2td7qfbIRUuvelzyCwQJYsMdL7EyU
         MJywJKYdmfvJA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5.15 02/10] ext4: use ext4_debug() instead of jbd_debug()
Date:   Wed,  4 Jan 2023 23:13:51 -0800
Message-Id: <20230105071359.257952-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105071359.257952-1-ebiggers@kernel.org>
References: <20230105071359.257952-1-ebiggers@kernel.org>
MIME-Version: 1.0
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

commit 4978c659e7b5c1926cdb4b556e4ca1fd2de8ad42 upstream.

We use jbd_debug() in some places in ext4. It seems a bit strange to use
jbd2 debugging output function for ext4 code. Also these days
ext4_debug() uses dynamic printk so each debug message can be enabled /
disabled on its own so the time when it made some sense to have these
combined (to allow easier common selecting of messages to report) has
passed. Just convert all jbd_debug() uses in ext4 to ext4_debug().

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Link: https://lore.kernel.org/r/20220608112355.4397-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/balloc.c      |  2 +-
 fs/ext4/ext4_jbd2.c   |  3 +--
 fs/ext4/fast_commit.c | 44 +++++++++++++++++++++----------------------
 fs/ext4/indirect.c    |  4 ++--
 fs/ext4/inode.c       |  2 +-
 fs/ext4/orphan.c      | 24 +++++++++++------------
 fs/ext4/super.c       |  2 +-
 7 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a0fb0c4bdc7cd..f9a79053f03ad 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -665,7 +665,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 	 * it's possible we've just missed a transaction commit here,
 	 * so ignore the returned status
 	 */
-	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
+	ext4_debug("%s: retrying operation after ENOSPC\n", sb->s_id);
 	(void) jbd2_journal_force_commit_nested(sbi->s_journal);
 	return 1;
 }
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 3477a16d08aee..8e1fb18f465ea 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -267,8 +267,7 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 	trace_ext4_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
-	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
-		  "data mode %x\n",
+	ext4_debug("forgetting bh %p: is_metadata=%d, mode %o, data mode %x\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 27854cf0444e2..b16fe6ae9852f 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -845,8 +845,8 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 	mutex_unlock(&ei->i_fc_lock);
 
 	cur_lblk_off = old_blk_size;
-	jbd_debug(1, "%s: will try writing %d to %d for inode %ld\n",
-		  __func__, cur_lblk_off, new_blk_size, inode->i_ino);
+	ext4_debug("will try writing %d to %d for inode %ld\n",
+		   cur_lblk_off, new_blk_size, inode->i_ino);
 
 	while (cur_lblk_off <= new_blk_size) {
 		map.m_lblk = cur_lblk_off;
@@ -1101,7 +1101,7 @@ static void ext4_fc_update_stats(struct super_block *sb, int status,
 {
 	struct ext4_fc_stats *stats = &EXT4_SB(sb)->s_fc_stats;
 
-	jbd_debug(1, "Fast commit ended with status = %d", status);
+	ext4_debug("Fast commit ended with status = %d", status);
 	if (status == EXT4_FC_STATUS_OK) {
 		stats->fc_num_commits++;
 		stats->fc_numblks += nblks;
@@ -1303,14 +1303,14 @@ static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", darg.ino);
+		ext4_debug("Inode %d not found", darg.ino);
 		return 0;
 	}
 
 	old_parent = ext4_iget(sb, darg.parent_ino,
 				EXT4_IGET_NORMAL);
 	if (IS_ERR(old_parent)) {
-		jbd_debug(1, "Dir with inode  %d not found", darg.parent_ino);
+		ext4_debug("Dir with inode %d not found", darg.parent_ino);
 		iput(inode);
 		return 0;
 	}
@@ -1335,21 +1335,21 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 
 	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(dir)) {
-		jbd_debug(1, "Dir with inode %d not found.", darg->parent_ino);
+		ext4_debug("Dir with inode %d not found.", darg->parent_ino);
 		dir = NULL;
 		goto out;
 	}
 
 	dentry_dir = d_obtain_alias(dir);
 	if (IS_ERR(dentry_dir)) {
-		jbd_debug(1, "Failed to obtain dentry");
+		ext4_debug("Failed to obtain dentry");
 		dentry_dir = NULL;
 		goto out;
 	}
 
 	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
 	if (!dentry_inode) {
-		jbd_debug(1, "Inode dentry not created.");
+		ext4_debug("Inode dentry not created.");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1362,7 +1362,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 	 * could complete.
 	 */
 	if (ret && ret != -EEXIST) {
-		jbd_debug(1, "Failed to link\n");
+		ext4_debug("Failed to link\n");
 		goto out;
 	}
 
@@ -1396,7 +1396,7 @@ static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1506,7 +1506,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return -EFSCORRUPTED;
 	}
 
@@ -1559,7 +1559,7 @@ static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "inode %d not found.", darg.ino);
+		ext4_debug("inode %d not found.", darg.ino);
 		inode = NULL;
 		ret = -EINVAL;
 		goto out;
@@ -1572,7 +1572,7 @@ static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
 		 */
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
 		if (IS_ERR(dir)) {
-			jbd_debug(1, "Dir %d not found.", darg.ino);
+			ext4_debug("Dir %d not found.", darg.ino);
 			goto out;
 		}
 		ret = ext4_init_new_dir(NULL, dir, inode);
@@ -1660,7 +1660,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1674,7 +1674,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 	cur = start;
 	remaining = len;
-	jbd_debug(1, "ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
+	ext4_debug("ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
 		  start, start_pblk, len, ext4_ext_is_unwritten(ex),
 		  inode->i_ino);
 
@@ -1735,7 +1735,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 		}
 
 		/* Range is mapped and needs a state change */
-		jbd_debug(1, "Converting from %ld to %d %lld",
+		ext4_debug("Converting from %ld to %d %lld",
 				map.m_flags & EXT4_MAP_UNWRITTEN,
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
@@ -1778,7 +1778,7 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange.fc_ino));
+		ext4_debug("Inode %d not found", le32_to_cpu(lrange.fc_ino));
 		return 0;
 	}
 
@@ -1786,7 +1786,7 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 	if (ret)
 		goto out;
 
-	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
+	ext4_debug("DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
 			le32_to_cpu(lrange.fc_len));
 	while (remaining > 0) {
@@ -1835,7 +1835,7 @@ static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 		inode = ext4_iget(sb, state->fc_modified_inodes[i],
 			EXT4_IGET_NORMAL);
 		if (IS_ERR(inode)) {
-			jbd_debug(1, "Inode %d not found.",
+			ext4_debug("Inode %d not found.",
 				state->fc_modified_inodes[i]);
 			continue;
 		}
@@ -1960,7 +1960,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
 		memcpy(&tl, cur, sizeof(tl));
 		val = cur + sizeof(tl);
-		jbd_debug(3, "Scan phase, tag:%s, blk %lld\n",
+		ext4_debug("Scan phase, tag:%s, blk %lld\n",
 			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
 		switch (le16_to_cpu(tl.fc_tag)) {
 		case EXT4_FC_TAG_ADD_RANGE:
@@ -2055,7 +2055,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 		sbi->s_mount_state |= EXT4_FC_REPLAY;
 	}
 	if (!sbi->s_fc_replay_state.fc_replay_num_tags) {
-		jbd_debug(1, "Replay stops\n");
+		ext4_debug("Replay stops\n");
 		ext4_fc_set_bitmaps_and_counters(sb);
 		return 0;
 	}
@@ -2079,7 +2079,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
-		jbd_debug(3, "Replay phase, tag:%s\n",
+		ext4_debug("Replay phase, tag:%s\n",
 				tag2str(le16_to_cpu(tl.fc_tag)));
 		state->fc_replay_num_tags--;
 		switch (le16_to_cpu(tl.fc_tag)) {
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index f48b3a868e061..9813cc4b7b2a9 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -467,7 +467,7 @@ static int ext4_splice_branch(handle_t *handle,
 		 * the new i_size.  But that is not done here - it is done in
 		 * generic_commit_write->__mark_inode_dirty->ext4_dirty_inode.
 		 */
-		jbd_debug(5, "splicing indirect only\n");
+		ext4_debug("splicing indirect only\n");
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
 		err = ext4_handle_dirty_metadata(handle, ar->inode, where->bh);
 		if (err)
@@ -479,7 +479,7 @@ static int ext4_splice_branch(handle_t *handle,
 		err = ext4_mark_inode_dirty(handle, ar->inode);
 		if (unlikely(err))
 			goto err_out;
-		jbd_debug(5, "splicing direct\n");
+		ext4_debug("splicing direct\n");
 	}
 	return err;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c59a694b67e1e..0a63863bc58c1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5220,7 +5220,7 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (EXT4_SB(inode->i_sb)->s_journal) {
 		if (ext4_journal_current_handle()) {
-			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
+			ext4_debug("called recursively, non-PF_MEMALLOC!\n");
 			dump_stack();
 			return -EIO;
 		}
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 1ce257a19fe45..c26c404ac58bf 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -181,8 +181,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	} else
 		brelse(iloc.bh);
 
-	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
-	jbd_debug(4, "orphan inode %lu will point to %d\n",
+	ext4_debug("superblock will point to %lu\n", inode->i_ino);
+	ext4_debug("orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
 out:
 	ext4_std_error(sb, err);
@@ -251,7 +251,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	}
 
 	mutex_lock(&sbi->s_orphan_lock);
-	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+	ext4_debug("remove inode %lu from orphan list\n", inode->i_ino);
 
 	prev = ei->i_orphan.prev;
 	list_del_init(&ei->i_orphan);
@@ -267,7 +267,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 
 	ino_next = NEXT_ORPHAN(inode);
 	if (prev == &sbi->s_orphan) {
-		jbd_debug(4, "superblock will point to %u\n", ino_next);
+		ext4_debug("superblock will point to %u\n", ino_next);
 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, inode->i_sb,
 						    sbi->s_sbh, EXT4_JTR_NONE);
@@ -286,7 +286,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		struct inode *i_prev =
 			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
 
-		jbd_debug(4, "orphan inode %lu will point to %u\n",
+		ext4_debug("orphan inode %lu will point to %u\n",
 			  i_prev->i_ino, ino_next);
 		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
 		if (err) {
@@ -332,8 +332,8 @@ static void ext4_process_orphan(struct inode *inode,
 			ext4_msg(sb, KERN_DEBUG,
 				"%s: truncating inode %lu to %lld bytes",
 				__func__, inode->i_ino, inode->i_size);
-		jbd_debug(2, "truncating inode %lu to %lld bytes\n",
-			  inode->i_ino, inode->i_size);
+		ext4_debug("truncating inode %lu to %lld bytes\n",
+			   inode->i_ino, inode->i_size);
 		inode_lock(inode);
 		truncate_inode_pages(inode->i_mapping, inode->i_size);
 		ret = ext4_truncate(inode);
@@ -353,8 +353,8 @@ static void ext4_process_orphan(struct inode *inode,
 			ext4_msg(sb, KERN_DEBUG,
 				"%s: deleting unreferenced inode %lu",
 				__func__, inode->i_ino);
-		jbd_debug(2, "deleting unreferenced inode %lu\n",
-			  inode->i_ino);
+		ext4_debug("deleting unreferenced inode %lu\n",
+			   inode->i_ino);
 		(*nr_orphans)++;
 	}
 	iput(inode);  /* The delete magic happens here! */
@@ -391,7 +391,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
 	if (!es->s_last_orphan && !oi->of_blocks) {
-		jbd_debug(4, "no orphan inodes to clean up\n");
+		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
 
@@ -415,7 +415,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 				  "clearing orphan list.");
 			es->s_last_orphan = 0;
 		}
-		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+		ext4_debug("Skipping orphan recovery on fs with errors.\n");
 		return;
 	}
 
@@ -459,7 +459,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		 * so, skip the rest.
 		 */
 		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-			jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+			ext4_debug("Skipping orphan recovery on fs with errors.\n");
 			es->s_last_orphan = 0;
 			break;
 		}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index beb8a888cf8f6..cdc2b1e6aa41a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5154,7 +5154,7 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 		return NULL;
 	}
 
-	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
+	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	if (!S_ISREG(journal_inode->i_mode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
-- 
2.39.0

