Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C35FED9C
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiJNLuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 07:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJNLt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 07:49:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502DE157F6F
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:51 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 67so4657395pfz.12
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 04:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWe7drlhBB9QqmplBUshuZiNR8eglqzEc0xZxSFA+4g=;
        b=qTy+kluVr/4BnjLEauGbXj9dhXaQgWVNCVLZwHgkg3uxtK6sSsbFphukAi/XoQZebo
         FBVVkq1+R0WmyEiwv65wt66WFtVPa7mElgDtW/IXdFhlJRfyg2LQSBL3At6pEM+drzWG
         /k5d8WjZo9dLO5wqEde9o5BNOaw1HCKOBwHIcOxsNYrHY5PFYK9dr49zRl2FGJ9BvWlA
         33QuI6QKi6B6S/P6hw6U9udrJxLTncz1IHm0/esYwyQVJ7O1SfD1kwzcinqASxv//Qww
         w5ukbWO97l/9gvmXBRB1W/iBJKte2fOvgahkIeYvYGZgNKf5x+ISOOJgEidzo1FjOFtK
         Y/7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yWe7drlhBB9QqmplBUshuZiNR8eglqzEc0xZxSFA+4g=;
        b=YfvS18Bl+ck61Wz2ZwihtjPbAGOKTGtppbDY/4DkJe1aCitMNRHnXv5ON8suig0/iA
         pbJhHmsvoomYBKh99Fk8qKo47fsoheR+QKfFNJ799zKH8rqo9R5RdKn8kuKC2N26I8Ns
         NXiWzd8P34YrjjgQCGVzKFJq6GjU06NaBVtORMecvloXBEZ+WCm5efZfQ/4DfbvzScP+
         tU37YQvxs3RWxpwXZtPJBXuRBmY+qUpvDoNB77PZ1ukrzF10GTzr57XBDit8BPeSYFul
         /GQ2KbIQpvycBa4VIZB2Dh8S34qeSBG0ocXGfaM1tVSG5cOf0TQ0cNxPcRwjbG9ORT8e
         IG9A==
X-Gm-Message-State: ACrzQf2t8Ip4quQXUo+tj3pUwzRF/MkSq63j8x8vlilwKgBlQRKOywIx
        eqQfhnkHISmTEZ6oTHiTXJk5mFpmTEQ=
X-Google-Smtp-Source: AMsMyM47LTiUHZH4Namee3+iI96jrD+Qxu2p72jW0NzxN3rFl6XHm9JF8KDLkE88hSqs1Yb92txkeA==
X-Received: by 2002:a65:6bcb:0:b0:44c:3e11:a7ac with SMTP id e11-20020a656bcb000000b0044c3e11a7acmr4385785pgw.274.1665748113584;
        Fri, 14 Oct 2022 04:48:33 -0700 (PDT)
Received: from carrot.. (i58-94-204-181.s42.a014.ap.plala.or.jp. [58.94.204.181])
        by smtp.gmail.com with ESMTPSA id b30-20020a631b5e000000b0046270ad651bsm1260105pgm.94.2022.10.14.04.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 04:48:32 -0700 (PDT)
From:   Ryusuke Konishi <konishi.ryusuke@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 1/2] nilfs2: fix lockdep warnings in page operations for btree nodes
Date:   Fri, 14 Oct 2022 20:48:25 +0900
Message-Id: <20221014114826.21895-2-konishi.ryusuke@gmail.com>
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

commit e897be17a441fa637cd166fc3de1445131e57692 upstream.

Patch series "nilfs2 lockdep warning fixes".

The first two are to resolve the lockdep warning issue, and the last one
is the accompanying cleanup and low priority.

Based on your comment, this series solves the issue by separating inode
object as needed.  Since I was worried about the impact of the object
composition changes, I tested the series carefully not to cause
regressions especially for delicate functions such like disk space
reclamation and snapshots.

This patch (of 3):

