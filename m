Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4171847FFFD
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbhL0PmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39958 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbhL0Pke (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 401A761052;
        Mon, 27 Dec 2021 15:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D9C36AEA;
        Mon, 27 Dec 2021 15:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619633;
        bh=gF5H9TKa9JL9BZ6K2Kib2s5Mqir6ka1eJRktLpz13Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MEamUIUEeXTyj2+qMgjqB+1fuplTTbp7fmSbeYdaJ2CceC392epwF1WT8ucEL1aBA
         3/khFQWIt2qWxYhSzpA6AedwFiaJvPFJ8mvpWNs/RLju9rS4N1Bqc3RXkcEp/Q4kbl
         y/k0wA+H4nGW1JL4daWwIpCoOfbHh7uHckEAaPu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 005/128] ext4: check for inconsistent extents between index and leaf block
Date:   Mon, 27 Dec 2021 16:29:40 +0100
Message-Id: <20211227151331.686637728@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 9c6e071913792d80894cd0be98cc3c4b770e26d3 upstream.

Now that we can check out overlapping extents in leaf block and
out-of-order index extents in index block. But the .ee_block in the
first extent of one leaf block should equal to the .ei_block in it's
parent index extent entry. This patch add a check to verify such
inconsistent between the index and leaf block.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://lore.kernel.org/r/20210908120850.4012324-3-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |   59 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 23 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -367,7 +367,8 @@ static int ext4_valid_extent_idx(struct
 
 static int ext4_valid_extent_entries(struct inode *inode,
 				     struct ext4_extent_header *eh,
-				     ext4_fsblk_t *pblk, int depth)
+				     ext4_lblk_t lblk, ext4_fsblk_t *pblk,
+				     int depth)
 {
 	unsigned short entries;
 	ext4_lblk_t lblock = 0;
@@ -381,6 +382,14 @@ static int ext4_valid_extent_entries(str
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
@@ -397,6 +406,14 @@ static int ext4_valid_extent_entries(str
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
@@ -417,7 +434,7 @@ static int ext4_valid_extent_entries(str
 
 static int __ext4_ext_check(const char *function, unsigned int line,
 			    struct inode *inode, struct ext4_extent_header *eh,
-			    int depth, ext4_fsblk_t pblk)
+			    int depth, ext4_fsblk_t pblk, ext4_lblk_t lblk)
 {
 	const char *error_msg;
 	int max = 0, err = -EFSCORRUPTED;
@@ -443,7 +460,7 @@ static int __ext4_ext_check(const char *
 		error_msg = "invalid eh_entries";
 		goto corrupted;
 	}
-	if (!ext4_valid_extent_entries(inode, eh, &pblk, depth)) {
+	if (!ext4_valid_extent_entries(inode, eh, lblk, &pblk, depth)) {
 		error_msg = "invalid extent entries";
 		goto corrupted;
 	}
@@ -473,7 +490,7 @@ corrupted:
 }
 
 #define ext4_ext_check(inode, eh, depth, pblk)			\
-	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk))
+	__ext4_ext_check(__func__, __LINE__, (inode), (eh), (depth), (pblk), 0)
 
 int ext4_ext_check_inode(struct inode *inode)
 {
@@ -506,16 +523,18 @@ static void ext4_cache_extents(struct in
 
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
@@ -528,8 +547,8 @@ __read_extent_tree_block(const char *fun
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
@@ -547,8 +566,8 @@ errout:
 
 }
 
-#define read_extent_tree_block(inode, pblk, depth, flags)		\
-	__read_extent_tree_block(__func__, __LINE__, (inode), (pblk),   \
+#define read_extent_tree_block(inode, idx, depth, flags)		\
+	__read_extent_tree_block(__func__, __LINE__, (inode), (idx),	\
 				 (depth), (flags))
 
 /*
@@ -598,8 +617,7 @@ int ext4_ext_precache(struct inode *inod
 			i--;
 			continue;
 		}
-		bh = read_extent_tree_block(inode,
-					    ext4_idx_pblock(path[i].p_idx++),
+		bh = read_extent_tree_block(inode, path[i].p_idx++,
 					    depth - i - 1,
 					    EXT4_EX_FORCE_CACHE);
 		if (IS_ERR(bh)) {
@@ -904,8 +922,7 @@ ext4_find_extent(struct inode *inode, ex
 		path[ppos].p_depth = i;
 		path[ppos].p_ext = NULL;
 
-		bh = read_extent_tree_block(inode, path[ppos].p_block, --i,
-					    flags);
+		bh = read_extent_tree_block(inode, path[ppos].p_idx, --i, flags);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
 			goto err;
@@ -1514,7 +1531,6 @@ static int ext4_ext_search_right(struct
 	struct ext4_extent_header *eh;
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
-	ext4_fsblk_t block;
 	int depth;	/* Note, NOT eh_depth; depth from top of tree */
 	int ee_len;
 
@@ -1581,20 +1597,17 @@ got_index:
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
@@ -2973,9 +2986,9 @@ again:
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


