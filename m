Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921EB676E3E
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjAVPIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjAVPId (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C33CC1C336
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A4B360C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F282C4339B;
        Sun, 22 Jan 2023 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400110;
        bh=yGIcZHV5nGXiOOLYyiQQBauhagdt+4DtrkSR+JIsBsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCgq9fI4JVT0YWrcI7aF2xH9hLsU3w/+fWDoENmsgmzrs7vhavnVzVgl/22ueczYQ
         M4KSv9lAIgV0lR1YFwaZfgId+olgr8SfjVak5WU/S0Sd9lKZGMEtxn+eWarbPLF17S
         P6kteBtSUNALKlNBqmQGneV+Td442NIJX64ltoH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/37] Revert "ext4: generalize extents status tree search functions"
Date:   Sun, 22 Jan 2023 16:04:33 +0100
Message-Id: <20230122150221.049861479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit cca8671f3a7f5775a078f2676f6d1039afb925e6 which is
commit ad431025aecda85d3ebef5e4a3aca5c1c681d0c7 upstream.

Eric writes:
	I recommend not backporting this patch or the other three
	patches apparently intended to support it to 4.19 stable.  All
	these patches are related to ext4's bigalloc feature, which was
	experimental as of 4.19 (expressly noted by contemporary
	versions of e2fsprogs) and also suffered from a number of bugs.
	A significant number of additional patches that were applied to
	5.X kernels over time would have to be backported to 4.19 for
	the patch below to function correctly. It's really not worth
	doing that given bigalloc's experimental status as of 4.19 and
	the very rare combination of the bigalloc and inline features.

Link: https://lore.kernel.org/r/Y8mAe1SlcLD5fykg@debian-BULLSEYE-live-builder-AMD64
Cc: Eric Whitney <enwlinux@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h              |    4 +
 fs/ext4/extents.c           |   52 +++++++++++----
 fs/ext4/extents_status.c    |  151 +++++---------------------------------------
 fs/ext4/extents_status.h    |   13 ---
 fs/ext4/inode.c             |   17 ++--
 include/trace/events/ext4.h |    4 -
 6 files changed, 75 insertions(+), 166 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3228,6 +3228,10 @@ extern struct ext4_ext_path *ext4_find_e
 					      int flags);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
