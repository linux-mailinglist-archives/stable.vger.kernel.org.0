Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5AE2D9EF3
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438458AbfJPV7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438447AbfJPV7R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:17 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081B821D7E;
        Wed, 16 Oct 2019 21:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263155;
        bh=VPLspMVyZgt9tUG9t/mgCQW+d3z0ORSBrrbOkMYpPm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qzy5Gewhf+NpUe0+oTZSAnn+d8Z/qu7b3xWKnFuun3sVRC//3TSgd2/XLLxgPBAHU
         fiTJqPp/VO1+JpP4EAWcxoztMDCbp+eSeiTpAJgfUWfHbiiDH9kDbULB+85sZBEiyw
         VCY/m5aHEy5cyCRB47g2/11FClqcyX4R1dF/3zXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cebtenzzre <cebtenzzre@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 083/112] btrfs: relocation: fix use-after-free on dead relocation roots
Date:   Wed, 16 Oct 2019 14:51:15 -0700
Message-Id: <20191016214904.783465327@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 1fac4a54374f7ef385938f3c6cf7649c0fe4f6cd upstream.

[BUG]
One user reported a reproducible KASAN report about use-after-free:

  BTRFS info (device sdi1): balance: start -dvrange=1256811659264..1256811659265
  BTRFS info (device sdi1): relocating block group 1256811659264 flags data|raid0
  ==================================================================
  BUG: KASAN: use-after-free in btrfs_init_reloc_root+0x2cd/0x340 [btrfs]
  Write of size 8 at addr ffff88856f671710 by task kworker/u24:10/261579

  CPU: 2 PID: 261579 Comm: kworker/u24:10 Tainted: P           OE     5.2.11-arch1-1-kasan #4
  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X99 Extreme4, BIOS P3.80 04/06/2018
  Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
  Call Trace:
   dump_stack+0x7b/0xba
   print_address_description+0x6c/0x22e
   ? btrfs_init_reloc_root+0x2cd/0x340 [btrfs]
   __kasan_report.cold+0x1b/0x3b
   ? btrfs_init_reloc_root+0x2cd/0x340 [btrfs]
   kasan_report+0x12/0x17
   __asan_report_store8_noabort+0x17/0x20
   btrfs_init_reloc_root+0x2cd/0x340 [btrfs]
   record_root_in_trans+0x2a0/0x370 [btrfs]
   btrfs_record_root_in_trans+0xf4/0x140 [btrfs]
   start_transaction+0x1ab/0xe90 [btrfs]
   btrfs_join_transaction+0x1d/0x20 [btrfs]
   btrfs_finish_ordered_io+0x7bf/0x18a0 [btrfs]
   ? lock_repin_lock+0x400/0x400
   ? __kmem_cache_shutdown.cold+0x140/0x1ad
   ? btrfs_unlink_subvol+0x9b0/0x9b0 [btrfs]
   finish_ordered_fn+0x15/0x20 [btrfs]
   normal_work_helper+0x1bd/0xca0 [btrfs]
   ? process_one_work+0x819/0x1720
   ? kasan_check_read+0x11/0x20
   btrfs_endio_write_helper+0x12/0x20 [btrfs]
   process_one_work+0x8c9/0x1720
   ? pwq_dec_nr_in_flight+0x2f0/0x2f0
   ? worker_thread+0x1d9/0x1030
   worker_thread+0x98/0x1030
   kthread+0x2bb/0x3b0
   ? process_one_work+0x1720/0x1720
   ? kthread_park+0x120/0x120
   ret_from_fork+0x35/0x40

  Allocated by task 369692:
   __kasan_kmalloc.part.0+0x44/0xc0
   __kasan_kmalloc.constprop.0+0xba/0xc0
   kasan_kmalloc+0x9/0x10
   kmem_cache_alloc_trace+0x138/0x260
   btrfs_read_tree_root+0x92/0x360 [btrfs]
   btrfs_read_fs_root+0x10/0xb0 [btrfs]
   create_reloc_root+0x47d/0xa10 [btrfs]
   btrfs_init_reloc_root+0x1e2/0x340 [btrfs]
   record_root_in_trans+0x2a0/0x370 [btrfs]
   btrfs_record_root_in_trans+0xf4/0x140 [btrfs]
   start_transaction+0x1ab/0xe90 [btrfs]
   btrfs_start_transaction+0x1e/0x20 [btrfs]
   __btrfs_prealloc_file_range+0x1c2/0xa00 [btrfs]
   btrfs_prealloc_file_range+0x13/0x20 [btrfs]
   prealloc_file_extent_cluster+0x29f/0x570 [btrfs]
   relocate_file_extent_cluster+0x193/0xc30 [btrfs]
   relocate_data_extent+0x1f8/0x490 [btrfs]
   relocate_block_group+0x600/0x1060 [btrfs]
   btrfs_relocate_block_group+0x3a0/0xa00 [btrfs]
   btrfs_relocate_chunk+0x9e/0x180 [btrfs]
   btrfs_balance+0x14e4/0x2fc0 [btrfs]
   btrfs_ioctl_balance+0x47f/0x640 [btrfs]
   btrfs_ioctl+0x119d/0x8380 [btrfs]
   do_vfs_ioctl+0x9f5/0x1060
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x73/0xb0
   do_syscall_64+0xa5/0x370
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  Freed by task 369692:
   __kasan_slab_free+0x14f/0x210
   kasan_slab_free+0xe/0x10
   kfree+0xd8/0x270
   btrfs_drop_snapshot+0x154c/0x1eb0 [btrfs]
   clean_dirty_subvols+0x227/0x340 [btrfs]
   relocate_block_group+0x972/0x1060 [btrfs]
   btrfs_relocate_block_group+0x3a0/0xa00 [btrfs]
   btrfs_relocate_chunk+0x9e/0x180 [btrfs]
   btrfs_balance+0x14e4/0x2fc0 [btrfs]
   btrfs_ioctl_balance+0x47f/0x640 [btrfs]
   btrfs_ioctl+0x119d/0x8380 [btrfs]
   do_vfs_ioctl+0x9f5/0x1060
   ksys_ioctl+0x67/0x90
   __x64_sys_ioctl+0x73/0xb0
   do_syscall_64+0xa5/0x370
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

  The buggy address belongs to the object at ffff88856f671100
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 1552 bytes inside of
   4096-byte region [ffff88856f671100, ffff88856f672100)
  The buggy address belongs to the page:
  page:ffffea0015bd9c00 refcount:1 mapcount:0 mapping:ffff88864400e600 index:0x0 compound_mapcount: 0
  flags: 0x2ffff0000010200(slab|head)
  raw: 02ffff0000010200 dead000000000100 dead000000000200 ffff88864400e600
  raw: 0000000000000000 0000000000070007 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected

  Memory state around the buggy address:
   ffff88856f671600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff88856f671680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  >ffff88856f671700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                           ^
   ffff88856f671780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
   ffff88856f671800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ==================================================================
  BTRFS info (device sdi1): 1 enospc errors during balance
  BTRFS info (device sdi1): balance: ended with status: -28

