Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104DB3787CC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhEJLSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236642AbhEJLIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B510619C5;
        Mon, 10 May 2021 11:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644571;
        bh=yg0G8d/4QXzFQuLzDOWe1U3JrO46IIbUmdJ6mEBbzZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vo3hOKSBTIzviEH3TdedMYzJ5X3/AbfkAXQvT7BTXVpLUZE/h2x6Y6WRq8lO+aS8k
         js9hqsOuL2qjRtwDQSAxcQj3L7kHvBa/ncF9fGZvE8DcP6Y4xZPQU87oKaR26ZCmWD
         1huqnQg2tjs3dhtc9ugZYEX/V5IbTPQmTnReYFUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 136/384] btrfs: fix exhaustion of the system chunk array due to concurrent allocations
Date:   Mon, 10 May 2021 12:18:45 +0200
Message-Id: <20210510102019.380147838@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit eafa4fd0ad06074da8be4e28ff93b4dca9ffa407 ]

When we are running out of space for updating the chunk tree, that is,
when we are low on available space in the system space info, if we have
many task concurrently allocating block groups, via fallocate for example,
many of them can end up all allocating new system chunks when only one is
needed. In extreme cases this can lead to exhaustion of the system chunk
array, which has a size limit of 2048 bytes, and results in a transaction
abort with errno EFBIG, producing a trace in dmesg like the following,
which was triggered on a PowerPC machine with a node/leaf size of 64K:

  [1359.518899] ------------[ cut here ]------------
  [1359.518980] BTRFS: Transaction aborted (error -27)
  [1359.519135] WARNING: CPU: 3 PID: 16463 at ../fs/btrfs/block-group.c:1968 btrfs_create_pending_block_groups+0x340/0x3c0 [btrfs]
  [1359.519152] Modules linked in: (...)
  [1359.519239] Supported: Yes, External
  [1359.519252] CPU: 3 PID: 16463 Comm: stress-ng Tainted: G               X    5.3.18-47-default #1 SLE15-SP3
  [1359.519274] NIP:  c008000000e36fe8 LR: c008000000e36fe4 CTR: 00000000006de8e8
  [1359.519293] REGS: c00000056890b700 TRAP: 0700   Tainted: G               X     (5.3.18-47-default)
  [1359.519317] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR: 48008222  XER: 00000007
  [1359.519356] CFAR: c00000000013e170 IRQMASK: 0
  [1359.519356] GPR00: c008000000e36fe4 c00000056890b990 c008000000e83200 0000000000000026
  [1359.519356] GPR04: 0000000000000000 0000000000000000 0000d52a3b027651 0000000000000007
  [1359.519356] GPR08: 0000000000000003 0000000000000001 0000000000000007 0000000000000000
  [1359.519356] GPR12: 0000000000008000 c00000063fe44600 000000001015e028 000000001015dfd0
  [1359.519356] GPR16: 000000000000404f 0000000000000001 0000000000010000 0000dd1e287affff
  [1359.519356] GPR20: 0000000000000001 c000000637c9a000 ffffffffffffffe5 0000000000000000
  [1359.519356] GPR24: 0000000000000004 0000000000000000 0000000000000100 ffffffffffffffc0
  [1359.519356] GPR28: c000000637c9a000 c000000630e09230 c000000630e091d8 c000000562188b08
  [1359.519561] NIP [c008000000e36fe8] btrfs_create_pending_block_groups+0x340/0x3c0 [btrfs]
  [1359.519613] LR [c008000000e36fe4] btrfs_create_pending_block_groups+0x33c/0x3c0 [btrfs]
  [1359.519626] Call Trace:
  [1359.519671] [c00000056890b990] [c008000000e36fe4] btrfs_create_pending_block_groups+0x33c/0x3c0 [btrfs] (unreliable)
  [1359.519729] [c00000056890ba90] [c008000000d68d44] __btrfs_end_transaction+0xbc/0x2f0 [btrfs]
  [1359.519782] [c00000056890bae0] [c008000000e309ac] btrfs_alloc_data_chunk_ondemand+0x154/0x610 [btrfs]
  [1359.519844] [c00000056890bba0] [c008000000d8a0fc] btrfs_fallocate+0xe4/0x10e0 [btrfs]
  [1359.519891] [c00000056890bd00] [c0000000004a23b4] vfs_fallocate+0x174/0x350
  [1359.519929] [c00000056890bd50] [c0000000004a3cf8] ksys_fallocate+0x68/0xf0
  [1359.519957] [c00000056890bda0] [c0000000004a3da8] sys_fallocate+0x28/0x40
  [1359.519988] [c00000056890bdc0] [c000000000038968] system_call_exception+0xe8/0x170
  [1359.520021] [c00000056890be20] [c00000000000cb70] system_call_common+0xf0/0x278
  [1359.520037] Instruction dump:
  [1359.520049] 7d0049ad 40c2fff4 7c0004ac 71490004 40820024 2f83fffb 419e0048 3c620000
  [1359.520082] e863bcb8 7ec4b378 48010d91 e8410018 <0fe00000> 3c820000 e884bcc8 7ec6b378
  [1359.520122] ---[ end trace d6c186e151022e20 ]---