If CONFIG_LOCKDEP is enabled, nilfs2 hits lockdep warnings at
inode_to_wb() during page/folio operations for btree nodes:

  WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 inode_to_wb include/linux/backing-dev.h:269 [inline]
  WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 folio_account_dirtied mm/page-writeback.c:2460 [inline]
  WARNING: CPU: 0 PID: 6575 at include/linux/backing-dev.h:269 __folio_mark_dirty+0xa7c/0xe30 mm/page-writeback.c:2509
  Modules linked in:
  ...
  RIP: 0010:inode_to_wb include/linux/backing-dev.h:269 [inline]
  RIP: 0010:folio_account_dirtied mm/page-writeback.c:2460 [inline]
  RIP: 0010:__folio_mark_dirty+0xa7c/0xe30 mm/page-writeback.c:2509
  ...
  Call Trace:
    __set_page_dirty include/linux/pagemap.h:834 [inline]
    mark_buffer_dirty+0x4e6/0x650 fs/buffer.c:1145
    nilfs_btree_propagate_p fs/nilfs2/btree.c:1889 [inline]
    nilfs_btree_propagate+0x4ae/0xea0 fs/nilfs2/btree.c:2085
    nilfs_bmap_propagate+0x73/0x170 fs/nilfs2/bmap.c:337
    nilfs_collect_dat_data+0x45/0xd0 fs/nilfs2/segment.c:625
    nilfs_segctor_apply_buffers+0x14a/0x470 fs/nilfs2/segment.c:1009
    nilfs_segctor_scan_file+0x47a/0x700 fs/nilfs2/segment.c:1048
    nilfs_segctor_collect_blocks fs/nilfs2/segment.c:1224 [inline]
    nilfs_segctor_collect fs/nilfs2/segment.c:1494 [inline]
    nilfs_segctor_do_construct+0x14f3/0x6c60 fs/nilfs2/segment.c:2036
    nilfs_segctor_construct+0x7a7/0xb30 fs/nilfs2/segment.c:2372
    nilfs_segctor_thread_construct fs/nilfs2/segment.c:2480 [inline]
    nilfs_segctor_thread+0x3c3/0xf90 fs/nilfs2/segment.c:2563
    kthread+0x405/0x4f0 kernel/kthread.c:327
    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

This is because nilfs2 uses two page caches for each inode and
inode->i_mapping never points to one of them, the btree node cache.

This causes inode_to_wb(inode) to refer to a different page cache than
the caller page/folio operations such like __folio_start_writeback(),
__folio_end_writeback(), or __folio_mark_dirty() acquired the lock.

This patch resolves the issue by allocating and using an additional
inode to hold the page cache of btree nodes.  The inode is attached
one-to-one to the traditional nilfs2 inode if it requires a block
mapping with b-tree.  This setup change is in memory only and does not
affect the disk format.

Link: https://lkml.kernel.org/r/1647867427-30498-1-git-send-email-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/1647867427-30498-2-git-send-email-konishi.ryusuke@gmail.com
Link: https://lore.kernel.org/r/YXrYvIo8YRnAOJCj@casper.infradead.org
Link: https://lore.kernel.org/r/9a20b33d-b38f-b4a2-4742-c1eb5b8e4d6c@redhat.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+0d5b462a6f07447991b3@syzkaller.appspotmail.com
Reported-by: syzbot+34ef28bb2aeb28724aa0@syzkaller.appspotmail.com
Reported-by: Hao Sun <sunhao.th@gmail.com>
Reported-by: David Hildenbrand <david@redhat.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/nilfs2/btnode.c  |  23 ++++++++--
 fs/nilfs2/btnode.h  |   1 +
 fs/nilfs2/btree.c   |  27 ++++++++----
 fs/nilfs2/gcinode.c |   7 +--
 fs/nilfs2/inode.c   | 104 ++++++++++++++++++++++++++++++++++++++------
 fs/nilfs2/mdt.c     |   7 +--
 fs/nilfs2/nilfs.h   |  14 +++---
 fs/nilfs2/page.c    |   7 ++-
 fs/nilfs2/segment.c |  11 +++--
 fs/nilfs2/super.c   |   5 +--
 10 files changed, 155 insertions(+), 51 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index c21e0b4454a6..abee814d2506 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -29,6 +29,23 @@
 #include "page.h"
 #include "btnode.h"
 
