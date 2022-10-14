Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627605FED9B
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbiJNLuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiJNLt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:49:28 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E3123EA7
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id l4so4493969plb.8
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysyZqWFkPmX+gmxNU51mq61gKrfwdwSJ3ht8i+gst74=;
        b=VORQBBkCZP41JsTBK1fUleab98r/i0egXK+LjqtdCGdfKIFAAYuj1maswHyDbEO50F
         UpAtd9YRv9BMV81awfaQfBlkv9by6TI3C7mTAPgX0rWS8tpykb+m/LFf4uOWMJl1JCWM
         qKr0rBYqqcbKLAHTf3WsGczxvpplthJHhRmiVLvWcUUvpxU1cIhjTL+oGv3uM3dRC5Gh
         E4jz2X0e8CWPU1TEhuLX9EnDiVeGJ4Qp3b2NhHcf0lbl0nguuqpOGrGfHAVXfzcEsTmD
         niqd0r/o6vEheRim7oVDyXV2KeoYWmKpJWY3k7qI5b7UzPi0/I1ENB/1RuU9KyJlGqy8
         Sueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysyZqWFkPmX+gmxNU51mq61gKrfwdwSJ3ht8i+gst74=;
        b=Jh5IZN6UjeQ12XbLjR1kuryOpCk6eVjh0VxYwlJ8/NxQB9/7Xk+UJUiCezas1FgimB
         z7pFzPB0u/l2DQg0hMulxfQEBz2LhAdWMDEM3MH0m+s1nnBrRwRbCIyydFHFidtR2pOH
         kz9qexdX+aZaxm3fU6Fxmfgi8mEMCB8Fnj6b0BAdcWf7PKcVPHf+82vwRmiDjcCm6uei
         jpwd4gx5sVk7mzBZrhJYZGmA5PrQqrFix5TjVH7nTR/YkkF2lHAsPC9Agc5HFHHt6wqt
         AkJIcEN6JQBZ+x3Yny2fIIjIhX0q2ZL/Mi8i6RtiaWEcDhb26S/kc87kLEpJzjKYWVz9
         X0lw==
X-Gm-Message-State: ACrzQf2DD8WE7Gjf1s5bRixDrYCzEuE9sMKVABCIDvglm5PmlD3vJkl4
        wkQJQPO0Cj5JEQmJIw1q0sjxy5AXM7s=
X-Google-Smtp-Source: AMsMyM5jUTGi27SR95ShNpIXY2lWhqGEVX3s4R5yhTeBfI4ld2VbnVO239nF2UN0yPzpQ9heYtg7BA==
X-Received: by 2002:a17:902:e882:b0:183:4bdf:9298 with SMTP id w2-20020a170902e88200b001834bdf9298mr5111615plg.116.1665748115838;
        Fri, 14 Oct 2022 04:48:35 -0700 (PDT)
Received: from carrot.. (i58-94-204-181.s42.a014.ap.plala.or.jp. [58.94.204.181])
        by smtp.gmail.com with ESMTPSA id b30-20020a631b5e000000b0046270ad651bsm1260105pgm.94.2022.10.14.04.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 04:48:34 -0700 (PDT)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 2/2] nilfs2: fix lockdep warnings during disk space reclamation