The following steps explain how we can end up in this situation:

1) Task A is at check_system_chunk(), either because it is allocating a
   new data or metadata block group, at btrfs_chunk_alloc(), or because
   it is removing a block group or turning a block group RO. It does not
   matter why;

2) Task A sees that there is not enough free space in the system
   space_info object, that is 'left' is < 'thresh'. And at this point
   the system space_info has a value of 0 for its 'bytes_may_use'
   counter;

3) As a consequence task A calls btrfs_alloc_chunk() in order to allocate
   a new system block group (chunk) and then reserves 'thresh' bytes in
   the chunk block reserve with the call to btrfs_block_rsv_add(). This
   changes the chunk block reserve's 'reserved' and 'size' counters by an
   amount of 'thresh', and changes the 'bytes_may_use' counter of the
   system space_info object from 0 to 'thresh'.

   Also during its call to btrfs_alloc_chunk(), we end up increasing the
   value of the 'total_bytes' counter of the system space_info object by
   8MiB (the size of a system chunk stripe). This happens through the
   call chain:

   btrfs_alloc_chunk()
       create_chunk()
           btrfs_make_block_group()
               btrfs_update_space_info()

4) After it finishes the first phase of the block group allocation, at
   btrfs_chunk_alloc(), task A unlocks the chunk mutex;

5) At this point the new system block group was added to the transaction
   handle's list of new block groups, but its block group item, device
   items and chunk item were not yet inserted in the extent, device and
   chunk trees, respectively. That only happens later when we call
   btrfs_finish_chunk_alloc() through a call to
   btrfs_create_pending_block_groups();

   Note that only when we update the chunk tree, through the call to
   btrfs_finish_chunk_alloc(), we decrement the 'reserved' counter
   of the chunk block reserve as we COW/allocate extent buffers,
   through:

   btrfs_alloc_tree_block()
      btrfs_use_block_rsv()
         btrfs_block_rsv_use_bytes()

   And the system space_info's 'bytes_may_use' is decremented everytime
   we allocate an extent buffer for COW operations on the chunk tree,
   through:

   btrfs_alloc_tree_block()
      btrfs_reserve_extent()
         find_free_extent()
            btrfs_add_reserved_bytes()

   If we end up COWing less chunk btree nodes/leaves than expected, which
   is the typical case since the amount of space we reserve is always
   pessimistic to account for the worst possible case, we release the
   unused space through:

   btrfs_create_pending_block_groups()
      btrfs_trans_release_chunk_metadata()
         btrfs_block_rsv_release()
            block_rsv_release_bytes()
                btrfs_space_info_free_bytes_may_use()

   But before task A gets into btrfs_create_pending_block_groups()...

