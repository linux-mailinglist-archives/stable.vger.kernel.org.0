Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3CA2661F9
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 17:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIKPT2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 11:19:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgIKPRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:17:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79F582224C;
        Fri, 11 Sep 2020 12:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829199;
        bh=gVdJQgmK1o0Su//kIWr0ng4eIp3DNniMdlIqldaObxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3RzWYJjHxA/JoTiLu2zPiVIeWldXiPgT0oXBP0wBkiwgYqtfu55iZyEh4fpjZ5ZF
         aAfXcNjYo2YXEGbcNC64HzfbWzl81ZxU4DD9kpPxXBTkbBEJKO9ndu9t1KENK3f2UT
         HpF1jZkMI/9xM3N6U7rjkr0DAFs+sVwA1GTgugMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+08092148130652a6faae@syzkaller.appspotmail.com,
        syzbot+a929647172775e335941@syzkaller.appspotmail.com,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 06/16] RDMA/cma: Execute rdma_cm destruction from a handler properly
Date:   Fri, 11 Sep 2020 14:47:23 +0200
Message-Id: <20200911122459.892960443@linuxfoundation.org>
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

[ Upstream commit f6a9d47ae6854980fc4b1676f1fe9f9fa45ea4e2 ]

When a rdma_cm_id needs to be destroyed after a handler callback fails,
part of the destruction pattern is open coded into each call site.

Unfortunately the blind assignment to state discards important information
needed to do cma_cancel_operation(). This results in active operations
being left running after rdma_destroy_id() completes, and the
use-after-free bugs from KASAN.

Consolidate this entire pattern into destroy_id_handler_unlock() and
manage the locking correctly. The state should be set to
RDMA_CM_DESTROYING under the handler_lock to atomically ensure no futher
handlers are called.

Link: https://lore.kernel.org/r/20200723070707.1771101-5-leon@kernel.org
Reported-by: syzbot+08092148130652a6faae@syzkaller.appspotmail.com
Reported-by: syzbot+a929647172775e335941@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c |  174 ++++++++++++++++++++----------------------
 1 file changed, 84 insertions(+), 90 deletions(-)

--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -428,19 +428,6 @@ static int cma_comp_exch(struct rdma_id_
 	return ret;
 }
 
-static enum rdma_cm_state cma_exch(struct rdma_id_private *id_priv,
-				   enum rdma_cm_state exch)
-{
-	unsigned long flags;
-	enum rdma_cm_state old;
-
-	spin_lock_irqsave(&id_priv->lock, flags);
-	old = id_priv->state;
-	id_priv->state = exch;
-	spin_unlock_irqrestore(&id_priv->lock, flags);
-	return old;
-}
-
 static inline u8 cma_get_ip_ver(const struct cma_hdr *hdr)
 {
 	return hdr->ip_version >> 4;
@@ -1829,21 +1816,9 @@ static void cma_leave_mc_groups(struct r
 	}
 }
 
