Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6386205D88
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbgFWUOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389197AbgFWUOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9883206C3;
        Tue, 23 Jun 2020 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943260;
        bh=mNA4LqoSKQHXvO6X2q6xzdL8Za34rmDm4vkOyoHWG4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1YWmiJR/JcmI1moVf5yZhLR4WGCHIldPEt2fSW0+D1xTZ+xJMLrvsCIYP9gHtZsjU
         Yp6w7K4Q+deIbwRHBCvHWBZXDvPGajIezaohr2kUrfUbwVZYhRAkyRWF6LCJC3B9Xk
         sqT6bNN41Ijnm581djoF8VqDj6wU1VVXqHON2CSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 322/477] ext4: handle ext4_mark_inode_dirty errors
Date:   Tue, 23 Jun 2020 21:55:19 +0200
Message-Id: <20200623195422.755156607@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshad Shirwadkar <harshadshirwadkar@gmail.com>

[ Upstream commit 4209ae12b12265d475bba28634184423149bd14f ]

ext4_mark_inode_dirty() can fail for real reasons. Ignoring its return
value may lead ext4 to ignore real failures that would result in
corruption / crashes. Harden ext4_mark_inode_dirty error paths to fail
as soon as possible and return errors to the caller whenever
appropriate.

One of the possible scnearios when this bug could affected is that
while creating a new inode, its directory entry gets added
successfully but while writing the inode itself mark_inode_dirty
returns error which is ignored. This would result in inconsistency
that the directory entry points to a non-existent inode.

Ran gce-xfstests smoke tests and verified that there were no
regressions.

Signed-off-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20200427013438.219117-1-harshadshirwadkar@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/acl.c       |  2 +-
 fs/ext4/ext4.h      |  2 +-
 fs/ext4/ext4_jbd2.h |  5 ++-
 fs/ext4/extents.c   | 34 +++++++++++---------
 fs/ext4/file.c      | 11 +++++--
 fs/ext4/indirect.c  |  4 ++-
 fs/ext4/inline.c    |  6 ++--
 fs/ext4/inode.c     | 38 ++++++++++++++++-------
 fs/ext4/migrate.c   | 12 ++++---
 fs/ext4/namei.c     | 76 +++++++++++++++++++++++++++++----------------
 fs/ext4/super.c     | 16 ++++++----
 fs/ext4/xattr.c     |  6 ++--
 12 files changed, 139 insertions(+), 73 deletions(-)

diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
index 8c7bbf3e566de..470be69f19aa3 100644
--- a/fs/ext4/acl.c
+++ b/fs/ext4/acl.c
@@ -256,7 +256,7 @@ retry:
 	if (!error && update_mode) {
 		inode->i_mode = mode;
 		inode->i_ctime = current_time(inode);
-		ext4_mark_inode_dirty(handle, inode);
+		error = ext4_mark_inode_dirty(handle, inode);
 	}
 out_stop:
 	ext4_journal_stop(handle);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ad2dbf6e49245..51a85b50033a7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3354,7 +3354,7 @@ struct ext4_extent;
  */
 #define EXT_MAX_BLOCKS	0xffffffff
 
-extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
+extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 4b9002f0e84c0..3bacf76d26093 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -222,7 +222,10 @@ ext4_mark_iloc_dirty(handle_t *handle,
 int ext4_reserve_inode_write(handle_t *handle, struct inode *inode,
 			struct ext4_iloc *iloc);
 
-int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode);
+#define ext4_mark_inode_dirty(__h, __i)					\
+		__ext4_mark_inode_dirty((__h), (__i), __func__, __LINE__)
+int __ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
+				const char *func, unsigned int line);
 
 int ext4_expand_extra_isize(struct inode *inode,
 			    unsigned int new_extra_isize,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2b4b94542e34d..5148695d520d2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -816,7 +816,7 @@ ext4_ext_binsearch(struct inode *inode,
 
 }
 
-int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
+void ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 {
 	struct ext4_extent_header *eh;
 
@@ -826,7 +826,6 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 	eh->eh_magic = EXT4_EXT_MAGIC;
 	eh->eh_max = cpu_to_le16(ext4_ext_space_root(inode, 0));
 	ext4_mark_inode_dirty(handle, inode);
-	return 0;
 }
 
 struct ext4_ext_path *
@@ -1319,7 +1318,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 		  ext4_idx_pblock(EXT_FIRST_INDEX(neh)));
 
 	le16_add_cpu(&neh->eh_depth, 1);
