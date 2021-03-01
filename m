Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0078B329059
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242461AbhCAUHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:07:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242622AbhCATyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5530E6536E;
        Mon,  1 Mar 2021 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621288;
        bh=xUkRRagtGOgPHdeAXf4E/eHx7WqKFeqmCTh/VHD4KMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q64CGu4fLBaQvk9Tw5VMh+3zRhMld3XkhVZBvCrWw4ATnvyX8IprsPYF+HG5Ge+t+
         XQWLWXN8FtzwtpAfWrjft8tM5DxCsqQlvGmSxWq8eVXCPq97G39jZ7Zh+IV+9bxxCQ
         DppPn/55hZTgN+wwBpa0nu9Y9XbMymjWQWthOM4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Md Haris Iqbal <haris.iqbal@cloud.ionos.com>,
        Lutz Pogrell <lutz.pogrell@cloud.ionos.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 460/775] RDMA/rtrs: Only allow addition of path to an already established session
Date:   Mon,  1 Mar 2021 17:10:28 +0100
Message-Id: <20210301161224.287516390@linuxfoundation.org>
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

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 03e9b33a0fd677f554b03352646c13459bf60458 ]

While adding a path from the client side to an already established
session, it was possible to provide the destination IP to a different
server. This is dangerous.

This commit adds an extra member to the rtrs_msg_conn_req structure, named
first_conn; which is supposed to notify if the connection request is the
first for that session or not.

On the server side, if a session does not exist but the first_conn
received inside the rtrs_msg_conn_req structure is 1, the connection
request is failed. This signifies that the connection request is for an
already existing session, and since the server did not find one, it is an
wrong connection request.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Fixes: 9cb837480424 ("RDMA/rtrs: server: main functionality")
Link: https://lore.kernel.org/r/20210212134525.103456-3-jinpu.wang@cloud.ionos.com
Signed-off-by: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>
Reviewed-by: Lutz Pogrell <lutz.pogrell@cloud.ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c |  7 +++++++
 drivers/infiniband/ulp/rtrs/rtrs-clt.h |  1 +
 drivers/infiniband/ulp/rtrs/rtrs-pri.h |  4 +++-
 drivers/infiniband/ulp/rtrs/rtrs-srv.c | 21 +++++++++++++++------
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 172bf7f221ff0..785cd1cf2a402 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -31,6 +31,8 @@
  */
 #define RTRS_RECONNECT_SEED 8
 
+#define FIRST_CONN 0x01
+
 MODULE_DESCRIPTION("RDMA Transport Client");
 MODULE_LICENSE("GPL");
 
@@ -1662,6 +1664,7 @@ static int rtrs_rdma_route_resolved(struct rtrs_clt_con *con)
 		.cid_num = cpu_to_le16(sess->s.con_num),
 		.recon_cnt = cpu_to_le16(sess->s.recon_cnt),
 	};
+	msg.first_conn = sess->for_new_clt ? FIRST_CONN : 0;
 	uuid_copy(&msg.sess_uuid, &sess->s.uuid);
 	uuid_copy(&msg.paths_uuid, &clt->paths_uuid);
 
@@ -1747,6 +1750,8 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 		scnprintf(sess->hca_name, sizeof(sess->hca_name),
 			  sess->s.dev->ib_dev->name);
 		sess->s.src_addr = con->c.cm_id->route.addr.src_addr;
+		/* set for_new_clt, to allow future reconnect on any path */
+		sess->for_new_clt = 1;
 	}
 
 	return 0;
@@ -2676,6 +2681,8 @@ struct rtrs_clt *rtrs_clt_open(struct rtrs_clt_ops *ops,
 			err = PTR_ERR(sess);
 			goto close_all_sess;
 		}
+		if (!i)
+			sess->for_new_clt = 1;
 		list_add_tail_rcu(&sess->s.entry, &clt->paths_list);
 
 		err = init_sess(sess);
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.h b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
index b8dbd701b3cb2..7c9e155027969 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.h
@@ -143,6 +143,7 @@ struct rtrs_clt_sess {
 	int			max_send_sge;
 	u32			flags;
 	struct kobject		kobj;
+	u8			for_new_clt;
 	struct rtrs_clt_stats	*stats;
 	/* cache hca_port and hca_name to display in sysfs */
 	u8			hca_port;
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-pri.h b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
index d5621e6fad1b1..8caad0a2322bf 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-pri.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-pri.h
@@ -188,7 +188,9 @@ struct rtrs_msg_conn_req {
 	__le16		recon_cnt;
 	uuid_t		sess_uuid;
 	uuid_t		paths_uuid;
-	u8		reserved[12];
+	u8		first_conn : 1;
+	u8		reserved_bits : 7;
+	u8		reserved[11];
 };
 
 /**
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index 1150d50b5d1e4..b6cb09972de55 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -1334,7 +1334,8 @@ static void free_srv(struct rtrs_srv *srv)
 }
 
 static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
-					   const uuid_t *paths_uuid)
+					  const uuid_t *paths_uuid,
+					  bool first_conn)
 {
 	struct rtrs_srv *srv;
 	int i;
@@ -1347,12 +1348,20 @@ static struct rtrs_srv *get_or_create_srv(struct rtrs_srv_ctx *ctx,
 			return srv;
 		}
 	}
+	/*
+	 * If this request is not the first connection request from the
+	 * client for this session then fail and return error.
+	 */
+	if (!first_conn) {
+		mutex_unlock(&ctx->srv_mutex);
+		return ERR_PTR(-ENXIO);
+	}
 
 	/* need to allocate a new srv */
 	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
 	if  (!srv) {
 		mutex_unlock(&ctx->srv_mutex);
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	INIT_LIST_HEAD(&srv->paths_list);
@@ -1387,7 +1396,7 @@ err_free_chunks:
 
 err_free_srv:
 	kfree(srv);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 static void put_srv(struct rtrs_srv *srv)
@@ -1788,13 +1797,13 @@ static int rtrs_rdma_connect(struct rdma_cm_id *cm_id,
 		goto reject_w_econnreset;
 	}
 	recon_cnt = le16_to_cpu(msg->recon_cnt);
-	srv = get_or_create_srv(ctx, &msg->paths_uuid);
+	srv = get_or_create_srv(ctx, &msg->paths_uuid, msg->first_conn);
 	/*
 	 * "refcount == 0" happens if a previous thread calls get_or_create_srv
 	 * allocate srv, but chunks of srv are not allocated yet.
 	 */
-	if (!srv || refcount_read(&srv->refcount) == 0) {
-		err = -ENOMEM;
+	if (IS_ERR(srv) || refcount_read(&srv->refcount) == 0) {
+		err = PTR_ERR(srv);
 		goto reject_w_err;
 	}
 	mutex_lock(&srv->paths_mutex);
-- 
2.27.0



