Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96FE47B067
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhLTPhR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:37:17 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37471 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231516AbhLTPhQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:37:16 -0500
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 1BKFb5sj004488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 10:37:05 -0500
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 4DEC315C33B1; Mon, 20 Dec 2021 10:37:05 -0500 (EST)
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     stable@vger.kernel.org
Cc:     Zhang Yi <yi.zhang@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5.10 3/3] ext4: check for inconsistent extents between index and leaf block
Date:   Mon, 20 Dec 2021 10:36:59 -0500
Message-Id: <20211220153659.2120506-4-tytso@mit.edu>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211220153659.2120506-1-tytso@mit.edu>
References: <20211220153659.2120506-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

Now that we can check out overlapping extents in leaf block and
out-of-order index extents in index block. But the .ee_block in the
first extent of one leaf block should equal to the .ei_block in it's
parent index extent entry. This patch add a check to verify such
inconsistent between the index and leaf block.

Commit 9c6e071913792d80894cd0be98cc3c4b770e26d3 upstream.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210908120850.4012324-3-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/extents.c | 59 +++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 35648dc3ff50..618675a41efb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -366,7 +366,8 @@ static int ext4_valid_extent_idx(struct inode *inode,
 
 static int ext4_valid_extent_entries(struct inode *inode,
 				     struct ext4_extent_header *eh,
-				     ext4_fsblk_t *pblk, int depth)
+				     ext4_lblk_t lblk, ext4_fsblk_t *pblk,
+				     int depth)
 {
 	unsigned short entries;
 	ext4_lblk_t lblock = 0;
@@ -380,6 +381,14 @@ static int ext4_valid_extent_entries(struct inode *inode,
 	if (depth == 0) {
 		/* leaf entries */
 		struct ext4_extent *ext = EXT_FIRST_EXTENT(eh);
+
+		/*
+		 * The logical block in the first entry should equal to
+		 * the number in the index block.
+		 */
+		if (depth != ext_depth(inode) &&
+		    lblk != le32_to_cpu(ext->ee_block))
+			return 0;
 		while (entries) {
 			if (!ext4_valid_extent(inode, ext))
 				return 0;
@@ -396,6 +405,14 @@ static int ext4_valid_extent_entries(struct inode *inode,
 		}
 	} else {
 		struct ext4_extent_idx *ext_idx = EXT_FIRST_INDEX(eh);
+
+		/*
+		 * The logical block in the first entry should equal to
+		 * the number in the parent index block.
+		 */
+		if (depth != ext_depth(inode) &&
+		    lblk != le32_to_cpu(ext_idx->ei_block))
+			return 0;
 		while (entries) {
 			if (!ext4_valid_extent_idx(inode, ext_idx))
 				return 0;
@@ -416,7 +433,7 @@ static int ext4_valid_extent_entries(struct inode *inode,
 
 static int __ext4_ext_check(const char *function, unsigned int line,
 			    struct inode *inode, struct ext4_extent_header *eh,
-			    int depth, ext4_fsblk_t pblk)
+			    int depth, ext4_fsblk_t pblk, ext4_lblk_t lblk)
 {
 	const char *error_msg;
 	int max = 0, err = -EFSCORRUPTED;
@@ -442,7 +459,7 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
-	if (!ext4_valid_extent_entries(inode, eh, &pblk, depth)) {
+	if (!ext4_valid_extent_entries(inode, eh, lblk, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
@@ -472,7 +489,7 @@ static int __ext4_ext_check(const char *function, unsigned int line,
 }
 
 #define ext4_ext_check(inode, eh, depth, pblk)			\
-	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk))
+	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk), 0)
 
 int ext4_ext_check_inode(struct inode *inode)
 {
@@ -505,16 +522,18 @@ static void ext4_cache_extents(struct inode *inode,
 
 static struct buffer_head *
 __read_extent_tree_block(const char *function, unsigned int line,
-			 struct inode *inode, ext4_fsblk_t pblk, int depth,
-			 int flags)
+			 struct inode *inode, struct ext4_extent_idx *idx,
+			 int depth, int flags)
 {
 	struct buffer_head		*bh;
 	int				err;
 	gfp_t				gfp_flags = __GFP_MOVABLE | GFP_NOFS;
+	ext4_fsblk_t			pblk;
 
 	if (flags & EXT4_EX_NOFAIL)
 		gfp_flags |= __GFP_NOFAIL;
 
+	pblk = ext4_idx_pblock(idx);
 	bh = sb_getblk_gfp(inode->i_sb, pblk, gfp_flags);
 	if (unlikely(!bh))
 		return ERR_PTR(-ENOMEM);
@@ -527,8 +546,8 @@ __read_extent_tree_block(const char *function, unsigned int line,
 	}
 	if (buffer_verified(bh) && !(flags & EXT4_EX_FORCE_CACHE))
 		return bh;
-	err = __ext4_ext_check(function, line, inode,
-			       ext_block_hdr(bh), depth, pblk);
+	err = __ext4_ext_check(function, line, inode, ext_block_hdr(bh),
+			       depth, pblk, le32_to_cpu(idx->ei_block));
 	if (err)
 		goto errout;
 	set_buffer_verified(bh);
@@ -546,8 +565,8 @@ __read_extent_tree_block(const char *function, unsigned int line,
 
 }
 
-#define read_extent_tree_block(inode, pblk, depth, flags)		\
-	__read_extent_tree_block(__func__, __LINE__, (inode), (pblk),   \
+#define read_extent_tree_block(inode, idx, depth, flags)		\
+	__read_extent_tree_block(__func__, __LINE__, (inode), (idx),	\
 				 (depth), (flags))
 
 /*
@@ -597,8 +616,7 @@ int ext4_ext_precache(struct inode *inode)
 			i--;
 			continue;
 		}
-		bh = read_extent_tree_block(inode,
-					    ext4_idx_pblock(path[i].p_idx++),
+		bh = read_extent_tree_block(inode, path[i].p_idx++,
 					    depth - i - 1,
 					    EXT4_EX_FORCE_CACHE);
 		if (IS_ERR(bh)) {
@@ -903,8 +921,7 @@ ext4_find_extent(struct inode *inode, ext4_lblk_t block,
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
-		bh = read_extent_tree_block(inode, path[ppos].p_block, --i,
-					    flags);
+		bh = read_extent_tree_block(inode, path[ppos].p_idx, --i, flags);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
 			goto err;
@@ -1509,7 +1526,6 @@ static int ext4_ext_search_right(struct inode *inode,
 	struct ext4_extent_header *eh;
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
-	ext4_fsblk_t block;
 	int depth;	/* Note, NOT eh_depth; depth from top of tree */
 	int ee_len;
 
@@ -1576,20 +1592,17 @@ static int ext4_ext_search_right(struct inode *inode,
 	 * follow it and find the closest allocated
 	 * block to the right */
 	ix++;
-	block = ext4_idx_pblock(ix);
 	while (++depth < path->p_depth) {
 		/* subtract from p_depth to get proper eh_depth */
-		bh = read_extent_tree_block(inode, block,
-					    path->p_depth - depth, 0);
+		bh = read_extent_tree_block(inode, ix, path->p_depth - depth, 0);
 		if (IS_ERR(bh))
 			return PTR_ERR(bh);
 		eh = ext_block_hdr(bh);
 		ix = EXT_FIRST_INDEX(eh);
-		block = ext4_idx_pblock(ix);
 		put_bh(bh);
 	}
 
-	bh = read_extent_tree_block(inode, block, path->p_depth - depth, 0);
+	bh = read_extent_tree_block(inode, ix, path->p_depth - depth, 0);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
 	eh = ext_block_hdr(bh);
@@ -2968,9 +2981,9 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			ext_debug(inode, "move to level %d (block %llu)\n",
 				  i + 1, ext4_idx_pblock(path[i].p_idx));
 			memset(path + i + 1, 0, sizeof(*path));
-			bh = read_extent_tree_block(inode,
-				ext4_idx_pblock(path[i].p_idx), depth - i - 1,
-				EXT4_EX_NOCACHE);
+			bh = read_extent_tree_block(inode, path[i].p_idx,
+						    depth - i - 1,
+						    EXT4_EX_NOCACHE);
 			if (IS_ERR(bh)) {
 				/* should we reset i_size? */
 				err = PTR_ERR(bh);
-- 
2.31.0

