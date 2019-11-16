Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075D0FEE97
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 16:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729631AbfKPPwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:52:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728355AbfKPPwi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:52:38 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37AD20728;
        Sat, 16 Nov 2019 15:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919557;
        bh=wLe3I/sVGgkxrO8cdF795wPt8HhFzJski5bLN6Ly4js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QtnQ16khSqEK/Pfej4Gnv1gThQ/OVLb/7+pPUXDphZPxaOIJdkAn4moq2ChY5Nc09
         cwx1bYQ7eJN+jGbE3kyX8S4YXTNdFy2Q27djE0WQ6bkke2v6odF9t4bab1dMeeRfhs
         soIYZc+Okr+GnG3yr1jzS/SHY0x+UxGdEgB+JxpM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Ernesto=20A=2E=20Fern=C3=A1ndez?= 
        <ernesto.mnd.fernandez@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 61/99] hfsplus: prevent btree data loss on ENOSPC
Date:   Sat, 16 Nov 2019 10:50:24 -0500
Message-Id: <20191116155103.10971-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit d92915c35bfaf763d78bf1d5ac7f183420e3bd99 ]

Inserting or deleting a record in a btree may require splitting several of
its nodes.  If we hit ENOSPC halfway through, the new nodes will be left
orphaned and their records will be lost.  This could mean lost inodes,
extents or xattrs.

Henceforth, check the available disk space before making any changes.
This still leaves the potential problem of corruption on ENOMEM.

The patch can be tested with xfstests generic/027.

Link: http://lkml.kernel.org/r/4596eef22fbda137b4ffa0272d92f0da15364421.1536269129.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/attributes.c | 10 ++++++++++
 fs/hfsplus/btree.c      | 44 ++++++++++++++++++++++++++---------------
 fs/hfsplus/catalog.c    | 24 ++++++++++++++++++++++
 fs/hfsplus/extents.c    |  4 ++++
 fs/hfsplus/hfsplus_fs.h |  2 ++
 5 files changed, 68 insertions(+), 16 deletions(-)

