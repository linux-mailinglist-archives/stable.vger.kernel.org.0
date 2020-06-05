Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5691EFA89
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbgFEOSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:18:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728678AbgFEOSb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:18:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C05D7208B8;
        Fri,  5 Jun 2020 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366710;
        bh=ZYLFjThddbW1+xNcXepU84+ujAyB4Au0piHz34kybLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMLbO8vkuTF6Z2SHcceFbCHAWKAhN6ciPMV4VPv8VcLp/QXhGJ/SCX7i7AmjKanmZ
         GNtjJcPy7zTNaS9biFSit3QfknI3A1jEwxgsTvu0J5x882x+p7PlvzlLu6OTRP/0NU
         S4HAHLi1yW3Xow9n8wyBohwxGRnQkNvrj/bQjOBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/38] RDMA/qedr: Fix qpids xarray api used
Date:   Fri,  5 Jun 2020 16:15:05 +0200
Message-Id: <20200605140253.896508411@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200605140252.542768750@linuxfoundation.org>
References: <20200605140252.542768750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 5fdff18b4dc64e2d1e912ad2b90495cd487f791b ]

The qpids xarray isn't accessed from irq context and therefore there
is no need to use the xa_XXX_irq version of the apis.
Remove the _irq.

Fixes: b6014f9e5f39 ("qedr: Convert qpidr to XArray")
Link: https://lore.kernel.org/r/20191027200451.28187-3-michal.kalderon@marvell.com
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/qedr/main.c       | 2 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c | 2 +-
 drivers/infiniband/hw/qedr/verbs.c      | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index b462eaca1ee3..4494dab8c3d8 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -360,7 +360,7 @@ static int qedr_alloc_resources(struct qedr_dev *dev)
 	xa_init_flags(&dev->srqs, XA_FLAGS_LOCK_IRQ);
 
 	if (IS_IWARP(dev)) {
-		xa_init_flags(&dev->qps, XA_FLAGS_LOCK_IRQ);
+		xa_init(&dev->qps);
 		dev->iwarp_wq = create_singlethread_workqueue("qedr_iwarpq");
 	}
 
diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 22881d4442b9..7fea74739c1f 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -739,7 +739,7 @@ void qedr_iw_qp_rem_ref(struct ib_qp *ibqp)
 	struct qedr_qp *qp = get_qedr_qp(ibqp);
 
 	if (atomic_dec_and_test(&qp->refcnt)) {
-		xa_erase_irq(&qp->dev->qps, qp->qp_id);
+		xa_erase(&qp->dev->qps, qp->qp_id);
 		kfree(qp);
 	}
 }
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a7ccca3c4f89..062165935441 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1926,7 +1926,7 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 	qp->ibqp.qp_num = qp->qp_id;
 
 	if (rdma_protocol_iwarp(&dev->ibdev, 1)) {
-		rc = xa_insert_irq(&dev->qps, qp->qp_id, qp, GFP_KERNEL);
+		rc = xa_insert(&dev->qps, qp->qp_id, qp, GFP_KERNEL);
 		if (rc)
 			goto err;
 	}
@@ -2500,7 +2500,7 @@ int qedr_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 
 	if (atomic_dec_and_test(&qp->refcnt) &&
 	    rdma_protocol_iwarp(&dev->ibdev, 1)) {
-		xa_erase_irq(&dev->qps, qp->qp_id);
+		xa_erase(&dev->qps, qp->qp_id);
 		kfree(qp);
 	}
 	return 0;
-- 
2.25.1



