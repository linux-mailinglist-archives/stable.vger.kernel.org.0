Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA243C53A4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348313AbhGLHzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350550AbhGLHvI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC342611AF;
        Mon, 12 Jul 2021 07:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075964;
        bh=4wSZOEmLEav6yoVtn1R0chnnFJYwpWHbj3UxA///9SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QT4Tc3UejFEDAcx9mz973iCY5fyChMRLGsA/AV53YURr3pIobwSK939eNIO3bM89e
         wGyqwqmQLbdufAhT2m2hfQ+XrzG//os4bC8dziZbdTvUVsztHiqYTJ+AZaSOlhrEYe
         dy3dwn2D9PTcIXJ6KaEOGRVOuc/sXFlB8jNFbtOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 441/800] IB/cm: Split cm_alloc_msg()
Date:   Mon, 12 Jul 2021 08:07:44 +0200
Message-Id: <20210712061014.006890212@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 4b4e586ebe37c8c7e2a4bf46dc4b742756fd788d ]

This is being used with two quite different flows, one attaches the
message to the priv and the other does not.

Ensure the message attach is consistently done under the spinlock and
ensure that the free on error always detaches the message from the
cm_id_priv, also always under lock.

This makes read/write to the cm_id_priv->msg consistently locked and
consistently NULL'd when the message is freed, even in all error paths.

Link: https://lore.kernel.org/r/f692b8c89eecb34fd82244f317e478bea6c97688.1622629024.git.leonro@nvidia.com
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 190 +++++++++++++++++++++--------------
 1 file changed, 115 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 6e20ba5d32e1..94613275edcc 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -305,8 +305,7 @@ static inline void cm_deref_id(struct cm_id_private *cm_id_priv)
 		complete(&cm_id_priv->comp);
 }
 
-static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
-			struct ib_mad_send_buf **msg)
+static struct ib_mad_send_buf *cm_alloc_msg(struct cm_id_private *cm_id_priv)
 {
 	struct ib_mad_agent *mad_agent;
 	struct ib_mad_send_buf *m;
@@ -359,12 +358,42 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 	m->retries = cm_id_priv->max_cm_retries;
 
 	refcount_inc(&cm_id_priv->refcount);
+	spin_unlock_irqrestore(&cm.state_lock, flags2);
 	m->context[0] = cm_id_priv;
-	*msg = m;
+	return m;
 
 out:
 	spin_unlock_irqrestore(&cm.state_lock, flags2);
-	return ret;
+	return ERR_PTR(ret);
+}
+
+static struct ib_mad_send_buf *
+cm_alloc_priv_msg(struct cm_id_private *cm_id_priv)
+{
+	struct ib_mad_send_buf *msg;
+
+	lockdep_assert_held(&cm_id_priv->lock);
+
+	msg = cm_alloc_msg(cm_id_priv);
+	if (IS_ERR(msg))
+		return msg;
+	cm_id_priv->msg = msg;
+	return msg;
+}
+
+static void cm_free_priv_msg(struct ib_mad_send_buf *msg)
+{
+	struct cm_id_private *cm_id_priv = msg->context[0];
+
+	lockdep_assert_held(&cm_id_priv->lock);
+
+	if (!WARN_ON(cm_id_priv->msg != msg))
+		cm_id_priv->msg = NULL;
+
+	if (msg->ah)
+		rdma_destroy_ah(msg->ah, 0);
+	cm_deref_id(cm_id_priv);
+	ib_free_send_mad(msg);
 }
 
 static struct ib_mad_send_buf *cm_alloc_response_msg_no_ah(struct cm_port *port,
@@ -1508,6 +1537,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 		   struct ib_cm_req_param *param)
 {
 	struct cm_id_private *cm_id_priv;
+	struct ib_mad_send_buf *msg;
 	struct cm_req_msg *req_msg;
 	unsigned long flags;
 	int ret;
@@ -1559,31 +1589,34 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	cm_id_priv->pkey = param->primary_path->pkey;
 	cm_id_priv->qp_type = param->qp_type;
 
-	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
-	if (ret)
-		goto out;
+	spin_lock_irqsave(&cm_id_priv->lock, flags);
+	msg = cm_alloc_priv_msg(cm_id_priv);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
+		goto out_unlock;
+	}
 
-	req_msg = (struct cm_req_msg *) cm_id_priv->msg->mad;
+	req_msg = (struct cm_req_msg *)msg->mad;
 	cm_format_req(req_msg, cm_id_priv, param);
 	cm_id_priv->tid = req_msg->hdr.tid;
-	cm_id_priv->msg->timeout_ms = cm_id_priv->timeout_ms;
-	cm_id_priv->msg->context[1] = (void *) (unsigned long) IB_CM_REQ_SENT;
+	msg->timeout_ms = cm_id_priv->timeout_ms;
+	msg->context[1] = (void *)(unsigned long)IB_CM_REQ_SENT;
 
 	cm_id_priv->local_qpn = cpu_to_be32(IBA_GET(CM_REQ_LOCAL_QPN, req_msg));
 	cm_id_priv->rq_psn = cpu_to_be32(IBA_GET(CM_REQ_STARTING_PSN, req_msg));
 
 	trace_icm_send_req(&cm_id_priv->id);
