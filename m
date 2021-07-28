Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1D13D85AF
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 03:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbhG1Bwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 21:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhG1Bwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 21:52:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C81A2601FF;
        Wed, 28 Jul 2021 01:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627437164;
        bh=bZebbcvnXhR5JIU5tUHxuvey9bFsVigx8iGinyfrMx8=;
        h=From:To:Cc:Subject:Date:From;
        b=PQrN3JG+y/WeffBreyMFAws4OuNvbiwN8RgJa+TIqW6JHrDVlwAluX2IUC63VMcph
         dmTe6DWZojACuOvg+7OMlvpSddIs5/EDMj48fd3iDMJA8qT0r08NevFzkaK0KGb1AZ
         ou6HVU0xf26qae/yVTo0UX4oERqUZlYiwQz7BN0D16RsJvIX3kkYY+CNeLf3doP5sO
         f9G9Y2wZHkdmt/zeWYoZomqQQaHidvxHwO+o29dUGnFXEWH7z5QCAqNZqm/38vk7ox
         WDXn1wCZJOXHVJRWX8ybszk0FsywQPR+rff9bOSPKCzcAdLvSUuMgnDGUojIAh9bSi
         gcyflowv0pbkA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] f2fs: remove broken support for allocating DIO writes
Date:   Tue, 27 Jul 2021 18:51:54 -0700
Message-Id: <20210728015154.171507-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
they require preallocating blocks, but f2fs doesn't support unwritten
blocks and therefore has to preallocate the blocks as regular blocks.
f2fs has no way to reliably roll back such preallocations, so as a
result, f2fs will leak uninitialized blocks to users if a DIO write
doesn't fully complete.  This can be easily reproduced by issuing a DIO
write that will fail due to misalignment, e.g.:

	rm -f file
	truncate -s 1000000 file
	dd if=/dev/zero bs=999999 oflag=direct conv=notrunc of=file
	od -tx1 file  # shows uninitialized disk blocks

