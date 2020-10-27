Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ACF29C3E4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822619AbgJ0RvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:51:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758840AbgJ0OYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18C6320790;
        Tue, 27 Oct 2020 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808673;
        bh=Fg0bRHghuVdI2SDBFhahCPoh2rNAf3dvbbu7uUDbyGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LJZfAGztYgFSjhh0sLNlOwWTFEzzGCM6uM3x7CuWwB/FzuV3+K8isTRPdfL3Lau2W
         7V8+S6h9bcE3QFDVxSTzaW3N4QbvBumfT3wfQXOS9V1umDUerRuYw2WWYwU+y6FvZR
         g9To3o2zwQ+GUJ5ePYJ655sK7CGdIVWWWG//hQaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/264] RDMA/cma: Remove dead code for kernel rdmacm multicast
Date:   Tue, 27 Oct 2020 14:53:28 +0100
Message-Id: <20201027135437.717563734@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1bb5091def706732c749df9aae45fbca003696f2 ]

There is no kernel user of RDMA CM multicast so this code managing the
multicast subscription of the kernel-only internal QP is dead. Remove it.

This makes the bug fixes in the next patches much simpler.

Link: https://lore.kernel.org/r/20200902081122.745412-7-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 1f14cd4ce3db5..65c15114cbe7a 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4020,16 +4020,6 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
 	else
 		pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to join multicast. status %d\n",
 				     status);
-	mutex_lock(&id_priv->qp_mutex);
-	if (!status && id_priv->id.qp) {
-		status = ib_attach_mcast(id_priv->id.qp, &multicast->rec.mgid,
-					 be16_to_cpu(multicast->rec.mlid));
-		if (status)
-			pr_debug_ratelimited("RDMA CM: MULTICAST_ERROR: failed to attach QP. status %d\n",
-					     status);
-	}
-	mutex_unlock(&id_priv->qp_mutex);
-
 	event.status = status;
 	event.param.ud.private_data = mc->context;
 	if (!status) {
@@ -4283,6 +4273,10 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	struct cma_multicast *mc;
 	int ret;
 
+	/* Not supported for kernel QPs */
+	if (WARN_ON(id->qp))
+		return -EINVAL;
+
 	if (!id->device)
 		return -EINVAL;
 
@@ -4337,11 +4331,6 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 			list_del(&mc->list);
 			spin_unlock_irq(&id_priv->lock);
 
-			if (id->qp)
-				ib_detach_mcast(id->qp,
-						&mc->multicast.ib->rec.mgid,
-						be16_to_cpu(mc->multicast.ib->rec.mlid));
-
 			BUG_ON(id_priv->cma_dev->device != id->device);
 
 			if (rdma_cap_ib_mcast(id->device, id->port_num)) {
-- 
2.25.1



