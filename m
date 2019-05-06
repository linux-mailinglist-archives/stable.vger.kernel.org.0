Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8017314E36
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfEFOmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728510AbfEFOmi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:42:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60B4821479;
        Mon,  6 May 2019 14:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153757;
        bh=6uI36CmgJ0/VrUNZlPf6wESC6TuMMxW77eB9pdUVEBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjP5Kk3R9mpZX1x/J3wg16ewNSy3nMKthLBr8vGdwXyVImFYSUTGjg6Z2jqHqRwJ8
         972kMMbfXIrQQZKqp43L4RSt1Hxurfmjqs/Rg1NYGZvk/4C2khmWDLAh7RMBmSIxkv
         qClsB223JzrxGRQ074byLfuqK/fbcUuysLGVTrJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        Daniel Jurgens <danielj@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.19 85/99] IB/core: Destroy QP if XRC QP fails
Date:   Mon,  6 May 2019 16:32:58 +0200
Message-Id: <20190506143101.688736872@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuval Avnery <yuvalav@mellanox.com>

commit 535005ca8e5e71918d64074032f4b9d4fef8981e upstream.

The open-coded variant missed destroy of SELinux created QP, reuse already
existing ib_detroy_qp() call and use this opportunity to clean
ib_create_qp() from double prints and unclear exit paths.

Reported-by: Parav Pandit <parav@mellanox.com>
Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Daniel Jurgens <danielj@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/verbs.c |   41 +++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1087,8 +1087,8 @@ struct ib_qp *ib_open_qp(struct ib_xrcd
 }
 EXPORT_SYMBOL(ib_open_qp);
 
-static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
-		struct ib_qp_init_attr *qp_init_attr)
+static struct ib_qp *create_xrc_qp(struct ib_qp *qp,
+				   struct ib_qp_init_attr *qp_init_attr)
 {
 	struct ib_qp *real_qp = qp;
 
@@ -1103,10 +1103,10 @@ static struct ib_qp *ib_create_xrc_qp(st
 
 	qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
 			  qp_init_attr->qp_context);
-	if (!IS_ERR(qp))
-		__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
-	else
-		real_qp->device->destroy_qp(real_qp);
+	if (IS_ERR(qp))
+		return qp;
+
+	__ib_insert_xrcd_qp(qp_init_attr->xrcd, real_qp);
 	return qp;
 }
 
@@ -1137,10 +1137,8 @@ struct ib_qp *ib_create_qp(struct ib_pd
 		return qp;
 
 	ret = ib_create_qp_security(qp, device);
-	if (ret) {
-		ib_destroy_qp(qp);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto err;
 
 	qp->real_qp    = qp;
 	qp->qp_type    = qp_init_attr->qp_type;
@@ -1153,8 +1151,15 @@ struct ib_qp *ib_create_qp(struct ib_pd
 	INIT_LIST_HEAD(&qp->sig_mrs);
 	qp->port = 0;
 
-	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT)
-		return ib_create_xrc_qp(qp, qp_init_attr);
+	if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
+		struct ib_qp *xrc_qp = create_xrc_qp(qp, qp_init_attr);
+
+		if (IS_ERR(xrc_qp)) {
+			ret = PTR_ERR(xrc_qp);
+			goto err;
+		}
+		return xrc_qp;
+	}
 
 	qp->event_handler = qp_init_attr->event_handler;
 	qp->qp_context = qp_init_attr->qp_context;
@@ -1181,11 +1186,8 @@ struct ib_qp *ib_create_qp(struct ib_pd
 
 	if (qp_init_attr->cap.max_rdma_ctxs) {
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
-		if (ret) {
-			pr_err("failed to init MR pool ret= %d\n", ret);
-			ib_destroy_qp(qp);
-			return ERR_PTR(ret);
-		}
+		if (ret)
+			goto err;
 	}
 
 	/*
@@ -1198,6 +1200,11 @@ struct ib_qp *ib_create_qp(struct ib_pd
 				 device->attrs.max_sge_rd);
 
 	return qp;
+
+err:
+	ib_destroy_qp(qp);
+	return ERR_PTR(ret);
+
 }
 EXPORT_SYMBOL(ib_create_qp);
 


