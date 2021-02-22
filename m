Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91851321796
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBVMu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:50:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231591AbhBVMq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:46:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A825564F5A;
        Mon, 22 Feb 2021 12:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997731;
        bh=QO3SnUY4HcS43OXK9zE2UXYRBkImEmDNhfrdHWVX3fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xayXR96UUi5HUvnLEXW2zToxzu69sKSiUL737YA6sdiMtDCe7VZv8X9yJkXQ7LnhJ
         zljh91EFT+uqhnb0nfdFh+452U+dMJINss136FSkkai/F7Aa43cc22XhFYEK1to8ub
         0PnQ8oParrY7feiuFZz4BX9AkOv8cKM7NYprts8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        syzbot+b06d57ba83f604522af2@syzkaller.appspotmail.com,
        syzbot+c021ba012da41ee9807c@syzkaller.appspotmail.com,
        syzbot+5024636e8b5fd19f0f19@syzkaller.appspotmail.com,
        syzbot+bcbc661df46657d0fa4f@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 16/49] squashfs: add more sanity checks in id lookup
Date:   Mon, 22 Feb 2021 13:36:14 +0100
Message-Id: <20210222121026.082234547@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121022.546148341@linuxfoundation.org>
References: <20210222121022.546148341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Lougher <phillip@squashfs.org.uk>

commit f37aa4c7366e23f91b81d00bafd6a7ab54e4a381 upstream.

Sysbot has reported a number of "slab-out-of-bounds reads" and
"use-after-free read" errors which has been identified as being caused
by a corrupted index value read from the inode.  This could be because
the metadata block is uncompressed, or because the "compression" bit has
been corrupted (turning a compressed block into an uncompressed block).

This patch adds additional sanity checks to detect this, and the
following corruption.

1. It checks against corruption of the ids count.  This can either
   lead to a larger table to be read, or a smaller than expected
   table to be read.

   In the case of a too large ids count, this would often have been
   trapped by the existing sanity checks, but this patch introduces
   a more exact check, which can identify too small values.

2. It checks the contents of the index table for corruption.

Link: https://lkml.kernel.org/r/20210204130249.4495-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+b06d57ba83f604522af2@syzkaller.appspotmail.com
Reported-by: syzbot+c021ba012da41ee9807c@syzkaller.appspotmail.com
Reported-by: syzbot+5024636e8b5fd19f0f19@syzkaller.appspotmail.com
Reported-by: syzbot+bcbc661df46657d0fa4f@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/id.c             |   40 ++++++++++++++++++++++++++++++++--------
 fs/squashfs/squashfs_fs_sb.h |    1 +
 fs/squashfs/super.c          |    6 +++---
 fs/squashfs/xattr.h          |   10 +++++++++-
 4 files changed, 45 insertions(+), 12 deletions(-)

