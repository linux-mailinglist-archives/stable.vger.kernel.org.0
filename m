Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13522315A13
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 00:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhBIXb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 18:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:55846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233910AbhBIWRC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Feb 2021 17:17:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D6FC64ECA;
        Tue,  9 Feb 2021 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612906917;
        bh=HeNaNkd7SUgTse7Z8b7/f1pJL+OyShP46W1UzGlBIbY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lXR7iRp2LHDizVGZDZj4azuJxmPVghjHokGorzIiJMIGqkopMV8QXycUoJaRBDgL4
         /U9huPJv0cfVp9jyCO8MpwojB09YWXMsDBI6u8oL+QWneRXmlzefXZycne0NtUrHPD
         Xt3hwMyV8eTWr3QdEyznphb73mK9OwZWTSatnVMQ=
Date:   Tue, 09 Feb 2021 13:41:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 03/14] squashfs: add more sanity checks in inode
 lookup
Message-ID: <20210209214156.xlICQUrK-%akpm@linux-foundation.org>
In-Reply-To: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: add more sanity checks in inode lookup

Sysbot has reported an "slab-out-of-bounds read" error which has been
identified as being caused by a corrupted "ino_num" value read from the
inode.  This could be because the metadata block is uncompressed, or
because the "compression" bit has been corrupted (turning a compressed
block into an uncompressed block).

This patch adds additional sanity checks to detect this, and the following
corruption.

1. It checks against corruption of the inodes count.  This can either
   lead to a larger table to be read, or a smaller than expected
   table to be read.

   In the case of a too large inodes count, this would often have been
   trapped by the existing sanity checks, but this patch introduces
   a more exact check, which can identify too small values.

2. It checks the contents of the index table for corruption.

[phillip@squashfs.org.uk: fix checkpatch issue]
  Link: https://lkml.kernel.org/r/527909353.754618.1612769948607@webmail.123-reg.co.uk
Link: https://lkml.kernel.org/r/20210204130249.4495-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+04419e3ff19d2970ea28@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/export.c |   41 +++++++++++++++++++++++++++++++++--------
 1 file changed, 33 insertions(+), 8 deletions(-)

--- a/fs/squashfs/export.c~squashfs-add-more-sanity-checks-in-inode-lookup
+++ a/fs/squashfs/export.c
@@ -41,12 +41,17 @@ static long long squashfs_inode_lookup(s
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int blk = SQUASHFS_LOOKUP_BLOCK(ino_num - 1);
 	int offset = SQUASHFS_LOOKUP_BLOCK_OFFSET(ino_num - 1);
-	u64 start = le64_to_cpu(msblk->inode_lookup_table[blk]);
+	u64 start;
 	__le64 ino;
 	int err;
 
 	TRACE("Entered squashfs_inode_lookup, inode_number = %d\n", ino_num);
 
+	if (ino_num == 0 || (ino_num - 1) >= msblk->inodes)
+		return -EINVAL;
+
+	start = le64_to_cpu(msblk->inode_lookup_table[blk]);
+
 	err = squashfs_read_metadata(sb, &ino, &start, &offset, sizeof(ino));
 	if (err < 0)
 		return err;
@@ -111,7 +116,10 @@ __le64 *squashfs_read_inode_lookup_table
 		u64 lookup_table_start, u64 next_table, unsigned int inodes)
 {
 	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
+	unsigned int indexes = SQUASHFS_LOOKUP_BLOCKS(inodes);
+	int n;
 	__le64 *table;
+	u64 start, end;
 
 	TRACE("In read_inode_lookup_table, length %d\n", length);
 
@@ -121,20 +129,37 @@ __le64 *squashfs_read_inode_lookup_table
 	if (inodes == 0)
 		return ERR_PTR(-EINVAL);
 
-	/* length bytes should not extend into the next table - this check
-	 * also traps instances where lookup_table_start is incorrectly larger
-	 * than the next table start
+	/*
+	 * The computed size of the lookup table (length bytes) should exactly
+	 * match the table start and end points
 	 */
-	if (lookup_table_start + length > next_table)
+	if (length != (next_table - lookup_table_start))
 		return ERR_PTR(-EINVAL);
 
 	table = squashfs_read_table(sb, lookup_table_start, length);
+	if (IS_ERR(table))
+		return table;
 
 	/*
-	 * table[0] points to the first inode lookup table metadata block,
-	 * this should be less than lookup_table_start
+	 * table0], table[1], ... table[indexes - 1] store the locations
+	 * of the compressed inode lookup blocks.  Each entry should be
+	 * less than the next (i.e. table[0] < table[1]), and the difference
+	 * between them should be SQUASHFS_METADATA_SIZE or less.
+	 * table[indexes - 1] should  be less than lookup_table_start, and
+	 * again the difference should be SQUASHFS_METADATA_SIZE or less
 	 */
-	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= lookup_table_start) {
+	for (n = 0; n < (indexes - 1); n++) {
+		start = le64_to_cpu(table[n]);
+		end = le64_to_cpu(table[n + 1]);
+
+		if (start >= end || (end - start) > SQUASHFS_METADATA_SIZE) {
+			kfree(table);
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	start = le64_to_cpu(table[indexes - 1]);
+	if (start >= lookup_table_start || (lookup_table_start - start) > SQUASHFS_METADATA_SIZE) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
_
