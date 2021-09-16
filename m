Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F25440E236
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242482AbhIPQf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242881AbhIPQdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898EC6124D;
        Thu, 16 Sep 2021 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809233;
        bh=q9oekycMO6sU+VC3t8stqT3YMADmNI7sl1Pw4YacYiY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrvdRKKp1WAQ1uSclfaj1yOFMz+WaY6K964NKVdnLOGrlqBQVUdc5LuwvFHi0KXbl
         N4W3SLFFtBIvXlf09RyyeBOS9OdRaNdvusqQfqOnmgqUv4aO19TtCnmwPRnqMnqiWC
         bn8Rd+uyXbnIFtjmDF+oXkOx5GnI9ehW7I9XHmws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/380] f2fs: compress: add compress_inode to cache compressed blocks
Date:   Thu, 16 Sep 2021 17:57:17 +0200
Message-Id: <20210916155806.749491861@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 6ce19aff0b8cd386860855185c6cd79337fc4d2b ]

Support to use address space of inner inode to cache compressed block,
in order to improve cache hit ratio of random read.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/filesystems/f2fs.rst |   3 +
 fs/f2fs/compress.c                 | 168 ++++++++++++++++++++++++++++-
 fs/f2fs/data.c                     |  41 +++++--
 fs/f2fs/debug.c                    |  13 +++
 fs/f2fs/f2fs.h                     |  71 +++++++++++-
 fs/f2fs/gc.c                       |   1 +
 fs/f2fs/inode.c                    |  21 +++-
 fs/f2fs/node.c                     |  14 +++
 fs/f2fs/node.h                     |   1 +
 fs/f2fs/segment.c                  |   6 +-
 fs/f2fs/super.c                    |  35 +++++-
 include/linux/f2fs_fs.h            |   1 +
 12 files changed, 361 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 53d396650afb..b91e5a8444d5 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -289,6 +289,9 @@ compress_mode=%s	 Control file compression mode. This supports "fs" and "user"
 			 choosing the target file and the timing. The user can do manual
 			 compression/decompression on the compression enabled files using
 			 ioctls.
+compress_cache		 Support to use address space of a filesystem managed inode to
+			 cache compressed block, in order to improve cache hit ratio of
+			 random read.
 inlinecrypt		 When possible, encrypt/decrypt the contents of encrypted
 			 files using the blk-crypto framework rather than
 			 filesystem-layer encryption. This allows the use of
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 1c65384d13f3..ba188722ba43 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -12,9 +12,11 @@
 #include <linux/lzo.h>
 #include <linux/lz4.h>
 #include <linux/zstd.h>
+#include <linux/pagevec.h>
 
 #include "f2fs.h"
 #include "node.h"
+#include "segment.h"
 #include <trace/events/f2fs.h>
 
 static struct kmem_cache *cic_entry_slab;
@@ -736,7 +738,7 @@ static int f2fs_compress_pages(struct compress_ctx *cc)
 	return ret;
 }
 
-static void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
+void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
 	struct f2fs_inode_info *fi = F2FS_I(dic->inode);
@@ -835,7 +837,8 @@ static void f2fs_decompress_cluster(struct decompress_io_ctx *dic)
  * page being waited on in the cluster, and if so, it decompresses the cluster
  * (or in the case of a failure, cleans up without actually decompressing).
  */
-void f2fs_end_read_compressed_page(struct page *page, bool failed)
+void f2fs_end_read_compressed_page(struct page *page, bool failed,
+						block_t blkaddr)
 {
 	struct decompress_io_ctx *dic =
 			(struct decompress_io_ctx *)page_private(page);
@@ -845,6 +848,9 @@ void f2fs_end_read_compressed_page(struct page *page, bool failed)
 
 	if (failed)
 		WRITE_ONCE(dic->failed, true);
+	else if (blkaddr)
+		f2fs_cache_compressed_page(sbi, page,
+					dic->inode->i_ino, blkaddr);
 
 	if (atomic_dec_and_test(&dic->remaining_pages))
 		f2fs_decompress_cluster(dic);
@@ -1683,6 +1689,164 @@ void f2fs_put_page_dic(struct page *page)
 	f2fs_put_dic(dic);
 }
 
