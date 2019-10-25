Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FCDE538C
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731557AbfJYSGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46576 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731324AbfJYSFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xy-0008OU-P5; Fri, 25 Oct 2019 19:05:38 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xw-0001kY-Bc; Fri, 25 Oct 2019 19:05:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Steven J. Magnani" <steve@digidescorp.com>,
        "Steven J. Magnani" <steve.magnani@digidescorp.com>,
        "Jan Kara" <jack@suse.cz>
Date:   Fri, 25 Oct 2019 19:03:39 +0100
Message-ID: <lsq.1572026582.496725547@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 38/47] udf: Fix incorrect final NOT_ALLOCATED (hole)
 extent length
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven J. Magnani" <steve.magnani@digidescorp.com>

commit fa33cdbf3eceb0206a4f844fe91aeebcf6ff2b7a upstream.

In some cases, using the 'truncate' command to extend a UDF file results
in a mismatch between the length of the file's extents (specifically, due
to incorrect length of the final NOT_ALLOCATED extent) and the information
(file) length. The discrepancy can prevent other operating systems
(i.e., Windows 10) from opening the file.

Two particular errors have been observed when extending a file:

1. The final extent is larger than it should be, having been rounded up
   to a multiple of the block size.

B. The final extent is not shorter than it should be, due to not having
   been updated when the file's information length was increased.

[JK: simplified udf_do_extend_final_block(), fixed up some types]

Fixes: 2c948b3f86e5 ("udf: Avoid IO in udf_clear_inode")
Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Link: https://lore.kernel.org/r/1561948775-5878-1-git-send-email-steve@digidescorp.com
Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/inode.c | 93 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 33 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -482,13 +482,15 @@ static struct buffer_head *udf_getblk(st
 	return NULL;
 }
 
