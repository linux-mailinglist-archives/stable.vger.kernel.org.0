Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F682E3CBB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437589AbgL1OFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:05:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437532AbgL1OFR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:05:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1845220731;
        Mon, 28 Dec 2020 14:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164301;
        bh=xMh/rxnI6YNKvsJMreBvE6sspUz0sTRCBr/09P7kmw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1+xysIfrhUTRXz7ze9q3hq78QejlaLO9pTybYR8dFdXBbWzIKms8pwF4ryhBzq5l
         ew02VKWoMSSdNBdrqEOtRMac3U+lVE7f/uxROeZ8c/9ZVBrb3VpmpXfcTedYHeoJxe
         +eRYA9oHz6jpE7PTndN2gqj9J7Exc8teP03dF61k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/717] RDMA/cma: Add missing error handling of listen_id
Date:   Mon, 28 Dec 2020 13:42:10 +0100
Message-Id: <20201228125027.272640231@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit c80a0c52d85c49a910d0dc0e342e8d8898677dc0 ]

Don't silently continue if rdma_listen() fails but destroy previously
created CM_ID and return an error to the caller.

Fixes: d02d1f5359e7 ("RDMA/cma: Fix deadlock destroying listen requests")
Link: https://lore.kernel.org/r/20201104144008.3808124-5-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 175 ++++++++++++++++++++--------------
 1 file changed, 101 insertions(+), 74 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a77750b8954db..4585f654f8836 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2495,8 +2495,8 @@ static int cma_listen_handler(struct rdma_cm_id *id,
 	return id_priv->id.event_handler(id, event);
 }
 
-static void cma_listen_on_dev(struct rdma_id_private *id_priv,
-			      struct cma_device *cma_dev)
+static int cma_listen_on_dev(struct rdma_id_private *id_priv,
+			     struct cma_device *cma_dev)
 {
 	struct rdma_id_private *dev_id_priv;
 	struct net *net = id_priv->id.route.addr.dev_addr.net;
@@ -2505,13 +2505,13 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	lockdep_assert_held(&lock);
 
 	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
-		return;
+		return 0;
 
 	dev_id_priv =
 		__rdma_create_id(net, cma_listen_handler, id_priv,
 				 id_priv->id.ps, id_priv->id.qp_type, id_priv);
 	if (IS_ERR(dev_id_priv))
-		return;
+		return PTR_ERR(dev_id_priv);
 
 	dev_id_priv->state = RDMA_CM_ADDR_BOUND;
 	memcpy(cma_src_addr(dev_id_priv), cma_src_addr(id_priv),
@@ -2527,19 +2527,34 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	ret = rdma_listen(&dev_id_priv->id, id_priv->backlog);
 	if (ret)
-		dev_warn(&cma_dev->device->dev,
-			 "RDMA CMA: cma_listen_on_dev, error %d\n", ret);
+		goto err_listen;
+	return 0;
+err_listen:
+	list_del(&id_priv->listen_list);
+	dev_warn(&cma_dev->device->dev, "RDMA CMA: %s, error %d\n", __func__, ret);
+	rdma_destroy_id(&dev_id_priv->id);
+	return ret;
 }
 
-static void cma_listen_on_all(struct rdma_id_private *id_priv)
+static int cma_listen_on_all(struct rdma_id_private *id_priv)
 {
 	struct cma_device *cma_dev;
+	int ret;
 
 	mutex_lock(&lock);
 	list_add_tail(&id_priv->list, &listen_any_list);
-	list_for_each_entry(cma_dev, &dev_list, list)
-		cma_listen_on_dev(id_priv, cma_dev);
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		ret = cma_listen_on_dev(id_priv, cma_dev);
+		if (ret)
+			goto err_listen;
+	}
+	mutex_unlock(&lock);
+	return 0;
+
+err_listen:
+	list_del(&id_priv->list);
 	mutex_unlock(&lock);
+	return ret;
 }
 
 void rdma_set_service_type(struct rdma_cm_id *id, int tos)
@@ -3692,8 +3707,11 @@ int rdma_listen(struct rdma_cm_id *id, int backlog)
 			ret = -ENOSYS;
 			goto err;
 		}
-	} else
-		cma_listen_on_all(id_priv);
+	} else {
+		ret = cma_listen_on_all(id_priv);
+		if (ret)
+			goto err;
+	}
 
 	return 0;
 err:
@@ -4773,69 +4791,6 @@ static struct notifier_block cma_nb = {
 	.notifier_call = cma_netdev_callback
 };
 