-	spin_lock_irqsave(&cm_id_priv->lock, flags);
-	ret = ib_post_send_mad(cm_id_priv->msg, NULL);
-	if (ret) {
-		cm_free_msg(cm_id_priv->msg);
-		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-		goto out;
-	}
+	ret = ib_post_send_mad(msg, NULL);
+	if (ret)
+		goto out_free;
 	BUG_ON(cm_id->state != IB_CM_IDLE);
 	cm_id->state = IB_CM_REQ_SENT;
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return 0;
+out_free:
+	cm_free_priv_msg(msg);
+out_unlock:
+	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 out:
 	return ret;
 }
@@ -2290,9 +2323,11 @@ int ib_send_cm_rep(struct ib_cm_id *cm_id,
 		goto out;
 	}
 
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret)
+	msg = cm_alloc_priv_msg(cm_id_priv);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
 		goto out;
+	}
 
 	rep_msg = (struct cm_rep_msg *) msg->mad;
 	cm_format_rep(rep_msg, cm_id_priv, param);
@@ -2301,14 +2336,10 @@ int ib_send_cm_rep(struct ib_cm_id *cm_id,
 
 	trace_icm_send_rep(cm_id);
 	ret = ib_post_send_mad(msg, NULL);
-	if (ret) {
-		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-		cm_free_msg(msg);
-		return ret;
-	}
+	if (ret)
+		goto out_free;
 
 	cm_id->state = IB_CM_REP_SENT;
-	cm_id_priv->msg = msg;
 	cm_id_priv->initiator_depth = param->initiator_depth;
 	cm_id_priv->responder_resources = param->responder_resources;
 	cm_id_priv->rq_psn = cpu_to_be32(IBA_GET(CM_REP_STARTING_PSN, rep_msg));
@@ -2316,8 +2347,13 @@ int ib_send_cm_rep(struct ib_cm_id *cm_id,
 		  "IBTA declares QPN to be 24 bits, but it is 0x%X\n",
 		  param->qp_num);
 	cm_id_priv->local_qpn = cpu_to_be32(param->qp_num & 0xFFFFFF);
+	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+	return 0;
 
-out:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+out_free:
+	cm_free_priv_msg(msg);
+out:
+	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_rep);
@@ -2364,9 +2400,11 @@ int ib_send_cm_rtu(struct ib_cm_id *cm_id,
 		goto error;
 	}
 
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret)
+	msg = cm_alloc_msg(cm_id_priv);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
 		goto error;
+	}
 
 	cm_format_rtu((struct cm_rtu_msg *) msg->mad, cm_id_priv,
 		      private_data, private_data_len);