[CAUSE]
The problem happens when finish_ordered_io() get called with balance
still running, while the reloc root of that subvolume is already dead.
(Tree is swap already done, but tree not yet deleted for possible qgroup
usage.)

That means root->reloc_root still exists, but that reloc_root can be
under btrfs_drop_snapshot(), thus we shouldn't access it.

The following race could cause the use-after-free problem:

                CPU1              |                CPU2
--------------------------------------------------------------------------
                                  | relocate_block_group()
                                  | |- unset_reloc_control(rc)
                                  | |- btrfs_commit_transaction()
btrfs_finish_ordered_io()         | |- clean_dirty_subvols()
|- btrfs_join_transaction()       |    |
   |- record_root_in_trans()      |    |
      |- btrfs_init_reloc_root()  |    |
         |- if (root->reloc_root) |    |
         |                        |    |- root->reloc_root = NULL
         |                        |    |- btrfs_drop_snapshot(reloc_root);
         |- reloc_root->last_trans|
                 = trans->transid |
	    ^^^^^^^^^^^^^^^^^^^^^^
            Use after free

[FIX]
Fix it by the following modifications:

- Test if the root has dead reloc tree before accessing root->reloc_root
  If the root has BTRFS_ROOT_DEAD_RELOC_TREE, then we don't need to
  create or update root->reloc_tree

- Clear the BTRFS_ROOT_DEAD_RELOC_TREE flag until we have fully dropped
  reloc tree
  To co-operate with above modification, so as long as
  BTRFS_ROOT_DEAD_RELOC_TREE is still set, we won't try to re-create
  reloc tree at record_root_in_trans().

Reported-by: Cebtenzzre <cebtenzzre@gmail.com>
Fixes: d2311e698578 ("btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots")
CC: stable@vger.kernel.org # 5.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/relocation.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1434,6 +1434,13 @@ int btrfs_init_reloc_root(struct btrfs_t
 	int clear_rsv = 0;
 	int ret;
 
+	/*
+	 * The subvolume has reloc tree but the swap is finished, no need to
+	 * create/update the dead reloc tree
+	 */
+	if (test_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state))
+		return 0;
+
 	if (root->reloc_root) {
 		reloc_root = root->reloc_root;
 		reloc_root->last_trans = trans->transid;
@@ -2186,7 +2193,6 @@ static int clean_dirty_subvols(struct re
 			/* Merged subvolume, cleanup its reloc root */
 			struct btrfs_root *reloc_root = root->reloc_root;
 
-			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 			list_del_init(&root->reloc_dirty_list);
 			root->reloc_root = NULL;
 			if (reloc_root) {
@@ -2195,6 +2201,7 @@ static int clean_dirty_subvols(struct re
 				if (ret2 < 0 && !ret)
 					ret = ret2;
 			}
+			clear_bit(BTRFS_ROOT_DEAD_RELOC_TREE, &root->state);
 			btrfs_put_fs_root(root);
 		} else {
 			/* Orphan reloc tree, just clean it up */


