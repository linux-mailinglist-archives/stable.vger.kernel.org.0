Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA115C561
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgBMPzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:55:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387491AbgBMPZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 912BA246A3;
        Thu, 13 Feb 2020 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607541;
        bh=vV1e1rIiNiX5yUqgdU3O4/J5u9z/Yr0qfysbnjbnbaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LapgQqeS8umvS9Cy3r8YNyXefSwrrjyw73xXlKZZnRCUODT5stFXD+qsDAm2J28OV
         lyj1zliqn7QhGC+nKGnZVZpgZREuFT/0hUQh53eKFyUd8cY/9m6PAIKco1ytMxvxvo
         3bmh8PQxh85sn14B/xkc3lZiFzLuA6/bDh98OnDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 119/173] btrfs: Get rid of the confusing btrfs_file_extent_inline_len
Date:   Thu, 13 Feb 2020 07:20:22 -0800
Message-Id: <20200213152002.412302332@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit e41ca5897489b1c18af75ff0cc8f5c80260b3281 ]

We used to call btrfs_file_extent_inline_len() to get the uncompressed
data size of an inlined extent.

However this function is hiding evil, for compressed extent, it has no
choice but to directly read out ram_bytes from btrfs_file_extent_item.
While for uncompressed extent, it uses item size to calculate the real
data size, and ignoring ram_bytes completely.

In fact, for corrupted ram_bytes, due to above behavior kernel
btrfs_print_leaf() can't even print correct ram_bytes to expose the bug.

Since we have the tree-checker to verify all EXTENT_DATA, such mismatch
can be detected pretty easily, thus we can trust ram_bytes without the
evil btrfs_file_extent_inline_len().

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.h             | 26 --------------------------
 fs/btrfs/file-item.c         |  2 +-
 fs/btrfs/file.c              |  3 +--
 fs/btrfs/inode.c             | 12 ++++++------
 fs/btrfs/print-tree.c        |  4 ++--
 fs/btrfs/send.c              | 17 +++++++----------
 fs/btrfs/tree-log.c          | 12 ++++--------
 include/trace/events/btrfs.h |  2 +-
 8 files changed, 22 insertions(+), 56 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 588760c49fe28..664710848e6f1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2408,32 +2408,6 @@ static inline u32 btrfs_file_extent_inline_item_len(
 	return btrfs_item_size(eb, e) - BTRFS_FILE_EXTENT_INLINE_DATA_START;
 }
 
-/* this returns the number of file bytes represented by the inline item.
- * If an item is compressed, this is the uncompressed size
- */
-static inline u32 btrfs_file_extent_inline_len(const struct extent_buffer *eb,
-					int slot,
-					const struct btrfs_file_extent_item *fi)
-{
-	struct btrfs_map_token token;
-
-	btrfs_init_map_token(&token);
-	/*
-	 * return the space used on disk if this item isn't
-	 * compressed or encoded
-	 */
-	if (btrfs_token_file_extent_compression(eb, fi, &token) == 0 &&
-	    btrfs_token_file_extent_encryption(eb, fi, &token) == 0 &&
-	    btrfs_token_file_extent_other_encoding(eb, fi, &token) == 0) {
-		return btrfs_file_extent_inline_item_len(eb,
-							 btrfs_item_nr(slot));
-	}
-
-	/* otherwise use the ram bytes field */
-	return btrfs_token_file_extent_ram_bytes(eb, fi, &token);
-}
-
-
 /* btrfs_dev_stats_item */
 static inline u64 btrfs_dev_stats_value(const struct extent_buffer *eb,
 					const struct btrfs_dev_stats_item *ptr,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index fdcb410026233..702b3606ad0ec 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -955,7 +955,7 @@ void btrfs_extent_item_to_extent_map(struct btrfs_inode *inode,
 			btrfs_file_extent_num_bytes(leaf, fi);
 	} else if (type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
-		size = btrfs_file_extent_inline_len(leaf, slot, fi);
+		size = btrfs_file_extent_ram_bytes(leaf, fi);
 		extent_end = ALIGN(extent_start + size,
 				   fs_info->sectorsize);
 	}
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c68ce3412dc11..725544ec9c842 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -784,8 +784,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_file_extent_num_bytes(leaf, fi);
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = key.offset +
-				btrfs_file_extent_inline_len(leaf,
-						     path->slots[0], fi);
+				btrfs_file_extent_ram_bytes(leaf, fi);
 		} else {
 			/* can't happen */
 			BUG();
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f2dc517768f02..abecc4724a3bc 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1476,8 +1476,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			nocow = 1;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
-				btrfs_file_extent_inline_len(leaf,
-						     path->slots[0], fi);
+				btrfs_file_extent_ram_bytes(leaf, fi);
 			extent_end = ALIGN(extent_end,
 					   fs_info->sectorsize);
 		} else {
@@ -4651,8 +4650,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					BTRFS_I(inode), leaf, fi,
 					found_key.offset);
 			} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-				item_end += btrfs_file_extent_inline_len(leaf,
-							 path->slots[0], fi);
+				item_end += btrfs_file_extent_ram_bytes(leaf,
+									fi);
 
 				trace_btrfs_truncate_show_fi_inline(
 					BTRFS_I(inode), leaf, fi, path->slots[0],
@@ -7167,7 +7166,8 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 						       extent_start);
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size_t size;
-		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
+
+		size = btrfs_file_extent_ram_bytes(leaf, item);
 		extent_end = ALIGN(extent_start + size,
 				   fs_info->sectorsize);
 