+
+/**
+ * nilfs_init_btnc_inode - initialize B-tree node cache inode
+ * @btnc_inode: inode to be initialized
+ *
+ * nilfs_init_btnc_inode() sets up an inode for B-tree node cache.
+ */
+void nilfs_init_btnc_inode(struct inode *btnc_inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(btnc_inode);
+
+	btnc_inode->i_mode = S_IFREG;
+	ii->i_flags = 0;
+	memset(&ii->i_bmap_data, 0, sizeof(struct nilfs_bmap));
+	mapping_set_gfp_mask(btnc_inode->i_mapping, GFP_NOFS);
+}
+
 void nilfs_btnode_cache_clear(struct address_space *btnc)
 {
 	invalidate_mapping_pages(btnc, 0, -1);
@@ -38,7 +55,7 @@ void nilfs_btnode_cache_clear(struct address_space *btnc)
 struct buffer_head *
 nilfs_btnode_create_block(struct address_space *btnc, __u64 blocknr)
 {
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct buffer_head *bh;
 
 	bh = nilfs_grab_buffer(inode, btnc, blocknr, BIT(BH_NILFS_Node));
@@ -66,7 +83,7 @@ int nilfs_btnode_submit_block(struct address_space *btnc, __u64 blocknr,
 			      struct buffer_head **pbh, sector_t *submit_ptr)
 {
 	struct buffer_head *bh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	struct page *page;
 	int err;
 
@@ -166,7 +183,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 				    struct nilfs_btnode_chkey_ctxt *ctxt)
 {
 	struct buffer_head *obh, *nbh;
-	struct inode *inode = NILFS_BTNC_I(btnc);
+	struct inode *inode = btnc->host;
 	__u64 oldkey = ctxt->oldkey, newkey = ctxt->newkey;
 	int err;
 
diff --git a/fs/nilfs2/btnode.h b/fs/nilfs2/btnode.h
index 4e8aaa1aeb65..1f78b637715d 100644
--- a/fs/nilfs2/btnode.h
+++ b/fs/nilfs2/btnode.h
@@ -39,6 +39,7 @@ struct nilfs_btnode_chkey_ctxt {
 	struct buffer_head *newbh;
 };
 
+void nilfs_init_btnc_inode(struct inode *btnc_inode);
 void nilfs_btnode_cache_clear(struct address_space *);
 struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
 					      __u64 blocknr);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index 06ffa135dfa6..6a58e6d6a24b 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -67,7 +67,8 @@ static void nilfs_btree_free_path(struct nilfs_btree_path *path)
 static int nilfs_btree_get_new_block(const struct nilfs_bmap *btree,
 				     __u64 ptr, struct buffer_head **bhp)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh;
 
 	bh = nilfs_btnode_create_block(btnc, ptr);
@@ -479,7 +480,8 @@ static int __nilfs_btree_get_block(const struct nilfs_bmap *btree, __u64 ptr,
 				   struct buffer_head **bhp,
 				   const struct nilfs_btree_readahead_info *ra)
 {
-	struct address_space *btnc = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btnc = btnc_inode->i_mapping;
 	struct buffer_head *bh, *ra_bh;
 	sector_t submit_ptr = 0;
 	int ret;
@@ -1751,6 +1753,10 @@ nilfs_btree_prepare_convert_and_insert(struct nilfs_bmap *btree, __u64 key,
 		dat = nilfs_bmap_get_dat(btree);
 	}
 
+	ret = nilfs_attach_btree_node_cache(&NILFS_BMAP_I(btree)->vfs_inode);
+	if (ret < 0)
+		return ret;
+
 	ret = nilfs_bmap_prepare_alloc_ptr(btree, dreq, dat);
 	if (ret < 0)
 		return ret;
@@ -1923,7 +1929,7 @@ static int nilfs_btree_prepare_update_v(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = path[level].bp_newreq.bpr_ptr;
 		path[level].bp_ctxt.bh = path[level].bp_bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0) {
 			nilfs_dat_abort_update(dat,
@@ -1949,7 +1955,7 @@ static void nilfs_btree_commit_update_v(struct nilfs_bmap *btree,
 
 	if (buffer_nilfs_node(path[level].bp_bh)) {
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		path[level].bp_bh = path[level].bp_ctxt.bh;
 	}
@@ -1968,7 +1974,7 @@ static void nilfs_btree_abort_update_v(struct nilfs_bmap *btree,
 			       &path[level].bp_newreq.bpr_req);
 	if (buffer_nilfs_node(path[level].bp_bh))
 		nilfs_btnode_abort_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 }
 
@@ -2144,7 +2150,8 @@ static void nilfs_btree_add_dirty_buffer(struct nilfs_bmap *btree,
 static void nilfs_btree_lookup_dirty_buffers(struct nilfs_bmap *btree,
 					     struct list_head *listp)
 {
-	struct address_space *btcache = &NILFS_BMAP_I(btree)->i_btnode_cache;
+	struct inode *btnc_inode = NILFS_BMAP_I(btree)->i_assoc_inode;
+	struct address_space *btcache = btnc_inode->i_mapping;
 	struct list_head lists[NILFS_BTREE_LEVEL_MAX];
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
@@ -2198,12 +2205,12 @@ static int nilfs_btree_assign_p(struct nilfs_bmap *btree,
 		path[level].bp_ctxt.newkey = blocknr;
 		path[level].bp_ctxt.bh = *bh;
 		ret = nilfs_btnode_prepare_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		if (ret < 0)
 			return ret;
 		nilfs_btnode_commit_change_key(
-			&NILFS_BMAP_I(btree)->i_btnode_cache,
+			NILFS_BMAP_I(btree)->i_assoc_inode->i_mapping,
 			&path[level].bp_ctxt);
 		*bh = path[level].bp_ctxt.bh;
 	}
@@ -2408,6 +2415,10 @@ int nilfs_btree_init(struct nilfs_bmap *bmap)
 
 	if (nilfs_btree_root_broken(nilfs_btree_get_root(bmap), bmap->b_inode))
 		ret = -EIO;
+	else
+		ret = nilfs_attach_btree_node_cache(
+			&NILFS_BMAP_I(bmap)->vfs_inode);
+
 	return ret;
 }
 
diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 853a831dcde0..1bbd0f50ce9d 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -135,9 +135,10 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
 {
+	struct inode *btnc_inode = NILFS_I(inode)->i_assoc_inode;
 	int ret;
 
-	ret = nilfs_btnode_submit_block(&NILFS_I(inode)->i_btnode_cache,
+	ret = nilfs_btnode_submit_block(btnc_inode->i_mapping,
 					vbn ? : pbn, pbn, REQ_OP_READ, 0,
 					out_bh, &pbn);
 	if (ret == -EEXIST) /* internal code (cache hit) */
@@ -179,7 +180,7 @@ int nilfs_init_gcinode(struct inode *inode)
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
 
-	return 0;
+	return nilfs_attach_btree_node_cache(inode);
 }
 
 /**
@@ -194,7 +195,7 @@ void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 		ii = list_first_entry(head, struct nilfs_inode_info, i_dirty);
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 694381082d49..c96c47ce7a14 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -37,12 +37,14 @@
  * @cno: checkpoint number
  * @root: pointer on NILFS root object (mounted checkpoint)
  * @for_gc: inode for GC flag
+ * @for_btnc: inode for B-tree node cache flag
  */
 struct nilfs_iget_args {
 	u64 ino;
 	__u64 cno;
 	struct nilfs_root *root;
-	int for_gc;
+	bool for_gc;
+	bool for_btnc;
 };
 
 static int nilfs_iget_test(struct inode *inode, void *opaque);
@@ -331,7 +333,8 @@ static int nilfs_insert_inode_locked(struct inode *inode,
 				     unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false
 	};
 
 	return insert_inode_locked4(inode, ino, nilfs_iget_test, &args);
@@ -545,6 +548,13 @@ static int nilfs_iget_test(struct inode *inode, void *opaque)
 		return 0;
 
 	ii = NILFS_I(inode);
+	if (test_bit(NILFS_I_BTNC, &ii->i_state)) {
+		if (!args->for_btnc)
+			return 0;
+	} else if (args->for_btnc) {
+		return 0;
+	}
+
 	if (!test_bit(NILFS_I_GCINODE, &ii->i_state))
 		return !args->for_gc;
 
@@ -556,15 +566,15 @@ static int nilfs_iget_set(struct inode *inode, void *opaque)
 	struct nilfs_iget_args *args = opaque;
 
 	inode->i_ino = args->ino;
-	if (args->for_gc) {
+	NILFS_I(inode)->i_cno = args->cno;
+	NILFS_I(inode)->i_root = args->root;
+	if (args->root && args->ino == NILFS_ROOT_INO)
+		nilfs_get_root(args->root);
+
+	if (args->for_gc)
 		NILFS_I(inode)->i_state = BIT(NILFS_I_GCINODE);
-		NILFS_I(inode)->i_cno = args->cno;
-		NILFS_I(inode)->i_root = NULL;
-	} else {
-		if (args->root && args->ino == NILFS_ROOT_INO)
-			nilfs_get_root(args->root);
-		NILFS_I(inode)->i_root = args->root;
-	}
+	if (args->for_btnc)
+		NILFS_I(inode)->i_state |= BIT(NILFS_I_BTNC);
 	return 0;
 }
 
@@ -572,7 +582,8 @@ struct inode *nilfs_ilookup(struct super_block *sb, struct nilfs_root *root,
 			    unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false
 	};
 
 	return ilookup5(sb, ino, nilfs_iget_test, &args);
@@ -582,7 +593,8 @@ struct inode *nilfs_iget_locked(struct super_block *sb, struct nilfs_root *root,
 				unsigned long ino)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = root, .cno = 0, .for_gc = 0
+		.ino = ino, .root = root, .cno = 0, .for_gc = false,
+		.for_btnc = false
 	};
 
 	return iget5_locked(sb, ino, nilfs_iget_test, nilfs_iget_set, &args);
@@ -613,7 +625,8 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 				__u64 cno)
 {
 	struct nilfs_iget_args args = {
-		.ino = ino, .root = NULL, .cno = cno, .for_gc = 1
+		.ino = ino, .root = NULL, .cno = cno, .for_gc = true,
+		.for_btnc = false
 	};
 	struct inode *inode;
 	int err;
@@ -633,6 +646,68 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
 	return inode;
 }
 
+/**
+ * nilfs_attach_btree_node_cache - attach a B-tree node cache to the inode
+ * @inode: inode object
+ *
+ * nilfs_attach_btree_node_cache() attaches a B-tree node cache to @inode,
+ * or does nothing if the inode already has it.  This function allocates
+ * an additional inode to maintain page cache of B-tree nodes one-on-one.
+ *
+ * Return Value: On success, 0 is returned. On errors, one of the following
+ * negative error code is returned.
+ *
+ * %-ENOMEM - Insufficient memory available.
+ */
+int nilfs_attach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode;
+	struct nilfs_iget_args args;
+
+	if (ii->i_assoc_inode)
+		return 0;
+
+	args.ino = inode->i_ino;
+	args.root = ii->i_root;
+	args.cno = ii->i_cno;
+	args.for_gc = test_bit(NILFS_I_GCINODE, &ii->i_state) != 0;
+	args.for_btnc = true;
+
+	btnc_inode = iget5_locked(inode->i_sb, inode->i_ino, nilfs_iget_test,
+				  nilfs_iget_set, &args);
+	if (unlikely(!btnc_inode))
+		return -ENOMEM;
+	if (btnc_inode->i_state & I_NEW) {
+		nilfs_init_btnc_inode(btnc_inode);
+		unlock_new_inode(btnc_inode);
+	}
+	NILFS_I(btnc_inode)->i_assoc_inode = inode;
+	NILFS_I(btnc_inode)->i_bmap = ii->i_bmap;
+	ii->i_assoc_inode = btnc_inode;
+
+	return 0;
+}
+
+/**
+ * nilfs_detach_btree_node_cache - detach the B-tree node cache from the inode
+ * @inode: inode object
+ *
+ * nilfs_detach_btree_node_cache() detaches the B-tree node cache and its
+ * holder inode bound to @inode, or does nothing if @inode doesn't have it.
+ */
+void nilfs_detach_btree_node_cache(struct inode *inode)
+{
+	struct nilfs_inode_info *ii = NILFS_I(inode);
+	struct inode *btnc_inode = ii->i_assoc_inode;
+
+	if (btnc_inode) {
+		NILFS_I(btnc_inode)->i_assoc_inode = NULL;
+		ii->i_assoc_inode = NULL;
+		iput(btnc_inode);
+	}
+}
+
 void nilfs_write_inode_common(struct inode *inode,
 			      struct nilfs_inode *raw_inode, int has_bmap)
 {
@@ -781,7 +856,8 @@ static void nilfs_clear_inode(struct inode *inode)
 	if (test_bit(NILFS_I_BMAP, &ii->i_state))
 		nilfs_bmap_clear(ii->i_bmap);
 
-	nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+	if (!test_bit(NILFS_I_BTNC, &ii->i_state))
+		nilfs_detach_btree_node_cache(inode);
 
 	if (ii->i_root && inode->i_ino == NILFS_ROOT_INO)
 		nilfs_put_root(ii->i_root);
diff --git a/fs/nilfs2/mdt.c b/fs/nilfs2/mdt.c
index c6bc1033e7d2..c1971a17adea 100644
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -540,7 +540,7 @@ int nilfs_mdt_save_to_shadow_map(struct inode *inode)
 		goto out;
 
 	ret = nilfs_copy_dirty_pages(&shadow->frozen_btnodes,
-				     &ii->i_btnode_cache);
+				     ii->i_assoc_inode->i_mapping);
 	if (ret)
 		goto out;
 
@@ -631,8 +631,9 @@ void nilfs_mdt_restore_from_shadow_map(struct inode *inode)
 	nilfs_clear_dirty_pages(inode->i_mapping, true);
 	nilfs_copy_back_pages(inode->i_mapping, &shadow->frozen_data);
 
-	nilfs_clear_dirty_pages(&ii->i_btnode_cache, true);
-	nilfs_copy_back_pages(&ii->i_btnode_cache, &shadow->frozen_btnodes);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
+			      &shadow->frozen_btnodes);
 
 	nilfs_bmap_restore(ii->i_bmap, &shadow->bmap_store);
 
diff --git a/fs/nilfs2/nilfs.h b/fs/nilfs2/nilfs.h
index a89704271428..e4112397a002 100644
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -37,7 +37,7 @@
  * @i_xattr: <TODO>
  * @i_dir_start_lookup: page index of last successful search
  * @i_cno: checkpoint number for GC inode
- * @i_btnode_cache: cached pages of b-tree nodes
+ * @i_assoc_inode: associated inode (B-tree node cache holder or back pointer)
  * @i_dirty: list for connecting dirty files
  * @xattr_sem: semaphore for extended attributes processing
  * @i_bh: buffer contains disk inode
@@ -52,7 +52,7 @@ struct nilfs_inode_info {
 	__u64 i_xattr;	/* sector_t ??? */
 	__u32 i_dir_start_lookup;
 	__u64 i_cno;		/* check point number for GC inode */
-	struct address_space i_btnode_cache;
+	struct inode *i_assoc_inode;
 	struct list_head i_dirty;	/* List for connecting dirty files */
 
 #ifdef CONFIG_NILFS_XATTR
@@ -84,13 +84,6 @@ NILFS_BMAP_I(const struct nilfs_bmap *bmap)
 	return container_of(bmap, struct nilfs_inode_info, i_bmap_data);
 }
 
-static inline struct inode *NILFS_BTNC_I(struct address_space *btnc)
-{
-	struct nilfs_inode_info *ii =
-		container_of(btnc, struct nilfs_inode_info, i_btnode_cache);
-	return &ii->vfs_inode;
-}
-
 /*
  * Dynamic state flags of NILFS on-memory inode (i_state)
  */
@@ -107,6 +100,7 @@ enum {
 	NILFS_I_INODE_SYNC,		/* dsync is not allowed for inode */
 	NILFS_I_BMAP,			/* has bmap and btnode_cache */
 	NILFS_I_GCINODE,		/* inode for GC, on memory only */
+	NILFS_I_BTNC,			/* inode for btree node cache */
 };
 
 /*
@@ -277,6 +271,8 @@ struct inode *nilfs_iget(struct super_block *sb, struct nilfs_root *root,
 			 unsigned long ino);
 extern struct inode *nilfs_iget_for_gc(struct super_block *sb,
 				       unsigned long ino, __u64 cno);
+int nilfs_attach_btree_node_cache(struct inode *inode);
+void nilfs_detach_btree_node_cache(struct inode *inode);
 extern void nilfs_update_inode(struct inode *, struct buffer_head *, int);
 extern void nilfs_truncate(struct inode *);
 extern void nilfs_evict_inode(struct inode *);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index 8616c46d33da..884c2452e60d 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -462,10 +462,9 @@ void nilfs_mapping_init(struct address_space *mapping, struct inode *inode)
 /*
  * NILFS2 needs clear_page_dirty() in the following two cases:
  *
- * 1) For B-tree node pages and data pages of the dat/gcdat, NILFS2 clears
- *    page dirty flags when it copies back pages from the shadow cache
- *    (gcdat->{i_mapping,i_btnode_cache}) to its original cache
- *    (dat->{i_mapping,i_btnode_cache}).
+ * 1) For B-tree node pages and data pages of DAT file, NILFS2 clears dirty
+ *    flag of pages when it copies back pages from shadow cache to the
+ *    original cache.
  *
  * 2) Some B-tree operations like insertion or deletion may dispose buffers
  *    in dirty state, and this needs to cancel the dirty state of their pages.
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 63077261cf64..e5a2b04c77ad 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -751,16 +751,19 @@ static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
 					    struct list_head *listp)
 {
 	struct nilfs_inode_info *ii = NILFS_I(inode);
-	struct address_space *mapping = &ii->i_btnode_cache;
+	struct inode *btnc_inode = ii->i_assoc_inode;
 	struct pagevec pvec;
 	struct buffer_head *bh, *head;
 	unsigned int i;
 	pgoff_t index = 0;
 
+	if (!btnc_inode)
+		return;
+
 	pagevec_init(&pvec, 0);
 
-	while (pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				  PAGEVEC_SIZE)) {
+	while (pagevec_lookup_tag(&pvec, btnc_inode->i_mapping, &index,
+				  PAGECACHE_TAG_DIRTY, PAGEVEC_SIZE)) {
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			bh = head = page_buffers(pvec.pages[i]);
 			do {
@@ -2429,7 +2432,7 @@ nilfs_remove_written_gcinodes(struct the_nilfs *nilfs, struct list_head *head)
 			continue;
 		list_del_init(&ii->i_dirty);
 		truncate_inode_pages(&ii->vfs_inode.i_data, 0);
-		nilfs_btnode_cache_clear(&ii->i_btnode_cache);
+		nilfs_btnode_cache_clear(ii->i_assoc_inode->i_mapping);
 		iput(&ii->vfs_inode);
 	}
 }
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 4fc018dfcfae..af7d0d5cce50 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -161,7 +161,8 @@ struct inode *nilfs_alloc_inode(struct super_block *sb)
 	ii->i_state = 0;
 	ii->i_cno = 0;
 	ii->vfs_inode.i_version = 1;
-	nilfs_mapping_init(&ii->i_btnode_cache, &ii->vfs_inode);
+	ii->i_assoc_inode = NULL;
+	ii->i_bmap = &ii->i_bmap_data;
 	return &ii->vfs_inode;
 }
 
@@ -1392,8 +1393,6 @@ static void nilfs_inode_init_once(void *obj)
 #ifdef CONFIG_NILFS_XATTR
 	init_rwsem(&ii->xattr_sem);
 #endif
-	address_space_init_once(&ii->i_btnode_cache);
-	ii->i_bmap = &ii->i_bmap_data;
 	inode_init_once(&ii->vfs_inode);
 }
 
-- 
2.31.1

