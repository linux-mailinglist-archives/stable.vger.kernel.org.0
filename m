Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83393C4F0E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhGLHW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245673AbhGLHTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84567610A6;
        Mon, 12 Jul 2021 07:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074217;
        bh=YEvTTwEsfdpG3H8tgqy1cjL2d4BGRY2Rt62QaX4OLYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTobiKQk8i0q2cL8iiB8H/KoBHO5RCtnxb4Hw/ClG5LYQ+QEDn+O9zmzcHXNKQLLU
         eUFOuHCs2giHynbE6v0QxoqcVzcJDYZRgIBMuf4mwAZfIfi2VYNec6mcDOL7CFYjjE
         oegDXdVq3nkCz///lM3i2NThTaQ3FDf0Z+2pQIew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 487/700] RDMA/cma: Protect RMW with qp_mutex
Date:   Mon, 12 Jul 2021 08:09:30 +0200
Message-Id: <20210712061028.375472864@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit ca0c448d2b9f43e3175835d536853854ef544e22 ]

The struct rdma_id_private contains three bit-fields, tos_set,
timeout_set, and min_rnr_timer_set. These are set by accessor functions
without any synchronization. If two or all accessor functions are invoked
in close proximity in time, there will be Read-Modify-Write from several
contexts to the same variable, and the result will be intermittent.

Fixed by protecting the bit-fields by the qp_mutex in the accessor
functions.

The consumer of timeout_set and min_rnr_timer_set is in
rdma_init_qp_attr(), which is called with qp_mutex held for connected
QPs. Explicit locking is added for the consumers of tos and tos_set.

This commit depends on ("RDMA/cma: Remove unnecessary INIT->INIT
transition"), since the call to rdma_init_qp_attr() from
cma_init_conn_qp() does not hold the qp_mutex.

Fixes: 2c1619edef61 ("IB/cma: Define option to set ack timeout and pack tos_set")
Fixes: 3aeffc46afde ("IB/cma: Introduce rdma_set_min_rnr_timer()")
Link: https://lore.kernel.org/r/1624369197-24578-3-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5b9022a8c9ec..2f5f384987a2 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2476,8 +2476,10 @@ static int cma_iw_listen(struct rdma_id_private *id_priv, int backlog)
 	if (IS_ERR(id))
 		return PTR_ERR(id);
 
+	mutex_lock(&id_priv->qp_mutex);
 	id->tos = id_priv->tos;
 	id->tos_set = id_priv->tos_set;
+	mutex_unlock(&id_priv->qp_mutex);
 	id_priv->cm_id.iw = id;
 
 	memcpy(&id_priv->cm_id.iw->local_addr, cma_src_addr(id_priv),
@@ -2537,8 +2539,10 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 	cma_id_get(id_priv);
 	dev_id_priv->internal_id = 1;
 	dev_id_priv->afonly = id_priv->afonly;
+	mutex_lock(&id_priv->qp_mutex);
 	dev_id_priv->tos_set = id_priv->tos_set;
 	dev_id_priv->tos = id_priv->tos;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	ret = rdma_listen(&dev_id_priv->id, id_priv->backlog);
 	if (ret)
@@ -2585,8 +2589,10 @@ void rdma_set_service_type(struct rdma_cm_id *id, int tos)
 	struct rdma_id_private *id_priv;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
 	id_priv->tos = (u8) tos;
 	id_priv->tos_set = true;
+	mutex_unlock(&id_priv->qp_mutex);
 }
 EXPORT_SYMBOL(rdma_set_service_type);
 
@@ -2613,8 +2619,10 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
 	id_priv->timeout = timeout;
 	id_priv->timeout_set = true;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	return 0;
 }
@@ -3000,8 +3008,11 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
 					rdma_start_port(id_priv->cma_dev->device)];
-	u8 tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
+	u8 tos;
 
+	mutex_lock(&id_priv->qp_mutex);
+	tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	work = kzalloc(sizeof *work, GFP_KERNEL);
 	if (!work)
@@ -3048,8 +3059,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	 * PacketLifeTime = local ACK timeout/2
 	 * as a reasonable approximation for RoCE networks.
 	 */
+	mutex_lock(&id_priv->qp_mutex);
 	route->path_rec->packet_life_time = id_priv->timeout_set ?
 		id_priv->timeout - 1 : CMA_IBOE_PACKET_LIFETIME;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	if (!route->path_rec->mtu) {
 		ret = -EINVAL;
@@ -4073,8 +4086,11 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
 
+	mutex_lock(&id_priv->qp_mutex);
 	cm_id->tos = id_priv->tos;
 	cm_id->tos_set = id_priv->tos_set;
+	mutex_unlock(&id_priv->qp_mutex);
+
 	id_priv->cm_id.iw = cm_id;
 
 	memcpy(&cm_id->local_addr, cma_src_addr(id_priv),
-- 
2.30.2



