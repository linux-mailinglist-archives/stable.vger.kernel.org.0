Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E126617140B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 10:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgB0JUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 04:20:50 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36283 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728678AbgB0JUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 04:20:50 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4C4B3610;
        Thu, 27 Feb 2020 04:20:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 27 Feb 2020 04:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=X0Yaeo
        XCV5DenOPu6kz5Yl9dJ+PgVF8MZ7JMcXnQISI=; b=zfH0zIO3YoHTyBF+xWcqc4
        qwF20wR/XfyqOnrQjeKjnnA6cHT5g8PBLlOUucOdvFagn3Q+er/Q/00yA96d25ER
        8lKB0y1fXgP4ggzptU/B7/RLwJ0knL6coDgI6od292TVes5DXnaD0IKVa2TUCnUW
        uYRwkkeoz2Q1jGH+TDnvO4WAP6A63GP7WXV3AbjfoS41+QjZiNgWyVMfPs/fKOlV
        ssfdRH++ROnUEaulD/ZtyLHxsSK9XKdqXuaVZfRwYXHzJAFO6eEaSRDGt0DBQJXX
        Nzpj/OM2/9RwIv4OvlW+mzbVn4SnejcBfO4aNM2NhYm16juI+V2m7KwYgQNKrnKA
        ==
X-ME-Sender: <xms:8IlXXoTFF7VJdCGLPkWzlbz6ZhOCpHLvvx28a2D1Stq6B9N27xXsLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeigddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudejne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8IlXXs1Hn8RB0tcmhrb9fHHx2Z61WJlgsNYN6FMrWhWb0vyaziYdDQ>
    <xmx:8IlXXtjhGdMDNvtNS9cwrB4tSvzybRklcZoDZnwu8swclTGNLq9Kuw>
    <xmx:8IlXXibtG3CqDmweoXkDvLphVUPgmgIIryn4ygIoq2QTMLT2oN9I8A>
    <xmx:8IlXXlbD2RPuNXZA50milX1fT0WcJwydPh6uuezYWabpirmb7iJBkg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 884EF3060BD1;
        Thu, 27 Feb 2020 04:20:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] Btrfs: fix deadlock during fast fsync when logging prealloc" failed to apply to 4.9-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 27 Feb 2020 10:20:47 +0100
Message-ID: <15827952471035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a5ae50dea9111db63d30d700766dd5509602f7ad Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 20 Feb 2020 13:29:49 +0000
Subject: [PATCH] Btrfs: fix deadlock during fast fsync when logging prealloc
 extents beyond eof

While logging the prealloc extents of an inode during a fast fsync we call
btrfs_truncate_inode_items(), through btrfs_log_prealloc_extents(), while
holding a read lock on a leaf of the inode's root (not the log root, the
fs/subvol root), and then that function locks the file range in the inode's
iotree. This can lead to a deadlock when:

* the fsync is ranged

* the file has prealloc extents beyond eof

* writeback for a range different from the fsync range starts
  during the fsync

* the size of the file is not sector size aligned

Because when finishing an ordered extent we lock first a file range and
then try to COW the fs/subvol tree to insert an extent item.

The following diagram shows how the deadlock can happen.

           CPU 1                                        CPU 2

  btrfs_sync_file()
    --> for range [0, 1MiB)

    --> inode has a size of
        1MiB and has 1 prealloc
        extent beyond the
        i_size, starting at offset
        4MiB

    flushes all delalloc for the
    range [0MiB, 1MiB) and waits
    for the respective ordered
    extents to complete

                                              --> before task at CPU 1 locks the
                                                  inode, a write into file range
                                                  [1MiB, 2MiB + 1KiB) is made

                                              --> i_size is updated to 2MiB + 1KiB

                                              --> writeback is started for that
                                                  range, [1MiB, 2MiB + 4KiB)
                                                  --> end offset rounded up to
                                                      be sector size aligned

    btrfs_log_dentry_safe()
      btrfs_log_inode_parent()
        btrfs_log_inode()

          btrfs_log_changed_extents()
            btrfs_log_prealloc_extents()
              --> does a search on the
                  inode's root
              --> holds a read lock on
                  leaf X

                                              btrfs_finish_ordered_io()
                                                --> locks range [1MiB, 2MiB + 4KiB)
                                                    --> end offset rounded up
                                                        to be sector size aligned

                                                --> tries to cow leaf X, through
                                                    insert_reserved_file_extent()
                                                    --> already locked by the
                                                        task at CPU 1

              btrfs_truncate_inode_items()

                --> gets an i_size of
                    2MiB + 1KiB, which is
                    not sector size
                    aligned

                --> tries to lock file
                    range [2MiB, (u64)-1)
                    --> the start range
                        is rounded down
                        from 2MiB + 1K
                        to 2MiB to be sector
                        size aligned

                    --> but the subrange
                        [2MiB, 2MiB + 4KiB) is
                        already locked by
                        task at CPU 2 which
                        is waiting to get a
                        write lock on leaf X
                        for which we are
                        holding a read lock

                                *** deadlock ***

