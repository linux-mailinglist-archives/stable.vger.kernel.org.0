Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A328C163151
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgBRT7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727158AbgBRT7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B67124670;
        Tue, 18 Feb 2020 19:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055963;
        bh=r3Wt9Fqia8ELqoZcBvGRbikshi1Mn5+KDL7u1kFTmjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOfXgD17Qu17QiC9A2yhRzQmP/sEdr9DQ8BmLhVl1XuCdRjYv0tNgOg23qUzPy2a6
         1Zhivya9ufv8hqHKh6jAFuupJikZ9CLhLU6R5rPUJR7+Et064Ex5WzxmbevF6yT2em
         TlFL1M4oHsZEI9Lmp2dq323wxeUw+mBikvrGLkA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhu Yanjun <yanjunz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 47/66] RDMA/rxe: Fix soft lockup problem due to using tasklets in softirq
Date:   Tue, 18 Feb 2020 20:55:14 +0100
Message-Id: <20200218190432.365113067@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhu Yanjun <yanjunz@mellanox.com>

commit 8ac0e6641c7ca14833a2a8c6f13d8e0a435e535c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/sw/rxe/rxe_comp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -329,7 +329,7 @@ static inline enum comp_state check_ack(
 					qp->comp.psn = pkt->psn;
 					if (qp->req.wait_psn) {
 						qp->req.wait_psn = 0;
-						rxe_run_task(&qp->req.task, 1);
+						rxe_run_task(&qp->req.task, 0);
 					}
 				}
 				return COMPST_ERROR_RETRY;
@@ -463,7 +463,7 @@ static void do_complete(struct rxe_qp *q
 	 */
 	if (qp->req.wait_fence) {
 		qp->req.wait_fence = 0;
-		rxe_run_task(&qp->req.task, 1);
+		rxe_run_task(&qp->req.task, 0);
 	}
 }
 
@@ -479,7 +479,7 @@ static inline enum comp_state complete_a
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


