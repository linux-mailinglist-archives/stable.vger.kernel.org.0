Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236AB328C7D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240658AbhCASxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:53:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240423AbhCASqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:46:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD2AC64E75;
        Mon,  1 Mar 2021 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619238;
        bh=K0pKmmVxcCGTB4GfbhJf6lyKdWb+XDq6Varbr1WL52A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuhG+D6AZ/64eiLVyc6DHSglbXyRke20brFs5CJC5zwQcTiPmLVwZ1DddtbV1sSta
         1Ltw3XT/trTo5ed1QvCeUSA1v83jhf1y56CkjcOWajFP9KgYxTbEIAk1m/Kn55VZA5
         lpSFNXluy6fyJdmd393S06/CnJrraaIOcofFmI5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/663] RDMA/rtrs-srv: Do not pass a valid pointer to PTR_ERR()
Date:   Mon,  1 Mar 2021 17:10:30 +0100
Message-Id: <20210301161200.760679780@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index 717304c49d0c3..f009a6907169c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1364,21 +1364,18 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
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
@@ -1388,8 +1385,6 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 	srv->ctx = ctx;
 	device_initialize(&srv->dev);
 	srv->dev.release = rtrs_srv_dev_release;
-	list_add(&srv->ctx_list, &ctx->srv_list);
-	mutex_unlock(&ctx->srv_mutex);
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
@@ -1402,6 +1397,9 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 			goto err_free_chunks;
 	}
 	refcount_set(&srv->refcount, 1);
+	mutex_lock(&ctx->srv_mutex);
+	list_add(&srv->ctx_list, &ctx->srv_list);
+	mutex_unlock(&ctx->srv_mutex);
 
 	return srv;
 
@@ -1816,11 +1814,7 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
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