+const struct address_space_operations f2fs_compress_aops = {
+	.releasepage = f2fs_release_page,
+	.invalidatepage = f2fs_invalidate_page,
+};
+
+struct address_space *COMPRESS_MAPPING(struct f2fs_sb_info *sbi)
+{
+	return sbi->compress_inode->i_mapping;
+}
+
+void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi, block_t blkaddr)
+{
+	if (!sbi->compress_inode)
+		return;
+	invalidate_mapping_pages(COMPRESS_MAPPING(sbi), blkaddr, blkaddr);
+}
+
+void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t ino, block_t blkaddr)
+{
+	struct page *cpage;
+	int ret;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return;
+
+	if (!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE_READ))
+		return;
+
+	if (!f2fs_available_free_memory(sbi, COMPRESS_PAGE))
+		return;
+
+	cpage = find_get_page(COMPRESS_MAPPING(sbi), blkaddr);
+	if (cpage) {
+		f2fs_put_page(cpage, 0);
+		return;
+	}
+
+	cpage = alloc_page(__GFP_NOWARN | __GFP_IO);
+	if (!cpage)
+		return;
+
+	ret = add_to_page_cache_lru(cpage, COMPRESS_MAPPING(sbi),
+						blkaddr, GFP_NOFS);
+	if (ret) {
+		f2fs_put_page(cpage, 0);
+		return;
+	}
+
+	set_page_private_data(cpage, ino);
+
+	if (!f2fs_is_valid_blkaddr(sbi, blkaddr, DATA_GENERIC_ENHANCE_READ))
+		goto out;
+
+	memcpy(page_address(cpage), page_address(page), PAGE_SIZE);
+	SetPageUptodate(cpage);
+out:
+	f2fs_put_page(cpage, 1);
+}
+
+bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+								block_t blkaddr)
+{
+	struct page *cpage;
+	bool hitted = false;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return false;
+
+	cpage = f2fs_pagecache_get_page(COMPRESS_MAPPING(sbi),
+				blkaddr, FGP_LOCK | FGP_NOWAIT, GFP_NOFS);
+	if (cpage) {
+		if (PageUptodate(cpage)) {
+			atomic_inc(&sbi->compress_page_hit);
+			memcpy(page_address(page),
+				page_address(cpage), PAGE_SIZE);
+			hitted = true;
+		}
+		f2fs_put_page(cpage, 1);
+	}
+
+	return hitted;
+}
+
+void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino)
+{
+	struct address_space *mapping = sbi->compress_inode->i_mapping;
+	struct pagevec pvec;
+	pgoff_t index = 0;
+	pgoff_t end = MAX_BLKADDR(sbi);
+
+	if (!mapping->nrpages)
+		return;
+
+	pagevec_init(&pvec);
+
+	do {
+		unsigned int nr_pages;
+		int i;
+
+		nr_pages = pagevec_lookup_range(&pvec, mapping,
+						&index, end - 1);
+		if (!nr_pages)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			if (page->index > end)
+				break;
+
+			lock_page(page);
+			if (page->mapping != mapping) {
+				unlock_page(page);
+				continue;
+			}
+
+			if (ino != get_page_private_data(page)) {
+				unlock_page(page);
+				continue;
+			}
+
+			generic_error_remove_page(mapping, page);
+			unlock_page(page);
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	} while (index < end);
+}
+
+int f2fs_init_compress_inode(struct f2fs_sb_info *sbi)
+{
+	struct inode *inode;
+
+	if (!test_opt(sbi, COMPRESS_CACHE))
+		return 0;
+
+	inode = f2fs_iget(sbi->sb, F2FS_COMPRESS_INO(sbi));
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+	sbi->compress_inode = inode;
+
+	sbi->compress_percent = COMPRESS_PERCENT;
+	sbi->compress_watermark = COMPRESS_WATERMARK;
+
+	atomic_set(&sbi->compress_page_hit, 0);
+
+	return 0;
+}
+
+void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi)
+{
+	if (!sbi->compress_inode)
+		return;
+	iput(sbi->compress_inode);
+	sbi->compress_inode = NULL;
+}
+
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi)
 {
 	dev_t dev = sbi->sb->s_bdev->bd_dev;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d4795eda12fa..3058c7e28b11 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -132,7 +132,7 @@ static void f2fs_finish_read_bio(struct bio *bio)
 
 		if (f2fs_is_compressed_page(page)) {
 			if (bio->bi_status)
-				f2fs_end_read_compressed_page(page, true);
+				f2fs_end_read_compressed_page(page, true, 0);
 			f2fs_put_page_dic(page);
 			continue;
 		}
@@ -228,15 +228,19 @@ static void f2fs_handle_step_decompress(struct bio_post_read_ctx *ctx)
 	struct bio_vec *bv;
 	struct bvec_iter_all iter_all;
 	bool all_compressed = true;
+	block_t blkaddr = SECTOR_TO_BLOCK(ctx->bio->bi_iter.bi_sector);
 
 	bio_for_each_segment_all(bv, ctx->bio, iter_all) {
 		struct page *page = bv->bv_page;
 
 		/* PG_error was set if decryption failed. */
 		if (f2fs_is_compressed_page(page))
-			f2fs_end_read_compressed_page(page, PageError(page));
+			f2fs_end_read_compressed_page(page, PageError(page),
+						blkaddr);
 		else
 			all_compressed = false;
+
+		blkaddr++;
 	}
 
 	/*
@@ -1352,9 +1356,11 @@ static int __allocate_data_block(struct dnode_of_data *dn, int seg_type)
 	old_blkaddr = dn->data_blkaddr;
 	f2fs_allocate_data_block(sbi, NULL, old_blkaddr, &dn->data_blkaddr,
 				&sum, seg_type, NULL);
-	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO)
+	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(sbi),
 					old_blkaddr, old_blkaddr);
+		f2fs_invalidate_compress_page(sbi, old_blkaddr);
+	}
 	f2fs_update_data_blkaddr(dn, dn->data_blkaddr);
 
 	/*
@@ -2174,7 +2180,7 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 		goto out_put_dnode;
 	}
 
-	for (i = 0; i < dic->nr_cpages; i++) {
+	for (i = 0; i < cc->nr_cpages; i++) {
 		struct page *page = dic->cpages[i];
 		block_t blkaddr;
 		struct bio_post_read_ctx *ctx;
@@ -2182,6 +2188,14 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 		blkaddr = data_blkaddr(dn.inode, dn.node_page,
 						dn.ofs_in_node + i + 1);
 
+		f2fs_wait_on_block_writeback(inode, blkaddr);
+
+		if (f2fs_load_compressed_page(sbi, page, blkaddr)) {
+			if (atomic_dec_and_test(&dic->remaining_pages))
+				f2fs_decompress_cluster(dic);
+			continue;
+		}
+
 		if (bio && (!page_is_mergeable(sbi, bio,
 					*last_block_in_bio, blkaddr) ||
 		    !f2fs_crypt_mergeable_bio(bio, inode, page->index, NULL))) {
@@ -2203,8 +2217,6 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 			}
 		}
 
-		f2fs_wait_on_block_writeback(inode, blkaddr);
-
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
 			goto submit_and_realloc;
 
@@ -3618,6 +3630,13 @@ void f2fs_invalidate_page(struct page *page, unsigned int offset,
 
 	clear_page_private_gcing(page);
 
+	if (test_opt(sbi, COMPRESS_CACHE)) {
+		if (f2fs_compressed_file(inode))
+			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
+			clear_page_private_data(page);
+	}
+
 	if (page_private_atomic(page))
 		return f2fs_drop_inmem_page(inode, page);
 
@@ -3635,6 +3654,16 @@ int f2fs_release_page(struct page *page, gfp_t wait)
 	if (page_private_atomic(page))
 		return 0;
 
+	if (test_opt(F2FS_P_SB(page), COMPRESS_CACHE)) {
+		struct f2fs_sb_info *sbi = F2FS_P_SB(page);
+		struct inode *inode = page->mapping->host;
+
+		if (f2fs_compressed_file(inode))
+			f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+		if (inode->i_ino == F2FS_COMPRESS_INO(sbi))
+			clear_page_private_data(page);
+	}
+
 	clear_page_private_gcing(page);
 
 	detach_page_private(page);
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index c03949a7ccff..833325038ef3 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -152,6 +152,12 @@ static void update_general_status(struct f2fs_sb_info *sbi)
 		si->node_pages = NODE_MAPPING(sbi)->nrpages;
 	if (sbi->meta_inode)
 		si->meta_pages = META_MAPPING(sbi)->nrpages;
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (sbi->compress_inode) {
+		si->compress_pages = COMPRESS_MAPPING(sbi)->nrpages;
+		si->compress_page_hit = atomic_read(&sbi->compress_page_hit);
+	}
+#endif
 	si->nats = NM_I(sbi)->nat_cnt[TOTAL_NAT];
 	si->dirty_nats = NM_I(sbi)->nat_cnt[DIRTY_NAT];
 	si->sits = MAIN_SEGS(sbi);
@@ -309,6 +315,12 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 
 		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
 	}
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (sbi->compress_inode) {
+		unsigned npages = COMPRESS_MAPPING(sbi)->nrpages;
+		si->page_mem += (unsigned long long)npages << PAGE_SHIFT;
+	}
+#endif
 }
 
 static int stat_show(struct seq_file *s, void *v)
@@ -476,6 +488,7 @@ static int stat_show(struct seq_file *s, void *v)
 			"volatile IO: %4d (Max. %4d)\n",
 			   si->inmem_pages, si->aw_cnt, si->max_aw_cnt,
 			   si->vw_cnt, si->max_vw_cnt);
+		seq_printf(s, "  - compress: %4d, hit:%8d\n", si->compress_pages, si->compress_page_hit);
 		seq_printf(s, "  - nodes: %4d in %4d\n",
 			   si->ndirty_node, si->node_pages);
 		seq_printf(s, "  - dents: %4d in dirs:%4d (%4d)\n",
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a0e828b5c701..7084b42a4437 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -98,6 +98,7 @@ extern const char *f2fs_fault_name[FAULT_MAX];
 #define F2FS_MOUNT_ATGC			0x08000000
 #define F2FS_MOUNT_MERGE_CHECKPOINT	0x10000000
 #define	F2FS_MOUNT_GC_MERGE		0x20000000
+#define F2FS_MOUNT_COMPRESS_CACHE	0x40000000
 
 #define F2FS_OPTION(sbi)	((sbi)->mount_opt)
 #define clear_opt(sbi, option)	(F2FS_OPTION(sbi).opt &= ~F2FS_MOUNT_##option)
@@ -1371,6 +1372,37 @@ PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
 PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
 PAGE_PRIVATE_CLEAR_FUNC(dummy, DUMMY_WRITE);
 
+static inline unsigned long get_page_private_data(struct page *page)
+{
+	unsigned long data = page_private(page);
+
+	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+		return 0;
+	return data >> PAGE_PRIVATE_MAX;
+}
+
+static inline void set_page_private_data(struct page *page, unsigned long data)
+{
+	if (!PagePrivate(page)) {
+		get_page(page);
+		SetPagePrivate(page);
+	}
+	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page));
+	page_private(page) |= data << PAGE_PRIVATE_MAX;
+}
+
+static inline void clear_page_private_data(struct page *page)
+{
+	page_private(page) &= (1 << PAGE_PRIVATE_MAX) - 1;
+	if (page_private(page) == 1 << PAGE_PRIVATE_NOT_POINTER) {
+		set_page_private(page, 0);
+		if (PagePrivate(page)) {
+			ClearPagePrivate(page);
+			put_page(page);
+		}
+	}
+}
+
 /* For compression */
 enum compress_algorithm_type {
 	COMPRESS_LZO,
@@ -1385,6 +1417,9 @@ enum compress_flag {
 	COMPRESS_MAX_FLAG,
 };
 
+#define	COMPRESS_WATERMARK			20
+#define	COMPRESS_PERCENT			20
+
 #define COMPRESS_DATA_RESERVED_SIZE		4
 struct compress_data {
 	__le32 clen;			/* compressed data size */
@@ -1694,6 +1729,12 @@ struct f2fs_sb_info {
 	u64 compr_written_block;
 	u64 compr_saved_block;
 	u32 compr_new_inode;
+
+	/* For compressed block cache */
+	struct inode *compress_inode;		/* cache compressed blocks */
+	unsigned int compress_percent;		/* cache page percentage */
+	unsigned int compress_watermark;	/* cache page watermark */
+	atomic_t compress_page_hit;		/* cache hit count */
 #endif
 };
 
@@ -3660,7 +3701,8 @@ struct f2fs_stat_info {
 	unsigned int bimodal, avg_vblocks;
 	int util_free, util_valid, util_invalid;
 	int rsvd_segs, overp_segs;
-	int dirty_count, node_pages, meta_pages;
+	int dirty_count, node_pages, meta_pages, compress_pages;
+	int compress_page_hit;
 	int prefree_count, call_count, cp_count, bg_cp_count;
 	int tot_segs, node_segs, data_segs, free_segs, free_secs;
 	int bg_node_segs, bg_data_segs;
@@ -3996,7 +4038,9 @@ void f2fs_compress_write_end_io(struct bio *bio, struct page *page);
 bool f2fs_is_compress_backend_ready(struct inode *inode);
 int f2fs_init_compress_mempool(void);
 void f2fs_destroy_compress_mempool(void);
-void f2fs_end_read_compressed_page(struct page *page, bool failed);
+void f2fs_decompress_cluster(struct decompress_io_ctx *dic);
+void f2fs_end_read_compressed_page(struct page *page, bool failed,
+							block_t blkaddr);
 bool f2fs_cluster_is_empty(struct compress_ctx *cc);
 bool f2fs_cluster_can_merge_page(struct compress_ctx *cc, pgoff_t index);
 void f2fs_compress_ctx_add_page(struct compress_ctx *cc, struct page *page);
@@ -4014,10 +4058,19 @@ void f2fs_put_page_dic(struct page *page);
 int f2fs_init_compress_ctx(struct compress_ctx *cc);
 void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse);
 void f2fs_init_compress_info(struct f2fs_sb_info *sbi);
+int f2fs_init_compress_inode(struct f2fs_sb_info *sbi);
+void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi);
 int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi);
 void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi);
 int __init f2fs_init_compress_cache(void);
 void f2fs_destroy_compress_cache(void);
