Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F122E3C4D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407971AbgL1OAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:34674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436533AbgL1OAu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:00:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2375D207B2;
        Mon, 28 Dec 2020 14:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164009;
        bh=XFKsSf6xlXJGXL6zIx7OyhT901UWKf7RDBCuS/+XY/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9oT2O1Jk3yMOM6TaHlo2YUdfDy63Wv6Mtc96kW0VjkWh6zNpkg7UJUkxpFXe8+Su
         nE/G6ZRVO2AX0aKTKCJ7iZkx4yPSA/lZ8lgavQoclJClwPeiviHkDME6YlvgOUYGKX
         cq7Q/QOUBwsmJAy/xKQyGwBqzUBCDC7hsj35bp2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 028/717] RDMA/rtrs-srv: Dont guard the whole __alloc_srv with srv_mutex
Date:   Mon, 28 Dec 2020 13:40:26 +0100
Message-Id: <20201228125022.335340168@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>

[ Upstream commit d715ff8acbd5876549ef2b21b755ed919f40dcc1 ]

The purpose of srv_mutex is to protect srv_list as in put_srv, so no need
to hold it when allocate memory for srv since it could be time consuming.

Otherwise if one machine has limited memory, rsrv_close_work could be
blocked for a longer time due to the mutex is held by get_or_create_srv
since it can't get memory in time.

  INFO: task kworker/1:1:27478 blocked for more than 120 seconds.
        Tainted: G           O    4.14.171-1-storage #4.14.171-1.3~deb9
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  kworker/1:1     D    0 27478      2 0x80000000
  Workqueue: rtrs_server_wq rtrs_srv_close_work [rtrs_server]
  Call Trace:
   ? __schedule+0x38c/0x7e0
   schedule+0x32/0x80
   schedule_preempt_disabled+0xa/0x10
   __mutex_lock.isra.2+0x25e/0x4d0
   ? put_srv+0x44/0x100 [rtrs_server]
   put_srv+0x44/0x100 [rtrs_server]
   rtrs_srv_close_work+0x16c/0x280 [rtrs_server]
   process_one_work+0x1c5/0x3c0
   worker_thread+0x47/0x3e0
   kthread+0xfc/0x130
   ? trace_event_raw_event_workqueue_execute_start+0xa0/0xa0
   ? kthread_create_on_node+0x70/0x70
   ret_from_fork+0x1f/0x30

Let's move all the logics from __find_srv_and_get and __alloc_srv to
get_or_create_srv, and remove the two functions. Then it should be safe
for multiple processes to access the same srv since it is protected with
srv_mutex.

And since we don't want to allocate chunks with srv_mutex held, let's
check the srv->refcount after get srv because the chunks could not be
allocated yet.

Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20201023074353.21946-6-jinpu.wang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 86 +++++++++++---------------
 1 file changed, 37 insertions(+), 49 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index d6f93601712e4..1cb778aff3c59 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1328,17 +1328,42 @@ static void rtrs_srv_dev_release(struct device *dev)
 	kfree(srv);
 }
 
-static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
-				     const uuid_t *paths_uuid)
+static void free_srv(struct rtrs_srv *srv)
+{
+	int i;
+
+	WARN_ON(refcount_read(&srv->refcount));
+	for (i = 0; i < srv->queue_depth; i++)
+		mempool_free(srv->chunks[i], chunk_pool);
+	kfree(srv->chunks);
+	mutex_destroy(&srv->paths_mutex);
+	mutex_destroy(&srv->paths_ev_mutex);
+	/* last put to release the srv structure */
+	put_device(&srv->dev);
+}
+
+static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
+					   const uuid_t *paths_uuid)
 {
 	struct rtrs_srv *srv;
 	int i;
 
+	mutex_lock(&ctx->srv_mutex);
+	list_for_each_entry(srv, &ctx->srv_list, ctx_list) {
+		if (uuid_equal(&srv->paths_uuid, paths_uuid) &&
+		    refcount_inc_not_zero(&srv->refcount)) {
+			mutex_unlock(&ctx->srv_mutex);
+			return srv;
+		}
+	}
+
+	/* need to allocate a new srv */
 	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
-	if  (!srv)
+	if  (!srv) {
+		mutex_unlock(&ctx->srv_mutex);
 		return NULL;
+	}
 
-	refcount_set(&srv->refcount, 1);
 	INIT_LIST_HEAD(&srv->paths_list);
 	mutex_init(&srv->paths_mutex);
 	mutex_init(&srv->paths_ev_mutex);
@@ -1347,6 +1372,8 @@ static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 	srv->ctx = ctx;
 	device_initialize(&srv->dev);
 	srv->dev.release = rtrs_srv_dev_release;
+	list_add(&srv->ctx_list, &ctx->srv_list);
+	mutex_unlock(&ctx->srv_mutex);
 
 	srv->chunks = kcalloc(srv->queue_depth, sizeof(*srv->chunks),
 			      GFP_KERNEL);
@@ -1358,7 +1385,7 @@ static struct rtrs_srv *__alloc_srv(struct rtrs_srv_ctx *ctx,
 		if (!srv->chunks[i])
 			goto err_free_chunks;
 	}
-	list_add(&srv->ctx_list, &ctx->srv_list);
+	refcount_set(&srv->refcount, 1);
 
 	return srv;
 
@@ -1369,52 +1396,9 @@ err_free_chunks:
 
 err_free_srv:
 	kfree(srv);
-
 	return NULL;
 }
 
-static void free_srv(struct rtrs_srv *srv)
-{
-	int i;
-
-	WARN_ON(refcount_read(&srv->refcount));
-	for (i = 0; i < srv->queue_depth; i++)
-		mempool_free(srv->chunks[i], chunk_pool);
-	kfree(srv->chunks);
-	mutex_destroy(&srv->paths_mutex);
-	mutex_destroy(&srv->paths_ev_mutex);
-	/* last put to release the srv structure */
-	put_device(&srv->dev);
-}
-
-static inline struct rtrs_srv *__find_srv_and_get(struct rtrs_srv_ctx *ctx,
-						   const uuid_t *paths_uuid)
-{
-	struct rtrs_srv *srv;
-
-	list_for_each_entry(srv, &ctx->srv_list, ctx_list) {
-		if (uuid_equal(&srv->paths_uuid, paths_uuid) &&
-		    refcount_inc_not_zero(&srv->refcount))
-			return srv;
-	}
-
-	return NULL;
-}
-
-static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
-					   const uuid_t *paths_uuid)
-{
-	struct rtrs_srv *srv;
-
-	mutex_lock(&ctx->srv_mutex);
-	srv = __find_srv_and_get(ctx, paths_uuid);
-	if (!srv)
-		srv = __alloc_srv(ctx, paths_uuid);
-	mutex_unlock(&ctx->srv_mutex);
-
-	return srv;
-}
-
 static void put_srv(struct rtrs_srv *srv)
 {
 	if (refcount_dec_and_test(&srv->refcount)) {
@@ -1813,7 +1797,11 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 	}
 	recon_cnt = le16_to_cpu(msg->recon_cnt);
 	srv = get_or_create_srv(ctx, &msg->paths_uuid);
-	if (!srv) {
+	/*
+	 * "refcount == 0" happens if a previous thread calls get_or_create_srv
+	 * allocate srv, but chunks of srv are not allocated yet.
+	 */
+	if (!srv || refcount_read(&srv->refcount) == 0) {
 		err = -ENOMEM;
 		goto reject_w_err;
 	}
-- 
2.27.0