-/* Extend the file by 'blocks' blocks, return the number of extents added */
+/* Extend the file with new blocks totaling 'new_block_bytes',
+ * return the number of extents added
+ */
 static int udf_do_extend_file(struct inode *inode,
 			      struct extent_position *last_pos,
 			      struct kernel_long_ad *last_ext,
-			      sector_t blocks)
+			      loff_t new_block_bytes)
 {
-	sector_t add;
+	uint32_t add;
 	int count = 0, fake = !(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	struct super_block *sb = inode->i_sb;
 	struct kernel_lb_addr prealloc_loc = {};
@@ -498,7 +500,7 @@ static int udf_do_extend_file(struct ino
 
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
-	if (!blocks && fake)
+	if (!new_block_bytes && fake)
 		return 0;
 
 	iinfo = UDF_I(inode);
@@ -529,13 +531,12 @@ static int udf_do_extend_file(struct ino
 	/* Can we merge with the previous extent? */
 	if ((last_ext->extLength & UDF_EXTENT_FLAG_MASK) ==
 					EXT_NOT_RECORDED_NOT_ALLOCATED) {
-		add = ((1 << 30) - sb->s_blocksize -
-			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK)) >>
-			sb->s_blocksize_bits;
-		if (add > blocks)
-			add = blocks;
-		blocks -= add;
-		last_ext->extLength += add << sb->s_blocksize_bits;
+		add = (1 << 30) - sb->s_blocksize -
+			(last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
+		if (add > new_block_bytes)
+			add = new_block_bytes;
+		new_block_bytes -= add;
+		last_ext->extLength += add;
 	}
 
 	if (fake) {
@@ -547,28 +548,27 @@ static int udf_do_extend_file(struct ino
 				last_ext->extLength, 1);
 
 	/* Managed to do everything necessary? */
-	if (!blocks)
+	if (!new_block_bytes)
 		goto out;
 
 	/* All further extents will be NOT_RECORDED_NOT_ALLOCATED */
 	last_ext->extLocation.logicalBlockNum = 0;
 	last_ext->extLocation.partitionReferenceNum = 0;
-	add = (1 << (30-sb->s_blocksize_bits)) - 1;
-	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-				(add << sb->s_blocksize_bits);
+	add = (1 << 30) - sb->s_blocksize;
+	last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED | add;
 
 	/* Create enough extents to cover the whole hole */
-	while (blocks > add) {
-		blocks -= add;
+	while (new_block_bytes > add) {
+		new_block_bytes -= add;
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
 			return err;
 		count++;
 	}
-	if (blocks) {
+	if (new_block_bytes) {
 		last_ext->extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-			(blocks << sb->s_blocksize_bits);
+			new_block_bytes;
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
@@ -599,6 +599,24 @@ out:
 	return count;
 }
 
+/* Extend the final block of the file to final_block_len bytes */
+static void udf_do_extend_final_block(struct inode *inode,
+				      struct extent_position *last_pos,
+				      struct kernel_long_ad *last_ext,
+				      uint32_t final_block_len)
+{
+	struct super_block *sb = inode->i_sb;
+	uint32_t added_bytes;
+
+	added_bytes = final_block_len -
+		      (last_ext->extLength & (sb->s_blocksize - 1));
+	last_ext->extLength += added_bytes;
+	UDF_I(inode)->i_lenExtents += added_bytes;
+
+	udf_write_aext(inode, last_pos, &last_ext->extLocation,
+			last_ext->extLength, 1);
+}
+
 static int udf_extend_file(struct inode *inode, loff_t newsize)
 {
 
@@ -608,10 +626,12 @@ static int udf_extend_file(struct inode
 	int8_t etype;
 	struct super_block *sb = inode->i_sb;
 	sector_t first_block = newsize >> sb->s_blocksize_bits, offset;
+	unsigned long partial_final_block;
 	int adsize;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 	struct kernel_long_ad extent;
-	int err;
+	int err = 0;
+	int within_final_block;
 
 	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_SHORT)
 		adsize = sizeof(struct short_ad);
@@ -621,18 +641,8 @@ static int udf_extend_file(struct inode
 		BUG();
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
+	within_final_block = (etype != -1);
 
-	/* File has extent covering the new size (could happen when extending
-	 * inside a block)? */
-	if (etype != -1)
-		return 0;
-	if (newsize & (sb->s_blocksize - 1))
-		offset++;
-	/* Extended file just to the boundary of the last file block? */
-	if (offset == 0)
-		return 0;
-
-	/* Truncate is extending the file by 'offset' blocks */
 	if ((!epos.bh && epos.offset == udf_file_entry_alloc_offset(inode)) ||
 	    (epos.bh && epos.offset == sizeof(struct allocExtDesc))) {
 		/* File has no extents at all or has empty last
@@ -646,7 +656,22 @@ static int udf_extend_file(struct inode
 				      &extent.extLength, 0);
 		extent.extLength |= etype << 30;
 	}
-	err = udf_do_extend_file(inode, &epos, &extent, offset);
+
+	partial_final_block = newsize & (sb->s_blocksize - 1);
+
+	/* File has extent covering the new size (could happen when extending
+	 * inside a block)?
+	 */
+	if (within_final_block) {
+		/* Extending file within the last file block */
+		udf_do_extend_final_block(inode, &epos, &extent,
+					  partial_final_block);
+	} else {
+		loff_t add = ((loff_t)offset << sb->s_blocksize_bits) |
+			     partial_final_block;
+		err = udf_do_extend_file(inode, &epos, &extent, add);
+	}
+
 	if (err < 0)
 		goto out;
 	err = 0;
@@ -751,6 +776,7 @@ static sector_t inode_getblk(struct inod
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
+		loff_t hole_len;
 		isBeyondEOF = 1;
 		if (count) {
 			if (c)
@@ -766,7 +792,8 @@ static sector_t inode_getblk(struct inod
 			startnum = (offset > 0);
 		}
 		/* Create extents for the hole between EOF and offset */
-		ret = udf_do_extend_file(inode, &prev_epos, laarr, offset);
+		hole_len = (loff_t)offset << inode->i_blkbits;
+		ret = udf_do_extend_file(inode, &prev_epos, laarr, hole_len);
 		if (ret < 0) {
 			brelse(prev_epos.bh);
 			brelse(cur_epos.bh);

