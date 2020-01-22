Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7932E145619
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgAVNUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbgAVNUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:46 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C5B2051A;
        Wed, 22 Jan 2020 13:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699245;
        bh=9Ng/vSvnMqDS50odJ736Zy/oy6QAiwOCZatssuAezu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6lHy/7Z2xB78jVu1jGVT4S7t28cQb36rQlaG+dDvEg0P1CQr7BhDkJNTYzKW2Hmr
         thWS8Ab/3sBWkrE+bDA51zpa7D3qDqh4F3k1fY9zMyLjlSsIyxSDfvqjfG99/pgKDc
         t9judhEyJnzplnZWI73B/JKIsyjyinTd9fRitm70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 086/222] btrfs: relocation: fix reloc_root lifespan and access
Date:   Wed, 22 Jan 2020 10:27:52 +0100
Message-Id: <20200122092839.869369609@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 6282675e6708ec78518cc0e9ad1f1f73d7c5c53d upstream.

[BUG]
There are several different KASAN reports for balance + snapshot
workloads.  Involved call paths include:

   should_ignore_root+0x54/0xb0 [btrfs]
   build_backref_tree+0x11af/0x2280 [btrfs]
   relocate_tree_blocks+0x391/0xb80 [btrfs]
   relocate_block_group+0x3e5/0xa00 [btrfs]
   btrfs_relocate_block_group+0x240/0x4d0 [btrfs]
   btrfs_relocate_chunk+0x53/0xf0 [btrfs]
   btrfs_balance+0xc91/0x1840 [btrfs]
   btrfs_ioctl_balance+0x416/0x4e0 [btrfs]
   btrfs_ioctl+0x8af/0x3e60 [btrfs]
   do_vfs_ioctl+0x831/0xb10

   create_reloc_root+0x9f/0x460 [btrfs]
   btrfs_reloc_post_snapshot+0xff/0x6c0 [btrfs]
   create_pending_snapshot+0xa9b/0x15f0 [btrfs]
   create_pending_snapshots+0x111/0x140 [btrfs]
   btrfs_commit_transaction+0x7a6/0x1360 [btrfs]
   btrfs_mksubvol+0x915/0x960 [btrfs]
   btrfs_ioctl_snap_create_transid+0x1d5/0x1e0 [btrfs]
   btrfs_ioctl_snap_create_v2+0x1d3/0x270 [btrfs]
   btrfs_ioctl+0x241b/0x3e60 [btrfs]
   do_vfs_ioctl+0x831/0xb10

   btrfs_reloc_pre_snapshot+0x85/0xc0 [btrfs]
   create_pending_snapshot+0x209/0x15f0 [btrfs]
   create_pending_snapshots+0x111/0x140 [btrfs]
   btrfs_commit_transaction+0x7a6/0x1360 [btrfs]
   btrfs_mksubvol+0x915/0x960 [btrfs]
   btrfs_ioctl_snap_create_transid+0x1d5/0x1e0 [btrfs]
   btrfs_ioctl_snap_create_v2+0x1d3/0x270 [btrfs]
   btrfs_ioctl+0x241b/0x3e60 [btrfs]
   do_vfs_ioctl+0x831/0xb10

[CAUSE]
All these call sites are only relying on root->reloc_root, which can
undergo btrfs_drop_snapshot(), and since we don't have real refcount
based protection to reloc roots, we can reach already dropped reloc
root, triggering KASAN.

[FIX]
To avoid such access to unstable root->reloc_root, we should check
BTRFS_ROOT_DEAD_RELOC_TREE bit first.

This patch introduces wrappers that provide the correct way to check the
bit with memory barriers protection.

Most callers don't distinguish merged reloc tree and no reloc tree.  The
only exception is should_ignore_root(), as merged reloc tree can be
ignored, while no reloc tree shouldn't.

[CRITICAL SECTION ANALYSIS]
Although test_bit()/set_bit()/clear_bit() doesn't imply a barrier, the
DEAD_RELOC_TREE bit has extra help from transaction as a higher level
barrier, the lifespan of root::reloc_root and DEAD_RELOC_TREE bit are:

	NULL: reloc_root is NULL	PTR: reloc_root is not NULL
	0: DEAD_RELOC_ROOT bit not set	DEAD: DEAD_RELOC_ROOT bit set

	(NULL, 0)    Initial state		 __
	  |					 /\ Section A
        btrfs_init_reloc_root()			 \/
	  |				 	 __
	(PTR, 0)     reloc_root initialized      /\
          |					 |
	btrfs_update_reloc_root()		 |  Section B
          |					 |
	(PTR, DEAD)  reloc_root has been merged  \/
          |					 __
	=== btrfs_commit_transaction() ====================
	  |					 /\
	clean_dirty_subvols()			 |
	  |					 |  Section C
	(NULL, DEAD) reloc_root cleanup starts   \/
          |					 __
	btrfs_drop_snapshot()			 /\
	  |					 |  Section D
	(NULL, 0)    Back to initial state	 \/

