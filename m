Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0D99A77
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390600AbfHVRI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:08:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390595AbfHVRI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:58 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B4072341F;
        Thu, 22 Aug 2019 17:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493737;
        bh=FsU2bOnczHjVUYUWGONuiGSha5N7bJ30nzPRVEw0Mus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZP/5ZzAdA3dthsuN4ZKScbBZDZviH6BKES6BIrA/0vQCmHXki8zj3V4+Y3qd4NT/9
         iGVug55v3jwDmMEh5XM5aCjPWfwdjqYD/qKO8TBAPtWdBycVT8RC2KXRIWjWFTAgkw
         XufVzKCkXxj3nI1X8bX3jNnhCYnvp2I1EnXw7u6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 080/135] RDMA/mlx5: Release locks during notifier unregister
Date:   Thu, 22 Aug 2019 13:07:16 -0400
Message-Id: <20190822170811.13303-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 23eaf3b5c1a755e3193480c76fb29414be648688 ]

The below kernel panic was observed when created bond mode LACP
with GRE tunnel on top. The reason to it was not released spinlock
during mlx5 notify unregsiter sequence.

[  234.562007] BUG: scheduling while atomic: sh/10900/0x00000002
[  234.563005] Preemption disabled at:
[  234.566864] ------------[ cut here ]------------
[  234.567120] DEBUG_LOCKS_WARN_ON(val > preempt_count())
[  234.567139] WARNING: CPU: 16 PID: 10900 at kernel/sched/core.c:3203 preempt_count_sub+0xca/0x170
[  234.569550] CPU: 16 PID: 10900 Comm: sh Tainted: G        W 5.2.0-rc1-for-linust-dbg-2019-05-25_04-57-33-60 #1
[  234.569886] Hardware name: Dell Inc. PowerEdge R720/0X3D66, BIOS 2.6.1 02/12/2018
[  234.570183] RIP: 0010:preempt_count_sub+0xca/0x170
[  234.570404] Code: 03 38
d0 7c 08 84 d2 0f 85 b0 00 00 00 8b 15 dd 02 03 04 85 d2 75 ba 48 c7 c6
00 e1 88 83 48 c7 c7 40 e1 88 83 e8 76 11 f7 ff <0f> 0b 5b c3 65 8b 05
d3 1f d8 7e 84 c0 75 82 e8 62 c3 c3 00 85 c0
[  234.570911] RSP: 0018:ffff888b94477b08 EFLAGS: 00010286
[  234.571133] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
[  234.571391] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000246
[  234.571648] RBP: ffff888ba5560000 R08: fffffbfff08962d5 R09: fffffbfff08962d5
[  234.571902] R10: 0000000000000001 R11: fffffbfff08962d4 R12: ffff888bac6e9548
[  234.572157] R13: ffff888babfaf728 R14: ffff888bac6e9568 R15: ffff888babfaf750
[  234.572412] FS: 00007fcafa59b740(0000) GS:ffff888bed200000(0000) knlGS:0000000000000000
[  234.572686] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  234.572914] CR2: 00007f984f16b140 CR3: 0000000b2bf0a001 CR4: 00000000001606e0
[  234.573172] Call Trace:
[  234.573336] _raw_spin_unlock+0x2e/0x50
[  234.573542] mlx5_ib_unbind_slave_port+0x1bc/0x690 [mlx5_ib]
[  234.573793] mlx5_ib_cleanup_multiport_master+0x1d3/0x660 [mlx5_ib]
[  234.574039] mlx5_ib_stage_init_cleanup+0x4c/0x360 [mlx5_ib]
[  234.574271]  ? kfree+0xf5/0x2f0
[  234.574465] __mlx5_ib_remove+0x61/0xd0 [mlx5_ib]
[  234.574688]  ? __mlx5_ib_remove+0xd0/0xd0 [mlx5_ib]
[  234.574951] mlx5_remove_device+0x234/0x300 [mlx5_core]
[  234.575224] mlx5_unregister_device+0x4d/0x1e0 [mlx5_core]
[  234.575493] remove_one+0x4f/0x160 [mlx5_core]
[  234.575704] pci_device_remove+0xef/0x2a0
[  234.581407]  ? pcibios_free_irq+0x10/0x10
[  234.587143]  ? up_read+0xc1/0x260
[  234.592785] device_release_driver_internal+0x1ab/0x430
[  234.598442] unbind_store+0x152/0x200
[  234.604064]  ? sysfs_kf_write+0x3b/0x180
[  234.609441]  ? sysfs_file_ops+0x160/0x160
[  234.615021] kernfs_fop_write+0x277/0x440
[  234.620288]  ? __sb_start_write+0x1ef/0x2c0
[  234.625512] vfs_write+0x15e/0x460
[  234.630786] ksys_write+0x156/0x1e0
[  234.635988]  ? __ia32_sys_read+0xb0/0xb0
[  234.641120]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  234.646163] do_syscall_64+0x95/0x470
[  234.651106] entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  234.656004] RIP: 0033:0x7fcaf9c9cfd0
[  234.660686] Code: 73 01
c3 48 8b 0d c0 6e 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00
83 3d cd cf 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73
31 c3 48 83 ec 08 e8 ee cb 01 00 48 89 04 24
[  234.670128] RSP: 002b:00007ffd3b01ddd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  234.674811] RAX: ffffffffffffffda RBX: 000000000000000d RCX: 00007fcaf9c9cfd0
[  234.679387] RDX: 000000000000000d RSI: 00007fcafa5c1000 RDI: 0000000000000001
[  234.683848] RBP: 00007fcafa5c1000 R08: 000000000000000a R09: 00007fcafa59b740
[  234.688167] R10: 00007ffd3b01d8e0 R11: 0000000000000246 R12: 00007fcaf9f75400
[  234.692386] R13: 000000000000000d R14: 0000000000000001 R15: 0000000000000000
[  234.696495] irq event stamp: 153067
[  234.700525] hardirqs last enabled at (153067): [<ffffffff83258c39>] _raw_spin_unlock_irqrestore+0x59/0x70
[  234.704665] hardirqs last disabled at (153066): [<ffffffff83259382>] _raw_spin_lock_irqsave+0x22/0x90
[  234.708722] softirqs last enabled at (153058): [<ffffffff836006c5>] __do_softirq+0x6c5/0xb4e
[  234.712673] softirqs last disabled at (153051): [<ffffffff81227c1d>] irq_exit+0x17d/0x1d0
[  234.716601] ---[ end trace 5dbf096843ee9ce6 ]---

Fixes: df097a278c75 ("IB/mlx5: Use the new mlx5 core notifier API")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190731083852.584-1-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index a6713a3b6c803..9ab276a8bc81a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -5687,13 +5687,12 @@ static void mlx5_ib_unbind_slave_port(struct mlx5_ib_dev *ibdev,
 		return;
 	}
 
-	if (mpi->mdev_events.notifier_call)
-		mlx5_notifier_unregister(mpi->mdev, &mpi->mdev_events);
-	mpi->mdev_events.notifier_call = NULL;
-
 	mpi->ibdev = NULL;
 
 	spin_unlock(&port->mp.mpi_lock);
+	if (mpi->mdev_events.notifier_call)
+		mlx5_notifier_unregister(mpi->mdev, &mpi->mdev_events);
+	mpi->mdev_events.notifier_call = NULL;
 	mlx5_remove_netdev_notifier(ibdev, port_num);
 	spin_lock(&port->mp.mpi_lock);
 
-- 
2.20.1