+struct address_space *COMPRESS_MAPPING(struct f2fs_sb_info *sbi);
+void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi, block_t blkaddr);
+void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+						nid_t ino, block_t blkaddr);
+bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi, struct page *page,
+								block_t blkaddr);
+void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi, nid_t ino);
 #define inc_compr_inode_stat(inode)					\
 	do {								\
 		struct f2fs_sb_info *sbi = F2FS_I_SB(inode);		\
@@ -4046,7 +4099,9 @@ static inline struct page *f2fs_compress_control_page(struct page *page)
 }
 static inline int f2fs_init_compress_mempool(void) { return 0; }
 static inline void f2fs_destroy_compress_mempool(void) { }
-static inline void f2fs_end_read_compressed_page(struct page *page, bool failed)
+static inline void f2fs_decompress_cluster(struct decompress_io_ctx *dic) { }
+static inline void f2fs_end_read_compressed_page(struct page *page,
+						bool failed, block_t blkaddr)
 {
 	WARN_ON_ONCE(1);
 }
@@ -4054,10 +4109,20 @@ static inline void f2fs_put_page_dic(struct page *page)
 {
 	WARN_ON_ONCE(1);
 }
+static inline int f2fs_init_compress_inode(struct f2fs_sb_info *sbi) { return 0; }
+static inline void f2fs_destroy_compress_inode(struct f2fs_sb_info *sbi) { }
 static inline int f2fs_init_page_array_cache(struct f2fs_sb_info *sbi) { return 0; }
 static inline void f2fs_destroy_page_array_cache(struct f2fs_sb_info *sbi) { }
 static inline int __init f2fs_init_compress_cache(void) { return 0; }
 static inline void f2fs_destroy_compress_cache(void) { }