-	ext4_mark_inode_dirty(handle, inode);
+	err = ext4_mark_inode_dirty(handle, inode);
 out:
 	brelse(bh);
 
@@ -4363,7 +4362,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
 	struct inode *inode = file_inode(file);
 	handle_t *handle;
 	int ret = 0;
-	int ret2 = 0;
+	int ret2 = 0, ret3 = 0;
 	int retries = 0;
 	int depth = 0;
 	struct ext4_map_blocks map;
@@ -4423,10 +4422,11 @@ retry:
 			if (ext4_update_inode_size(inode, epos) & 0x1)
 				inode->i_mtime = inode->i_ctime;
 		}
-		ext4_mark_inode_dirty(handle, inode);
+		ret2 = ext4_mark_inode_dirty(handle, inode);
 		ext4_update_inode_fsync_trans(handle, inode, 1);
-		ret2 = ext4_journal_stop(handle);
-		if (ret2)
+		ret3 = ext4_journal_stop(handle);
+		ret2 = ret3 ? ret3 : ret2;
+		if (unlikely(ret2))
 			break;
 	}
 	if (ret == -ENOSPC &&
@@ -4577,7 +4577,9 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	if (new_size)
 		ext4_update_inode_size(inode, new_size);
-	ext4_mark_inode_dirty(handle, inode);
+	ret = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(ret))
+		goto out_handle;
 
 	/* Zero out partial block at the edges of the range */
 	ret = ext4_zero_partial_blocks(handle, inode, offset, len);
@@ -4587,6 +4589,7 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 	if (file->f_flags & O_SYNC)
 		ext4_handle_sync(handle);
 
+out_handle:
 	ext4_journal_stop(handle);
 out_mutex:
 	inode_unlock(inode);
@@ -4700,8 +4703,7 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 				   loff_t offset, ssize_t len)
 {
 	unsigned int max_blocks;
-	int ret = 0;
-	int ret2 = 0;
+	int ret = 0, ret2 = 0, ret3 = 0;
 	struct ext4_map_blocks map;
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned int credits = 0;
@@ -4734,9 +4736,13 @@ int ext4_convert_unwritten_extents(handle_t *handle, struct inode *inode,
 				     "ext4_ext_map_blocks returned %d",
 				     inode->i_ino, map.m_lblk,
 				     map.m_len, ret);
-		ext4_mark_inode_dirty(handle, inode);
-		if (credits)
-			ret2 = ext4_journal_stop(handle);
+		ret2 = ext4_mark_inode_dirty(handle, inode);
+		if (credits) {
+			ret3 = ext4_journal_stop(handle);
+			if (unlikely(ret3))
+				ret2 = ret3;
+		}
+
 		if (ret <= 0 || ret2)
 			break;
 	}
@@ -5304,7 +5310,7 @@ static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ret = ext4_mark_inode_dirty(handle, inode);
 	ext4_update_inode_fsync_trans(handle, inode, 1);
 
 out_stop:
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 0d624250a62bf..b8e69f9e38587 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -287,6 +287,7 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
 	bool truncate = false;
 	u8 blkbits = inode->i_blkbits;
 	ext4_lblk_t written_blk, end_blk;
+	int ret;
 
 	/*
 	 * Note that EXT4_I(inode)->i_disksize can get extended up to
@@ -327,8 +328,14 @@ static ssize_t ext4_handle_inode_extension(struct inode *inode, loff_t offset,
 		goto truncate;
 	}
 
-	if (ext4_update_inode_size(inode, offset + written))
-		ext4_mark_inode_dirty(handle, inode);
+	if (ext4_update_inode_size(inode, offset + written)) {
+		ret = ext4_mark_inode_dirty(handle, inode);
+		if (unlikely(ret)) {
+			written = ret;
+			ext4_journal_stop(handle);
+			goto truncate;
+		}
+	}
 
 	/*
 	 * We may need to truncate allocated but not written blocks beyond EOF.
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 107f0043f67f1..be2b66eb65f7a 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -467,7 +467,9 @@ static int ext4_splice_branch(handle_t *handle,
 		/*
 		 * OK, we spliced it into the inode itself on a direct block.
 		 */
