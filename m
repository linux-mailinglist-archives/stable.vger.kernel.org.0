Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E510029B933
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802249AbgJ0PqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801083AbgJ0PjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:12 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C7222281;
        Tue, 27 Oct 2020 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813151;
        bh=oMKaqw5SCbNLXIjrj9VkXS5HQtnhoUp6WOVIfkZ+Ulo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGJMaWVcuy5Xjtv6Wbu5QNK/PzmwBnxlSoDlxQiDtj78eZnykt3axCQd0hHP8NJJK
         EloRx9pyY4nTWvcigGhpVFZr+QiXzwQgL/36SOcsKQHDZiJgG4NBzrYIydX2Ihh4wq
         EUU0OcEyfQjXCMp+/l/4q65PSnkOa22UNQgJn6w4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 455/757] RDMA/cma: Fix use after free race in roce multicast join
Date:   Tue, 27 Oct 2020 14:51:45 +0100
Message-Id: <20201027135511.854653787@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit b5de0c60cc30c2a3513c7188c73f3f29acc29234 ]

The roce path triggers a work queue that continues to touch the id_priv
but doesn't hold any reference on it. Futher, unlike in the IB case, the
work queue is not fenced during rdma_destroy_id().

This can trigger a use after free if a destroy is triggered in the
incredibly narrow window after the queue_work and the work starting and
obtaining the handler_mutex.

The only purpose of this work queue is to run the ULP event callback from
the standard context, so switch the design to use the existing
cma_work_handler() scheme. This simplifies quite a lot of the flow:

- Use the cma_work_handler() callback to launch the work for roce. This
  requires generating the event synchronously inside the
  rdma_join_multicast(), which in turn means the dummy struct
  ib_sa_multicast can become a simple stack variable.

- cm_work_handler() used the id_priv kref, so we can entirely eliminate
  the kref inside struct cma_multicast. Since the cma_multicast never
  leaks into an unprotected work queue the kfree can be done at the same
  time as for IB.

- Eliminating the general multicast.ib requires using cma_set_mgid() in a
  few places to recompute the mgid.

Fixes: 3c86aa70bf67 ("RDMA/cm: Add RDMA CM support for IBoE devices")
Link: https://lore.kernel.org/r/20200902081122.745412-9-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 196 +++++++++++++++-------------------
 1 file changed, 88 insertions(+), 108 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index da2c06850b303..baf0b6ae7a8bb 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -68,6 +68,9 @@ static const char * const cma_events[] = {
 	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 = "timewait exit",
 };
 
+static void cma_set_mgid(struct rdma_id_private *id_priv, struct sockaddr *addr,
+			 union ib_gid *mgid);
+
 const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 {
 	size_t index = event;
@@ -345,13 +348,10 @@ struct ib_device *cma_get_ib_dev(struct cma_device *cma_dev)
 
 struct cma_multicast {
 	struct rdma_id_private *id_priv;
-	union {
-		struct ib_sa_multicast *ib;
-	} multicast;
+	struct ib_sa_multicast *sa_mc;
 	struct list_head	list;
 	void			*context;
 	struct sockaddr_storage	addr;
-	struct kref		mcref;
 	u8			join_state;
 };
 
@@ -363,12 +363,6 @@ struct cma_work {
 	struct rdma_cm_event	event;
 };
 
-struct iboe_mcast_work {
-	struct work_struct	 work;
-	struct rdma_id_private	*id;
-	struct cma_multicast	*mc;
-};
-
 union cma_ip_addr {
 	struct in6_addr ip6;
 	struct {
@@ -477,14 +471,6 @@ static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 					  rdma_start_port(cma_dev->device)];
 }
 
-static inline void release_mc(struct kref *kref)
-{
-	struct cma_multicast *mc = container_of(kref, struct cma_multicast, mcref);
-
-	kfree(mc->multicast.ib);
-	kfree(mc);
-}
-
 static void cma_release_dev(struct rdma_id_private *id_priv)
 {
 	mutex_lock(&lock);
@@ -1780,14 +1766,10 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 static void destroy_mc(struct rdma_id_private *id_priv,
 		       struct cma_multicast *mc)
 {
-	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num)) {
-		ib_sa_free_multicast(mc->multicast.ib);
-		kfree(mc);
-		return;
-	}
+	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num))
+		ib_sa_free_multicast(mc->sa_mc);
 
-	if (rdma_protocol_roce(id_priv->id.device,
-				      id_priv->id.port_num)) {
+	if (rdma_protocol_roce(id_priv->id.device, id_priv->id.port_num)) {
 		struct rdma_dev_addr *dev_addr =
 			&id_priv->id.route.addr.dev_addr;
 		struct net_device *ndev = NULL;
@@ -1796,11 +1778,15 @@ static void destroy_mc(struct rdma_id_private *id_priv,
 			ndev = dev_get_by_index(dev_addr->net,
 						dev_addr->bound_dev_if);
 		if (ndev) {
-			cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid, false);
+			union ib_gid mgid;
+
+			cma_set_mgid(id_priv, (struct sockaddr *)&mc->addr,
+				     &mgid);
+			cma_igmp_send(ndev, &mgid, false);
 			dev_put(ndev);
 		}
-		kref_put(&mc->mcref, release_mc);
 	}
+	kfree(mc);
 }
 
 static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