Until a proper design for non-overwrite DIO writes on f2fs can be
designed and implemented, remove support for them and make them fall
back to buffered I/O.  This is what other filesystems that don't support
unwritten blocks, e.g. ext2, also do, at least for non-extending DIO
writes.  However, f2fs can't do extending DIO writes either, as f2fs
appears to have no mechanism for guaranteeing that leftover allocated
blocks past EOF will get truncated.  (f2fs does have an orphan list, but
it's only used for deleting inodes, not truncating them.)

This patch doesn't attempt to remove the F2FS_GET_BLOCK_{DIO,PRE_DIO}
cases in f2fs_map_blocks(); that can be cleaned up later.

Fixes: bfad7c2d4033 ("f2fs: introduce a new direct_IO write path")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This applies to the latest f2fs.git#dev branch.

 fs/f2fs/data.c | 82 +++++++++++---------------------------------------
 fs/f2fs/f2fs.h | 24 +++++----------
 fs/f2fs/file.c | 11 ++-----
 3 files changed, 28 insertions(+), 89 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index cb71d7317ad2..756b2277bf1b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1374,9 +1374,7 @@ int f2fs_preallocate_blocks(struct kiocb *iocb, struct iov_iter *from)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct f2fs_map_blocks map;
-	int flag;
 	int err = 0;
-	bool direct_io = iocb->ki_flags & IOCB_DIRECT;
 
 	map.m_lblk = F2FS_BLK_ALIGN(iocb->ki_pos);
 	map.m_len = F2FS_BYTES_TO_BLK(iocb->ki_pos + iov_iter_count(from));
@@ -1390,13 +1388,6 @@ int f2fs_preallocate_blocks(struct kiocb *iocb, struct iov_iter *from)
 	map.m_seg_type = NO_CHECK_TYPE;
 	map.m_may_create = true;
 
-	if (direct_io) {
-		map.m_seg_type = f2fs_rw_hint_to_seg_type(iocb->ki_hint);
-		flag = f2fs_force_buffered_io(inode, iocb, from) ?
-					F2FS_GET_BLOCK_PRE_AIO :
-					F2FS_GET_BLOCK_PRE_DIO;
-		goto map_blocks;
-	}
 	if (iocb->ki_pos + iov_iter_count(from) > MAX_INLINE_DATA(inode)) {
 		err = f2fs_convert_inline_inode(inode);
 		if (err)
@@ -1405,13 +1396,9 @@ int f2fs_preallocate_blocks(struct kiocb *iocb, struct iov_iter *from)
 	if (f2fs_has_inline_data(inode))
 		return err;
 
-	flag = F2FS_GET_BLOCK_PRE_AIO;
-
-map_blocks:
-	err = f2fs_map_blocks(inode, &map, 1, flag);
+	err = f2fs_map_blocks(inode, &map, 1, F2FS_GET_BLOCK_PRE_AIO);
 	if (map.m_len > 0 && err == -ENOSPC) {
-		if (!direct_io)
-			set_inode_flag(inode, FI_NO_PREALLOC);
+		set_inode_flag(inode, FI_NO_PREALLOC);
 		err = 0;
 	}
 	return err;
@@ -1701,47 +1688,30 @@ static inline u64 blks_to_bytes(struct inode *inode, u64 blks)
 	return (blks << inode->i_blkbits);
 }
 
-static int __get_data_block(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh, int create, int flag,
-			pgoff_t *next_pgofs, int seg_type, bool may_write)
+static int get_data_block_dio(struct inode *inode, sector_t iblock,
+			      struct buffer_head *bh, int create)
 {
-	struct f2fs_map_blocks map;
+	struct f2fs_map_blocks map = {
+		.m_lblk = iblock,
+		.m_len = bytes_to_blks(inode, bh->b_size),
+	};
 	int err;
 
-	map.m_lblk = iblock;
-	map.m_len = bytes_to_blks(inode, bh->b_size);
-	map.m_next_pgofs = next_pgofs;
-	map.m_next_extent = NULL;
-	map.m_seg_type = seg_type;
-	map.m_may_create = may_write;
-
-	err = f2fs_map_blocks(inode, &map, create, flag);
+	/*
+	 * We don't allocate blocks here, as that would expose uninitialized
+	 * blocks if the DIO write doesn't fully complete.  DIO writes that need
+	 * to allocate blocks will fall back to buffered writes.
+	 */
+	err = f2fs_map_blocks(inode, &map, 0, F2FS_GET_BLOCK_DEFAULT);
 	if (!err) {
-		map_bh(bh, inode->i_sb, map.m_pblk);
+		if (map.m_flags & F2FS_MAP_MAPPED)
+			map_bh(bh, inode->i_sb, map.m_pblk);
 		bh->b_state = (bh->b_state & ~F2FS_MAP_FLAGS) | map.m_flags;
 		bh->b_size = blks_to_bytes(inode, map.m_len);
 	}
 	return err;
 }
 
-static int get_data_block_dio_write(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create)
-{
-	return __get_data_block(inode, iblock, bh_result, create,
-				F2FS_GET_BLOCK_DIO, NULL,
-				f2fs_rw_hint_to_seg_type(inode->i_write_hint),
-				true);
-}
-
-static int get_data_block_dio(struct inode *inode, sector_t iblock,
-			struct buffer_head *bh_result, int create)
-{
-	return __get_data_block(inode, iblock, bh_result, create,
-				F2FS_GET_BLOCK_DIO, NULL,
-				f2fs_rw_hint_to_seg_type(inode->i_write_hint),
-				false);
-}
-
 static int f2fs_xattr_fiemap(struct inode *inode,
 				struct fiemap_extent_info *fieinfo)
 {
@@ -3556,7 +3526,6 @@ static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	int err;
 	enum rw_hint hint = iocb->ki_hint;
 	int whint_mode = F2FS_OPTION(sbi).whint_mode;
-	bool do_opu;
 
 	err = check_direct_IO(inode, iter, offset);
 	if (err)
@@ -3565,8 +3534,6 @@ static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (f2fs_force_buffered_io(inode, iocb, iter))
 		return 0;
 
-	do_opu = rw == WRITE && f2fs_lfs_mode(sbi);
-
 	trace_f2fs_direct_IO_enter(inode, offset, count, rw);
 
 	if (rw == WRITE && whint_mode == WHINT_MODE_OFF)
@@ -3578,27 +3545,15 @@ static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			err = -EAGAIN;
 			goto out;
 		}
-		if (do_opu && !down_read_trylock(&fi->i_gc_rwsem[READ])) {
-			up_read(&fi->i_gc_rwsem[rw]);
-			iocb->ki_hint = hint;
-			err = -EAGAIN;
-			goto out;
-		}
 	} else {
 		down_read(&fi->i_gc_rwsem[rw]);
-		if (do_opu)
-			down_read(&fi->i_gc_rwsem[READ]);
 	}
 
 	err = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
