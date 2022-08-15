Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBA659467A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352232AbiHOW5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352670AbiHOW4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409A545F71;
        Mon, 15 Aug 2022 12:55:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 195CBB80EB1;
        Mon, 15 Aug 2022 19:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634ABC433D6;
        Mon, 15 Aug 2022 19:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593343;
        bh=b8P6wp/YZFfxYrEl2lGN9d3k3AyqwUd6Z5FBEFA0Yys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k5yE7MV/IYeq5xVVqxUoW1nfK4e5nYGp+3nvPi0so3BzFYWfSc4PRZHR96QA9z8oJ
         WpH22FqYUQdP2b8bAYpsPHPPUh31+FrVHlbxf+YkmpHTB3Ngaaag/tDzl8pxT3C5cc
         F3kEGXxHNYI62XEn9Khrp/hafPeqUc3PT0adN1n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0932/1095] f2fs: kill volatile write support
Date:   Mon, 15 Aug 2022 20:05:31 +0200
Message-Id: <20220815180507.784381254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 7bc155fec5b371dbb57256e84a49c78692a09060 ]

There's no user, since all can use atomic writes simply.
Let's kill it.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |   4 +-
 fs/f2fs/data.c       |   5 --
 fs/f2fs/debug.c      |  10 +---
 fs/f2fs/f2fs.h       |  27 +---------
 fs/f2fs/file.c       | 116 ++-----------------------------------------
 fs/f2fs/segment.c    |   3 +-
 fs/f2fs/verity.c     |   2 +-
 7 files changed, 10 insertions(+), 157 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index beceac9885c3..63ab8c9d674e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1004,9 +1004,7 @@ static void __add_dirty_inode(struct inode *inode, enum inode_type type)
 		return;
 
 	set_inode_flag(inode, flag);
-	if (!f2fs_is_volatile_file(inode))
-		list_add_tail(&F2FS_I(inode)->dirty_list,
-						&sbi->inode_list[type]);
+	list_add_tail(&F2FS_I(inode)->dirty_list, &sbi->inode_list[type]);
 	stat_inc_dirty_inode(sbi, type);
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 4c1603a79745..07522e82c7c4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2744,11 +2744,6 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 write:
 	if (f2fs_is_drop_cache(inode))
 		goto out;
-	/* we should not write 0'th page having journal header */
-	if (f2fs_is_volatile_file(inode) && (!page->index ||
-			(!wbc->for_reclaim &&
-			f2fs_available_free_memory(sbi, BASE_CHECK))))
-		goto redirty_out;
 
 	/* Dentry/quota blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode) || IS_NOQUOTA(inode)) {
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 65f0bcf498bb..c92625ef16d0 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -92,9 +92,7 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->nquota_files = sbi->nquota_files;
 	si->ndirty_all = sbi->ndirty_inode[DIRTY_META];
 	si->aw_cnt = sbi->atomic_files;
-	si->vw_cnt = atomic_read(&sbi->vw_cnt);
 	si->max_aw_cnt = atomic_read(&sbi->max_aw_cnt);
-	si->max_vw_cnt = atomic_read(&sbi->max_vw_cnt);
 	si->nr_dio_read = get_pages(sbi, F2FS_DIO_READ);
 	si->nr_dio_write = get_pages(sbi, F2FS_DIO_WRITE);
 	si->nr_wb_cp_data = get_pages(sbi, F2FS_WB_CP_DATA);
@@ -511,10 +509,8 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->flush_list_empty,
 			   si->nr_discarding, si->nr_discarded,
 			   si->nr_discard_cmd, si->undiscard_blks);
-		seq_printf(s, "  - atomic IO: %4d (Max. %4d), "
-			"volatile IO: %4d (Max. %4d)\n",
-			   si->aw_cnt, si->max_aw_cnt,
-			   si->vw_cnt, si->max_vw_cnt);
+		seq_printf(s, "  - atomic IO: %4d (Max. %4d)\n",
+			   si->aw_cnt, si->max_aw_cnt);
 		seq_printf(s, "  - compress: %4d, hit:%8d\n", si->compress_pages, si->compress_page_hit);
 		seq_printf(s, "  - nodes: %4d in %4d\n",
 			   si->ndirty_node, si->node_pages);
@@ -615,9 +611,7 @@ int f2fs_build_stats(struct f2fs_sb_info *sbi)
 	for (i = META_CP; i < META_MAX; i++)
 		atomic_set(&sbi->meta_count[i], 0);
 
-	atomic_set(&sbi->vw_cnt, 0);
 	atomic_set(&sbi->max_aw_cnt, 0);
-	atomic_set(&sbi->max_vw_cnt, 0);
 
 	raw_spin_lock_irqsave(&f2fs_stat_lock, flags);
 	list_add_tail(&si->stat_list, &f2fs_stat_list);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 13140b753ba1..ce8f496a7e5d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -737,7 +737,6 @@ enum {
 	FI_UPDATE_WRITE,	/* inode has in-place-update data */
 	FI_NEED_IPU,		/* used for ipu per file */
 	FI_ATOMIC_FILE,		/* indicate atomic file */