diff --git a/fs/hfsplus/attributes.c b/fs/hfsplus/attributes.c
index e5b221de7de63..d7455ea702878 100644
--- a/fs/hfsplus/attributes.c
+++ b/fs/hfsplus/attributes.c
@@ -216,6 +216,11 @@ int hfsplus_create_attr(struct inode *inode,
 	if (err)
 		goto failed_init_create_attr;
 
+	/* Fail early and avoid ENOSPC during the btree operation */
+	err = hfs_bmap_reserve(fd.tree, fd.tree->depth + 1);
+	if (err)
+		goto failed_create_attr;
+
 	if (name) {
 		err = hfsplus_attr_build_key(sb, fd.search_key,
 						inode->i_ino, name);
@@ -312,6 +317,11 @@ int hfsplus_delete_attr(struct inode *inode, const char *name)
 	if (err)
 		return err;
 
+	/* Fail early and avoid ENOSPC during the btree operation */
+	err = hfs_bmap_reserve(fd.tree, fd.tree->depth);
+	if (err)
+		goto out;
+
 	if (name) {
 		err = hfsplus_attr_build_key(sb, fd.search_key,
 						inode->i_ino, name);
diff --git a/fs/hfsplus/btree.c b/fs/hfsplus/btree.c
index 8d2256454efe6..7e96b4c294f7a 100644
--- a/fs/hfsplus/btree.c
+++ b/fs/hfsplus/btree.c
@@ -341,26 +341,21 @@ static struct hfs_bnode *hfs_bmap_new_bmap(struct hfs_bnode *prev, u32 idx)
 	return node;
 }
 
-struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
+/* Make sure @tree has enough space for the @rsvd_nodes */
+int hfs_bmap_reserve(struct hfs_btree *tree, int rsvd_nodes)
 {
-	struct hfs_bnode *node, *next_node;
-	struct page **pagep;
-	u32 nidx, idx;
-	unsigned off;
-	u16 off16;
-	u16 len;
-	u8 *data, byte, m;
-	int i;
+	struct inode *inode = tree->inode;
+	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	u32 count;
+	int res;
 
-	while (!tree->free_nodes) {
-		struct inode *inode = tree->inode;
-		struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
-		u32 count;
-		int res;
+	if (rsvd_nodes <= 0)
+		return 0;
 
+	while (tree->free_nodes < rsvd_nodes) {
 		res = hfsplus_file_extend(inode, hfs_bnode_need_zeroout(tree));
 		if (res)
-			return ERR_PTR(res);
+			return res;
 		hip->phys_size = inode->i_size =
 			(loff_t)hip->alloc_blocks <<
 				HFSPLUS_SB(tree->sb)->alloc_blksz_shift;
@@ -368,9 +363,26 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 			hip->alloc_blocks << HFSPLUS_SB(tree->sb)->fs_shift;
 		inode_set_bytes(inode, inode->i_size);
 		count = inode->i_size >> tree->node_size_shift;
-		tree->free_nodes = count - tree->node_count;
+		tree->free_nodes += count - tree->node_count;
 		tree->node_count = count;
 	}
+	return 0;
+}
+
+struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
+{
+	struct hfs_bnode *node, *next_node;
+	struct page **pagep;
+	u32 nidx, idx;
+	unsigned off;
+	u16 off16;
+	u16 len;
+	u8 *data, byte, m;
+	int i, res;
+
+	res = hfs_bmap_reserve(tree, 1);
+	if (res)
+		return ERR_PTR(res);
 
 	nidx = 0;
 	node = hfs_bnode_find(tree, nidx);
diff --git a/fs/hfsplus/catalog.c b/fs/hfsplus/catalog.c
index a5e00f7a4c143..947da72e72a30 100644
--- a/fs/hfsplus/catalog.c
+++ b/fs/hfsplus/catalog.c
@@ -264,6 +264,14 @@ int hfsplus_create_cat(u32 cnid, struct inode *dir,
 	if (err)
 		return err;
 
+	/*
+	 * Fail early and avoid ENOSPC during the btree operations. We may
+	 * have to split the root node at most once.
+	 */
+	err = hfs_bmap_reserve(fd.tree, 2 * fd.tree->depth);
+	if (err)
+		goto err2;
+
 	hfsplus_cat_build_key_with_cnid(sb, fd.search_key, cnid);
 	entry_size = hfsplus_fill_cat_thread(sb, &entry,
 		S_ISDIR(inode->i_mode) ?
@@ -332,6 +340,14 @@ int hfsplus_delete_cat(u32 cnid, struct inode *dir, const struct qstr *str)
 	if (err)
 		return err;
 
+	/*
+	 * Fail early and avoid ENOSPC during the btree operations. We may
+	 * have to split the root node at most once.
+	 */
+	err = hfs_bmap_reserve(fd.tree, 2 * (int)fd.tree->depth - 2);
+	if (err)
+		goto out;
+
 	if (!str) {
 		int len;
 
@@ -432,6 +448,14 @@ int hfsplus_rename_cat(u32 cnid,
 		return err;
 	dst_fd = src_fd;
 
+	/*
+	 * Fail early and avoid ENOSPC during the btree operations. We may
+	 * have to split the root node at most twice.
+	 */
+	err = hfs_bmap_reserve(src_fd.tree, 4 * (int)src_fd.tree->depth - 1);
+	if (err)
+		goto out;
+
 	/* find the old dir entry and read the data */
 	err = hfsplus_cat_build_key(sb, src_fd.search_key,
 			src_dir->i_ino, src_name);
diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index feca524ce2a5c..ce0b8f8374081 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -99,6 +99,10 @@ static int __hfsplus_ext_write_extent(struct inode *inode,
 	if (hip->extent_state & HFSPLUS_EXT_NEW) {
 		if (res != -ENOENT)
 			return res;
+		/* Fail early and avoid ENOSPC during the btree operation */
+		res = hfs_bmap_reserve(fd->tree, fd->tree->depth + 1);
+		if (res)
+			return res;
 		hfs_brec_insert(fd, hip->cached_extents,
 				sizeof(hfsplus_extent_rec));
 		hip->extent_state &= ~(HFSPLUS_EXT_DIRTY | HFSPLUS_EXT_NEW);
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index a3f03b2474637..35cd703c66045 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -311,6 +311,7 @@ static inline unsigned short hfsplus_min_io_size(struct super_block *sb)
 #define hfs_btree_open hfsplus_btree_open
 #define hfs_btree_close hfsplus_btree_close
 #define hfs_btree_write hfsplus_btree_write
+#define hfs_bmap_reserve hfsplus_bmap_reserve
 #define hfs_bmap_alloc hfsplus_bmap_alloc
 #define hfs_bmap_free hfsplus_bmap_free
 #define hfs_bnode_read hfsplus_bnode_read
@@ -395,6 +396,7 @@ u32 hfsplus_calc_btree_clump_size(u32 block_size, u32 node_size, u64 sectors,
 struct hfs_btree *hfs_btree_open(struct super_block *sb, u32 id);
 void hfs_btree_close(struct hfs_btree *tree);
 int hfs_btree_write(struct hfs_btree *tree);
+int hfs_bmap_reserve(struct hfs_btree *tree, int rsvd_nodes);
 struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree);
 void hfs_bmap_free(struct hfs_bnode *node);
 
-- 
2.20.1

