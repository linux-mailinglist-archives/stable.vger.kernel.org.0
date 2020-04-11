Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA0B1A583C
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgDKXLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727269AbgDKXLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:11:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1EC620708;
        Sat, 11 Apr 2020 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646671;
        bh=u6HJ5OVJ8HdzsGofslqa9eTnLjHRqBwZbvulVXh0+I8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx9V/rrK983mM4jGTnqR4iorRx043xBP/ROGYFPPq+QYzQIOvVDlquqOoMN0AMIKu
         licYVSehjTRN3de+YRdRqQmu7OKfEhaHBFcWNjK6PvckgA8KjX5G+Icz2sSA4ATLDh
         M9CZZP32eqaZW4T7gjdyqgvSph+CiplMCkDx5VF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 070/108] RDMA/cm: Remove a race freeing timewait_info
Date:   Sat, 11 Apr 2020 19:09:05 -0400
Message-Id: <20200411230943.24951-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit bede86a39d9dc3387ac00dcb8e1ac221676b2f25 ]

When creating a cm_id during REQ the id immediately becomes visible to the
other MAD handlers, and shortly after the state is moved to IB_CM_REQ_RCVD

This allows cm_rej_handler() to run concurrently and free the work:

        CPU 0                                CPU1
 cm_req_handler()
  ib_create_cm_id()
  cm_match_req()
    id_priv->state = IB_CM_REQ_RCVD
                                       cm_rej_handler()
                                         cm_acquire_id()
                                         spin_lock(&id_priv->lock)
                                         switch (id_priv->state)
  					   case IB_CM_REQ_RCVD:
                                            cm_reset_to_idle()
                                             kfree(id_priv->timewait_info);
   goto destroy
  destroy:
    kfree(id_priv->timewait_info);
                                             id_priv->timewait_info = NULL

Causing a double free or worse.

Do not free the timewait_info without also holding the
id_priv->lock. Simplify this entire flow by making the free unconditional
during cm_destroy_id() and removing the confusing special case error
unwind during creation of the timewait_info.

This also fixes a leak of the timewait if cm_destroy_id() is called in
IB_CM_ESTABLISHED with an XRC TGT QP. The state machine will be left in
ESTABLISHED while it needed to transition through IB_CM_TIMEWAIT to
release the timewait pointer.

Also fix a leak of the timewait_info if the caller mis-uses the API and
does ib_send_cm_reqs().

Fixes: a977049dacde ("[PATCH] IB: Add the kernel CM implementation")
Link: https://lore.kernel.org/r/20200310092545.251365-4-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cm.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 2c4d925041d09..600b05cd5e876 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1097,14 +1097,22 @@ static void cm_destroy_id(struct ib_cm_id *cm_id, int err)
 		break;
 	}
 
-	spin_lock_irq(&cm.lock);
+	spin_lock_irq(&cm_id_priv->lock);
+	spin_lock(&cm.lock);
+	/* Required for cleanup paths related cm_req_handler() */
+	if (cm_id_priv->timewait_info) {
+		cm_cleanup_timewait(cm_id_priv->timewait_info);
+		kfree(cm_id_priv->timewait_info);
+		cm_id_priv->timewait_info = NULL;
+	}
 	if (!list_empty(&cm_id_priv->altr_list) &&
 	    (!cm_id_priv->altr_send_port_not_ready))
 		list_del(&cm_id_priv->altr_list);
 	if (!list_empty(&cm_id_priv->prim_list) &&
 	    (!cm_id_priv->prim_send_port_not_ready))
 		list_del(&cm_id_priv->prim_list);
-	spin_unlock_irq(&cm.lock);
+	spin_unlock(&cm.lock);
+	spin_unlock_irq(&cm_id_priv->lock);
 
 	cm_free_id(cm_id->local_id);
 	cm_deref_id(cm_id_priv);
@@ -1421,7 +1429,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	/* Verify that we're not in timewait. */
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
-	if (cm_id->state != IB_CM_IDLE) {
+	if (cm_id->state != IB_CM_IDLE || WARN_ON(cm_id_priv->timewait_info)) {
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		ret = -EINVAL;
 		goto out;
@@ -1439,12 +1447,12 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 				 param->ppath_sgid_attr, &cm_id_priv->av,
 				 cm_id_priv);
 	if (ret)
-		goto error1;
+		goto out;
 	if (param->alternate_path) {
 		ret = cm_init_av_by_path(param->alternate_path, NULL,
 					 &cm_id_priv->alt_av, cm_id_priv);
 		if (ret)
-			goto error1;
+			goto out;
 	}
 	cm_id->service_id = param->service_id;
 	cm_id->service_mask = ~cpu_to_be64(0);
@@ -1462,7 +1470,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 
 	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
 	if (ret)
-		goto error1;
+		goto out;
 
 	req_msg = (struct cm_req_msg *) cm_id_priv->msg->mad;
 	cm_format_req(req_msg, cm_id_priv, param);
@@ -1485,7 +1493,6 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	return 0;
 
 error2:	cm_free_msg(cm_id_priv->msg);
-error1:	kfree(cm_id_priv->timewait_info);
 out:	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_req);
@@ -1974,7 +1981,7 @@ static int cm_req_handler(struct cm_work *work)
 		pr_debug("%s: local_id %d, no listen_cm_id_priv\n", __func__,
 			 be32_to_cpu(cm_id->local_id));
 		ret = -EINVAL;
-		goto free_timeinfo;
+		goto destroy;
 	}
 
 	cm_id_priv->id.cm_handler = listen_cm_id_priv->id.cm_handler;
@@ -2059,8 +2066,6 @@ static int cm_req_handler(struct cm_work *work)
 rejected:
 	atomic_dec(&cm_id_priv->refcount);
 	cm_deref_id(listen_cm_id_priv);
-free_timeinfo:
-	kfree(cm_id_priv->timewait_info);
 destroy:
 	ib_destroy_cm_id(cm_id);
 	return ret;
-- 
2.20.1