-static int cma_add_one(struct ib_device *device)
-{
-	struct cma_device *cma_dev;
-	struct rdma_id_private *id_priv;
-	unsigned int i;
-	unsigned long supported_gids = 0;
-	int ret;
-
-	cma_dev = kmalloc(sizeof *cma_dev, GFP_KERNEL);
-	if (!cma_dev)
-		return -ENOMEM;
-
-	cma_dev->device = device;
-	cma_dev->default_gid_type = kcalloc(device->phys_port_cnt,
-					    sizeof(*cma_dev->default_gid_type),
-					    GFP_KERNEL);
-	if (!cma_dev->default_gid_type) {
-		ret = -ENOMEM;
-		goto free_cma_dev;
-	}
-
-	cma_dev->default_roce_tos = kcalloc(device->phys_port_cnt,
-					    sizeof(*cma_dev->default_roce_tos),
-					    GFP_KERNEL);
-	if (!cma_dev->default_roce_tos) {
-		ret = -ENOMEM;
-		goto free_gid_type;
-	}
-
-	rdma_for_each_port (device, i) {
-		supported_gids = roce_gid_type_mask_support(device, i);
-		WARN_ON(!supported_gids);
-		if (supported_gids & (1 << CMA_PREFERRED_ROCE_GID_TYPE))
-			cma_dev->default_gid_type[i - rdma_start_port(device)] =
-				CMA_PREFERRED_ROCE_GID_TYPE;
-		else
-			cma_dev->default_gid_type[i - rdma_start_port(device)] =
-				find_first_bit(&supported_gids, BITS_PER_LONG);
-		cma_dev->default_roce_tos[i - rdma_start_port(device)] = 0;
-	}
-
-	init_completion(&cma_dev->comp);
-	refcount_set(&cma_dev->refcount, 1);
-	INIT_LIST_HEAD(&cma_dev->id_list);
-	ib_set_client_data(device, &cma_client, cma_dev);
-
-	mutex_lock(&lock);
-	list_add_tail(&cma_dev->list, &dev_list);
-	list_for_each_entry(id_priv, &listen_any_list, list)
-		cma_listen_on_dev(id_priv, cma_dev);
-	mutex_unlock(&lock);
-
-	trace_cm_add_one(device);
-	return 0;
-
-free_gid_type:
-	kfree(cma_dev->default_gid_type);
-
-free_cma_dev:
-	kfree(cma_dev);
-	return ret;
-}
-
 static void cma_send_device_removal_put(struct rdma_id_private *id_priv)
 {
 	struct rdma_cm_event event = { .event = RDMA_CM_EVENT_DEVICE_REMOVAL };
@@ -4898,6 +4853,78 @@ static void cma_process_remove(struct cma_device *cma_dev)
 	wait_for_completion(&cma_dev->comp);
 }
 
+static int cma_add_one(struct ib_device *device)
+{
+	struct cma_device *cma_dev;
+	struct rdma_id_private *id_priv;
+	unsigned int i;
+	unsigned long supported_gids = 0;
+	int ret;
+
+	cma_dev = kmalloc(sizeof(*cma_dev), GFP_KERNEL);
+	if (!cma_dev)
+		return -ENOMEM;
+
+	cma_dev->device = device;
+	cma_dev->default_gid_type = kcalloc(device->phys_port_cnt,
+					    sizeof(*cma_dev->default_gid_type),
+					    GFP_KERNEL);
+	if (!cma_dev->default_gid_type) {
+		ret = -ENOMEM;
+		goto free_cma_dev;
+	}
+
+	cma_dev->default_roce_tos = kcalloc(device->phys_port_cnt,
+					    sizeof(*cma_dev->default_roce_tos),
+					    GFP_KERNEL);
+	if (!cma_dev->default_roce_tos) {
+		ret = -ENOMEM;
+		goto free_gid_type;
+	}
+
+	rdma_for_each_port (device, i) {
+		supported_gids = roce_gid_type_mask_support(device, i);
+		WARN_ON(!supported_gids);
+		if (supported_gids & (1 << CMA_PREFERRED_ROCE_GID_TYPE))
+			cma_dev->default_gid_type[i - rdma_start_port(device)] =
+				CMA_PREFERRED_ROCE_GID_TYPE;
+		else
+			cma_dev->default_gid_type[i - rdma_start_port(device)] =
+				find_first_bit(&supported_gids, BITS_PER_LONG);
+		cma_dev->default_roce_tos[i - rdma_start_port(device)] = 0;
+	}
+
+	init_completion(&cma_dev->comp);
+	refcount_set(&cma_dev->refcount, 1);
+	INIT_LIST_HEAD(&cma_dev->id_list);
+	ib_set_client_data(device, &cma_client, cma_dev);
+
+	mutex_lock(&lock);
+	list_add_tail(&cma_dev->list, &dev_list);
+	list_for_each_entry(id_priv, &listen_any_list, list) {
+		ret = cma_listen_on_dev(id_priv, cma_dev);
+		if (ret)
+			goto free_listen;
+	}
+	mutex_unlock(&lock);
+
+	trace_cm_add_one(device);
+	return 0;
+
+free_listen:
+	list_del(&cma_dev->list);
+	mutex_unlock(&lock);
+
+	cma_process_remove(cma_dev);
+	kfree(cma_dev->default_roce_tos);
+free_gid_type:
+	kfree(cma_dev->default_gid_type);
+
+free_cma_dev:
+	kfree(cma_dev);
+	return ret;
+}
+
 static void cma_remove_one(struct ib_device *device, void *client_data)
 {
 	struct cma_device *cma_dev = client_data;
-- 
2.27.0



