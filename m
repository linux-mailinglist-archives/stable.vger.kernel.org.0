Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F2497384
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 18:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239206AbiAWRTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 12:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiAWRTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 12:19:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0FAC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 09:19:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A8F2B80DDE
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 17:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90129C340E2;
        Sun, 23 Jan 2022 17:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642958350;
        bh=BGiSzzQg7org2xM2D5s93UovoF1NKc3/5hoc3X26aw0=;
        h=Subject:To:Cc:From:Date:From;
        b=KcRi5EvSsjTEhjQWS6LYg/q7MB5mFLPMicQqJfYyLL+lFCxD2fXZP0wTVbPsjzpCm
         sqKq8xqp5vtzlLDblzyxFHj0uN9Eq7LVv7+Qt0zghJ5UAq/AsCuBU+ipvskyZKFdRC
         h7gO/ap3xYy3vIL0eUj6NFuLD+EpyPUuktPcszf0=
Subject: FAILED: patch "[PATCH] btrfs: fix deadlock between quota enable and other quota" failed to apply to 4.19-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, sunhao.th@gmail.com,
        wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 18:18:37 +0100
Message-ID: <1642958317194231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 232796df8c1437c41d308d161007f0715bac0a54 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 27 Oct 2021 18:30:25 +0100
Subject: [PATCH] btrfs: fix deadlock between quota enable and other quota
 operations

When enabling quotas, we attempt to commit a transaction while holding the
mutex fs_info->qgroup_ioctl_lock. This can result on a deadlock with other
quota operations such as:

- qgroup creation and deletion, ioctl BTRFS_IOC_QGROUP_CREATE;

- adding and removing qgroup relations, ioctl BTRFS_IOC_QGROUP_ASSIGN.

This is because these operations join a transaction and after that they
attempt to lock the mutex fs_info->qgroup_ioctl_lock. Acquiring that mutex
after joining or starting a transaction is a pattern followed everywhere
in qgroups, so the quota enablement operation is the one at fault here,
and should not commit a transaction while holding that mutex.

Fix this by making the transaction commit while not holding the mutex.
We are safe from two concurrent tasks trying to enable quotas because
we are serialized by the rw semaphore fs_info->subvol_sem at
btrfs_ioctl_quota_ctl(), which is the only call site for enabling
quotas.

When this deadlock happens, it produces a trace like the following:

  INFO: task syz-executor:25604 blocked for more than 143 seconds.
  Not tainted 5.15.0-rc6 #4
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:syz-executor state:D stack:24800 pid:25604 ppid: 24873 flags:0x00004004
  Call Trace:
  context_switch kernel/sched/core.c:4940 [inline]
  __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
  schedule+0xd3/0x270 kernel/sched/core.c:6366
  btrfs_commit_transaction+0x994/0x2e90 fs/btrfs/transaction.c:2201
  btrfs_quota_enable+0x95c/0x1790 fs/btrfs/qgroup.c:1120
  btrfs_ioctl_quota_ctl fs/btrfs/ioctl.c:4229 [inline]
  btrfs_ioctl+0x637e/0x7b70 fs/btrfs/ioctl.c:5010
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:874 [inline]
  __se_sys_ioctl fs/ioctl.c:860 [inline]
  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f86920b2c4d
  RSP: 002b:00007f868f61ac58 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007f86921d90a0 RCX: 00007f86920b2c4d
  RDX: 0000000020005e40 RSI: 00000000c0109428 RDI: 0000000000000008
  RBP: 00007f869212bd80 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 0000000000000246 R12: 00007f86921d90a0
  R13: 00007fff6d233e4f R14: 00007fff6d233ff0 R15: 00007f868f61adc0
  INFO: task syz-executor:25628 blocked for more than 143 seconds.
  Not tainted 5.15.0-rc6 #4
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:syz-executor state:D stack:29080 pid:25628 ppid: 24873 flags:0x00004004
  Call Trace:
  context_switch kernel/sched/core.c:4940 [inline]
  __schedule+0xcd9/0x2530 kernel/sched/core.c:6287
  schedule+0xd3/0x270 kernel/sched/core.c:6366
  schedule_preempt_disabled+0xf/0x20 kernel/sched/core.c:6425
  __mutex_lock_common kernel/locking/mutex.c:669 [inline]
  __mutex_lock+0xc96/0x1680 kernel/locking/mutex.c:729
  btrfs_remove_qgroup+0xb7/0x7d0 fs/btrfs/qgroup.c:1548
  btrfs_ioctl_qgroup_create fs/btrfs/ioctl.c:4333 [inline]
  btrfs_ioctl+0x683c/0x7b70 fs/btrfs/ioctl.c:5014
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:874 [inline]
  __se_sys_ioctl fs/ioctl.c:860 [inline]
  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: Hao Sun <sunhao.th@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CACkBjsZQF19bQ1C6=yetF3BvL10OSORpFUcWXTP6HErshDB4dQ@mail.gmail.com/
Fixes: 340f1aa27f36 ("btrfs: qgroups: Move transaction management inside btrfs_quota_enable/disable")
CC: stable@vger.kernel.org # 4.19
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 6c037f1252b7..071f7334f818 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -940,6 +940,14 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 	int ret = 0;
 	int slot;
 
+	/*
+	 * We need to have subvol_sem write locked, to prevent races between
+	 * concurrent tasks trying to enable quotas, because we will unlock
+	 * and relock qgroup_ioctl_lock before setting fs_info->quota_root
+	 * and before setting BTRFS_FS_QUOTA_ENABLED.
+	 */
+	lockdep_assert_held_write(&fs_info->subvol_sem);
+
 	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (fs_info->quota_root)
 		goto out;
@@ -1117,8 +1125,19 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info)
 		goto out_free_path;
 	}
 
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
+	/*
+	 * Commit the transaction while not holding qgroup_ioctl_lock, to avoid
+	 * a deadlock with tasks concurrently doing other qgroup operations, such
+	 * adding/removing qgroups or adding/deleting qgroup relations for example,
+	 * because all qgroup operations first start or join a transaction and then
+	 * lock the qgroup_ioctl_lock mutex.
+	 * We are safe from a concurrent task trying to enable quotas, by calling
+	 * this function, since we are serialized by fs_info->subvol_sem.
+	 */
 	ret = btrfs_commit_transaction(trans);
 	trans = NULL;
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	if (ret)
 		goto out_free_path;
 

