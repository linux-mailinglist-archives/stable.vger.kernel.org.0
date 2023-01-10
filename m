Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA22D664AD3
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbjAJSg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239492AbjAJSfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47156F1E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9551B818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D391C433D2;
        Tue, 10 Jan 2023 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375471;
        bh=IvLYqiMDAcUrjcZJlPCUye2bZIqxVBA2Di+RAV4mSGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xND+AHUdZ74xfNvF4lVjVvg69WOWFV2RM1Ae9qvDJuhAbR6J6+yT7+zkJuBA2N5tw
         9hCUDhj7oB3xEhWk/zjbWEvAPPxu/5yIO+ZLqAusqrkEXidrCHVQiOQx3ztJiAmvwL
         FDqZpeHcP7UoCGta8q1VaBUkZc6gasr4BZFm0TWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 168/290] ext4: use ext4_debug() instead of jbd_debug()
Date:   Tue, 10 Jan 2023 19:04:20 +0100
Message-Id: <20230110180037.709111299@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/balloc.c      |    2 +-
 fs/ext4/ext4_jbd2.c   |    3 +--
 fs/ext4/fast_commit.c |   44 ++++++++++++++++++++++----------------------
 fs/ext4/indirect.c    |    4 ++--
 fs/ext4/inode.c       |    2 +-
 fs/ext4/orphan.c      |   24 ++++++++++++------------
 fs/ext4/super.c       |    2 +-
 7 files changed, 40 insertions(+), 41 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -665,7 +665,7 @@ int ext4_should_retry_alloc(struct super
 	 * it's possible we've just missed a transaction commit here,
 	 * so ignore the returned status
 	 */
-	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
+	ext4_debug("%s: retrying operation after ENOSPC\n", sb->s_id);
 	(void) jbd2_journal_force_commit_nested(sbi->s_journal);
 	return 1;
 }
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -267,8 +267,7 @@ int __ext4_forget(const char *where, uns
 	trace_ext4_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
-	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
-		  "data mode %x\n",
+	ext4_debug("forgetting bh %p: is_metadata=%d, mode %o, data mode %x\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -845,8 +845,8 @@ static int ext4_fc_write_inode_data(stru
 	mutex_unlock(&ei->i_fc_lock);
 
 	cur_lblk_off = old_blk_size;
-	jbd_debug(1, "%s: will try writing %d to %d for inode %ld\n",
-		  __func__, cur_lblk_off, new_blk_size, inode->i_ino);
+	ext4_debug("will try writing %d to %d for inode %ld\n",
+		   cur_lblk_off, new_blk_size, inode->i_ino);
 
 	while (cur_lblk_off <= new_blk_size) {
 		map.m_lblk = cur_lblk_off;
@@ -1101,7 +1101,7 @@ static void ext4_fc_update_stats(struct
 {
 	struct ext4_fc_stats *stats = &EXT4_SB(sb)->s_fc_stats;
 
-	jbd_debug(1, "Fast commit ended with status = %d", status);
+	ext4_debug("Fast commit ended with status = %d", status);
 	if (status == EXT4_FC_STATUS_OK) {
 		stats->fc_num_commits++;
 		stats->fc_numblks += nblks;
@@ -1303,14 +1303,14 @@ static int ext4_fc_replay_unlink(struct
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
@@ -1335,21 +1335,21 @@ static int ext4_fc_replay_link_internal(
 
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
@@ -1362,7 +1362,7 @@ static int ext4_fc_replay_link_internal(
 	 * could complete.
 	 */
 	if (ret && ret != -EEXIST) {
-		jbd_debug(1, "Failed to link\n");
+		ext4_debug("Failed to link\n");
 		goto out;
 	}
 
@@ -1396,7 +1396,7 @@ static int ext4_fc_replay_link(struct su
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1506,7 +1506,7 @@ static int ext4_fc_replay_inode(struct s
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return -EFSCORRUPTED;
 	}
 
@@ -1559,7 +1559,7 @@ static int ext4_fc_replay_create(struct
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "inode %d not found.", darg.ino);
+		ext4_debug("inode %d not found.", darg.ino);
 		inode = NULL;
 		ret = -EINVAL;
 		goto out;
@@ -1572,7 +1572,7 @@ static int ext4_fc_replay_create(struct
 		 */
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
 		if (IS_ERR(dir)) {
-			jbd_debug(1, "Dir %d not found.", darg.ino);
+			ext4_debug("Dir %d not found.", darg.ino);
 			goto out;
 		}
 		ret = ext4_init_new_dir(NULL, dir, inode);
@@ -1660,7 +1660,7 @@ static int ext4_fc_replay_add_range(stru
 
 	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1674,7 +1674,7 @@ static int ext4_fc_replay_add_range(stru
 
 	cur = start;
 	remaining = len;
-	jbd_debug(1, "ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
+	ext4_debug("ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
 		  start, start_pblk, len, ext4_ext_is_unwritten(ex),
 		  inode->i_ino);
 
@@ -1735,7 +1735,7 @@ static int ext4_fc_replay_add_range(stru
 		}
 
 		/* Range is mapped and needs a state change */
-		jbd_debug(1, "Converting from %ld to %d %lld",
+		ext4_debug("Converting from %ld to %d %lld",
 				map.m_flags & EXT4_MAP_UNWRITTEN,
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
@@ -1778,7 +1778,7 @@ ext4_fc_replay_del_range(struct super_bl
 
 	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange.fc_ino));
+		ext4_debug("Inode %d not found", le32_to_cpu(lrange.fc_ino));
 		return 0;
 	}
 
@@ -1786,7 +1786,7 @@ ext4_fc_replay_del_range(struct super_bl
 	if (ret)
 		goto out;
 
-	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
+	ext4_debug("DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
 			le32_to_cpu(lrange.fc_len));
 	while (remaining > 0) {
@@ -1835,7 +1835,7 @@ static void ext4_fc_set_bitmaps_and_coun
 		inode = ext4_iget(sb, state->fc_modified_inodes[i],
 			EXT4_IGET_NORMAL);
 		if (IS_ERR(inode)) {
-			jbd_debug(1, "Inode %d not found.",
+			ext4_debug("Inode %d not found.",
 				state->fc_modified_inodes[i]);
 			continue;
 		}
@@ -1960,7 +1960,7 @@ static int ext4_fc_replay_scan(journal_t
 	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
 		memcpy(&tl, cur, sizeof(tl));
 		val = cur + sizeof(tl);
-		jbd_debug(3, "Scan phase, tag:%s, blk %lld\n",
+		ext4_debug("Scan phase, tag:%s, blk %lld\n",
 			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
 		switch (le16_to_cpu(tl.fc_tag)) {
 		case EXT4_FC_TAG_ADD_RANGE:
@@ -2055,7 +2055,7 @@ static int ext4_fc_replay(journal_t *jou
 		sbi->s_mount_state |= EXT4_FC_REPLAY;
 	}
 	if (!sbi->s_fc_replay_state.fc_replay_num_tags) {
-		jbd_debug(1, "Replay stops\n");
+		ext4_debug("Replay stops\n");
 		ext4_fc_set_bitmaps_and_counters(sb);
 		return 0;
 	}
@@ -2079,7 +2079,7 @@ static int ext4_fc_replay(journal_t *jou
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
-		jbd_debug(3, "Replay phase, tag:%s\n",
+		ext4_debug("Replay phase, tag:%s\n",
 				tag2str(le16_to_cpu(tl.fc_tag)));
 		state->fc_replay_num_tags--;
 		switch (le16_to_cpu(tl.fc_tag)) {
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -467,7 +467,7 @@ static int ext4_splice_branch(handle_t *
 		 * the new i_size.  But that is not done here - it is done in
 		 * generic_commit_write->__mark_inode_dirty->ext4_dirty_inode.
 		 */
-		jbd_debug(5, "splicing indirect only\n");
+		ext4_debug("splicing indirect only\n");
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
 		err = ext4_handle_dirty_metadata(handle, ar->inode, where->bh);
 		if (err)
@@ -479,7 +479,7 @@ static int ext4_splice_branch(handle_t *
 		err = ext4_mark_inode_dirty(handle, ar->inode);
 		if (unlikely(err))
 			goto err_out;
-		jbd_debug(5, "splicing direct\n");
+		ext4_debug("splicing direct\n");
 	}
 	return err;
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5220,7 +5220,7 @@ int ext4_write_inode(struct inode *inode
 
 	if (EXT4_SB(inode->i_sb)->s_journal) {
 		if (ext4_journal_current_handle()) {
-			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
+			ext4_debug("called recursively, non-PF_MEMALLOC!\n");
 			dump_stack();
 			return -EIO;
 		}
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -181,8 +181,8 @@ int ext4_orphan_add(handle_t *handle, st
 	} else
 		brelse(iloc.bh);
 
-	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
-	jbd_debug(4, "orphan inode %lu will point to %d\n",
+	ext4_debug("superblock will point to %lu\n", inode->i_ino);
+	ext4_debug("orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
 out:
 	ext4_std_error(sb, err);
@@ -251,7 +251,7 @@ int ext4_orphan_del(handle_t *handle, st
 	}
 
 	mutex_lock(&sbi->s_orphan_lock);
-	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+	ext4_debug("remove inode %lu from orphan list\n", inode->i_ino);
 
 	prev = ei->i_orphan.prev;
 	list_del_init(&ei->i_orphan);
@@ -267,7 +267,7 @@ int ext4_orphan_del(handle_t *handle, st
 
 	ino_next = NEXT_ORPHAN(inode);
 	if (prev == &sbi->s_orphan) {
-		jbd_debug(4, "superblock will point to %u\n", ino_next);
+		ext4_debug("superblock will point to %u\n", ino_next);
 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, inode->i_sb,
 						    sbi->s_sbh, EXT4_JTR_NONE);
@@ -286,7 +286,7 @@ int ext4_orphan_del(handle_t *handle, st
 		struct inode *i_prev =
 			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
 
-		jbd_debug(4, "orphan inode %lu will point to %u\n",
+		ext4_debug("orphan inode %lu will point to %u\n",
 			  i_prev->i_ino, ino_next);
 		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
 		if (err) {
@@ -332,8 +332,8 @@ static void ext4_process_orphan(struct i
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
@@ -353,8 +353,8 @@ static void ext4_process_orphan(struct i
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
@@ -391,7 +391,7 @@ void ext4_orphan_cleanup(struct super_bl
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
 	if (!es->s_last_orphan && !oi->of_blocks) {
-		jbd_debug(4, "no orphan inodes to clean up\n");
+		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
 
@@ -415,7 +415,7 @@ void ext4_orphan_cleanup(struct super_bl
 				  "clearing orphan list.");
 			es->s_last_orphan = 0;
 		}
-		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+		ext4_debug("Skipping orphan recovery on fs with errors.\n");
 		return;
 	}
 
@@ -459,7 +459,7 @@ void ext4_orphan_cleanup(struct super_bl
 		 * so, skip the rest.
 		 */
 		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-			jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+			ext4_debug("Skipping orphan recovery on fs with errors.\n");
 			es->s_last_orphan = 0;
 			break;
 		}
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5154,7 +5154,7 @@ static struct inode *ext4_get_journal_in
 		return NULL;
 	}
 
-	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
+	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
 	if (!S_ISREG(journal_inode->i_mode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");


