Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E82115C6C2
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgBMQDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgBMPYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:16 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A712524691;
        Thu, 13 Feb 2020 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607455;
        bh=fb+xDc7Z0c5llCUOasQGRPatoq2CprLiJ/WNxLVApfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=poXs+MKuRyrLizUtcZUm9tDnes1HsEkga97nEcIjffH4VP7QOmlqfiid8ztaFeiVr
         Te5A/z1ai9Q+vCicHmyBNrStXb1kXD8UuA+QFelyOIvBp3a01e501L/ztVLdvUsztu
         Hq5dwVPrdSsgaYRk9q6tB7+RnxvhpckvGpd6LS98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/116] Btrfs: fix race between adding and putting tree mod seq elements and nodes
Date:   Thu, 13 Feb 2020 07:20:29 -0800
Message-Id: <20200213151915.760487577@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7227ff4de55d931bbdc156c8ef0ce4f100c78a5b ]

There is a race between adding and removing elements to the tree mod log
list and rbtree that can lead to use-after-free problems.

Consider the following example that explains how/why the problems happens:

1) Task A has mod log element with sequence number 200. It currently is
   the only element in the mod log list;

2) Task A calls btrfs_put_tree_mod_seq() because it no longer needs to
   access the tree mod log. When it enters the function, it initializes
   'min_seq' to (u64)-1. Then it acquires the lock 'tree_mod_seq_lock'
   before checking if there are other elements in the mod seq list.
   Since the list it empty, 'min_seq' remains set to (u64)-1. Then it
   unlocks the lock 'tree_mod_seq_lock';

3) Before task A acquires the lock 'tree_mod_log_lock', task B adds
   itself to the mod seq list through btrfs_get_tree_mod_seq() and gets a
   sequence number of 201;

4) Some other task, name it task C, modifies a btree and because there
   elements in the mod seq list, it adds a tree mod elem to the tree
   mod log rbtree. That node added to the mod log rbtree is assigned
   a sequence number of 202;

5) Task B, which is doing fiemap and resolving indirect back references,
   calls btrfs get_old_root(), with 'time_seq' == 201, which in turn
   calls tree_mod_log_search() - the search returns the mod log node
   from the rbtree with sequence number 202, created by task C;

6) Task A now acquires the lock 'tree_mod_log_lock', starts iterating
   the mod log rbtree and finds the node with sequence number 202. Since
   202 is less than the previously computed 'min_seq', (u64)-1, it
   removes the node and frees it;

7) Task B still has a pointer to the node with sequence number 202, and
   it dereferences the pointer itself and through the call to
   __tree_mod_log_rewind(), resulting in a use-after-free problem.

This issue can be triggered sporadically with the test case generic/561
from fstests, and it happens more frequently with a higher number of
duperemove processes. When it happens to me, it either freezes the VM or
it produces a trace like the following before crashing:

  [ 1245.321140] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC PTI
  [ 1245.321200] CPU: 1 PID: 26997 Comm: pool Not tainted 5.5.0-rc6-btrfs-next-52 #1
  [ 1245.321235] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
  [ 1245.321287] RIP: 0010:rb_next+0x16/0x50
  [ 1245.321307] Code: ....
  [ 1245.321372] RSP: 0018:ffffa151c4d039b0 EFLAGS: 00010202
  [ 1245.321388] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8ae221363c80 RCX: 6b6b6b6b6b6b6b6b
  [ 1245.321409] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8ae221363c80
  [ 1245.321439] RBP: ffff8ae20fcc4688 R08: 0000000000000002 R09: 0000000000000000
  [ 1245.321475] R10: ffff8ae20b120910 R11: 00000000243f8bb1 R12: 0000000000000038
  [ 1245.321506] R13: ffff8ae221363c80 R14: 000000000000075f R15: ffff8ae223f762b8
  [ 1245.321539] FS:  00007fdee1ec7700(0000) GS:ffff8ae236c80000(0000) knlGS:0000000000000000
  [ 1245.321591] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 1245.321614] CR2: 00007fded4030c48 CR3: 000000021da16003 CR4: 00000000003606e0
  [ 1245.321642] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [ 1245.321668] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [ 1245.321706] Call Trace:
  [ 1245.321798]  __tree_mod_log_rewind+0xbf/0x280 [btrfs]
  [ 1245.321841]  btrfs_search_old_slot+0x105/0xd00 [btrfs]
  [ 1245.321877]  resolve_indirect_refs+0x1eb/0xc60 [btrfs]
  [ 1245.321912]  find_parent_nodes+0x3dc/0x11b0 [btrfs]
  [ 1245.321947]  btrfs_check_shared+0x115/0x1c0 [btrfs]
  [ 1245.321980]  ? extent_fiemap+0x59d/0x6d0 [btrfs]
  [ 1245.322029]  extent_fiemap+0x59d/0x6d0 [btrfs]
  [ 1245.322066]  do_vfs_ioctl+0x45a/0x750
  [ 1245.322081]  ksys_ioctl+0x70/0x80
  [ 1245.322092]  ? trace_hardirqs_off_thunk+0x1a/0x1c
  [ 1245.322113]  __x64_sys_ioctl+0x16/0x20
  [ 1245.322126]  do_syscall_64+0x5c/0x280
  [ 1245.322139]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [ 1245.322155] RIP: 0033:0x7fdee3942dd7
  [ 1245.322177] Code: ....
  [ 1245.322258] RSP: 002b:00007fdee1ec6c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  [ 1245.322294] RAX: ffffffffffffffda RBX: 00007fded40210d8 RCX: 00007fdee3942dd7
  [ 1245.322314] RDX: 00007fded40210d8 RSI: 00000000c020660b RDI: 0000000000000004
  [ 1245.322337] RBP: 0000562aa89e7510 R08: 0000000000000000 R09: 00007fdee1ec6d44
  [ 1245.322369] R10: 0000000000000073 R11: 0000000000000246 R12: 00007fdee1ec6d48
  [ 1245.322390] R13: 00007fdee1ec6d40 R14: 00007fded40210d0 R15: 00007fdee1ec6d50
  [ 1245.322423] Modules linked in: ....
  [ 1245.323443] ---[ end trace 01de1e9ec5dff3cd ]---