@@ -2664,10 +2702,10 @@ static int cm_send_dreq_locked(struct cm_id_private *cm_id_priv,
 	    cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
 		ib_cancel_mad(cm_id_priv->av.port->mad_agent, cm_id_priv->msg);
 
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret) {
+	msg = cm_alloc_priv_msg(cm_id_priv);
+	if (IS_ERR(msg)) {
 		cm_enter_timewait(cm_id_priv);
-		return ret;
+		return PTR_ERR(msg);
 	}
 
 	cm_format_dreq((struct cm_dreq_msg *) msg->mad, cm_id_priv,
@@ -2679,12 +2717,11 @@ static int cm_send_dreq_locked(struct cm_id_private *cm_id_priv,
 	ret = ib_post_send_mad(msg, NULL);
 	if (ret) {
 		cm_enter_timewait(cm_id_priv);
-		cm_free_msg(msg);
+		cm_free_priv_msg(msg);
 		return ret;
 	}
 
 	cm_id_priv->id.state = IB_CM_DREQ_SENT;
-	cm_id_priv->msg = msg;
 	return 0;
 }
 
@@ -2739,9 +2776,9 @@ static int cm_send_drep_locked(struct cm_id_private *cm_id_priv,
 	cm_set_private_data(cm_id_priv, private_data, private_data_len);
 	cm_enter_timewait(cm_id_priv);
 
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret)
-		return ret;
+	msg = cm_alloc_msg(cm_id_priv);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
 	cm_format_drep((struct cm_drep_msg *) msg->mad, cm_id_priv,
 		       private_data, private_data_len);
@@ -2934,9 +2971,9 @@ static int cm_send_rej_locked(struct cm_id_private *cm_id_priv,
 	case IB_CM_REP_RCVD:
 	case IB_CM_MRA_REP_SENT:
 		cm_reset_to_idle(cm_id_priv);
-		ret = cm_alloc_msg(cm_id_priv, &msg);
-		if (ret)
-			return ret;
+		msg = cm_alloc_msg(cm_id_priv);
+		if (IS_ERR(msg))
+			return PTR_ERR(msg);
 		cm_format_rej((struct cm_rej_msg *)msg->mad, cm_id_priv, reason,
 			      ari, ari_length, private_data, private_data_len,
 			      state);
@@ -2944,9 +2981,9 @@ static int cm_send_rej_locked(struct cm_id_private *cm_id_priv,
 	case IB_CM_REP_SENT:
 	case IB_CM_MRA_REP_RCVD:
 		cm_enter_timewait(cm_id_priv);
-		ret = cm_alloc_msg(cm_id_priv, &msg);
-		if (ret)
-			return ret;
+		msg = cm_alloc_msg(cm_id_priv);
+		if (IS_ERR(msg))
+			return PTR_ERR(msg);
 		cm_format_rej((struct cm_rej_msg *)msg->mad, cm_id_priv, reason,
 			      ari, ari_length, private_data, private_data_len,
 			      state);
@@ -3124,13 +3161,15 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
 	default:
 		trace_icm_send_mra_unknown_err(&cm_id_priv->id);
 		ret = -EINVAL;
-		goto error1;
+		goto error_unlock;
 	}
 
 	if (!(service_timeout & IB_CM_MRA_FLAG_DELAY)) {
-		ret = cm_alloc_msg(cm_id_priv, &msg);
-		if (ret)
-			goto error1;
+		msg = cm_alloc_msg(cm_id_priv);
+		if (IS_ERR(msg)) {
+			ret = PTR_ERR(msg);
+			goto error_unlock;
+		}
 
 		cm_format_mra((struct cm_mra_msg *) msg->mad, cm_id_priv,
 			      msg_response, service_timeout,
@@ -3138,7 +3177,7 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
 		trace_icm_send_mra(cm_id);
 		ret = ib_post_send_mad(msg, NULL);
 		if (ret)
-			goto error2;
+			goto error_free_msg;
 	}
 
 	cm_id->state = cm_state;
@@ -3148,13 +3187,11 @@ int ib_send_cm_mra(struct ib_cm_id *cm_id,
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return 0;
 
-error1:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-	kfree(data);
-	return ret;
-
-error2:	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-	kfree(data);
+error_free_msg:
 	cm_free_msg(msg);
+error_unlock:
+	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
+	kfree(data);
 	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_mra);
@@ -3490,38 +3527,41 @@ int ib_send_cm_sidr_req(struct ib_cm_id *cm_id,
 				 &cm_id_priv->av,
 				 cm_id_priv);
 	if (ret)
-		goto out;
+		return ret;
 
 	cm_id->service_id = param->service_id;
 	cm_id->service_mask = ~cpu_to_be64(0);
 	cm_id_priv->timeout_ms = param->timeout_ms;
 	cm_id_priv->max_cm_retries = param->max_cm_retries;
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret)
-		goto out;
-
-	cm_format_sidr_req((struct cm_sidr_req_msg *) msg->mad, cm_id_priv,
-			   param);
-	msg->timeout_ms = cm_id_priv->timeout_ms;
-	msg->context[1] = (void *) (unsigned long) IB_CM_SIDR_REQ_SENT;
 
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
-	if (cm_id->state == IB_CM_IDLE) {
-		trace_icm_send_sidr_req(&cm_id_priv->id);
-		ret = ib_post_send_mad(msg, NULL);
-	} else {
+	if (cm_id->state != IB_CM_IDLE) {
 		ret = -EINVAL;
+		goto out_unlock;
 	}
 
-	if (ret) {
-		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-		cm_free_msg(msg);
-		goto out;
+	msg = cm_alloc_priv_msg(cm_id_priv);
+	if (IS_ERR(msg)) {
+		ret = PTR_ERR(msg);
+		goto out_unlock;
 	}
+
+	cm_format_sidr_req((struct cm_sidr_req_msg *)msg->mad, cm_id_priv,
+			   param);
+	msg->timeout_ms = cm_id_priv->timeout_ms;
+	msg->context[1] = (void *)(unsigned long)IB_CM_SIDR_REQ_SENT;
+
+	trace_icm_send_sidr_req(&cm_id_priv->id);
+	ret = ib_post_send_mad(msg, NULL);
+	if (ret)
+		goto out_free;
 	cm_id->state = IB_CM_SIDR_REQ_SENT;
-	cm_id_priv->msg = msg;
 	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
-out:
+	return 0;
+out_free:
+	cm_free_priv_msg(msg);
+out_unlock:
+	spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_sidr_req);
@@ -3668,9 +3708,9 @@ static int cm_send_sidr_rep_locked(struct cm_id_private *cm_id_priv,
 	if (cm_id_priv->id.state != IB_CM_SIDR_REQ_RCVD)
 		return -EINVAL;
 
-	ret = cm_alloc_msg(cm_id_priv, &msg);
-	if (ret)
-		return ret;
+	msg = cm_alloc_msg(cm_id_priv);
+	if (IS_ERR(msg))
+		return PTR_ERR(msg);
 
 	cm_format_sidr_rep((struct cm_sidr_rep_msg *) msg->mad, cm_id_priv,
 			   param);
-- 
2.30.2



