Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E72171D35
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389659AbgB0OSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389937AbgB0OSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ECB824690;
        Thu, 27 Feb 2020 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813133;
        bh=ppMQH/pYveAkoCYcW2YZk1hkbHpiaBc68PW8hHvy1Ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VuYGNaYABpEYkpYJNf9aX9EDXABlcpMps2PS9aDm7qEvEGd1aZTYE1JofgRPvwxvG
         qVvAWNKTtWKHEB03QgaN2ul6o8shUORcQjktVu7YkUCSfd8kWb6S5Z4vKcsz1ghK/R
         H9bdklHixhXj1UaYv8218CwW9NT0TkYc54VfX7JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.5 109/150] Btrfs: fix deadlock during fast fsync when logging prealloc extents beyond eof
Date:   Thu, 27 Feb 2020 14:37:26 +0100
Message-Id: <20200227132248.875439548@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit a5ae50dea9111db63d30d700766dd5509602f7ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4775,8 +4775,9 @@ int btrfs_truncate_inode_items(struct bt
 		return -ENOMEM;
 	path->reada = READA_BACK;
 
-	lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
-			 &cached_state);
+	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+		lock_extent_bits(&BTRFS_I(inode)->io_tree, lock_start, (u64)-1,
+				 &cached_state);
 
 	/*
 	 * We want to drop from the next block forward in case this new size is
@@ -5040,11 +5041,10 @@ out:
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


