Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F95ECA2AB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732250AbfJCQHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733013AbfJCQHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2E9207FF;
        Thu,  3 Oct 2019 16:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118871;
        bh=BIohoXAlhVB4rZBWYriKGkkUxUnJUI9fxltSi2I7I1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KihU/GQvfkjg5KNMhTuTIEHjj+Fh66SmX8sT51mlHy5GGkSPiXr/6pmJ0NMmkggAC
         6+ThM7rWfXwwRj38pCl2XGX6iHWFiz0BJmZKAAQNne3YwKg+swzVjQ+H12iZ7H4SZE
         lnN85LJNxWgN+n2237sVqR3H0oWQU0dumiTSD9c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.m>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 004/185] IB/core: Add an unbound WQ type to the new CQ API
Date:   Thu,  3 Oct 2019 17:51:22 +0200
Message-Id: <20191003154438.325611744@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit f794809a7259dfaa3d47d90ef5a86007cf48b1ce upstream.

The upstream kernel commit cited below modified the workqueue in the
new CQ API to be bound to a specific CPU (instead of being unbound).
This caused ALL users of the new CQ API to use the same bound WQ.

Specifically, MAD handling was severely delayed when the CPU bound
to the WQ was busy handling (higher priority) interrupts.

This caused a delay in the MAD "heartbeat" response handling,
which resulted in ports being incorrectly classified as "down".

To fix this, add a new "unbound" WQ type to the new CQ API, so that users
have the option to choose either a bound WQ or an unbound WQ.

For MADs, choose the new "unbound" WQ.

Fixes: b7363e67b23e ("IB/device: Convert ib-comp-wq to be CPU-bound")
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.m>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cq.c     |    8 ++++++--
 drivers/infiniband/core/device.c |   15 ++++++++++++++-
 drivers/infiniband/core/mad.c    |    2 +-
 include/rdma/ib_verbs.h          |    9 ++++++---
 4 files changed, 27 insertions(+), 7 deletions(-)

--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -112,12 +112,12 @@ static void ib_cq_poll_work(struct work_
 				    IB_POLL_BATCH);
 	if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
 	    ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
-		queue_work(ib_comp_wq, &cq->work);
+		queue_work(cq->comp_wq, &cq->work);
 }
 
 static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
 {
-	queue_work(ib_comp_wq, &cq->work);
+	queue_work(cq->comp_wq, &cq->work);
 }
 
 /**
@@ -169,9 +169,12 @@ struct ib_cq *ib_alloc_cq(struct ib_devi
 		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 		break;
 	case IB_POLL_WORKQUEUE:
+	case IB_POLL_UNBOUND_WORKQUEUE:
 		cq->comp_handler = ib_cq_completion_workqueue;
 		INIT_WORK(&cq->work, ib_cq_poll_work);
 		ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
+		cq->comp_wq = (cq->poll_ctx == IB_POLL_WORKQUEUE) ?
+				ib_comp_wq : ib_comp_unbound_wq;
 		break;
 	default:
 		ret = -EINVAL;
@@ -206,6 +209,7 @@ void ib_free_cq(struct ib_cq *cq)
 		irq_poll_disable(&cq->iop);
 		break;
 	case IB_POLL_WORKQUEUE:
+	case IB_POLL_UNBOUND_WORKQUEUE:
 		cancel_work_sync(&cq->work);
 		break;
 	default:
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -61,6 +61,7 @@ struct ib_client_data {
 };
 
 struct workqueue_struct *ib_comp_wq;
+struct workqueue_struct *ib_comp_unbound_wq;
 struct workqueue_struct *ib_wq;
 EXPORT_SYMBOL_GPL(ib_wq);
 
@@ -1202,10 +1203,19 @@ static int __init ib_core_init(void)
 		goto err;
 	}
 
+	ib_comp_unbound_wq =
+		alloc_workqueue("ib-comp-unb-wq",
+				WQ_UNBOUND | WQ_HIGHPRI | WQ_MEM_RECLAIM |
+				WQ_SYSFS, WQ_UNBOUND_MAX_ACTIVE);
+	if (!ib_comp_unbound_wq) {
+		ret = -ENOMEM;
+		goto err_comp;
+	}
+
 	ret = class_register(&ib_class);
 	if (ret) {
 		pr_warn("Couldn't create InfiniBand device class\n");
-		goto err_comp;
+		goto err_comp_unbound;
 	}
 
 	ret = rdma_nl_init();
@@ -1254,6 +1264,8 @@ err_ibnl:
 	rdma_nl_exit();
 err_sysfs:
 	class_unregister(&ib_class);
+err_comp_unbound:
+	destroy_workqueue(ib_comp_unbound_wq);
 err_comp:
 	destroy_workqueue(ib_comp_wq);
 err:
@@ -1272,6 +1284,7 @@ static void __exit ib_core_cleanup(void)
 	addr_cleanup();
 	rdma_nl_exit();
 	class_unregister(&ib_class);
+	destroy_workqueue(ib_comp_unbound_wq);
 	destroy_workqueue(ib_comp_wq);
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -3178,7 +3178,7 @@ static int ib_mad_port_open(struct ib_de
 	}
 
 	port_priv->cq = ib_alloc_cq(port_priv->device, port_priv, cq_size, 0,
-			IB_POLL_WORKQUEUE);
+			IB_POLL_UNBOUND_WORKQUEUE);
 	if (IS_ERR(port_priv->cq)) {
 		dev_err(&device->dev, "Couldn't create ib_mad CQ\n");
 		ret = PTR_ERR(port_priv->cq);
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -68,6 +68,7 @@
 
 extern struct workqueue_struct *ib_wq;
 extern struct workqueue_struct *ib_comp_wq;
+extern struct workqueue_struct *ib_comp_unbound_wq;
 
 union ib_gid {
 	u8	raw[16];
@@ -1544,9 +1545,10 @@ struct ib_ah {
 typedef void (*ib_comp_handler)(struct ib_cq *cq, void *cq_context);
 
 enum ib_poll_context {
-	IB_POLL_DIRECT,		/* caller context, no hw completions */
-	IB_POLL_SOFTIRQ,	/* poll from softirq context */
-	IB_POLL_WORKQUEUE,	/* poll from workqueue */
+	IB_POLL_DIRECT,		   /* caller context, no hw completions */
+	IB_POLL_SOFTIRQ,	   /* poll from softirq context */
+	IB_POLL_WORKQUEUE,	   /* poll from workqueue */
+	IB_POLL_UNBOUND_WORKQUEUE, /* poll from unbound workqueue */
 };
 
 struct ib_cq {
@@ -1563,6 +1565,7 @@ struct ib_cq {
 		struct irq_poll		iop;
 		struct work_struct	work;
 	};
+	struct workqueue_struct *comp_wq;
 };
 
 struct ib_srq {


