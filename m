Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BD664AD6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbjAJSgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbjAJSfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DA454DBC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:31:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 898DCB81905
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4481C433EF;
        Tue, 10 Jan 2023 18:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375477;
        bh=QACbFCJd4t+Gb42iKf/qn3OgeQvXxzfYJCI8ir+8mZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ageYkp2FPlRB9zUSi4st8+DC4q7EYH1nOK9wunQjQG2Hl3DcgHyjA9ef/35DQKwTx
         +STFzpF6+cw5vfaWeuC7e1q97vAzC/3Z+y6j3MSLNvfS+Wwr9OmIv1kfXJ7Qc5aDeR
         ey1/k/3H19nNqcrNinx1zZNpguLHLRjiFDq/U6no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 5.15 170/290] ext4: factor out ext4_fc_get_tl()
Date:   Tue, 10 Jan 2023 19:04:22 +0100
Message-Id: <20230110180037.781665298@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit dcc5827484d6e53ccda12334f8bbfafcc593ceda upstream.

Factor out ext4_fc_get_tl() to fill 'tl' with host byte order.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220924075233.2315259-3-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1271,7 +1271,7 @@ struct dentry_info_args {
 };
 
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct  ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1280,8 +1280,14 @@ static inline void tl_to_darg(struct den
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
@@ -1446,7 +1452,7 @@ static int ext4_fc_replay_inode(struct s
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
 	struct ext4_iloc iloc;
-	int inode_len, ino, ret, tag = le16_to_cpu(tl->fc_tag);
+	int inode_len, ino, ret, tag = tl->fc_tag;
 	struct ext4_extent_header *eh;
 
 	memcpy(&fc_inode, val, sizeof(fc_inode));
@@ -1471,7 +1477,7 @@ static int ext4_fc_replay_inode(struct s
 	if (ret)
 		goto out;
 
-	inode_len = le16_to_cpu(tl->fc_len) - sizeof(struct ext4_fc_inode);
+	inode_len = tl->fc_len - sizeof(struct ext4_fc_inode);
 	raw_inode = ext4_raw_inode(&iloc);
 
 	memcpy(raw_inode, raw_fc_inode, offsetof(struct ext4_inode, i_block));
@@ -1958,12 +1964,12 @@ static int ext4_fc_replay_scan(journal_t
 
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
@@ -1983,7 +1989,7 @@ static int ext4_fc_replay_scan(journal_t
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
@@ -2016,7 +2022,7 @@ static int ext4_fc_replay_scan(journal_t
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2072,8 +2078,8 @@ static int ext4_fc_replay(journal_t *jou
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
 	for (cur = start; cur < end;
-	     cur = cur + EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, EXT4_FC_TAG_BASE_LEN);
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
@@ -2081,10 +2087,9 @@ static int ext4_fc_replay(journal_t *jou
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
@@ -2105,19 +2110,18 @@ static int ext4_fc_replay(journal_t *jou
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


