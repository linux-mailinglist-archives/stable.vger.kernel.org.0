Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0266A3C539C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348210AbhGLHzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350533AbhGLHvG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC1E611BF;
        Mon, 12 Jul 2021 07:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075969;
        bh=JpTjL76AgAJfbDLrrMZwnS1WhbSTTtD/2wHnRk1v2to=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EHUczl56RUZ9QlyO5PCasvVemwjBLMke4In0npLzq6M8flXqFcPZqsQUM1XAEKTGA
         Aa0q0MdslPmsE3MbzxPRRNjBEduOopQ/twf1oKvBoBb+2LfIfVNKfHVYD11UYChgq6
         8iC4Ig+FRyZJEWZhstv2U2UgsbWPB8HBYD6TueXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 443/800] IB/cm: Improve the calling of cm_init_av_for_lap and cm_init_av_by_path
Date:   Mon, 12 Jul 2021 08:07:46 +0200
Message-Id: <20210712061014.238494575@linuxfoundation.org>
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

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit 7345201c39633fc4c82dae7315da7154efaf2459 ]

The cm_init_av_for_lap() and cm_init_av_by_path() function calls have the
following issues:

1. Both of them might sleep and should not be called under spinlock.
2. The access of cm_id_priv->av should be under cm_id_priv->lock, which
   means it can't be initialized directly.

This patch splits the calling of 2 functions into two parts: first one
initializes an AV outside of the spinlock, the second one copies AV to
cm_id_priv->av under spinlock.

Fixes: e1444b5a163e ("IB/cm: Fix automatic path migration support")
Link: https://lore.kernel.org/r/038fb8ad932869b4548b0c7708cab7f76af06f18.1622629024.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 105 +++++++++++++++++++----------------
 1 file changed, 58 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 162261fd16d6..81d832646d27 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -439,30 +439,12 @@ static void cm_set_private_data(struct cm_id_private *cm_id_priv,
 	cm_id_priv->private_data_len = private_data_len;
 }
 
-static int cm_init_av_for_lap(struct cm_port *port, struct ib_wc *wc,
-			      struct ib_grh *grh, struct cm_av *av)
+static void cm_init_av_for_lap(struct cm_port *port, struct ib_wc *wc,
+			       struct rdma_ah_attr *ah_attr, struct cm_av *av)
 {
-	struct rdma_ah_attr new_ah_attr;
-	int ret;
-
 	av->port = port;
 	av->pkey_index = wc->pkey_index;
-
-	/*
-	 * av->ah_attr might be initialized based on past wc during incoming
-	 * connect request or while sending out connect request. So initialize
-	 * a new ah_attr on stack. If initialization fails, old ah_attr is
-	 * used for sending any responses. If initialization is successful,
-	 * than new ah_attr is used by overwriting old one.
-	 */
-	ret = ib_init_ah_attr_from_wc(port->cm_dev->ib_device,
-				      port->port_num, wc,
-				      grh, &new_ah_attr);
-	if (ret)
-		return ret;
-
-	rdma_move_ah_attr(&av->ah_attr, &new_ah_attr);
-	return 0;
+	rdma_move_ah_attr(&av->ah_attr, ah_attr);
 }
 
 static int cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
@@ -556,6 +538,20 @@ static int cm_init_av_by_path(struct sa_path_rec *path,
 	return 0;
 }
 
+/* Move av created by cm_init_av_by_path(), so av.dgid is not moved */
+static void cm_move_av_from_path(struct cm_av *dest, struct cm_av *src)
+{
+	dest->port = src->port;
+	dest->pkey_index = src->pkey_index;
+	rdma_move_ah_attr(&dest->ah_attr, &src->ah_attr);
+	dest->timeout = src->timeout;
+}
+
+static void cm_destroy_av(struct cm_av *av)
+{
+	rdma_destroy_ah_attr(&av->ah_attr);
+}
+
 static u32 cm_local_id(__be32 local_id)
 {
 	return (__force u32) (local_id ^ cm.random_id_operand);
@@ -1145,8 +1141,8 @@ retest:
 	while ((work = cm_dequeue_work(cm_id_priv)) != NULL)
 		cm_free_work(work);
 
-	rdma_destroy_ah_attr(&cm_id_priv->av.ah_attr);
-	rdma_destroy_ah_attr(&cm_id_priv->alt_av.ah_attr);
+	cm_destroy_av(&cm_id_priv->av);
+	cm_destroy_av(&cm_id_priv->alt_av);
 	kfree(cm_id_priv->private_data);
 	kfree_rcu(cm_id_priv, rcu);
 }
@@ -1470,6 +1466,7 @@ static int cm_validate_req_param(struct ib_cm_req_param *param)
 int ib_send_cm_req(struct ib_cm_id *cm_id,
 		   struct ib_cm_req_param *param)
 {
+	struct cm_av av = {}, alt_av = {};
 	struct cm_id_private *cm_id_priv;
 	struct ib_mad_send_buf *msg;
 	struct cm_req_msg *req_msg;
@@ -1485,8 +1482,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	if (cm_id->state != IB_CM_IDLE || WARN_ON(cm_id_priv->timewait_info)) {
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-		ret = -EINVAL;
-		goto out;
+		return -EINVAL;
 	}
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 
@@ -1495,18 +1491,20 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	if (IS_ERR(cm_id_priv->timewait_info)) {
 		ret = PTR_ERR(cm_id_priv->timewait_info);
 		cm_id_priv->timewait_info = NULL;
-		goto out;
+		return ret;
 	}
 
 	ret = cm_init_av_by_path(param->primary_path,
-				 param->ppath_sgid_attr, &cm_id_priv->av);
+				 param->ppath_sgid_attr, &av);
 	if (ret)