+static inline void f2fs_invalidate_compress_page(struct f2fs_sb_info *sbi,
+				block_t blkaddr) { }
+static inline void f2fs_cache_compressed_page(struct f2fs_sb_info *sbi,
+				struct page *page, nid_t ino, block_t blkaddr) { }
+static inline bool f2fs_load_compressed_page(struct f2fs_sb_info *sbi,
+				struct page *page, block_t blkaddr) { return false; }
+static inline void f2fs_invalidate_compress_pages(struct f2fs_sb_info *sbi,
+							nid_t ino) { }
 #define inc_compr_inode_stat(inode)		do { } while (0)
 #endif
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 5ae066a71d4c..83b0a7872b3c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1261,6 +1261,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	f2fs_put_page(mpage, 1);
 	invalidate_mapping_pages(META_MAPPING(fio.sbi),
 				fio.old_blkaddr, fio.old_blkaddr);
+	f2fs_invalidate_compress_page(fio.sbi, fio.old_blkaddr);
 
 	set_page_dirty(fio.encrypted_page);
 	if (clear_page_dirty_for_io(fio.encrypted_page))
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index cbda7ca3b3be..9141147b5bb0 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -18,6 +18,10 @@
 
 #include <trace/events/f2fs.h>
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+extern const struct address_space_operations f2fs_compress_aops;
+#endif
+
 void f2fs_mark_inode_dirty_sync(struct inode *inode, bool sync)
 {
 	if (is_inode_flag_set(inode, FI_NEW_INODE))
@@ -494,6 +498,11 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	if (ino == F2FS_NODE_INO(sbi) || ino == F2FS_META_INO(sbi))
 		goto make_now;
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+	if (ino == F2FS_COMPRESS_INO(sbi))
+		goto make_now;
+#endif
+
 	ret = do_read_inode(inode);
 	if (ret)
 		goto bad_inode;
@@ -504,6 +513,12 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	} else if (ino == F2FS_META_INO(sbi)) {
 		inode->i_mapping->a_ops = &f2fs_meta_aops;
 		mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
+	} else if (ino == F2FS_COMPRESS_INO(sbi)) {
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		inode->i_mapping->a_ops = &f2fs_compress_aops;
+#endif
+		mapping_set_gfp_mask(inode->i_mapping,
+			GFP_NOFS | __GFP_HIGHMEM | __GFP_MOVABLE);
 	} else if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &f2fs_file_inode_operations;
 		inode->i_fop = &f2fs_file_operations;
