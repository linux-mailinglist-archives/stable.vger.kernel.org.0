Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D6455D4A5
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235815AbiF0LfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:35:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235791AbiF0LeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:34:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AF4C70;
        Mon, 27 Jun 2022 04:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1320A60920;
        Mon, 27 Jun 2022 11:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E18C341C7;
        Mon, 27 Jun 2022 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329482;
        bh=1BB1wOUQsQB6tpJdbtk784NHEMFwqPPjxahzx4rXdiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZtVooUrnjFxt47uMQMwqp2iDvC89CFcsKOE0lSgArMUA5U/uL3VfpqL5IHbFsZsZ
         Oo+ZNWjB2yEdrSvkO+pjn2jF9PxuKWfahdZOU+UCP05H/iM52zl4Jk6p9tyWk/nMJ9
         PJNobc5NhYShxIVtye1OUw9BssehC213UTyMRLks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 014/135] btrfs: fix hang during unmount when block group reclaim task is running
Date:   Mon, 27 Jun 2022 13:20:21 +0200
Message-Id: <20220627111938.572642668@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 31e70e527806c546a72262f2fc3d982ee23c42d3 upstream.

When we start an unmount, at close_ctree(), if we have the reclaim task
running and in the middle of a data block group relocation, we can trigger
a deadlock when stopping an async reclaim task, producing a trace like the
following:

[629724.498185] task:kworker/u16:7   state:D stack:    0 pid:681170 ppid:     2 flags:0x00004000
[629724.499760] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[629724.501267] Call Trace:
[629724.501759]  <TASK>
[629724.502174]  __schedule+0x3cb/0xed0
[629724.502842]  schedule+0x4e/0xb0
[629724.503447]  btrfs_wait_on_delayed_iputs+0x7c/0xc0 [btrfs]
[629724.504534]  ? prepare_to_wait_exclusive+0xc0/0xc0
[629724.505442]  flush_space+0x423/0x630 [btrfs]
[629724.506296]  ? rcu_read_unlock_trace_special+0x20/0x50
[629724.507259]  ? lock_release+0x220/0x4a0
[629724.507932]  ? btrfs_get_alloc_profile+0xb3/0x290 [btrfs]
[629724.508940]  ? do_raw_spin_unlock+0x4b/0xa0
[629724.509688]  btrfs_async_reclaim_metadata_space+0x139/0x320 [btrfs]
[629724.510922]  process_one_work+0x252/0x5a0
[629724.511694]  ? process_one_work+0x5a0/0x5a0
[629724.512508]  worker_thread+0x52/0x3b0
[629724.513220]  ? process_one_work+0x5a0/0x5a0
[629724.514021]  kthread+0xf2/0x120
[629724.514627]  ? kthread_complete_and_exit+0x20/0x20
[629724.515526]  ret_from_fork+0x22/0x30
[629724.516236]  </TASK>
[629724.516694] task:umount          state:D stack:    0 pid:719055 ppid:695412 flags:0x00004000
[629724.518269] Call Trace:
[629724.518746]  <TASK>
[629724.519160]  __schedule+0x3cb/0xed0
[629724.519835]  schedule+0x4e/0xb0
[629724.520467]  schedule_timeout+0xed/0x130
[629724.521221]  ? lock_release+0x220/0x4a0
[629724.521946]  ? lock_acquired+0x19c/0x420
[629724.522662]  ? trace_hardirqs_on+0x1b/0xe0
[629724.523411]  __wait_for_common+0xaf/0x1f0
[629724.524189]  ? usleep_range_state+0xb0/0xb0
[629724.524997]  __flush_work+0x26d/0x530
[629724.525698]  ? flush_workqueue_prep_pwqs+0x140/0x140
[629724.526580]  ? lock_acquire+0x1a0/0x310
[629724.527324]  __cancel_work_timer+0x137/0x1c0
[629724.528190]  close_ctree+0xfd/0x531 [btrfs]
[629724.529000]  ? evict_inodes+0x166/0x1c0
[629724.529510]  generic_shutdown_super+0x74/0x120
[629724.530103]  kill_anon_super+0x14/0x30
[629724.530611]  btrfs_kill_super+0x12/0x20 [btrfs]
[629724.531246]  deactivate_locked_super+0x31/0xa0
[629724.531817]  cleanup_mnt+0x147/0x1c0
[629724.532319]  task_work_run+0x5c/0xa0
[629724.532984]  exit_to_user_mode_prepare+0x1a6/0x1b0
[629724.533598]  syscall_exit_to_user_mode+0x16/0x40
[629724.534200]  do_syscall_64+0x48/0x90
[629724.534667]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[629724.535318] RIP: 0033:0x7fa2b90437a7
[629724.535804] RSP: 002b:00007ffe0b7e4458 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[629724.536912] RAX: 0000000000000000 RBX: 00007fa2b9182264 RCX: 00007fa2b90437a7
[629724.538156] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000555d6cf20dd0
[629724.539053] RBP: 0000555d6cf20ba0 R08: 0000000000000000 R09: 00007ffe0b7e3200
[629724.539956] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[629724.540883] R13: 0000555d6cf20dd0 R14: 0000555d6cf20cb0 R15: 0000000000000000
[629724.541796]  </TASK>

