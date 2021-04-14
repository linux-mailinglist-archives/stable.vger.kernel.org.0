Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3EE35F121
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhDNKAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Apr 2021 06:00:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:41572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhDNKAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Apr 2021 06:00:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7E29AED7;
        Wed, 14 Apr 2021 09:59:45 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 7EFBD1F2B5F; Wed, 14 Apr 2021 11:59:45 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Eric Whitney <enwlinux@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] ext4: Fix occasional generic/418 failure
Date:   Wed, 14 Apr 2021 11:59:35 +0200
Message-Id: <20210414095935.30521-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric has noticed that after pagecache read rework, generic/418 is
occasionally failing for ext4 when blocksize < pagesize. In fact, the
pagecache rework just made hard to hit race in ext4 more likely. The
problem is that since ext4 conversion of direct IO writes to iomap
framework (commit 378f32bab371), we update inode size after direct IO
write only after invalidating page cache. Thus if buffered read sneaks
at unfortunate moment like:

CPU1 - write at offset 1k                       CPU2 - read from offset 0
iomap_dio_rw(..., IOMAP_DIO_FORCE_WAIT);
                                                ext4_readpage();
ext4_handle_inode_extension()

the read will zero out tail of the page as it still sees smaller inode
size and thus page cache becomes inconsistent with on-disk contents with
all the consequences.

Fix the problem by moving inode size update into end_io handler which
gets called before the page cache is invalidated.

Reported-by: Eric Whitney <enwlinux@gmail.com>
Fixes: 378f32bab371 ("ext4: introduce direct I/O write using iomap infrastructure")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 194 +++++++++++++++++++++++++------------------------
 1 file changed, 98 insertions(+), 96 deletions(-)

Eric, can you please try whether this patch fixes the failures you are
occasionally seeing?

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 194f5d00fa32..2b84fb48bde6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -280,13 +280,66 @@ static ssize_t ext4_buffered_write_iter(struct kiocb *iocb,
 	return ret;
 }
 
