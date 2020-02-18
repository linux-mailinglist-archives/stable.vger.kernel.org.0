Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12B461621E8
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 08:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgBRH7M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 02:59:12 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47867 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbgBRH7M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 02:59:12 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 2299F583;
        Tue, 18 Feb 2020 02:59:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 18 Feb 2020 02:59:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8t27Gn
        UF19MGtNe63oUZoy0zPrPxkWyucYiwJe+bK74=; b=dOzlS/KJ2zgJKk4oRXWKXM
        zgSQNVuKLSIkjSpGGpSLqtggz9FxbTtDKvnFw1JFwNQ47NDLmL0L7oXiplaZlLbS
        9psbSJwevdaeshjBD0LxvRU0c9Msv1pv0uP8mZyCk1qEmbvbv3LkPhirmekgrfO1
        RrkmIge7pr05bmu6C88ca3ZmlijCpaYCCuySWDk8G3douBZGQLQ/kBy3R8ivQDxS
        vecO0PLAeYc9BoI+JDzmH1ejVlhvgO0dibcggknojdtR0Rhhq7k6zdNsMPtdslKR
        QYJP2H1A3pebAb3sZeWYUT/AFoMx4nt0VqQ9j4MvuIVe8SqLwwE6M35UWkcf+xRQ
        ==
X-ME-Sender: <xms:TplLXthq27Ct8Dx6ZZLOoDZUEjooyCWniqkWao3i_v4Pwzch8e7MmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeejgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TplLXm9DF0xGDJZixnMwnnZLBjsdXco9TEe8tJ4GdxQzqM7CRArrtg>
    <xmx:TplLXhWgUTprShevIaYN9DhB6D_sh2jRGeexVvB6UEmm5l4GSbU5_w>
    <xmx:TplLXiC9kQUBaOr8I7JcwInHoeQbE6N2k17FelKNmhCyB0DVPMi4Ow>
    <xmx:TplLXlq4qgf-239jaqpYhW5zzoKXHYPCxoBtBcU8Bmi62hpXZiwIMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5BD113280062;
        Tue, 18 Feb 2020 02:59:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/rxe: Fix soft lockup problem due to using tasklets in" failed to apply to 4.14-stable tree
To:     yanjunz@mellanox.com, jgg@mellanox.com, leonro@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Feb 2020 08:59:06 +0100
Message-ID: <15820127465011@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8ac0e6641c7ca14833a2a8c6f13d8e0a435e535c Mon Sep 17 00:00:00 2001
From: Zhu Yanjun <yanjunz@mellanox.com>
Date: Wed, 12 Feb 2020 09:26:33 +0200
Subject: [PATCH] RDMA/rxe: Fix soft lockup problem due to using tasklets in
 softirq

When run stress tests with RXE, the following Call Traces often occur

  watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [swapper/2:0]
  ...
  Call Trace:
  <IRQ>
  create_object+0x3f/0x3b0
  kmem_cache_alloc_node_trace+0x129/0x2d0
  __kmalloc_reserve.isra.52+0x2e/0x80
  __alloc_skb+0x83/0x270
  rxe_init_packet+0x99/0x150 [rdma_rxe]
  rxe_requester+0x34e/0x11a0 [rdma_rxe]
  rxe_do_task+0x85/0xf0 [rdma_rxe]
  tasklet_action_common.isra.21+0xeb/0x100
  __do_softirq+0xd0/0x298
  irq_exit+0xc5/0xd0
  smp_apic_timer_interrupt+0x68/0x120
  apic_timer_interrupt+0xf/0x20
  </IRQ>
  ...

The root cause is that tasklet is actually a softirq. In a tasklet
handler, another softirq handler is triggered. Usually these softirq
handlers run on the same cpu core. So this will cause "soft lockup Bug".

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200212072635.682689-8-leon@kernel.org
Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 116cafc9afcf..4bc88708b355 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -329,7 +329,7 @@ static inline enum comp_state check_ack(struct rxe_qp *qp,
 					qp->comp.psn = pkt->psn;
 					if (qp->req.wait_psn) {
 						qp->req.wait_psn = 0;
-						rxe_run_task(&qp->req.task, 1);
+						rxe_run_task(&qp->req.task, 0);
 					}
 				}
 				return COMPST_ERROR_RETRY;
@@ -463,7 +463,7 @@ static void do_complete(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	 */
 	if (qp->req.wait_fence) {
 		qp->req.wait_fence = 0;
-		rxe_run_task(&qp->req.task, 1);
+		rxe_run_task(&qp->req.task, 0);
 	}
 }
 
@@ -479,7 +479,7 @@ static inline enum comp_state complete_ack(struct rxe_qp *qp,
 		if (qp->req.need_rd_atomic) {
 			qp->comp.timeout_retry = 0;
 			qp->req.need_rd_atomic = 0;
-			rxe_run_task(&qp->req.task, 1);
+			rxe_run_task(&qp->req.task, 0);
 		}
 	}
 
@@ -725,7 +725,7 @@ int rxe_completer(void *arg)
 							RXE_CNT_COMP_RETRY);
 					qp->req.need_retry = 1;
 					qp->comp.started_retry = 1;
-					rxe_run_task(&qp->req.task, 1);
+					rxe_run_task(&qp->req.task, 0);
 				}
 
 				if (pkt) {

