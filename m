Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF32676E3D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjAVPIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjAVPId (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:08:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC841DBBA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32A1CCE0ECE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E0EC433D2;
        Sun, 22 Jan 2023 15:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400108;
        bh=/P1A2tuavZfDOCZMgCTR2PUcm9Bjp/nej3vFhmZT7UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JEyrMmG4F0/+/KWgVEyyA8309B5hqfGO1Uvm8m1n16pAR370QFQ9M+iVmUwlud1Zu
         uoWD9omghXoFo4zovsVYWtTyyYDI/e0NcecbT67CsxYFVfczKu8Her7p03Va8/OWil
         GMOuRKL5o49mGYdbq1PPK3heYoU/U/n5ECaiTZAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Whitney <enwlinux@gmail.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 35/37] Revert "ext4: add new pending reservation mechanism"
Date:   Sun, 22 Jan 2023 16:04:32 +0100
Message-Id: <20230122150221.010316382@linuxfoundation.org>
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

This reverts commit 9bacbb4cfdbc41518d13f620d3f53c0ba36ca87e which is
commit 1dc0aa46e74a3366e12f426b7caaca477853e9c3 upstream.

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
 fs/ext4/ext4.h           |    3 
 fs/ext4/extents_status.c |  187 -----------------------------------------------
 fs/ext4/extents_status.h |   51 ------------
 fs/ext4/super.c          |    8 --
 4 files changed, 249 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1041,9 +1041,6 @@ struct ext4_inode_info {
 	ext4_lblk_t i_da_metadata_calc_last_lblock;
 	int i_da_metadata_calc_len;
 
-	/* pending cluster reservations for bigalloc file systems */
-	struct ext4_pending_tree i_pending_tree;
-
 	/* on-disk additional length */
 	__u16 i_extra_isize;
 
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -142,7 +142,6 @@
  */
 
 static struct kmem_cache *ext4_es_cachep;
-static struct kmem_cache *ext4_pending_cachep;
 
 static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
@@ -1364,189 +1363,3 @@ static int es_reclaim_extents(struct ext
 	ei->i_es_tree.cache_es = NULL;
 	return nr_shrunk;
 }
-
-#ifdef ES_DEBUG__
-static void ext4_print_pending_tree(struct inode *inode)
-{
-	struct ext4_pending_tree *tree;
-	struct rb_node *node;
-	struct pending_reservation *pr;
-
-	printk(KERN_DEBUG "pending reservations for inode %lu:", inode->i_ino);
-	tree = &EXT4_I(inode)->i_pending_tree;
-	node = rb_first(&tree->root);
-	while (node) {
-		pr = rb_entry(node, struct pending_reservation, rb_node);
-		printk(KERN_DEBUG " %u", pr->lclu);
-		node = rb_next(node);
-	}
-	printk(KERN_DEBUG "\n");
-}
-#else
-#define ext4_print_pending_tree(inode)
-#endif
-
-int __init ext4_init_pending(void)
-{
-	ext4_pending_cachep = kmem_cache_create("ext4_pending_reservation",
-					   sizeof(struct pending_reservation),
-					   0, (SLAB_RECLAIM_ACCOUNT), NULL);
-	if (ext4_pending_cachep == NULL)
-		return -ENOMEM;
-	return 0;
-}
-
-void ext4_exit_pending(void)
-{
-	kmem_cache_destroy(ext4_pending_cachep);
-}
-
-void ext4_init_pending_tree(struct ext4_pending_tree *tree)
-{
-	tree->root = RB_ROOT;
-}
-
-/*
- * __get_pending - retrieve a pointer to a pending reservation
- *
- * @inode - file containing the pending cluster reservation
- * @lclu - logical cluster of interest
- *
- * Returns a pointer to a pending reservation if it's a member of
- * the set, and NULL if not.  Must be called holding i_es_lock.
- */
-static struct pending_reservation *__get_pending(struct inode *inode,
-						 ext4_lblk_t lclu)
-{
-	struct ext4_pending_tree *tree;
-	struct rb_node *node;
-	struct pending_reservation *pr = NULL;
-
-	tree = &EXT4_I(inode)->i_pending_tree;
-	node = (&tree->root)->rb_node;
-
-	while (node) {
-		pr = rb_entry(node, struct pending_reservation, rb_node);
-		if (lclu < pr->lclu)
-			node = node->rb_left;
-		else if (lclu > pr->lclu)
-			node = node->rb_right;
-		else if (lclu == pr->lclu)
-			return pr;
-	}
-	return NULL;
-}
-
-/*
- * __insert_pending - adds a pending cluster reservation to the set of
- *                    pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the cluster to be added
- *
- * Returns 0 on successful insertion and -ENOMEM on failure.  If the
- * pending reservation is already in the set, returns successfully.
- */
-static int __insert_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_pending_tree *tree = &EXT4_I(inode)->i_pending_tree;
-	struct rb_node **p = &tree->root.rb_node;
-	struct rb_node *parent = NULL;
-	struct pending_reservation *pr;
-	ext4_lblk_t lclu;
-	int ret = 0;
-
-	lclu = EXT4_B2C(sbi, lblk);
-	/* search to find parent for insertion */
-	while (*p) {
-		parent = *p;
-		pr = rb_entry(parent, struct pending_reservation, rb_node);
-
-		if (lclu < pr->lclu) {
-			p = &(*p)->rb_left;
-		} else if (lclu > pr->lclu) {
-			p = &(*p)->rb_right;
-		} else {
-			/* pending reservation already inserted */
-			goto out;
-		}
-	}
-
-	pr = kmem_cache_alloc(ext4_pending_cachep, GFP_ATOMIC);
-	if (pr == NULL) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	pr->lclu = lclu;
-
-	rb_link_node(&pr->rb_node, parent, p);
-	rb_insert_color(&pr->rb_node, &tree->root);
-
-out:
-	return ret;
-}
-
-/*
- * __remove_pending - removes a pending cluster reservation from the set
- *                    of pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the pending cluster reservation to be removed
- *
- * Returns successfully if pending reservation is not a member of the set.
- */
-static void __remove_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct pending_reservation *pr;
-	struct ext4_pending_tree *tree;
-
-	pr = __get_pending(inode, EXT4_B2C(sbi, lblk));
-	if (pr != NULL) {
-		tree = &EXT4_I(inode)->i_pending_tree;
-		rb_erase(&pr->rb_node, &tree->root);
-		kmem_cache_free(ext4_pending_cachep, pr);
-	}
-}
-
-/*
- * ext4_remove_pending - removes a pending cluster reservation from the set
- *                       of pending reservations
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the pending cluster reservation to be removed
- *
- * Locking for external use of __remove_pending.
- */
-void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_inode_info *ei = EXT4_I(inode);
-
-	write_lock(&ei->i_es_lock);
-	__remove_pending(inode, lblk);
-	write_unlock(&ei->i_es_lock);
-}
-
-/*
- * ext4_is_pending - determine whether a cluster has a pending reservation
- *                   on it
- *
- * @inode - file containing the cluster
- * @lblk - logical block in the cluster
- *
- * Returns true if there's a pending reservation for the cluster in the
- * set of pending reservations, and false if not.
- */
-bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	bool ret;
-
-	read_lock(&ei->i_es_lock);
-	ret = (bool)(__get_pending(inode, EXT4_B2C(sbi, lblk)) != NULL);
-	read_unlock(&ei->i_es_lock);
-
-	return ret;
-}
--- a/fs/ext4/extents_status.h
+++ b/fs/ext4/extents_status.h
@@ -78,51 +78,6 @@ struct ext4_es_stats {
 	struct percpu_counter es_stats_shk_cnt;
 };
 
