Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 767F365D6CE
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjADPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbjADPDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:03:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFD2EE30
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:03:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 604CBB81673
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BF1C433F2;
        Wed,  4 Jan 2023 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844613;
        bh=1f2LXUVh3aMol7OlxaqKc4caW4xdwKoy+STxE/NKxBo=;
        h=Subject:To:Cc:From:Date:From;
        b=OZ1eI+V0+943UtSfYI30UtVUYCvQrQXs6tYgMLHGEiCx0RSa/muUg8RXQ/dU0SRdd
         z89sNciFnYxFBSjZWjAqltgbUcgx/GeK0IhTmU1RIN0+GeB+Lu8BtkUFHYMagK16jz
         SGAohZWRc9eoUQ/nv0nIqixCsa3PNDdh6RWIdHIo=
Subject: FAILED: patch "[PATCH] ext4: fix off-by-one errors in fast-commit block filling" failed to apply to 5.15-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:03:29 +0100
Message-ID: <167284460914318@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

48a6a66db82b ("ext4: fix off-by-one errors in fast-commit block filling")
8415ce07ecf0 ("ext4: fix unaligned memory access in ext4_fc_reserve_space()")
594bc43b4103 ("ext4: fix leaking uninitialized memory in fast-commit journal")
1b45cc5c7b92 ("ext4: fix potential out of bound read in ext4_fc_replay_scan()")
dcc5827484d6 ("ext4: factor out ext4_fc_get_tl()")
fdc2a3c75dd8 ("ext4: introduce EXT4_FC_TAG_BASE_LEN helper")
ccbf8eeb39f2 ("ext4: fix miss release buffer head in ext4_fc_write_inode")
4978c659e7b5 ("ext4: use ext4_debug() instead of jbd_debug()")
d9bf099cb980 ("ext4: add commit_tid info in jbd debug log")
0915e464cb27 ("ext4: simplify updating of fast commit stats")
7bbbe241ec7c ("ext4: drop ineligible txn start stop APIs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 48a6a66db82b8043d298a630f22c62d43550cae5 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:40 -0800
Subject: [PATCH] ext4: fix off-by-one errors in fast-commit block filling

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
Link: https://lore.kernel.org/r/20221106224841.279231-7-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 892fa7c7a768..7ed71c652f67 100644
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

