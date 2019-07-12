Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881D266D57
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfGLM27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728908AbfGLM26 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D18ED208E4;
        Fri, 12 Jul 2019 12:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934537;
        bh=/T3rBfyNMd4s89OXKH3VPrhhGzsi43ZonvJrirmgypo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9+7gI7KupuprQRpSaaqhl+8bvj1B1SAz97EHh/11wN7Y1VbieedPtyVufO1/gucU
         De2b2FOKHz/2/UOiiiOIrMwHEUqb45tYgDvv9ErBK8t+KuQbxP+FTQqTxqzit+s9WV
         hiXMNlr00kii1WiDTGVD0JmFnWkA+iUizHHRpM7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.1 089/138] udf: Fix incorrect final NOT_ALLOCATED (hole) extent length
Date:   Fri, 12 Jul 2019 14:19:13 +0200
Message-Id: <20190712121632.162572244@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven J. Magnani <steve.magnani@digidescorp.com>

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
CC: stable@vger.kernel.org
Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
Link: https://lore.kernel.org/r/1561948775-5878-1-git-send-email-steve@digidescorp.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/inode.c |   93 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 60 insertions(+), 33 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -470,13 +470,15 @@ static struct buffer_head *udf_getblk(st
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
@@ -486,7 +488,7 @@ static int udf_do_extend_file(struct ino
 
 	/* The previous extent is fake and we should not extend by anything
 	 * - there's nothing to do... */
-	if (!blocks && fake)
+	if (!new_block_bytes && fake)
 		return 0;
 
 	iinfo = UDF_I(inode);
@@ -517,13 +519,12 @@ static int udf_do_extend_file(struct ino
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
@@ -544,28 +545,27 @@ static int udf_do_extend_file(struct ino
 	}
 
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
@@ -596,6 +596,24 @@ out:
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
 
@@ -605,10 +623,12 @@ static int udf_extend_file(struct inode
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
@@ -618,18 +638,8 @@ static int udf_extend_file(struct inode
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
@@ -643,7 +653,22 @@ static int udf_extend_file(struct inode
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
@@ -745,6 +770,7 @@ static sector_t inode_getblk(struct inod
 	/* Are we beyond EOF? */
 	if (etype == -1) {
 		int ret;
+		loff_t hole_len;
 		isBeyondEOF = true;
 		if (count) {
 			if (c)
@@ -760,7 +786,8 @@ static sector_t inode_getblk(struct inod
 			startnum = (offset > 0);
 		}
 		/* Create extents for the hole between EOF and offset */
-		ret = udf_do_extend_file(inode, &prev_epos, laarr, offset);
+		hole_len = (loff_t)offset << inode->i_blkbits;
+		ret = udf_do_extend_file(inode, &prev_epos, laarr, hole_len);
 		if (ret < 0) {
 			*err = ret;
 			newblock = 0;