@@ -723,8 +738,12 @@ void f2fs_evict_inode(struct inode *inode)
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
+	if (test_opt(sbi, COMPRESS_CACHE) && f2fs_compressed_file(inode))
+		f2fs_invalidate_compress_pages(sbi, inode->i_ino);
+
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
-			inode->i_ino == F2FS_META_INO(sbi))
+			inode->i_ino == F2FS_META_INO(sbi) ||
+			inode->i_ino == F2FS_COMPRESS_INO(sbi))
 		goto out_clear;
 
 	f2fs_bug_on(sbi, get_dirty_pages(inode));
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 3a8f7afa5059..dd611efa8aa4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -97,6 +97,20 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		mem_size = (atomic_read(&dcc->discard_cmd_cnt) *
 				sizeof(struct discard_cmd)) >> PAGE_SHIFT;
 		res = mem_size < (avail_ram * nm_i->ram_thresh / 100);
+	} else if (type == COMPRESS_PAGE) {
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		unsigned long free_ram = val.freeram;
+
+		/*
+		 * free memory is lower than watermark or cached page count
+		 * exceed threshold, deny caching compress page.
+		 */
+		res = (free_ram > avail_ram * sbi->compress_watermark / 100) &&
+			(COMPRESS_MAPPING(sbi)->nrpages <
+			 free_ram * sbi->compress_percent / 100);
+#else
+		res = false;
+#endif
 	} else {
 		if (!sbi->sb->s_bdi->wb.dirty_exceeded)
 			return true;
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index d85e8659cfda..84d45385d1f2 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -148,6 +148,7 @@ enum mem_type {
 	EXTENT_CACHE,	/* indicates extent cache */
 	INMEM_PAGES,	/* indicates inmemory pages */
 	DISCARD_CACHE,	/* indicates memory of cached discard cmds */
+	COMPRESS_PAGE,	/* indicates memory of cached compressed pages */
 	BASE_CHECK,	/* check kernel status */
 };
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 8668df7870d0..406a6b244782 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -2322,6 +2322,7 @@ void f2fs_invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 		return;
 
 	invalidate_mapping_pages(META_MAPPING(sbi), addr, addr);
+	f2fs_invalidate_compress_page(sbi, addr);
 
 	/* add it into sit main buffer */
 	down_write(&sit_i->sentry_lock);
@@ -3469,9 +3470,11 @@ static void do_write_page(struct f2fs_summary *sum, struct f2fs_io_info *fio)
 reallocate:
 	f2fs_allocate_data_block(fio->sbi, fio->page, fio->old_blkaddr,
 			&fio->new_blkaddr, sum, type, fio);
-	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO)
+	if (GET_SEGNO(fio->sbi, fio->old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(fio->sbi),
 					fio->old_blkaddr, fio->old_blkaddr);
+		f2fs_invalidate_compress_page(fio->sbi, fio->old_blkaddr);
+	}
 
 	/* writeout dirty page into bdev */
 	f2fs_submit_page_write(fio);