-			iter, rw == WRITE ? get_data_block_dio_write :
-			get_data_block_dio, NULL, f2fs_dio_submit_bio,
+			iter, get_data_block_dio, NULL, f2fs_dio_submit_bio,
 			rw == WRITE ? DIO_LOCKING | DIO_SKIP_HOLES :
 			DIO_SKIP_HOLES);
 
-	if (do_opu)
-		up_read(&fi->i_gc_rwsem[READ]);
-
 	up_read(&fi->i_gc_rwsem[rw]);
 
 	if (rw == WRITE) {
@@ -3607,8 +3562,7 @@ static ssize_t f2fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		if (err > 0) {
 			f2fs_update_iostat(F2FS_I_SB(inode), APP_DIRECT_IO,
 									err);
-			if (!do_opu)
-				set_inode_flag(inode, FI_UPDATE_WRITE);
+			set_inode_flag(inode, FI_UPDATE_WRITE);
 		} else if (err == -EIOCBQUEUED) {
 			f2fs_update_iostat(F2FS_I_SB(inode), APP_DIRECT_IO,
 						count - iov_iter_count(iter));
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 5d16486feb8f..c99756a6ff5f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4302,17 +4302,6 @@ static inline void f2fs_i_compr_blocks_update(struct inode *inode,
 	f2fs_mark_inode_dirty_sync(inode, true);
 }
 
-static inline int block_unaligned_IO(struct inode *inode,
-				struct kiocb *iocb, struct iov_iter *iter)
-{
-	unsigned int i_blkbits = READ_ONCE(inode->i_blkbits);
-	unsigned int blocksize_mask = (1 << i_blkbits) - 1;
-	loff_t offset = iocb->ki_pos;
-	unsigned long align = offset | iov_iter_alignment(iter);
-
-	return align & blocksize_mask;
-}
-
 static inline bool f2fs_force_buffered_io(struct inode *inode,
 				struct kiocb *iocb, struct iov_iter *iter)
 {
@@ -4329,12 +4318,13 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	 */
 	if (f2fs_sb_has_blkzoned(sbi))
 		return true;
-	if (f2fs_lfs_mode(sbi) && (rw == WRITE)) {
-		if (block_unaligned_IO(inode, iocb, iter))
-			return true;
-		if (F2FS_IO_ALIGNED(sbi))
-			return true;
-	}
+	/*
+	 * DIO writes in LFS mode would require preallocating blocks, which is
+	 * hard to do without exposing uninitialized blocks after short writes.
+	 */
+	if (f2fs_lfs_mode(sbi) && rw == WRITE)
+		return true;
+
 	if (is_sbi_flag_set(F2FS_I_SB(inode), SBI_CP_DISABLED))
 		return true;
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f335d38efc76..745672ab5a2a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4287,14 +4287,9 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			err = f2fs_convert_inline_inode(inode);
 			if (err)
 				goto out_err;
-			/*
-			 * If force_buffere_io() is true, we have to allocate
-			 * blocks all the time, since f2fs_direct_IO will fall
-			 * back to buffered IO.
-			 */
-			if (!f2fs_force_buffered_io(inode, iocb, from) &&
-					f2fs_lfs_mode(F2FS_I_SB(inode)))
-				goto write;
+
+			set_inode_flag(inode, FI_NO_PREALLOC);
+			goto write;
 		}
 		preallocated = true;
 		target_size = iocb->ki_pos + iov_iter_count(from);

base-commit: 08b8de81abe13b595120973b3089c4958e3ff2da
-- 
2.32.0

