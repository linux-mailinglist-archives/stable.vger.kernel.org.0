Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910E65F2A62
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbiJCHgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiJCHel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60852090;
        Mon,  3 Oct 2022 00:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2CA1B80E7D;
        Mon,  3 Oct 2022 07:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2B9C433D6;
        Mon,  3 Oct 2022 07:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781699;
        bh=8ql047hcERYZagcrzm1q4mD/hxfz6MX8T3wzxFcrFP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXr1YDOwCCRqbpPFlya2bCWlhap1iG2cVdlD90nveoVg8I40VLQqg/eqD0ei13rQ4
         z/AMWs2Ft3+q/uIJh8LIkBf4IGXvQY4EnSR+5Zb2d3CK9R6kVLOjJNK77b6og1BVGF
         bGWIdoUuA0PvLujfuPvd/UpsSTkapuoEW9PJfm1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/52] btrfs: fix hang during unmount when stopping a space reclaim worker
Date:   Mon,  3 Oct 2022 09:11:14 +0200
Message-Id: <20221003070718.934923187@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070718.687440096@linuxfoundation.org>
References: <20221003070718.687440096@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a362bb864b8db4861977d00bd2c3222503ccc34b ]

Often when running generic/562 from fstests we can hang during unmount,
resulting in a trace like this:

  Sep 07 11:52:00 debian9 unknown: run fstests generic/562 at 2022-09-07 11:52:00
  Sep 07 11:55:32 debian9 kernel: INFO: task umount:49438 blocked for more than 120 seconds.
  Sep 07 11:55:32 debian9 kernel:       Not tainted 6.0.0-rc2-btrfs-next-122 #1
  Sep 07 11:55:32 debian9 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  Sep 07 11:55:32 debian9 kernel: task:umount          state:D stack:    0 pid:49438 ppid: 25683 flags:0x00004000
  Sep 07 11:55:32 debian9 kernel: Call Trace:
  Sep 07 11:55:32 debian9 kernel:  <TASK>
  Sep 07 11:55:32 debian9 kernel:  __schedule+0x3c8/0xec0
  Sep 07 11:55:32 debian9 kernel:  ? rcu_read_lock_sched_held+0x12/0x70
  Sep 07 11:55:32 debian9 kernel:  schedule+0x5d/0xf0
  Sep 07 11:55:32 debian9 kernel:  schedule_timeout+0xf1/0x130
  Sep 07 11:55:32 debian9 kernel:  ? lock_release+0x224/0x4a0
  Sep 07 11:55:32 debian9 kernel:  ? lock_acquired+0x1a0/0x420
  Sep 07 11:55:32 debian9 kernel:  ? trace_hardirqs_on+0x2c/0xd0
  Sep 07 11:55:32 debian9 kernel:  __wait_for_common+0xac/0x200
  Sep 07 11:55:32 debian9 kernel:  ? usleep_range_state+0xb0/0xb0
  Sep 07 11:55:32 debian9 kernel:  __flush_work+0x26d/0x530
  Sep 07 11:55:32 debian9 kernel:  ? flush_workqueue_prep_pwqs+0x140/0x140
  Sep 07 11:55:32 debian9 kernel:  ? trace_clock_local+0xc/0x30
  Sep 07 11:55:32 debian9 kernel:  __cancel_work_timer+0x11f/0x1b0
  Sep 07 11:55:32 debian9 kernel:  ? close_ctree+0x12b/0x5b3 [btrfs]
  Sep 07 11:55:32 debian9 kernel:  ? __trace_bputs+0x10b/0x170
  Sep 07 11:55:32 debian9 kernel:  close_ctree+0x152/0x5b3 [btrfs]
  Sep 07 11:55:32 debian9 kernel:  ? evict_inodes+0x166/0x1c0
  Sep 07 11:55:32 debian9 kernel:  generic_shutdown_super+0x71/0x120
  Sep 07 11:55:32 debian9 kernel:  kill_anon_super+0x14/0x30
  Sep 07 11:55:32 debian9 kernel:  btrfs_kill_super+0x12/0x20 [btrfs]
  Sep 07 11:55:32 debian9 kernel:  deactivate_locked_super+0x2e/0xa0
  Sep 07 11:55:32 debian9 kernel:  cleanup_mnt+0x100/0x160
  Sep 07 11:55:32 debian9 kernel:  task_work_run+0x59/0xa0
  Sep 07 11:55:32 debian9 kernel:  exit_to_user_mode_prepare+0x1a6/0x1b0
  Sep 07 11:55:32 debian9 kernel:  syscall_exit_to_user_mode+0x16/0x40
  Sep 07 11:55:32 debian9 kernel:  do_syscall_64+0x48/0x90
  Sep 07 11:55:32 debian9 kernel:  entry_SYSCALL_64_after_hwframe+0x63/0xcd
  Sep 07 11:55:32 debian9 kernel: RIP: 0033:0x7fcde59a57a7
  Sep 07 11:55:32 debian9 kernel: RSP: 002b:00007ffe914217c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
  Sep 07 11:55:32 debian9 kernel: RAX: 0000000000000000 RBX: 00007fcde5ae8264 RCX: 00007fcde59a57a7
  Sep 07 11:55:32 debian9 kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000055b57556cdd0
  Sep 07 11:55:32 debian9 kernel: RBP: 000055b57556cba0 R08: 0000000000000000 R09: 00007ffe91420570
  Sep 07 11:55:32 debian9 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  Sep 07 11:55:32 debian9 kernel: R13: 000055b57556cdd0 R14: 000055b57556ccb8 R15: 0000000000000000
  Sep 07 11:55:32 debian9 kernel:  </TASK>

