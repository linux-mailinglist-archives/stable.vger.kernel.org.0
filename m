Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47483C5501
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242440AbhGLIIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348248AbhGLH5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 840F661351;
        Mon, 12 Jul 2021 07:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076363;
        bh=dqaUxs9nuJX1JfZx24xwQbOuTODdAGIeNmuHT2RF0Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0YT3XVjGbe8yPaidEt3IUDFpaHoborO/Ct/6tHWSK7ocxyQobbcpxt7msp0PgNMQ
         C55F2rnR60Z4vyOhw9GRotu/tdl+CmtmuEd1Xxd4ubsSFMJTOwPxDFJpbN+0w9AVnY
         ObrHCAxl57EKWLbIzvy8hR4KouBYCkj/5IU4VYzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 568/800] RDMA/cma: Protect RMW with qp_mutex
Date:   Mon, 12 Jul 2021 08:09:51 +0200
Message-Id: <20210712061027.858653810@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
 drivers/infiniband/core/cma.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index ab148a696c0c..a5ec61ac11cc 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2472,8 +2472,10 @@ static int cma_iw_listen(struct rdma_id_private *id_priv, int backlog)
 	if (IS_ERR(id))
 		return PTR_ERR(id);
 
+	mutex_lock(&id_priv->qp_mutex);
 	id->tos = id_priv->tos;
 	id->tos_set = id_priv->tos_set;
+	mutex_unlock(&id_priv->qp_mutex);
 	id->afonly = id_priv->afonly;
 	id_priv->cm_id.iw = id;
 
@@ -2534,8 +2536,10 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 	cma_id_get(id_priv);
 	dev_id_priv->internal_id = 1;
 	dev_id_priv->afonly = id_priv->afonly;
+	mutex_lock(&id_priv->qp_mutex);
 	dev_id_priv->tos_set = id_priv->tos_set;
 	dev_id_priv->tos = id_priv->tos;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	ret = rdma_listen(&dev_id_priv->id, id_priv->backlog);
 	if (ret)
@@ -2582,8 +2586,10 @@ void rdma_set_service_type(struct rdma_cm_id *id, int tos)
 	struct rdma_id_private *id_priv;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
 	id_priv->tos = (u8) tos;
 	id_priv->tos_set = true;
+	mutex_unlock(&id_priv->qp_mutex);
 }
 EXPORT_SYMBOL(rdma_set_service_type);
 
@@ -2610,8 +2616,10 @@ int rdma_set_ack_timeout(struct rdma_cm_id *id, u8 timeout)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
 	id_priv->timeout = timeout;
 	id_priv->timeout_set = true;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	return 0;
 }
@@ -2647,8 +2655,10 @@ int rdma_set_min_rnr_timer(struct rdma_cm_id *id, u8 min_rnr_timer)
 		return -EINVAL;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+	mutex_lock(&id_priv->qp_mutex);
 	id_priv->min_rnr_timer = min_rnr_timer;
 	id_priv->min_rnr_timer_set = true;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	return 0;
 }
@@ -3034,8 +3044,11 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 
 	u8 default_roce_tos = id_priv->cma_dev->default_roce_tos[id_priv->id.port_num -
 					rdma_start_port(id_priv->cma_dev->device)];
-	u8 tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
+	u8 tos;
 
+	mutex_lock(&id_priv->qp_mutex);
+	tos = id_priv->tos_set ? id_priv->tos : default_roce_tos;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	work = kzalloc(sizeof *work, GFP_KERNEL);
 	if (!work)
@@ -3082,8 +3095,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	 * PacketLifeTime = local ACK timeout/2
 	 * as a reasonable approximation for RoCE networks.
 	 */
+	mutex_lock(&id_priv->qp_mutex);
 	route->path_rec->packet_life_time = id_priv->timeout_set ?
 		id_priv->timeout - 1 : CMA_IBOE_PACKET_LIFETIME;
+	mutex_unlock(&id_priv->qp_mutex);
 
 	if (!route->path_rec->mtu) {
 		ret = -EINVAL;
@@ -4107,8 +4122,11 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
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



