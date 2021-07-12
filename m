Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF933C4A2B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbhGLGs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237110AbhGLGr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 403FE610D1;
        Mon, 12 Jul 2021 06:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072231;
        bh=InqpK1j5z2eLBKUBzg9eOK6bJDw5GG1+7K2qQRNao5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHLamJbOc7DINNC5SOxeNghge970thZaf2dc+cRSabEcMLa8xS3w02oJwveRXsAsu
         VEvQs2ljhiQ+CFLq151z16/vJD3qKcLr5Vk3Ka+ypG/NKcGmO33M+KimBTEfcJPCgF
         P6S+t73o4bvPZq7lazLlcJdHvo6PfOouKU4llqvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 410/593] RDMA/cma: Fix incorrect Packet Lifetime calculation
Date:   Mon, 12 Jul 2021 08:09:30 +0200
Message-Id: <20210712060932.967933647@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index f2fd4bc2fbec..be4e447134b3 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -3060,8 +3060,10 @@ static int cma_resolve_iboe_route(struct rdma_id_private *id_priv)
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



