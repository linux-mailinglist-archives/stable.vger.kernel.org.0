Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACE929B4F9
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793634AbgJ0PHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790958AbgJ0PFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:13 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF6FE21D24;
        Tue, 27 Oct 2020 15:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811112;
        bh=JK12HcBdyjs0CSV9uBupvXaVWc5Y/eNkJhOs5uksRRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9D5PmTa5NXgn+f8jT3Kc0iTHywQly+YN10FmzTZI1GkMDNfPx5AANRm1X2gsADxz
         VlBtDal8lf+OnTXcgi9LcoygrmtwrvXzasM46Yj0c99OrNPxDzLYtU/7QHIDjpUiRR
         a+qOBG2V+p1/tsQjOid8nTehz4YxH6MYwwY6zRlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>,
        =?UTF-8?q?Michal=20Kalderon=C2=A0?= <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 376/633] RDMA/qedr: Fix resource leak in qedr_create_qp
Date:   Tue, 27 Oct 2020 14:51:59 +0100
Message-Id: <20201027135540.343119887@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>

[ Upstream commit 3e45410fe3c202ffb619f301beff0644f717e132 ]

When xa_insert() fails, the acquired resource in qedr_create_qp should
also be freed. However, current implementation does not handle the error.

Fix this by adding a new goto label that calls qedr_free_qp_resources.

Fixes: 1212767e23bb ("qedr: Add wrapping generic structure for qpidr and adjust idr routines.")
Link: https://lore.kernel.org/r/20200911125159.4577-1-keitasuzuki.park@sslab.ics.keio.ac.jp
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Acked-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 52 ++++++++++++++++--------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index 820e351277d1b..41813e9d771ff 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2113,6 +2113,28 @@ static int qedr_create_kernel_qp(struct qedr_dev *dev,
 	return rc;
 }
 
+static int qedr_free_qp_resources(struct qedr_dev *dev, struct qedr_qp *qp,
+				  struct ib_udata *udata)
+{
+	struct qedr_ucontext *ctx =
+		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
+					  ibucontext);
+	int rc;
+
+	if (qp->qp_type != IB_QPT_GSI) {
+		rc = dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
+		if (rc)
+			return rc;
+	}
+
+	if (qp->create_type == QEDR_QP_CREATE_USER)
+		qedr_cleanup_user(dev, ctx, qp);
+	else
+		qedr_cleanup_kernel(dev, qp);
+
+	return 0;
+}
+
 struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 			     struct ib_qp_init_attr *attrs,
 			     struct ib_udata *udata)
@@ -2159,19 +2181,21 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 		rc = qedr_create_kernel_qp(dev, qp, ibpd, attrs);
 
 	if (rc)
-		goto err;
+		goto out_free_qp;
 
 	qp->ibqp.qp_num = qp->qp_id;
 
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
 		rc = xa_insert(&dev->qps, qp->qp_id, qp, GFP_KERNEL);
 		if (rc)
-			goto err;
+			goto out_free_qp_resources;
 	}
 
 	return &qp->ibqp;
 
-err:
+out_free_qp_resources:
+	qedr_free_qp_resources(dev, qp, udata);
+out_free_qp:
 	kfree(qp);
 
 	return ERR_PTR(-EFAULT);
@@ -2672,28 +2696,6 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	return rc;
 }
 
-static int qedr_free_qp_resources(struct qedr_dev *dev, struct qedr_qp *qp,
-				  struct ib_udata *udata)
-{
-	struct qedr_ucontext *ctx =
-		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
-					  ibucontext);
-	int rc;
-
-	if (qp->qp_type != IB_QPT_GSI) {
-		rc = dev->ops->rdma_destroy_qp(dev->rdma_ctx, qp->qed_qp);
-		if (rc)
-			return rc;
-	}
-
-	if (qp->create_type == QEDR_QP_CREATE_USER)
-		qedr_cleanup_user(dev, ctx, qp);
-	else
-		qedr_cleanup_kernel(dev, qp);
-
-	return 0;
-}
-
 int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 {
 	struct qedr_qp *qp = get_qedr_qp(ibqp);
-- 
2.25.1



