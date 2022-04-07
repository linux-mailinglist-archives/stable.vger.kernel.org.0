Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192A84F70FD
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiDGBXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbiDGBTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:19:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93A218EE80;
        Wed,  6 Apr 2022 18:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B9C61DE1;
        Thu,  7 Apr 2022 01:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D4EC385A8;
        Thu,  7 Apr 2022 01:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294052;
        bh=vmFV3+jew1i1W4R7jm9slUQWqdqRJc4StEDG2Gln6PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e9CwZEQk/3VUWaT9dP9MzkKQ2mBbBjIvQExuzUa1nkwuEaKSvfQt5HhW83XqQBjet
         S6JMXtLUn3say4J7KX+FMNQYHsZJcvzwYZ3c+XFQiKQjP7xiY00OqBRhoZI58RYfLN
         EQE82itb/nEECGbkTzxFiMUNFvFokKN1aOI8WJfdFCouWNKQbQ/R3TebozOOrWdf5r
         Jx38zruAd0ZStv0hrq48ABW4ap57c7zejXKXQIyG5RH2LtU9EoVbAp+/bxbnuIq16Q
         EwRmjHmbtUh3puIsofaM86Fbnn0AxOYhS5Lg6QGv6IJEtnPP0rSWYhVH5JlQthMhsn
         QaqGN75BZ3/Nw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Hao Sun <sunhao.th@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-nilfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 27/27] nilfs2: fix lockdep warnings during disk space reclamation
Date:   Wed,  6 Apr 2022 21:12:57 -0400
Message-Id: <20220407011257.114287-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 6e211930f79aa45d422009a5f2e5467d2369ffe5 ]

During disk space reclamation, nilfs2 still emits the following lockdep
warning due to page/folio operations on shadowed page caches that nilfs2
uses to get a snapshot of DAT file in memory:

  WARNING: CPU: 0 PID: 2643 at include/linux/backing-dev.h:272 __folio_mark_dirty+0x645/0x670
  ...
  RIP: 0010:__folio_mark_dirty+0x645/0x670
  ...
  Call Trace:
    filemap_dirty_folio+0x74/0xd0
    __set_page_dirty_nobuffers+0x85/0xb0
    nilfs_copy_dirty_pages+0x288/0x510 [nilfs2]
    nilfs_mdt_save_to_shadow_map+0x50/0xe0 [nilfs2]
    nilfs_clean_segments+0xee/0x5d0 [nilfs2]
    nilfs_ioctl_clean_segments.isra.19+0xb08/0xf40 [nilfs2]
    nilfs_ioctl+0xc52/0xfb0 [nilfs2]
    __x64_sys_ioctl+0x11d/0x170

This fixes the remaining warning by using inode objects to hold those
page caches.

Link: https://lkml.kernel.org/r/1647867427-30498-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hao Sun <sunhao.th@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/dat.c   |  4 ++-
 fs/nilfs2/inode.c | 63 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/nilfs2/mdt.c   | 38 +++++++++++++++++++---------
 fs/nilfs2/mdt.h   |  6 ++---
 fs/nilfs2/nilfs.h |  2 ++
 5 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 8bccdf1158fc..1a3d183027b9 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -497,7 +497,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
 	di = NILFS_DAT_I(dat);
 	lockdep_set_class(&di->mi.mi_sem, &dat_lock_key);
 	nilfs_palloc_setup_cache(dat, &di->palloc_cache);
-	nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	err = nilfs_mdt_setup_shadow_map(dat, &di->shadow);
+	if (err)
+		goto failed;
 
 	err = nilfs_read_inode_common(dat, raw_inode);
 	if (err)
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7b2bc4173313..2466f8b8be95 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -30,6 +30,7 @@
  * @root: pointer on NILFS root object (mounted checkpoint)
  * @for_gc: inode for GC flag
  * @for_btnc: inode for B-tree node cache flag
+ * @for_shadow: inode for shadowed page cache flag
  */
 struct nilfs_iget_args {
 	u64 ino;
@@ -37,6 +38,7 @@ struct nilfs_iget_args {
 	struct nilfs_root *root;
 	bool for_gc;
 	bool for_btnc;
+	bool for_shadow;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -317,7 +319,7 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -536,6 +538,12 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 	} else if (args->for_btnc) {
 		return 0;
 	}
+	if (test_bit(NILFS_I_SHADOW, &ii->i_state)) {
+		if (!args->for_shadow)
+			return 0;
+	} else if (args->for_shadow) {
+		return 0;
+	}
 
 	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
 		return !args->for_gc;
@@ -557,6 +565,8 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
 	if (args->for_btnc)
 		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
+	if (args->for_shadow)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -565,7 +575,7 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -576,7 +586,7 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -608,7 +618,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 	struct inode *inode;
 	int err;
@@ -655,6 +665,7 @@ int nilfs_attach_btree_node_cache(struct inode *inode)
 	args.cno = ii->i_cno;
 	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
 	args.for_btnc = true;
+	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
 
 	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
 				  nilfs_iget_set, &args);
@@ -690,6 +701,50 @@ void nilfs_detach_btree_node_cache(struct inode *inode)
 	}
 }
 
