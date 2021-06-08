Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61CDA3A0367
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbhFHTQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238303AbhFHTOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A47206142F;
        Tue,  8 Jun 2021 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178215;
        bh=Eed/U8DmyzBVZwD+d+5trDzBPZJW3qpDqiLz3j0286s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YLkip/J4wOIJmqHZKlrQ5+GblcWrBAv8QJiP4Ht6z/jbGn/Z10T8a6ft9/P94QIoh
         aqZ2vT/rjBAxYo0wPfcwUtojyIEHF7n3XbOuokl5kzUcrlEIDPej2QzVdpSaNTzdQN
         T2NxPad6MSLZ4kUjHSMtVk/IfKPaXiHgT+S6AQ50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.12 118/161] ext4: fix fast commit alignment issues
Date:   Tue,  8 Jun 2021 20:27:28 +0200
Message-Id: <20210608175949.441909939@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

commit a7ba36bc94f20b6c77f16364b9a23f582ea8faac upstream.

Fast commit recovery data on disk may not be aligned. So, when the
recovery code reads it, this patch makes sure that fast commit info
found on-disk is first memcpy-ed into an aligned variable before
accessing it. As a consequence of it, we also remove some macros that
could resulted in unaligned accesses.

Cc: stable@kernel.org
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20210519215920.2037527-1-harshads@google.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |  170 ++++++++++++++++++++++++++------------------------
 fs/ext4/fast_commit.h |   19 -----
 2 files changed, 90 insertions(+), 99 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1288,28 +1288,29 @@ struct dentry_info_args {
 };
 
 static inline void tl_to_darg(struct dentry_info_args *darg,
-				struct  ext4_fc_tl *tl)
+			      struct  ext4_fc_tl *tl, u8 *val)
 {
-	struct ext4_fc_dentry_info *fcd;
+	struct ext4_fc_dentry_info fcd;
 
-	fcd = (struct ext4_fc_dentry_info *)ext4_fc_tag_val(tl);
+	memcpy(&fcd, val, sizeof(fcd));
 
-	darg->parent_ino = le32_to_cpu(fcd->fc_parent_ino);
-	darg->ino = le32_to_cpu(fcd->fc_ino);
-	darg->dname = fcd->fc_dname;
-	darg->dname_len = ext4_fc_tag_len(tl) -
-			sizeof(struct ext4_fc_dentry_info);
+	darg->parent_ino = le32_to_cpu(fcd.fc_parent_ino);
+	darg->ino = le32_to_cpu(fcd.fc_ino);
+	darg->dname = val + offsetof(struct ext4_fc_dentry_info, fc_dname);
+	darg->dname_len = le16_to_cpu(tl->fc_len) -
+		sizeof(struct ext4_fc_dentry_info);
 }
 
 /* Unlink replay function */
-static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl)
+static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
+				 u8 *val)
 {
 	struct inode *inode, *old_parent;
 	struct qstr entry;
 	struct dentry_info_args darg;
 	int ret = 0;
 
-	tl_to_darg(&darg, tl);
+	tl_to_darg(&darg, tl, val);
 
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_UNLINK, darg.ino,
 			darg.parent_ino, darg.dname_len);
@@ -1399,13 +1400,14 @@ out:
 }
 
 /* Link replay function */
-static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl)
+static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
+			       u8 *val)
 {
 	struct inode *inode;
 	struct dentry_info_args darg;
 	int ret = 0;
 
-	tl_to_darg(&darg, tl);
+	tl_to_darg(&darg, tl, val);
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_LINK, darg.ino,
 			darg.parent_ino, darg.dname_len);
 
@@ -1450,9 +1452,10 @@ static int ext4_fc_record_modified_inode
 /*
  * Inode replay function
  */
