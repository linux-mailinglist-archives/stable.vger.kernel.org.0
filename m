Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D471A26F091
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgIRCKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:10:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728427AbgIRCKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:10:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1ED238A1;
        Fri, 18 Sep 2020 02:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395018;
        bh=V8EJJJpgxZ0IT/dWPRc7TaxDiicSTsDaMI/WFOHjKgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXYfYY7CEpLd3MV1qDgKf2Y5UAxGRsrcmp3SxvRs7SU0HIpN0c/MITAbGn3QcR1vy
         NeSjjEcDqmu08yYCnI/kewYb1Ycny7xb3ujHtT1F18Ph4wMWzGqD4cfHPCdqk0Yfy3
         o1oZQJH2oMBg67VtE1ZsJKXFC3Ld3s2qoRqA4Lxg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 113/206] RDMA/cm: Remove a race freeing timewait_info
Date:   Thu, 17 Sep 2020 22:06:29 -0400
Message-Id: <20200918020802.2065198-113-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
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
index 64f206e11d497..4ebf63360a697 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1100,14 +1100,22 @@ retest:
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
@@ -1424,7 +1432,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	/* Verify that we're not in timewait. */
 	cm_id_priv = container_of(cm_id, struct cm_id_private, id);
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
-	if (cm_id->state != IB_CM_IDLE) {
+	if (cm_id->state != IB_CM_IDLE || WARN_ON(cm_id_priv->timewait_info)) {
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		ret = -EINVAL;
 		goto out;
@@ -1442,12 +1450,12 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
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
@@ -1465,7 +1473,7 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 
 	ret = cm_alloc_msg(cm_id_priv, &cm_id_priv->msg);
 	if (ret)
-		goto error1;
+		goto out;
 
 	req_msg = (struct cm_req_msg *) cm_id_priv->msg->mad;
 	cm_format_req(req_msg, cm_id_priv, param);
@@ -1488,7 +1496,6 @@ int ib_send_cm_req(struct ib_cm_id *cm_id,
 	return 0;
 
 error2:	cm_free_msg(cm_id_priv->msg);
-error1:	kfree(cm_id_priv->timewait_info);
 out:	return ret;
 }
 EXPORT_SYMBOL(ib_send_cm_req);
@@ -1973,7 +1980,7 @@ static int cm_req_handler(struct cm_work *work)
 		pr_debug("%s: local_id %d, no listen_cm_id_priv\n", __func__,
 			 be32_to_cpu(cm_id->local_id));
 		ret = -EINVAL;
-		goto free_timeinfo;
+		goto destroy;
 	}
 
 	cm_id_priv->id.cm_handler = listen_cm_id_priv->id.cm_handler;
@@ -2057,8 +2064,6 @@ static int cm_req_handler(struct cm_work *work)
 rejected:
 	atomic_dec(&cm_id_priv->refcount);
 	cm_deref_id(listen_cm_id_priv);
-free_timeinfo:
-	kfree(cm_id_priv->timewait_info);
 destroy:
 	ib_destroy_cm_id(cm_id);
 	return ret;
-- 
2.25.1