This happens because:

1) Before entering close_ctree() we have the async block group reclaim
   task running and relocating a data block group;

2) There's an async metadata (or data) space reclaim task running;

3) We enter close_ctree() and park the cleaner kthread;

4) The async space reclaim task is at flush_space() and runs all the
   existing delayed iputs;

5) Before the async space reclaim task calls
   btrfs_wait_on_delayed_iputs(), the block group reclaim task which is
   doing the data block group relocation, creates a delayed iput at
   replace_file_extents() (called when COWing leaves that have file extent
   items pointing to relocated data extents, during the merging phase
   of relocation roots);

6) The async reclaim space reclaim task blocks at
   btrfs_wait_on_delayed_iputs(), since we have a new delayed iput;

7) The task at close_ctree() then calls cancel_work_sync() to stop the
   async space reclaim task, but it blocks since that task is waiting for
   the delayed iput to be run;

8) The delayed iput is never run because the cleaner kthread is parked,
   and no one else runs delayed iputs, resulting in a hang.

So fix this by stopping the async block group reclaim task before we
park the cleaner kthread.

Fixes: 18bb8bbf13c183 ("btrfs: zoned: automatically reclaim zones")
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4360,6 +4360,17 @@ void __cold close_ctree(struct btrfs_fs_
 	int ret;
 
 	set_bit(BTRFS_FS_CLOSING_START, &fs_info->flags);
+
+	/*
+	 * We may have the reclaim task running and relocating a data block group,
+	 * in which case it may create delayed iputs. So stop it before we park
+	 * the cleaner kthread otherwise we can get new delayed iputs after
+	 * parking the cleaner, and that can make the async reclaim task to hang
+	 * if it's waiting for delayed iputs to complete, since the cleaner is
+	 * parked and can not run delayed iputs - this will make us hang when
+	 * trying to stop the async reclaim task.
+	 */
+	cancel_work_sync(&fs_info->reclaim_bgs_work);
 	/*
 	 * We don't want the cleaner to start new transactions, add more delayed
 	 * iputs, etc. while we're closing. We can't use kthread_stop() yet
@@ -4400,8 +4411,6 @@ void __cold close_ctree(struct btrfs_fs_
 	cancel_work_sync(&fs_info->async_data_reclaim_work);
 	cancel_work_sync(&fs_info->preempt_reclaim_work);
 
-	cancel_work_sync(&fs_info->reclaim_bgs_work);
-
 	/* Cancel or finish ongoing discard work */
 	btrfs_discard_cleanup(fs_info);
 


