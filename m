Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356792AB964
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgKINIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731734AbgKINIr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:08:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3462083B;
        Mon,  9 Nov 2020 13:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927326;
        bh=VxHwe7ui+wK5sHBVlWrGurUwJ9jlIZ2WzXkHFC1R5Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RGuCsisLH34sueb5PxgUkhnl7Pit9shImswExfEH3u6C6HcAHscDgdrTE9kbkpjws
         ocgvAkxLNBvyRJqYvvKR4p+GDMmuUByHL0G95WOHICgE/NmJsaHoqwu9KOmvmN2ynD
         5bRhXZAmiKH/tja4tc9EMqUENh0IsiEc62vJzs78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.19 21/71] btrfs: Dont submit any btree write bio if the fs has errors
Date:   Mon,  9 Nov 2020 13:55:15 +0100
Message-Id: <20201109125020.896825235@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
References: <20201109125019.906191744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit b3ff8f1d380e65dddd772542aa9bff6c86bf715a upstream.

[BUG]
There is a fuzzed image which could cause KASAN report at unmount time.

  BUG: KASAN: use-after-free in btrfs_queue_work+0x2c1/0x390
  Read of size 8 at addr ffff888067cf6848 by task umount/1922

  CPU: 0 PID: 1922 Comm: umount Tainted: G        W         5.0.21 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
  Call Trace:
   dump_stack+0x5b/0x8b
   print_address_description+0x70/0x280
   kasan_report+0x13a/0x19b
   btrfs_queue_work+0x2c1/0x390
   btrfs_wq_submit_bio+0x1cd/0x240
   btree_submit_bio_hook+0x18c/0x2a0
   submit_one_bio+0x1be/0x320
   flush_write_bio.isra.41+0x2c/0x70
   btree_write_cache_pages+0x3bb/0x7f0
   do_writepages+0x5c/0x130
   __writeback_single_inode+0xa3/0x9a0
   writeback_single_inode+0x23d/0x390
   write_inode_now+0x1b5/0x280
   iput+0x2ef/0x600
   close_ctree+0x341/0x750
   generic_shutdown_super+0x126/0x370
   kill_anon_super+0x31/0x50
   btrfs_kill_super+0x36/0x2b0
   deactivate_locked_super+0x80/0xc0
   deactivate_super+0x13c/0x150
   cleanup_mnt+0x9a/0x130
   task_work_run+0x11a/0x1b0
   exit_to_usermode_loop+0x107/0x130
   do_syscall_64+0x1e5/0x280
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

[CAUSE]
The fuzzed image has a completely screwd up extent tree:

  leaf 29421568 gen 8 total ptrs 6 free space 3587 owner EXTENT_TREE
  refs 2 lock (w:0 r:0 bw:0 br:0 sw:0 sr:0) lock_owner 0 current 5938
          item 0 key (12587008 168 4096) itemoff 3942 itemsize 53
                  extent refs 1 gen 9 flags 1
                  ref#0: extent data backref root 5 objectid 259 offset 0 count 1
          item 1 key (12591104 168 8192) itemoff 3889 itemsize 53
                  extent refs 1 gen 9 flags 1
                  ref#0: extent data backref root 5 objectid 271 offset 0 count 1
          item 2 key (12599296 168 4096) itemoff 3836 itemsize 53
                  extent refs 1 gen 9 flags 1
                  ref#0: extent data backref root 5 objectid 259 offset 4096 count 1
          item 3 key (29360128 169 0) itemoff 3803 itemsize 33
                  extent refs 1 gen 9 flags 2
                  ref#0: tree block backref root 5
          item 4 key (29368320 169 1) itemoff 3770 itemsize 33
                  extent refs 1 gen 9 flags 2
                  ref#0: tree block backref root 5
          item 5 key (29372416 169 0) itemoff 3737 itemsize 33
                  extent refs 1 gen 9 flags 2
                  ref#0: tree block backref root 5

Note that leaf 29421568 doesn't have its backref in the extent tree.
Thus extent allocator can re-allocate leaf 29421568 for other trees.

In short, the bug is caused by:

- Existing tree block gets allocated to log tree
  This got its generation bumped.

- Log tree balance cleaned dirty bit of offending tree block
  It will not be written back to disk, thus no WRITTEN flag.

- Original owner of the tree block gets COWed
  Since the tree block has higher transid, no WRITTEN flag, it's reused,
  and not traced by transaction::dirty_pages.

- Transaction aborted
  Tree blocks get cleaned according to transaction::dirty_pages. But the
  offending tree block is not recorded at all.

