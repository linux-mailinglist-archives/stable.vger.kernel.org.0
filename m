Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9532261E713
	for <lists+stable@lfdr.de>; Sun,  6 Nov 2022 23:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiKFWwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 17:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiKFWwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 17:52:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A321C101E3;
        Sun,  6 Nov 2022 14:52:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64DDBB80D37;
        Sun,  6 Nov 2022 22:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0400AC4347C;
        Sun,  6 Nov 2022 22:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775155;
        bh=doSgKvL2ErW/F+kDQDJ3xeq4/JGRaB/+jqKEaI9++OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJTk58VK3XNftsorG1SUruxkPkcqMG3Y4FUCZ/dH+PVVl9XaNmoKxwIlo13UUTuaB
         tyY4PIRaihhJna0ylJ0BssqVapkOkoerbYk1vVGn4/nMRMY2lgVE/Fn8aYOVDO9G9I
         C5xTiYN80XbhWtN4ENjMtMFA8av39ztrEcSZ/NCD8J3kWSyd3h5gvtIS2Ph6xwep2Q
         A49ZR0RH/YV+yT4SSfy6g1EDiRgEGtsebANMQUy1GbJ+b4jo/+yE9ENxxPCUR3hlmQ
         0r4rmyoVk7T2pRi4QCe5KyEEb/TDbabUJJIAN3HgbeZvSFzZ28r99O7blLTsuTaTKB
         lsn+/yggISAaQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 5/7] ext4: fix unaligned memory access in ext4_fc_reserve_space()
Date:   Sun,  6 Nov 2022 14:48:39 -0800
Message-Id: <20221106224841.279231-6-ebiggers@kernel.org>
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

As is done elsewhere in the file, build the struct ext4_fc_tl on the
stack and memcpy() it into the buffer, rather than directly writing it
to a potentially-unaligned location in the buffer.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ext4/fast_commit.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index d5ad4b2b235d6..892fa7c7a768b 100644
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
-- 
2.38.1

