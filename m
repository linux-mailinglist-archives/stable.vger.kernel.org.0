Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E07765E5DF
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjAEHRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjAEHRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:17:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167E45276E;
        Wed,  4 Jan 2023 23:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6487B618FF;
        Thu,  5 Jan 2023 07:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A631AC433EF;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672903028;
        bh=hPUwFYWj0A7kOhIr3GkylzuNAfDaCWcm9MA3oXycCjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffyo5GjnR5dIsi05cikixB4H9kSeAbyA7Y5BGx/F44Hvk7nmSS2OndNCRdfpZ/erB
         DCozSqhgD2AYwc+6ytWEvIrwkgGla8gCfMKtz7cPOZRbDCE7uOf+K2LDEhrYqNs/O0
         KWY2UKkugPn9YOOHzedpnKCEmF0kRJvhd6kPDpL4rIZbTt3KN5Si/ShYAERMoa7sWp
         kzvUwsopaNZK5mr7Gozz7j8m1k5XizxZiCNV248daUwSGrJmeTeA8w9TzNrqfrfJUz
         Y0IMNBvSBtlrti8UJpUZTWgO8I4l2vJG4zp3WxZNHP9fPUXhvsAjf7+6XUiM00fkM9
         IGl4WW9iNQMOg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5.15 04/10] ext4: factor out ext4_fc_get_tl()
Date:   Wed,  4 Jan 2023 23:13:53 -0800
Message-Id: <20230105071359.257952-5-ebiggers@kernel.org>
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

From: Ye Bin <yebin10@huawei.com>

commit dcc5827484d6e53ccda12334f8bbfafcc593ceda upstream.

Factor out ext4_fc_get_tl() to fill 'tl' with host byte order.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220924075233.2315259-3-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 46 +++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 9b1dedd03be0a..fdce08c68cd43 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1271,7 +1271,7 @@ struct dentry_info_args {
 };
 
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct  ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1280,8 +1280,14 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
 	darg->parent_ino = le32_to_cpu(fcd.fc_parent_ino);
 	darg->ino = le32_to_cpu(fcd.fc_ino);
 	darg->dname = val + offsetof(struct ext4_fc_dentry_info, fc_dname);
-	darg->dname_len = le16_to_cpu(tl->fc_len) -
-		sizeof(struct ext4_fc_dentry_info);
+	darg->dname_len = tl->fc_len - sizeof(struct ext4_fc_dentry_info);
+}
+
+static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
+{
+	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
+	tl->fc_len = le16_to_cpu(tl->fc_len);
+	tl->fc_tag = le16_to_cpu(tl->fc_tag);
 }
 
 /* Unlink replay function */
@@ -1446,7 +1452,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
 	struct ext4_iloc iloc;
-	int inode_len, ino, ret, tag = le16_to_cpu(tl->fc_tag);
+	int inode_len, ino, ret, tag = tl->fc_tag;
 	struct ext4_extent_header *eh;
 
 	memcpy(&fc_inode, val, sizeof(fc_inode));
@@ -1471,7 +1477,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	if (ret)
 		goto out;
 
-	inode_len = le16_to_cpu(tl->fc_len) - sizeof(struct ext4_fc_inode);
+	inode_len = tl->fc_len - sizeof(struct ext4_fc_inode);
 	raw_inode = ext4_raw_inode(&iloc);
 
 	memcpy(raw_inode, raw_fc_inode, offsetof(struct ext4_inode, i_block));
@@ -1958,12 +1964,12 @@ static int ext4_fc_replay_scan(journal_t *journal,
 
 	state->fc_replay_expected_off++;
 	for (cur = start; cur < end;
-	     cur = cur + EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, EXT4_FC_TAG_BASE_LEN);
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
-			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
-		switch (le16_to_cpu(tl.fc_tag)) {
+			   tag2str(tl.fc_tag), bh->b_blocknr);
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_ADD_RANGE:
 			memcpy(&ext, val, sizeof(ext));
 			ex = (struct ext4_extent *)&ext.fc_ex;
@@ -1983,7 +1989,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
@@ -2016,7 +2022,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2072,8 +2078,8 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
 	for (cur = start; cur < end;
-	     cur = cur + EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, EXT4_FC_TAG_BASE_LEN);
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
@@ -2081,10 +2087,9 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
-		ext4_debug("Replay phase, tag:%s\n",
-				tag2str(le16_to_cpu(tl.fc_tag)));
+		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
-		switch (le16_to_cpu(tl.fc_tag)) {
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_LINK:
 			ret = ext4_fc_replay_link(sb, &tl, val);
 			break;
@@ -2105,19 +2110,18 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			break;
 		case EXT4_FC_TAG_PAD:
 			trace_ext4_fc_replay(sb, EXT4_FC_TAG_PAD, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+					     tl.fc_len, 0);
 			break;
 		case EXT4_FC_TAG_TAIL:
-			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL,
+					     0, tl.fc_len, 0);
 			memcpy(&tail, val, sizeof(tail));
 			WARN_ON(le32_to_cpu(tail.fc_tid) != expected_tid);
 			break;
 		case EXT4_FC_TAG_HEAD:
 			break;
 		default:
-			trace_ext4_fc_replay(sb, le16_to_cpu(tl.fc_tag), 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, tl.fc_tag, 0, tl.fc_len, 0);
 			ret = -ECANCELED;
 			break;
 		}
-- 
2.39.0

