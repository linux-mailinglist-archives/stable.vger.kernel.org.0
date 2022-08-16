Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA9594678
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351869AbiHOW5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352620AbiHOW41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A7630F75;
        Mon, 15 Aug 2022 12:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2C28B80EAD;
        Mon, 15 Aug 2022 19:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB13C433C1;
        Mon, 15 Aug 2022 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593334;
        bh=GIH4ddnl7odpqrS7xLLx6jo1+9V9uYFQW4dGidvphOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPoEqgKoAPLLp8yYqIXENicjgt8IDNcDSYxakC9Vup+QMUzLNC/tbf7xEu5foW8cW
         9jf5h3CKQXQof7fdubVhGseeCxVH9BcBUpWMv+Spi681cCjfeNC66DPY/H0KS+FuGJ
         5421Kmit6ik65m4xuRQ2PakF3tpy71x5DrxuVRZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0931/1095] f2fs: change the current atomic write way
Date:   Mon, 15 Aug 2022 20:05:30 +0200
Message-Id: <20220815180507.738744574@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 3db1de0e582c358dd013f3703cd55b5fe4076436 ]

Current atomic write has three major issues like below.
 - keeps the updates in non-reclaimable memory space and they are even
   hard to be migrated, which is not good for contiguous memory
   allocation.
 - disk spaces used for atomic files cannot be garbage collected, so
   this makes it difficult for the filesystem to be defragmented.
 - If atomic write operations hit the threshold of either memory usage
   or garbage collection failure count, All the atomic write operations
   will fail immediately.

To resolve the issues, I will keep a COW inode internally for all the
updates to be flushed from memory, when we need to flush them out in a
situation like high memory pressure. These COW inodes will be tagged
as orphan inodes to be reclaimed in case of sudden power-cut or system
failure during atomic writes.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c              | 180 +++++++++++------
 fs/f2fs/debug.c             |  12 +-
 fs/f2fs/f2fs.h              |  33 +---
 fs/f2fs/file.c              |  49 ++---
 fs/f2fs/gc.c                |  27 +--
 fs/f2fs/inode.c             |   3 +-
 fs/f2fs/namei.c             |  28 ++-
 fs/f2fs/node.c              |   4 -
 fs/f2fs/node.h              |   1 -
 fs/f2fs/segment.c           | 380 ++++++++++++------------------------
 fs/f2fs/segment.h           |   4 +-
 fs/f2fs/super.c             |   6 +-
 include/trace/events/f2fs.h |  22 ---
 13 files changed, 303 insertions(+), 446 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 1862b03a9982..4c1603a79745 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -69,8 +69,7 @@ static bool __is_cp_guaranteed(struct page *page)
 
 	if (f2fs_is_compressed_page(page))
 		return false;
-	if ((S_ISREG(inode->i_mode) &&
-			(f2fs_is_atomic_file(inode) || IS_NOQUOTA(inode))) ||
+	if ((S_ISREG(inode->i_mode) && IS_NOQUOTA(inode)) ||
 			page_private_gcing(page))
 		return true;
 	return false;
@@ -2566,7 +2565,12 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 	bool ipu_force = false;
 	int err = 0;
 
-	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	/* Use COW inode to make dnode_of_data for atomic write */
+	if (f2fs_is_atomic_file(inode))
+		set_new_dnode(&dn, F2FS_I(inode)->cow_inode, NULL, NULL, 0);
+	else
+		set_new_dnode(&dn, inode, NULL, NULL, 0);
+
 	if (need_inplace_update(fio) &&
 			f2fs_lookup_extent_cache(inode, page->index, &ei)) {
 		fio->old_blkaddr = ei.blk + page->index - ei.fofs;
@@ -2603,6 +2607,7 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 		err = -EFSCORRUPTED;
 		goto out_writepage;
 	}
+
 	/*
 	 * If current allocation needs SSR,
 	 * it had better in-place writes for updated data.
@@ -3316,6 +3321,100 @@ static int prepare_write_begin(struct f2fs_sb_info *sbi,
 	return err;
 }
 
+static int __find_data_block(struct inode *inode, pgoff_t index,
+				block_t *blk_addr)
+{
+	struct dnode_of_data dn;
+	struct page *ipage;
+	struct extent_info ei = {0, };
+	int err = 0;
+
+	ipage = f2fs_get_node_page(F2FS_I_SB(inode), inode->i_ino);
+	if (IS_ERR(ipage))
+		return PTR_ERR(ipage);
+
+	set_new_dnode(&dn, inode, ipage, ipage, 0);
+
+	if (f2fs_lookup_extent_cache(inode, index, &ei)) {
+		dn.data_blkaddr = ei.blk + index - ei.fofs;
+	} else {
+		/* hole case */
+		err = f2fs_get_dnode_of_data(&dn, index, LOOKUP_NODE);
+		if (err) {
+			dn.data_blkaddr = NULL_ADDR;
+			err = 0;
+		}
+	}
+	*blk_addr = dn.data_blkaddr;
+	f2fs_put_dnode(&dn);
+	return err;
+}
+
+static int __reserve_data_block(struct inode *inode, pgoff_t index,
+				block_t *blk_addr, bool *node_changed)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct dnode_of_data dn;
+	struct page *ipage;
+	int err = 0;
+
+	f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, true);
+
+	ipage = f2fs_get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage)) {
+		err = PTR_ERR(ipage);
+		goto unlock_out;
+	}
+	set_new_dnode(&dn, inode, ipage, ipage, 0);
+
+	err = f2fs_get_block(&dn, index);
+
+	*blk_addr = dn.data_blkaddr;
+	*node_changed = dn.node_changed;
+	f2fs_put_dnode(&dn);
+
+unlock_out:
+	f2fs_do_map_lock(sbi, F2FS_GET_BLOCK_PRE_AIO, false);
+	return err;
+}
+
+static int prepare_atomic_write_begin(struct f2fs_sb_info *sbi,
+			struct page *page, loff_t pos, unsigned int len,
+			block_t *blk_addr, bool *node_changed)
+{
+	struct inode *inode = page->mapping->host;
+	struct inode *cow_inode = F2FS_I(inode)->cow_inode;
+	pgoff_t index = page->index;
+	int err = 0;
+	block_t ori_blk_addr;
+
+	/* If pos is beyond the end of file, reserve a new block in COW inode */
+	if ((pos & PAGE_MASK) >= i_size_read(inode))
+		return __reserve_data_block(cow_inode, index, blk_addr,
+					node_changed);
+
+	/* Look for the block in COW inode first */
+	err = __find_data_block(cow_inode, index, blk_addr);
+	if (err)
+		return err;
+	else if (*blk_addr != NULL_ADDR)
+		return 0;
+
+	/* Look for the block in the original inode */
+	err = __find_data_block(inode, index, &ori_blk_addr);
+	if (err)
+		return err;
+
+	/* Finally, we should reserve a new block in COW inode for the update */
+	err = __reserve_data_block(cow_inode, index, blk_addr, node_changed);
+	if (err)
+		return err;
+
+	if (ori_blk_addr != NULL_ADDR)
+		*blk_addr = ori_blk_addr;
+	return 0;
+}
+
 static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
