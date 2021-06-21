Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370B73AEF85
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhFUQkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhFUQhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85D666100A;
        Mon, 21 Jun 2021 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292934;
        bh=L1d6I5VKLiIbY9lV5ChXDEgSH6YenZtYxZcqv9O/R0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pJTN4Yi/djM/RoG1G2YtwFS5vThlhnagc2/Ll8pyRpFBps6VBxtRuBWoz6afc0LGE
         Gej4my+P87hP+SOBI+Cy0J64QsaIK7beZJC50migfVSX7vOdsT4OX7qRuft2da77gT
         2UTmxCnLMT8uCY1dTGoXcwFZBgEZQ44ICnjHvJRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 039/178] net/mlx5e: Block offload of outer header csum for GRE tunnel
Date:   Mon, 21 Jun 2021 18:14:13 +0200
Message-Id: <20210621154923.436504321@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 54e1217b90486c94b26f24dcee1ee5ef5372f832 ]

The device is able to offload either the outer header csum or inner
header csum. The driver utilizes the inner csum offload. So, prohibit
setting of tx-gre-csum-segmentation and let it be: off[fixed].

Fixes: 2729984149e6 ("net/mlx5e: Support TSO and TX checksum offloads for GRE tunnels")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2a3da167f248..16b8f5245032 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5174,12 +5174,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
-						NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_GRE;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-- 
2.30.2