-/*
- * Pending cluster reservations for bigalloc file systems
- *
- * A cluster with a pending reservation is a logical cluster shared by at
- * least one extent in the extents status tree with delayed and unwritten
- * status and at least one other written or unwritten extent.  The
- * reservation is said to be pending because a cluster reservation would
- * have to be taken in the event all blocks in the cluster shared with
- * written or unwritten extents were deleted while the delayed and
- * unwritten blocks remained.
- *
- * The set of pending cluster reservations is an auxiliary data structure
- * used with the extents status tree to implement reserved cluster/block
- * accounting for bigalloc file systems.  The set is kept in memory and
- * records all pending cluster reservations.
- *
- * Its primary function is to avoid the need to read extents from the
- * disk when invalidating pages as a result of a truncate, punch hole, or
- * collapse range operation.  Page invalidation requires a decrease in the
- * reserved cluster count if it results in the removal of all delayed
- * and unwritten extents (blocks) from a cluster that is not shared with a
- * written or unwritten extent, and no decrease otherwise.  Determining
- * whether the cluster is shared can be done by searching for a pending
- * reservation on it.
- *
- * Secondarily, it provides a potentially faster method for determining
- * whether the reserved cluster count should be increased when a physical
- * cluster is deallocated as a result of a truncate, punch hole, or
- * collapse range operation.  The necessary information is also present
- * in the extents status tree, but might be more rapidly accessed in
- * the pending reservation set in many cases due to smaller size.
- *
- * The pending cluster reservation set is implemented as a red-black tree
- * with the goal of minimizing per page search time overhead.
- */
-
-struct pending_reservation {
-	struct rb_node rb_node;
-	ext4_lblk_t lclu;
-};
-
-struct ext4_pending_tree {
-	struct rb_root root;
-};
-
 extern int __init ext4_init_es(void);
 extern void ext4_exit_es(void);
 extern void ext4_es_init_tree(struct ext4_es_tree *tree);
@@ -227,10 +182,4 @@ extern void ext4_es_unregister_shrinker(
 
 extern int ext4_seq_es_shrinker_info_show(struct seq_file *seq, void *v);
 
-extern int __init ext4_init_pending(void);
-extern void ext4_exit_pending(void);
-extern void ext4_init_pending_tree(struct ext4_pending_tree *tree);
-extern void ext4_remove_pending(struct inode *inode, ext4_lblk_t lblk);
-extern bool ext4_is_pending(struct inode *inode, ext4_lblk_t lblk);
-
 #endif /* _EXT4_EXTENTS_STATUS_H */
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1095,7 +1095,6 @@ static struct inode *ext4_alloc_inode(st
 	ei->i_da_metadata_calc_len = 0;
 	ei->i_da_metadata_calc_last_lblock = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
-	ext4_init_pending_tree(&ei->i_pending_tree);
 #ifdef CONFIG_QUOTA
 	ei->i_reserved_quota = 0;
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
@@ -6190,10 +6189,6 @@ static int __init ext4_init_fs(void)
 	if (err)
 		return err;
 
-	err = ext4_init_pending();
-	if (err)
-		goto out6;
-
 	err = ext4_init_pageio();
 	if (err)
 		goto out5;
@@ -6232,8 +6227,6 @@ out3:
 out4:
 	ext4_exit_pageio();
 out5:
-	ext4_exit_pending();
-out6:
 	ext4_exit_es();
 
 	return err;
@@ -6251,7 +6244,6 @@ static void __exit ext4_exit_fs(void)
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
 	ext4_exit_es();
-	ext4_exit_pending();
 }
 
 MODULE_AUTHOR("Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others");


