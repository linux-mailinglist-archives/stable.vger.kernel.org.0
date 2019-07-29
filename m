Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40967798C4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbfG2UK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 16:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388434AbfG2Tef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 108ED2070B;
        Mon, 29 Jul 2019 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428873;
        bh=rKgG8ym8zReOiunIK9uNJ3w/5eypGJN1hEPXU3m7NDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEbB3eTozp+PuNbcn8kz2ASpEUEwyV7Q6rFd+zOCEIbUSDM3o/TosvcFy5KtV8mnd
         ygXG8MicpKj9touJ0nH+LLYqAoXvYDs6GKU0JmPDzC77bCGGdteq7IdOcgQppyb9We
         DxJFwytQU0VlhkSlMH/fDGZ1pgf1xlpAg9fZRGTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.14 213/293] ext4: allow directory holes
Date:   Mon, 29 Jul 2019 21:21:44 +0200
Message-Id: <20190729190840.796313703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 4e19d6b65fb4fc42e352ce9883649e049da14743 upstream.

The largedir feature was intended to allow ext4 directories to have
unmapped directory blocks (e.g., directory holes).  And so the
released e2fsprogs no longer enforces this for largedir file systems;
however, the corresponding change to the kernel-side code was not made.

This commit fixes this oversight.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/dir.c   |   19 +++++++++----------
 fs/ext4/namei.c |   45 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 18 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -107,7 +107,6 @@ static int ext4_readdir(struct file *fil
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh = NULL;
-	int dir_has_error = 0;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
 
 	if (ext4_encrypted_inode(inode)) {
@@ -143,8 +142,6 @@ static int ext4_readdir(struct file *fil
 			return err;
 	}
 
-	offset = ctx->pos & (sb->s_blocksize - 1);
-
 	while (ctx->pos < inode->i_size) {
 		struct ext4_map_blocks map;
 
@@ -153,9 +150,18 @@ static int ext4_readdir(struct file *fil
 			goto errout;
 		}
 		cond_resched();
+		offset = ctx->pos & (sb->s_blocksize - 1);
 		map.m_lblk = ctx->pos >> EXT4_BLOCK_SIZE_BITS(sb);
 		map.m_len = 1;
 		err = ext4_map_blocks(NULL, inode, &map, 0);
+		if (err == 0) {
+			/* m_len should never be zero but let's avoid
+			 * an infinite loop if it somehow is */
+			if (map.m_len == 0)
+				map.m_len = 1;
+			ctx->pos += map.m_len * sb->s_blocksize;
+			continue;
+		}
 		if (err > 0) {
 			pgoff_t index = map.m_pblk >>
 					(PAGE_SHIFT - inode->i_blkbits);
@@ -174,13 +180,6 @@ static int ext4_readdir(struct file *fil
 		}
 
 		if (!bh) {
-			if (!dir_has_error) {
-				EXT4_ERROR_FILE(file, 0,
-						"directory contains a "
-						"hole at offset %llu",
-					   (unsigned long long) ctx->pos);
-				dir_has_error = 1;
-			}
 			/* corrupt size?  Maybe no more blocks to read */
 			if (ctx->pos > inode->i_blocks << 9)
 				break;
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -80,8 +80,18 @@ static struct buffer_head *ext4_append(h
 static int ext4_dx_csum_verify(struct inode *inode,
 			       struct ext4_dir_entry *dirent);
 
+/*
+ * Hints to ext4_read_dirblock regarding whether we expect a directory
+ * block being read to be an index block, or a block containing
+ * directory entries (and if the latter, whether it was found via a
+ * logical block in an htree index block).  This is used to control
+ * what sort of sanity checkinig ext4_read_dirblock() will do on the
+ * directory block read from the storage device.  EITHER will means
+ * the caller doesn't know what kind of directory block will be read,
+ * so no specific verification will be done.
+ */
 typedef enum {
-	EITHER, INDEX, DIRENT
+	EITHER, INDEX, DIRENT, DIRENT_HTREE
 } dirblock_type_t;
 
 #define ext4_read_dirblock(inode, block, type) \
@@ -107,11 +117,14 @@ static struct buffer_head *__ext4_read_d
 
 		return bh;
 	}
-	if (!bh) {
+	if (!bh && (type == INDEX || type == DIRENT_HTREE)) {
 		ext4_error_inode(inode, func, line, block,
-				 "Directory hole found");
+				 "Directory hole found for htree %s block",
+				 (type == INDEX) ? "index" : "leaf");
 		return ERR_PTR(-EFSCORRUPTED);
 	}
+	if (!bh)
+		return NULL;
 	dirent = (struct ext4_dir_entry *) bh->b_data;
 	/* Determine whether or not we have an index block */
 	if (is_dx(inode)) {
@@ -978,7 +991,7 @@ static int htree_dirblock_to_tree(struct
 
 	dxtrace(printk(KERN_INFO "In htree dirblock_to_tree: block %lu\n",
 							(unsigned long)block));
-	bh = ext4_read_dirblock(dir, block, DIRENT);
+	bh = ext4_read_dirblock(dir, block, DIRENT_HTREE);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 
@@ -1508,7 +1521,7 @@ static struct buffer_head * ext4_dx_find
 		return (struct buffer_head *) frame;
 	do {
 		block = dx_get_block(frame->at);
-		bh = ext4_read_dirblock(dir, block, DIRENT);
+		bh = ext4_read_dirblock(dir, block, DIRENT_HTREE);
 		if (IS_ERR(bh))
 			goto errout;
 
@@ -2088,6 +2101,11 @@ static int ext4_add_entry(handle_t *hand
 	blocks = dir->i_size >> sb->s_blocksize_bits;
 	for (block = 0; block < blocks; block++) {
 		bh = ext4_read_dirblock(dir, block, DIRENT);
+		if (bh == NULL) {
+			bh = ext4_bread(handle, dir, block,
+					EXT4_GET_BLOCKS_CREATE);
+			goto add_to_new_block;
+		}
 		if (IS_ERR(bh)) {
 			retval = PTR_ERR(bh);
 			bh = NULL;
@@ -2108,6 +2126,7 @@ static int ext4_add_entry(handle_t *hand
 		brelse(bh);
 	}
 	bh = ext4_append(handle, dir, &block);
+add_to_new_block:
 	if (IS_ERR(bh)) {
 		retval = PTR_ERR(bh);
 		bh = NULL;
@@ -2152,7 +2171,7 @@ again:
 		return PTR_ERR(frame);
 	entries = frame->entries;
 	at = frame->at;
-	bh = ext4_read_dirblock(dir, dx_get_block(frame->at), DIRENT);
+	bh = ext4_read_dirblock(dir, dx_get_block(frame->at), DIRENT_HTREE);
 	if (IS_ERR(bh)) {
 		err = PTR_ERR(bh);
 		bh = NULL;
@@ -2700,7 +2719,10 @@ bool ext4_empty_dir(struct inode *inode)
 		EXT4_ERROR_INODE(inode, "invalid size");
 		return true;
 	}
-	bh = ext4_read_dirblock(inode, 0, EITHER);
+	/* The first directory block must not be a hole,
+	 * so treat it as DIRENT_HTREE
+	 */
+	bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
 	if (IS_ERR(bh))
 		return true;
 
@@ -2722,6 +2744,10 @@ bool ext4_empty_dir(struct inode *inode)
 			brelse(bh);
 			lblock = offset >> EXT4_BLOCK_SIZE_BITS(sb);
 			bh = ext4_read_dirblock(inode, lblock, EITHER);
+			if (bh == NULL) {
+				offset += sb->s_blocksize;
+				continue;
+			}
 			if (IS_ERR(bh))
 				return true;
 			de = (struct ext4_dir_entry_2 *) bh->b_data;
@@ -3292,7 +3318,10 @@ static struct buffer_head *ext4_get_firs
 	struct buffer_head *bh;
 
 	if (!ext4_has_inline_data(inode)) {
-		bh = ext4_read_dirblock(inode, 0, EITHER);
+		/* The first directory block must not be a hole, so
+		 * treat it as DIRENT_HTREE
+		 */
+		bh = ext4_read_dirblock(inode, 0, DIRENT_HTREE);
 		if (IS_ERR(bh)) {
 			*retval = PTR_ERR(bh);
 			return NULL;


