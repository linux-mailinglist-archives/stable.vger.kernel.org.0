Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BDB22EF5E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbgG0OPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730756AbgG0OPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:15:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A1B2075A;
        Mon, 27 Jul 2020 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859349;
        bh=ntk01Kim6t9W9EGr/aZfU8ztLQHGiTsPGvsW5wOPnEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcqefULcn50XMgaJv9WfkMgv1uQ7P0AL/x9t+UpGpHfEP8BFTaMpKkNWwAs4Or7IH
         ctMA21BRGRtk8c6/iMsGTjH1pmhT3JBY0qOAuJoavoJ7pveTfCEGM61McKhfhy+l1a
         nebcqDeQG70Ji/QaF5dN1HO1e92k8gRcoOLW8m+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/138] RDMA/mlx5: Use xa_lock_irq when access to SRQ table
Date:   Mon, 27 Jul 2020 16:03:58 +0200
Message-Id: <20200727134927.517829514@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

[ Upstream commit c3d6057e07a5d15be7c69ea545b3f91877808c96 ]

SRQ table is accessed both from interrupt and process context,
therefore we must use xa_lock_irq.

   inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
   kworker/u17:9/8573   takes:
   ffff8883e3503d30 (&xa->xa_lock#13){?...}-{2:2}, at: mlx5_cmd_get_srq+0x18/0x70 [mlx5_ib]
   {IN-HARDIRQ-W} state was registered at:
     lock_acquire+0xb9/0x3a0
     _raw_spin_lock+0x25/0x30
     srq_event_notifier+0x2b/0xc0 [mlx5_ib]
     notifier_call_chain+0x45/0x70
     __atomic_notifier_call_chain+0x69/0x100
     forward_event+0x36/0xc0 [mlx5_core]
     notifier_call_chain+0x45/0x70
     __atomic_notifier_call_chain+0x69/0x100
     mlx5_eq_async_int+0xc5/0x160 [mlx5_core]
     notifier_call_chain+0x45/0x70
     __atomic_notifier_call_chain+0x69/0x100
     mlx5_irq_int_handler+0x19/0x30 [mlx5_core]
     __handle_irq_event_percpu+0x43/0x2a0
     handle_irq_event_percpu+0x30/0x70
     handle_irq_event+0x34/0x60
     handle_edge_irq+0x7c/0x1b0
     do_IRQ+0x60/0x110
     ret_from_intr+0x0/0x2a
     default_idle+0x34/0x160
     do_idle+0x1ec/0x220
     cpu_startup_entry+0x19/0x20
     start_secondary+0x153/0x1a0
     secondary_startup_64+0xa4/0xb0
   irq event stamp: 20907
   hardirqs last  enabled at (20907):   _raw_spin_unlock_irq+0x24/0x30
   hardirqs last disabled at (20906):   _raw_spin_lock_irq+0xf/0x40
   softirqs last  enabled at (20746):   __do_softirq+0x2c9/0x436
   softirqs last disabled at (20681):   irq_exit+0xb3/0xc0

   other info that might help us debug this:
    Possible unsafe locking scenario:

          CPU0
          ----
     lock(&xa->xa_lock#13);
     <Interrupt>
       lock(&xa->xa_lock#13);

    *** DEADLOCK ***

   2 locks held by kworker/u17:9/8573:
    #0: ffff888295218d38 ((wq_completion)mlx5_ib_page_fault){+.+.}-{0:0}, at: process_one_work+0x1f1/0x5f0
    #1: ffff888401647e78 ((work_completion)(&pfault->work)){+.+.}-{0:0}, at: process_one_work+0x1f1/0x5f0

   stack backtrace:
   CPU: 0 PID: 8573 Comm: kworker/u17:9 Tainted: GO      5.7.0_for_upstream_min_debug_2020_06_14_11_31_46_41 #1
   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
   Workqueue: mlx5_ib_page_fault mlx5_ib_eqe_pf_action [mlx5_ib]
   Call Trace:
    dump_stack+0x71/0x9b
    mark_lock+0x4f2/0x590
    ? print_shortest_lock_dependencies+0x200/0x200
    __lock_acquire+0xa00/0x1eb0
    lock_acquire+0xb9/0x3a0
    ? mlx5_cmd_get_srq+0x18/0x70 [mlx5_ib]
    _raw_spin_lock+0x25/0x30
    ? mlx5_cmd_get_srq+0x18/0x70 [mlx5_ib]
    mlx5_cmd_get_srq+0x18/0x70 [mlx5_ib]
    mlx5_ib_eqe_pf_action+0x257/0xa30 [mlx5_ib]
    ? process_one_work+0x209/0x5f0
    process_one_work+0x27b/0x5f0
    ? __schedule+0x280/0x7e0
    worker_thread+0x2d/0x3c0
    ? process_one_work+0x5f0/0x5f0
    kthread+0x111/0x130
    ? kthread_park+0x90/0x90
    ret_from_fork+0x24/0x30

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Link: https://lore.kernel.org/r/20200712102641.15210-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index 8fc3630a9d4c3..0224231a2e6f8 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -83,11 +83,11 @@ struct mlx5_core_srq *mlx5_cmd_get_srq(struct mlx5_ib_dev *dev, u32 srqn)
 	struct mlx5_srq_table *table = &dev->srq_table;
 	struct mlx5_core_srq *srq;
 
-	xa_lock(&table->array);
+	xa_lock_irq(&table->array);
 	srq = xa_load(&table->array, srqn);
 	if (srq)
 		refcount_inc(&srq->common.refcount);
-	xa_unlock(&table->array);
+	xa_unlock_irq(&table->array);
 
 	return srq;
 }
-- 
2.25.1