-	FI_VOLATILE_FILE,	/* indicate volatile file */
 	FI_FIRST_BLOCK_WRITTEN,	/* indicate #0 data block was written */
 	FI_DROP_CACHE,		/* drop dirty page cache */
 	FI_DATA_EXIST,		/* indicate data exists */
@@ -1738,9 +1737,7 @@ struct f2fs_sb_info {
 	atomic_t inline_dir;			/* # of inline_dentry inodes */
 	atomic_t compr_inode;			/* # of compressed inodes */
 	atomic64_t compr_blocks;		/* # of compressed blocks */
-	atomic_t vw_cnt;			/* # of volatile writes */
 	atomic_t max_aw_cnt;			/* max # of atomic writes */
-	atomic_t max_vw_cnt;			/* max # of volatile writes */
 	unsigned int io_skip_bggc;		/* skip background gc for in-flight IO */
 	unsigned int other_skip_bggc;		/* skip background gc for other reasons */
 	unsigned int ndirty_inode[NR_INODE_TYPE];	/* # of dirty inodes */
@@ -3191,11 +3188,6 @@ static inline bool f2fs_is_atomic_file(struct inode *inode)
 	return is_inode_flag_set(inode, FI_ATOMIC_FILE);
 }
 
-static inline bool f2fs_is_volatile_file(struct inode *inode)
-{
-	return is_inode_flag_set(inode, FI_VOLATILE_FILE);
-}
-
 static inline bool f2fs_is_first_block_written(struct inode *inode)
 {
 	return is_inode_flag_set(inode, FI_FIRST_BLOCK_WRITTEN);
@@ -3815,7 +3807,7 @@ struct f2fs_stat_info {
 	int inline_xattr, inline_inode, inline_dir, append, update, orphans;
 	int compr_inode;
 	unsigned long long compr_blocks;
-	int aw_cnt, max_aw_cnt, vw_cnt, max_vw_cnt;
+	int aw_cnt, max_aw_cnt;
 	unsigned int valid_count, valid_node_count, valid_inode_count, discard_blks;
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
@@ -3926,17 +3918,6 @@ static inline struct f2fs_stat_info *F2FS_STAT(struct f2fs_sb_info *sbi)
 		if (cur > max)						\
 			atomic_set(&F2FS_I_SB(inode)->max_aw_cnt, cur);	\
 	} while (0)
-#define stat_inc_volatile_write(inode)					\
-		(atomic_inc(&F2FS_I_SB(inode)->vw_cnt))
-#define stat_dec_volatile_write(inode)					\
-		(atomic_dec(&F2FS_I_SB(inode)->vw_cnt))
-#define stat_update_max_volatile_write(inode)				\
-	do {								\
-		int cur = atomic_read(&F2FS_I_SB(inode)->vw_cnt);	\
-		int max = atomic_read(&F2FS_I_SB(inode)->max_vw_cnt);	\
-		if (cur > max)						\
-			atomic_set(&F2FS_I_SB(inode)->max_vw_cnt, cur);	\
-	} while (0)
 #define stat_inc_seg_count(sbi, type, gc_type)				\
 	do {								\
 		struct f2fs_stat_info *si = F2FS_STAT(sbi);		\
@@ -3998,9 +3979,6 @@ void f2fs_update_sit_info(struct f2fs_sb_info *sbi);
 #define stat_add_compr_blocks(inode, blocks)		do { } while (0)
 #define stat_sub_compr_blocks(inode, blocks)		do { } while (0)
 #define stat_update_max_atomic_write(inode)		do { } while (0)
-#define stat_inc_volatile_write(inode)			do { } while (0)
-#define stat_dec_volatile_write(inode)			do { } while (0)
-#define stat_update_max_volatile_write(inode)		do { } while (0)
 #define stat_inc_meta_count(sbi, blkaddr)		do { } while (0)
 #define stat_inc_seg_type(sbi, curseg)			do { } while (0)
 #define stat_inc_block_count(sbi, curseg)		do { } while (0)
@@ -4404,8 +4382,7 @@ static inline bool f2fs_lfs_mode(struct f2fs_sb_info *sbi)
 static inline bool f2fs_may_compress(struct inode *inode)
 {
 	if (IS_SWAPFILE(inode) || f2fs_is_pinned_file(inode) ||
-				f2fs_is_atomic_file(inode) ||
-				f2fs_is_volatile_file(inode))
+				f2fs_is_atomic_file(inode))
 		return false;
 	return S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode);
 }
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9b04a7a0a368..ab344d5f9b82 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1818,13 +1818,6 @@ static int f2fs_release_file(struct inode *inode, struct file *filp)
 
 	if (f2fs_is_atomic_file(inode))
 		f2fs_abort_atomic_write(inode, true);
-	if (f2fs_is_volatile_file(inode)) {
-		set_inode_flag(inode, FI_DROP_CACHE);
-		filemap_fdatawrite(inode->i_mapping);
-		clear_inode_flag(inode, FI_DROP_CACHE);
-		clear_inode_flag(inode, FI_VOLATILE_FILE);
-		stat_dec_volatile_write(inode);
-	}
 	return 0;
 }
 
