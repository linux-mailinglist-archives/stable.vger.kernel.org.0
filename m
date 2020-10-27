Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5D129B24F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761322AbgJ0Oi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761311AbgJ0Oix (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42D76207BB;
        Tue, 27 Oct 2020 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809532;
        bh=eF+EKJ5C6rYnUyS32ry4OCUo7eXi0HAcwsgqhmA/lyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7/YCZcn/BDhCg4aZyrzhCV4LhPvLIF9axgrO23PpH6VxUupOE9STA6fi2hRPolBB
         E4tcXEgKRytW+3DuwZ3nxLRnXHuH/DXykBEvc8kB8E74hQF0ls9AZOdWi/OqyIqsIE
         erHFLSAnDFUPVeDafTLUt85Xu8bnNAYakqqcccac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 230/408] RDMA/cma: Consolidate the destruction of a cma_multicast in one place
Date:   Tue, 27 Oct 2020 14:52:48 +0100
Message-Id: <20201027135505.732793418@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 3788d2997bc0150ea911a964d5b5a2e11808a936 ]

Two places were open coding this sequence, and also pull in
cma_leave_roce_mc_group() which was called only once.

Link: https://lore.kernel.org/r/20200902081122.745412-8-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 63 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 10525c91cac6c..98d2d74b96f78 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1803,19 +1803,30 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 	mutex_unlock(&lock);
 }
 
-static void cma_leave_roce_mc_group(struct rdma_id_private *id_priv,
-				    struct cma_multicast *mc)
+static void destroy_mc(struct rdma_id_private *id_priv,
+		       struct cma_multicast *mc)
 {
-	struct rdma_dev_addr *dev_addr = &id_priv->id.route.addr.dev_addr;
-	struct net_device *ndev = NULL;
+	if (rdma_cap_ib_mcast(id_priv->id.device, id_priv->id.port_num)) {
+		ib_sa_free_multicast(mc->multicast.ib);
+		kfree(mc);
+		return;
+	}
 
-	if (dev_addr->bound_dev_if)
-		ndev = dev_get_by_index(dev_addr->net, dev_addr->bound_dev_if);
-	if (ndev) {
-		cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid, false);
-		dev_put(ndev);
+	if (rdma_protocol_roce(id_priv->id.device,
+				      id_priv->id.port_num)) {
+		struct rdma_dev_addr *dev_addr =
+			&id_priv->id.route.addr.dev_addr;
+		struct net_device *ndev = NULL;
+
+		if (dev_addr->bound_dev_if)
+			ndev = dev_get_by_index(dev_addr->net,
+						dev_addr->bound_dev_if);
+		if (ndev) {
+			cma_igmp_send(ndev, &mc->multicast.ib->rec.mgid, false);
+			dev_put(ndev);
+		}
+		kref_put(&mc->mcref, release_mc);
 	}
-	kref_put(&mc->mcref, release_mc);
 }
 
 static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
@@ -1823,16 +1834,10 @@ static void cma_leave_mc_groups(struct rdma_id_private *id_priv)
 	struct cma_multicast *mc;
 
 	while (!list_empty(&id_priv->mc_list)) {
-		mc = container_of(id_priv->mc_list.next,
-				  struct cma_multicast, list);
+		mc = list_first_entry(&id_priv->mc_list, struct cma_multicast,
+				      list);
 		list_del(&mc->list);
-		if (rdma_cap_ib_mcast(id_priv->cma_dev->device,
-				      id_priv->id.port_num)) {
-			ib_sa_free_multicast(mc->multicast.ib);
-			kfree(mc);
-		} else {
-			cma_leave_roce_mc_group(id_priv, mc);
-		}
+		destroy_mc(id_priv, mc);
 	}
 }
 
@@ -4490,20 +4495,14 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	id_priv = container_of(id, struct rdma_id_private, id);
 	spin_lock_irq(&id_priv->lock);
 	list_for_each_entry(mc, &id_priv->mc_list, list) {
-		if (!memcmp(&mc->addr, addr, rdma_addr_size(addr))) {
-			list_del(&mc->list);
-			spin_unlock_irq(&id_priv->lock);
-
-			BUG_ON(id_priv->cma_dev->device != id->device);
+		if (memcmp(&mc->addr, addr, rdma_addr_size(addr)) != 0)
+			continue;
+		list_del(&mc->list);
+		spin_unlock_irq(&id_priv->lock);
 
-			if (rdma_cap_ib_mcast(id->device, id->port_num)) {
-				ib_sa_free_multicast(mc->multicast.ib);
-				kfree(mc);
-			} else if (rdma_protocol_roce(id->device, id->port_num)) {
-				cma_leave_roce_mc_group(id_priv, mc);
-			}
-			return;
-		}
+		WARN_ON(id_priv->cma_dev->device != id->device);
+		destroy_mc(id_priv, mc);
+		return;
 	}
 	spin_unlock_irq(&id_priv->lock);
 }
-- 
2.25.1



