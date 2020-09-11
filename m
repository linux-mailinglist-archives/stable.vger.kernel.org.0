Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D2266427
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIKQc0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIKPTJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE62422210;
        Fri, 11 Sep 2020 12:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829196;
        bh=eVcYg1cJOefDsu6kms7fDMPDr5i2bdkGkA+Hpm7nYuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7v+1825Fz4yuLgDuq4UUEfq3IcawKemnxKy4/mFBbFcn/NYMMBp1WHtz9S+2TtOH
         pqZYXC3rYitnzWDY6lt3h02Oghx2H7Ohd5vxijo+cMLrmcgJabp2fK2A3N5kjwbCYd
         pLrDhHciXVbLieCND2X5c6Uq9E+oUhvUGq6rTJuc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 05/16] RDMA/cma: Remove unneeded locking for req paths
Date:   Fri, 11 Sep 2020 14:47:22 +0200
Message-Id: <20200911122459.843026940@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122459.585735377@linuxfoundation.org>
References: <20200911122459.585735377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit cc9c037343898eb7a775e6b81d092ee21eeff218 ]

The REQ flows are concerned that once the handler is called on the new
cm_id the ULP can choose to trigger a rdma_destroy_id() concurrently at
any time.

However, this is not true, while the ULP can call rdma_destroy_id(), it
immediately blocks on the handler_mutex which prevents anything harmful
from running concurrently.

Remove the confusing extra locking and refcounts and make the
handler_mutex protecting state during destroy more clear.

Link: https://lore.kernel.org/r/20200723070707.1771101-4-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 04151c301e851..11f43204fee77 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1831,21 +1831,21 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 
 void rdma_destroy_id(struct rdma_cm_id *id)
 {
-	struct rdma_id_private *id_priv;
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
 	enum rdma_cm_state state;
 
-	id_priv = container_of(id, struct rdma_id_private, id);
-	trace_cm_id_destroy(id_priv);
-	state = cma_exch(id_priv, RDMA_CM_DESTROYING);
-	cma_cancel_operation(id_priv, state);
-
 	/*
 	 * Wait for any active callback to finish.  New callbacks will find
 	 * the id_priv state set to destroying and abort.
 	 */
 	mutex_lock(&id_priv->handler_mutex);
+	trace_cm_id_destroy(id_priv);
+	state = cma_exch(id_priv, RDMA_CM_DESTROYING);
 	mutex_unlock(&id_priv->handler_mutex);
 
+	cma_cancel_operation(id_priv, state);
+
 	rdma_restrack_del(&id_priv->res);
 	if (id_priv->cma_dev) {
 		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
@@ -2205,19 +2205,9 @@ static int cma_ib_req_handler(struct ib_cm_id *cm_id,
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
-	/*
-	 * Protect against the user destroying conn_id from another thread
-	 * until we're done accessing it.
-	 */
-	cma_id_get(conn_id);
 	ret = cma_cm_event_handler(conn_id, &event);
 	if (ret)
 		goto err3;
-	/*
-	 * Acquire mutex to prevent user executing rdma_destroy_id()
-	 * while we're accessing the cm_id.
-	 */
-	mutex_lock(&lock);
 	if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 	    (conn_id->id.qp_type != IB_QPT_UD)) {
 		trace_cm_send_mra(cm_id->context);
@@ -2226,13 +2216,11 @@ static int cma_ib_req_handler(struct ib_cm_id *cm_id,
 	mutex_unlock(&lock);
 	mutex_unlock(&conn_id->handler_mutex);
 	mutex_unlock(&listen_id->handler_mutex);
-	cma_id_put(conn_id);
 	if (net_dev)
 		dev_put(net_dev);
 	return 0;
 
 err3:
-	cma_id_put(conn_id);
 	/* Destroy the CM ID by returning a non-zero value. */
 	conn_id->cm_id.ib = NULL;
 err2:
@@ -2409,11 +2397,6 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	memcpy(cma_src_addr(conn_id), laddr, rdma_addr_size(laddr));
 	memcpy(cma_dst_addr(conn_id), raddr, rdma_addr_size(raddr));
 
-	/*
-	 * Protect against the user destroying conn_id from another thread
-	 * until we're done accessing it.
-	 */
-	cma_id_get(conn_id);
 	ret = cma_cm_event_handler(conn_id, &event);
 	if (ret) {
 		/* User wants to destroy the CM ID */
@@ -2421,13 +2404,11 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		cma_exch(conn_id, RDMA_CM_DESTROYING);
 		mutex_unlock(&conn_id->handler_mutex);
 		mutex_unlock(&listen_id->handler_mutex);
-		cma_id_put(conn_id);
 		rdma_destroy_id(&conn_id->id);
 		return ret;
 	}
 
 	mutex_unlock(&conn_id->handler_mutex);
-	cma_id_put(conn_id);
 
 out:
 	mutex_unlock(&listen_id->handler_mutex);
-- 
2.25.1