@@ -3324,7 +3423,7 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *page = NULL;
 	pgoff_t index = ((unsigned long long) pos) >> PAGE_SHIFT;
-	bool need_balance = false, drop_atomic = false;
+	bool need_balance = false;
 	block_t blkaddr = NULL_ADDR;
 	int err = 0;
 
@@ -3335,14 +3434,6 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 		goto fail;
 	}
 
-	if ((f2fs_is_atomic_file(inode) &&
-			!f2fs_available_free_memory(sbi, INMEM_PAGES)) ||
-			is_inode_flag_set(inode, FI_ATOMIC_REVOKE_REQUEST)) {
-		err = -ENOMEM;
-		drop_atomic = true;
-		goto fail;
-	}
-
 	/*
 	 * We should check this at this moment to avoid deadlock on inode page
 	 * and #0 page. The locking rule for inline_data conversion should be:
@@ -3390,7 +3481,11 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 	*pagep = page;
 
-	err = prepare_write_begin(sbi, page, pos, len,
+	if (f2fs_is_atomic_file(inode))
+		err = prepare_atomic_write_begin(sbi, page, pos, len,
+					&blkaddr, &need_balance);
+	else
+		err = prepare_write_begin(sbi, page, pos, len,
 					&blkaddr, &need_balance);
 	if (err)
 		goto fail;
@@ -3446,8 +3541,6 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 fail:
 	f2fs_put_page(page, 1);
 	f2fs_write_failed(inode, pos + len);
-	if (drop_atomic)
-		f2fs_drop_inmem_pages_all(sbi, false);
 	return err;
 }
 
@@ -3491,8 +3584,12 @@ static int f2fs_write_end(struct file *file,
 	set_page_dirty(page);
 
 	if (pos + copied > i_size_read(inode) &&
-	    !f2fs_verity_in_progress(inode))
+	    !f2fs_verity_in_progress(inode)) {
 		f2fs_i_size_write(inode, pos + copied);
+		if (f2fs_is_atomic_file(inode))
+			f2fs_i_size_write(F2FS_I(inode)->cow_inode,
+					pos + copied);
+	}
 unlock_out:
 	f2fs_put_page(page, 1);
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
@@ -3525,9 +3622,6 @@ void f2fs_invalidate_folio(struct folio *folio, size_t offset, size_t length)
 			inode->i_ino == F2FS_COMPRESS_INO(sbi))
 		clear_page_private_data(&folio->page);
 
-	if (page_private_atomic(&folio->page))
-		return f2fs_drop_inmem_page(inode, &folio->page);
-
 	folio_detach_private(folio);
 }
 
@@ -3537,10 +3631,6 @@ int f2fs_release_page(struct page *page, gfp_t wait)
 	if (PageDirty(page))
 		return 0;
 
-	/* This is atomic written page, keep Private */
-	if (page_private_atomic(page))
-		return 0;
-
 	if (test_opt(F2FS_P_SB(page), COMPRESS_CACHE)) {
 		struct inode *inode = page->mapping->host;
 
@@ -3566,18 +3656,6 @@ static bool f2fs_dirty_data_folio(struct address_space *mapping,
 		folio_mark_uptodate(folio);
 	BUG_ON(folio_test_swapcache(folio));
 
-	if (f2fs_is_atomic_file(inode) && !f2fs_is_commit_atomic_write(inode)) {
-		if (!page_private_atomic(&folio->page)) {
-			f2fs_register_inmem_page(inode, &folio->page);
-			return true;
-		}
-		/*
-		 * Previously, this page has been registered, we just
-		 * return here.
-		 */
-		return false;
-	}
-
 	if (!folio_test_dirty(folio)) {
 		filemap_dirty_folio(mapping, folio);
 		f2fs_update_dirty_folio(inode, folio);
@@ -3657,42 +3735,14 @@ static sector_t f2fs_bmap(struct address_space *mapping, sector_t block)
 int f2fs_migrate_page(struct address_space *mapping,
 		struct page *newpage, struct page *page, enum migrate_mode mode)
 {
-	int rc, extra_count;
-	struct f2fs_inode_info *fi = F2FS_I(mapping->host);
-	bool atomic_written = page_private_atomic(page);
+	int rc, extra_count = 0;
 
 	BUG_ON(PageWriteback(page));
 
-	/* migrating an atomic written page is safe with the inmem_lock hold */
-	if (atomic_written) {
-		if (mode != MIGRATE_SYNC)
-			return -EBUSY;
-		if (!mutex_trylock(&fi->inmem_lock))
-			return -EAGAIN;
-	}
-
-	/* one extra reference was held for atomic_write page */
-	extra_count = atomic_written ? 1 : 0;
 	rc = migrate_page_move_mapping(mapping, newpage,
 				page, extra_count);
-	if (rc != MIGRATEPAGE_SUCCESS) {
-		if (atomic_written)
-			mutex_unlock(&fi->inmem_lock);
+	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
-	}
-
-	if (atomic_written) {
-		struct inmem_pages *cur;
-
-		list_for_each_entry(cur, &fi->inmem_pages, list)
-			if (cur->page == page) {
-				cur->page = newpage;
-				break;
-			}
-		mutex_unlock(&fi->inmem_lock);
-		put_page(page);
-		get_page(newpage);
-	}
 
 	/* guarantee to start from no stale private field */
 	set_page_private(newpage, 0);
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index fcdf253cd211..65f0bcf498bb 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -91,7 +91,6 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->ndirty_files = sbi->ndirty_inode[FILE_INODE];
 	si->nquota_files = sbi->nquota_files;
 	si->ndirty_all = sbi->ndirty_inode[DIRTY_META];
-	si->inmem_pages = get_pages(sbi, F2FS_INMEM_PAGES);
 	si->aw_cnt = sbi->atomic_files;
 	si->vw_cnt = atomic_read(&sbi->vw_cnt);
 	si->max_aw_cnt = atomic_read(&sbi->max_aw_cnt);
@@ -167,8 +166,6 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 	si->alloc_nids = NM_I(sbi)->nid_cnt[PREALLOC_NID];
 	si->io_skip_bggc = sbi->io_skip_bggc;
 	si->other_skip_bggc = sbi->other_skip_bggc;
-	si->skipped_atomic_files[BG_GC] = sbi->skipped_atomic_files[BG_GC];
-	si->skipped_atomic_files[FG_GC] = sbi->skipped_atomic_files[FG_GC];
 	si->util_free = (int)(free_user_blocks(sbi) >> sbi->log_blocks_per_seg)
 		* 100 / (int)(sbi->user_block_count >> sbi->log_blocks_per_seg)
 		/ 2;
@@ -296,7 +293,6 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 				sizeof(struct nat_entry);
 	si->cache_mem += NM_I(sbi)->nat_cnt[DIRTY_NAT] *
 				sizeof(struct nat_entry_set);
-	si->cache_mem += si->inmem_pages * sizeof(struct inmem_pages);
 	for (i = 0; i < MAX_INO_ENTRY; i++)
 		si->cache_mem += sbi->im[i].ino_num * sizeof(struct ino_entry);
 	si->cache_mem += atomic_read(&sbi->total_ext_tree) *
@@ -491,10 +487,6 @@ static int stat_show(struct seq_file *s, void *v)
 				si->bg_data_blks);
 		seq_printf(s, "  - node blocks : %d (%d)\n", si->node_blks,
 				si->bg_node_blks);
-		seq_printf(s, "Skipped : atomic write %llu (%llu)\n",
-				si->skipped_atomic_files[BG_GC] +
-				si->skipped_atomic_files[FG_GC],
-				si->skipped_atomic_files[BG_GC]);
 		seq_printf(s, "BG skip : IO: %u, Other: %u\n",
 				si->io_skip_bggc, si->other_skip_bggc);
 		seq_puts(s, "\nExtent Cache:\n");
@@ -519,9 +511,9 @@ static int stat_show(struct seq_file *s, void *v)
 			   si->flush_list_empty,
 			   si->nr_discarding, si->nr_discarded,
 			   si->nr_discard_cmd, si->undiscard_blks);
-		seq_printf(s, "  - inmem: %4d, atomic IO: %4d (Max. %4d), "
+		seq_printf(s, "  - atomic IO: %4d (Max. %4d), "
 			"volatile IO: %4d (Max. %4d)\n",
-			   si->inmem_pages, si->aw_cnt, si->max_aw_cnt,
+			   si->aw_cnt, si->max_aw_cnt,
 			   si->vw_cnt, si->max_vw_cnt);
 		seq_printf(s, "  - compress: %4d, hit:%8d\n", si->compress_pages, si->compress_page_hit);
 		seq_printf(s, "  - nodes: %4d in %4d\n",
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9b89f26af1f3..13140b753ba1 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -716,7 +716,6 @@ enum {
 
 enum {
 	GC_FAILURE_PIN,
-	GC_FAILURE_ATOMIC,
 	MAX_GC_FAILURE
 };
 
@@ -738,7 +737,6 @@ enum {
 	FI_UPDATE_WRITE,	/* inode has in-place-update data */
 	FI_NEED_IPU,		/* used for ipu per file */
 	FI_ATOMIC_FILE,		/* indicate atomic file */
-	FI_ATOMIC_COMMIT,	/* indicate the state of atomical committing */
 	FI_VOLATILE_FILE,	/* indicate volatile file */
 	FI_FIRST_BLOCK_WRITTEN,	/* indicate #0 data block was written */
 	FI_DROP_CACHE,		/* drop dirty page cache */
@@ -752,7 +750,6 @@ enum {
 	FI_EXTRA_ATTR,		/* indicate file has extra attribute */
 	FI_PROJ_INHERIT,	/* indicate file inherits projectid */
 	FI_PIN_FILE,		/* indicate file should not be gced */
-	FI_ATOMIC_REVOKE_REQUEST, /* request to drop atomic data */
 	FI_VERITY_IN_PROGRESS,	/* building fs-verity Merkle tree */
 	FI_COMPRESSED_FILE,	/* indicate file's data can be compressed */
 	FI_COMPRESS_CORRUPT,	/* indicate compressed cluster is corrupted */
@@ -794,11 +791,9 @@ struct f2fs_inode_info {
 #endif
 	struct list_head dirty_list;	/* dirty list for dirs and files */
 	struct list_head gdirty_list;	/* linked in global dirty list */
-	struct list_head inmem_ilist;	/* list for inmem inodes */
-	struct list_head inmem_pages;	/* inmemory pages managed by f2fs */
-	struct task_struct *inmem_task;	/* store inmemory task */
-	struct mutex inmem_lock;	/* lock for inmemory pages */
+	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree;	/* cached extent_tree entry */
+	struct inode *cow_inode;	/* copy-on-write inode for atomic write */
 
 	/* avoid racing between foreground op and gc */
 	struct f2fs_rwsem i_gc_rwsem[2];
@@ -1092,7 +1087,6 @@ enum count_type {
 	F2FS_DIRTY_QDATA,
 	F2FS_DIRTY_NODES,
 	F2FS_DIRTY_META,
-	F2FS_INMEM_PAGES,
 	F2FS_DIRTY_IMETA,
 	F2FS_WB_CP_DATA,
 	F2FS_WB_DATA,
@@ -1122,11 +1116,7 @@ enum page_type {
 	META,
 	NR_PAGE_TYPE,
 	META_FLUSH,
-	INMEM,		/* the below types are used by tracepoints only. */
-	INMEM_DROP,
-	INMEM_INVALIDATE,
-	INMEM_REVOKE,
-	IPU,
+	IPU,		/* the below types are used by tracepoints only. */
 	OPU,
 };
 
@@ -1718,7 +1708,6 @@ struct f2fs_sb_info {
 
 	/* for skip statistic */
 	unsigned int atomic_files;		/* # of opened atomic file */
-	unsigned long long skipped_atomic_files[2];	/* FG_GC and BG_GC */
 	unsigned long long skipped_gc_rwsem;		/* FG_GC only */
 
 	/* threshold for gc trials on pinned files */
@@ -3202,11 +3191,6 @@ static inline bool f2fs_is_atomic_file(struct inode *inode)
 	return is_inode_flag_set(inode, FI_ATOMIC_FILE);
 }
 
-static inline bool f2fs_is_commit_atomic_write(struct inode *inode)
-{
-	return is_inode_flag_set(inode, FI_ATOMIC_COMMIT);
-}
-
 static inline bool f2fs_is_volatile_file(struct inode *inode)
 {
 	return is_inode_flag_set(inode, FI_VOLATILE_FILE);
@@ -3444,6 +3428,8 @@ void f2fs_handle_failed_inode(struct inode *inode);
 int f2fs_update_extension_list(struct f2fs_sb_info *sbi, const char *name,
 							bool hot, bool set);
 struct dentry *f2fs_get_parent(struct dentry *child);
+int f2fs_get_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
+		     struct inode **new_inode);
 
 /*
  * dir.c
@@ -3579,11 +3565,8 @@ void f2fs_destroy_node_manager_caches(void);
  * segment.c
  */
 bool f2fs_need_SSR(struct f2fs_sb_info *sbi);
-void f2fs_register_inmem_page(struct inode *inode, struct page *page);
-void f2fs_drop_inmem_pages_all(struct f2fs_sb_info *sbi, bool gc_failure);
-void f2fs_drop_inmem_pages(struct inode *inode);
-void f2fs_drop_inmem_page(struct inode *inode, struct page *page);
-int f2fs_commit_inmem_pages(struct inode *inode);
+int f2fs_commit_atomic_write(struct inode *inode);
+void f2fs_abort_atomic_write(struct inode *inode, bool clean);
 void f2fs_balance_fs(struct f2fs_sb_info *sbi, bool need);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *sbi, bool from_bg);
 int f2fs_issue_flush(struct f2fs_sb_info *sbi, nid_t ino);
@@ -3815,7 +3798,6 @@ struct f2fs_stat_info {
 	int ext_tree, zombie_tree, ext_node;
 	int ndirty_node, ndirty_dent, ndirty_meta, ndirty_imeta;
 	int ndirty_data, ndirty_qdata;
-	int inmem_pages;
 	unsigned int ndirty_dirs, ndirty_files, nquota_files, ndirty_all;
 	int nats, dirty_nats, sits, dirty_sits;
 	int free_nids, avail_nids, alloc_nids;
@@ -3845,7 +3827,6 @@ struct f2fs_stat_info {
 	int bg_node_segs, bg_data_segs;
 	int tot_blks, data_blks, node_blks;
 	int bg_data_blks, bg_node_blks;
-	unsigned long long skipped_atomic_files[2];
 	int curseg[NR_CURSEG_TYPE];
 	int cursec[NR_CURSEG_TYPE];
 	int curzone[NR_CURSEG_TYPE];
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5d1b97e852e7..9b04a7a0a368 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1816,9 +1816,8 @@ static int f2fs_release_file(struct inode *inode, struct file *filp)
 			atomic_read(&inode->i_writecount) != 1)
 		return 0;
 
-	/* some remained atomic pages should discarded */
 	if (f2fs_is_atomic_file(inode))
-		f2fs_drop_inmem_pages(inode);
+		f2fs_abort_atomic_write(inode, true);
 	if (f2fs_is_volatile_file(inode)) {
 		set_inode_flag(inode, FI_DROP_CACHE);
 		filemap_fdatawrite(inode->i_mapping);
@@ -1840,8 +1839,8 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 	 * before dropping file lock, it needs to do in ->flush.
 	 */
 	if (f2fs_is_atomic_file(inode) &&
-			F2FS_I(inode)->inmem_task == current)
-		f2fs_drop_inmem_pages(inode);
+			F2FS_I(inode)->atomic_write_task == current)
+		f2fs_abort_atomic_write(inode, true);
 	return 0;
 }
 
@@ -2004,6 +2003,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	struct user_namespace *mnt_userns = file_mnt_user_ns(filp);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct inode *pinode;
 	int ret;
 
 	if (!inode_owner_or_capable(mnt_userns, inode))
@@ -2026,11 +2026,8 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		goto out;
 	}
 
-	if (f2fs_is_atomic_file(inode)) {
-		if (is_inode_flag_set(inode, FI_ATOMIC_REVOKE_REQUEST))
-			ret = -EINVAL;
+	if (f2fs_is_atomic_file(inode))
 		goto out;
-	}
 
 	ret = f2fs_convert_inline_inode(inode);
 	if (ret)
@@ -2051,19 +2048,33 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		goto out;
 	}
 
+	/* Create a COW inode for atomic write */
+	pinode = f2fs_iget(inode->i_sb, fi->i_pino);
+	if (IS_ERR(pinode)) {
+		f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+		ret = PTR_ERR(pinode);
+		goto out;
+	}
+
+	ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
+	iput(pinode);
+	if (ret) {
+		f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
+		goto out;
+	}
+	f2fs_i_size_write(fi->cow_inode, i_size_read(inode));
+
 	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
-	if (list_empty(&fi->inmem_ilist))
-		list_add_tail(&fi->inmem_ilist, &sbi->inode_list[ATOMIC_FILE]);
 	sbi->atomic_files++;
 	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
 
-	/* add inode in inmem_list first and set atomic_file */
 	set_inode_flag(inode, FI_ATOMIC_FILE);
-	clear_inode_flag(inode, FI_ATOMIC_REVOKE_REQUEST);
+	set_inode_flag(fi->cow_inode, FI_ATOMIC_FILE);
+	clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
 	f2fs_up_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
 
 	f2fs_update_time(F2FS_I_SB(inode), REQ_TIME);
-	F2FS_I(inode)->inmem_task = current;
+	F2FS_I(inode)->atomic_write_task = current;
 	stat_update_max_atomic_write(inode);
 out:
 	inode_unlock(inode);
@@ -2094,21 +2105,17 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 	}
 
 	if (f2fs_is_atomic_file(inode)) {
-		ret = f2fs_commit_inmem_pages(inode);
+		ret = f2fs_commit_atomic_write(inode);
 		if (ret)
 			goto err_out;
 
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
 		if (!ret)
-			f2fs_drop_inmem_pages(inode);
+			f2fs_abort_atomic_write(inode, false);
 	} else {
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 1, false);
 	}
 err_out:
-	if (is_inode_flag_set(inode, FI_ATOMIC_REVOKE_REQUEST)) {
-		clear_inode_flag(inode, FI_ATOMIC_REVOKE_REQUEST);
-		ret = -EINVAL;
-	}
 	inode_unlock(inode);
 	mnt_drop_write_file(filp);
 	return ret;
@@ -2196,15 +2203,13 @@ static int f2fs_ioc_abort_volatile_write(struct file *filp)
 	inode_lock(inode);
 
 	if (f2fs_is_atomic_file(inode))
-		f2fs_drop_inmem_pages(inode);
+		f2fs_abort_atomic_write(inode, true);
 	if (f2fs_is_volatile_file(inode)) {
 		clear_inode_flag(inode, FI_VOLATILE_FILE);
 		stat_dec_volatile_write(inode);
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
 	}
 
-	clear_inode_flag(inode, FI_ATOMIC_REVOKE_REQUEST);
-
 	inode_unlock(inode);
 
 	mnt_drop_write_file(filp);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 3009c0a97ab4..ba8e93e517be 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1245,13 +1245,6 @@ static int move_data_block(struct inode *inode, block_t bidx,
 		goto out;
 	}
 
-	if (f2fs_is_atomic_file(inode)) {
-		F2FS_I(inode)->i_gc_failures[GC_FAILURE_ATOMIC]++;
-		F2FS_I_SB(inode)->skipped_atomic_files[gc_type]++;
-		err = -EAGAIN;
-		goto out;
-	}
-
 	err = f2fs_gc_pinned_control(inode, gc_type, segno);
 	if (err)
 		goto out;
@@ -1393,12 +1386,6 @@ static int move_data_page(struct inode *inode, block_t bidx, int gc_type,
 		goto out;
 	}
 
-	if (f2fs_is_atomic_file(inode)) {
-		F2FS_I(inode)->i_gc_failures[GC_FAILURE_ATOMIC]++;
-		F2FS_I_SB(inode)->skipped_atomic_files[gc_type]++;
-		err = -EAGAIN;
-		goto out;
-	}
 	err = f2fs_gc_pinned_control(inode, gc_type, segno);
 	if (err)
 		goto out;
@@ -1765,8 +1752,6 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 		.ilist = LIST_HEAD_INIT(gc_list.ilist),
 		.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 	};
-	unsigned long long last_skipped = sbi->skipped_atomic_files[FG_GC];
-	unsigned long long first_skipped;
 	unsigned int skipped_round = 0, round = 0;
 
 	trace_f2fs_gc_begin(sbi->sb, sync, background,
@@ -1780,7 +1765,6 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 
 	cpc.reason = __get_cp_reason(sbi);
 	sbi->skipped_gc_rwsem = 0;
-	first_skipped = last_skipped;
 gc_more:
 	if (unlikely(!(sbi->sb->s_flags & SB_ACTIVE))) {
 		ret = -EINVAL;
@@ -1831,10 +1815,8 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 	total_freed += seg_freed;
 
 	if (gc_type == FG_GC) {
-		if (sbi->skipped_atomic_files[FG_GC] > last_skipped ||
-						sbi->skipped_gc_rwsem)
+		if (sbi->skipped_gc_rwsem)
 			skipped_round++;
-		last_skipped = sbi->skipped_atomic_files[FG_GC];
 		round++;
 	}
 
@@ -1860,13 +1842,6 @@ int f2fs_gc(struct f2fs_sb_info *sbi, bool sync,
 		segno = NULL_SEGNO;
 		goto gc_more;
 	}
-	if (first_skipped < last_skipped &&
-			(last_skipped - first_skipped) >
-					sbi->skipped_gc_rwsem) {
-		f2fs_drop_inmem_pages_all(sbi, true);
-		segno = NULL_SEGNO;
-		goto gc_more;
-	}
 	if (gc_type == FG_GC && !is_sbi_flag_set(sbi, SBI_CP_DISABLED))
 		ret = f2fs_write_checkpoint(sbi, &cpc);
 stop:
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e9818723103c..938961a9084e 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -744,9 +744,8 @@ void f2fs_evict_inode(struct inode *inode)
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 	int err = 0;
 
-	/* some remained atomic pages should discarded */
 	if (f2fs_is_atomic_file(inode))
-		f2fs_drop_inmem_pages(inode);
+		f2fs_abort_atomic_write(inode, true);
 
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 3764e12f19db..28d5981443a7 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -848,8 +848,8 @@ static int f2fs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 }
 
 static int __f2fs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
-					struct dentry *dentry, umode_t mode,
-					struct inode **whiteout)
+			  struct dentry *dentry, umode_t mode, bool is_whiteout,
+			  struct inode **new_inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
 	struct inode *inode;
@@ -863,7 +863,7 @@ static int __f2fs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	if (whiteout) {
+	if (is_whiteout) {
 		init_special_inode(inode, inode->i_mode, WHITEOUT_DEV);
 		inode->i_op = &f2fs_special_inode_operations;
 	} else {
@@ -888,21 +888,25 @@ static int __f2fs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 	f2fs_add_orphan_inode(inode);
 	f2fs_alloc_nid_done(sbi, inode->i_ino);
 
-	if (whiteout) {
+	if (is_whiteout) {
 		f2fs_i_links_write(inode, false);
 
 		spin_lock(&inode->i_lock);
 		inode->i_state |= I_LINKABLE;
 		spin_unlock(&inode->i_lock);
-
-		*whiteout = inode;
 	} else {
-		d_tmpfile(dentry, inode);
+		if (dentry)
+			d_tmpfile(dentry, inode);
+		else
+			f2fs_i_links_write(inode, false);
 	}
 	/* link_count was changed by d_tmpfile as well. */
 	f2fs_unlock_op(sbi);
 	unlock_new_inode(inode);
 
+	if (new_inode)
+		*new_inode = inode;
+
 	f2fs_balance_fs(sbi, true);
 	return 0;
 
@@ -923,7 +927,7 @@ static int f2fs_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!f2fs_is_checkpoint_ready(sbi))
 		return -ENOSPC;
 
-	return __f2fs_tmpfile(mnt_userns, dir, dentry, mode, NULL);
+	return __f2fs_tmpfile(mnt_userns, dir, dentry, mode, false, NULL);
 }
 
 static int f2fs_create_whiteout(struct user_namespace *mnt_userns,
@@ -933,7 +937,13 @@ static int f2fs_create_whiteout(struct user_namespace *mnt_userns,
 		return -EIO;
 
 	return __f2fs_tmpfile(mnt_userns, dir, NULL,
-				S_IFCHR | WHITEOUT_MODE, whiteout);
+				S_IFCHR | WHITEOUT_MODE, true, whiteout);
+}
+
+int f2fs_get_tmpfile(struct user_namespace *mnt_userns, struct inode *dir,
+		     struct inode **new_inode)
+{
+	return __f2fs_tmpfile(mnt_userns, dir, NULL, S_IFREG, false, new_inode);
 }
 
 static int f2fs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index aedc3d334113..9dabf99eedc5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -90,10 +90,6 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 				atomic_read(&sbi->total_ext_node) *
 				sizeof(struct extent_node)) >> PAGE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
-	} else if (type == INMEM_PAGES) {
-		/* it allows 20% / total_ram for inmemory pages */
-		mem_size = get_pages(sbi, F2FS_INMEM_PAGES);
-		res = mem_size < (val.totalram / 5);
 	} else if (type == DISCARD_CACHE) {
 		mem_size = (atomic_read(&dcc->discard_cmd_cnt) *
 				sizeof(struct discard_cmd)) >> PAGE_SHIFT;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 4c1d34bfea78..3c09cae058b0 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -147,7 +147,6 @@ enum mem_type {
 	DIRTY_DENTS,	/* indicates dirty dentry pages */
 	INO_ENTRIES,	/* indicates inode entries */
 	EXTENT_CACHE,	/* indicates extent cache */
-	INMEM_PAGES,	/* indicates inmemory pages */
 	DISCARD_CACHE,	/* indicates memory of cached discard cmds */
 	COMPRESS_PAGE,	/* indicates memory of cached compressed pages */
 	BASE_CHECK,	/* check kernel status */
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a914b70f8543..86a3c5a5a564 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -30,7 +30,7 @@
 static struct kmem_cache *discard_entry_slab;
 static struct kmem_cache *discard_cmd_slab;
 static struct kmem_cache *sit_entry_set_slab;
-static struct kmem_cache *inmem_entry_slab;
+static struct kmem_cache *revoke_entry_slab;
 
 static unsigned long __reverse_ulong(unsigned char *str)
 {
@@ -185,304 +185,180 @@ bool f2fs_need_SSR(struct f2fs_sb_info *sbi)
 			SM_I(sbi)->min_ssr_sections + reserved_sections(sbi));
 }
 
-void f2fs_register_inmem_page(struct inode *inode, struct page *page)
+void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 {
-	struct inmem_pages *new;
-
-	set_page_private_atomic(page);
-
-	new = f2fs_kmem_cache_alloc(inmem_entry_slab,
-					GFP_NOFS, true, NULL);
-
-	/* add atomic page indices to the list */
-	new->page = page;
-	INIT_LIST_HEAD(&new->list);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 
-	/* increase reference count with clean state */
-	get_page(page);
-	mutex_lock(&F2FS_I(inode)->inmem_lock);
-	list_add_tail(&new->list, &F2FS_I(inode)->inmem_pages);
-	inc_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
-	mutex_unlock(&F2FS_I(inode)->inmem_lock);
+	if (f2fs_is_atomic_file(inode)) {
+		if (clean)
+			truncate_inode_pages_final(inode->i_mapping);
+		clear_inode_flag(fi->cow_inode, FI_ATOMIC_FILE);
+		iput(fi->cow_inode);
+		fi->cow_inode = NULL;
+		clear_inode_flag(inode, FI_ATOMIC_FILE);
 
-	trace_f2fs_register_inmem_page(page, INMEM);
+		spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
+		sbi->atomic_files--;
+		spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
+	}
 }
 
-static int __revoke_inmem_pages(struct inode *inode,
-				struct list_head *head, bool drop, bool recover,
-				bool trylock)
+static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
+			block_t new_addr, block_t *old_addr, bool recover)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct inmem_pages *cur, *tmp;
-	int err = 0;
-
-	list_for_each_entry_safe(cur, tmp, head, list) {
-		struct page *page = cur->page;
-
-		if (drop)
-			trace_f2fs_commit_inmem_page(page, INMEM_DROP);
-
-		if (trylock) {
-			/*
-			 * to avoid deadlock in between page lock and
-			 * inmem_lock.
-			 */
-			if (!trylock_page(page))
-				continue;
-		} else {
-			lock_page(page);
-		}
-
-		f2fs_wait_on_page_writeback(page, DATA, true, true);
-
-		if (recover) {
-			struct dnode_of_data dn;
-			struct node_info ni;
+	struct dnode_of_data dn;
+	struct node_info ni;
+	int err;
 
-			trace_f2fs_commit_inmem_page(page, INMEM_REVOKE);
 retry:
-			set_new_dnode(&dn, inode, NULL, NULL, 0);
-			err = f2fs_get_dnode_of_data(&dn, page->index,
-								LOOKUP_NODE);
-			if (err) {
-				if (err == -ENOMEM) {
-					memalloc_retry_wait(GFP_NOFS);
-					goto retry;
-				}
-				err = -EAGAIN;
-				goto next;
-			}
-
-			err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
-			if (err) {
-				f2fs_put_dnode(&dn);
-				return err;
-			}
-
-			if (cur->old_addr == NEW_ADDR) {
-				f2fs_invalidate_blocks(sbi, dn.data_blkaddr);
-				f2fs_update_data_blkaddr(&dn, NEW_ADDR);
-			} else
-				f2fs_replace_block(sbi, &dn, dn.data_blkaddr,
-					cur->old_addr, ni.version, true, true);
-			f2fs_put_dnode(&dn);
-		}
-next:
-		/* we don't need to invalidate this in the sccessful status */
-		if (drop || recover) {
-			ClearPageUptodate(page);
-			clear_page_private_gcing(page);
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	err = f2fs_get_dnode_of_data(&dn, index, LOOKUP_NODE_RA);
+	if (err) {
+		if (err == -ENOMEM) {
+			f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
+			goto retry;
 		}
-		detach_page_private(page);
-		set_page_private(page, 0);
-		f2fs_put_page(page, 1);
-
-		list_del(&cur->list);
-		kmem_cache_free(inmem_entry_slab, cur);
-		dec_page_count(F2FS_I_SB(inode), F2FS_INMEM_PAGES);
+		return err;
 	}
-	return err;
-}
 
-void f2fs_drop_inmem_pages_all(struct f2fs_sb_info *sbi, bool gc_failure)
-{
-	struct list_head *head = &sbi->inode_list[ATOMIC_FILE];
-	struct inode *inode;
-	struct f2fs_inode_info *fi;
-	unsigned int count = sbi->atomic_files;
-	unsigned int looped = 0;
-next:
-	spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
-	if (list_empty(head)) {
-		spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
-		return;
+	err = f2fs_get_node_info(sbi, dn.nid, &ni, false);
+	if (err) {
+		f2fs_put_dnode(&dn);
+		return err;
 	}
-	fi = list_first_entry(head, struct f2fs_inode_info, inmem_ilist);
-	inode = igrab(&fi->vfs_inode);
-	if (inode)
-		list_move_tail(&fi->inmem_ilist, head);
-	spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
 
-	if (inode) {
-		if (gc_failure) {
-			if (!fi->i_gc_failures[GC_FAILURE_ATOMIC])
-				goto skip;
+	if (recover) {
+		/* dn.data_blkaddr is always valid */
+		if (!__is_valid_data_blkaddr(new_addr)) {
+			if (new_addr == NULL_ADDR)
+				dec_valid_block_count(sbi, inode, 1);
+			f2fs_invalidate_blocks(sbi, dn.data_blkaddr);
+			f2fs_update_data_blkaddr(&dn, new_addr);
+		} else {
+			f2fs_replace_block(sbi, &dn, dn.data_blkaddr,
+				new_addr, ni.version, true, true);
 		}
-		set_inode_flag(inode, FI_ATOMIC_REVOKE_REQUEST);
-		f2fs_drop_inmem_pages(inode);
-skip:
-		iput(inode);
-	}
-	f2fs_io_schedule_timeout(DEFAULT_IO_TIMEOUT);
-	if (gc_failure) {
-		if (++looped >= count)
-			return;
-	}
-	goto next;
-}
-
-void f2fs_drop_inmem_pages(struct inode *inode)
-{
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct f2fs_inode_info *fi = F2FS_I(inode);
+	} else {
+		blkcnt_t count = 1;
 
-	do {
-		mutex_lock(&fi->inmem_lock);
-		if (list_empty(&fi->inmem_pages)) {
-			fi->i_gc_failures[GC_FAILURE_ATOMIC] = 0;
-
-			spin_lock(&sbi->inode_lock[ATOMIC_FILE]);
-			if (!list_empty(&fi->inmem_ilist))
-				list_del_init(&fi->inmem_ilist);
-			if (f2fs_is_atomic_file(inode)) {
-				clear_inode_flag(inode, FI_ATOMIC_FILE);
-				sbi->atomic_files--;
-			}
-			spin_unlock(&sbi->inode_lock[ATOMIC_FILE]);
+		*old_addr = dn.data_blkaddr;
+		f2fs_truncate_data_blocks_range(&dn, 1);
+		dec_valid_block_count(sbi, F2FS_I(inode)->cow_inode, count);
+		inc_valid_block_count(sbi, inode, &count);
+		f2fs_replace_block(sbi, &dn, dn.data_blkaddr, new_addr,
+					ni.version, true, false);
+	}
 
-			mutex_unlock(&fi->inmem_lock);
-			break;
-		}
-		__revoke_inmem_pages(inode, &fi->inmem_pages,
-						true, false, true);
-		mutex_unlock(&fi->inmem_lock);
-	} while (1);
+	f2fs_put_dnode(&dn);
+	return 0;
 }
 
-void f2fs_drop_inmem_page(struct inode *inode, struct page *page)
+static void __complete_revoke_list(struct inode *inode, struct list_head *head,
+					bool revoke)
 {
-	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct list_head *head = &fi->inmem_pages;
-	struct inmem_pages *cur = NULL;
-	struct inmem_pages *tmp;
-
-	f2fs_bug_on(sbi, !page_private_atomic(page));
+	struct revoke_entry *cur, *tmp;
 
-	mutex_lock(&fi->inmem_lock);
-	list_for_each_entry(tmp, head, list) {
-		if (tmp->page == page) {
-			cur = tmp;
-			break;
-		}
+	list_for_each_entry_safe(cur, tmp, head, list) {
+		if (revoke)
+			__replace_atomic_write_block(inode, cur->index,
+						cur->old_addr, NULL, true);
+		list_del(&cur->list);
+		kmem_cache_free(revoke_entry_slab, cur);
 	}
-
-	f2fs_bug_on(sbi, !cur);
-	list_del(&cur->list);
-	mutex_unlock(&fi->inmem_lock);
-
-	dec_page_count(sbi, F2FS_INMEM_PAGES);
-	kmem_cache_free(inmem_entry_slab, cur);
-
-	ClearPageUptodate(page);
-	clear_page_private_atomic(page);
-	f2fs_put_page(page, 0);
-
-	detach_page_private(page);
-	set_page_private(page, 0);
-
-	trace_f2fs_commit_inmem_page(page, INMEM_INVALIDATE);
 }
 
-static int __f2fs_commit_inmem_pages(struct inode *inode)
+static int __f2fs_commit_atomic_write(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
-	struct inmem_pages *cur, *tmp;
-	struct f2fs_io_info fio = {
-		.sbi = sbi,
-		.ino = inode->i_ino,
-		.type = DATA,
-		.op = REQ_OP_WRITE,
-		.op_flags = REQ_SYNC | REQ_PRIO,
-		.io_type = FS_DATA_IO,
-	};
+	struct inode *cow_inode = fi->cow_inode;
+	struct revoke_entry *new;
 	struct list_head revoke_list;
-	bool submit_bio = false;
-	int err = 0;
+	block_t blkaddr;
+	struct dnode_of_data dn;
+	pgoff_t len = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
+	pgoff_t off = 0, blen, index;
+	int ret = 0, i;
 
 	INIT_LIST_HEAD(&revoke_list);
 
-	list_for_each_entry_safe(cur, tmp, &fi->inmem_pages, list) {
-		struct page *page = cur->page;
+	while (len) {
+		blen = min_t(pgoff_t, ADDRS_PER_BLOCK(cow_inode), len);
 
-		lock_page(page);
-		if (page->mapping == inode->i_mapping) {
-			trace_f2fs_commit_inmem_page(page, INMEM);
+		set_new_dnode(&dn, cow_inode, NULL, NULL, 0);
+		ret = f2fs_get_dnode_of_data(&dn, off, LOOKUP_NODE_RA);
+		if (ret && ret != -ENOENT) {
+			goto out;
+		} else if (ret == -ENOENT) {
+			ret = 0;
+			if (dn.max_level == 0)
+				goto out;
+			goto next;
+		}
 
-			f2fs_wait_on_page_writeback(page, DATA, true, true);
+		blen = min((pgoff_t)ADDRS_PER_PAGE(dn.node_page, cow_inode),
+				len);
+		index = off;
+		for (i = 0; i < blen; i++, dn.ofs_in_node++, index++) {
+			blkaddr = f2fs_data_blkaddr(&dn);
 
-			set_page_dirty(page);
-			if (clear_page_dirty_for_io(page)) {
-				inode_dec_dirty_pages(inode);
-				f2fs_remove_dirty_inode(inode);
-			}
-retry:
-			fio.page = page;
-			fio.old_blkaddr = NULL_ADDR;
-			fio.encrypted_page = NULL;
-			fio.need_lock = LOCK_DONE;
-			err = f2fs_do_write_data_page(&fio);
-			if (err) {
-				if (err == -ENOMEM) {
-					memalloc_retry_wait(GFP_NOFS);
-					goto retry;
-				}
-				unlock_page(page);
-				break;
+			if (!__is_valid_data_blkaddr(blkaddr)) {
+				continue;
+			} else if (!f2fs_is_valid_blkaddr(sbi, blkaddr,
+					DATA_GENERIC_ENHANCE)) {
+				f2fs_put_dnode(&dn);
+				ret = -EFSCORRUPTED;
+				goto out;
 			}
-			/* record old blkaddr for revoking */
-			cur->old_addr = fio.old_blkaddr;
-			submit_bio = true;
-		}
-		unlock_page(page);
-		list_move_tail(&cur->list, &revoke_list);
-	}
 
-	if (submit_bio)
-		f2fs_submit_merged_write_cond(sbi, inode, NULL, 0, DATA);
+			new = f2fs_kmem_cache_alloc(revoke_entry_slab, GFP_NOFS,
+							true, NULL);
+			if (!new) {
+				f2fs_put_dnode(&dn);
+				ret = -ENOMEM;
+				goto out;
+			}
 
-	if (err) {
-		/*
-		 * try to revoke all committed pages, but still we could fail
-		 * due to no memory or other reason, if that happened, EAGAIN
-		 * will be returned, which means in such case, transaction is
-		 * already not integrity, caller should use journal to do the
-		 * recovery or rewrite & commit last transaction. For other
-		 * error number, revoking was done by filesystem itself.
-		 */
-		err = __revoke_inmem_pages(inode, &revoke_list,
-						false, true, false);
+			ret = __replace_atomic_write_block(inode, index, blkaddr,
+							&new->old_addr, false);
+			if (ret) {
+				f2fs_put_dnode(&dn);
+				kmem_cache_free(revoke_entry_slab, new);
+				goto out;
+			}
 
-		/* drop all uncommitted pages */
-		__revoke_inmem_pages(inode, &fi->inmem_pages,
-						true, false, false);
-	} else {
-		__revoke_inmem_pages(inode, &revoke_list,
-						false, false, false);
+			f2fs_update_data_blkaddr(&dn, NULL_ADDR);
+			new->index = index;
+			list_add_tail(&new->list, &revoke_list);
+		}
+		f2fs_put_dnode(&dn);
+next:
+		off += blen;
+		len -= blen;
 	}
 
-	return err;
+out:
+	__complete_revoke_list(inode, &revoke_list, ret ? true : false);
+
+	return ret;
 }
 
-int f2fs_commit_inmem_pages(struct inode *inode)
+int f2fs_commit_atomic_write(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	int err;
 
-	f2fs_balance_fs(sbi, true);
+	err = filemap_write_and_wait_range(inode->i_mapping, 0, LLONG_MAX);
+	if (err)
+		return err;
 
 	f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
-
 	f2fs_lock_op(sbi);
-	set_inode_flag(inode, FI_ATOMIC_COMMIT);
-
-	mutex_lock(&fi->inmem_lock);
-	err = __f2fs_commit_inmem_pages(inode);
-	mutex_unlock(&fi->inmem_lock);
 
-	clear_inode_flag(inode, FI_ATOMIC_COMMIT);
+	err = __f2fs_commit_atomic_write(inode);
 
 	f2fs_unlock_op(sbi);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
@@ -5359,9 +5235,9 @@ int __init f2fs_create_segment_manager_caches(void)
 	if (!sit_entry_set_slab)
 		goto destroy_discard_cmd;
 
-	inmem_entry_slab = f2fs_kmem_cache_create("f2fs_inmem_page_entry",
-			sizeof(struct inmem_pages));
-	if (!inmem_entry_slab)
+	revoke_entry_slab = f2fs_kmem_cache_create("f2fs_revoke_entry",
+			sizeof(struct revoke_entry));
+	if (!revoke_entry_slab)
 		goto destroy_sit_entry_set;
 	return 0;
 
@@ -5380,5 +5256,5 @@ void f2fs_destroy_segment_manager_caches(void)
 	kmem_cache_destroy(sit_entry_set_slab);
 	kmem_cache_destroy(discard_cmd_slab);
 	kmem_cache_destroy(discard_entry_slab);
-	kmem_cache_destroy(inmem_entry_slab);
+	kmem_cache_destroy(revoke_entry_slab);
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 8fbc9f6afa55..3f277dfcb131 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -225,10 +225,10 @@ struct segment_allocation {
 
 #define MAX_SKIP_GC_COUNT			16
 
-struct inmem_pages {
+struct revoke_entry {
 	struct list_head list;
-	struct page *page;
 	block_t old_addr;		/* for revoking when fail to commit */
+	pgoff_t index;
 };
 
 struct sit_info {
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1b59f95606c7..e3539c027a6c 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1339,9 +1339,6 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);
 	INIT_LIST_HEAD(&fi->gdirty_list);
-	INIT_LIST_HEAD(&fi->inmem_ilist);
-	INIT_LIST_HEAD(&fi->inmem_pages);
-	mutex_init(&fi->inmem_lock);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[READ]);
 	init_f2fs_rwsem(&fi->i_gc_rwsem[WRITE]);
 	init_f2fs_rwsem(&fi->i_xattr_sem);
@@ -1382,9 +1379,8 @@ static int f2fs_drop_inode(struct inode *inode)
 			atomic_inc(&inode->i_count);
 			spin_unlock(&inode->i_lock);
 
-			/* some remained atomic pages should discarded */
 			if (f2fs_is_atomic_file(inode))
-				f2fs_drop_inmem_pages(inode);
+				f2fs_abort_atomic_write(inode, true);
 
 			/* should remain fi->extent_tree for writepage */
 			f2fs_destroy_extent_node(inode);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 1779e133cea0..d91370377523 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -15,10 +15,6 @@ TRACE_DEFINE_ENUM(NODE);
 TRACE_DEFINE_ENUM(DATA);
 TRACE_DEFINE_ENUM(META);
 TRACE_DEFINE_ENUM(META_FLUSH);
-TRACE_DEFINE_ENUM(INMEM);
-TRACE_DEFINE_ENUM(INMEM_DROP);
-TRACE_DEFINE_ENUM(INMEM_INVALIDATE);
-TRACE_DEFINE_ENUM(INMEM_REVOKE);
 TRACE_DEFINE_ENUM(IPU);
 TRACE_DEFINE_ENUM(OPU);
 TRACE_DEFINE_ENUM(HOT);
@@ -59,10 +55,6 @@ TRACE_DEFINE_ENUM(CP_RESIZE);
 		{ DATA,		"DATA" },				\
 		{ META,		"META" },				\
 		{ META_FLUSH,	"META_FLUSH" },				\
-		{ INMEM,	"INMEM" },				\
-		{ INMEM_DROP,	"INMEM_DROP" },				\
-		{ INMEM_INVALIDATE,	"INMEM_INVALIDATE" },		\
-		{ INMEM_REVOKE,	"INMEM_REVOKE" },			\
 		{ IPU,		"IN-PLACE" },				\
 		{ OPU,		"OUT-OF-PLACE" })
 
@@ -1289,20 +1281,6 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
-DEFINE_EVENT(f2fs__page, f2fs_register_inmem_page,
-
-	TP_PROTO(struct page *page, int type),
-
-	TP_ARGS(page, type)
-);
-
-DEFINE_EVENT(f2fs__page, f2fs_commit_inmem_page,
-
-	TP_PROTO(struct page *page, int type),
-
-	TP_ARGS(page, type)
-);
-
 TRACE_EVENT(f2fs_filemap_fault,
 
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long ret),
-- 
2.35.1



