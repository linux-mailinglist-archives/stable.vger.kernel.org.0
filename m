Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E250129B91B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802197AbgJ0Pp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801080AbgJ0PjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F549207C3;
        Tue, 27 Oct 2020 15:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813141;
        bh=W5U8oER/VUgPWT4SRu7XPlajT8RhgXPzz7T0GIU43uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNVG8MJDxFbTVRN7zQybw1cpRulOJnu8gOb1rTxndQDd+evN0UpNdAtKNeUwJAUFu
         zgXKjzavVKRayCeooyg2iPXi1VT8cWptrsMPYYGWi49wRGPa+G2RWA11XhE//3LYWX
         4ET5ysmLyFaCk4Y3S6rh8pmmHVoOtQ5pScp0pNV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 452/757] RDMA/cma: Combine cma_ndev_work with cma_work
Date:   Tue, 27 Oct 2020 14:51:42 +0100
Message-Id: <20201027135511.731690648@linuxfoundation.org>
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

[ Upstream commit 7e85bcda8bfe883f4244672ed79f81b7762a1a7e ]

These are the same thing, except that cma_ndev_work doesn't have a state
transition. Signal no state transition by setting old_state and new_state
== 0.

In all cases the handler function should not be called once
rdma_destroy_id() has progressed passed setting the state.

Link: https://lore.kernel.org/r/20200902081122.745412-6-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 38 +++++++----------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5888311b21198..9c3cb8549ac72 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -363,12 +363,6 @@ struct cma_work {
 	struct rdma_cm_event	event;
 };
 
-struct cma_ndev_work {
-	struct work_struct	work;
-	struct rdma_id_private	*id;
-	struct rdma_cm_event	event;
-};
-
 struct iboe_mcast_work {
 	struct work_struct	 work;
 	struct rdma_id_private	*id;
@@ -2647,32 +2641,14 @@ static void cma_work_handler(struct work_struct *_work)
 	struct rdma_id_private *id_priv = work->id;
 
 	mutex_lock(&id_priv->handler_mutex);
-	if (!cma_comp_exch(id_priv, work->old_state, work->new_state))
+	if (READ_ONCE(id_priv->state) == RDMA_CM_DESTROYING ||
+	    READ_ONCE(id_priv->state) == RDMA_CM_DEVICE_REMOVAL)
 		goto out_unlock;
-
-	if (cma_cm_event_handler(id_priv, &work->event)) {
-		cma_id_put(id_priv);
-		destroy_id_handler_unlock(id_priv);
-		goto out_free;
+	if (work->old_state != 0 || work->new_state != 0) {
+		if (!cma_comp_exch(id_priv, work->old_state, work->new_state))
+			goto out_unlock;
 	}
 
-out_unlock:
-	mutex_unlock(&id_priv->handler_mutex);
-	cma_id_put(id_priv);
-out_free:
-	kfree(work);
-}
-
-static void cma_ndev_work_handler(struct work_struct *_work)
-{
-	struct cma_ndev_work *work = container_of(_work, struct cma_ndev_work, work);
-	struct rdma_id_private *id_priv = work->id;
-
-	mutex_lock(&id_priv->handler_mutex);
-	if (id_priv->state == RDMA_CM_DESTROYING ||
-	    id_priv->state == RDMA_CM_DEVICE_REMOVAL)
-		goto out_unlock;
-
 	if (cma_cm_event_handler(id_priv, &work->event)) {
 		cma_id_put(id_priv);
 		destroy_id_handler_unlock(id_priv);
@@ -4656,7 +4632,7 @@ EXPORT_SYMBOL(rdma_leave_multicast);
 static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id_priv)
 {
 	struct rdma_dev_addr *dev_addr;
-	struct cma_ndev_work *work;
+	struct cma_work *work;
 
 	dev_addr = &id_priv->id.route.addr.dev_addr;
 
@@ -4669,7 +4645,7 @@ static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id
 		if (!work)
 			return -ENOMEM;
 
-		INIT_WORK(&work->work, cma_ndev_work_handler);
+		INIT_WORK(&work->work, cma_work_handler);
 		work->id = id_priv;
 		work->event.event = RDMA_CM_EVENT_ADDR_CHANGE;
 		cma_id_get(id_priv);
-- 
2.25.1



