Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4C8200EA1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391943AbgFSPJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:09:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391935AbgFSPJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA26221D94;
        Fri, 19 Jun 2020 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579377;
        bh=Rhg5e+wBEhn02Vp7DUNhY6BAIHE/FzWM6qIgipmPOrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zowmytZWgjgIIPMz58Vj06JZSrD0t4lzkw/024A4E1l9gYr42TkKoFaDFlKyOrQr+
         CKKoqpuAHmRjhXfx8QRwMpyOFoZ1R8Dnerq+2yXK0Q/obrAwc61kTFp24QaxXaGbkA
         7tXnuKk8GcOm6I7NTAUR5D7dRJKE9YyT0b9FV6w8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/261] md: dont flush workqueue unconditionally in md_open
Date:   Fri, 19 Jun 2020 16:32:03 +0200
Message-Id: <20200619141655.231430519@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit f6766ff6afff70e2aaf39e1511e16d471de7c3ae ]

We need to check mddev->del_work before flush workqueu since the purpose
of flush is to ensure the previous md is disappeared. Otherwise the similar
deadlock appeared if LOCKDEP is enabled, it is due to md_open holds the
bdev->bd_mutex before flush workqueue.

kernel: [  154.522645] ======================================================
kernel: [  154.522647] WARNING: possible circular locking dependency detected
kernel: [  154.522650] 5.6.0-rc7-lp151.27-default #25 Tainted: G           O
kernel: [  154.522651] ------------------------------------------------------
kernel: [  154.522653] mdadm/2482 is trying to acquire lock:
kernel: [  154.522655] ffff888078529128 ((wq_completion)md_misc){+.+.}, at: flush_workqueue+0x84/0x4b0
kernel: [  154.522673]
kernel: [  154.522673] but task is already holding lock:
kernel: [  154.522675] ffff88804efa9338 (&bdev->bd_mutex){+.+.}, at: __blkdev_get+0x79/0x590
kernel: [  154.522691]
kernel: [  154.522691] which lock already depends on the new lock.
kernel: [  154.522691]
kernel: [  154.522694]
kernel: [  154.522694] the existing dependency chain (in reverse order) is:
kernel: [  154.522696]
kernel: [  154.522696] -> #4 (&bdev->bd_mutex){+.+.}:
kernel: [  154.522704]        __mutex_lock+0x87/0x950
kernel: [  154.522706]        __blkdev_get+0x79/0x590
kernel: [  154.522708]        blkdev_get+0x65/0x140
kernel: [  154.522709]        blkdev_get_by_dev+0x2f/0x40
kernel: [  154.522716]        lock_rdev+0x3d/0x90 [md_mod]
kernel: [  154.522719]        md_import_device+0xd6/0x1b0 [md_mod]
kernel: [  154.522723]        new_dev_store+0x15e/0x210 [md_mod]
kernel: [  154.522728]        md_attr_store+0x7a/0xc0 [md_mod]
kernel: [  154.522732]        kernfs_fop_write+0x117/0x1b0
kernel: [  154.522735]        vfs_write+0xad/0x1a0
kernel: [  154.522737]        ksys_write+0xa4/0xe0
kernel: [  154.522745]        do_syscall_64+0x64/0x2b0
kernel: [  154.522748]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
kernel: [  154.522749]
kernel: [  154.522749] -> #3 (&mddev->reconfig_mutex){+.+.}:
kernel: [  154.522752]        __mutex_lock+0x87/0x950
kernel: [  154.522756]        new_dev_store+0xc9/0x210 [md_mod]
kernel: [  154.522759]        md_attr_store+0x7a/0xc0 [md_mod]
kernel: [  154.522761]        kernfs_fop_write+0x117/0x1b0
kernel: [  154.522763]        vfs_write+0xad/0x1a0
kernel: [  154.522765]        ksys_write+0xa4/0xe0
kernel: [  154.522767]        do_syscall_64+0x64/0x2b0
kernel: [  154.522769]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
kernel: [  154.522770]
kernel: [  154.522770] -> #2 (kn->count#253){++++}:
kernel: [  154.522775]        __kernfs_remove+0x253/0x2c0
kernel: [  154.522778]        kernfs_remove+0x1f/0x30
kernel: [  154.522780]        kobject_del+0x28/0x60
kernel: [  154.522783]        mddev_delayed_delete+0x24/0x30 [md_mod]
kernel: [  154.522786]        process_one_work+0x2a7/0x5f0
kernel: [  154.522788]        worker_thread+0x2d/0x3d0
kernel: [  154.522793]        kthread+0x117/0x130
kernel: [  154.522795]        ret_from_fork+0x3a/0x50
kernel: [  154.522796]
kernel: [  154.522796] -> #1 ((work_completion)(&mddev->del_work)){+.+.}:
kernel: [  154.522800]        process_one_work+0x27e/0x5f0
kernel: [  154.522802]        worker_thread+0x2d/0x3d0
kernel: [  154.522804]        kthread+0x117/0x130
kernel: [  154.522806]        ret_from_fork+0x3a/0x50
kernel: [  154.522807]
kernel: [  154.522807] -> #0 ((wq_completion)md_misc){+.+.}:
kernel: [  154.522813]        __lock_acquire+0x1392/0x1690
kernel: [  154.522816]        lock_acquire+0xb4/0x1a0
kernel: [  154.522818]        flush_workqueue+0xab/0x4b0
kernel: [  154.522821]        md_open+0xb6/0xc0 [md_mod]
kernel: [  154.522823]        __blkdev_get+0xea/0x590
kernel: [  154.522825]        blkdev_get+0x65/0x140
kernel: [  154.522828]        do_dentry_open+0x1d1/0x380
kernel: [  154.522831]        path_openat+0x567/0xcc0
kernel: [  154.522834]        do_filp_open+0x9b/0x110
kernel: [  154.522836]        do_sys_openat2+0x201/0x2a0
kernel: [  154.522838]        do_sys_open+0x57/0x80
kernel: [  154.522840]        do_syscall_64+0x64/0x2b0
kernel: [  154.522842]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
kernel: [  154.522844]
kernel: [  154.522844] other info that might help us debug this:
kernel: [  154.522844]
kernel: [  154.522846] Chain exists of:
kernel: [  154.522846]   (wq_completion)md_misc --> &mddev->reconfig_mutex --> &bdev->bd_mutex
kernel: [  154.522846]
kernel: [  154.522850]  Possible unsafe locking scenario:
kernel: [  154.522850]
kernel: [  154.522852]        CPU0                    CPU1
kernel: [  154.522853]        ----                    ----
kernel: [  154.522854]   lock(&bdev->bd_mutex);
kernel: [  154.522856]                                lock(&mddev->reconfig_mutex);
kernel: [  154.522858]                                lock(&bdev->bd_mutex);
kernel: [  154.522860]   lock((wq_completion)md_misc);
kernel: [  154.522861]
kernel: [  154.522861]  *** DEADLOCK ***
kernel: [  154.522861]
kernel: [  154.522864] 1 lock held by mdadm/2482:
kernel: [  154.522865]  #0: ffff88804efa9338 (&bdev->bd_mutex){+.+.}, at: __blkdev_get+0x79/0x590
kernel: [  154.522868]
kernel: [  154.522868] stack backtrace:
kernel: [  154.522873] CPU: 1 PID: 2482 Comm: mdadm Tainted: G           O      5.6.0-rc7-lp151.27-default #25
kernel: [  154.522875] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
kernel: [  154.522878] Call Trace:
kernel: [  154.522881]  dump_stack+0x8f/0xcb
kernel: [  154.522884]  check_noncircular+0x194/0x1b0
kernel: [  154.522888]  ? __lock_acquire+0x1392/0x1690
kernel: [  154.522890]  __lock_acquire+0x1392/0x1690
kernel: [  154.522893]  lock_acquire+0xb4/0x1a0
kernel: [  154.522895]  ? flush_workqueue+0x84/0x4b0
kernel: [  154.522898]  flush_workqueue+0xab/0x4b0
kernel: [  154.522900]  ? flush_workqueue+0x84/0x4b0
kernel: [  154.522905]  ? md_open+0xb6/0xc0 [md_mod]
kernel: [  154.522908]  md_open+0xb6/0xc0 [md_mod]
kernel: [  154.522910]  __blkdev_get+0xea/0x590
kernel: [  154.522912]  ? bd_acquire+0xc0/0xc0
kernel: [  154.522914]  blkdev_get+0x65/0x140
kernel: [  154.522916]  ? bd_acquire+0xc0/0xc0
kernel: [  154.522918]  do_dentry_open+0x1d1/0x380
kernel: [  154.522921]  path_openat+0x567/0xcc0
kernel: [  154.522923]  ? __lock_acquire+0x380/0x1690
kernel: [  154.522926]  do_filp_open+0x9b/0x110
kernel: [  154.522929]  ? __alloc_fd+0xe5/0x1f0
kernel: [  154.522935]  ? kmem_cache_alloc+0x28c/0x630
kernel: [  154.522939]  ? do_sys_openat2+0x201/0x2a0
kernel: [  154.522941]  do_sys_openat2+0x201/0x2a0
kernel: [  154.522944]  do_sys_open+0x57/0x80
kernel: [  154.522946]  do_syscall_64+0x64/0x2b0
kernel: [  154.522948]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
kernel: [  154.522951] RIP: 0033:0x7f98d279d9ae

And md_alloc also flushed the same workqueue, but the thing is different
here. Because all the paths call md_alloc don't hold bdev->bd_mutex, and
the flush is necessary to avoid race condition, so leave it as it is.

Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6b69a12ca2d8..5a378a453a2d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7607,7 +7607,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 		 */
 		mddev_put(mddev);
 		/* Wait until bdev->bd_disk is definitely gone */
-		flush_workqueue(md_misc_wq);
+		if (work_pending(&mddev->del_work))
+			flush_workqueue(md_misc_wq);
 		/* Then retry the open from the top */
 		return -ERESTARTSYS;
 	}
-- 
2.25.1



