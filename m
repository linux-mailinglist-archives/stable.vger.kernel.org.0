Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45CC65D6CD
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbjADPDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239572AbjADPD0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:03:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711F417049
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:03:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3125CB81687
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF80C4339C;
        Wed,  4 Jan 2023 15:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844602;
        bh=MrYIhpNAPnFCWJFn4U/LrXBHZSRt0/xG5etqB03Witw=;
        h=Subject:To:Cc:From:Date:From;
        b=T5lpiM4+KYU2Fd1f5wvA/+Yo6XYAThWmDujg4O45W8wRbemtgG9WuGnb+LTdxUq38
         CFW30ti/FV+tJ1UhTm84NoMZVDEcfwpSZgOpbYv12xEPZxAQ6FykkARy0WMUYomECv
         q+c03KcsEMgixhU1aIDa6UXLZ06Ya7/Msdk3KSWs=
Subject: FAILED: patch "[PATCH] ext4: fix unaligned memory access in ext4_fc_reserve_space()" failed to apply to 5.10-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:03:11 +0100
Message-ID: <167284459125553@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
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
02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
25c6d98fc4c2 ("ext4: Move orphan inode handling into a separate file")
188c299e2a26 ("ext4: Support for checksumming from journal triggers")
bd2c38cf1726 ("ext4: Make sure quota files are not grabbed accidentally")
facec450a824 ("ext4: reduce arguments of ext4_fc_add_dentry_tlv")
b9a037b7f3c4 ("ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle")
a7ba36bc94f2 ("ext4: fix fast commit alignment issues")
fcdf3c34b7ab ("ext4: fix debug format string warning")
3088e5a5153c ("ext4: fix various seppling typos")
72ffb49a7b62 ("ext4: do not set SB_ACTIVE in ext4_orphan_cleanup()")
c915fb80eaa6 ("ext4: fix bh ref count on error paths")
efc61345274d ("ext4: shrink race window in ext4_should_retry_alloc()")

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