This results in a stack trace like the following, triggered by test case
generic/561 from fstests:

  [ 2779.973608] INFO: task kworker/u8:6:247 blocked for more than 120 seconds.
  [ 2779.979536]       Not tainted 5.6.0-rc2-btrfs-next-53 #1
  [ 2779.984503] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [ 2779.990136] kworker/u8:6    D    0   247      2 0x80004000
  [ 2779.990457] Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
  [ 2779.990466] Call Trace:
  [ 2779.990491]  ? __schedule+0x384/0xa30
  [ 2779.990521]  schedule+0x33/0xe0
  [ 2779.990616]  btrfs_tree_read_lock+0x19e/0x2e0 [btrfs]
  [ 2779.990632]  ? remove_wait_queue+0x60/0x60
  [ 2779.990730]  btrfs_read_lock_root_node+0x2f/0x40 [btrfs]
  [ 2779.990782]  btrfs_search_slot+0x510/0x1000 [btrfs]
  [ 2779.990869]  btrfs_lookup_file_extent+0x4a/0x70 [btrfs]
  [ 2779.990944]  __btrfs_drop_extents+0x161/0x1060 [btrfs]
  [ 2779.990987]  ? mark_held_locks+0x6d/0xc0
  [ 2779.990994]  ? __slab_alloc.isra.49+0x99/0x100
  [ 2779.991060]  ? insert_reserved_file_extent.constprop.19+0x64/0x300 [btrfs]
  [ 2779.991145]  insert_reserved_file_extent.constprop.19+0x97/0x300 [btrfs]
  [ 2779.991222]  ? start_transaction+0xdd/0x5c0 [btrfs]
  [ 2779.991291]  btrfs_finish_ordered_io+0x4f4/0x840 [btrfs]
  [ 2779.991405]  btrfs_work_helper+0xaa/0x720 [btrfs]
  [ 2779.991432]  process_one_work+0x26d/0x6a0
  [ 2779.991460]  worker_thread+0x4f/0x3e0
  [ 2779.991481]  ? process_one_work+0x6a0/0x6a0
  [ 2779.991489]  kthread+0x103/0x140
  [ 2779.991499]  ? kthread_create_worker_on_cpu+0x70/0x70
  [ 2779.991515]  ret_from_fork+0x3a/0x50
  (...)
  [ 2780.026211] INFO: task fsstress:17375 blocked for more than 120 seconds.
  [ 2780.027480]       Not tainted 5.6.0-rc2-btrfs-next-53 #1
  [ 2780.028482] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [ 2780.030035] fsstress        D    0 17375  17373 0x00004000
  [ 2780.030038] Call Trace:
  [ 2780.030044]  ? __schedule+0x384/0xa30
  [ 2780.030052]  schedule+0x33/0xe0
  [ 2780.030075]  lock_extent_bits+0x20c/0x320 [btrfs]
  [ 2780.030094]  ? btrfs_truncate_inode_items+0xf4/0x1150 [btrfs]
  [ 2780.030098]  ? rcu_read_lock_sched_held+0x59/0xa0
  [ 2780.030102]  ? remove_wait_queue+0x60/0x60
  [ 2780.030122]  btrfs_truncate_inode_items+0x133/0x1150 [btrfs]
  [ 2780.030151]  ? btrfs_set_path_blocking+0xb2/0x160 [btrfs]
  [ 2780.030165]  ? btrfs_search_slot+0x379/0x1000 [btrfs]
  [ 2780.030195]  btrfs_log_changed_extents.isra.8+0x841/0x93e [btrfs]
  [ 2780.030202]  ? do_raw_spin_unlock+0x49/0xc0
  [ 2780.030215]  ? btrfs_get_num_csums+0x10/0x10 [btrfs]
  [ 2780.030239]  btrfs_log_inode+0xf83/0x1124 [btrfs]
  [ 2780.030251]  ? __mutex_unlock_slowpath+0x45/0x2a0
  [ 2780.030275]  btrfs_log_inode_parent+0x2a0/0xe40 [btrfs]
  [ 2780.030282]  ? dget_parent+0xa1/0x370
  [ 2780.030309]  btrfs_log_dentry_safe+0x4a/0x70 [btrfs]
  [ 2780.030329]  btrfs_sync_file+0x3f3/0x490 [btrfs]
  [ 2780.030339]  do_fsync+0x38/0x60
  [ 2780.030343]  __x64_sys_fdatasync+0x13/0x20
  [ 2780.030345]  do_syscall_64+0x5c/0x280
  [ 2780.030348]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [ 2780.030356] RIP: 0033:0x7f2d80f6d5f0
  [ 2780.030361] Code: Bad RIP value.
  [ 2780.030362] RSP: 002b:00007ffdba3c8548 EFLAGS: 00000246 ORIG_RAX: 000000000000004b
  [ 2780.030364] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f2d80f6d5f0
  [ 2780.030365] RDX: 00007ffdba3c84b0 RSI: 00007ffdba3c84b0 RDI: 0000000000000003
  [ 2780.030367] RBP: 000000000000004a R08: 0000000000000001 R09: 00007ffdba3c855c
  [ 2780.030368] R10: 0000000000000078 R11: 0000000000000246 R12: 00000000000001f4
  [ 2780.030369] R13: 0000000051eb851f R14: 00007ffdba3c85f0 R15: 0000557a49220d90

So fix this by making btrfs_truncate_inode_items() not lock the range in
the inode's iotree when the target root is a log root, since it's not
needed to lock the range for log roots as the protection from the inode's
lock and log_mutex are all that's needed.

Fixes: 28553fa992cb28 ("Btrfs: fix race between shrinking truncate and fiemap")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f47ba652b31..1ccb3f8d528d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4103,8 +4103,9 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 	path->reada = READA_BACK;
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
-			 &cached_state);
+	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+				 &cached_state);
 
 	/*
 	 * We want to drop from the next block forward in case this new size is
@@ -4368,11 +4369,10 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		if (!ret && last_size > new_size)
 			last_size = new_size;
 		btrfs_ordered_update_i_size(inode, last_size, NULL);
+		unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start,
+				     (u64)-1, &cached_state);
 	}
 
-	unlock_extent_cached(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
-			     &cached_state);
-
 	btrfs_free_path(path);
 	return ret;
 }