Date:   Fri, 14 Oct 2022 20:48:26 +0900
Message-Id: <20221014114826.21895-3-konishi.ryusuke@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221014114826.21895-1-konishi.ryusuke@gmail.com>
References: <20221014114826.21895-1-konishi.ryusuke@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6e211930f79aa45d422009a5f2e5467d2369ffe5 upstream.

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
---
 fs/nilfs2/dat.c   |  4 ++-
 fs/nilfs2/inode.c | 63 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/nilfs2/mdt.c   | 38 +++++++++++++++++++---------
 fs/nilfs2/mdt.h   |  6 ++---
 fs/nilfs2/nilfs.h |  2 ++
 5 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index dffedb2f8817..524f13bc47b2 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -506,7 +506,9 @@ int nilfs_dat_read(struct super_block *sb, size_t entry_size,
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
index c96c47ce7a14..228e120885af 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -38,6 +38,7 @@
  * @root: pointer on NILFS root object (mounted checkpoint)
  * @for_gc: inode for GC flag
  * @for_btnc: inode for B-tree node cache flag
+ * @for_shadow: inode for shadowed page cache flag
  */
 struct nilfs_iget_args {
 	u64 ino;
@@ -45,6 +46,7 @@ struct nilfs_iget_args {
 	struct nilfs_root *root;
 	bool for_gc;
 	bool for_btnc;
+	bool for_shadow;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -334,7 +336,7 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -554,6 +556,12 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
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
@@ -575,6 +583,8 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
 	if (args->for_btnc)
 		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
+	if (args->for_shadow)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_SHADOW);
 	return 0;
 }
 
@@ -583,7 +593,7 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -594,7 +604,7 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = root, .cno = 0, .for_gc = false,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -626,7 +636,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 {
 	struct nilfs_iget_args args = {
 		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
-		.for_btnc = false
+		.for_btnc = false, .for_shadow = false
 	};
 	struct inode *inode;
 	int err;
@@ -673,6 +683,7 @@ int nilfs_attach_btree_node_cache(struct inode *inode)
 	args.cno = ii->i_cno;
 	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
 	args.for_btnc = true;
+	args.for_shadow = test_bit(NILFS_I_SHADOW, &ii->i_state) != 0;
 
 	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
 				  nilfs_iget_set, &args);
@@ -708,6 +719,50 @@ void nilfs_detach_btree_node_cache(struct inode *inode)
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
index c1971a17adea..52763f8a8836 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -478,9 +478,18 @@ int nilfs_mdt_init(struct inode *inode, gfp_t gfp_mask, size_t objsz)
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
@@ -514,12 +523,15 @@ int nilfs_mdt_setup_shadow_map(struct inode *inode,
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
@@ -533,13 +545,14 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
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
@@ -556,7 +569,7 @@ int nilfs_mdt_freeze_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int blkbits = inode->i_blkbits;
 
-	page = grab_cache_page(&shadow->frozen_data, bh->b_page->index);
+	page = grab_cache_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (!page)
 		return -ENOMEM;
 
@@ -588,7 +601,7 @@ nilfs_mdt_get_frozen_buffer(struct inode *inode, struct buffer_head *bh)
 	struct page *page;
 	int n;
 
-	page = find_lock_page(&shadow->frozen_data, bh->b_page->index);
+	page = find_lock_page(shadow->inode->i_mapping, bh->b_page->index);
 	if (page) {
 		if (page_has_buffers(page)) {
 			n = bh_offset(bh) >> inode->i_blkbits;
@@ -629,11 +642,11 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 		nilfs_palloc_clear_cache(inode);
 
 	nilfs_clear_dirty_pages(inode->i_mapping, true);
-	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
+	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
 	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
-			      &shadow->frozen_btnodes);
+			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
 
@@ -648,10 +661,11 @@ void nilfs_mdt_clear_shadow_map(struct inode *inode)
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
index 3f67f3932097..35ee0aeb9e27 100644
--- a/fs/nilfs2/mdt.h
+++ b/fs/nilfs2/mdt.h
@@ -27,14 +27,12 @@
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
index e4112397a002..f9798f14c199 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -101,6 +101,7 @@ enum {
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
 	NILFS_I_BTNC,			/* inode for btree node cache */
+	NILFS_I_SHADOW,			/* inode for shadowed page cache */
 };
 
 /*
@@ -273,6 +274,7 @@ extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
 int nilfs_attach_btree_node_cache(struct inode *inode);
 void nilfs_detach_btree_node_cache(struct inode *inode);
+struct inode *nilfs_iget_for_shadow(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
-- 
2.31.1

