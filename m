Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DED10B856
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfK0Um0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbfK0UmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:42:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84B8C215A5;
        Wed, 27 Nov 2019 20:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887341;
        bh=90YLpakxFViMzzFiDiAr7OzCWNPW73BTmNi7XC0WLRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gd8a/JTSlXN4gXDT540UYmzzDAv0oymNkyZ8EDZKhBeDs5OVsmpo9cQIMAIJtYf94
         t/O6xoiPu+LbLR36DbFVYtYo+1+UTuxBNqwUpiv1iI77pIVJA70JTJKaNrmILkHtVB
         oVyXnZ8HXBL4D0gRTY6BkFFtjaIgX2PpALeZgJbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "=?UTF-8?q?Ernesto=20A . =20Fern=C3=A1ndez?=" 
        <ernesto.mnd.fernandez@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 074/151] hfs: prevent btree data loss on ENOSPC
Date:   Wed, 27 Nov 2019 21:30:57 +0100
Message-Id: <20191127203035.052871313@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>

[ Upstream commit 54640c7502e5ed41fbf4eedd499e85f9acc9698f ]

Inserting a new record in a btree may require splitting several of its
nodes.  If we hit ENOSPC halfway through, the new nodes will be left
orphaned and their records will be lost.  This could mean lost inodes or
extents.

Henceforth, check the available disk space before making any changes.
This still leaves the potential problem of corruption on ENOMEM.

There is no need to reserve space before deleting a catalog record, as we
do for hfsplus.  This difference is because hfs index nodes have fixed
length keys.

Link: http://lkml.kernel.org/r/ab5fc8a7d5ffccfd5f27b1cf2cb4ceb6c110da74.1536269131.git.ernesto.mnd.fernandez@gmail.com
Signed-off-by: Ernesto A. Fernández <ernesto.mnd.fernandez@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfs/btree.c   | 41 +++++++++++++++++++++++++----------------
 fs/hfs/btree.h   |  1 +
 fs/hfs/catalog.c | 16 ++++++++++++++++
 fs/hfs/extent.c  |  4 ++++
 4 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/hfs/btree.c b/fs/hfs/btree.c
index 320f4372f1720..77eff447d3014 100644
--- a/fs/hfs/btree.c
+++ b/fs/hfs/btree.c
@@ -219,25 +219,17 @@ static struct hfs_bnode *hfs_bmap_new_bmap(struct hfs_bnode *prev, u32 idx)
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
-
-	while (!tree->free_nodes) {
-		struct inode *inode = tree->inode;
-		u32 count;
-		int res;
+	struct inode *inode = tree->inode;
+	u32 count;
+	int res;
 
+	while (tree->free_nodes < rsvd_nodes) {
 		res = hfs_extend_file(inode);
 		if (res)
-			return ERR_PTR(res);
+			return res;
 		HFS_I(inode)->phys_size = inode->i_size =
 				(loff_t)HFS_I(inode)->alloc_blocks *
 				HFS_SB(tree->sb)->alloc_blksz;
@@ -245,9 +237,26 @@ struct hfs_bnode *hfs_bmap_alloc(struct hfs_btree *tree)
 					  tree->sb->s_blocksize_bits;
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
diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index f6bd266d70b55..2715f416b5a80 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -81,6 +81,7 @@ struct hfs_find_data {
 extern struct hfs_btree *hfs_btree_open(struct super_block *, u32, btree_keycmp);
 extern void hfs_btree_close(struct hfs_btree *);
 extern void hfs_btree_write(struct hfs_btree *);
+extern int hfs_bmap_reserve(struct hfs_btree *, int);
 extern struct hfs_bnode * hfs_bmap_alloc(struct hfs_btree *);
 extern void hfs_bmap_free(struct hfs_bnode *node);
 
diff --git a/fs/hfs/catalog.c b/fs/hfs/catalog.c
index 8a66405b0f8b5..d365bf0b8c77d 100644
--- a/fs/hfs/catalog.c
+++ b/fs/hfs/catalog.c
@@ -97,6 +97,14 @@ int hfs_cat_create(u32 cnid, struct inode *dir, const struct qstr *str, struct i
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
 	hfs_cat_build_key(sb, fd.search_key, cnid, NULL);
 	entry_size = hfs_cat_build_thread(sb, &entry, S_ISDIR(inode->i_mode) ?
 			HFS_CDR_THD : HFS_CDR_FTH,
@@ -295,6 +303,14 @@ int hfs_cat_move(u32 cnid, struct inode *src_dir, const struct qstr *src_name,
 		return err;
 	dst_fd = src_fd;
 
+	/*
+	 * Fail early and avoid ENOSPC during the btree operations. We may
+	 * have to split the root node at most once.
+	 */
+	err = hfs_bmap_reserve(src_fd.tree, 2 * src_fd.tree->depth);
+	if (err)
+		goto out;
+
 	/* find the old dir entry and read the data */
 	hfs_cat_build_key(sb, src_fd.search_key, src_dir->i_ino, src_name);
 	err = hfs_brec_find(&src_fd);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index e33a0d36a93eb..1bd1afefe2538 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -117,6 +117,10 @@ static int __hfs_ext_write_extent(struct inode *inode, struct hfs_find_data *fd)
 	if (HFS_I(inode)->flags & HFS_FLG_EXT_NEW) {
 		if (res != -ENOENT)
 			return res;
+		/* Fail early and avoid ENOSPC during the btree operation */
+		res = hfs_bmap_reserve(fd->tree, fd->tree->depth + 1);
+		if (res)
+			return res;
 		hfs_brec_insert(fd, HFS_I(inode)->cached_extents, sizeof(hfs_extent_rec));
 		HFS_I(inode)->flags &= ~(HFS_FLG_EXT_DIRTY|HFS_FLG_EXT_NEW);
 	} else {
-- 
2.20.1