-static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl)
+static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
+				u8 *val)
 {
-	struct ext4_fc_inode *fc_inode;
+	struct ext4_fc_inode fc_inode;
 	struct ext4_inode *raw_inode;
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
@@ -1460,9 +1463,9 @@ static int ext4_fc_replay_inode(struct s
 	int inode_len, ino, ret, tag = le16_to_cpu(tl->fc_tag);
 	struct ext4_extent_header *eh;
 
-	fc_inode = (struct ext4_fc_inode *)ext4_fc_tag_val(tl);
+	memcpy(&fc_inode, val, sizeof(fc_inode));
 
-	ino = le32_to_cpu(fc_inode->fc_ino);
+	ino = le32_to_cpu(fc_inode.fc_ino);
 	trace_ext4_fc_replay(sb, tag, ino, 0, 0);
 
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
@@ -1474,12 +1477,13 @@ static int ext4_fc_replay_inode(struct s
 
 	ext4_fc_record_modified_inode(sb, ino);
 
-	raw_fc_inode = (struct ext4_inode *)fc_inode->fc_raw_inode;
+	raw_fc_inode = (struct ext4_inode *)
+		(val + offsetof(struct ext4_fc_inode, fc_raw_inode));
 	ret = ext4_get_fc_inode_loc(sb, ino, &iloc);
 	if (ret)
 		goto out;
 
-	inode_len = ext4_fc_tag_len(tl) - sizeof(struct ext4_fc_inode);
+	inode_len = le16_to_cpu(tl->fc_len) - sizeof(struct ext4_fc_inode);
 	raw_inode = ext4_raw_inode(&iloc);
 
 	memcpy(raw_inode, raw_fc_inode, offsetof(struct ext4_inode, i_block));
@@ -1547,14 +1551,15 @@ out:
  * inode for which we are trying to create a dentry here, should already have
  * been replayed before we start here.
  */
-static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl)
+static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
+				 u8 *val)
 {
 	int ret = 0;
 	struct inode *inode = NULL;
 	struct inode *dir = NULL;
 	struct dentry_info_args darg;
 
-	tl_to_darg(&darg, tl);
+	tl_to_darg(&darg, tl, val);
 
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_CREAT, darg.ino,
 			darg.parent_ino, darg.dname_len);
@@ -1633,9 +1638,9 @@ static int ext4_fc_record_regions(struct
 
 /* Replay add range tag */
 static int ext4_fc_replay_add_range(struct super_block *sb,
-				struct ext4_fc_tl *tl)
+				    struct ext4_fc_tl *tl, u8 *val)
 {
-	struct ext4_fc_add_range *fc_add_ex;
+	struct ext4_fc_add_range fc_add_ex;
 	struct ext4_extent newex, *ex;
 	struct inode *inode;
 	ext4_lblk_t start, cur;
@@ -1645,15 +1650,14 @@ static int ext4_fc_replay_add_range(stru
 	struct ext4_ext_path *path = NULL;
 	int ret;
 
-	fc_add_ex = (struct ext4_fc_add_range *)ext4_fc_tag_val(tl);
-	ex = (struct ext4_extent *)&fc_add_ex->fc_ex;
+	memcpy(&fc_add_ex, val, sizeof(fc_add_ex));
+	ex = (struct ext4_extent *)&fc_add_ex.fc_ex;
 
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_ADD_RANGE,
-		le32_to_cpu(fc_add_ex->fc_ino), le32_to_cpu(ex->ee_block),
+		le32_to_cpu(fc_add_ex.fc_ino), le32_to_cpu(ex->ee_block),
 		ext4_ext_get_actual_len(ex));
 
-	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex->fc_ino),
-				EXT4_IGET_NORMAL);
+	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		jbd_debug(1, "Inode not found.");
 		return 0;
@@ -1762,32 +1766,33 @@ next:
 
 /* Replay DEL_RANGE tag */
 static int
-ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl)
+ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
+			 u8 *val)
 {
 	struct inode *inode;
-	struct ext4_fc_del_range *lrange;
+	struct ext4_fc_del_range lrange;
 	struct ext4_map_blocks map;
 	ext4_lblk_t cur, remaining;
 	int ret;
 
-	lrange = (struct ext4_fc_del_range *)ext4_fc_tag_val(tl);
-	cur = le32_to_cpu(lrange->fc_lblk);
-	remaining = le32_to_cpu(lrange->fc_len);
+	memcpy(&lrange, val, sizeof(lrange));
+	cur = le32_to_cpu(lrange.fc_lblk);
+	remaining = le32_to_cpu(lrange.fc_len);
 
 	trace_ext4_fc_replay(sb, EXT4_FC_TAG_DEL_RANGE,
-		le32_to_cpu(lrange->fc_ino), cur, remaining);
+		le32_to_cpu(lrange.fc_ino), cur, remaining);
 
-	inode = ext4_iget(sb, le32_to_cpu(lrange->fc_ino), EXT4_IGET_NORMAL);
+	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange->fc_ino));
+		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange.fc_ino));
 		return 0;
 	}
 
 	ret = ext4_fc_record_modified_inode(sb, inode->i_ino);
 
 	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
