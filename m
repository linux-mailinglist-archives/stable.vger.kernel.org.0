Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E5965E5E6
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjAEHRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjAEHRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:17:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C32D5276F;
        Wed,  4 Jan 2023 23:17:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B56FEB81A09;
        Thu,  5 Jan 2023 07:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1AEC433D2;
        Thu,  5 Jan 2023 07:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672903028;
        bh=jda5oJsc2ZFtZt0qXOxYDzeaPur/mruwvPxMnNnACRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYa/f1N9C1iG4lUpvuWulG+EguuLliS378xQjQa8mMBUFhE08G5yZQFSx4i05gZmq
         hewvhCs5cSVasBmwE+xGFTcAwBnRahBS6pvqrTP8Cela4qqAlQwDQRaN+MQ3zxwwQQ
         VxdfypRNLovb0ZvssnQia0rg/q5kjZc1NKFsa/4N13s6EQDEZIZkMwA+1Ag97T3DGG
         e6RELGEL219e+7ajs7dBzz+mtnJYY7Sdx4M7NmHH1PX6nVvpYQyRfNBZZOOe9vsVLj
         wG5R9o8q3ptbKkDLAy6ECKPS3sZwSLQtD9rgpm4pLvPnL7gWAx9xF5qKZVBbjqBz0v
         yxI3DETGMDezQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5.15 03/10] ext4: introduce EXT4_FC_TAG_BASE_LEN helper
Date:   Wed,  4 Jan 2023 23:13:52 -0800
Message-Id: <20230105071359.257952-4-ebiggers@kernel.org>
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

commit fdc2a3c75dd8345c5b48718af90bad1a7811bedb upstream.

Introduce EXT4_FC_TAG_BASE_LEN helper for calculate length of
struct ext4_fc_tl.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220924075233.2315259-2-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 54 ++++++++++++++++++++++---------------------
 fs/ext4/fast_commit.h |  3 +++
 2 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b16fe6ae9852f..9b1dedd03be0a 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -631,10 +631,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	 * After allocating len, we should have space at least for a 0 byte
 	 * padding.
 	 */
-	if (len + sizeof(struct ext4_fc_tl) > bsize)
+	if (len + EXT4_FC_TAG_BASE_LEN > bsize)
 		return NULL;
 
-	if (bsize - off - 1 > len + sizeof(struct ext4_fc_tl)) {
+	if (bsize - off - 1 > len + EXT4_FC_TAG_BASE_LEN) {
 		/*
 		 * Only allocate from current buffer if we have enough space for
 		 * this request AND we have space to add a zero byte padding.
@@ -651,10 +651,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	/* Need to add PAD tag */
 	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
 	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
-	pad_len = bsize - off - 1 - sizeof(struct ext4_fc_tl);
+	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
 	tl->fc_len = cpu_to_le16(pad_len);
 	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, sizeof(*tl));
+		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
 	if (pad_len > 0)
 		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
 	/* Don't leak uninitialized memory in the unused last byte. */
@@ -699,7 +699,7 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	 * ext4_fc_reserve_space takes care of allocating an extra block if
 	 * there's no enough space on this block for accommodating this tail.
 	 */
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(tail), &crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + sizeof(tail), &crc);
 	if (!dst)
 		return -ENOSPC;
 
@@ -709,8 +709,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), &crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	tail.fc_tid = cpu_to_le32(sbi->s_journal->j_running_transaction->t_tid);
 	ext4_fc_memcpy(sb, dst, &tail.fc_tid, sizeof(tail.fc_tid), &crc);
 	dst += sizeof(tail.fc_tid);
@@ -734,15 +734,15 @@ static bool ext4_fc_add_tlv(struct super_block *sb, u16 tag, u16 len, u8 *val,
 	struct ext4_fc_tl tl;
 	u8 *dst;
 
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + len, crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + len, crc);
 	if (!dst)
 		return false;
 
 	tl.fc_tag = cpu_to_le16(tag);
 	tl.fc_len = cpu_to_le16(len);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	ext4_fc_memcpy(sb, dst + sizeof(tl), val, len, crc);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	ext4_fc_memcpy(sb, dst + EXT4_FC_TAG_BASE_LEN, val, len, crc);
 
 	return true;
 }
@@ -754,8 +754,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	struct ext4_fc_dentry_info fcd;
 	struct ext4_fc_tl tl;
 	int dlen = fc_dentry->fcd_name.len;
-	u8 *dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(fcd) + dlen,
-					crc);
+	u8 *dst = ext4_fc_reserve_space(sb,
+			EXT4_FC_TAG_BASE_LEN + sizeof(fcd) + dlen, crc);
 
 	if (!dst)
 		return false;
@@ -764,8 +764,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	fcd.fc_ino = cpu_to_le32(fc_dentry->fcd_ino);
 	tl.fc_tag = cpu_to_le16(fc_dentry->fcd_op);
 	tl.fc_len = cpu_to_le16(sizeof(fcd) + dlen);
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	ext4_fc_memcpy(sb, dst, &fcd, sizeof(fcd), crc);
 	dst += sizeof(fcd);
 	ext4_fc_memcpy(sb, dst, fc_dentry->fcd_name.name, dlen, crc);
@@ -801,13 +801,13 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 
 	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
-			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
+		EXT4_FC_TAG_BASE_LEN + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
 		goto err;
 
-	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
+	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc))
 		goto err;
-	dst += sizeof(tl);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
 		goto err;
 	dst += sizeof(fc_inode);
@@ -1957,9 +1957,10 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
+	for (cur = start; cur < end;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len)) {
+		memcpy(&tl, cur, EXT4_FC_TAG_BASE_LEN);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
 		ext4_debug("Scan phase, tag:%s, blk %lld\n",
 			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
 		switch (le16_to_cpu(tl.fc_tag)) {
@@ -1982,13 +1983,13 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
 			memcpy(&tail, val, sizeof(tail));
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-						sizeof(tl) +
+						EXT4_FC_TAG_BASE_LEN +
 						offsetof(struct ext4_fc_tail,
 						fc_crc));
 			if (le32_to_cpu(tail.fc_tid) == expected_tid &&
@@ -2015,7 +2016,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					    sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2070,9 +2071,10 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 	start = (u8 *)bh->b_data;
 	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
 
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
+	for (cur = start; cur < end;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len)) {
+		memcpy(&tl, cur, EXT4_FC_TAG_BASE_LEN);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
 			ret = JBD2_FC_REPLAY_STOP;
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index a0fed4e8a8c8e..e580702281d28 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -70,6 +70,9 @@ struct ext4_fc_tail {
 	__le32 fc_crc;
 };
 
+/* Tag base length */
+#define EXT4_FC_TAG_BASE_LEN (sizeof(struct ext4_fc_tl))
+
 /*
  * Fast commit status codes
  */
-- 
2.39.0

