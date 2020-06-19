Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FDD200EA5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391262AbgFSPJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391964AbgFSPJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D8A620776;
        Fri, 19 Jun 2020 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579387;
        bh=tHem92zshHOrndbxX8cm28aAXY0RKpx+8lmYqeiiAsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzACoZBJrS8G5Lm5+lUgBtg6zghPwnUsDojuZyOMKXIgeYTKwY8TYFsuKEivDlUb5
         l5vpnbwzoG1h6Z1zWOMt4Malcwvk0UQfFSgMgUn7GVa4SErXDc3JuWNLia4TOpZB/P
         bmLkyAyaqjDgEfsYNSpzqps4lkeJOW73VUBiCCp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/261] net/mlx5e: IPoIB, Drop multicast packets that this interface sent
Date:   Fri, 19 Jun 2020 16:32:07 +0200
Message-Id: <20200619141655.438157866@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

[ Upstream commit 8b46d424a743ddfef8056d5167f13ee7ebd1dcad ]

After enabled loopback packets for IPoIB, we need to drop these packets
that this HCA has replicated and came back to the same interface that
sent them.

Fixes: 4c6c615e3f30 ("net/mlx5e: IPoIB, Add PKEY child interface nic profile")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index c4eed5bbcd45..066bada4ccd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1428,6 +1428,7 @@ out:
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
 
+#define MLX5_IB_GRH_SGID_OFFSET 8
 #define MLX5_IB_GRH_DGID_OFFSET 24
 #define MLX5_GID_SIZE           16
 
@@ -1441,6 +1442,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 	char *pseudo_header;
+	u32 flags_rqpn;
 	u32 qpn;
 	u8 *dgid;
 	u8 g;
@@ -1462,7 +1464,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	tstamp = &priv->tstamp;
 	stats = &priv->channel_stats[rq->ix].rq;
 
-	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
+	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
+	g = (flags_rqpn >> 28) & 3;
 	dgid = skb->data + MLX5_IB_GRH_DGID_OFFSET;
 	if ((!g) || dgid[0] != 0xff)
 		skb->pkt_type = PACKET_HOST;
@@ -1471,9 +1474,15 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	else
 		skb->pkt_type = PACKET_MULTICAST;
 
-	/* TODO: IB/ipoib: Allow mcast packets from other VFs
-	 * 68996a6e760e5c74654723eeb57bf65628ae87f4
+	/* Drop packets that this interface sent, ie multicast packets
+	 * that the HCA has replicated.
 	 */
+	if (g && (qpn == (flags_rqpn & 0xffffff)) &&
+	    (memcmp(netdev->dev_addr + 4, skb->data + MLX5_IB_GRH_SGID_OFFSET,
+		    MLX5_GID_SIZE) == 0)) {
+		skb->dev = NULL;
+		return;
+	}
 
 	skb_pull(skb, MLX5_IB_GRH_BYTES);
 
-- 
2.25.1



