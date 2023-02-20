Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F4169CE50
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbjBTN6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjBTN6h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:58:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B421D914
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:57:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F54060E8A
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:57:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E776C433EF;
        Mon, 20 Feb 2023 13:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901478;
        bh=cX0mrIxZBkaEDjLDzT8aoCFGuAgFwvm4pHBawsM6d0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWQPcg+qdr9jmaORwC6pwClgv2K3t67REWD1MgPpWBXBQG0McM6hPgQ9dpff73qhK
         fMQrmyyo5G5hw/w6gd8SNwFTFUI1qV17sIoTtseZi1LJjrHvR62GrRdYjWpBqNgWHc
         e85Cp71cmiXzQOWtA+IGmsp2/pwHSKoHxSj832cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/118] btrfs: move the auto defrag code to defrag.c
Date:   Mon, 20 Feb 2023 14:35:21 +0100
Message-Id: <20230220133600.612118249@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 6e3df18ba7e8e68015dd66bcab326a4b7aaed085 ]

This currently exists in file.c, move it to the more natural location in
defrag.c.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ reformat comments ]
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 519b7e13b5ae ("btrfs: lock the inode in shared mode before starting fiemap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file.c        | 340 -----------------------------------------
 fs/btrfs/tree-defrag.c | 337 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 337 insertions(+), 340 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 23056d9914d84..1bda59c683602 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -31,329 +31,6 @@
 #include "reflink.h"
 #include "subpage.h"
 
-static struct kmem_cache *btrfs_inode_defrag_cachep;
-/*
- * when auto defrag is enabled we
- * queue up these defrag structs to remember which
- * inodes need defragging passes
- */
-struct inode_defrag {
-	struct rb_node rb_node;
-	/* objectid */
-	u64 ino;
-	/*
-	 * transid where the defrag was added, we search for
-	 * extents newer than this
-	 */
-	u64 transid;
-
-	/* root objectid */
-	u64 root;
-
-	/*
-	 * The extent size threshold for autodefrag.
-	 *
-	 * This value is different for compressed/non-compressed extents,
-	 * thus needs to be passed from higher layer.
-	 * (aka, inode_should_defrag())
-	 */
-	u32 extent_thresh;
-};
-
-static int __compare_inode_defrag(struct inode_defrag *defrag1,
-				  struct inode_defrag *defrag2)
-{
-	if (defrag1->root > defrag2->root)
-		return 1;
-	else if (defrag1->root < defrag2->root)
-		return -1;
-	else if (defrag1->ino > defrag2->ino)
-		return 1;
-	else if (defrag1->ino < defrag2->ino)
-		return -1;
-	else
-		return 0;
-}
-
-/* pop a record for an inode into the defrag tree.  The lock
- * must be held already
- *
- * If you're inserting a record for an older transid than an
- * existing record, the transid already in the tree is lowered
- *
- * If an existing record is found the defrag item you
- * pass in is freed
- */
-static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
-				    struct inode_defrag *defrag)
-{
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct inode_defrag *entry;
-	struct rb_node **p;
-	struct rb_node *parent = NULL;
-	int ret;
-
-	p = &fs_info->defrag_inodes.rb_node;
-	while (*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct inode_defrag, rb_node);
-
-		ret = __compare_inode_defrag(defrag, entry);
-		if (ret < 0)
-			p = &parent->rb_left;
-		else if (ret > 0)
-			p = &parent->rb_right;
-		else {
-			/* if we're reinserting an entry for
-			 * an old defrag run, make sure to
-			 * lower the transid of our existing record
-			 */
-			if (defrag->transid < entry->transid)
-				entry->transid = defrag->transid;
-			entry->extent_thresh = min(defrag->extent_thresh,
-						   entry->extent_thresh);
-			return -EEXIST;
-		}
-	}
-	set_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
-	rb_link_node(&defrag->rb_node, parent, p);
-	rb_insert_color(&defrag->rb_node, &fs_info->defrag_inodes);
-	return 0;
-}
-
-static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_test_opt(fs_info, AUTO_DEFRAG))
-		return 0;
-
-	if (btrfs_fs_closing(fs_info))
-		return 0;
-
-	return 1;
-}
-
-/*
- * insert a defrag record for this inode if auto defrag is
- * enabled
- */
-int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct btrfs_inode *inode, u32 extent_thresh)
-{
-	struct btrfs_root *root = inode->root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct inode_defrag *defrag;
-	u64 transid;
-	int ret;
-
-	if (!__need_auto_defrag(fs_info))
-		return 0;
-
-	if (test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags))
-		return 0;
-
-	if (trans)
-		transid = trans->transid;
-	else
-		transid = inode->root->last_trans;
-
-	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
-	if (!defrag)
-		return -ENOMEM;
-
-	defrag->ino = btrfs_ino(inode);
-	defrag->transid = transid;
-	defrag->root = root->root_key.objectid;
-	defrag->extent_thresh = extent_thresh;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
-		/*
-		 * If we set IN_DEFRAG flag and evict the inode from memory,
-		 * and then re-read this inode, this new inode doesn't have
-		 * IN_DEFRAG flag. At the case, we may find the existed defrag.
-		 */
-		ret = __btrfs_add_inode_defrag(inode, defrag);
-		if (ret)
-			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	} else {
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	}
-	spin_unlock(&fs_info->defrag_inodes_lock);
-	return 0;
-}
-
-/*
- * pick the defragable inode that we want, if it doesn't exist, we will get
- * the next one.
- */
-static struct inode_defrag *
-btrfs_pick_defrag_inode(struct btrfs_fs_info *fs_info, u64 root, u64 ino)
-{
-	struct inode_defrag *entry = NULL;
-	struct inode_defrag tmp;
-	struct rb_node *p;
-	struct rb_node *parent = NULL;
-	int ret;
-
-	tmp.ino = ino;
-	tmp.root = root;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	p = fs_info->defrag_inodes.rb_node;
-	while (p) {
-		parent = p;
-		entry = rb_entry(parent, struct inode_defrag, rb_node);
-
-		ret = __compare_inode_defrag(&tmp, entry);
-		if (ret < 0)
-			p = parent->rb_left;
-		else if (ret > 0)
-			p = parent->rb_right;
-		else
-			goto out;
-	}
-
-	if (parent && __compare_inode_defrag(&tmp, entry) > 0) {
-		parent = rb_next(parent);
-		if (parent)
-			entry = rb_entry(parent, struct inode_defrag, rb_node);
-		else
-			entry = NULL;
-	}
-out:
-	if (entry)
-		rb_erase(parent, &fs_info->defrag_inodes);
-	spin_unlock(&fs_info->defrag_inodes_lock);
-	return entry;
-}
-
-void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
-{
-	struct inode_defrag *defrag;
-	struct rb_node *node;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	node = rb_first(&fs_info->defrag_inodes);
-	while (node) {
-		rb_erase(node, &fs_info->defrag_inodes);
-		defrag = rb_entry(node, struct inode_defrag, rb_node);
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-
-		cond_resched_lock(&fs_info->defrag_inodes_lock);
-
-		node = rb_first(&fs_info->defrag_inodes);
-	}
-	spin_unlock(&fs_info->defrag_inodes_lock);
-}
-
-#define BTRFS_DEFRAG_BATCH	1024
-
-static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
-				    struct inode_defrag *defrag)
-{
-	struct btrfs_root *inode_root;
-	struct inode *inode;
-	struct btrfs_ioctl_defrag_range_args range;
-	int ret = 0;
-	u64 cur = 0;
-
-again:
-	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
-		goto cleanup;
-	if (!__need_auto_defrag(fs_info))
-		goto cleanup;
-
-	/* get the inode */
-	inode_root = btrfs_get_fs_root(fs_info, defrag->root, true);
-	if (IS_ERR(inode_root)) {
-		ret = PTR_ERR(inode_root);
-		goto cleanup;
-	}
-
-	inode = btrfs_iget(fs_info->sb, defrag->ino, inode_root);
-	btrfs_put_root(inode_root);
-	if (IS_ERR(inode)) {
-		ret = PTR_ERR(inode);
-		goto cleanup;
-	}
-
-	if (cur >= i_size_read(inode)) {
-		iput(inode);
-		goto cleanup;
-	}
-
-	/* do a chunk of defrag */
-	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
-	memset(&range, 0, sizeof(range));
-	range.len = (u64)-1;
-	range.start = cur;
-	range.extent_thresh = defrag->extent_thresh;
-
-	sb_start_write(fs_info->sb);
-	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
-				       BTRFS_DEFRAG_BATCH);
-	sb_end_write(fs_info->sb);
-	iput(inode);
-
-	if (ret < 0)
-		goto cleanup;
-
-	cur = max(cur + fs_info->sectorsize, range.start);
-	goto again;
-
-cleanup:
-	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	return ret;
-}
-
-/*
- * run through the list of inodes in the FS that need
- * defragging
- */
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
-{
-	struct inode_defrag *defrag;
-	u64 first_ino = 0;
-	u64 root_objectid = 0;
-
-	atomic_inc(&fs_info->defrag_running);
-	while (1) {
-		/* Pause the auto defragger. */
-		if (test_bit(BTRFS_FS_STATE_REMOUNTING,
-			     &fs_info->fs_state))
-			break;
-
-		if (!__need_auto_defrag(fs_info))
-			break;
-
-		/* find an inode to defrag */
-		defrag = btrfs_pick_defrag_inode(fs_info, root_objectid,
-						 first_ino);
-		if (!defrag) {
-			if (root_objectid || first_ino) {
-				root_objectid = 0;
-				first_ino = 0;
-				continue;
-			} else {
-				break;
-			}
-		}
-
-		first_ino = defrag->ino + 1;
-		root_objectid = defrag->root;
-
-		__btrfs_run_defrag_inode(fs_info, defrag);
-	}
-	atomic_dec(&fs_info->defrag_running);
-
-	/*
-	 * during unmount, we use the transaction_wait queue to
-	 * wait for the defragger to stop
-	 */
-	wake_up(&fs_info->transaction_wait);
-	return 0;
-}
-
 /* simple helper to fault in pages and copy.  This should go away
  * and be replaced with calls into generic code.
  */