+/**
+ * nilfs_iget_for_shadow - obtain inode for shadow mapping
+ * @inode: inode object that uses shadow mapping
+ *
+ * nilfs_iget_for_shadow() allocates a pair of inodes that holds page
+ * caches for shadow mapping.  The page cache for data pages is set up
+ * in one inode and the one for b-tree node pages is set up in the
+ * other inode, which is attached to the former inode.
+ *
+ * Return Value: On success, a pointer to the inode for data pages is
+ * returned. On errors, one of the following negative error code is returned
+ * in a pointer type.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+struct inode *nilfs_iget_for_shadow(struct inode *inode)
+{
+	struct nilfs_iget_args args = {
+		.ino = inode->i_ino, .root = NULL, .cno = 0, .for_gc = false,
+		.for_btnc = false, .for_shadow = true
+	};
+	struct inode *s_inode;
+	int err;
+
+	s_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+			       nilfs_iget_set, &args);
+	if (unlikely(!s_inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(s_inode->i_state & I_NEW))
+		return inode;
+
+	NILFS_I(s_inode)->i_flags = 0;
+	memset(NILFS_I(s_inode)->i_bmap, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(s_inode->i_mapping, GFP_NOFS);
+
+	err = nilfs_attach_btree_node_cache(s_inode);
+	if (unlikely(err)) {
+		iget_failed(s_inode);
+		return ERR_PTR(err);
+	}
+	unlock_new_inode(s_inode);
+	return s_inode;
+}
+
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index 21acd2d4b4d4..131b5add32ee 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -470,9 +470,18 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
 void nilfs_mdt_clear(struct inode *inode)
 {
 	struct nilfs_mdt_info *mdi = NILFS_MDT(inode);
+	struct nilfs_shadow_map *shadow = mdi->mi_shadow;
 
 	if (mdi->mi_palloc_cache)
 		nilfs_palloc_destroy_cache(inode);
+
+	if (shadow) {
+		struct inode *s_inode = shadow->inode;
+
+		shadow->inode = NULL;
+		iput(s_inode);
+		mdi->mi_shadow = NULL;
+	}
 }
 
 /**
@@ -506,12 +515,15 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
 			       struct nilfs_shadow_map *shadow)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
+	struct inode *s_inode;
 
 	INIT_LIST_HEAD(&shadow->frozen_buffers);
-	address_space_init_once(&shadow->frozen_data);
-	nilfs_mapping_init(&shadow->frozen_data, inode);
-	address_space_init_once(&shadow->frozen_btnodes);
-	nilfs_mapping_init(&shadow->frozen_btnodes, inode);
+
+	s_inode = nilfs_iget_for_shadow(inode);
+	if (IS_ERR(s_inode))
+		return PTR_ERR(s_inode);
+
+	shadow->inode = s_inode;
 	mi->mi_shadow = shadow;
 	return 0;
 }
@@ -525,13 +537,14 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_inode_info *ii = NILFS_I(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *s_inode = shadow->inode;
 	int ret;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_data, inode->i_mapping);
+	ret = nilfs_copy_dirty_pages(s_inode->i_mapping, inode->i_mapping);
 	if (ret)
 		goto out;
 
-	ret = nilfs_copy_dirty_pages(&shadow->frozen_btnodes,
+	ret = nilfs_copy_dirty_pages(NILFS_I(s_inode)->i_assoc_inode->i_mapping,
 				     ii->i_assoc_inode->i_mapping);
 	if (ret)
 		goto out;
@@ -548,7 +561,7 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -580,7 +593,7 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int n;
 
-	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
@@ -621,11 +634,11 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 		nilfs_palloc_clear_cache(inode);
 
 	nilfs_clear_dirty_pages(inode->i_mapping, true);
-	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
+	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
 	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
-			      &shadow->frozen_btnodes);
+			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
 
@@ -640,10 +653,11 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
 {
 	struct nilfs_mdt_info *mi = NILFS_MDT(inode);
 	struct nilfs_shadow_map *shadow = mi->mi_shadow;
+	struct inode *shadow_btnc_inode = NILFS_I(shadow->inode)->i_assoc_inode;
 
 	down_write(&mi->mi_sem);
 	nilfs_release_frozen_buffers(shadow);
-	truncate_inode_pages(&shadow->frozen_data, 0);
-	truncate_inode_pages(&shadow->frozen_btnodes, 0);
+	truncate_inode_pages(shadow->inode->i_mapping, 0);
+	truncate_inode_pages(shadow_btnc_inode->i_mapping, 0);
 	up_write(&mi->mi_sem);
 }
diff --git a/fs/nilfs2/mdt.h b/fs/nilfs2/mdt.h
index e77aea4bb921..9d8ac0d27c16 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -18,14 +18,12 @@
 /**
  * struct nilfs_shadow_map - shadow mapping of meta data file
  * @bmap_store: shadow copy of bmap state
- * @frozen_data: shadowed dirty data pages
- * @frozen_btnodes: shadowed dirty b-tree nodes' pages
+ * @inode: holder of page caches used in shadow mapping
  * @frozen_buffers: list of frozen buffers
  */
 struct nilfs_shadow_map {
 	struct nilfs_bmap_store bmap_store;
-	struct address_space frozen_data;
-	struct address_space frozen_btnodes;
+	struct inode *inode;
 	struct list_head frozen_buffers;
 };
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index 6c5148de84ff..7dcb77d38759 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -92,6 +92,7 @@ enum {
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
 	NILFS_I_BTNC,			/* inode for btree node cache */
+	NILFS_I_SHADOW,			/* inode for shadowed page cache */
 };
 
 /*
@@ -263,6 +264,7 @@ extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
 int nilfs_attach_btree_node_cache(struct inode *inode);
 void nilfs_detach_btree_node_cache(struct inode *inode);
+struct inode *nilfs_iget_for_shadow(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
-- 
2.35.1

