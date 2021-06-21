Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B657D3AEE4C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFUQ1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhFUQ0B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:26:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03402613C1;
        Mon, 21 Jun 2021 16:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292529;
        bh=T1FKjeiXzn7t4vZ0WJ/akKPVTTpnjOBDTccC6E2CKGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4+vigPBWY4KZzl1l589TE0Zdnkl4WVXFOL4tEmy/e4JsI/nwYbLNzQ50o31dUuXD
         3eTjF7H86bg4viJeahwD8ZaphuXLxPbWrpSStkE2HwNJ0mwZEtoCWmfurV2gUdoFjH
         qAHD4gnYcXIWasUp4g0zoSD9vWariSfPcnaH0yUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/146] net/mlx5e: Block offload of outer header csum for UDP tunnels
Date:   Mon, 21 Jun 2021 18:14:23 +0200
Message-Id: <20210621154912.420288004@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 6d6727dddc7f93fcc155cb8d0c49c29ae0e71122 ]

The device is able to offload either the outer header csum or inner
header csum. The driver utilizes the inner csum offload. Hence, block
setting of tx-udp_tnl-csum-segmentation and set it to off[fixed].

Fixes: b49663c8fb49 ("net/mlx5e: Add support for UDP tunnel segmentation with outer checksum offload")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f18b52be32e9..d81fa8e56199 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4958,13 +4958,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
 	}
 
 	if (mlx5e_tunnel_proto_supported(mdev, IPPROTO_GRE)) {
-- 
2.30.2