-		goto out;
+		return ret;
 	if (param->alternate_path) {
 		ret = cm_init_av_by_path(param->alternate_path, NULL,
-					 &cm_id_priv->alt_av);
-		if (ret)
-			goto out;
+					 &alt_av);
+		if (ret) {
+			cm_destroy_av(&av);
+			return ret;
+		}
 	}
 	cm_id->service_id = param->service_id;
 	cm_id->service_mask = ~cpu_to_be64(0);
@@ -1523,6 +1521,11 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	cm_id_priv->qp_type = param->qp_type;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
+
+	cm_move_av_from_path(&cm_id_priv->av, &av);
+	if (param->alternate_path)
+		cm_move_av_from_path(&cm_id_priv->alt_av, &alt_av);
+
 	msg = cm_alloc_priv_msg(cm_id_priv);
 	if (IS_ERR(msg)) {
 		ret = PTR_ERR(msg);
@@ -1550,7 +1553,6 @@ out_free:
 	cm_free_priv_msg(msg);
 out_unlock:
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-out:
 	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_req);
@@ -3267,6 +3269,8 @@ static int cm_lap_handler(struct cm_work *work)
 	struct cm_lap_msg *lap_msg;
 	struct ib_cm_lap_event_param *param;
 	struct ib_mad_send_buf *msg = NULL;
+	struct rdma_ah_attr ah_attr;
+	struct cm_av alt_av = {};
 	int ret;
 
 	/* Currently Alternate path messages are not supported for
@@ -3295,7 +3299,25 @@ static int cm_lap_handler(struct cm_work *work)
 	work->cm_event.private_data =
 		IBA_GET_MEM_PTR(CM_LAP_PRIVATE_DATA, lap_msg);
 
+	ret = ib_init_ah_attr_from_wc(work->port->cm_dev->ib_device,
+				      work->port->port_num,
+				      work->mad_recv_wc->wc,
+				      work->mad_recv_wc->recv_buf.grh,
+				      &ah_attr);
+	if (ret)
+		goto deref;
+
+	ret = cm_init_av_by_path(param->alternate_path, NULL, &alt_av);
+	if (ret) {
+		rdma_destroy_ah_attr(&ah_attr);
+		return -EINVAL;
+	}
+
 	spin_lock_irq(&cm_id_priv->lock);
+	cm_init_av_for_lap(work->port, work->mad_recv_wc->wc,
+			   &ah_attr, &cm_id_priv->av);
+	cm_move_av_from_path(&cm_id_priv->alt_av, &alt_av);
+
 	if (cm_id_priv->id.state != IB_CM_ESTABLISHED)
 		goto unlock;
 
@@ -3329,17 +3351,6 @@ static int cm_lap_handler(struct cm_work *work)
 		goto unlock;
 	}
 
-	ret = cm_init_av_for_lap(work->port, work->mad_recv_wc->wc,
-				 work->mad_recv_wc->recv_buf.grh,
-				 &cm_id_priv->av);
-	if (ret)
-		goto unlock;
-
-	ret = cm_init_av_by_path(param->alternate_path, NULL,
-				 &cm_id_priv->alt_av);
-	if (ret)
-		goto unlock;
-
 	cm_id_priv->id.lap_state = IB_CM_LAP_RCVD;
 	cm_id_priv->tid = lap_msg->hdr.tid;
 	cm_queue_work_unlock(cm_id_priv, work);
@@ -3447,6 +3458,7 @@ int ib_send_cm_sidr_req(struct ib_cm_id *cm_id,
 {
 	struct cm_id_private *cm_id_priv;
 	struct ib_mad_send_buf *msg;
+	struct cm_av av = {};
 	unsigned long flags;
 	int ret;
 
@@ -3455,17 +3467,16 @@ int ib_send_cm_sidr_req(struct ib_cm_id *cm_id,
 		return -EINVAL;
 
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
-	ret = cm_init_av_by_path(param->path, param->sgid_attr,
-				 &cm_id_priv->av);
+	ret = cm_init_av_by_path(param->path, param->sgid_attr, &av);
 	if (ret)
 		return ret;
 
+	spin_lock_irqsave(&cm_id_priv->lock, flags);
+	cm_move_av_from_path(&cm_id_priv->av, &av);
 	cm_id->service_id = param->service_id;
 	cm_id->service_mask = ~cpu_to_be64(0);
 	cm_id_priv->timeout_ms = param->timeout_ms;
 	cm_id_priv->max_cm_retries = param->max_cm_retries;
-
-	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	if (cm_id->state != IB_CM_IDLE) {
 		ret = -EINVAL;
 		goto out_unlock;
-- 
2.30.2



