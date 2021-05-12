Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EAD37CA82
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240640AbhELQal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237057AbhELQYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8CEE61D9E;
        Wed, 12 May 2021 15:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834461;
        bh=BF5L2viBDwu4eSkX3VQPvuiAqggLe+C/IEo9a50M6WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Idf1z0BcI2W44f3eos/FH4/LAC4Zkt3tlWb5B4rgphtyvRASLYHA0uyoxwKQP2Ins
         juSuDFu0BTDEXGUBrzmKEV3feEPv1bMvK3yuUILlN5Qib4pXQPTySv3GKtvW0+wZMx
         X67S/dXuTcu1CKVlhNBumLafy46u0PJUtLNgokLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 552/601] RDMA/core: Add CM to restrack after successful attachment to a device
Date:   Wed, 12 May 2021 16:50:29 +0200
Message-Id: <20210512144846.037433500@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit cb5cd0ea4eb3ce338a593a5331ddb4986ae20faa ]

The device attach triggers addition of CM_ID to the restrack DB.
However, when error occurs, we releasing this device, but defer CM_ID
release. This causes to the situation where restrack sees CM_ID that
is not valid anymore.

As a solution, add the CM_ID to the resource tracking DB only after the
attachment is finished.

Found by syzcaller:
infiniband syz0: added syz_tun
rdma_rxe: ignoring netdev event = 10 for syz_tun
infiniband syz0: set down
infiniband syz0: ib_query_port failed (-19)
restrack: ------------[ cut here    ]------------
infiniband syz0: BUG: RESTRACK detected leak of resources
restrack: User CM_ID object allocated by syz-executor716 is not freed
restrack: ------------[ cut here    ]------------

Fixes: b09c4d701220 ("RDMA/restrack: Improve readability in task name management")
Link: https://lore.kernel.org/r/ab93e56ba831eac65c322b3256796fa1589ec0bb.1618753862.git.leonro@nvidia.com
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e3638f80e1d5..6af066a2c8c0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -463,7 +463,6 @@ static void _cma_attach_to_dev(struct rdma_id_private *id_priv,
 	id_priv->id.route.addr.dev_addr.transport =
 		rdma_node_get_transport(cma_dev->device->node_type);
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
-	rdma_restrack_add(&id_priv->res);
 
 	trace_cm_id_attach(id_priv, cma_dev->device);
 }
@@ -700,6 +699,7 @@ static int cma_ib_acquire_dev(struct rdma_id_private *id_priv,
 	mutex_lock(&lock);
 	cma_attach_to_dev(id_priv, listen_id_priv->cma_dev);
 	mutex_unlock(&lock);
+	rdma_restrack_add(&id_priv->res);
 	return 0;
 }
 
@@ -754,8 +754,10 @@ static int cma_iw_acquire_dev(struct rdma_id_private *id_priv,
 	}
 
 out:
-	if (!ret)
+	if (!ret) {
 		cma_attach_to_dev(id_priv, cma_dev);
+		rdma_restrack_add(&id_priv->res);
+	}
 
 	mutex_unlock(&lock);
 	return ret;
@@ -816,6 +818,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
 found:
 	cma_attach_to_dev(id_priv, cma_dev);
+	rdma_restrack_add(&id_priv->res);
 	mutex_unlock(&lock);
 	addr = (struct sockaddr_ib *)cma_src_addr(id_priv);
 	memcpy(&addr->sib_addr, &sgid, sizeof(sgid));
@@ -2529,6 +2532,7 @@ static int cma_listen_on_dev(struct rdma_id_private *id_priv,
 	       rdma_addr_size(cma_src_addr(id_priv)));
 
 	_cma_attach_to_dev(dev_id_priv, cma_dev);
+	rdma_restrack_add(&dev_id_priv->res);
 	cma_id_get(id_priv);
 	dev_id_priv->internal_id = 1;
 	dev_id_priv->afonly = id_priv->afonly;
@@ -3169,6 +3173,7 @@ port_found:
 	ib_addr_set_pkey(&id_priv->id.route.addr.dev_addr, pkey);
 	id_priv->id.port_num = p;
 	cma_attach_to_dev(id_priv, cma_dev);
+	rdma_restrack_add(&id_priv->res);
 	cma_set_loopback(cma_src_addr(id_priv));
 out:
 	mutex_unlock(&lock);
@@ -3201,6 +3206,7 @@ static void addr_handler(int status, struct sockaddr *src_addr,
 		if (status)
 			pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to acquire device. status %d\n",
 					     status);
+		rdma_restrack_add(&id_priv->res);
 	} else if (status) {
 		pr_debug_ratelimited("RDMA CM: ADDR_ERROR: failed to resolve IP. status %d\n", status);
 	}
@@ -3812,6 +3818,8 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (ret)
 		goto err2;
 
+	if (!cma_any_addr(addr))
+		rdma_restrack_add(&id_priv->res);
 	return 0;
 err2:
 	if (id_priv->cma_dev)
-- 
2.30.2