- Filesystem unmount
  All pages are assumed to be are clean, destroying all workqueue, then
  call iput(btree_inode).
  But offending tree block is still dirty, which triggers writeback, and
  causes use-after-free bug.

The detailed sequence looks like this:

- Initial status
  eb: 29421568, header=WRITTEN bflags_dirty=0, page_dirty=0, gen=8,
      not traced by any dirty extent_iot_tree.

- New tree block is allocated
  Since there is no backref for 29421568, it's re-allocated as new tree
  block.
  Keep in mind that tree block 29421568 is still referred by extent
  tree.

- Tree block 29421568 is filled for log tree
  eb: 29421568, header=0 bflags_dirty=1, page_dirty=1, gen=9 << (gen bumped)
      traced by btrfs_root::dirty_log_pages

- Some log tree operations
  Since the fs is using node size 4096, the log tree can easily go a
  level higher.

- Log tree needs balance
  Tree block 29421568 gets all its content pushed to right, thus now
  it is empty, and we don't need it.
  btrfs_clean_tree_block() from __push_leaf_right() get called.

  eb: 29421568, header=0 bflags_dirty=0, page_dirty=0, gen=9
      traced by btrfs_root::dirty_log_pages

- Log tree write back
  btree_write_cache_pages() goes through dirty pages ranges, but since
  page of tree block 29421568 gets cleaned already, it's not written
  back to disk. Thus it doesn't have WRITTEN bit set.
  But ranges in dirty_log_pages are cleared.

  eb: 29421568, header=0 bflags_dirty=0, page_dirty=0, gen=9
      not traced by any dirty extent_iot_tree.

- Extent tree update when committing transaction
  Since tree block 29421568 has transid equal to running trans, and has
  no WRITTEN bit, should_cow_block() will use it directly without adding
  it to btrfs_transaction::dirty_pages.

  eb: 29421568, header=0 bflags_dirty=1, page_dirty=1, gen=9
      not traced by any dirty extent_iot_tree.

  At this stage, we're doomed. We have a dirty eb not tracked by any
  extent io tree.

- Transaction gets aborted due to corrupted extent tree
  Btrfs cleans up dirty pages according to transaction::dirty_pages and
  btrfs_root::dirty_log_pages.
  But since tree block 29421568 is not tracked by neither of them, it's
  still dirty.

  eb: 29421568, header=0 bflags_dirty=1, page_dirty=1, gen=9
      not traced by any dirty extent_iot_tree.

- Filesystem unmount
  Since all cleanup is assumed to be done, all workqueus are destroyed.
  Then iput(btree_inode) is called, expecting no dirty pages.
  But tree 29421568 is still dirty, thus triggering writeback.
  Since all workqueues are already freed, we cause use-after-free.

This shows us that, log tree blocks + bad extent tree can cause wild
dirty pages.

[FIX]
To fix the problem, don't submit any btree write bio if the filesytem
has any error.  This is the last safe net, just in case other cleanup
haven't caught catch it.

Link: https://github.com/bobfuzzer/CVE/tree/master/CVE-2019-19377
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[bwh: Backported to 4.19: fs_info variable already exists in
 btree_write_cache_pages()]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3947,7 +3947,39 @@ retry:
 		end_write_bio(&epd, ret);
 		return ret;
 	}
-	ret = flush_write_bio(&epd);
+	/*
+	 * If something went wrong, don't allow any metadata write bio to be
+	 * submitted.
+	 *
+	 * This would prevent use-after-free if we had dirty pages not
+	 * cleaned up, which can still happen by fuzzed images.
+	 *
+	 * - Bad extent tree
+	 *   Allowing existing tree block to be allocated for other trees.
+	 *
+	 * - Log tree operations
+	 *   Exiting tree blocks get allocated to log tree, bumps its
+	 *   generation, then get cleaned in tree re-balance.
+	 *   Such tree block will not be written back, since it's clean,
+	 *   thus no WRITTEN flag set.
+	 *   And after log writes back, this tree block is not traced by
+	 *   any dirty extent_io_tree.
+	 *
+	 * - Offending tree block gets re-dirtied from its original owner
+	 *   Since it has bumped generation, no WRITTEN flag, it can be
+	 *   reused without COWing. This tree block will not be traced
+	 *   by btrfs_transaction::dirty_pages.
+	 *
+	 *   Now such dirty tree block will not be cleaned by any dirty
+	 *   extent io tree. Thus we don't want to submit such wild eb
+	 *   if the fs already has error.
+	 */
+	if (!test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state)) {
+		ret = flush_write_bio(&epd);
+	} else {
+		ret = -EUCLEAN;
+		end_write_bio(&epd, ret);
+	}
 	return ret;
 }
 