6) Many other tasks start allocating new block groups through fallocate,
   each one does the first phase of block group allocation in a
   serialized way, since btrfs_chunk_alloc() takes the chunk mutex
   before calling check_system_chunk() and btrfs_alloc_chunk().

   However before everyone enters the final phase of the block group
   allocation, that is, before calling btrfs_create_pending_block_groups(),
   new tasks keep coming to allocate new block groups and while at
   check_system_chunk(), the system space_info's 'bytes_may_use' keeps
   increasing each time a task reserves space in the chunk block reserve.
   This means that eventually some other task can end up not seeing enough
   free space in the system space_info and decide to allocate yet another
   system chunk.

   This may repeat several times if yet more new tasks keep allocating
   new block groups before task A, and all the other tasks, finish the
   creation of the pending block groups, which is when reserved space
   in excess is released. Eventually this can result in exhaustion of
   system chunk array in the superblock, with btrfs_add_system_chunk()
   returning EFBIG, resulting later in a transaction abort.

   Even when we don't reach the extreme case of exhausting the system
   array, most, if not all, unnecessarily created system block groups
   end up being unused since when finishing creation of the first
   pending system block group, the creation of the following ones end
   up not needing to COW nodes/leaves of the chunk tree, so we never
   allocate and deallocate from them, resulting in them never being
   added to the list of unused block groups - as a consequence they
   don't get deleted by the cleaner kthread - the only exceptions are
   if we unmount and mount the filesystem again, which adds any unused
   block groups to the list of unused block groups, if a scrub is
   run, which also adds unused block groups to the unused list, and
   under some circumstances when using a zoned filesystem or async
   discard, which may also add unused block groups to the unused list.

So fix this by:

*) Tracking the number of reserved bytes for the chunk tree per
   transaction, which is the sum of reserved chunk bytes by each
   transaction handle currently being used;