+extern int ext4_find_delalloc_range(struct inode *inode,
+				    ext4_lblk_t lblk_start,
+				    ext4_lblk_t lblk_end);
+extern int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk);
 extern ext4_lblk_t ext4_ext_next_allocated_block(struct ext4_ext_path *path);
 extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2381,8 +2381,8 @@ ext4_ext_put_gap_in_cache(struct inode *
 {
 	struct extent_status es;
 
-	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
-				  hole_start + hole_len - 1, &es);
+	ext4_es_find_delayed_extent_range(inode, hole_start,
+					  hole_start + hole_len - 1, &es);
 	if (es.es_len) {
 		/* There's delayed extent containing lblock? */
 		if (es.es_lblk <= hole_start)
@@ -3853,6 +3853,39 @@ out:
 }
 
 /**
+ * ext4_find_delalloc_range: find delayed allocated block in the given range.
+ *
+ * Return 1 if there is a delalloc block in the range, otherwise 0.
+ */
+int ext4_find_delalloc_range(struct inode *inode,
+			     ext4_lblk_t lblk_start,
+			     ext4_lblk_t lblk_end)
+{
+	struct extent_status es;
+
+	ext4_es_find_delayed_extent_range(inode, lblk_start, lblk_end, &es);
+	if (es.es_len == 0)
+		return 0; /* there is no delay extent in this tree */
+	else if (es.es_lblk <= lblk_start &&
+		 lblk_start < es.es_lblk + es.es_len)
+		return 1;
+	else if (lblk_start <= es.es_lblk && es.es_lblk <= lblk_end)
+		return 1;
+	else
+		return 0;
+}
+
+int ext4_find_delalloc_cluster(struct inode *inode, ext4_lblk_t lblk)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	ext4_lblk_t lblk_start, lblk_end;
+	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
+	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
+
+	return ext4_find_delalloc_range(inode, lblk_start, lblk_end);
+}
+
+/**
  * Determines how many complete clusters (out of those specified by the 'map')
  * are under delalloc and were reserved quota for.
  * This function is called when we are writing out the blocks that were
@@ -3910,8 +3943,7 @@ get_reserved_cluster_alloc(struct inode
 		lblk_from = EXT4_LBLK_CMASK(sbi, lblk_start);
 		lblk_to = lblk_from + c_offset - 1;
 
-		if (ext4_es_scan_range(inode, &ext4_es_is_delayed, lblk_from,
-				       lblk_to))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -3921,8 +3953,7 @@ get_reserved_cluster_alloc(struct inode
 		lblk_from = lblk_start + num_blks;
 		lblk_to = lblk_from + (sbi->s_cluster_ratio - c_offset) - 1;
 
-		if (ext4_es_scan_range(inode, &ext4_es_is_delayed, lblk_from,
-				       lblk_to))
+		if (ext4_find_delalloc_range(inode, lblk_from, lblk_to))
 			allocated_clusters--;
 	}
 
@@ -5077,10 +5108,8 @@ static int ext4_find_delayed_extent(stru
 	ext4_lblk_t block, next_del;
 
 	if (newes->es_pblk == 0) {
-		ext4_es_find_extent_range(inode, &ext4_es_is_delayed,
-					  newes->es_lblk,
-					  newes->es_lblk + newes->es_len - 1,
-					  &es);
+		ext4_es_find_delayed_extent_range(inode, newes->es_lblk,
+				newes->es_lblk + newes->es_len - 1, &es);
 
 		/*
 		 * No extent in extent-tree contains block @newes->es_pblk,
@@ -5101,8 +5130,7 @@ static int ext4_find_delayed_extent(stru
 	}
 
 	block = newes->es_lblk + newes->es_len;
-	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, block,
-				  EXT_MAX_BLOCKS, &es);
+	ext4_es_find_delayed_extent_range(inode, block, EXT_MAX_BLOCKS, &es);
 	if (es.es_len == 0)
 		next_del = EXT_MAX_BLOCKS;
 	else
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -233,38 +233,30 @@ static struct extent_status *__es_tree_s
 }
 
 /*
- * ext4_es_find_extent_range - find extent with specified status within block
- *                             range or next extent following block range in
- *                             extents status tree
+ * ext4_es_find_delayed_extent_range: find the 1st delayed extent covering
+ * @es->lblk if it exists, otherwise, the next extent after @es->lblk.
  *
- * @inode - file containing the range
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block defining start of range
- * @end - logical block defining end of range
- * @es - extent found, if any
- *
- * Find the first extent within the block range specified by @lblk and @end
- * in the extents status tree that satisfies @matching_fn.  If a match
- * is found, it's returned in @es.  If not, and a matching extent is found
- * beyond the block range, it's returned in @es.  If no match is found, an
- * extent is returned in @es whose es_lblk, es_len, and es_pblk components
- * are 0.
- */
-static void __es_find_extent_range(struct inode *inode,
-				   int (*matching_fn)(struct extent_status *es),
-				   ext4_lblk_t lblk, ext4_lblk_t end,
-				   struct extent_status *es)
+ * @inode: the inode which owns delayed extents
+ * @lblk: the offset where we start to search
+ * @end: the offset where we stop to search
+ * @es: delayed extent that we found
+ */
+void ext4_es_find_delayed_extent_range(struct inode *inode,
+				 ext4_lblk_t lblk, ext4_lblk_t end,
+				 struct extent_status *es)
 {
 	struct ext4_es_tree *tree = NULL;
 	struct extent_status *es1 = NULL;
 	struct rb_node *node;
 
-	WARN_ON(es == NULL);
-	WARN_ON(end < lblk);
+	BUG_ON(es == NULL);
+	BUG_ON(end < lblk);
+	trace_ext4_es_find_delayed_extent_range_enter(inode, lblk);
 
+	read_lock(&EXT4_I(inode)->i_es_lock);
 	tree = &EXT4_I(inode)->i_es_tree;
 
-	/* see if the extent has been cached */
+	/* find extent in cache firstly */
 	es->es_lblk = es->es_len = es->es_pblk = 0;
 	if (tree->cache_es) {
 		es1 = tree->cache_es;
@@ -279,133 +271,28 @@ static void __es_find_extent_range(struc
 	es1 = __es_tree_search(&tree->root, lblk);
 
 out:
-	if (es1 && !matching_fn(es1)) {
+	if (es1 && !ext4_es_is_delayed(es1)) {
 		while ((node = rb_next(&es1->rb_node)) != NULL) {
 			es1 = rb_entry(node, struct extent_status, rb_node);
 			if (es1->es_lblk > end) {
 				es1 = NULL;
 				break;
 			}
-			if (matching_fn(es1))
+			if (ext4_es_is_delayed(es1))
 				break;
 		}
 	}
 
-	if (es1 && matching_fn(es1)) {
+	if (es1 && ext4_es_is_delayed(es1)) {
 		tree->cache_es = es1;
 		es->es_lblk = es1->es_lblk;
 		es->es_len = es1->es_len;
 		es->es_pblk = es1->es_pblk;
 	}
 
-}
-
-/*
- * Locking for __es_find_extent_range() for external use
- */
-void ext4_es_find_extent_range(struct inode *inode,
-			       int (*matching_fn)(struct extent_status *es),
-			       ext4_lblk_t lblk, ext4_lblk_t end,
-			       struct extent_status *es)
-{
-	trace_ext4_es_find_extent_range_enter(inode, lblk);
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	__es_find_extent_range(inode, matching_fn, lblk, end, es);
-	read_unlock(&EXT4_I(inode)->i_es_lock);
-
-	trace_ext4_es_find_extent_range_exit(inode, es);
-}
-
-/*
- * __es_scan_range - search block range for block with specified status
- *                   in extents status tree
- *
- * @inode - file containing the range
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block defining start of range
- * @end - logical block defining end of range
- *
- * Returns true if at least one block in the specified block range satisfies
- * the criterion specified by @matching_fn, and false if not.  If at least
- * one extent has the specified status, then there is at least one block
- * in the cluster with that status.  Should only be called by code that has
- * taken i_es_lock.
- */
-static bool __es_scan_range(struct inode *inode,
-			    int (*matching_fn)(struct extent_status *es),
-			    ext4_lblk_t start, ext4_lblk_t end)
-{
-	struct extent_status es;
-
-	__es_find_extent_range(inode, matching_fn, start, end, &es);
-	if (es.es_len == 0)
-		return false;   /* no matching extent in the tree */
-	else if (es.es_lblk <= start &&
-		 start < es.es_lblk + es.es_len)
-		return true;
-	else if (start <= es.es_lblk && es.es_lblk <= end)
-		return true;
-	else
-		return false;
-}
-/*
- * Locking for __es_scan_range() for external use
- */
-bool ext4_es_scan_range(struct inode *inode,
-			int (*matching_fn)(struct extent_status *es),
-			ext4_lblk_t lblk, ext4_lblk_t end)
-{
-	bool ret;
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	ret = __es_scan_range(inode, matching_fn, lblk, end);
-	read_unlock(&EXT4_I(inode)->i_es_lock);
-
-	return ret;
-}
-
-/*
- * __es_scan_clu - search cluster for block with specified status in
- *                 extents status tree
- *
- * @inode - file containing the cluster
- * @matching_fn - pointer to function that matches extents with desired status
- * @lblk - logical block in cluster to be searched
- *
- * Returns true if at least one extent in the cluster containing @lblk
- * satisfies the criterion specified by @matching_fn, and false if not.  If at
- * least one extent has the specified status, then there is at least one block
- * in the cluster with that status.  Should only be called by code that has
- * taken i_es_lock.
- */
-static bool __es_scan_clu(struct inode *inode,
-			  int (*matching_fn)(struct extent_status *es),
-			  ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	ext4_lblk_t lblk_start, lblk_end;
-
-	lblk_start = EXT4_LBLK_CMASK(sbi, lblk);
-	lblk_end = lblk_start + sbi->s_cluster_ratio - 1;
-
-	return __es_scan_range(inode, matching_fn, lblk_start, lblk_end);
-}
-
-/*
- * Locking for __es_scan_clu() for external use
- */
-bool ext4_es_scan_clu(struct inode *inode,
-		      int (*matching_fn)(struct extent_status *es),
-		      ext4_lblk_t lblk)
-{
-	bool ret;
-
-	read_lock(&EXT4_I(inode)->i_es_lock);
-	ret = __es_scan_clu(inode, matching_fn, lblk);
 	read_unlock(&EXT4_I(inode)->i_es_lock);
 
-	return ret;
+	trace_ext4_es_find_delayed_extent_range_exit(inode, es);
 }
 
 static void ext4_es_list_add(struct inode *inode)
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -90,18 +90,11 @@ extern void ext4_es_cache_extent(struct
 				 unsigned int status);
 extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 				 ext4_lblk_t len);
-extern void ext4_es_find_extent_range(struct inode *inode,
-				      int (*match_fn)(struct extent_status *es),
-				      ext4_lblk_t lblk, ext4_lblk_t end,
-				      struct extent_status *es);
+extern void ext4_es_find_delayed_extent_range(struct inode *inode,
+					ext4_lblk_t lblk, ext4_lblk_t end,
+					struct extent_status *es);
 extern int ext4_es_lookup_extent(struct inode *inode, ext4_lblk_t lblk,
 				 struct extent_status *es);
-extern bool ext4_es_scan_range(struct inode *inode,
-			       int (*matching_fn)(struct extent_status *es),
-			       ext4_lblk_t lblk, ext4_lblk_t end);
-extern bool ext4_es_scan_clu(struct inode *inode,
-			     int (*matching_fn)(struct extent_status *es),
-			     ext4_lblk_t lblk);
 
 static inline unsigned int ext4_es_status(struct extent_status *es)
 {
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -600,8 +600,8 @@ int ext4_map_blocks(handle_t *handle, st
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
 		    !(status & EXTENT_STATUS_WRITTEN) &&
-		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
-				       map->m_lblk + map->m_len - 1))
+		    ext4_find_delalloc_range(inode, map->m_lblk,
+					     map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
 		ret = ext4_es_insert_extent(inode, map->m_lblk,
 					    map->m_len, map->m_pblk, status);
@@ -724,8 +724,8 @@ found:
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		if (!(flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
 		    !(status & EXTENT_STATUS_WRITTEN) &&
-		    ext4_es_scan_range(inode, &ext4_es_is_delayed, map->m_lblk,
-				       map->m_lblk + map->m_len - 1))
+		    ext4_find_delalloc_range(inode, map->m_lblk,
+					     map->m_lblk + map->m_len - 1))
 			status |= EXTENT_STATUS_DELAYED;
 		ret = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
 					    map->m_pblk, status);
@@ -1717,7 +1717,7 @@ static void ext4_da_page_release_reserva
 		lblk = (page->index << (PAGE_SHIFT - inode->i_blkbits)) +
 			((num_clusters - 1) << sbi->s_cluster_bits);
 		if (sbi->s_cluster_ratio == 1 ||
-		    !ext4_es_scan_clu(inode, &ext4_es_is_delayed, lblk))
+		    !ext4_find_delalloc_cluster(inode, lblk))
 			ext4_da_release_space(inode, 1);
 
 		num_clusters--;
@@ -1902,7 +1902,6 @@ static int ext4_da_map_blocks(struct ino
 add_delayed:
 	if (retval == 0) {
 		int ret;
-
 		/*
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
@@ -1913,8 +1912,7 @@ add_delayed:
 		 * to reserve metadata for every block we're going to write.
 		 */
 		if (EXT4_SB(inode->i_sb)->s_cluster_ratio == 1 ||
-		    !ext4_es_scan_clu(inode,
-				      &ext4_es_is_delayed, map->m_lblk)) {
+		    !ext4_find_delalloc_cluster(inode, map->m_lblk)) {
 			ret = ext4_da_reserve_space(inode);
 			if (ret) {
 				/* not enough space to reserve */
@@ -3521,8 +3519,7 @@ static int ext4_iomap_begin(struct inode
 			ext4_lblk_t end = map.m_lblk + map.m_len - 1;
 			struct extent_status es;
 
-			ext4_es_find_extent_range(inode, &ext4_es_is_delayed,
-						  map.m_lblk, end, &es);
+			ext4_es_find_delayed_extent_range(inode, map.m_lblk, end, &es);
 
 			if (!es.es_len || es.es_lblk > end) {
 				/* entire range is a hole */
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -2290,7 +2290,7 @@ TRACE_EVENT(ext4_es_remove_extent,
 		  __entry->lblk, __entry->len)
 );
 
-TRACE_EVENT(ext4_es_find_extent_range_enter,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_enter,
 	TP_PROTO(struct inode *inode, ext4_lblk_t lblk),
 
 	TP_ARGS(inode, lblk),
@@ -2312,7 +2312,7 @@ TRACE_EVENT(ext4_es_find_extent_range_en
 		  (unsigned long) __entry->ino, __entry->lblk)
 );
 
-TRACE_EVENT(ext4_es_find_extent_range_exit,
+TRACE_EVENT(ext4_es_find_delayed_extent_range_exit,
 	TP_PROTO(struct inode *inode, struct extent_status *es),
 
 	TP_ARGS(inode, es),