-		ext4_mark_inode_dirty(handle, ar->inode);
+		err = ext4_mark_inode_dirty(handle, ar->inode);
+		if (unlikely(err))
+			goto err_out;
 		jbd_debug(5, "splicing direct\n");
 	}
 	return err;
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index f35e289e17aa3..c3a1ad2db1227 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1260,7 +1260,7 @@ out:
 int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
 			      struct inode *dir, struct inode *inode)
 {
-	int ret, inline_size, no_expand;
+	int ret, ret2, inline_size, no_expand;
 	void *inline_start;
 	struct ext4_iloc iloc;
 
@@ -1314,7 +1314,9 @@ int ext4_try_add_inline_entry(handle_t *handle, struct ext4_filename *fname,
 
 out:
 	ext4_write_unlock_xattr(dir, &no_expand);
-	ext4_mark_inode_dirty(handle, dir);
+	ret2 = ext4_mark_inode_dirty(handle, dir);
+	if (unlikely(ret2 && !ret))
+		ret = ret2;
 	brelse(iloc.bh);
 	return ret;
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2a4aae6acdcb9..87430d276bccc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1296,7 +1296,7 @@ static int ext4_write_end(struct file *file,
 	 * filesystems.
 	 */
 	if (i_size_changed || inline_data)
-		ext4_mark_inode_dirty(handle, inode);
+		ret = ext4_mark_inode_dirty(handle, inode);
 
 	if (pos + len > inode->i_size && !verity && ext4_can_truncate(inode))
 		/* if we have allocated more blocks and copied
@@ -3077,7 +3077,7 @@ static int ext4_da_write_end(struct file *file,
 			 * new_i_size is less that inode->i_size
 			 * bu greater than i_disksize.(hint delalloc)
 			 */
-			ext4_mark_inode_dirty(handle, inode);
+			ret = ext4_mark_inode_dirty(handle, inode);
 		}
 	}
 
@@ -3094,7 +3094,7 @@ static int ext4_da_write_end(struct file *file,
 	if (ret2 < 0)
 		ret = ret2;
 	ret2 = ext4_journal_stop(handle);
-	if (!ret)
+	if (unlikely(ret2 && !ret))
 		ret = ret2;
 
 	return ret ? ret : copied;
@@ -3886,6 +3886,8 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 				      loff_t len)
 {
 	handle_t *handle;
+	int ret;
+
 	loff_t size = i_size_read(inode);
 
 	WARN_ON(!inode_is_locked(inode));
@@ -3899,10 +3901,10 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 	ext4_update_i_disksize(inode, size);
-	ext4_mark_inode_dirty(handle, inode);
+	ret = ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 
-	return 0;
+	return ret;
 }
 
 static void ext4_wait_dax_page(struct ext4_inode_info *ei)
@@ -3954,7 +3956,7 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	loff_t first_block_offset, last_block_offset;
 	handle_t *handle;
 	unsigned int credits;
-	int ret = 0;
+	int ret = 0, ret2 = 0;
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
@@ -4077,7 +4079,9 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 		ext4_handle_sync(handle);
 
 	inode->i_mtime = inode->i_ctime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	ret2 = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(ret2))
+		ret = ret2;
 	if (ret >= 0)
 		ext4_update_inode_fsync_trans(handle, inode, 1);
 out_stop:
@@ -4146,7 +4150,7 @@ int ext4_truncate(struct inode *inode)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	unsigned int credits;
-	int err = 0;
+	int err = 0, err2;
 	handle_t *handle;
 	struct address_space *mapping = inode->i_mapping;
 
@@ -4234,7 +4238,9 @@ out_stop:
 		ext4_orphan_del(handle, inode);
 
 	inode->i_mtime = inode->i_ctime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	err2 = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(err2 && !err))
+		err = err2;
 	ext4_journal_stop(handle);
 
 	trace_ext4_truncate_exit(inode);
@@ -5292,6 +5298,8 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			inode->i_gid = attr->ia_gid;
 		error = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
+		if (unlikely(error))
+			return error;
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
@@ -5777,7 +5785,8 @@ out_unlock:
  * Whenever the user wants stuff synced (sys_sync, sys_msync, sys_fsync)
  * we start and wait on commits.
  */
