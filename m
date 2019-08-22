Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F04599A7B
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731759AbfHVRNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390582AbfHVRI6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:58 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0119B23407;
        Thu, 22 Aug 2019 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493737;
        bh=Q13wtFxSwRSYhCjMa/fkfkqqtzby4eShoht+S5nVh6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3+LTbD/xto/roETRRDERLtbtOvEwT571z4+yOesLHcLLvW3fj7HtYzkSyQ58F0sL
         PbSjCM5dj3WWqUTUl8cJFfpX7W+XEVlvMf0vTmSIkDvBZTrEPnHD15cmh5hfqFVPPG
         jof+VHi14zuJiw7VTmvvnRcSVarj8Chj8M0r5Tdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 079/135] IB/mad: Fix use-after-free in ib mad completion handling
Date:   Thu, 22 Aug 2019 13:07:15 -0400
Message-Id: <20190822170811.13303-80-sashal@kernel.org>
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

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

[ Upstream commit 770b7d96cfff6a8bf6c9f261ba6f135dc9edf484 ]

We encountered a use-after-free bug when unloading the driver:

[ 3562.116059] BUG: KASAN: use-after-free in ib_mad_post_receive_mads+0xddc/0xed0 [ib_core]
[ 3562.117233] Read of size 4 at addr ffff8882ca5aa868 by task kworker/u13:2/23862
[ 3562.118385]
[ 3562.119519] CPU: 2 PID: 23862 Comm: kworker/u13:2 Tainted: G           OE     5.1.0-for-upstream-dbg-2019-05-19_16-44-30-13 #1
[ 3562.121806] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu2 04/01/2014
[ 3562.123075] Workqueue: ib-comp-unb-wq ib_cq_poll_work [ib_core]
[ 3562.124383] Call Trace:
[ 3562.125640]  dump_stack+0x9a/0xeb
[ 3562.126911]  print_address_description+0xe3/0x2e0
[ 3562.128223]  ? ib_mad_post_receive_mads+0xddc/0xed0 [ib_core]
[ 3562.129545]  __kasan_report+0x15c/0x1df
[ 3562.130866]  ? ib_mad_post_receive_mads+0xddc/0xed0 [ib_core]
[ 3562.132174]  kasan_report+0xe/0x20
[ 3562.133514]  ib_mad_post_receive_mads+0xddc/0xed0 [ib_core]
[ 3562.134835]  ? find_mad_agent+0xa00/0xa00 [ib_core]
[ 3562.136158]  ? qlist_free_all+0x51/0xb0
[ 3562.137498]  ? mlx4_ib_sqp_comp_worker+0x1970/0x1970 [mlx4_ib]
[ 3562.138833]  ? quarantine_reduce+0x1fa/0x270
[ 3562.140171]  ? kasan_unpoison_shadow+0x30/0x40
[ 3562.141522]  ib_mad_recv_done+0xdf6/0x3000 [ib_core]
[ 3562.142880]  ? _raw_spin_unlock_irqrestore+0x46/0x70
[ 3562.144277]  ? ib_mad_send_done+0x1810/0x1810 [ib_core]
[ 3562.145649]  ? mlx4_ib_destroy_cq+0x2a0/0x2a0 [mlx4_ib]
[ 3562.147008]  ? _raw_spin_unlock_irqrestore+0x46/0x70
[ 3562.148380]  ? debug_object_deactivate+0x2b9/0x4a0
[ 3562.149814]  __ib_process_cq+0xe2/0x1d0 [ib_core]
[ 3562.151195]  ib_cq_poll_work+0x45/0xf0 [ib_core]
[ 3562.152577]  process_one_work+0x90c/0x1860
[ 3562.153959]  ? pwq_dec_nr_in_flight+0x320/0x320
[ 3562.155320]  worker_thread+0x87/0xbb0
[ 3562.156687]  ? __kthread_parkme+0xb6/0x180
[ 3562.158058]  ? process_one_work+0x1860/0x1860
[ 3562.159429]  kthread+0x320/0x3e0
[ 3562.161391]  ? kthread_park+0x120/0x120
[ 3562.162744]  ret_from_fork+0x24/0x30
...
[ 3562.187615] Freed by task 31682:
[ 3562.188602]  save_stack+0x19/0x80
[ 3562.189586]  __kasan_slab_free+0x11d/0x160
[ 3562.190571]  kfree+0xf5/0x2f0
[ 3562.191552]  ib_mad_port_close+0x200/0x380 [ib_core]
[ 3562.192538]  ib_mad_remove_device+0xf0/0x230 [ib_core]
[ 3562.193538]  remove_client_context+0xa6/0xe0 [ib_core]
[ 3562.194514]  disable_device+0x14e/0x260 [ib_core]
[ 3562.195488]  __ib_unregister_device+0x79/0x150 [ib_core]
[ 3562.196462]  ib_unregister_device+0x21/0x30 [ib_core]
[ 3562.197439]  mlx4_ib_remove+0x162/0x690 [mlx4_ib]
[ 3562.198408]  mlx4_remove_device+0x204/0x2c0 [mlx4_core]
[ 3562.199381]  mlx4_unregister_interface+0x49/0x1d0 [mlx4_core]
[ 3562.200356]  mlx4_ib_cleanup+0xc/0x1d [mlx4_ib]
[ 3562.201329]  __x64_sys_delete_module+0x2d2/0x400
[ 3562.202288]  do_syscall_64+0x95/0x470
[ 3562.203277]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The problem was that the MAD PD was deallocated before the MAD CQ.
There was completion work pending for the CQ when the PD got deallocated.
When the mad completion handling reached procedure
ib_mad_post_receive_mads(), we got a use-after-free bug in the following
line of code in that procedure:
   sg_list.lkey = qp_info->port_priv->pd->local_dma_lkey;