*) When there is not enough free space in the system space_info,
   if there are other transaction handles which reserved chunk space,
   wait for some of them to complete in order to have enough excess
   reserved space released, and then try again. Otherwise proceed with
   the creation of a new system chunk.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 58 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/transaction.c |  5 ++++
 fs/btrfs/transaction.h |  7 +++++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 744b99ddc28c..a7d9e147dee6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3269,6 +3269,7 @@ static u64 get_profile_num_devs(struct btrfs_fs_info *fs_info, u64 type)
  */
 void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 {
+	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
 	u64 left;
@@ -3283,6 +3284,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 	lockdep_assert_held(&fs_info->chunk_mutex);
 
 	info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
+again:
 	spin_lock(&info->lock);
 	left = info->total_bytes - btrfs_space_info_used(info, true);
 	spin_unlock(&info->lock);
@@ -3301,6 +3303,58 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 
 	if (left < thresh) {
 		u64 flags = btrfs_system_alloc_profile(fs_info);
+		u64 reserved = atomic64_read(&cur_trans->chunk_bytes_reserved);
+
+		/*
+		 * If there's not available space for the chunk tree (system
+		 * space) and there are other tasks that reserved space for
+		 * creating a new system block group, wait for them to complete
+		 * the creation of their system block group and release excess
+		 * reserved space. We do this because:
+		 *
+		 * *) We can end up allocating more system chunks than necessary
+		 *    when there are multiple tasks that are concurrently
+		 *    allocating block groups, which can lead to exhaustion of
+		 *    the system array in the superblock;
+		 *
+		 * *) If we allocate extra and unnecessary system block groups,
+		 *    despite being empty for a long time, and possibly forever,
+		 *    they end not being added to the list of unused block groups
+		 *    because that typically happens only when deallocating the
+		 *    last extent from a block group - which never happens since
+		 *    we never allocate from them in the first place. The few
+		 *    exceptions are when mounting a filesystem or running scrub,
+		 *    which add unused block groups to the list of unused block
+		 *    groups, to be deleted by the cleaner kthread.
+		 *    And even when they are added to the list of unused block
+		 *    groups, it can take a long time until they get deleted,
+		 *    since the cleaner kthread might be sleeping or busy with
+		 *    other work (deleting subvolumes, running delayed iputs,
+		 *    defrag scheduling, etc);
+		 *
+		 * This is rare in practice, but can happen when too many tasks
+		 * are allocating blocks groups in parallel (via fallocate())
+		 * and before the one that reserved space for a new system block
+		 * group finishes the block group creation and releases the space
+		 * reserved in excess (at btrfs_create_pending_block_groups()),
+		 * other tasks end up here and see free system space temporarily
+		 * not enough for updating the chunk tree.
+		 *
+		 * We unlock the chunk mutex before waiting for such tasks and
+		 * lock it again after the wait, otherwise we would deadlock.
+		 * It is safe to do so because allocating a system chunk is the
+		 * first thing done while allocating a new block group.
+		 */
+		if (reserved > trans->chunk_bytes_reserved) {
+			const u64 min_needed = reserved - thresh;
+
+			mutex_unlock(&fs_info->chunk_mutex);
+			wait_event(cur_trans->chunk_reserve_wait,
+			   atomic64_read(&cur_trans->chunk_bytes_reserved) <=
+			   min_needed);
+			mutex_lock(&fs_info->chunk_mutex);
+			goto again;
+		}
 
 		/*
 		 * Ignore failure to create system chunk. We might end up not
@@ -3315,8 +3369,10 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 		ret = btrfs_block_rsv_add(fs_info->chunk_root,
 					  &fs_info->chunk_block_rsv,
 					  thresh, BTRFS_RESERVE_NO_FLUSH);
-		if (!ret)
+		if (!ret) {
+			atomic64_add(thresh, &cur_trans->chunk_bytes_reserved);
 			trans->chunk_bytes_reserved += thresh;
+		}
 	}
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3f2c4ee3e762..d56d3e7ca324 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -260,6 +260,7 @@ static inline int extwriter_counter_read(struct btrfs_transaction *trans)
 void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_transaction *cur_trans = trans->transaction;
 
 	if (!trans->chunk_bytes_reserved)
 		return;
@@ -268,6 +269,8 @@ void btrfs_trans_release_chunk_metadata(struct btrfs_trans_handle *trans)
 
 	btrfs_block_rsv_release(fs_info, &fs_info->chunk_block_rsv,
 				trans->chunk_bytes_reserved, NULL);
+	atomic64_sub(trans->chunk_bytes_reserved, &cur_trans->chunk_bytes_reserved);
+	cond_wake_up(&cur_trans->chunk_reserve_wait);
 	trans->chunk_bytes_reserved = 0;
 }
 
@@ -383,6 +386,8 @@ loop:
 	spin_lock_init(&cur_trans->dropped_roots_lock);
 	INIT_LIST_HEAD(&cur_trans->releasing_ebs);
 	spin_lock_init(&cur_trans->releasing_ebs_lock);
+	atomic64_set(&cur_trans->chunk_bytes_reserved, 0);
+	init_waitqueue_head(&cur_trans->chunk_reserve_wait);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(fs_info, &cur_trans->dirty_pages,
 			IO_TREE_TRANS_DIRTY_PAGES, fs_info->btree_inode);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index dd7c3eea08ad..364cfbb4c5c5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -96,6 +96,13 @@ struct btrfs_transaction {
 
 	spinlock_t releasing_ebs_lock;
 	struct list_head releasing_ebs;
+
+	/*
+	 * The number of bytes currently reserved, by all transaction handles
+	 * attached to this transaction, for metadata extents of the chunk tree.
+	 */
+	atomic64_t chunk_bytes_reserved;
+	wait_queue_head_t chunk_reserve_wait;
 };
 
 #define __TRANS_FREEZABLE	(1U << 0)
-- 
2.30.2



