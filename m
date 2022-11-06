Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E357C61E719
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 23:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKFWwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 17:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiKFWwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 17:52:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DB210066;
        Sun,  6 Nov 2022 14:52:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC3A7B80D48;
        Sun,  6 Nov 2022 22:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490E0C433D7;
        Sun,  6 Nov 2022 22:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775155;
        bh=EIFImRJhrHvC8VtkQyKQx9/usgbKtcApLH9PflVR6ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISxGsSh3CkCLD5k/9Tnptc/FFGkWScPpqL/1pmJEf47qd4E+FmggXpsrEzdy4R3JV
         YkZK0JYgzvrS6KMiMEO/MZ4znTam7I9f3Qpx6tSOD0mh4I1WrEvfHN9RZfqqB0kh4D
         BKVv+HN0jrOIfPwud6/uB5yoxzH6LgYkEXz5I5YE7k7qH321i5rFZIsgBlVnibe6tY
         R+74Dlq8VzTmz122GTwoD5tzvdckpNdcRqcUuKWM9qf/KUxOBr87sTE2FUB3q7oAyO
         4uMfWxIYVbfv6DuAAvbQfV/mSDJ/zZlfsw4yyPN4JQDso9y0ck+987xKL2nbD03k6k
         5bhOsmIUYvjVg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 6/7] ext4: fix off-by-one errors in fast-commit block filling
Date:   Sun,  6 Nov 2022 14:48:40 -0800
Message-Id: <20221106224841.279231-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221106224841.279231-1-ebiggers@kernel.org>
References: <20221106224841.279231-1-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

Due to several different off-by-one errors, or perhaps due to a late
change in design that wasn't fully reflected in the code that was
actually merged, there are several very strange constraints on how
fast-commit blocks are filled with tlv entries:

- tlvs must start at least 10 bytes before the end of the block, even
  though the minimum tlv length is 8.  Otherwise, the replay code will
  ignore them.  (BUG: ext4_fc_reserve_space() could violate this
  requirement if called with a len of blocksize - 9 or blocksize - 8.
  Fortunately, this doesn't seem to happen currently.)

- tlvs must end at least 1 byte before the end of the block.  Otherwise
  the replay code will consider them to be invalid.  This quirk
  contributed to a bug (fixed by an earlier commit) where uninitialized
  memory was being leaked to disk in the last byte of blocks.

Also, strangely these constraints don't apply to the replay code in
e2fsprogs, which will accept any tlvs in the blocks (with no bounds
checks at all, but that is a separate issue...).

Given that this all seems to be a bug, let's fix it by just filling
blocks with tlv entries in the natural way.

Note that old kernels will be unable to replay fast-commit journals
created by kernels that have this commit.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 66 +++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 892fa7c7a768b..7ed71c652f67f 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -714,43 +714,43 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	struct buffer_head *bh;
 	int bsize = sbi->s_journal->j_blocksize;
 	int ret, off = sbi->s_fc_bytes % bsize;
-	int pad_len;
+	int remaining;
 	u8 *dst;
 
 	/*
-	 * After allocating len, we should have space at least for a 0 byte
-	 * padding.
+	 * If 'len' is too long to fit in any block alongside a PAD tlv, then we
+	 * cannot fulfill the request.
 	 */
-	if (len + EXT4_FC_TAG_BASE_LEN > bsize)
+	if (len > bsize - EXT4_FC_TAG_BASE_LEN)
 		return NULL;
 
-	if (bsize - off - 1 > len + EXT4_FC_TAG_BASE_LEN) {
-		/*
-		 * Only allocate from current buffer if we have enough space for
-		 * this request AND we have space to add a zero byte padding.
-		 */
-		if (!sbi->s_fc_bh) {
-			ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
-			if (ret)
-				return NULL;
-			sbi->s_fc_bh = bh;
-		}
-		sbi->s_fc_bytes += len;
-		return sbi->s_fc_bh->b_data + off;
+	if (!sbi->s_fc_bh) {
+		ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
+		if (ret)
+			return NULL;
+		sbi->s_fc_bh = bh;
 	}
-	/* Need to add PAD tag */
 	dst = sbi->s_fc_bh->b_data + off;
+
+	/*
+	 * Allocate the bytes in the current block if we can do so while still
+	 * leaving enough space for a PAD tlv.
+	 */
+	remaining = bsize - EXT4_FC_TAG_BASE_LEN - off;
+	if (len <= remaining) {
+		sbi->s_fc_bytes += len;
+		return dst;
+	}
+
+	/*
+	 * Else, terminate the current block with a PAD tlv, then allocate a new
+	 * block and allocate the bytes at the start of that new block.
+	 */
+
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
-	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
-	tl.fc_len = cpu_to_le16(pad_len);
+	tl.fc_len = cpu_to_le16(remaining);
 	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
-	dst += EXT4_FC_TAG_BASE_LEN;
-	if (pad_len > 0) {
-		ext4_fc_memzero(sb, dst, pad_len, crc);
-		dst += pad_len;
-	}
-	/* Don't leak uninitialized memory in the unused last byte. */
-	*dst = 0;
+	ext4_fc_memzero(sb, dst + EXT4_FC_TAG_BASE_LEN, remaining, crc);
 
 	ext4_fc_submit_bh(sb, false);
 
@@ -758,7 +758,7 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	if (ret)
 		return NULL;
 	sbi->s_fc_bh = bh;
-	sbi->s_fc_bytes = (sbi->s_fc_bytes / bsize + 1) * bsize + len;
+	sbi->s_fc_bytes += bsize - off + len;
 	return sbi->s_fc_bh->b_data;
 }
 
@@ -789,7 +789,7 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	off = sbi->s_fc_bytes % bsize;
 
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_TAIL);
-	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
+	tl.fc_len = cpu_to_le16(bsize - off + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
 	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
@@ -2056,7 +2056,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	state = &sbi->s_fc_replay_state;
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
 	if (state->fc_replay_expected_off == 0) {
 		state->fc_cur_tag = 0;
@@ -2077,7 +2077,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
@@ -2195,9 +2195,9 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 #endif
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
-	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
-- 
2.38.1