(the pd pointer in the above line is no longer valid, because the
pd has been deallocated).

We fix this by allocating the PD before the CQ in procedure
ib_mad_port_open(), and deallocating the PD after freeing the CQ
in procedure ib_mad_port_close().

Since the CQ completion work queue is flushed during ib_free_cq(),
no completions will be pending for that CQ when the PD is later
deallocated.

Note that freeing the CQ before deallocating the PD is the practice
in the ULPs.

Fixes: 4be90bc60df4 ("IB/mad: Remove ib_get_dma_mr calls")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190801121449.24973-1-leon@kernel.org
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index cc99479b2c09d..9947d16edef21 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3224,18 +3224,18 @@ static int ib_mad_port_open(struct ib_device *device,
 	if (has_smi)
 		cq_size *= 2;
 
+	port_priv->pd = ib_alloc_pd(device, 0);
+	if (IS_ERR(port_priv->pd)) {
+		dev_err(&device->dev, "Couldn't create ib_mad PD\n");
+		ret = PTR_ERR(port_priv->pd);
+		goto error3;
+	}
+
 	port_priv->cq = ib_alloc_cq(port_priv->device, port_priv, cq_size, 0,
 			IB_POLL_UNBOUND_WORKQUEUE);
 	if (IS_ERR(port_priv->cq)) {
 		dev_err(&device->dev, "Couldn't create ib_mad CQ\n");
 		ret = PTR_ERR(port_priv->cq);
-		goto error3;
-	}
-
-	port_priv->pd = ib_alloc_pd(device, 0);
-	if (IS_ERR(port_priv->pd)) {
-		dev_err(&device->dev, "Couldn't create ib_mad PD\n");
-		ret = PTR_ERR(port_priv->pd);
 		goto error4;
 	}
 
@@ -3278,11 +3278,11 @@ static int ib_mad_port_open(struct ib_device *device,
 error7:
 	destroy_mad_qp(&port_priv->qp_info[0]);
 error6:
-	ib_dealloc_pd(port_priv->pd);
-error4:
 	ib_free_cq(port_priv->cq);
 	cleanup_recv_queue(&port_priv->qp_info[1]);
 	cleanup_recv_queue(&port_priv->qp_info[0]);
+error4:
+	ib_dealloc_pd(port_priv->pd);
 error3:
 	kfree(port_priv);
 
@@ -3312,8 +3312,8 @@ static int ib_mad_port_close(struct ib_device *device, int port_num)
 	destroy_workqueue(port_priv->wq);
 	destroy_mad_qp(&port_priv->qp_info[1]);
 	destroy_mad_qp(&port_priv->qp_info[0]);
-	ib_dealloc_pd(port_priv->pd);
 	ib_free_cq(port_priv->cq);
+	ib_dealloc_pd(port_priv->pd);
 	cleanup_recv_queue(&port_priv->qp_info[1]);
 	cleanup_recv_queue(&port_priv->qp_info[0]);
 	/* XXX: Handle deallocation of MAD registration tables */
-- 
2.20.1

