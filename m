Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627BF29B22E
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761303AbgJ0Oiv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761300AbgJ0Oiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71664207BB;
        Tue, 27 Oct 2020 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809530;
        bh=qTAJKcr5QfV7qdmRojt05ZdjWrzjGb4muDon/pNya5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ghl80N/1s1TFE+8PN26L9NTCWUtYQGzphG19nD+rbrsoK7SwiQl5l31ZWuzrSqLDk
         G46ZjqmTncR9sxVWLuQHVlOpHIXBuVzbSDIOP/Dy70DZwrdZqvIjCcl8Uk9tJlpcJn
         CMo8JnCfum0a08z0xqdEQwf8FLmSCqm1fUWoY4fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 229/408] RDMA/cma: Remove dead code for kernel rdmacm multicast
Date:   Tue, 27 Oct 2020 14:52:47 +0100
Message-Id: <20201027135505.691605272@linuxfoundation.org>
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
index e3cd9d2b0dd2b..10525c91cac6c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4182,16 +4182,6 @@ static int cma_ib_mc_handler(int status, struct ib_sa_multicast *multicast)
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
@@ -4446,6 +4436,10 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	struct cma_multicast *mc;
 	int ret;
 
+	/* Not supported for kernel QPs */
+	if (WARN_ON(id->qp))
+		return -EINVAL;
+
 	if (!id->device)
 		return -EINVAL;
 
@@ -4500,11 +4494,6 @@ void rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
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