@@ -2664,6 +2650,8 @@ static void cma_work_handler(struct work_struct *_work)
 	mutex_unlock(&id_priv->handler_mutex);
 	cma_id_put(id_priv);
 out_free:
+	if (work->event.event == RDMA_CM_EVENT_MULTICAST_JOIN)
+		rdma_destroy_ah_attr(&work->event.param.ud.ah_attr);
 	kfree(work);
 }
 
@@ -4280,53 +4268,66 @@ int rdma_disconnect(struct rdma_cm_id *id)
 }
 EXPORT_SYMBOL(rdma_disconnect);
 
+static void cma_make_mc_event(int status, struct rdma_id_private *id_priv,
+			      struct ib_sa_multicast *multicast,
+			      struct rdma_cm_event *event,
+			      struct cma_multicast *mc)
+{
+	struct rdma_dev_addr *dev_addr;
+	enum ib_gid_type gid_type;
+	struct net_device *ndev;
+
+	if (!status)
+		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
+	else
+		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
+				     status);
+
+	event->status = status;
+	event->param.ud.private_data = mc->context;
+	if (status) {
+		event->event = RDMA_CM_EVENT_MULTICAST_ERROR;
+		return;
+	}
+
+	dev_addr = &id_priv->id.route.addr.dev_addr;
+	ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
+	gid_type =
+		id_priv->cma_dev
+			->default_gid_type[id_priv->id.port_num -
+					   rdma_start_port(
+						   id_priv->cma_dev->device)];
+
+	event->event = RDMA_CM_EVENT_MULTICAST_JOIN;
+	if (ib_init_ah_from_mcmember(id_priv->id.device, id_priv->id.port_num,
+				     &multicast->rec, ndev, gid_type,
+				     &event->param.ud.ah_attr)) {
+		event->event = RDMA_CM_EVENT_MULTICAST_ERROR;
+		goto out;
+	}
+
+	event->param.ud.qp_num = 0xFFFFFF;
+	event->param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
+
+out:
+	if (ndev)
+		dev_put(ndev);
+}
+
 static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 {
-	struct rdma_id_private *id_priv;
 	struct cma_multicast *mc = multicast->context;
+	struct rdma_id_private *id_priv = mc->id_priv;
 	struct rdma_cm_event event = {};
 	int ret = 0;
 
-	id_priv = mc->id_priv;
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state != RDMA_CM_ADDR_BOUND &&
 	    id_priv->state != RDMA_CM_ADDR_RESOLVED)
 		goto out;
 
-	if (!status)
-		status = cma_set_qkey(id_priv, be32_to_cpu(multicast->rec.qkey));
-	else
-		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
-				     status);
-	event.status = status;
-	event.param.ud.private_data = mc->context;
-	if (!status) {
-		struct rdma_dev_addr *dev_addr =
-			&id_priv->id.route.addr.dev_addr;
-		struct net_device *ndev =
-			dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
-		enum ib_gid_type gid_type =
-			id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
-			rdma_start_port(id_priv->cma_dev->device)];
-
-		event.event = RDMA_CM_EVENT_MULTICAST_JOIN;
-		ret = ib_init_ah_from_mcmember(id_priv->id.device,
-					       id_priv->id.port_num,
-					       &multicast->rec,
-					       ndev, gid_type,
-					       &event.param.ud.ah_attr);
-		if (ret)
-			event.event = RDMA_CM_EVENT_MULTICAST_ERROR;
-
-		event.param.ud.qp_num = 0xFFFFFF;
-		event.param.ud.qkey = be32_to_cpu(multicast->rec.qkey);
-		if (ndev)
-			dev_put(ndev);
-	} else
-		event.event = RDMA_CM_EVENT_MULTICAST_ERROR;
-
+	cma_make_mc_event(status, id_priv, multicast, &event, mc);
 	ret = cma_cm_event_handler(id_priv, &event);
