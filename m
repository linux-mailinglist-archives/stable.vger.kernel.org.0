Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE55632179A
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhBVMvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:51:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231138AbhBVMrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:47:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98A3E64F5E;
        Mon, 22 Feb 2021 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613997736;
        bh=M7tf0YXjwh9g467iZNihXYU2nRWQ8SxGzo/8yqj+BoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jo5DBXV2YAtUU/pYqdU2rCbdmosFYCmnuKmrRfIoHIRJMVrm7zF4NtUdFi+HX0EYk
         NAlazJhztpd49W4UExUDic9BopbTpdmQaKqM1rsDR154DVDkOFhIAUH4JaSkkFITo4
         4JlKMpyZfK89e0W9xze9uI9C4g4bo5ZZL3hLHgKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phillip Lougher <phillip@squashfs.org.uk>,
        syzbot+2ccea6339d368360800d@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 18/49] squashfs: add more sanity checks in xattr id lookup
Date:   Mon, 22 Feb 2021 13:36:16 +0100
Message-Id: <20210222121026.251570362@linuxfoundation.org>
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

commit 506220d2ba21791314af569211ffd8870b8208fa upstream.

Sysbot has reported a warning where a kmalloc() attempt exceeds the
maximum limit.  This has been identified as corruption of the xattr_ids
count when reading the xattr id lookup table.

This patch adds a number of additional sanity checks to detect this
corruption and others.

1. It checks for a corrupted xattr index read from the inode.  This could
   be because the metadata block is uncompressed, or because the
   "compression" bit has been corrupted (turning a compressed block
   into an uncompressed block).  This would cause an out of bounds read.

2. It checks against corruption of the xattr_ids count.  This can either
   lead to the above kmalloc failure, or a smaller than expected
   table to be read.

3. It checks the contents of the index table for corruption.

[phillip@squashfs.org.uk: fix checkpatch issue]
  Link: https://lkml.kernel.org/r/270245655.754655.1612770082682@webmail.123-reg.co.uk

Link: https://lkml.kernel.org/r/20210204130249.4495-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+2ccea6339d368360800d@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/squashfs/xattr_id.c |   66 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -44,10 +44,15 @@ int squashfs_xattr_lookup(struct super_b
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block = SQUASHFS_XATTR_BLOCK(index);
 	int offset = SQUASHFS_XATTR_BLOCK_OFFSET(index);
-	u64 start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+	u64 start_block;
 	struct squashfs_xattr_id id;
 	int err;
 
+	if (index >= msblk->xattr_ids)
+		return -EINVAL;
+
+	start_block = le64_to_cpu(msblk->xattr_id_table[block]);
+
 	err = squashfs_read_metadata(sb, &id, &start_block, &offset,
 							sizeof(id));
 	if (err < 0)
@@ -63,13 +68,17 @@ int squashfs_xattr_lookup(struct super_b
 /*
  * Read uncompressed xattr id lookup table indexes from disk into memory
  */
-__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 start,
+__le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 		u64 *xattr_table_start, int *xattr_ids)
 {
-	unsigned int len;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	unsigned int len, indexes;
 	struct squashfs_xattr_id_table *id_table;
+	__le64 *table;
+	u64 start, end;
+	int n;
 
-	id_table = squashfs_read_table(sb, start, sizeof(*id_table));
+	id_table = squashfs_read_table(sb, table_start, sizeof(*id_table));
 	if (IS_ERR(id_table))
 		return (__le64 *) id_table;
 
@@ -83,13 +92,52 @@ __le64 *squashfs_read_xattr_id_table(str
 	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
-	/* xattr_table should be less than start */
-	if (*xattr_table_start >= start)
+	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
+	indexes = SQUASHFS_XATTR_BLOCKS(*xattr_ids);
+
+	/*
+	 * The computed size of the index table (len bytes) should exactly
+	 * match the table start and end points
+	 */
+	start = table_start + sizeof(*id_table);
+	end = msblk->bytes_used;
+
+	if (len != (end - start))
 		return ERR_PTR(-EINVAL);
 
-	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
+	table = squashfs_read_table(sb, start, len);
+	if (IS_ERR(table))
+		return table;
+
+	/* table[0], table[1], ... table[indexes - 1] store the locations
+	 * of the compressed xattr id blocks.  Each entry should be less than
+	 * the next (i.e. table[0] < table[1]), and the difference between them
+	 * should be SQUASHFS_METADATA_SIZE or less.  table[indexes - 1]
+	 * should be less than table_start, and again the difference
+	 * shouls be SQUASHFS_METADATA_SIZE or less.
+	 *
+	 * Finally xattr_table_start should be less than table[0].
+	 */
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
+	if (start >= table_start || (table_start - start) > SQUASHFS_METADATA_SIZE) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
 
-	TRACE("In read_xattr_index_table, length %d\n", len);
+	if (*xattr_table_start >= le64_to_cpu(table[0])) {
+		kfree(table);
+		return ERR_PTR(-EINVAL);
+	}
 
-	return squashfs_read_table(sb, start + sizeof(*id_table), len);
+	return table;
 }