Every have_reloc_root() or test_bit(DEAD_RELOC_ROOT) caller holds
transaction handle, so none of such caller can cross transaction boundary.

In Section A, every caller just found no DEAD bit, and grab reloc_root.

In the cross section A-B, caller may get no DEAD bit, but since reloc_root
is still completely valid thus accessing reloc_root is completely safe.

No test_bit() caller can cross the boundary of Section B and Section C.

In Section C, every caller found the DEAD bit, so no one will access
reloc_root.

In the cross section C-D, either caller gets the DEAD bit set, avoiding
access reloc_root no matter if it's safe or not.  Or caller get the DEAD
bit cleared, then access reloc_root, which is already NULL, nothing will
be wrong.

The memory write barriers are between the reloc_root updates and bit
set/clear, the pairing read side is before test_bit.

Reported-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ barriers ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |   51 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -517,6 +517,34 @@ static int update_backref_cache(struct b
 	return 1;
 }
 
+static bool reloc_root_is_dead(struct btrfs_root *root)
+{
+	/*
+	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
+	 * btrfs_update_reloc_root. We need to see the updated bit before
+	 * trying to access reloc_root
+	 */
+	smp_rmb();
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+		return true;
+	return false;
+}
+
+/*
+ * Check if this subvolume tree has valid reloc tree.
+ *
+ * Reloc tree after swap is considered dead, thus not considered as valid.
+ * This is enough for most callers, as they don't distinguish dead reloc root
+ * from no reloc root.  But should_ignore_root() below is a special case.
+ */
+static bool have_reloc_root(struct btrfs_root *root)
+{
+	if (reloc_root_is_dead(root))
+		return false;
+	if (!root->reloc_root)
+		return false;
+	return true;
+}
 
 static int should_ignore_root(struct btrfs_root *root)
 {
@@ -525,6 +553,10 @@ static int should_ignore_root(struct btr
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state))
 		return 0;
 
+	/* This root has been merged with its reloc tree, we can ignore it */
+	if (reloc_root_is_dead(root))
+		return 1;
+
 	reloc_root = root->reloc_root;
 	if (!reloc_root)
 		return 0;
@@ -1439,7 +1471,7 @@ int btrfs_init_reloc_root(struct btrfs_t
 	 * The subvolume has reloc tree but the swap is finished, no need to
 	 * create/update the dead reloc tree
 	 */
-	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+	if (reloc_root_is_dead(root))
 		return 0;
 
 	if (root->reloc_root) {
@@ -1478,8 +1510,7 @@ int btrfs_update_reloc_root(struct btrfs
 	struct btrfs_root_item *root_item;
 	int ret;
 
-	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state) ||
-	    !root->reloc_root)
+	if (!have_reloc_root(root))
 		goto out;
 
 	reloc_root = root->reloc_root;
@@ -1489,6 +1520,11 @@ int btrfs_update_reloc_root(struct btrfs
 	if (fs_info->reloc_ctl->merge_reloc_tree &&
 	    btrfs_root_refs(root_item) == 0) {
 		set_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
+		/*
+		 * Mark the tree as dead before we change reloc_root so
+		 * have_reloc_root will not touch it from now on.
+		 */
+		smp_wmb();
 		__del_reloc_root(reloc_root);
 	}
 
@@ -2202,6 +2238,11 @@ static int clean_dirty_subvols(struct re
 				if (ret2 < 0 && !ret)
 					ret = ret2;
 			}
+			/*
+			 * Need barrier to ensure clear_bit() only happens after
+			 * root->reloc_root = NULL. Pairs with have_reloc_root.
+			 */
+			smp_wmb();
 			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 			btrfs_put_fs_root(root);
 		} else {
@@ -4721,7 +4762,7 @@ void btrfs_reloc_pre_snapshot(struct btr
 	struct btrfs_root *root = pending->root;
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 
-	if (!root->reloc_root || !rc)
+	if (!rc || !have_reloc_root(root))
 		return;
 
 	if (!rc->merge_reloc_tree)
@@ -4755,7 +4796,7 @@ int btrfs_reloc_post_snapshot(struct btr
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 	int ret;
 
-	if (!root->reloc_root || !rc)
+	if (!rc || !have_reloc_root(root))
 		return 0;
 
 	rc = root->fs_info->reloc_ctl;


