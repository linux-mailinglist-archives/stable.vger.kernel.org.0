Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5D96B5281
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 22:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCJVFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 16:05:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCJVFF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 16:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAE393FA;
        Fri, 10 Mar 2023 13:05:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E0C761D61;
        Fri, 10 Mar 2023 21:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB690C4339B;
        Fri, 10 Mar 2023 21:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678482301;
        bh=jyiBeMdshyF5q/uOJqeaCKVKG+kKajYCgiDYMvUXlKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jLdXNVs5IC+f3Xg0EpqN0zXHQnvLvHsYZ4Hv/0oWCAJsr9/F7s+DRmMgC8SmsuYga
         6+nU2a7w5Tpdt2qvD5Ha9XOfwVYcjaWfeaIL74KeOKlCZGES/N2+mHMw7Z7APgcjLi
         3RpLEF6V/aRDhqpTD/CVM07wEEkYnbbBe36dNVDNmZIMWko188fzucfmvHpjqbFLDF
         4OJQ5ucMIlBEpVb4nNE2hmC6Bz1TCFW151TWgJ4m/7OeEpploz3vnsV8DWgWJSMOJN
         hw8K5/TvaFjzZt8ij2bljcAQQDNOB6KhJhosTEkEo8/n2UffRIgrOvWf2gTJrr1Fwc
         HqHRSdU6qZX4g==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/3] f2fs: factor out discard_cmd usage from general rb_tree use
Date:   Fri, 10 Mar 2023 13:04:53 -0800
Message-Id: <20230310210454.2350881-2-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230310210454.2350881-1-jaegeuk@kernel.org>
References: <20230310210454.2350881-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a second part to remove the mixed use of rb_tree in discard_cmd from
extent_cache.

This should also fix arm32 memory alignment issue caused by shared rb_entry.

[struct discard_cmd]               [struct rb_entry]
[0] struct rb_node rb_node;        [0] struct rb_node rb_node;
  union {                              union {
    struct {                             struct {
[16]  block_t lstart;              [12]    unsigned int ofs;
      block_t len;                         unsigned int len;
                                         };
                                         unsigned long long key;
                                       } __packed;

Cc: <stable@vger.kernel.org>
Fixes: 004b68621897 ("f2fs: use rb-tree to track pending discard commands")
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/extent_cache.c |  36 +-----
 fs/f2fs/f2fs.h         |  23 +---
 fs/f2fs/segment.c      | 255 +++++++++++++++++++++++++++--------------
 3 files changed, 172 insertions(+), 142 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index d1aa4609ca6b..5c206f941aac 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -192,7 +192,7 @@ static struct rb_entry *__lookup_rb_tree_slow(struct rb_root_cached *root,
 	return NULL;
 }
 
-struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
+static struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
 				struct rb_entry *cached_re, unsigned int ofs)
 {
 	struct rb_entry *re;
@@ -204,7 +204,7 @@ struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
 	return re;
 }
 
-struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
+static struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
 				struct rb_root_cached *root,
 				struct rb_node **parent,
 				unsigned int ofs, bool *leftmost)
@@ -238,7 +238,7 @@ struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
  * in order to simplify the insertion after.
  * tree must stay unchanged between lookup and insertion.
  */
-struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
+static struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
 				struct rb_entry *cached_re,
 				unsigned int ofs,
 				struct rb_entry **prev_entry,
@@ -311,36 +311,6 @@ struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
 	return re;
 }
 