@@ -2099,15 +2092,10 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 
 	inode_lock(inode);
 
-	if (f2fs_is_volatile_file(inode)) {
-		ret = -EINVAL;
-		goto err_out;
-	}
-
 	if (f2fs_is_atomic_file(inode)) {
 		ret = f2fs_commit_atomic_write(inode);
 		if (ret)
-			goto err_out;
+			goto unlock_out;
 
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
 		if (!ret)
@@ -2115,108 +2103,12 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	} else {
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 1, false);
 	}
-err_out:
+unlock_out:
 	inode_unlock(inode);
 	mnt_drop_write_file(filp);
 	return ret;
 }
 
-static int f2fs_ioc_start_volatile_write(struct file *filp)
-{
-	struct inode *inode = file_inode(filp);
-	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
-	int ret;
-
-	if (!inode_owner_or_capable(mnt_userns, inode))
-		return -EACCES;
-
-	if (!S_ISREG(inode->i_mode))
-		return -EINVAL;
-
-	ret = mnt_want_write_file(filp);
-	if (ret)
-		return ret;
-
-	inode_lock(inode);
-
-	if (f2fs_is_volatile_file(inode))
-		goto out;
-
-	ret = f2fs_convert_inline_inode(inode);
-	if (ret)
-		goto out;
-
-	stat_inc_volatile_write(inode);
-	stat_update_max_volatile_write(inode);
-
-	set_inode_flag(inode, FI_VOLATILE_FILE);
-	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-out:
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
-	return ret;
-}
-
-static int f2fs_ioc_release_volatile_write(struct file *filp)
-{
-	struct inode *inode = file_inode(filp);
-	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
-	int ret;
-
-	if (!inode_owner_or_capable(mnt_userns, inode))
-		return -EACCES;
-
-	ret = mnt_want_write_file(filp);
-	if (ret)
-		return ret;
-
-	inode_lock(inode);
-
-	if (!f2fs_is_volatile_file(inode))
-		goto out;
-
-	if (!f2fs_is_first_block_written(inode)) {
-		ret = truncate_partial_data_page(inode, 0, true);
-		goto out;
-	}
-
-	ret = punch_hole(inode, 0, F2FS_BLKSIZE);
-out:
-	inode_unlock(inode);
-	mnt_drop_write_file(filp);
-	return ret;
-}
-
-static int f2fs_ioc_abort_volatile_write(struct file *filp)
-{
-	struct inode *inode = file_inode(filp);
-	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
-	int ret;
-
-	if (!inode_owner_or_capable(mnt_userns, inode))
-		return -EACCES;
-
-	ret = mnt_want_write_file(filp);
-	if (ret)
-		return ret;
-
-	inode_lock(inode);
-
-	if (f2fs_is_atomic_file(inode))
-		f2fs_abort_atomic_write(inode, true);
-	if (f2fs_is_volatile_file(inode)) {
-		clear_inode_flag(inode, FI_VOLATILE_FILE);
-		stat_dec_volatile_write(inode);
-		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
-	}
-
-	inode_unlock(inode);
-
-	mnt_drop_write_file(filp);
-	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	return ret;
-}
-
 static int f2fs_ioc_shutdown(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -4155,11 +4047,9 @@ static long __f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case F2FS_IOC_COMMIT_ATOMIC_WRITE:
 		return f2fs_ioc_commit_atomic_write(filp);
 	case F2FS_IOC_START_VOLATILE_WRITE:
-		return f2fs_ioc_start_volatile_write(filp);
 	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
-		return f2fs_ioc_release_volatile_write(filp);
 	case F2FS_IOC_ABORT_VOLATILE_WRITE:
-		return f2fs_ioc_abort_volatile_write(filp);
+		return -EOPNOTSUPP;
 	case F2FS_IOC_SHUTDOWN:
 		return f2fs_ioc_shutdown(filp, arg);
 	case FITRIM:
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 86a3c5a5a564..4115c6568e48 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3167,8 +3167,7 @@ static int __get_segment_type_6(struct f2fs_io_info *fio)
 			return CURSEG_COLD_DATA;
 		if (file_is_hot(inode) ||
 				is_inode_flag_set(inode, FI_HOT_DATA) ||
-				f2fs_is_atomic_file(inode) ||
-				f2fs_is_volatile_file(inode))
+				f2fs_is_atomic_file(inode))
 			return CURSEG_HOT_DATA;
 		return f2fs_rw_hint_to_seg_type(inode->i_write_hint);
 	} else {
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 3d793202cc9f..5ac7e756a1bb 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -128,7 +128,7 @@ static int f2fs_begin_enable_verity(struct file *filp)
 	if (f2fs_verity_in_progress(inode))
 		return -EBUSY;
 
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
+	if (f2fs_is_atomic_file(inode))
 		return -EOPNOTSUPP;
 
 	/*
-- 
2.35.1