-int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
+int __ext4_mark_inode_dirty(handle_t *handle, struct inode *inode,
+				const char *func, unsigned int line)
 {
 	struct ext4_iloc iloc;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -5787,13 +5796,18 @@ int ext4_mark_inode_dirty(handle_t *handle, struct inode *inode)
 	trace_ext4_mark_inode_dirty(inode, _RET_IP_);
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (err)
-		return err;
+		goto out;
 
 	if (EXT4_I(inode)->i_extra_isize < sbi->s_want_extra_isize)
 		ext4_try_to_expand_extra_isize(inode, sbi->s_want_extra_isize,
 					       iloc, handle);
 
-	return ext4_mark_iloc_dirty(handle, inode, &iloc);
+	err = ext4_mark_iloc_dirty(handle, inode, &iloc);
+out:
+	if (unlikely(err))
+		ext4_error_inode_err(inode, func, line, 0, err,
+					"mark_inode_dirty error");
+	return err;
 }
 
 /*
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index fb6520f371355..c5e3fc998211a 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -287,7 +287,7 @@ static int free_ind_block(handle_t *handle, struct inode *inode, __le32 *i_data)
 static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 						struct inode *tmp_inode)
 {
-	int retval;
+	int retval, retval2 = 0;
 	__le32	i_data[3];
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
@@ -342,7 +342,9 @@ static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
 	 * i_blocks when freeing the indirect meta-data blocks
 	 */
 	retval = free_ind_block(handle, inode, i_data);
-	ext4_mark_inode_dirty(handle, inode);
+	retval2 = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(retval2 && !retval))
+		retval = retval2;
 
 err_out:
 	return retval;
@@ -601,7 +603,7 @@ int ext4_ind_migrate(struct inode *inode)
 	ext4_lblk_t			start, end;
 	ext4_fsblk_t			blk;
 	handle_t			*handle;
