Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCE37CD95
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236252AbhELQ4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243993AbhELQmW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2017A61C5B;
        Wed, 12 May 2021 16:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835756;
        bh=qYZsLFiEcMAcRQ/VB1HSXD+ll6OTncUh9ekmxuMEqqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y7O6kPaZ1zRmUlgb9MVhEQUxu4pE8EvJ8yqaF8YncnPiwQrYOeuMHEW22vy1bcVhT
         TNtmcBtx9HzI5HREqRmr8eFyL2r8+TB7NJxNYnChOmr46RolV2XCo3vx8nGOwzOgDz
         EbXcVsP9GJtK2I7fn5I5+Cb6hu2b0Q6cS3dBrVYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Sagi Grimberg <sagi@grimberg.me>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 472/677] IB/isert: Fix a use after free in isert_connect_request
Date:   Wed, 12 May 2021 16:48:38 +0200
Message-Id: <20210512144853.040391996@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit adb76a520d068a54ee5ca82e756cf8e5a47363a4 ]

The device is got by isert_device_get() with refcount is 1, and is
assigned to isert_conn by
  isert_conn->device = device.

When isert_create_qp() failed, device will be freed with
isert_device_put().

Later, the device is used in isert_free_login_buf(isert_conn) by the
isert_conn->device->ib_device statement.

Free the device in the correct order.

Fixes: ae9ea9ed38c9 ("iser-target: Split some logic in isert_connect_request to routines")
Link: https://lore.kernel.org/r/20210322161325.7491-1-lyl2019@mail.ustc.edu.cn
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Acked-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7305ed8976c2..18266f07c58d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -438,23 +438,23 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	isert_init_conn(isert_conn);
 	isert_conn->cm_id = cma_id;
 
-	ret = isert_alloc_login_buf(isert_conn, cma_id->device);
-	if (ret)
-		goto out;
-
 	device = isert_device_get(cma_id);
 	if (IS_ERR(device)) {
 		ret = PTR_ERR(device);
-		goto out_rsp_dma_map;
+		goto out;
 	}
 	isert_conn->device = device;
 
+	ret = isert_alloc_login_buf(isert_conn, cma_id->device);
+	if (ret)
+		goto out_conn_dev;
+
 	isert_set_nego_params(isert_conn, &event->param.conn);
 
 	isert_conn->qp = isert_create_qp(isert_conn, cma_id);
 	if (IS_ERR(isert_conn->qp)) {
 		ret = PTR_ERR(isert_conn->qp);
-		goto out_conn_dev;
+		goto out_rsp_dma_map;
 	}
 
 	ret = isert_login_post_recv(isert_conn);
@@ -473,10 +473,10 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 
 out_destroy_qp:
 	isert_destroy_qp(isert_conn);
-out_conn_dev:
-	isert_device_put(device);
 out_rsp_dma_map:
 	isert_free_login_buf(isert_conn);
+out_conn_dev:
+	isert_device_put(device);
 out:
 	kfree(isert_conn);
 	rdma_reject(cma_id, NULL, 0, IB_CM_REJ_CONSUMER_DEFINED);
-- 
2.30.2