-
 	rdma_destroy_ah_attr(&event.param.ud.ah_attr);
 	if (ret) {
 		destroy_id_handler_unlock(id_priv);
@@ -4416,23 +4417,10 @@ static int cma_join_ib_multicast(struct rdma_id_private *id_priv,
 			     IB_SA_MCMEMBER_REC_MTU |
 			     IB_SA_MCMEMBER_REC_HOP_LIMIT;
 
-	mc->multicast.ib = ib_sa_join_multicast(&sa_client, id_priv->id.device,
-						id_priv->id.port_num, &rec,
-						comp_mask, GFP_KERNEL,
-						cma_ib_mc_handler, mc);
-	return PTR_ERR_OR_ZERO(mc->multicast.ib);
-}
-
-static void iboe_mcast_work_handler(struct work_struct *work)
-{
-	struct iboe_mcast_work *mw = container_of(work, struct iboe_mcast_work, work);
-	struct cma_multicast *mc = mw->mc;
-	struct ib_sa_multicast *m = mc->multicast.ib;
-
-	mc->multicast.ib->context = mc;
-	cma_ib_mc_handler(0, m);
-	kref_put(&mc->mcref, release_mc);
-	kfree(mw);
+	mc->sa_mc = ib_sa_join_multicast(&sa_client, id_priv->id.device,
+					 id_priv->id.port_num, &rec, comp_mask,
+					 GFP_KERNEL, cma_ib_mc_handler, mc);
+	return PTR_ERR_OR_ZERO(mc->sa_mc);
 }
 
 static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
@@ -4467,52 +4455,47 @@ static void cma_iboe_set_mgid(struct sockaddr *addr, union ib_gid *mgid,
 static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 				   struct cma_multicast *mc)
 {
-	struct iboe_mcast_work *work;
+	struct cma_work *work;
 	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
 	int err = 0;
 	struct sockaddr *addr = (struct sockaddr *)&mc->addr;
 	struct net_device *ndev = NULL;
+	struct ib_sa_multicast ib;
 	enum ib_gid_type gid_type;
 	bool send_only;
 
 	send_only = mc->join_state == BIT(SENDONLY_FULLMEMBER_JOIN);
 
-	if (cma_zero_addr((struct sockaddr *)&mc->addr))
+	if (cma_zero_addr(addr))
 		return -EINVAL;
 
 	work = kzalloc(sizeof *work, GFP_KERNEL);
 	if (!work)
 		return -ENOMEM;
 
-	mc->multicast.ib = kzalloc(sizeof(struct ib_sa_multicast), GFP_KERNEL);
-	if (!mc->multicast.ib) {
-		err = -ENOMEM;
-		goto out1;
-	}
-
 	gid_type = id_priv->cma_dev->default_gid_type[id_priv->id.port_num -
 		   rdma_start_port(id_priv->cma_dev->device)];
-	cma_iboe_set_mgid(addr, &mc->multicast.ib->rec.mgid, gid_type);
+	cma_iboe_set_mgid(addr, &ib.rec.mgid, gid_type);
 
-	mc->multicast.ib->rec.pkey = cpu_to_be16(0xffff);
+	ib.rec.pkey = cpu_to_be16(0xffff);
 	if (id_priv->id.ps == RDMA_PS_UDP)
-		mc->multicast.ib->rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
+		ib.rec.qkey = cpu_to_be32(RDMA_UDP_QKEY);
 
 	if (dev_addr->bound_dev_if)
 		ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
 	if (!ndev) {
 		err = -ENODEV;
-		goto out2;
+		goto err_free;
 	}
-	mc->multicast.ib->rec.rate = iboe_get_rate(ndev);
-	mc->multicast.ib->rec.hop_limit = 1;
-	mc->multicast.ib->rec.mtu = iboe_get_mtu(ndev->mtu);
+	ib.rec.rate = iboe_get_rate(ndev);
+	ib.rec.hop_limit = 1;
+	ib.rec.mtu = iboe_get_mtu(ndev->mtu);
 
 	if (addr->sa_family == AF_INET) {
 		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) {
-			mc->multicast.ib->rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
+			ib.rec.hop_limit = IPV6_DEFAULT_HOPLIMIT;
 			if (!send_only) {
-				err = cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid,
+				err = cma_igmp_send(ndev, &ib.rec.mgid,
 						    true);
 			}
 		}
@@ -4521,24 +4504,22 @@ static int cma_iboe_join_multicast(struct rdma_id_private *id_priv,
 			err = -ENOTSUPP;
 	}
 	dev_put(ndev);
-	if (err || !mc->multicast.ib->rec.mtu) {
+	if (err || !ib.rec.mtu) {
 		if (!err)
 			err = -EINVAL;
-		goto out2;
+		goto err_free;
 	}
 	rdma_ip2gid((struct sockaddr *)&id_priv->id.route.addr.src_addr,
-		    &mc->multicast.ib->rec.port_gid);
+		    &ib.rec.port_gid);
 	work->id = id_priv;
-	work->mc = mc;
-	INIT_WORK(&work->work, iboe_mcast_work_handler);
-	kref_get(&mc->mcref);
+	INIT_WORK(&work->work, cma_work_handler);
+	cma_make_mc_event(0, id_priv, &ib, &work->event, mc);
+	/* Balances with cma_id_put() in cma_work_handler */
+	cma_id_get(id_priv);
 	queue_work(cma_wq, &work->work);
-
 	return 0;
 
-out2:
-	kfree(mc->multicast.ib);
-out1:
+err_free:
 	kfree(work);
 	return err;
 }
@@ -4562,7 +4543,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	    !cma_comp(id_priv, RDMA_CM_ADDR_RESOLVED))
 		return -EINVAL;
 
-	mc = kmalloc(sizeof *mc, GFP_KERNEL);
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL);
 	if (!mc)
 		return -ENOMEM;
 
@@ -4572,7 +4553,6 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	mc->join_state = join_state;
 
 	if (rdma_protocol_roce(id->device, id->port_num)) {
-		kref_init(&mc->mcref);
 		ret = cma_iboe_join_multicast(id_priv, mc);
 		if (ret)
 			goto out_err;
-- 
2.25.1



