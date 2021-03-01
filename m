Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAE832909D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238660AbhCAULU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242280AbhCAT5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:57:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D69BF6537D;
        Mon,  1 Mar 2021 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621341;
        bh=d23VV/IwXj7sdjIIcFM7adswcV2h7QngsXOcB4h81cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfAkgyM3eZmreeoosYHTOZ2lkdP57Xy3JWynGB2I4AbTDYjv4msqHCx5rmwEv1c1w
         G9ES6iyOfYzwHX+GfbBWVJir6Z/u2H70MMTsBiku2vtfKCQ9lbRrGqDhmaWf+2rGYp
         2xQTu9q0wYeirLVr5VKb9y7wuEPDg5YsqwNz5z3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 463/775] RDMA/rtrs-srv: Do not pass a valid pointer to PTR_ERR()
Date:   Mon,  1 Mar 2021 17:10:31 +0100
Message-Id: <20210301161224.437391837@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

[ Upstream commit ed408529679737a9a7ad816c8de5d59ba104bb11 ]

smatch gives the warning:

  drivers/infiniband/ulp/rtrs/rtrs-srv.c:1805 rtrs_rdma_connect() warn: passing zero to 'PTR_ERR'

Which is trying to say smatch has shown that srv is not an error pointer
and thus cannot be passed to PTR_ERR.

The solution is to move the list_add() down after full initilization of
rtrs_srv. To avoid holding the srv_mutex too long, only hold it during the
list operation as suggested by Leon.

Fixes: 03e9b33a0fd6 ("RDMA/rtrs: Only allow addition of path to an already established session")
Link: https://lore.kernel.org/r/20210216143807.65923-1-jinpu.wang@cloud.ionos.com
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 77ec87f1a660b..3850d2a938f8e 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1348,21 +1348,18 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 			return srv;
 		}
 	}
+	mutex_unlock(&ctx->srv_mutex);
 	/*
 	 * If this request is not the first connection request from the
 	 * client for this session then fail and return error.
 	 */
-	if (!first_conn) {
-		mutex_unlock(&ctx->srv_mutex);
+	if (!first_conn)
 		return ERR_PTR(-ENXIO);
-	}
 
 	/* need to allocate a new srv */
 	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
-	if  (!srv) {
-		mutex_unlock(&ctx->srv_mutex);
+	if  (!srv)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	INIT_LIST_HEAD(&srv->paths_list);
 	mutex_init(&srv->paths_mutex);
@@ -1372,8 +1369,6 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	srv->ctx = ctx;
 	device_initialize(&srv->dev);
 	srv->dev.release = rtrs_srv_dev_release;
-	list_add(&srv->ctx_list, &ctx->srv_list);
-	mutex_unlock(&ctx->srv_mutex);
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
@@ -1386,6 +1381,9 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 			goto err_free_chunks;
 	}
 	refcount_set(&srv->refcount, 1);
+	mutex_lock(&ctx->srv_mutex);
+	list_add(&srv->ctx_list, &ctx->srv_list);
+	mutex_unlock(&ctx->srv_mutex);
 
 	return srv;
 
@@ -1800,11 +1798,7 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 	}
 	recon_cnt = le16_to_cpu(msg->recon_cnt);
 	srv = get_or_create_srv(ctx, &msg->paths_uuid, msg->first_conn);
-	/*
-	 * "refcount == 0" happens if a previous thread calls get_or_create_srv
-	 * allocate srv, but chunks of srv are not allocated yet.
-	 */
-	if (IS_ERR(srv) || refcount_read(&srv->refcount) == 0) {
+	if (IS_ERR(srv)) {
 		err = PTR_ERR(srv);
 		goto reject_w_err;
 	}
-- 
2.27.0



