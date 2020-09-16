Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECEA26B5AC
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIOXtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58CA323BDC;
        Tue, 15 Sep 2020 14:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179871;
        bh=PCPEi+qWb3KNRwh88ur9KAcL2yz0Ft5mpU4VDxqv+Io=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTyGEA7nEanGH4GzO105cEfOAxfY4P3NjcBfv6zx6cvAXpm5iHZ5CMQV99gnDgisd
         WjuKLbvFFzJyKJ29YuydszRqGMWH6S/hBfs68VLekRI5RppJTrBzYIT46zewATQ4V3
         ac8UIsDftghkThUPjh1o4WhXzxfJnvTiRgiNdZ4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 019/177] RDMA/bnxt_re: Fix the qp table indexing
Date:   Tue, 15 Sep 2020 16:11:30 +0200
Message-Id: <20200915140654.568351104@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 84cf229f4001c1216afc3e4c7f05e1620a0dd4bc ]

qp->id can be a value outside the max number of qp. Indexing the qp table
with the id can cause out of bounds crash. So changing the qp table
indexing by (qp->id % max_qp -1).

Allocating one extra entry for QP1. Some adapters create one more than the
max_qp requested to accommodate QP1.  If the qp->id is 1, store the
inforamtion in the last entry of the qp table.

Fixes: f218d67ef004 ("RDMA/bnxt_re: Allow posting when QPs are in error")
Link: https://lore.kernel.org/r/1598292876-26529-4-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c   | 22 ++++++++++++++--------
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 10 ++++++----
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.h |  5 +++++
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index c5e29577cd434..b217208f6bcce 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -796,6 +796,7 @@ int bnxt_qplib_create_qp1(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	u16 cmd_flags = 0;
 	u32 qp_flags = 0;
 	u8 pg_sz_lvl;
+	u32 tbl_indx;
 	int rc;
 
 	RCFW_CMD_PREP(req, CREATE_QP1, cmd_flags);
@@ -891,8 +892,9 @@ int bnxt_qplib_create_qp1(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		rq->dbinfo.xid = qp->id;
 		rq->dbinfo.db = qp->dpi->dbr;
 	}
-	rcfw->qp_tbl[qp->id].qp_id = qp->id;
-	rcfw->qp_tbl[qp->id].qp_handle = (void *)qp;
+	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
+	rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
+	rcfw->qp_tbl[tbl_indx].qp_handle = (void *)qp;
 
 	return 0;
 
@@ -950,6 +952,7 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 	u32 qp_flags = 0;
 	u8 pg_sz_lvl;
 	u16 max_rsge;
+	u32 tbl_indx;
 
 	RCFW_CMD_PREP(req, CREATE_QP, cmd_flags);
 
@@ -1118,8 +1121,9 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 		rq->dbinfo.xid = qp->id;
 		rq->dbinfo.db = qp->dpi->dbr;
 	}
-	rcfw->qp_tbl[qp->id].qp_id = qp->id;
-	rcfw->qp_tbl[qp->id].qp_handle = (void *)qp;
+	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
+	rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
+	rcfw->qp_tbl[tbl_indx].qp_handle = (void *)qp;
 
 	return 0;
 
@@ -1467,10 +1471,12 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	struct cmdq_destroy_qp req;
 	struct creq_destroy_qp_resp resp;
 	u16 cmd_flags = 0;
+	u32 tbl_indx;
 	int rc;
 
-	rcfw->qp_tbl[qp->id].qp_id = BNXT_QPLIB_QP_ID_INVALID;
-	rcfw->qp_tbl[qp->id].qp_handle = NULL;
+	tbl_indx = map_qp_id_to_tbl_indx(qp->id, rcfw);
+	rcfw->qp_tbl[tbl_indx].qp_id = BNXT_QPLIB_QP_ID_INVALID;
+	rcfw->qp_tbl[tbl_indx].qp_handle = NULL;
 
 	RCFW_CMD_PREP(req, DESTROY_QP, cmd_flags);
 
@@ -1478,8 +1484,8 @@ int bnxt_qplib_destroy_qp(struct bnxt_qplib_res *res,
 	rc = bnxt_qplib_rcfw_send_message(rcfw, (void *)&req,
 					  (void *)&resp, NULL, 0);
 	if (rc) {
-		rcfw->qp_tbl[qp->id].qp_id = qp->id;
-		rcfw->qp_tbl[qp->id].qp_handle = qp;
+		rcfw->qp_tbl[tbl_indx].qp_id = qp->id;
+		rcfw->qp_tbl[tbl_indx].qp_handle = qp;
 		return rc;
 	}
 
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index 4e211162acee2..f7736e34ac64c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -307,14 +307,15 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 	__le16  mcookie;
 	u16 cookie;
 	int rc = 0;
-	u32 qp_id;
+	u32 qp_id, tbl_indx;
 
 	pdev = rcfw->pdev;
 	switch (qp_event->event) {
 	case CREQ_QP_EVENT_EVENT_QP_ERROR_NOTIFICATION:
 		err_event = (struct creq_qp_error_notification *)qp_event;
 		qp_id = le32_to_cpu(err_event->xid);
-		qp = rcfw->qp_tbl[qp_id].qp_handle;
+		tbl_indx = map_qp_id_to_tbl_indx(qp_id, rcfw);
+		qp = rcfw->qp_tbl[tbl_indx].qp_handle;
 		dev_dbg(&pdev->dev, "Received QP error notification\n");
 		dev_dbg(&pdev->dev,
 			"qpid 0x%x, req_err=0x%x, resp_err=0x%x\n",
@@ -615,8 +616,9 @@ int bnxt_qplib_alloc_rcfw_channel(struct bnxt_qplib_res *res,
 
 	cmdq->bmap_size = bmap_size;
 
-	rcfw->qp_tbl_size = qp_tbl_sz;
-	rcfw->qp_tbl = kcalloc(qp_tbl_sz, sizeof(struct bnxt_qplib_qp_node),
+	/* Allocate one extra to hold the QP1 entries */
+	rcfw->qp_tbl_size = qp_tbl_sz + 1;
+	rcfw->qp_tbl = kcalloc(rcfw->qp_tbl_size, sizeof(struct bnxt_qplib_qp_node),
 			       GFP_KERNEL);
 	if (!rcfw->qp_tbl)
 		goto fail;
diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
index 157387636d004..5f2f0a5a3560f 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.h
@@ -216,4 +216,9 @@ int bnxt_qplib_deinit_rcfw(struct bnxt_qplib_rcfw *rcfw);
 int bnxt_qplib_init_rcfw(struct bnxt_qplib_rcfw *rcfw,
 			 struct bnxt_qplib_ctx *ctx, int is_virtfn);
 void bnxt_qplib_mark_qp_error(void *qp_handle);
+static inline u32 map_qp_id_to_tbl_indx(u32 qid, struct bnxt_qplib_rcfw *rcfw)
+{
+	/* Last index of the qp_tbl is for QP1 ie. qp_tbl_size - 1*/
+	return (qid == 1) ? rcfw->qp_tbl_size - 1 : qid % rcfw->qp_tbl_size - 2;
+}
 #endif /* __BNXT_QPLIB_RCFW_H__ */
-- 
2.25.1