@@ -7218,7 +7218,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		if (new_inline)
 			goto out;
 
-		size = btrfs_file_extent_inline_len(leaf, path->slots[0], item);
+		size = btrfs_file_extent_ram_bytes(leaf, item);
 		extent_offset = page_offset(page) + pg_offset - extent_start;
 		copy_size = min_t(u64, PAGE_SIZE - pg_offset,
 				  size - extent_offset);
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 569205e651c7d..47336d4b19d84 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -259,8 +259,8 @@ void btrfs_print_leaf(struct extent_buffer *l)
 					    struct btrfs_file_extent_item);
 			if (btrfs_file_extent_type(l, fi) ==
 			    BTRFS_FILE_EXTENT_INLINE) {
-				pr_info("\t\tinline extent data size %u\n",
-				       btrfs_file_extent_inline_len(l, i, fi));
+				pr_info("\t\tinline extent data size %llu\n",
+				       btrfs_file_extent_ram_bytes(l, fi));
 				break;
 			}
 			pr_info("\t\textent data disk bytenr %llu nr %llu\n",
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 1211fdcd425dc..ca15d65a2070c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1545,7 +1545,7 @@ static int read_symlink(struct btrfs_root *root,
 	BUG_ON(compression);
 
 	off = btrfs_file_extent_inline_start(ei);
-	len = btrfs_file_extent_inline_len(path->nodes[0], path->slots[0], ei);
+	len = btrfs_file_extent_ram_bytes(path->nodes[0], ei);
 
 	ret = fs_path_add_from_extent_buffer(dest, path->nodes[0], off, len);
 
@@ -5195,7 +5195,7 @@ static int clone_range(struct send_ctx *sctx,
 		ei = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 		type = btrfs_file_extent_type(leaf, ei);
 		if (type == BTRFS_FILE_EXTENT_INLINE) {
-			ext_len = btrfs_file_extent_inline_len(leaf, slot, ei);
+			ext_len = btrfs_file_extent_ram_bytes(leaf, ei);
 			ext_len = PAGE_ALIGN(ext_len);
 		} else {
 			ext_len = btrfs_file_extent_num_bytes(leaf, ei);
@@ -5271,8 +5271,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 			struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], ei);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		len = btrfs_file_extent_inline_len(path->nodes[0],
-						   path->slots[0], ei);
+		len = btrfs_file_extent_ram_bytes(path->nodes[0], ei);
 		/*
 		 * it is possible the inline item won't cover the whole page,
 		 * but there may be items after this page.  Make
@@ -5405,7 +5404,7 @@ static int is_extent_unchanged(struct send_ctx *sctx,
 		}
 
 		if (right_type == BTRFS_FILE_EXTENT_INLINE) {
-			right_len = btrfs_file_extent_inline_len(eb, slot, ei);
+			right_len = btrfs_file_extent_ram_bytes(eb, ei);
 			right_len = PAGE_ALIGN(right_len);
 		} else {
 			right_len = btrfs_file_extent_num_bytes(eb, ei);
@@ -5526,8 +5525,7 @@ static int get_last_extent(struct send_ctx *sctx, u64 offset)
 			    struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], fi);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
-							path->slots[0], fi);
+		u64 size = btrfs_file_extent_ram_bytes(path->nodes[0], fi);
 		extent_end = ALIGN(key.offset + size,
 				   sctx->send_root->fs_info->sectorsize);
 	} else {
@@ -5590,7 +5588,7 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
 		fi = btrfs_item_ptr(leaf, slot, struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(leaf, fi) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			u64 size = btrfs_file_extent_inline_len(leaf, slot, fi);
+			u64 size = btrfs_file_extent_ram_bytes(leaf, fi);
 
 			extent_end = ALIGN(key.offset + size,
 					   root->fs_info->sectorsize);
@@ -5636,8 +5634,7 @@ static int maybe_send_hole(struct send_ctx *sctx, struct btrfs_path *path,
 			    struct btrfs_file_extent_item);
 	type = btrfs_file_extent_type(path->nodes[0], fi);
 	if (type == BTRFS_FILE_EXTENT_INLINE) {
-		u64 size = btrfs_file_extent_inline_len(path->nodes[0],
-							path->slots[0], fi);
+		u64 size = btrfs_file_extent_ram_bytes(path->nodes[0], fi);
 		extent_end = ALIGN(key->offset + size,
 				   sctx->send_root->fs_info->sectorsize);
 	} else {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 98c397eb054c5..65a986054f89e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -619,7 +619,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
 			nbytes = 0;
 	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
-		size = btrfs_file_extent_inline_len(eb, slot, item);
+		size = btrfs_file_extent_ram_bytes(eb, item);
 		nbytes = btrfs_file_extent_ram_bytes(eb, item);
 		extent_end = ALIGN(start + size,
 				   fs_info->sectorsize);
@@ -3943,9 +3943,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 					struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(src, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(src,
-							   src_path->slots[0],
-							   extent);
+			len = btrfs_file_extent_ram_bytes(src, extent);
 			*last_extent = ALIGN(key.offset + len,
 					     fs_info->sectorsize);
 		} else {
@@ -4010,7 +4008,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		extent = btrfs_item_ptr(src, i, struct btrfs_file_extent_item);
 		if (btrfs_file_extent_type(src, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(src, i, extent);
+			len = btrfs_file_extent_ram_bytes(src, extent);
 			extent_end = ALIGN(key.offset + len,
 					   fs_info->sectorsize);
 		} else {
@@ -4730,9 +4728,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 
 		if (btrfs_file_extent_type(leaf, extent) ==
 		    BTRFS_FILE_EXTENT_INLINE) {
-			len = btrfs_file_extent_inline_len(leaf,
-							   path->slots[0],
-							   extent);
+			len = btrfs_file_extent_ram_bytes(leaf, extent);
 			ASSERT(len == i_size ||
 			       (len == fs_info->sectorsize &&
 				btrfs_file_extent_compression(leaf, extent) !=
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 32d0c1fe2bfa7..3ebada29a313e 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -325,7 +325,7 @@ DECLARE_EVENT_CLASS(
 		__entry->extent_type	= btrfs_file_extent_type(l, fi);
 		__entry->compression	= btrfs_file_extent_compression(l, fi);
 		__entry->extent_start	= start;
-		__entry->extent_end	= (start + btrfs_file_extent_inline_len(l, slot, fi));
+		__entry->extent_end	= (start + btrfs_file_extent_ram_bytes(l, fi));
 	),
 
 	TP_printk_btrfs(
-- 
2.20.1



