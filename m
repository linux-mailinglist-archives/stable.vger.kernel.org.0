Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A12A3C544D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348378AbhGLH5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352125AbhGLHyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 181D6613D2;
        Mon, 12 Jul 2021 07:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076279;
        bh=oU+Y7ODhxdkw54tHVQNHNpC9dNaCUEfAmbeB35i1rU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNqO4hrK9N9Y8M7c9TTKrCqJwBO6/sOZJsaKjk0ZZkKP/rGDitdW3ztAj6/KzjIEF
         BuPfqgTs3sa04WQSvZy1ZbK7zaWem1cgU5smSo/Sz22q/Pvwgq0OZjGQph1OakRigH
         rDmD0PL4UKyQUE13cxEcmjrLkL6GA+6urVVJwQUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 576/800] RDMA/cma: Fix incorrect Packet Lifetime calculation
Date:   Mon, 12 Jul 2021 08:09:59 +0200
Message-Id: <20210712061028.641758557@linuxfoundation.org>
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

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit e84045eab69c625bc0b0bf24d8e05bc65da1eed1 ]

An approximation for the PacketLifeTime is half the local ACK timeout.
The encoding for both timers are logarithmic.

If the local ACK timeout is set, but zero, it means the timer is
disabled. In this case, we choose the CMA_IBOE_PACKET_LIFETIME value,
since 50% of infinite makes no sense.

Before this commit, the PacketLifeTime became 255 if local ACK
timeout was zero (not running).

Fixed by explicitly testing for timeout being zero.

Fixes: e1ee1e62bec4 ("RDMA/cma: Use ACK timeout for RoCE packetLifeTime")
Link: https://lore.kernel.org/r/1624371207-26710-1-git-send-email-haakon.bugge@oracle.com
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index a5ec61ac11cc..8bbffa04fb48 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3096,8 +3096,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
 	 * as a reasonable approximation for RoCE networks.
 	 */
 	mutex_lock(&id_priv->qp_mutex);
-	route->path_rec->packet_life_time = id_priv->timeout_set ?
-		id_priv->timeout - 1 : CMA_IBOE_PACKET_LIFETIME;
+	if (id_priv->timeout_set && id_priv->timeout)
+		route->path_rec->packet_life_time = id_priv->timeout - 1;
+	else
+		route->path_rec->packet_life_time = CMA_IBOE_PACKET_LIFETIME;
 	mutex_unlock(&id_priv->qp_mutex);
 
 	if (!route->path_rec->mtu) {
-- 
2.30.2