What happens is the following:

1) The cleaner kthread tries to start a transaction to delete an unused
   block group, but the metadata reservation can not be satisfied right
   away, so a reservation ticket is created and it starts the async
   metadata reclaim task (fs_info->async_reclaim_work);

2) Writeback for all the filler inodes with an i_size of 2K starts
   (generic/562 creates a lot of 2K files with the goal of filling
   metadata space). We try to create an inline extent for them, but we
   fail when trying to insert the inline extent with -ENOSPC (at
   cow_file_range_inline()) - since this is not critical, we fallback
   to non-inline mode (back to cow_file_range()), reserve extents, create
   extent maps and create the ordered extents;

3) An unmount starts, enters close_ctree();

4) The async reclaim task is flushing stuff, entering the flush states one
   by one, until it reaches RUN_DELAYED_IPUTS. There it runs all current
   delayed iputs.

   After running the delayed iputs and before calling
   btrfs_wait_on_delayed_iputs(), one or more ordered extents complete,
   and btrfs_add_delayed_iput() is called for each one through
   btrfs_finish_ordered_io() -> btrfs_put_ordered_extent(). This results
   in bumping fs_info->nr_delayed_iputs from 0 to some positive value.

   So the async reclaim task blocks at btrfs_wait_on_delayed_iputs() waiting
   for fs_info->nr_delayed_iputs to become 0;

5) The current transaction is committed by the transaction kthread, we then
   start unpinning extents and end up calling btrfs_try_granting_tickets()
   through unpin_extent_range(), since we released some space.
   This results in satisfying the ticket created by the cleaner kthread at
   step 1, waking up the cleaner kthread;

6) At close_ctree() we ask the cleaner kthread to park;

7) The cleaner kthread starts the transaction, deletes the unused block
   group, and then calls kthread_should_park(), which returns true, so it
   parks. And at this point we have the delayed iputs added by the
   completion of the ordered extents still pending;

8) Then later at close_ctree(), when we call:

       cancel_work_sync(&fs_info->async_reclaim_work);

   We hang forever, since the cleaner was parked and no one else can run
   delayed iputs after that, while the reclaim task is waiting for the
   remaining delayed iputs to be completed.

Fix this by waiting for all ordered extents to complete and running the
delayed iputs before attempting to stop the async reclaim tasks. Note that
we can not wait for ordered extents with btrfs_wait_ordered_roots() (or
other similar functions) because that waits for the BTRFS_ORDERED_COMPLETE
flag to be set on an ordered extent, but the delayed iput is added after
that, when doing the final btrfs_put_ordered_extent(). So instead wait for
the work queues used for executing ordered extent completion to be empty,
which works because we do the final put on an ordered extent at
btrfs_finish_ordered_io() (while we are in the unmount context).

Fixes: d6fd0ae25c6495 ("Btrfs: fix missing delayed iputs on unmount")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2c7e50980a70..f2abd8bfd4a0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4105,6 +4105,31 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * After we parked the cleaner kthread, ordered extents may have
+	 * completed and created new delayed iputs. If one of the async reclaim
+	 * tasks is running and in the RUN_DELAYED_IPUTS flush state, then we
+	 * can hang forever trying to stop it, because if a delayed iput is
+	 * added after it ran btrfs_run_delayed_iputs() and before it called
+	 * btrfs_wait_on_delayed_iputs(), it will hang forever since there is
+	 * no one else to run iputs.
+	 *
+	 * So wait for all ongoing ordered extents to complete and then run
+	 * delayed iputs. This works because once we reach this point no one
+	 * can either create new ordered extents nor create delayed iputs
+	 * through some other means.
+	 *
+	 * Also note that btrfs_wait_ordered_roots() is not safe here, because
+	 * it waits for BTRFS_ORDERED_COMPLETE to be set on an ordered extent,
+	 * but the delayed iput for the respective inode is made only when doing
+	 * the final btrfs_put_ordered_extent() (which must happen at
+	 * btrfs_finish_ordered_io() when we are unmounting).
+	 */
+	btrfs_flush_workqueue(fs_info->endio_write_workers);
+	/* Ordered extents for free space inodes. */
+	btrfs_flush_workqueue(fs_info->endio_freespace_worker);
+	btrfs_run_delayed_iputs(fs_info);
+
 	cancel_work_sync(&fs_info->async_reclaim_work);
 	cancel_work_sync(&fs_info->async_data_reclaim_work);
 
-- 
2.35.1