@@ -4130,23 +3807,6 @@ const struct file_operations btrfs_file_operations = {
 	.remap_file_range = btrfs_remap_file_range,
 };
 
-void __cold btrfs_auto_defrag_exit(void)
-{
-	kmem_cache_destroy(btrfs_inode_defrag_cachep);
-}
-
-int __init btrfs_auto_defrag_init(void)
-{
-	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
-					sizeof(struct inode_defrag), 0,
-					SLAB_MEM_SPREAD,
-					NULL);
-	if (!btrfs_inode_defrag_cachep)
-		return -ENOMEM;
-
-	return 0;
-}
-
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
 {
 	int ret;
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 072ab9a1374b5..0520d6d32a2db 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -10,6 +10,326 @@
 #include "transaction.h"
 #include "locking.h"
 
+static struct kmem_cache *btrfs_inode_defrag_cachep;
+
+/*
+ * When auto defrag is enabled we queue up these defrag structs to remember
+ * which inodes need defragging passes.
+ */
+struct inode_defrag {
+	struct rb_node rb_node;
+	/* Inode number */
+	u64 ino;
+	/*
+	 * Transid where the defrag was added, we search for extents newer than
+	 * this.
+	 */
+	u64 transid;
+
+	/* Root objectid */
+	u64 root;
+
+	/*
+	 * The extent size threshold for autodefrag.
+	 *
+	 * This value is different for compressed/non-compressed extents, thus
+	 * needs to be passed from higher layer.
+	 * (aka, inode_should_defrag())
+	 */
+	u32 extent_thresh;
+};
+
+static int __compare_inode_defrag(struct inode_defrag *defrag1,
+				  struct inode_defrag *defrag2)
+{
+	if (defrag1->root > defrag2->root)
+		return 1;
+	else if (defrag1->root < defrag2->root)
+		return -1;
+	else if (defrag1->ino > defrag2->ino)
+		return 1;
+	else if (defrag1->ino < defrag2->ino)
+		return -1;
+	else
+		return 0;
+}
+
+/*
+ * Pop a record for an inode into the defrag tree.  The lock must be held
+ * already.
+ *
+ * If you're inserting a record for an older transid than an existing record,
+ * the transid already in the tree is lowered.
+ *
+ * If an existing record is found the defrag item you pass in is freed.
+ */
+static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
+				    struct inode_defrag *defrag)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct inode_defrag *entry;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	p = &fs_info->defrag_inodes.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inode_defrag, rb_node);
+
+		ret = __compare_inode_defrag(defrag, entry);
+		if (ret < 0)
+			p = &parent->rb_left;
+		else if (ret > 0)
+			p = &parent->rb_right;
+		else {
+			/*
+			 * If we're reinserting an entry for an old defrag run,
+			 * make sure to lower the transid of our existing
+			 * record.
+			 */
+			if (defrag->transid < entry->transid)
+				entry->transid = defrag->transid;
+			entry->extent_thresh = min(defrag->extent_thresh,
+						   entry->extent_thresh);
+			return -EEXIST;
+		}
+	}
+	set_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
+	rb_link_node(&defrag->rb_node, parent, p);
+	rb_insert_color(&defrag->rb_node, &fs_info->defrag_inodes);
+	return 0;
+}
+
+static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
+{
+	if (!btrfs_test_opt(fs_info, AUTO_DEFRAG))
+		return 0;
+
+	if (btrfs_fs_closing(fs_info))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Insert a defrag record for this inode if auto defrag is enabled.
+ */
+int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
+			   struct btrfs_inode *inode, u32 extent_thresh)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct inode_defrag *defrag;
+	u64 transid;
+	int ret;
+
+	if (!__need_auto_defrag(fs_info))
+		return 0;
+
+	if (test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags))
+		return 0;
+
+	if (trans)
+		transid = trans->transid;
+	else
+		transid = inode->root->last_trans;
+
+	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
+	if (!defrag)
+		return -ENOMEM;
+
+	defrag->ino = btrfs_ino(inode);
+	defrag->transid = transid;
+	defrag->root = root->root_key.objectid;
+	defrag->extent_thresh = extent_thresh;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
+		/*
+		 * If we set IN_DEFRAG flag and evict the inode from memory,
+		 * and then re-read this inode, this new inode doesn't have
+		 * IN_DEFRAG flag. At the case, we may find the existed defrag.
+		 */
+		ret = __btrfs_add_inode_defrag(inode, defrag);
+		if (ret)
+			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	} else {
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	}
+	spin_unlock(&fs_info->defrag_inodes_lock);
+	return 0;
+}
+
+/*
+ * Pick the defragable inode that we want, if it doesn't exist, we will get the
+ * next one.
+ */
+static struct inode_defrag *btrfs_pick_defrag_inode(
+			struct btrfs_fs_info *fs_info, u64 root, u64 ino)
+{
+	struct inode_defrag *entry = NULL;
+	struct inode_defrag tmp;
+	struct rb_node *p;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	tmp.ino = ino;
+	tmp.root = root;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	p = fs_info->defrag_inodes.rb_node;
+	while (p) {
+		parent = p;
+		entry = rb_entry(parent, struct inode_defrag, rb_node);
+
+		ret = __compare_inode_defrag(&tmp, entry);
+		if (ret < 0)
+			p = parent->rb_left;
+		else if (ret > 0)
+			p = parent->rb_right;
+		else
+			goto out;
+	}
+
+	if (parent && __compare_inode_defrag(&tmp, entry) > 0) {
+		parent = rb_next(parent);
+		if (parent)
+			entry = rb_entry(parent, struct inode_defrag, rb_node);
+		else
+			entry = NULL;
+	}
+out:
+	if (entry)
+		rb_erase(parent, &fs_info->defrag_inodes);
+	spin_unlock(&fs_info->defrag_inodes_lock);
+	return entry;
+}
+
+void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct inode_defrag *defrag;
+	struct rb_node *node;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	node = rb_first(&fs_info->defrag_inodes);
+	while (node) {
+		rb_erase(node, &fs_info->defrag_inodes);
+		defrag = rb_entry(node, struct inode_defrag, rb_node);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+
+		cond_resched_lock(&fs_info->defrag_inodes_lock);
+
+		node = rb_first(&fs_info->defrag_inodes);
+	}
+	spin_unlock(&fs_info->defrag_inodes_lock);
+}
+
+#define BTRFS_DEFRAG_BATCH	1024
+
+static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
+				    struct inode_defrag *defrag)
+{
+	struct btrfs_root *inode_root;
+	struct inode *inode;
+	struct btrfs_ioctl_defrag_range_args range;
+	int ret = 0;
+	u64 cur = 0;
+
+again:
+	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+		goto cleanup;
+	if (!__need_auto_defrag(fs_info))
+		goto cleanup;
+
+	/* Get the inode */
+	inode_root = btrfs_get_fs_root(fs_info, defrag->root, true);
+	if (IS_ERR(inode_root)) {
+		ret = PTR_ERR(inode_root);
+		goto cleanup;
+	}
+
+	inode = btrfs_iget(fs_info->sb, defrag->ino, inode_root);
+	btrfs_put_root(inode_root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto cleanup;
+	}
+
+	if (cur >= i_size_read(inode)) {
+		iput(inode);
+		goto cleanup;
+	}
+
+	/* Do a chunk of defrag */
+	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
+	memset(&range, 0, sizeof(range));
+	range.len = (u64)-1;
+	range.start = cur;
+	range.extent_thresh = defrag->extent_thresh;
+
+	sb_start_write(fs_info->sb);
+	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
+				       BTRFS_DEFRAG_BATCH);
+	sb_end_write(fs_info->sb);
+	iput(inode);
+
+	if (ret < 0)
+		goto cleanup;
+
+	cur = max(cur + fs_info->sectorsize, range.start);
+	goto again;
+
+cleanup:
+	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	return ret;
+}
+
+/*
+ * Run through the list of inodes in the FS that need defragging.
+ */
+int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct inode_defrag *defrag;
+	u64 first_ino = 0;
+	u64 root_objectid = 0;
+
+	atomic_inc(&fs_info->defrag_running);
+	while (1) {
+		/* Pause the auto defragger. */
+		if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+			break;
+
+		if (!__need_auto_defrag(fs_info))
+			break;
+
+		/* find an inode to defrag */
+		defrag = btrfs_pick_defrag_inode(fs_info, root_objectid, first_ino);
+		if (!defrag) {
+			if (root_objectid || first_ino) {
+				root_objectid = 0;
+				first_ino = 0;
+				continue;
+			} else {
+				break;
+			}
+		}
+
+		first_ino = defrag->ino + 1;
+		root_objectid = defrag->root;
+
+		__btrfs_run_defrag_inode(fs_info, defrag);
+	}
+	atomic_dec(&fs_info->defrag_running);
+
+	/*
+	 * During unmount, we use the transaction_wait queue to wait for the
+	 * defragger to stop.
+	 */
+	wake_up(&fs_info->transaction_wait);
+	return 0;
+}
+
 /*
  * Defrag all the leaves in a given btree.
  * Read all the leaves and try to get key order to
@@ -132,3 +452,20 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 
 	return ret;
 }
+
+void __cold btrfs_auto_defrag_exit(void)
+{
+	kmem_cache_destroy(btrfs_inode_defrag_cachep);
+}
+
+int __init btrfs_auto_defrag_init(void)
+{
+	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
+					sizeof(struct inode_defrag), 0,
+					SLAB_MEM_SPREAD,
+					NULL);
+	if (!btrfs_inode_defrag_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
-- 
2.39.0



