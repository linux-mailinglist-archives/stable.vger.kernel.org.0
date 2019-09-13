Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8192BB1F1A
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389194AbfIMNPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388589AbfIMNPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:15:53 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88DB208C0;
        Fri, 13 Sep 2019 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380551;
        bh=9I4NeQF5Jdb1En7+YP9CTZMrKhsKtyMNmyq+3h9EiUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4MgJXkgvfI1HNm3hO5MEVu/SpuhOWm/i0NWHQwBBvbYRBrF9lOjy1D5yFwYxZfLu
         7g0LE+B/YqXhDJwN1QWq8WYdxMCHOlgOCMa7QZFIvt4qurVSsgdYDM7IHmg+9U1fyU
         N4T6nj8zsUuTXOAcgH/HrolCIuLjF/W+DdqJXj5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/190] btrfs: scrub: fix circular locking dependency warning
Date:   Fri, 13 Sep 2019 14:05:56 +0100
Message-Id: <20190913130607.659331327@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1cec3f27168d7835ff3d23ab371cd548440131bb ]

This fixes a longstanding lockdep warning triggered by
fstests/btrfs/011.

Circular locking dependency check reports warning[1], that's because the
btrfs_scrub_dev() calls the stack #0 below with, the fs_info::scrub_lock
held. The test case leading to this warning:

  $ mkfs.btrfs -f /dev/sdb
  $ mount /dev/sdb /btrfs
  $ btrfs scrub start -B /btrfs

In fact we have fs_info::scrub_workers_refcnt to track if the init and destroy
of the scrub workers are needed. So once we have incremented and decremented
the fs_info::scrub_workers_refcnt value in the thread, its ok to drop the
scrub_lock, and then actually do the btrfs_destroy_workqueue() part. So this
patch drops the scrub_lock before calling btrfs_destroy_workqueue().

  [359.258534] ======================================================
  [359.260305] WARNING: possible circular locking dependency detected
  [359.261938] 5.0.0-rc6-default #461 Not tainted
  [359.263135] ------------------------------------------------------
  [359.264672] btrfs/20975 is trying to acquire lock:
  [359.265927] 00000000d4d32bea ((wq_completion)"%s-%s""btrfs", name){+.+.}, at: flush_workqueue+0x87/0x540
  [359.268416]
  [359.268416] but task is already holding lock:
  [359.270061] 0000000053ea26a6 (&fs_info->scrub_lock){+.+.}, at: btrfs_scrub_dev+0x322/0x590 [btrfs]
  [359.272418]
  [359.272418] which lock already depends on the new lock.
  [359.272418]
  [359.274692]
  [359.274692] the existing dependency chain (in reverse order) is:
  [359.276671]
  [359.276671] -> #3 (&fs_info->scrub_lock){+.+.}:
  [359.278187]        __mutex_lock+0x86/0x9c0
  [359.279086]        btrfs_scrub_pause+0x31/0x100 [btrfs]
  [359.280421]        btrfs_commit_transaction+0x1e4/0x9e0 [btrfs]
  [359.281931]        close_ctree+0x30b/0x350 [btrfs]
  [359.283208]        generic_shutdown_super+0x64/0x100
  [359.284516]        kill_anon_super+0x14/0x30
  [359.285658]        btrfs_kill_super+0x12/0xa0 [btrfs]
  [359.286964]        deactivate_locked_super+0x29/0x60
  [359.288242]        cleanup_mnt+0x3b/0x70
  [359.289310]        task_work_run+0x98/0xc0
  [359.290428]        exit_to_usermode_loop+0x83/0x90
  [359.291445]        do_syscall_64+0x15b/0x180
  [359.292598]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [359.294011]
  [359.294011] -> #2 (sb_internal#2){.+.+}:
  [359.295432]        __sb_start_write+0x113/0x1d0
  [359.296394]        start_transaction+0x369/0x500 [btrfs]
  [359.297471]        btrfs_finish_ordered_io+0x2aa/0x7c0 [btrfs]
  [359.298629]        normal_work_helper+0xcd/0x530 [btrfs]
  [359.299698]        process_one_work+0x246/0x610
  [359.300898]        worker_thread+0x3c/0x390
  [359.302020]        kthread+0x116/0x130
  [359.303053]        ret_from_fork+0x24/0x30
  [359.304152]
  [359.304152] -> #1 ((work_completion)(&work->normal_work)){+.+.}:
  [359.306100]        process_one_work+0x21f/0x610
  [359.307302]        worker_thread+0x3c/0x390
  [359.308465]        kthread+0x116/0x130
  [359.309357]        ret_from_fork+0x24/0x30
  [359.310229]
  [359.310229] -> #0 ((wq_completion)"%s-%s""btrfs", name){+.+.}:
  [359.311812]        lock_acquire+0x90/0x180
  [359.312929]        flush_workqueue+0xaa/0x540
  [359.313845]        drain_workqueue+0xa1/0x180
  [359.314761]        destroy_workqueue+0x17/0x240
  [359.315754]        btrfs_destroy_workqueue+0x57/0x200 [btrfs]
  [359.317245]        scrub_workers_put+0x2c/0x60 [btrfs]
  [359.318585]        btrfs_scrub_dev+0x336/0x590 [btrfs]
  [359.319944]        btrfs_dev_replace_by_ioctl.cold.19+0x179/0x1bb [btrfs]
  [359.321622]        btrfs_ioctl+0x28a4/0x2e40 [btrfs]
  [359.322908]        do_vfs_ioctl+0xa2/0x6d0
  [359.324021]        ksys_ioctl+0x3a/0x70
  [359.325066]        __x64_sys_ioctl+0x16/0x20
  [359.326236]        do_syscall_64+0x54/0x180
  [359.327379]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [359.328772]
  [359.328772] other info that might help us debug this:
  [359.328772]
  [359.330990] Chain exists of:
  [359.330990]   (wq_completion)"%s-%s""btrfs", name --> sb_internal#2 --> &fs_info->scrub_lock
  [359.330990]
  [359.334376]  Possible unsafe locking scenario:
  [359.334376]
  [359.336020]        CPU0                    CPU1
  [359.337070]        ----                    ----
  [359.337821]   lock(&fs_info->scrub_lock);
  [359.338506]                                lock(sb_internal#2);
  [359.339506]                                lock(&fs_info->scrub_lock);
  [359.341461]   lock((wq_completion)"%s-%s""btrfs", name);
  [359.342437]
  [359.342437]  *** DEADLOCK ***
  [359.342437]
  [359.343745] 1 lock held by btrfs/20975:
  [359.344788]  #0: 0000000053ea26a6 (&fs_info->scrub_lock){+.+.}, at: btrfs_scrub_dev+0x322/0x590 [btrfs]
  [359.346778]
  [359.346778] stack backtrace:
  [359.347897] CPU: 0 PID: 20975 Comm: btrfs Not tainted 5.0.0-rc6-default #461
  [359.348983] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.11.2-0-gf9626cc-prebuilt.qemu-project.org 04/01/2014
  [359.350501] Call Trace:
  [359.350931]  dump_stack+0x67/0x90
  [359.351676]  print_circular_bug.isra.37.cold.56+0x15c/0x195
  [359.353569]  check_prev_add.constprop.44+0x4f9/0x750
  [359.354849]  ? check_prev_add.constprop.44+0x286/0x750
  [359.356505]  __lock_acquire+0xb84/0xf10
  [359.357505]  lock_acquire+0x90/0x180
  [359.358271]  ? flush_workqueue+0x87/0x540
  [359.359098]  flush_workqueue+0xaa/0x540
  [359.359912]  ? flush_workqueue+0x87/0x540
  [359.360740]  ? drain_workqueue+0x1e/0x180
  [359.361565]  ? drain_workqueue+0xa1/0x180
  [359.362391]  drain_workqueue+0xa1/0x180
  [359.363193]  destroy_workqueue+0x17/0x240
  [359.364539]  btrfs_destroy_workqueue+0x57/0x200 [btrfs]
  [359.365673]  scrub_workers_put+0x2c/0x60 [btrfs]
  [359.366618]  btrfs_scrub_dev+0x336/0x590 [btrfs]
  [359.367594]  ? start_transaction+0xa1/0x500 [btrfs]
  [359.368679]  btrfs_dev_replace_by_ioctl.cold.19+0x179/0x1bb [btrfs]
  [359.369545]  btrfs_ioctl+0x28a4/0x2e40 [btrfs]
  [359.370186]  ? __lock_acquire+0x263/0xf10
  [359.370777]  ? kvm_clock_read+0x14/0x30
  [359.371392]  ? kvm_sched_clock_read+0x5/0x10
  [359.372248]  ? sched_clock+0x5/0x10
  [359.372786]  ? sched_clock_cpu+0xc/0xc0
  [359.373662]  ? do_vfs_ioctl+0xa2/0x6d0
  [359.374552]  do_vfs_ioctl+0xa2/0x6d0
  [359.375378]  ? do_sigaction+0xff/0x250
  [359.376233]  ksys_ioctl+0x3a/0x70
  [359.376954]  __x64_sys_ioctl+0x16/0x20
  [359.377772]  do_syscall_64+0x54/0x180
  [359.378841]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
  [359.380422] RIP: 0033:0x7f5429296a97

Backporting to older kernels: scrub_nocow_workers must be freed the same
way as the others.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
[ update changelog ]
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 56c4d2236484f..a08a4d6f540f9 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -3778,16 +3778,6 @@ fail_scrub_workers:
 	return -ENOMEM;
 }
 
