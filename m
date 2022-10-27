Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999B460FDF7
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbiJ0RAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbiJ0RAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3860120ED9
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2072A623EC
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AA1C433D7;
        Thu, 27 Oct 2022 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890048;
        bh=SwVBKzF++TqtI9nQB39vIUZIFzOuIqDSsMFyLtmTR4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWGecjO7jjFv6XKX8txL6ZYJXYTTovNqS+PY0D9BuemX64kLSkStvQO8NP/KEcgnm
         tAHgh7uWD3whNCHv0uFBeeMgzTg+QhiGf2oZ9RqolDPWHkAyra+9STCHaJVTYQa4Eg
         rkRyNSbFUI79t7hJkGqboy7DCP2igiTM1vGn40O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 90/94] ext4: introduce EXT4_FC_TAG_BASE_LEN helper
Date:   Thu, 27 Oct 2022 18:55:32 +0200
Message-Id: <20221027165100.818112420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit fdc2a3c75dd8345c5b48718af90bad1a7811bedb ]

Introduce EXT4_FC_TAG_BASE_LEN helper for calculate length of
struct ext4_fc_tl.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220924075233.2315259-2-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 1b45cc5c7b92 ("ext4: fix potential out of bound read in ext4_fc_replay_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/fast_commit.c | 54 ++++++++++++++++++++++---------------------
 fs/ext4/fast_commit.h |  3 +++
 2 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index b26f304baa52..6c8b78ad0ff2 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -710,10 +710,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
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
@@ -730,10 +730,10 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
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
 	ext4_fc_submit_bh(sb, false);
@@ -775,7 +775,7 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	 * ext4_fc_reserve_space takes care of allocating an extra block if
 	 * there's no enough space on this block for accommodating this tail.
 	 */
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(tail), &crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + sizeof(tail), &crc);
 	if (!dst)
 		return -ENOSPC;
 
@@ -785,8 +785,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), &crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	tail.fc_tid = cpu_to_le32(sbi->s_journal->j_running_transaction->t_tid);
 	ext4_fc_memcpy(sb, dst, &tail.fc_tid, sizeof(tail.fc_tid), &crc);
 	dst += sizeof(tail.fc_tid);
@@ -808,15 +808,15 @@ static bool ext4_fc_add_tlv(struct super_block *sb, u16 tag, u16 len, u8 *val,
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
@@ -828,8 +828,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	struct ext4_fc_dentry_info fcd;
 	struct ext4_fc_tl tl;
 	int dlen = fc_dentry->fcd_name.len;
-	u8 *dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(fcd) + dlen,
-					crc);
+	u8 *dst = ext4_fc_reserve_space(sb,
+			EXT4_FC_TAG_BASE_LEN + sizeof(fcd) + dlen, crc);
 
 	if (!dst)
 		return false;
@@ -838,8 +838,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
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
@@ -876,13 +876,13 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 
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
@@ -2036,9 +2036,10 @@ static int ext4_fc_replay_scan(journal_t *journal,
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
@@ -2061,13 +2062,13 @@ static int ext4_fc_replay_scan(journal_t *journal,
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
@@ -2094,7 +2095,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					    sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + le16_to_cpu(tl.fc_len));
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2149,9 +2150,10 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
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
index 1db12847a83b..a6154c3ed135 100644
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
2.35.1