Fix this by ensuring that btrfs_put_tree_mod_seq() computes the minimum
sequence number and iterates the rbtree while holding the lock
'tree_mod_log_lock' in write mode. Also get rid of the 'tree_mod_seq_lock'
lock, since it is now redundant.

Fixes: bd989ba359f2ac ("Btrfs: add tree modification log functions")
Fixes: 097b8a7c9e48e2 ("Btrfs: join tree mod log code with the code holding back delayed refs")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c             | 8 ++------
 fs/btrfs/ctree.h             | 6 ++----
 fs/btrfs/delayed-ref.c       | 8 ++++----
 fs/btrfs/disk-io.c           | 1 -
 fs/btrfs/tests/btrfs-tests.c | 1 -
 5 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 5e552947666c9..b5ebb43b1824f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -351,12 +351,10 @@ u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
 			   struct seq_list *elem)
 {
 	write_lock(&fs_info->tree_mod_log_lock);
-	spin_lock(&fs_info->tree_mod_seq_lock);
 	if (!elem->seq) {
 		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
 		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
 	write_unlock(&fs_info->tree_mod_log_lock);
 
 	return elem->seq;
@@ -376,7 +374,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 	if (!seq_putting)
 		return;
 
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	write_lock(&fs_info->tree_mod_log_lock);
 	list_del(&elem->list);
 	elem->seq = 0;
 
@@ -387,19 +385,17 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
 				 * blocker with lower sequence number exists, we
 				 * cannot remove anything from the log
 				 */
-				spin_unlock(&fs_info->tree_mod_seq_lock);
+				write_unlock(&fs_info->tree_mod_log_lock);
 				return;
 			}
 			min_seq = cur_elem->seq;
 		}
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
 
 	/*
 	 * anything that's lower than the lowest existing (read: blocked)
 	 * sequence number can be removed from the tree.
 	 */
-	write_lock(&fs_info->tree_mod_log_lock);
 	tm_root = &fs_info->tree_mod_log;
 	for (node = rb_first(tm_root); node; node = next) {
 		next = rb_next(node);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a423c36bcd72b..2bc37d03d4075 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -851,14 +851,12 @@ struct btrfs_fs_info {
 	struct list_head delayed_iputs;
 	struct mutex cleaner_delayed_iput_mutex;
 
-	/* this protects tree_mod_seq_list */
-	spinlock_t tree_mod_seq_lock;
 	atomic64_t tree_mod_seq;
-	struct list_head tree_mod_seq_list;
 
-	/* this protects tree_mod_log */
+	/* this protects tree_mod_log and tree_mod_seq_list */
 	rwlock_t tree_mod_log_lock;
 	struct rb_root tree_mod_log;
+	struct list_head tree_mod_seq_list;
 
 	atomic_t nr_async_submits;
 	atomic_t async_submit_draining;
diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
index 74c17db752014..c1ca4ce11e69e 100644
--- a/fs/btrfs/delayed-ref.c
+++ b/fs/btrfs/delayed-ref.c
@@ -279,7 +279,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 	if (head->is_data)
 		return;
 
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	read_lock(&fs_info->tree_mod_log_lock);
 	if (!list_empty(&fs_info->tree_mod_seq_list)) {
 		struct seq_list *elem;
 
@@ -287,7 +287,7 @@ void btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
 					struct seq_list, list);
 		seq = elem->seq;
 	}
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	read_unlock(&fs_info->tree_mod_log_lock);
 
 	ref = list_first_entry(&head->ref_list, struct btrfs_delayed_ref_node,
 			       list);
@@ -315,7 +315,7 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 	struct seq_list *elem;
 	int ret = 0;
 
-	spin_lock(&fs_info->tree_mod_seq_lock);
+	read_lock(&fs_info->tree_mod_log_lock);
 	if (!list_empty(&fs_info->tree_mod_seq_list)) {
 		elem = list_first_entry(&fs_info->tree_mod_seq_list,
 					struct seq_list, list);
@@ -329,7 +329,7 @@ int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
 		}
 	}
 
-	spin_unlock(&fs_info->tree_mod_seq_lock);
+	read_unlock(&fs_info->tree_mod_log_lock);
 	return ret;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 439b5f5dc3274..d61e5497f6dca 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2519,7 +2519,6 @@ int open_ctree(struct super_block *sb,
 	spin_lock_init(&fs_info->delayed_iput_lock);
 	spin_lock_init(&fs_info->defrag_inodes_lock);
 	spin_lock_init(&fs_info->free_chunk_lock);
-	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->buffer_lock);
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index bf62ad919a95d..9edc2674b8a70 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -112,7 +112,6 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(void)
 	spin_lock_init(&fs_info->qgroup_op_lock);
 	spin_lock_init(&fs_info->super_lock);
 	spin_lock_init(&fs_info->fs_roots_radix_lock);
-	spin_lock_init(&fs_info->tree_mod_seq_lock);
 	mutex_init(&fs_info->qgroup_ioctl_lock);
 	mutex_init(&fs_info->qgroup_rescan_lock);
 	rwlock_init(&fs_info->tree_mod_log_lock);
-- 
2.20.1