-static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
-					   ssize_t written, size_t count)
+static int ext4_prepare_dio_extend(struct inode *inode)
+{
+	handle_t *handle;
+	int ret;
+
+	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
+
+	ext4_fc_start_update(inode);
+	ret = ext4_orphan_add(handle, inode);
+	ext4_fc_stop_update(inode);
+	if (ret) {
+		ext4_journal_stop(handle);
+		return ret;
+	}
+	ext4_journal_stop(handle);
+	return 0;
+}
+
+static void ext4_cleanup_dio_extend(struct inode *inode, loff_t offset,
+				    ssize_t written, size_t count)
 {
 	handle_t *handle;
-	bool truncate = false;
 	u8 blkbits = inode->i_blkbits;
 	ext4_lblk_t written_blk, end_blk;
+
+	/* Error? Nothing was written... */
+	if (written < 0)
+		written = 0;
+
+	written_blk = ALIGN(offset + written, 1 << blkbits);
+	end_blk = ALIGN(offset + count, 1 << blkbits);
+	if (written_blk < end_blk && ext4_can_truncate(inode)) {
+		ext4_truncate_failed_write(inode);
+		/*
+		 * If the truncate operation failed early, then the inode may
+		 * still be on the orphan list. In that case, we need to try
+		 * remove the inode from the in-memory linked list.
+		 */
+		if (inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+		return;
+	}
+
+	if (!list_empty(&EXT4_I(inode)->i_orphan) && inode->i_nlink) {
+		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
+		if (IS_ERR(handle)) {
+			ext4_orphan_del(NULL, inode);
+			return;
+		}
+		ext4_orphan_del(handle, inode);
+		ext4_journal_stop(handle);
+	}
+}
+
+static int ext4_handle_inode_extension(struct inode *inode, loff_t offset,
+				       ssize_t written)
+{
+	handle_t *handle;
 	int ret;
 
 	/*
@@ -298,74 +351,23 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
 	 * as much as we intended.
 	 */
 	WARN_ON_ONCE(i_size_read(inode) < EXT4_I(inode)->i_disksize);
-	if (offset + count <= EXT4_I(inode)->i_disksize) {
-		/*
-		 * We need to ensure that the inode is removed from the orphan
-		 * list if it has been added prematurely, due to writeback of
-		 * delalloc blocks.
-		 */
-		if (!list_empty(&EXT4_I(inode)->i_orphan) && inode->i_nlink) {
-			handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
-
-			if (IS_ERR(handle)) {
-				ext4_orphan_del(NULL, inode);
-				return PTR_ERR(handle);
-			}
-
-			ext4_orphan_del(handle, inode);
-			ext4_journal_stop(handle);
-		}
-
-		return written;
-	}
-
-	if (written < 0)
-		goto truncate;
+	if (offset + written <= EXT4_I(inode)->i_disksize)
+		return 0;
 
 	handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
-	if (IS_ERR(handle)) {
-		written = PTR_ERR(handle);
-		goto truncate;
-	}
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 
 	if (ext4_update_inode_size(inode, offset + written)) {
 		ret = ext4_mark_inode_dirty(handle, inode);
 		if (unlikely(ret)) {
-			written = ret;
 			ext4_journal_stop(handle);
-			goto truncate;
+			return ret;
 		}
 	}
-
-	/*
-	 * We may need to truncate allocated but not written blocks beyond EOF.
-	 */
-	written_blk = ALIGN(offset + written, 1 << blkbits);
-	end_blk = ALIGN(offset + count, 1 << blkbits);
-	if (written_blk < end_blk && ext4_can_truncate(inode))
-		truncate = true;
-
-	/*
-	 * Remove the inode from the orphan list if it has been extended and
-	 * everything went OK.
-	 */
-	if (!truncate && inode->i_nlink)
-		ext4_orphan_del(handle, inode);
 	ext4_journal_stop(handle);
 
-	if (truncate) {
-truncate:
-		ext4_truncate_failed_write(inode);
-		/*
-		 * If the truncate operation failed early, then the inode may
-		 * still be on the orphan list. In that case, we need to try
-		 * remove the inode from the in-memory linked list.
-		 */
-		if (inode->i_nlink)
-			ext4_orphan_del(NULL, inode);
-	}
-
-	return written;
+	return 0;
 }
 
 static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
@@ -380,14 +382,29 @@ static int ext4_dio_write_end_io(struct kiocb *iocb, ssize_t size,
 	if (size && flags & IOMAP_DIO_UNWRITTEN)
 		return ext4_convert_unwritten_extents(NULL, inode,
 						      offset, size);
-
 	return 0;
 }
 
+static int ext4_dio_extending_write_end_io(struct kiocb *iocb, ssize_t size,
+					   int error, unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	int ret;
+
+	ret = ext4_dio_write_end_io(iocb, size, error, flags);
+	if (ret < 0)
+		return ret;
+	return ext4_handle_inode_extension(inode, iocb->ki_pos, size);
+}
+
 static const struct iomap_dio_ops ext4_dio_write_ops = {
 	.end_io = ext4_dio_write_end_io,
 };
 
+static const struct iomap_dio_ops ext4_dio_extending_write_ops = {
+	.end_io = ext4_dio_extending_write_end_io,
+};
+
 /*
  * The intention here is to start with shared lock acquired then see if any
  * condition requires an exclusive inode lock. If yes, then we restart the
@@ -454,11 +471,11 @@ static ssize_t ext4_dio_write_checks(struct kiocb *iocb, struct iov_iter *from,
 static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 {
 	ssize_t ret;
-	handle_t *handle;
 	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
 	size_t count = iov_iter_count(from);
 	const struct iomap_ops *iomap_ops = &ext4_iomap_ops;
+	const struct iomap_dio_ops *dio_ops = &ext4_dio_write_ops;
 	bool extend = false, unaligned_io = false;
 	bool ilock_shared = true;
 
@@ -529,33 +546,21 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_dio_wait(inode);
 
 	if (extend) {
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
-
-		ext4_fc_start_update(inode);
-		ret = ext4_orphan_add(handle, inode);
-		ext4_fc_stop_update(inode);
-		if (ret) {
-			ext4_journal_stop(handle);
+		ret = ext4_prepare_dio_extend(inode);
+		if (ret)
 			goto out;
-		}
-
-		ext4_journal_stop(handle);
+		dio_ops = &ext4_dio_extending_write_ops;
 	}
 
 	if (ilock_shared)
 		iomap_ops = &ext4_iomap_overwrite_ops;
-	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
-			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0);
+
+	ret = iomap_dio_rw(iocb, from, iomap_ops, dio_ops,
+			   (extend || unaligned_io) ? IOMAP_DIO_FORCE_WAIT : 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
-
 	if (extend)
-		ret = ext4_handle_inode_extension(inode, offset, ret, count);
-
+		ext4_cleanup_dio_extend(inode, offset, ret, count);
 out:
 	if (ilock_shared)
 		inode_unlock_shared(inode);
@@ -598,7 +603,6 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	size_t count;
 	loff_t offset;
-	handle_t *handle;
 	bool extend = false;
 	struct inode *inode = file_inode(iocb->ki_filp);
 
@@ -617,26 +621,24 @@ ext4_dax_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	count = iov_iter_count(from);
 
 	if (offset + count > EXT4_I(inode)->i_disksize) {
-		handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
-
-		ret = ext4_orphan_add(handle, inode);
-		if (ret) {
-			ext4_journal_stop(handle);
+		ret = ext4_prepare_dio_extend(inode);
+		if (ret < 0)
 			goto out;
-		}
-
 		extend = true;
-		ext4_journal_stop(handle);
 	}
 
 	ret = dax_iomap_rw(iocb, from, &ext4_iomap_ops);
 
-	if (extend)
-		ret = ext4_handle_inode_extension(inode, offset, ret, count);
+	if (extend) {
+		if (ret > 0) {
+			int ret2;
+
+			ret2 = ext4_handle_inode_extension(inode, offset, ret);
+			if (ret2 < 0)
+				ret = ret2;
+		}
+		ext4_cleanup_dio_extend(inode, offset, ret, count);
+	}
 out:
 	inode_unlock(inode);
 	if (ret > 0)
-- 
2.26.2