@@ -3661,6 +3664,7 @@ void f2fs_do_replace_block(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (GET_SEGNO(sbi, old_blkaddr) != NULL_SEGNO) {
 		invalidate_mapping_pages(META_MAPPING(sbi),
 					old_blkaddr, old_blkaddr);
+		f2fs_invalidate_compress_page(sbi, old_blkaddr);
 		if (!from_gc)
 			update_segment_mtime(sbi, old_blkaddr, 0);
 		update_sit_entry(sbi, old_blkaddr, -1);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8b2b34500b2a..97e3efe5a020 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -150,6 +150,7 @@ enum {
 	Opt_compress_extension,
 	Opt_compress_chksum,
 	Opt_compress_mode,
+	Opt_compress_cache,
 	Opt_atgc,
 	Opt_gc_merge,
 	Opt_nogc_merge,
@@ -224,6 +225,7 @@ static match_table_t f2fs_tokens = {
 	{Opt_compress_extension, "compress_extension=%s"},
 	{Opt_compress_chksum, "compress_chksum"},
 	{Opt_compress_mode, "compress_mode=%s"},
+	{Opt_compress_cache, "compress_cache"},
 	{Opt_atgc, "atgc"},
 	{Opt_gc_merge, "gc_merge"},
 	{Opt_nogc_merge, "nogc_merge"},
@@ -1066,12 +1068,16 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 			}
 			kfree(name);
 			break;
+		case Opt_compress_cache:
+			set_opt(sbi, COMPRESS_CACHE);
+			break;
 #else
 		case Opt_compress_algorithm:
 		case Opt_compress_log_size:
 		case Opt_compress_extension:
 		case Opt_compress_chksum:
 		case Opt_compress_mode:
+		case Opt_compress_cache:
 			f2fs_info(sbi, "compression options not supported");
 			break;
 #endif
@@ -1403,6 +1409,8 @@ static void f2fs_put_super(struct super_block *sb)
 
 	f2fs_bug_on(sbi, sbi->fsync_node_num);
 
+	f2fs_destroy_compress_inode(sbi);
+
 	iput(sbi->node_inode);
 	sbi->node_inode = NULL;
 
@@ -1672,6 +1680,9 @@ static inline void f2fs_show_compress_options(struct seq_file *seq,
 		seq_printf(seq, ",compress_mode=%s", "fs");
 	else if (F2FS_OPTION(sbi).compress_mode == COMPR_MODE_USER)
 		seq_printf(seq, ",compress_mode=%s", "user");
+
+	if (test_opt(sbi, COMPRESS_CACHE))
+		seq_puts(seq, ",compress_cache");
 }
 #endif
 
@@ -1958,6 +1969,7 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 	bool disable_checkpoint = test_opt(sbi, DISABLE_CHECKPOINT);
 	bool no_io_align = !F2FS_IO_ALIGNED(sbi);
 	bool no_atgc = !test_opt(sbi, ATGC);
+	bool no_compress_cache = !test_opt(sbi, COMPRESS_CACHE);
 	bool checkpoint_changed;
 #ifdef CONFIG_QUOTA
 	int i, j;
@@ -2050,6 +2062,12 @@ static int f2fs_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	if (no_compress_cache == !!test_opt(sbi, COMPRESS_CACHE)) {
+		err = -EINVAL;
+		f2fs_warn(sbi, "switch compress_cache option is not allowed");
+		goto restore_opts;
+	}
+
 	if ((*flags & SB_RDONLY) && test_opt(sbi, DISABLE_CHECKPOINT)) {
 		err = -EINVAL;
 		f2fs_warn(sbi, "disabling checkpoint not compatible with read-only");
@@ -3975,10 +3993,14 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		goto free_node_inode;
 	}
 
-	err = f2fs_register_sysfs(sbi);
+	err = f2fs_init_compress_inode(sbi);
 	if (err)
 		goto free_root_inode;
 
+	err = f2fs_register_sysfs(sbi);
+	if (err)
+		goto free_compress_inode;
+
 #ifdef CONFIG_QUOTA
 	/* Enable quota usage during mount */
 	if (f2fs_sb_has_quota_ino(sbi) && !f2fs_readonly(sb)) {
@@ -4119,6 +4141,8 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	/* evict some inodes being cached by GC */
 	evict_inodes(sb);
 	f2fs_unregister_sysfs(sbi);
+free_compress_inode:
+	f2fs_destroy_compress_inode(sbi);
 free_root_inode:
 	dput(sb->s_root);
 	sb->s_root = NULL;
@@ -4197,6 +4221,15 @@ static void kill_f2fs_super(struct super_block *sb)
 		f2fs_stop_gc_thread(sbi);
 		f2fs_stop_discard_thread(sbi);
 
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		/*
+		 * latter evict_inode() can bypass checking and invalidating
+		 * compress inode cache.
+		 */
+		if (test_opt(sbi, COMPRESS_CACHE))
+			truncate_inode_pages_final(COMPRESS_MAPPING(sbi));
+#endif
+
 		if (is_sbi_flag_set(sbi, SBI_IS_DIRTY) ||
 				!is_set_ckpt_flags(sbi, CP_UMOUNT_FLAG)) {
 			struct cp_control cpc = {
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 5487a80617a3..0021ea8f7c3b 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -34,6 +34,7 @@
 #define F2FS_ROOT_INO(sbi)	((sbi)->root_ino_num)
 #define F2FS_NODE_INO(sbi)	((sbi)->node_ino_num)
 #define F2FS_META_INO(sbi)	((sbi)->meta_ino_num)
+#define F2FS_COMPRESS_INO(sbi)	(NM_I(sbi)->max_nid)
 
 #define F2FS_MAX_QUOTAS		3
 
-- 
2.30.2