-static noinline_for_stack void scrub_workers_put(struct btrfs_fs_info *fs_info)
-{
-	if (--fs_info->scrub_workers_refcnt == 0) {
-		btrfs_destroy_workqueue(fs_info->scrub_workers);
-		btrfs_destroy_workqueue(fs_info->scrub_wr_completion_workers);
-		btrfs_destroy_workqueue(fs_info->scrub_parity_workers);
-	}
-	WARN_ON(fs_info->scrub_workers_refcnt < 0);
-}
-
 int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 		    u64 end, struct btrfs_scrub_progress *progress,
 		    int readonly, int is_dev_replace)
@@ -3796,6 +3786,9 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	int ret;
 	struct btrfs_device *dev;
 	unsigned int nofs_flag;
+	struct btrfs_workqueue *scrub_workers = NULL;
+	struct btrfs_workqueue *scrub_wr_comp = NULL;
+	struct btrfs_workqueue *scrub_parity = NULL;
 
 	if (btrfs_fs_closing(fs_info))
 		return -EINVAL;
@@ -3935,9 +3928,16 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 
 	mutex_lock(&fs_info->scrub_lock);
 	dev->scrub_ctx = NULL;
-	scrub_workers_put(fs_info);
+	if (--fs_info->scrub_workers_refcnt == 0) {
+		scrub_workers = fs_info->scrub_workers;
+		scrub_wr_comp = fs_info->scrub_wr_completion_workers;
+		scrub_parity = fs_info->scrub_parity_workers;
+	}
 	mutex_unlock(&fs_info->scrub_lock);
 
+	btrfs_destroy_workqueue(scrub_workers);
+	btrfs_destroy_workqueue(scrub_wr_comp);
+	btrfs_destroy_workqueue(scrub_parity);
 	scrub_put_ctx(sctx);
 
 	return ret;
-- 
2.20.1



