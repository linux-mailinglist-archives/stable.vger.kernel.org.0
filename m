Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5A04EA00B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbiC1ToG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343536AbiC1ToC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:44:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59C4673EF;
        Mon, 28 Mar 2022 12:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CC90612B2;
        Mon, 28 Mar 2022 19:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D03C36AE3;
        Mon, 28 Mar 2022 19:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496536;
        bh=E0D0/3joNBZjRxf5vdymf3cFTpOU7GzS6zqyTVfa210=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME7NxL5gBzO4eM+gDYHNpOKKILWh4/vjuqfsI1M2jRe8ifKhPL4jme/XlKhE+Cei4
         vdQ1ax5m9T/1oFgU1IZzBYwJUIfbD+CNsZZb20jIxeEZBn6ELnMVnp3I5jQUHUVKb7
         F7Ean/FAQJqxxzvBEbK0e2oJO2Ll18wmtpA8269D/dBibDhOy3+6O3J/UgAfoaps4y
         2GVGOEmPuralDr1+occWQptpoNd21TCsrcji8kYF/X1g1WGlAUb76eQ8SxL8KJJmn3
         aJ4KDxHTItWHmlBpbjB3D65Vop836qi6ARk4VxZxL0LmT7wDU+Qm8YV75hT7e2rx/L
         oZ9c6a/xOhNSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com, jbacik@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 14/21] btrfs: handle csum lookup errors properly on reads
Date:   Mon, 28 Mar 2022 15:41:49 -0400
Message-Id: <20220328194157.1585642-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194157.1585642-1-sashal@kernel.org>
References: <20220328194157.1585642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 1784b7d502a94b561eae58249adde5f72c26eb3c ]

Currently any error we get while trying to lookup csums during reads
shows up as a missing csum, and then on the read completion side we
print an error saying there was a csum mismatch and we increase the
device corruption count.

However we could have gotten an EIO from the lookup.  We could also be
inside of a memory constrained container and gotten a ENOMEM while
trying to do the read.  In either case we don't want to make this look
like a file system corruption problem, we want to make it look like the
actual error it is.  Capture any negative value, convert it to the
appropriate blk_status_t, free the csum array if we have one and bail.

Note: a possible improvement would be to make the relocation code look
up the owning inode and see if it's marked as NODATASUM and set
EXTENT_NODATASUM there, that way if there's corruption and there isn't a
checksum when we want it we can fail here rather than later.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index f9813853eaf8..70f5cbd9020b 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -368,6 +368,7 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio, u8 *dst
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct btrfs_bio *bbio = NULL;
 	struct btrfs_path *path;
 	const u32 sectorsize = fs_info->sectorsize;
 	const u32 csum_size = fs_info->csum_size;
@@ -377,6 +378,7 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio, u8 *dst
 	u8 *csum;
 	const unsigned int nblocks = orig_len >> fs_info->sectorsize_bits;
 	int count = 0;
+	blk_status_t ret = BLK_STS_OK;
 
 	if ((BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) ||
 	    test_bit(BTRFS_FS_STATE_NO_CSUMS, &fs_info->fs_state))
@@ -400,7 +402,7 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio, u8 *dst
 		return BLK_STS_RESOURCE;
 
 	if (!dst) {
-		struct btrfs_bio *bbio = btrfs_bio(bio);
+		bbio = btrfs_bio(bio);
 
 		if (nblocks * csum_size > BTRFS_BIO_INLINE_CSUM_SIZE) {
 			bbio->csum = kmalloc_array(nblocks, csum_size, GFP_NOFS);
@@ -456,21 +458,27 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio, u8 *dst
 
 		count = search_csum_tree(fs_info, path, cur_disk_bytenr,
 					 search_len, csum_dst);
-		if (count <= 0) {
-			/*
-			 * Either we hit a critical error or we didn't find
-			 * the csum.
-			 * Either way, we put zero into the csums dst, and skip
-			 * to the next sector.
-			 */
+		if (count < 0) {
+			ret = errno_to_blk_status(count);
+			if (bbio)
+				btrfs_bio_free_csum(bbio);
+			break;
+		}
+
+		/*
+		 * We didn't find a csum for this range.  We need to make sure
+		 * we complain loudly about this, because we are not NODATASUM.
+		 *
+		 * However for the DATA_RELOC inode we could potentially be
+		 * relocating data extents for a NODATASUM inode, so the inode
+		 * itself won't be marked with NODATASUM, but the extent we're
+		 * copying is in fact NODATASUM.  If we don't find a csum we
+		 * assume this is the case.
+		 */
+		if (count == 0) {
 			memset(csum_dst, 0, csum_size);
 			count = 1;
 
-			/*
-			 * For data reloc inode, we need to mark the range
-			 * NODATASUM so that balance won't report false csum
-			 * error.
-			 */
 			if (BTRFS_I(inode)->root->root_key.objectid ==
 			    BTRFS_DATA_RELOC_TREE_OBJECTID) {
 				u64 file_offset;
@@ -491,7 +499,7 @@ blk_status_t btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio, u8 *dst
 	}
 
 	btrfs_free_path(path);
-	return BLK_STS_OK;
+	return ret;
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
-- 
2.34.1