--- a/fs/squashfs/id.c
+++ b/fs/squashfs/id.c
@@ -48,10 +48,15 @@ int squashfs_get_id(struct super_block *
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block = SQUASHFS_ID_BLOCK(index);
 	int offset = SQUASHFS_ID_BLOCK_OFFSET(index);
-	u64 start_block = le64_to_cpu(msblk->id_table[block]);
+	u64 start_block;
 	__le32 disk_id;
 	int err;
 
+	if (index >= msblk->ids)
+		return -EINVAL;
+
+	start_block = le64_to_cpu(msblk->id_table[block]);
+
 	err = squashfs_read_metadata(sb, &disk_id, &start_block, &offset,
 							sizeof(disk_id));
 	if (err < 0)
@@ -69,7 +74,10 @@ __le64 *squashfs_read_id_index_table(str
 		u64 id_table_start, u64 next_table, unsigned short no_ids)
 {
 	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
+	unsigned int indexes = SQUASHFS_ID_BLOCKS(no_ids);
+	int n;
 	__le64 *table;
+	u64 start, end;
 
 	TRACE("In read_id_index_table, length %d\n", length);
 
@@ -80,20 +88,36 @@ __le64 *squashfs_read_id_index_table(str
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * length bytes should not extend into the next table - this check
-	 * also traps instances where id_table_start is incorrectly larger
-	 * than the next table start
+	 * The computed size of the index table (length bytes) should exactly
+	 * match the table start and end points
 	 */
-	if (id_table_start + length > next_table)
+	if (length != (next_table - id_table_start))
 		return ERR_PTR(-EINVAL);
 
 	table = squashfs_read_table(sb, id_table_start, length);
+	if (IS_ERR(table))
+		return table;
 
 	/*
-	 * table[0] points to the first id lookup table metadata block, this
-	 * should be less than id_table_start
+	 * table[0], table[1], ... table[indexes - 1] store the locations
+	 * of the compressed id blocks.   Each entry should be less than
+	 * the next (i.e. table[0] < table[1]), and the difference between them
+	 * should be SQUASHFS_METADATA_SIZE or less.  table[indexes - 1]
+	 * should be less than id_table_start, and again the difference
+	 * should be SQUASHFS_METADATA_SIZE or less
 	 */
-	if (!IS_ERR(table) && le64_to_cpu(table[0]) >= id_table_start) {
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
+	if (start >= id_table_start || (id_table_start - start) > SQUASHFS_METADATA_SIZE) {
 		kfree(table);
 		return ERR_PTR(-EINVAL);
 	}
--- a/fs/squashfs/squashfs_fs_sb.h
+++ b/fs/squashfs/squashfs_fs_sb.h
@@ -77,5 +77,6 @@ struct squashfs_sb_info {
 	unsigned int				inodes;
 	unsigned int				fragments;
 	int					xattr_ids;
+	unsigned int				ids;
 };
 #endif
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -176,6 +176,7 @@ static int squashfs_fill_super(struct su
 	msblk->directory_table = le64_to_cpu(sblk->directory_table_start);
 	msblk->inodes = le32_to_cpu(sblk->inodes);
 	msblk->fragments = le32_to_cpu(sblk->fragments);
+	msblk->ids = le16_to_cpu(sblk->no_ids);
 	flags = le16_to_cpu(sblk->flags);
 
 	TRACE("Found valid superblock on %pg\n", sb->s_bdev);
@@ -187,7 +188,7 @@ static int squashfs_fill_super(struct su
 	TRACE("Block size %d\n", msblk->block_size);
 	TRACE("Number of inodes %d\n", msblk->inodes);
 	TRACE("Number of fragments %d\n", msblk->fragments);
-	TRACE("Number of ids %d\n", le16_to_cpu(sblk->no_ids));
+	TRACE("Number of ids %d\n", msblk->ids);
 	TRACE("sblk->inode_table_start %llx\n", msblk->inode_table);
 	TRACE("sblk->directory_table_start %llx\n", msblk->directory_table);
 	TRACE("sblk->fragment_table_start %llx\n",
@@ -244,8 +245,7 @@ static int squashfs_fill_super(struct su
 allocate_id_index_table:
 	/* Allocate and read id index table */
 	msblk->id_table = squashfs_read_id_index_table(sb,
-		le64_to_cpu(sblk->id_table_start), next_table,
-		le16_to_cpu(sblk->no_ids));
+		le64_to_cpu(sblk->id_table_start), next_table, msblk->ids);
 	if (IS_ERR(msblk->id_table)) {
 		ERROR("unable to read id index table\n");
 		err = PTR_ERR(msblk->id_table);
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -30,8 +30,16 @@ extern int squashfs_xattr_lookup(struct
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, int *xattr_ids)
 {
+	struct squashfs_xattr_id_table *id_table;
+
+	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
+	if (IS_ERR(id_table))
+		return (__le64 *) id_table;
+
+	*xattr_table_start = le64_to_cpu(id_table->xattr_table_start);
+	kfree(id_table);
+
 	ERROR("Xattrs in filesystem, these will be ignored\n");
-	*xattr_table_start = start;
 	return ERR_PTR(-ENOTSUPP);
 }
 