-void rdma_destroy_id(struct rdma_cm_id *id)
+static void _destroy_id(struct rdma_id_private *id_priv,
+			enum rdma_cm_state state)
 {
-	struct rdma_id_private *id_priv =
-		container_of(id, struct rdma_id_private, id);
-	enum rdma_cm_state state;
-
-	/*
-	 * Wait for any active callback to finish.  New callbacks will find
-	 * the id_priv state set to destroying and abort.
-	 */
-	mutex_lock(&id_priv->handler_mutex);
-	trace_cm_id_destroy(id_priv);
-	state = cma_exch(id_priv, RDMA_CM_DESTROYING);
-	mutex_unlock(&id_priv->handler_mutex);
-
 	cma_cancel_operation(id_priv, state);
 
 	rdma_restrack_del(&id_priv->res);
@@ -1874,6 +1849,42 @@ void rdma_destroy_id(struct rdma_cm_id *
 	put_net(id_priv->id.route.addr.dev_addr.net);
 	kfree(id_priv);
 }
+
+/*
+ * destroy an ID from within the handler_mutex. This ensures that no other
+ * handlers can start running concurrently.
+ */
+static void destroy_id_handler_unlock(struct rdma_id_private *id_priv)
+	__releases(&idprv->handler_mutex)
+{
+	enum rdma_cm_state state;
+	unsigned long flags;
+
+	trace_cm_id_destroy(id_priv);
+
+	/*
+	 * Setting the state to destroyed under the handler mutex provides a
+	 * fence against calling handler callbacks. If this is invoked due to
+	 * the failure of a handler callback then it guarentees that no future
+	 * handlers will be called.
+	 */
+	lockdep_assert_held(&id_priv->handler_mutex);
+	spin_lock_irqsave(&id_priv->lock, flags);
+	state = id_priv->state;
+	id_priv->state = RDMA_CM_DESTROYING;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+	mutex_unlock(&id_priv->handler_mutex);
+	_destroy_id(id_priv, state);
+}
+
+void rdma_destroy_id(struct rdma_cm_id *id)
+{
+	struct rdma_id_private *id_priv =
+		container_of(id, struct rdma_id_private, id);
+
+	mutex_lock(&id_priv->handler_mutex);
+	destroy_id_handler_unlock(id_priv);
+}
 EXPORT_SYMBOL(rdma_destroy_id);
 
 static int cma_rep_recv(struct rdma_id_private *id_priv)
@@ -1938,7 +1949,7 @@ static int cma_ib_handler(struct ib_cm_i
 {
 	struct rdma_id_private *id_priv = cm_id->context;
 	struct rdma_cm_event event = {};
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if ((ib_event->event != IB_CM_TIMEWAIT_EXIT &&
@@ -2007,14 +2018,12 @@ static int cma_ib_handler(struct ib_cm_i
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 out:
 	mutex_unlock(&id_priv->handler_mutex);
-	return ret;
+	return 0;
 }
 
 static struct rdma_id_private *
@@ -2176,7 +2185,7 @@ static int cma_ib_req_handler(struct ib_
 	mutex_lock(&listen_id->handler_mutex);
 	if (listen_id->state != RDMA_CM_LISTEN) {
 		ret = -ECONNABORTED;
-		goto err1;
+		goto err_unlock;
 	}
 
 	offset = cma_user_data_offset(listen_id);
@@ -2193,43 +2202,38 @@ static int cma_ib_req_handler(struct ib_
 	}
 	if (!conn_id) {
 		ret = -ENOMEM;
-		goto err1;
+		goto err_unlock;
 	}
 
 	mutex_lock_nested(&conn_id->handler_mutex, SINGLE_DEPTH_NESTING);
 	ret = cma_ib_acquire_dev(conn_id, listen_id, &req);
-	if (ret)
-		goto err2;
+	if (ret) {
+		destroy_id_handler_unlock(conn_id);
+		goto err_unlock;
+	}
 
 	conn_id->cm_id.ib = cm_id;
 	cm_id->context = conn_id;
 	cm_id->cm_handler = cma_ib_handler;
 
 	ret = cma_cm_event_handler(conn_id, &event);
-	if (ret)
-		goto err3;
+	if (ret) {
+		/* Destroy the CM ID by returning a non-zero value. */
+		conn_id->cm_id.ib = NULL;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		goto net_dev_put;
+	}
+
 	if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 	    (conn_id->id.qp_type != IB_QPT_UD)) {
 		trace_cm_send_mra(cm_id->context);
 		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 	}
-	mutex_unlock(&lock);
 	mutex_unlock(&conn_id->handler_mutex);
-	mutex_unlock(&listen_id->handler_mutex);
-	if (net_dev)
-		dev_put(net_dev);
-	return 0;
 
-err3:
-	/* Destroy the CM ID by returning a non-zero value. */
-	conn_id->cm_id.ib = NULL;
-err2:
-	cma_exch(conn_id, RDMA_CM_DESTROYING);
-	mutex_unlock(&conn_id->handler_mutex);
-err1:
+err_unlock:
 	mutex_unlock(&listen_id->handler_mutex);
-	if (conn_id)
-		rdma_destroy_id(&conn_id->id);
 
 net_dev_put:
 	if (net_dev)
@@ -2329,9 +2333,7 @@ static int cma_iw_handler(struct iw_cm_i
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.iw = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 
@@ -2378,16 +2380,16 @@ static int iw_conn_req_handler(struct iw
 
 	ret = rdma_translate_ip(laddr, &conn_id->id.route.addr.dev_addr);
 	if (ret) {
-		mutex_unlock(&conn_id->handler_mutex);
-		rdma_destroy_id(new_cm_id);
-		goto out;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		return ret;
 	}
 
 	ret = cma_iw_acquire_dev(conn_id, listen_id);
 	if (ret) {
-		mutex_unlock(&conn_id->handler_mutex);
-		rdma_destroy_id(new_cm_id);
-		goto out;
+		mutex_unlock(&listen_id->handler_mutex);
+		destroy_id_handler_unlock(conn_id);
+		return ret;
 	}
 
 	conn_id->cm_id.iw = cm_id;
@@ -2401,10 +2403,8 @@ static int iw_conn_req_handler(struct iw
 	if (ret) {
 		/* User wants to destroy the CM ID */
 		conn_id->cm_id.iw = NULL;
-		cma_exch(conn_id, RDMA_CM_DESTROYING);
-		mutex_unlock(&conn_id->handler_mutex);
 		mutex_unlock(&listen_id->handler_mutex);
-		rdma_destroy_id(&conn_id->id);
+		destroy_id_handler_unlock(conn_id);
 		return ret;
 	}
 
@@ -2644,21 +2644,21 @@ static void cma_work_handler(struct work
 {
 	struct cma_work *work = container_of(_work, struct cma_work, work);
 	struct rdma_id_private *id_priv = work->id;
-	int destroy = 0;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (!cma_comp_exch(id_priv, work->old_state, work->new_state))
-		goto out;
+		goto out_unlock;
 
 	if (cma_cm_event_handler(id_priv, &work->event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		destroy = 1;
+		cma_id_put(id_priv);
+		destroy_id_handler_unlock(id_priv);
+		goto out_free;
 	}
-out:
+
+out_unlock:
 	mutex_unlock(&id_priv->handler_mutex);
 	cma_id_put(id_priv);
-	if (destroy)
-		rdma_destroy_id(&id_priv->id);
+out_free:
 	kfree(work);
 }
 
@@ -2666,23 +2666,22 @@ static void cma_ndev_work_handler(struct
 {
 	struct cma_ndev_work *work = container_of(_work, struct cma_ndev_work, work);
 	struct rdma_id_private *id_priv = work->id;
-	int destroy = 0;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state == RDMA_CM_DESTROYING ||
 	    id_priv->state == RDMA_CM_DEVICE_REMOVAL)
-		goto out;
+		goto out_unlock;
 
 	if (cma_cm_event_handler(id_priv, &work->event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		destroy = 1;
+		cma_id_put(id_priv);
+		destroy_id_handler_unlock(id_priv);
+		goto out_free;
 	}
 
-out:
+out_unlock:
 	mutex_unlock(&id_priv->handler_mutex);
 	cma_id_put(id_priv);
-	if (destroy)
-		rdma_destroy_id(&id_priv->id);
+out_free:
 	kfree(work);
 }
 
@@ -3158,9 +3157,7 @@ static void addr_handler(int status, str
 		event.event = RDMA_CM_EVENT_ADDR_RESOLVED;
 
 	if (cma_cm_event_handler(id_priv, &event)) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return;
 	}
 out:
@@ -3777,7 +3774,7 @@ static int cma_sidr_rep_handler(struct i
 	struct rdma_cm_event event = {};
 	const struct ib_cm_sidr_rep_event_param *rep =
 				&ib_event->param.sidr_rep_rcvd;
-	int ret = 0;
+	int ret;
 
 	mutex_lock(&id_priv->handler_mutex);
 	if (id_priv->state != RDMA_CM_CONNECT)
@@ -3827,14 +3824,12 @@ static int cma_sidr_rep_handler(struct i
 	if (ret) {
 		/* Destroy the CM ID by returning a non-zero value. */
 		id_priv->cm_id.ib = NULL;
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return ret;
 	}
 out:
 	mutex_unlock(&id_priv->handler_mutex);
-	return ret;
+	return 0;
 }
 
 static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
@@ -4359,9 +4354,7 @@ static int cma_ib_mc_handler(int status,
 
 	rdma_destroy_ah_attr(&event.param.ud.ah_attr);
 	if (ret) {
-		cma_exch(id_priv, RDMA_CM_DESTROYING);
-		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		destroy_id_handler_unlock(id_priv);
 		return 0;
 	}
 
@@ -4802,7 +4795,8 @@ static void cma_send_device_removal_put(
 		 */
 		cma_id_put(id_priv);
 		mutex_unlock(&id_priv->handler_mutex);
-		rdma_destroy_id(&id_priv->id);
+		trace_cm_id_destroy(id_priv);
+		_destroy_id(id_priv, state);
 		return;
 	}
 	mutex_unlock(&id_priv->handler_mutex);


