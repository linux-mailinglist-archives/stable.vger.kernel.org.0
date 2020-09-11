Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ED2266429
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 18:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgIKQc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 12:32:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgIKPTF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 11:19:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36ABB2224B;
        Fri, 11 Sep 2020 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829193;
        bh=CxiLQledTtjYLcXI2PL3KnXja4YeJ9jEEbIqHlV6OSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVZg4Y7JrzO2SCrf8KBd8E41VlKvv0SjyhUpEEoAGbv73dImNGfX3husa96ssMBjC
         p/9vH+grtQIuiGBre9TU6QnqoF/9/lnY571MtdNGCsh1Dm1oW4KwxCvolfm5xPx3Ko
         ED46vkR5Rlq4USj0++e4b11EPzYHIBwDfu/Y5rNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 04/16] RDMA/cma: Using the standard locking pattern when delivering the removal event
Date:   Fri, 11 Sep 2020 14:47:21 +0200
Message-Id: <20200911122459.794964379@linuxfoundation.org>
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

[ Upstream commit 3647a28de1ada8708efc78d956619b9df5004478 ]

Whenever an event is delivered to the handler it should be done under the
handler_mutex and upon any non-zero return from the handler it should
trigger destruction of the cm_id.

cma_process_remove() skips some steps here, it is not necessarily wrong
since the state change should prevent any races, but it is confusing and
unnecessary.

Follow the standard pattern here, with the slight twist that the
transition to RDMA_CM_DEVICE_REMOVAL includes a cma_cancel_operation().

Link: https://lore.kernel.org/r/20200723070707.1771101-3-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 62 ++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 537eeebde5f4d..04151c301e851 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1925,6 +1925,8 @@ static int cma_cm_event_handler(struct rdma_id_private *id_priv,
 {
 	int ret;
 
+	lockdep_assert_held(&id_priv->handler_mutex);
+
 	trace_cm_event_handler(id_priv, event);
 	ret = id_priv->id.event_handler(&id_priv->id, event);
 	trace_cm_event_done(id_priv, event, ret);
@@ -4793,50 +4795,58 @@ free_cma_dev:
 	return ret;
 }
 
-static int cma_remove_id_dev(struct rdma_id_private *id_priv)
+static void cma_send_device_removal_put(struct rdma_id_private *id_priv)
 {
-	struct rdma_cm_event event = {};
+	struct rdma_cm_event event = { .event = RDMA_CM_EVENT_DEVICE_REMOVAL };
 	enum rdma_cm_state state;
-	int ret = 0;
-
-	/* Record that we want to remove the device */
-	state = cma_exch(id_priv, RDMA_CM_DEVICE_REMOVAL);
-	if (state == RDMA_CM_DESTROYING)
-		return 0;
+	unsigned long flags;
 
-	cma_cancel_operation(id_priv, state);
 	mutex_lock(&id_priv->handler_mutex);
+	/* Record that we want to remove the device */
+	spin_lock_irqsave(&id_priv->lock, flags);
+	state = id_priv->state;
+	if (state == RDMA_CM_DESTROYING || state == RDMA_CM_DEVICE_REMOVAL) {
+		spin_unlock_irqrestore(&id_priv->lock, flags);
+		mutex_unlock(&id_priv->handler_mutex);
+		cma_id_put(id_priv);
+		return;
+	}
+	id_priv->state = RDMA_CM_DEVICE_REMOVAL;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
 
-	/* Check for destruction from another callback. */
-	if (!cma_comp(id_priv, RDMA_CM_DEVICE_REMOVAL))
-		goto out;
-
-	event.event = RDMA_CM_EVENT_DEVICE_REMOVAL;
-	ret = cma_cm_event_handler(id_priv, &event);
-out:
+	if (cma_cm_event_handler(id_priv, &event)) {
+		/*
+		 * At this point the ULP promises it won't call
+		 * rdma_destroy_id() concurrently
+		 */
+		cma_id_put(id_priv);
+		mutex_unlock(&id_priv->handler_mutex);
+		rdma_destroy_id(&id_priv->id);
+		return;
+	}
 	mutex_unlock(&id_priv->handler_mutex);
-	return ret;
+
+	/*
+	 * If this races with destroy then the thread that first assigns state
+	 * to a destroying does the cancel.
+	 */
+	cma_cancel_operation(id_priv, state);
+	cma_id_put(id_priv);
 }
 
 static void cma_process_remove(struct cma_device *cma_dev)
 {
-	struct rdma_id_private *id_priv;
-	int ret;
-
 	mutex_lock(&lock);
 	while (!list_empty(&cma_dev->id_list)) {
-		id_priv = list_entry(cma_dev->id_list.next,
-				     struct rdma_id_private, list);
+		struct rdma_id_private *id_priv = list_first_entry(
+			&cma_dev->id_list, struct rdma_id_private, list);
 
 		list_del(&id_priv->listen_list);
 		list_del_init(&id_priv->list);
 		cma_id_get(id_priv);
 		mutex_unlock(&lock);
 
-		ret = cma_remove_id_dev(id_priv);
-		cma_id_put(id_priv);
-		if (ret)
-			rdma_destroy_id(&id_priv->id);
+		cma_send_device_removal_put(id_priv);
 
 		mutex_lock(&lock);
 	}
-- 
2.25.1