-	int				ret;
+	int				ret, ret2 = 0;
 
 	if (!ext4_has_feature_extents(inode->i_sb) ||
 	    (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
@@ -655,7 +657,9 @@ int ext4_ind_migrate(struct inode *inode)
 	memset(ei->i_data, 0, sizeof(ei->i_data));
 	for (i = start; i <= end; i++)
 		ei->i_data[i] = cpu_to_le32(blk++);
-	ext4_mark_inode_dirty(handle, inode);
+	ret2 = ext4_mark_inode_dirty(handle, inode);
+	if (unlikely(ret2 && !ret))
+		ret = ret2;
 errout:
 	ext4_journal_stop(handle);
 	up_write(&EXT4_I(inode)->i_data_sem);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a8aca4772aaa7..56738b538ddf4 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1993,7 +1993,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 {
 	unsigned int	blocksize = dir->i_sb->s_blocksize;
 	int		csum_size = 0;
-	int		err;
+	int		err, err2;
 
 	if (ext4_has_metadata_csum(inode->i_sb))
 		csum_size = sizeof(struct ext4_dir_entry_tail);
@@ -2028,12 +2028,12 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ext4_update_dx_flag(dir);
 	inode_inc_iversion(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	err2 = ext4_mark_inode_dirty(handle, dir);
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_dirblock(handle, dir, bh);
 	if (err)
 		ext4_std_error(dir->i_sb, err);
-	return 0;
+	return err ? err : err2;
 }
 
 /*
@@ -2223,7 +2223,9 @@ static int ext4_add_entry(handle_t *handle, struct dentry *dentry,
 		}
 		ext4_clear_inode_flag(dir, EXT4_INODE_INDEX);
 		dx_fallback++;
-		ext4_mark_inode_dirty(handle, dir);
+		retval = ext4_mark_inode_dirty(handle, dir);
+		if (unlikely(retval))
+			goto out;
 	}
 	blocks = dir->i_size >> sb->s_blocksize_bits;
 	for (block = 0; block < blocks; block++) {
@@ -2576,12 +2578,12 @@ static int ext4_add_nondir(handle_t *handle,
 	struct inode *inode = *inodep;
 	int err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
-		ext4_mark_inode_dirty(handle, inode);
+		err = ext4_mark_inode_dirty(handle, inode);
 		if (IS_DIRSYNC(dir))
 			ext4_handle_sync(handle);
 		d_instantiate_new(dentry, inode);
 		*inodep = NULL;
-		return 0;
+		return err;
 	}
 	drop_nlink(inode);
 	ext4_orphan_add(handle, inode);
@@ -2775,7 +2777,7 @@ static int ext4_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	handle_t *handle;
 	struct inode *inode;
-	int err, credits, retries = 0;
+	int err, err2 = 0, credits, retries = 0;
 
 	if (EXT4_DIR_LINK_MAX(dir))
 		return -EMLINK;
@@ -2808,7 +2810,9 @@ out_clear_inode:
 		clear_nlink(inode);
 		ext4_orphan_add(handle, inode);
 		unlock_new_inode(inode);
-		ext4_mark_inode_dirty(handle, inode);
+		err2 = ext4_mark_inode_dirty(handle, inode);
+		if (unlikely(err2))
+			err = err2;
 		ext4_journal_stop(handle);
 		iput(inode);
 		goto out_retry;
@@ -3148,10 +3152,12 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	inode->i_size = 0;
 	ext4_orphan_add(handle, inode);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	retval = ext4_mark_inode_dirty(handle, inode);
+	if (retval)
+		goto end_rmdir;
 	ext4_dec_count(handle, dir);
 	ext4_update_dx_flag(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	retval = ext4_mark_inode_dirty(handle, dir);
 
 #ifdef CONFIG_UNICODE
 	/* VFS negative dentries are incompatible with Encoding and
@@ -3221,7 +3227,9 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 		goto end_unlink;
 	dir->i_ctime = dir->i_mtime = current_time(dir);
 	ext4_update_dx_flag(dir);
-	ext4_mark_inode_dirty(handle, dir);
+	retval = ext4_mark_inode_dirty(handle, dir);
+	if (retval)
+		goto end_unlink;
 	if (inode->i_nlink == 0)
 		ext4_warning_inode(inode, "Deleting file '%.*s' with no links",
 				   dentry->d_name.len, dentry->d_name.name);
@@ -3230,7 +3238,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (!inode->i_nlink)
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	retval = ext4_mark_inode_dirty(handle, inode);
 
 #ifdef CONFIG_UNICODE
 	/* VFS negative dentries are incompatible with Encoding and
@@ -3419,7 +3427,7 @@ retry:
 
 	err = ext4_add_entry(handle, dentry, inode);
 	if (!err) {
-		ext4_mark_inode_dirty(handle, inode);
+		err = ext4_mark_inode_dirty(handle, inode);
 		/* this can happen only for tmpfile being
 		 * linked the first time
 		 */
@@ -3531,7 +3539,7 @@ static int ext4_rename_dir_finish(handle_t *handle, struct ext4_renament *ent,
 static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 		       unsigned ino, unsigned file_type)
 {
-	int retval;
+	int retval, retval2;
 
 	BUFFER_TRACE(ent->bh, "get write access");
 	retval = ext4_journal_get_write_access(handle, ent->bh);
@@ -3543,19 +3551,19 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	inode_inc_iversion(ent->dir);
 	ent->dir->i_ctime = ent->dir->i_mtime =
 		current_time(ent->dir);
-	ext4_mark_inode_dirty(handle, ent->dir);
+	retval = ext4_mark_inode_dirty(handle, ent->dir);
 	BUFFER_TRACE(ent->bh, "call ext4_handle_dirty_metadata");
 	if (!ent->inlined) {
-		retval = ext4_handle_dirty_dirblock(handle, ent->dir, ent->bh);
-		if (unlikely(retval)) {
-			ext4_std_error(ent->dir->i_sb, retval);
-			return retval;
+		retval2 = ext4_handle_dirty_dirblock(handle, ent->dir, ent->bh);
+		if (unlikely(retval2)) {
+			ext4_std_error(ent->dir->i_sb, retval2);
+			return retval2;
 		}
 	}
 	brelse(ent->bh);
 	ent->bh = NULL;
 
-	return 0;
+	return retval;
 }
 
 static int ext4_find_delete_entry(handle_t *handle, struct inode *dir,
@@ -3790,7 +3798,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				     EXT4_FT_CHRDEV);
 		if (retval)
 			goto end_rename;
-		ext4_mark_inode_dirty(handle, whiteout);
+		retval = ext4_mark_inode_dirty(handle, whiteout);
+		if (unlikely(retval))
+			goto end_rename;
 	}
 	if (!new.bh) {
 		retval = ext4_add_entry(handle, new.dentry, old.inode);
@@ -3811,7 +3821,9 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 	 * rename.
 	 */
 	old.inode->i_ctime = current_time(old.inode);
-	ext4_mark_inode_dirty(handle, old.inode);
+	retval = ext4_mark_inode_dirty(handle, old.inode);
+	if (unlikely(retval))
+		goto end_rename;
 
 	if (!whiteout) {
 		/*
@@ -3840,12 +3852,18 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 		} else {
 			ext4_inc_count(handle, new.dir);
 			ext4_update_dx_flag(new.dir);
-			ext4_mark_inode_dirty(handle, new.dir);
+			retval = ext4_mark_inode_dirty(handle, new.dir);
+			if (unlikely(retval))
+				goto end_rename;
 		}
 	}
-	ext4_mark_inode_dirty(handle, old.dir);
+	retval = ext4_mark_inode_dirty(handle, old.dir);
+	if (unlikely(retval))
+		goto end_rename;
 	if (new.inode) {
-		ext4_mark_inode_dirty(handle, new.inode);
+		retval = ext4_mark_inode_dirty(handle, new.inode);
+		if (unlikely(retval))
+			goto end_rename;
 		if (!new.inode->i_nlink)
 			ext4_orphan_add(handle, new.inode);
 	}
@@ -3979,8 +3997,12 @@ static int ext4_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	ctime = current_time(old.inode);
 	old.inode->i_ctime = ctime;
 	new.inode->i_ctime = ctime;
-	ext4_mark_inode_dirty(handle, old.inode);
-	ext4_mark_inode_dirty(handle, new.inode);
+	retval = ext4_mark_inode_dirty(handle, old.inode);
+	if (unlikely(retval))
+		goto end_rename;
+	retval = ext4_mark_inode_dirty(handle, new.inode);
+	if (unlikely(retval))
+		goto end_rename;
 
 	if (old.dir_bh) {
 		retval = ext4_rename_dir_finish(handle, &old, new.dir->i_ino);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bf5fcb477f667..6135e187e3ed9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5885,7 +5885,7 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 		EXT4_I(inode)->i_flags |= EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL;
 		inode_set_flags(inode, S_NOATIME | S_IMMUTABLE,
 				S_NOATIME | S_IMMUTABLE);
-		ext4_mark_inode_dirty(handle, inode);
+		err = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
 	unlock_inode:
 		inode_unlock(inode);
@@ -5987,12 +5987,14 @@ static int ext4_quota_off(struct super_block *sb, int type)
 	 * this is not a hard failure and quotas are already disabled.
 	 */
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA, 1);
-	if (IS_ERR(handle))
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
 		goto out_unlock;
+	}
 	EXT4_I(inode)->i_flags &= ~(EXT4_NOATIME_FL | EXT4_IMMUTABLE_FL);
 	inode_set_flags(inode, 0, S_NOATIME | S_IMMUTABLE);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
-	ext4_mark_inode_dirty(handle, inode);
+	err = ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
 out_unlock:
 	inode_unlock(inode);
@@ -6050,7 +6052,7 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
 	ext4_lblk_t blk = off >> EXT4_BLOCK_SIZE_BITS(sb);
-	int err, offset = off & (sb->s_blocksize - 1);
+	int err = 0, err2 = 0, offset = off & (sb->s_blocksize - 1);
 	int retries = 0;
 	struct buffer_head *bh;
 	handle_t *handle = journal_current_handle();
@@ -6098,9 +6100,11 @@ out:
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_mark_inode_dirty(handle, inode);
+		err2 = ext4_mark_inode_dirty(handle, inode);
+		if (unlikely(err2 && !err))
+			err = err2;
 	}
-	return len;
+	return err ? err : len;
 }
 #endif
 
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 01ba66373e978..9b29a40738acc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1327,7 +1327,7 @@ static int ext4_xattr_inode_write(handle_t *handle, struct inode *ea_inode,
 	int blocksize = ea_inode->i_sb->s_blocksize;
 	int max_blocks = (bufsize + blocksize - 1) >> ea_inode->i_blkbits;
 	int csize, wsize = 0;
-	int ret = 0;
+	int ret = 0, ret2 = 0;
 	int retries = 0;
 
 retry:
@@ -1385,7 +1385,9 @@ retry:
 	ext4_update_i_disksize(ea_inode, wsize);
 	inode_unlock(ea_inode);
 
-	ext4_mark_inode_dirty(handle, ea_inode);
+	ret2 = ext4_mark_inode_dirty(handle, ea_inode);
+	if (unlikely(ret2 && !ret))
+		ret = ret2;
 
 out:
 	brelse(bh);
-- 
2.25.1