-bool f2fs_check_rb_tree_consistence(struct f2fs_sb_info *sbi,
-				struct rb_root_cached *root)
-{
-#ifdef CONFIG_F2FS_CHECK_FS
-	struct rb_node *cur = rb_first_cached(root), *next;
-	struct rb_entry *cur_re, *next_re;
-
-	if (!cur)
-		return true;
-
-	while (cur) {
-		next = rb_next(cur);
-		if (!next)
-			return true;
-
-		cur_re = rb_entry(cur, struct rb_entry, rb_node);
-		next_re = rb_entry(next, struct rb_entry, rb_node);
-
-		if (cur_re->ofs + cur_re->len > next_re->ofs) {
-			f2fs_info(sbi, "inconsistent rbtree, cur(%u, %u) next(%u, %u)",
-				  cur_re->ofs, cur_re->len,
-				  next_re->ofs, next_re->len);
-			return false;
-		}
-		cur = next;
-	}
-#endif
-	return true;
-}
-
 static struct kmem_cache *extent_tree_slab;
 static struct kmem_cache *extent_node_slab;
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 9396549e112d..6e04fea9c34f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -353,15 +353,7 @@ struct discard_info {
 
 struct discard_cmd {
 	struct rb_node rb_node;		/* rb node located in rb-tree */
-	union {
-		struct {
-			block_t lstart;	/* logical start address */
-			block_t len;	/* length */
-			block_t start;	/* actual start address in dev */
-		};
-		struct discard_info di;	/* discard info */
-
-	};
+	struct discard_info di;		/* discard info */
 	struct list_head list;		/* command list */
 	struct completion wait;		/* compleation */
 	struct block_device *bdev;	/* bdev */
@@ -4132,19 +4124,6 @@ void f2fs_leave_shrinker(struct f2fs_sb_info *sbi);
  * extent_cache.c
  */
 bool sanity_check_extent_cache(struct inode *inode);
-struct rb_entry *f2fs_lookup_rb_tree(struct rb_root_cached *root,
-				struct rb_entry *cached_re, unsigned int ofs);
-struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
-				struct rb_root_cached *root,
-				struct rb_node **parent,
-				unsigned int ofs, bool *leftmost);
-struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
-		struct rb_entry *cached_re, unsigned int ofs,
-		struct rb_entry **prev_entry, struct rb_entry **next_entry,
-		struct rb_node ***insert_p, struct rb_node **insert_parent,
-		bool force, bool *leftmost);
-bool f2fs_check_rb_tree_consistence(struct f2fs_sb_info *sbi,
-				struct rb_root_cached *root);
 void f2fs_init_extent_tree(struct inode *inode);
 void f2fs_drop_extent_tree(struct inode *inode);
 void f2fs_destroy_extent_node(struct inode *inode);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index e98a12e8dca1..961f5b149ee4 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -933,9 +933,9 @@ static struct discard_cmd *__create_discard_cmd(struct f2fs_sb_info *sbi,
 	dc = f2fs_kmem_cache_alloc(discard_cmd_slab, GFP_NOFS, true, NULL);
 	INIT_LIST_HEAD(&dc->list);
 	dc->bdev = bdev;
-	dc->lstart = lstart;
-	dc->start = start;
-	dc->len = len;
+	dc->di.lstart = lstart;
+	dc->di.start = start;
+	dc->di.len = len;
 	dc->ref = 0;
 	dc->state = D_PREP;
 	dc->queued = 0;
@@ -950,20 +950,111 @@ static struct discard_cmd *__create_discard_cmd(struct f2fs_sb_info *sbi,
 	return dc;
 }
 
-static struct discard_cmd *__attach_discard_cmd(struct f2fs_sb_info *sbi,
-				struct block_device *bdev, block_t lstart,
-				block_t start, block_t len,
-				struct rb_node *parent, struct rb_node **p,
-				bool leftmost)
+static bool f2fs_check_discard_tree(struct f2fs_sb_info *sbi)
+{
+#ifdef CONFIG_F2FS_CHECK_FS
+	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
+	struct rb_node *cur = rb_first_cached(&dcc->root), *next;
+	struct discard_cmd *cur_dc, *next_dc;
+
+	if (!cur)
+		return true;
+
+	while (cur) {
+		next = rb_next(cur);
+		if (!next)
+			return true;
+
+		cur_dc = rb_entry(cur, struct discard_cmd, rb_node);
+		next_dc = rb_entry(next, struct discard_cmd, rb_node);
+
+		if (cur_dc->di.lstart + cur_dc->di.len > next_dc->di.lstart) {
+			f2fs_info(sbi, "broken discard_rbtree, "
+				"cur(%u, %u) next(%u, %u)",
+				cur_dc->di.lstart, cur_dc->di.len,
+				next_dc->di.lstart, next_dc->di.len);
+			return false;
+		}
+		cur = next;
+	}
+#endif
+	return true;
+}
+
+static struct discard_cmd *__lookup_discard_cmd(struct f2fs_sb_info *sbi,
+						block_t blkaddr)
 {
 	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
+	struct rb_node *node = dcc->root.rb_root.rb_node;
 	struct discard_cmd *dc;
 
-	dc = __create_discard_cmd(sbi, bdev, lstart, start, len);
+	while (node) {
+		dc = rb_entry(node, struct discard_cmd, rb_node);
 
-	rb_link_node(&dc->rb_node, parent, p);
-	rb_insert_color_cached(&dc->rb_node, &dcc->root, leftmost);
+		if (blkaddr < dc->di.lstart)
+			node = node->rb_left;
+		else if (blkaddr >= dc->di.lstart + dc->di.len)
+			node = node->rb_right;
+		else
+			return dc;
+	}
+	return NULL;
+}
+
+static struct discard_cmd *__lookup_discard_cmd_ret(struct rb_root_cached *root,
+				block_t blkaddr,
+				struct discard_cmd **prev_entry,
+				struct discard_cmd **next_entry,
+				struct rb_node ***insert_p,
+				struct rb_node **insert_parent)
+{
+	struct rb_node **pnode = &root->rb_root.rb_node;
+	struct rb_node *parent = NULL, *tmp_node;
+	struct discard_cmd *dc;
+
+	*insert_p = NULL;
+	*insert_parent = NULL;
+	*prev_entry = NULL;
+	*next_entry = NULL;
+
+	if (RB_EMPTY_ROOT(&root->rb_root))
+		return NULL;
+
+	while (*pnode) {
+		parent = *pnode;
+		dc = rb_entry(*pnode, struct discard_cmd, rb_node);
+
+		if (blkaddr < dc->di.lstart)
+			pnode = &(*pnode)->rb_left;
+		else if (blkaddr >= dc->di.lstart + dc->di.len)
+			pnode = &(*pnode)->rb_right;
+		else
+			goto lookup_neighbors;
+	}
 
+	*insert_p = pnode;
+	*insert_parent = parent;
+
+	dc = rb_entry(parent, struct discard_cmd, rb_node);
+	tmp_node = parent;
+	if (parent && blkaddr > dc->di.lstart)
+		tmp_node = rb_next(parent);
+	*next_entry = rb_entry_safe(tmp_node, struct discard_cmd, rb_node);
+
+	tmp_node = parent;
+	if (parent && blkaddr < dc->di.lstart)
+		tmp_node = rb_prev(parent);
+	*prev_entry = rb_entry_safe(tmp_node, struct discard_cmd, rb_node);
+	return NULL;
+
+lookup_neighbors:
+	/* lookup prev node for merging backward later */
+	tmp_node = rb_prev(&dc->rb_node);
+	*prev_entry = rb_entry_safe(tmp_node, struct discard_cmd, rb_node);
+
+	/* lookup next node for merging frontward later */
+	tmp_node = rb_next(&dc->rb_node);
+	*next_entry = rb_entry_safe(tmp_node, struct discard_cmd, rb_node);
 	return dc;
 }
 
@@ -975,7 +1066,7 @@ static void __detach_discard_cmd(struct discard_cmd_control *dcc,
 
 	list_del(&dc->list);
 	rb_erase_cached(&dc->rb_node, &dcc->root);
-	dcc->undiscard_blks -= dc->len;
+	dcc->undiscard_blks -= dc->di.len;
 
 	kmem_cache_free(discard_cmd_slab, dc);
 
@@ -988,7 +1079,7 @@ static void __remove_discard_cmd(struct f2fs_sb_info *sbi,
 	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
 	unsigned long flags;
 
-	trace_f2fs_remove_discard(dc->bdev, dc->start, dc->len);
+	trace_f2fs_remove_discard(dc->bdev, dc->di.start, dc->di.len);
 
 	spin_lock_irqsave(&dc->lock, flags);
 	if (dc->bio_ref) {
@@ -1006,7 +1097,7 @@ static void __remove_discard_cmd(struct f2fs_sb_info *sbi,
 		printk_ratelimited(
 			"%sF2FS-fs (%s): Issue discard(%u, %u, %u) failed, ret: %d",
 			KERN_INFO, sbi->sb->s_id,
-			dc->lstart, dc->start, dc->len, dc->error);
+			dc->di.lstart, dc->di.start, dc->di.len, dc->error);
 	__detach_discard_cmd(dcc, dc);
 }
 
@@ -1122,14 +1213,14 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 	if (is_sbi_flag_set(sbi, SBI_NEED_FSCK))
 		return 0;
 
-	trace_f2fs_issue_discard(bdev, dc->start, dc->len);
+	trace_f2fs_issue_discard(bdev, dc->di.start, dc->di.len);
 
-	lstart = dc->lstart;
-	start = dc->start;
-	len = dc->len;
+	lstart = dc->di.lstart;
+	start = dc->di.start;
+	len = dc->di.len;
 	total_len = len;
 
-	dc->len = 0;
+	dc->di.len = 0;
 
 	while (total_len && *issued < dpolicy->max_requests && !err) {
 		struct bio *bio = NULL;
@@ -1145,7 +1236,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		if (*issued == dpolicy->max_requests)
 			last = true;
 
-		dc->len += len;
+		dc->di.len += len;
 
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
@@ -1207,34 +1298,41 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 	return err;
 }
 
-static void __insert_discard_tree(struct f2fs_sb_info *sbi,
+static void __insert_discard_cmd(struct f2fs_sb_info *sbi,
 				struct block_device *bdev, block_t lstart,
-				block_t start, block_t len,
-				struct rb_node **insert_p,
-				struct rb_node *insert_parent)
+				block_t start, block_t len)
 {
 	struct discard_cmd_control *dcc = SM_I(sbi)->dcc_info;
-	struct rb_node **p;
+	struct rb_node **p = &dcc->root.rb_root.rb_node;
 	struct rb_node *parent = NULL;
+	struct discard_cmd *dc;
 	bool leftmost = true;
 
-	if (insert_p && insert_parent) {
-		parent = insert_parent;
-		p = insert_p;
-		goto do_insert;
+	/* look up rb tree to find parent node */
+	while (*p) {
+		parent = *p;
+		dc = rb_entry(parent, struct discard_cmd, rb_node);
+
+		if (lstart < dc->di.lstart) {
+			p = &(*p)->rb_left;
+		} else if (lstart >= dc->di.lstart + dc->di.len) {
+			p = &(*p)->rb_right;
+			leftmost = false;
+		} else {
+			f2fs_bug_on(sbi, 1);
+		}
 	}
 
-	p = f2fs_lookup_rb_tree_for_insert(sbi, &dcc->root, &parent,
-							lstart, &leftmost);
-do_insert:
-	__attach_discard_cmd(sbi, bdev, lstart, start, len, parent,
-								p, leftmost);
+	dc = __create_discard_cmd(sbi, bdev, lstart, start, len);
+
+	rb_link_node(&dc->rb_node, parent, p);
+	rb_insert_color_cached(&dc->rb_node, &dcc->root, leftmost);
 }
 
 static void __relocate_discard_cmd(struct discard_cmd_control *dcc,
 						struct discard_cmd *dc)
 {
-	list_move_tail(&dc->list, &dcc->pend_list[plist_idx(dc->len)]);
+	list_move_tail(&dc->list, &dcc->pend_list[plist_idx(dc->di.len)]);
 }
 
 static void __punch_discard_cmd(struct f2fs_sb_info *sbi,
@@ -1244,7 +1342,7 @@ static void __punch_discard_cmd(struct f2fs_sb_info *sbi,
 	struct discard_info di = dc->di;
 	bool modified = false;
 
-	if (dc->state == D_DONE || dc->len == 1) {
+	if (dc->state == D_DONE || dc->di.len == 1) {
 		__remove_discard_cmd(sbi, dc);
 		return;
 	}
@@ -1252,23 +1350,22 @@ static void __punch_discard_cmd(struct f2fs_sb_info *sbi,
 	dcc->undiscard_blks -= di.len;
 
 	if (blkaddr > di.lstart) {
-		dc->len = blkaddr - dc->lstart;
-		dcc->undiscard_blks += dc->len;
+		dc->di.len = blkaddr - dc->di.lstart;
+		dcc->undiscard_blks += dc->di.len;
 		__relocate_discard_cmd(dcc, dc);
 		modified = true;
 	}
 
 	if (blkaddr < di.lstart + di.len - 1) {
 		if (modified) {
-			__insert_discard_tree(sbi, dc->bdev, blkaddr + 1,
+			__insert_discard_cmd(sbi, dc->bdev, blkaddr + 1,
 					di.start + blkaddr + 1 - di.lstart,
-					di.lstart + di.len - 1 - blkaddr,
-					NULL, NULL);
+					di.lstart + di.len - 1 - blkaddr);
 		} else {
-			dc->lstart++;
-			dc->len--;
-			dc->start++;
-			dcc->undiscard_blks += dc->len;
+			dc->di.lstart++;
+			dc->di.len--;
+			dc->di.start++;
+			dcc->undiscard_blks += dc->di.len;
 			__relocate_discard_cmd(dcc, dc);
 		}
 	}
@@ -1287,37 +1384,33 @@ static void __update_discard_tree_range(struct f2fs_sb_info *sbi,
 			SECTOR_TO_BLOCK(bdev_max_discard_sectors(bdev));
 	block_t end = lstart + len;
 
-	dc = (struct discard_cmd *)f2fs_lookup_rb_tree_ret(&dcc->root,
-					NULL, lstart,
-					(struct rb_entry **)&prev_dc,
-					(struct rb_entry **)&next_dc,
-					&insert_p, &insert_parent, true, NULL);
+	dc = __lookup_discard_cmd_ret(&dcc->root, lstart,
+				&prev_dc, &next_dc, &insert_p, &insert_parent);
 	if (dc)
 		prev_dc = dc;
 
 	if (!prev_dc) {
 		di.lstart = lstart;
-		di.len = next_dc ? next_dc->lstart - lstart : len;
+		di.len = next_dc ? next_dc->di.lstart - lstart : len;
 		di.len = min(di.len, len);
 		di.start = start;
 	}
 
 	while (1) {
 		struct rb_node *node;
-		bool merged = false;
 		struct discard_cmd *tdc = NULL;
 
 		if (prev_dc) {
-			di.lstart = prev_dc->lstart + prev_dc->len;
+			di.lstart = prev_dc->di.lstart + prev_dc->di.len;
 			if (di.lstart < lstart)
 				di.lstart = lstart;
 			if (di.lstart >= end)
 				break;
 
-			if (!next_dc || next_dc->lstart > end)
+			if (!next_dc || next_dc->di.lstart > end)
 				di.len = end - di.lstart;
 			else
-				di.len = next_dc->lstart - di.lstart;
+				di.len = next_dc->di.lstart - di.lstart;
 			di.start = start + di.lstart - lstart;
 		}
 
@@ -1333,7 +1426,7 @@ static void __update_discard_tree_range(struct f2fs_sb_info *sbi,
 			__relocate_discard_cmd(dcc, prev_dc);
 			di = prev_dc->di;
 			tdc = prev_dc;
-			merged = true;
+			goto next;
 		}
 
 		if (next_dc && next_dc->state == D_PREP &&
@@ -1347,13 +1440,10 @@ static void __update_discard_tree_range(struct f2fs_sb_info *sbi,
 			__relocate_discard_cmd(dcc, next_dc);
 			if (tdc)
 				__remove_discard_cmd(sbi, tdc);
-			merged = true;
+			goto next;
 		}
 
-		if (!merged) {
-			__insert_discard_tree(sbi, bdev, di.lstart, di.start,
-							di.len, NULL, NULL);
-		}
+		__insert_discard_cmd(sbi, bdev, di.lstart, di.start, di.len);
  next:
 		prev_dc = next_dc;
 		if (!prev_dc)
@@ -1392,15 +1482,11 @@ static void __issue_discard_cmd_orderly(struct f2fs_sb_info *sbi,
 	struct rb_node **insert_p = NULL, *insert_parent = NULL;
 	struct discard_cmd *dc;
 	struct blk_plug plug;
-	unsigned int pos = dcc->next_pos;
 	bool io_interrupted = false;
 
 	mutex_lock(&dcc->cmd_lock);
-	dc = (struct discard_cmd *)f2fs_lookup_rb_tree_ret(&dcc->root,
-					NULL, pos,
-					(struct rb_entry **)&prev_dc,
-					(struct rb_entry **)&next_dc,
-					&insert_p, &insert_parent, true, NULL);
+	dc = __lookup_discard_cmd_ret(&dcc->root, dcc->next_pos,
+				&prev_dc, &next_dc, &insert_p, &insert_parent);
 	if (!dc)
 		dc = next_dc;
 
@@ -1418,7 +1504,7 @@ static void __issue_discard_cmd_orderly(struct f2fs_sb_info *sbi,
 			break;
 		}
 
-		dcc->next_pos = dc->lstart + dc->len;
+		dcc->next_pos = dc->di.lstart + dc->di.len;
 		err = __submit_discard_cmd(sbi, dpolicy, dc, issued);
 
 		if (*issued >= dpolicy->max_requests)
@@ -1477,8 +1563,7 @@ static int __issue_discard_cmd(struct f2fs_sb_info *sbi,
 		if (list_empty(pend_list))
 			goto next;
 		if (unlikely(dcc->rbtree_check))
-			f2fs_bug_on(sbi, !f2fs_check_rb_tree_consistence(sbi,
-							&dcc->root));
+			f2fs_bug_on(sbi, !f2fs_check_discard_tree(sbi));
 		blk_start_plug(&plug);
 		list_for_each_entry_safe(dc, tmp, pend_list, list) {
 			f2fs_bug_on(sbi, dc->state != D_PREP);
@@ -1556,7 +1641,7 @@ static unsigned int __wait_one_discard_bio(struct f2fs_sb_info *sbi,
 	dc->ref--;
 	if (!dc->ref) {
 		if (!dc->error)
-			len = dc->len;
+			len = dc->di.len;
 		__remove_discard_cmd(sbi, dc);
 	}
 	mutex_unlock(&dcc->cmd_lock);
@@ -1579,14 +1664,15 @@ static unsigned int __wait_discard_cmd_range(struct f2fs_sb_info *sbi,
 
 	mutex_lock(&dcc->cmd_lock);
 	list_for_each_entry_safe(iter, tmp, wait_list, list) {
-		if (iter->lstart + iter->len <= start || end <= iter->lstart)
+		if (iter->di.lstart + iter->di.len <= start ||
+					end <= iter->di.lstart)
 			continue;
-		if (iter->len < dpolicy->granularity)
+		if (iter->di.len < dpolicy->granularity)
 			continue;
 		if (iter->state == D_DONE && !iter->ref) {
 			wait_for_completion_io(&iter->wait);
 			if (!iter->error)
-				trimmed += iter->len;
+				trimmed += iter->di.len;
 			__remove_discard_cmd(sbi, iter);
 		} else {
 			iter->ref++;
@@ -1630,8 +1716,7 @@ static void f2fs_wait_discard_bio(struct f2fs_sb_info *sbi, block_t blkaddr)
 	bool need_wait = false;
 
 	mutex_lock(&dcc->cmd_lock);
-	dc = (struct discard_cmd *)f2fs_lookup_rb_tree(&dcc->root,
-							NULL, blkaddr);
+	dc = __lookup_discard_cmd(sbi, blkaddr);
 	if (dc) {
 		if (dc->state == D_PREP) {
 			__punch_discard_cmd(sbi, dc, blkaddr);
@@ -2964,24 +3049,20 @@ static unsigned int __issue_discard_cmd_range(struct f2fs_sb_info *sbi,
 
 	mutex_lock(&dcc->cmd_lock);
 	if (unlikely(dcc->rbtree_check))
-		f2fs_bug_on(sbi, !f2fs_check_rb_tree_consistence(sbi,
-							&dcc->root));
-
-	dc = (struct discard_cmd *)f2fs_lookup_rb_tree_ret(&dcc->root,
-					NULL, start,
-					(struct rb_entry **)&prev_dc,
-					(struct rb_entry **)&next_dc,
-					&insert_p, &insert_parent, true, NULL);
+		f2fs_bug_on(sbi, !f2fs_check_discard_tree(sbi));
+
+	dc = __lookup_discard_cmd_ret(&dcc->root, start,
+				&prev_dc, &next_dc, &insert_p, &insert_parent);
 	if (!dc)
 		dc = next_dc;
 
 	blk_start_plug(&plug);
 
-	while (dc && dc->lstart <= end) {
+	while (dc && dc->di.lstart <= end) {
 		struct rb_node *node;
 		int err = 0;
 
-		if (dc->len < dpolicy->granularity)
+		if (dc->di.len < dpolicy->granularity)
 			goto skip;
 
 		if (dc->state != D_PREP) {
@@ -2992,7 +3073,7 @@ static unsigned int __issue_discard_cmd_range(struct f2fs_sb_info *sbi,
 		err = __submit_discard_cmd(sbi, dpolicy, dc, &issued);
 
 		if (issued >= dpolicy->max_requests) {
-			start = dc->lstart + dc->len;
+			start = dc->di.lstart + dc->di.len;
 
 			if (err)
 				__remove_discard_cmd(sbi, dc);
-- 
2.40.0.rc1.284.g88254d51c5-goog