-			inode->i_ino, le32_to_cpu(lrange->fc_lblk),
-			le32_to_cpu(lrange->fc_len));
+			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
+			le32_to_cpu(lrange.fc_len));
 	while (remaining > 0) {
 		map.m_lblk = cur;
 		map.m_len = remaining;
@@ -1808,8 +1813,8 @@ ext4_fc_replay_del_range(struct super_bl
 	}
 
 	ret = ext4_punch_hole(inode,
-		le32_to_cpu(lrange->fc_lblk) << sb->s_blocksize_bits,
-		le32_to_cpu(lrange->fc_len) <<  sb->s_blocksize_bits);
+		le32_to_cpu(lrange.fc_lblk) << sb->s_blocksize_bits,
+		le32_to_cpu(lrange.fc_len) <<  sb->s_blocksize_bits);
 	if (ret)
 		jbd_debug(1, "ext4_punch_hole returned %d", ret);
 	ext4_ext_replay_shrink_inode(inode,
@@ -1925,11 +1930,11 @@ static int ext4_fc_replay_scan(journal_t
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_fc_replay_state *state;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
-	struct ext4_fc_add_range *ext;
-	struct ext4_fc_tl *tl;
-	struct ext4_fc_tail *tail;
-	__u8 *start, *end;
-	struct ext4_fc_head *head;
+	struct ext4_fc_add_range ext;
+	struct ext4_fc_tl tl;
+	struct ext4_fc_tail tail;
+	__u8 *start, *end, *cur, *val;
+	struct ext4_fc_head head;
 	struct ext4_extent *ex;
 
 	state = &sbi->s_fc_replay_state;
@@ -1956,15 +1961,17 @@ static int ext4_fc_replay_scan(journal_t
 	}
 
 	state->fc_replay_expected_off++;
-	fc_for_each_tl(start, end, tl) {
+	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
+		memcpy(&tl, cur, sizeof(tl));
+		val = cur + sizeof(tl);
 		jbd_debug(3, "Scan phase, tag:%s, blk %lld\n",
-			  tag2str(le16_to_cpu(tl->fc_tag)), bh->b_blocknr);
-		switch (le16_to_cpu(tl->fc_tag)) {
+			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
+		switch (le16_to_cpu(tl.fc_tag)) {
 		case EXT4_FC_TAG_ADD_RANGE:
-			ext = (struct ext4_fc_add_range *)ext4_fc_tag_val(tl);
-			ex = (struct ext4_extent *)&ext->fc_ex;
+			memcpy(&ext, val, sizeof(ext));
+			ex = (struct ext4_extent *)&ext.fc_ex;
 			ret = ext4_fc_record_regions(sb,
-				le32_to_cpu(ext->fc_ino),
+				le32_to_cpu(ext.fc_ino),
 				le32_to_cpu(ex->ee_block), ext4_ext_pblock(ex),
 				ext4_ext_get_actual_len(ex));
 			if (ret < 0)
@@ -1978,18 +1985,18 @@ static int ext4_fc_replay_scan(journal_t
 		case EXT4_FC_TAG_INODE:
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
-			state->fc_crc = ext4_chksum(sbi, state->fc_crc, tl,
-					sizeof(*tl) + ext4_fc_tag_len(tl));
+			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
+					sizeof(tl) + le16_to_cpu(tl.fc_len));
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
-			tail = (struct ext4_fc_tail *)ext4_fc_tag_val(tl);
-			state->fc_crc = ext4_chksum(sbi, state->fc_crc, tl,
-						sizeof(*tl) +
+			memcpy(&tail, val, sizeof(tail));
+			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
+						sizeof(tl) +
 						offsetof(struct ext4_fc_tail,
 						fc_crc));
-			if (le32_to_cpu(tail->fc_tid) == expected_tid &&
-				le32_to_cpu(tail->fc_crc) == state->fc_crc) {
+			if (le32_to_cpu(tail.fc_tid) == expected_tid &&
+				le32_to_cpu(tail.fc_crc) == state->fc_crc) {
 				state->fc_replay_num_tags = state->fc_cur_tag;
 				state->fc_regions_valid =
 					state->fc_regions_used;
@@ -2000,19 +2007,19 @@ static int ext4_fc_replay_scan(journal_t
 			state->fc_crc = 0;
 			break;
 		case EXT4_FC_TAG_HEAD:
-			head = (struct ext4_fc_head *)ext4_fc_tag_val(tl);
-			if (le32_to_cpu(head->fc_features) &
+			memcpy(&head, val, sizeof(head));
+			if (le32_to_cpu(head.fc_features) &
 				~EXT4_FC_SUPPORTED_FEATURES) {
 				ret = -EOPNOTSUPP;
 				break;
 			}
-			if (le32_to_cpu(head->fc_tid) != expected_tid) {
+			if (le32_to_cpu(head.fc_tid) != expected_tid) {
 				ret = JBD2_FC_REPLAY_STOP;
 				break;
 			}
 			state->fc_cur_tag++;
-			state->fc_crc = ext4_chksum(sbi, state->fc_crc, tl,
-					sizeof(*tl) + ext4_fc_tag_len(tl));
+			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
+					    sizeof(tl) + le16_to_cpu(tl.fc_len));
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2036,11 +2043,11 @@ static int ext4_fc_replay(journal_t *jou
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_fc_tl *tl;
-	__u8 *start, *end;
+	struct ext4_fc_tl tl;
+	__u8 *start, *end, *cur, *val;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_replay_state *state = &sbi->s_fc_replay_state;
-	struct ext4_fc_tail *tail;
+	struct ext4_fc_tail tail;
 
 	if (pass == PASS_SCAN) {
 		state->fc_current_pass = PASS_SCAN;
@@ -2067,49 +2074,52 @@ static int ext4_fc_replay(journal_t *jou
 	start = (u8 *)bh->b_data;
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
-	fc_for_each_tl(start, end, tl) {
+	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
+		memcpy(&tl, cur, sizeof(tl));
+		val = cur + sizeof(tl);
+
 		if (state->fc_replay_num_tags == 0) {
 			ret = JBD2_FC_REPLAY_STOP;
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
 		jbd_debug(3, "Replay phase, tag:%s\n",
-				tag2str(le16_to_cpu(tl->fc_tag)));
+				tag2str(le16_to_cpu(tl.fc_tag)));
 		state->fc_replay_num_tags--;
-		switch (le16_to_cpu(tl->fc_tag)) {
+		switch (le16_to_cpu(tl.fc_tag)) {
 		case EXT4_FC_TAG_LINK:
-			ret = ext4_fc_replay_link(sb, tl);
+			ret = ext4_fc_replay_link(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_UNLINK:
-			ret = ext4_fc_replay_unlink(sb, tl);
+			ret = ext4_fc_replay_unlink(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_ADD_RANGE:
-			ret = ext4_fc_replay_add_range(sb, tl);
+			ret = ext4_fc_replay_add_range(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_CREAT:
-			ret = ext4_fc_replay_create(sb, tl);
+			ret = ext4_fc_replay_create(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_DEL_RANGE:
-			ret = ext4_fc_replay_del_range(sb, tl);
+			ret = ext4_fc_replay_del_range(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_INODE:
-			ret = ext4_fc_replay_inode(sb, tl);
+			ret = ext4_fc_replay_inode(sb, &tl, val);
 			break;
 		case EXT4_FC_TAG_PAD:
 			trace_ext4_fc_replay(sb, EXT4_FC_TAG_PAD, 0,
-				ext4_fc_tag_len(tl), 0);
+					     le16_to_cpu(tl.fc_len), 0);
 			break;
 		case EXT4_FC_TAG_TAIL:
 			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL, 0,
-				ext4_fc_tag_len(tl), 0);
-			tail = (struct ext4_fc_tail *)ext4_fc_tag_val(tl);
-			WARN_ON(le32_to_cpu(tail->fc_tid) != expected_tid);
+					     le16_to_cpu(tl.fc_len), 0);
+			memcpy(&tail, val, sizeof(tail));
+			WARN_ON(le32_to_cpu(tail.fc_tid) != expected_tid);
 			break;
 		case EXT4_FC_TAG_HEAD:
 			break;
 		default:
-			trace_ext4_fc_replay(sb, le16_to_cpu(tl->fc_tag), 0,
-				ext4_fc_tag_len(tl), 0);
+			trace_ext4_fc_replay(sb, le16_to_cpu(tl.fc_tag), 0,
+					     le16_to_cpu(tl.fc_len), 0);
 			ret = -ECANCELED;
 			break;
 		}
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -153,13 +153,6 @@ struct ext4_fc_replay_state {
 #define region_last(__region) (((__region)->lblk) + ((__region)->len) - 1)
 #endif
 
-#define fc_for_each_tl(__start, __end, __tl)				\
-	for (tl = (struct ext4_fc_tl *)(__start);			\
-	     (__u8 *)tl < (__u8 *)(__end);				\
-		tl = (struct ext4_fc_tl *)((__u8 *)tl +			\
-					sizeof(struct ext4_fc_tl) +	\
-					+ le16_to_cpu(tl->fc_len)))
-
 static inline const char *tag2str(__u16 tag)
 {
 	switch (tag) {
@@ -186,16 +179,4 @@ static inline const char *tag2str(__u16
 	}
 }
 
-/* Get length of a particular tlv */
-static inline int ext4_fc_tag_len(struct ext4_fc_tl *tl)
-{
-	return le16_to_cpu(tl->fc_len);
-}
-
-/* Get a pointer to "value" of a tlv */
-static inline __u8 *ext4_fc_tag_val(struct ext4_fc_tl *tl)
-{
-	return (__u8 *)tl + sizeof(*tl);
-}
-
 #endif /* __FAST_COMMIT_H__ */


