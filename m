Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3C265D6CC
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbjADPDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239520AbjADPDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:03:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FDE1AA01
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 65DACCE16F9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40373C433F2;
        Wed,  4 Jan 2023 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844593;
        bh=0dV86kmtMGv6b8ag1bRZFM3WsxaEgsckI3ksbtvC4K8=;
        h=Subject:To:Cc:From:Date:From;
        b=ZavZAAtveBxehMA8PUUtSStXwVrGJFNLk7N085BXymjdb7FqRT3ZNA2qrS59SngCc
         AFma9rkfeMw3/+kUvPOZCG82eYFQ/m2XpBEoG5+dZpi2T9UHurDVoOY8XDpvt938X+
         kWV/r0RQQ/JVsp902xb/VZv/9N0L1tB7PfRB/DtQ=
Subject: FAILED: patch "[PATCH] ext4: fix unaligned memory access in ext4_fc_reserve_space()" failed to apply to 5.15-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:03:10 +0100
Message-ID: <1672844590226207@kroah.com>
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

8415ce07ecf0 ("ext4: fix unaligned memory access in ext4_fc_reserve_space()")
594bc43b4103 ("ext4: fix leaking uninitialized memory in fast-commit journal")
fdc2a3c75dd8 ("ext4: introduce EXT4_FC_TAG_BASE_LEN helper")
ccbf8eeb39f2 ("ext4: fix miss release buffer head in ext4_fc_write_inode")
4978c659e7b5 ("ext4: use ext4_debug() instead of jbd_debug()")
d9bf099cb980 ("ext4: add commit_tid info in jbd debug log")
0915e464cb27 ("ext4: simplify updating of fast commit stats")
7bbbe241ec7c ("ext4: drop ineligible txn start stop APIs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8415ce07ecf0cc25efdd5db264a7133716e503cf Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:39 -0800
Subject: [PATCH] ext4: fix unaligned memory access in ext4_fc_reserve_space()

As is done elsewhere in the file, build the struct ext4_fc_tl on the
stack and memcpy() it into the buffer, rather than directly writing it
to a potentially-unaligned location in the buffer.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-6-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index d5ad4b2b235d..892fa7c7a768 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -675,6 +675,15 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 
 /* Ext4 commit path routines */
 
+/* memcpy to fc reserved space and update CRC */
+static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
+				int len, u32 *crc)
+{
+	if (crc)
+		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
+	return memcpy(dst, src, len);
+}
+
 /* memzero and update CRC */
 static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
 				u32 *crc)
@@ -700,12 +709,13 @@ static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
  */
 static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 {
-	struct ext4_fc_tl *tl;
+	struct ext4_fc_tl tl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct buffer_head *bh;
 	int bsize = sbi->s_journal->j_blocksize;
 	int ret, off = sbi->s_fc_bytes % bsize;
 	int pad_len;
+	u8 *dst;
 
 	/*
 	 * After allocating len, we should have space at least for a 0 byte
@@ -729,16 +739,18 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 		return sbi->s_fc_bh->b_data + off;
 	}
 	/* Need to add PAD tag */
-	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
-	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
+	dst = sbi->s_fc_bh->b_data + off;
+	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
 	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
-	tl->fc_len = cpu_to_le16(pad_len);
-	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
-	if (pad_len > 0)
-		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+	tl.fc_len = cpu_to_le16(pad_len);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
+	if (pad_len > 0) {
+		ext4_fc_memzero(sb, dst, pad_len, crc);
+		dst += pad_len;
+	}
 	/* Don't leak uninitialized memory in the unused last byte. */
-	*((u8 *)(tl + 1) + pad_len) = 0;
+	*dst = 0;
 
 	ext4_fc_submit_bh(sb, false);
 
@@ -750,15 +762,6 @@ static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 	return sbi->s_fc_bh->b_data;
 }
 
-/* memcpy to fc reserved space and update CRC */
-static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
-				int len, u32 *crc)
-{
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
-	return memcpy(dst, src, len);
-}
-
 /*
  * Complete a fast commit by writing tail tag.
  *

