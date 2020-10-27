Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5EC29B89F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368898AbgJ0PmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800533AbgJ0Pg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4330322275;
        Tue, 27 Oct 2020 15:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812988;
        bh=9fqwijg251PlkDfzaDjj5E8/2HJpfUS7QhVeDMQU5Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNJcvHEY8bCZ9LL1YqnNqh9ktFXAmJ9nZU3dErlxTz/rMnfI5EVlFWUDPmBHyHDwz
         unTpFIyxQPKeBfcvCL3qKZuKEXFf9fgInzHc66OkQAUUvUVdzfF80uJ/ToptivI8WC
         Ka1FSexvTjm9xMJWKgKnw9BX8wGDOH/JsaIRAf7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 399/757] IB/mlx4: Fix starvation in paravirt mux/demux
Date:   Tue, 27 Oct 2020 14:50:49 +0100
Message-Id: <20201027135509.293764784@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit 7fd1507df7cee9c533f38152fcd1dd769fcac6ce ]

The mlx4 driver will proxy MAD packets through the PF driver. A VM or an
instantiated VF will send its MAD packets to the PF driver using
loop-back. The PF driver will be informed by an interrupt, but defer the
handling and polling of CQEs to a worker thread running on an ordered
work-queue.

Consider the following scenario: the VMs will in short proximity in time,
for example due to a network event, send many MAD packets to the PF
driver. Lets say there are K VMs, each sending N packets.

The interrupt from the first VM will start the worker thread, which will
poll N CQEs. A common case here is where the PF driver will multiplex the
packets received from the VMs out on the wire QP.

But before the wire QP has returned a send CQE and associated interrupt,
the other K - 1 VMs have sent their N packets as well.

The PF driver has to multiplex K * N packets out on the wire QP. But the
send-queue on the wire QP has a finite capacity.

So, in this scenario, if K * N is larger than the send-queue capacity of
the wire QP, we will get MAD packets dropped on the floor with this
dynamic debug message:

mlx4_ib_multiplex_mad: failed sending GSI to wire on behalf of slave 2 (-11)

and this despite the fact that the wire send-queue could have capacity,
but the PF driver isn't aware, because the wire send CQEs have not yet
been polled.

We can also have a similar scenario inbound, with a wire recv-queue larger
than the tunnel QP's send-queue. If many remote peers send MAD packets to
the very same VM, the tunnel send-queue destined to the VM could allegedly
be construed to be full by the PF driver.

This starvation is fixed by introducing separate work queues for the wire
QPs vs. the tunnel QPs.

With this fix, using a dual ported HCA, 8 VFs instantiated, we could run
cmtime on each of the 18 interfaces towards a similar configured peer,
each cmtime instance with 800 QPs (all in all 14400 QPs) without a single
CM packet getting lost.

Fixes: 3cf69cc8dbeb ("IB/mlx4: Add CM paravirtualization")
Link: https://lore.kernel.org/r/20200803061941.1139994-5-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/mad.c     | 34 +++++++++++++++++++++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 ++
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index abe68708d6d6e..2cbdba4da9dfe 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1299,6 +1299,18 @@ static void mlx4_ib_tunnel_comp_handler(struct ib_cq *cq, void *arg)
 	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
 }
 
+static void mlx4_ib_wire_comp_handler(struct ib_cq *cq, void *arg)
+{
+	unsigned long flags;
+	struct mlx4_ib_demux_pv_ctx *ctx = cq->cq_context;
+	struct mlx4_ib_dev *dev = to_mdev(ctx->ib_dev);
+
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	if (!dev->sriov.is_going_down && ctx->state == DEMUX_PV_STATE_ACTIVE)
+		queue_work(ctx->wi_wq, &ctx->work);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+}
+
 static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_demux_pv_ctx *ctx,
 				  struct mlx4_ib_demux_pv_qp *tun_qp,
 				  int index)
@@ -2001,7 +2013,8 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		cq_size *= 2;
 
 	cq_attr.cqe = cq_size;
-	ctx->cq = ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler,
+	ctx->cq = ib_create_cq(ctx->ib_dev,
+			       create_tun ? mlx4_ib_tunnel_comp_handler : mlx4_ib_wire_comp_handler,
 			       NULL, ctx, &cq_attr);
 	if (IS_ERR(ctx->cq)) {
 		ret = PTR_ERR(ctx->cq);
@@ -2038,6 +2051,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		INIT_WORK(&ctx->work, mlx4_ib_sqp_comp_worker);
 
 	ctx->wq = to_mdev(ibdev)->sriov.demux[port - 1].wq;
+	ctx->wi_wq = to_mdev(ibdev)->sriov.demux[port - 1].wi_wq;
 
 	ret = ib_req_notify_cq(ctx->cq, IB_CQ_NEXT_COMP);
 	if (ret) {
@@ -2181,7 +2195,7 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_mcg;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibt%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibt%d", port);
 	ctx->wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->wq) {
 		pr_err("Failed to create tunnelling WQ for port %d\n", port);
@@ -2189,7 +2203,15 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 		goto err_wq;
 	}
 
-	snprintf(name, sizeof name, "mlx4_ibud%d", port);
+	snprintf(name, sizeof(name), "mlx4_ibwi%d", port);
+	ctx->wi_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
+	if (!ctx->wi_wq) {
+		pr_err("Failed to create wire WQ for port %d\n", port);
+		ret = -ENOMEM;
+		goto err_wiwq;
+	}
+
+	snprintf(name, sizeof(name), "mlx4_ibud%d", port);
 	ctx->ud_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->ud_wq) {
 		pr_err("Failed to create up/down WQ for port %d\n", port);
@@ -2200,6 +2222,10 @@ static int mlx4_ib_alloc_demux_ctx(struct mlx4_ib_dev *dev,
 	return 0;
 
 err_udwq:
+	destroy_workqueue(ctx->wi_wq);
+	ctx->wi_wq = NULL;
+
+err_wiwq:
 	destroy_workqueue(ctx->wq);
 	ctx->wq = NULL;
 
@@ -2247,12 +2273,14 @@ static void mlx4_ib_free_demux_ctx(struct mlx4_ib_demux_ctx *ctx)
 				ctx->tun[i]->state = DEMUX_PV_STATE_DOWNING;
 		}
 		flush_workqueue(ctx->wq);
+		flush_workqueue(ctx->wi_wq);
 		for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
 			destroy_pv_resources(dev, i, ctx->port, ctx->tun[i], 0);
 			free_pv_object(dev, i, ctx->port);
 		}
 		kfree(ctx->tun);
 		destroy_workqueue(ctx->ud_wq);
+		destroy_workqueue(ctx->wi_wq);
 		destroy_workqueue(ctx->wq);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 38e87a700a2a2..75af838365c93 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -454,6 +454,7 @@ struct mlx4_ib_demux_pv_ctx {
 	struct ib_pd *pd;
 	struct work_struct work;
 	struct workqueue_struct *wq;
+	struct workqueue_struct *wi_wq;
 	struct mlx4_ib_demux_pv_qp qp[2];
 };
 
@@ -461,6 +462,7 @@ struct mlx4_ib_demux_ctx {
 	struct ib_device *ib_dev;
 	int port;
 	struct workqueue_struct *wq;
+	struct workqueue_struct *wi_wq;
 	struct workqueue_struct *ud_wq;
 	spinlock_t ud_lock;
 	atomic64_t subnet_prefix;
-- 
2.25.1



