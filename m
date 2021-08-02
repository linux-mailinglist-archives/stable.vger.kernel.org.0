Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756723DDA1D
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhHBOGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235731AbhHBODR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46EFD6124B;
        Mon,  2 Aug 2021 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912633;
        bh=cVelJkhvseI4o4ns7nAQi66mJf1r3ubjKSeahjw8QLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwNOYxdjNXHYZNr6MamFI5fCqiuXDlpsx7WbVKDcgSfqqb1qo83uc+aPwYuTDBFxP
         90nFr8SDTRNlHeOGUQnnbXLly+zIgnAi280n4B9iEnGGIqWng4/ar2N/wMIWYxopEC
         L7hI/JNnh5dcDFEaPecdYjf2d3UnFzATYUMhkMjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 080/104] net/mlx5e: Add NETIF_F_HW_TC to hw_features when HTB offload is available
Date:   Mon,  2 Aug 2021 15:45:17 +0200
Message-Id: <20210802134346.642859271@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 9841d58f3550d11c6181424427e8ad8c9c80f1b6 ]

If a feature flag is only present in features, but not in hw_features,
the user can't reset it. Although hw_features may contain NETIF_F_HW_TC
by the point where the driver checks whether HTB offload is supported,
this flag is controlled by another condition that may not hold. Set it
explicitly to make sure the user can disable it.

Fixes: 214baf22870c ("net/mlx5e: Support HTB offload")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 86a27b0b42cb..d0d9acb17253 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4866,6 +4866,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	if (MLX5_CAP_ETH(mdev, scatter_fcs))
 		netdev->hw_features |= NETIF_F_RXFCS;
 
+	if (mlx5_qos_is_supported(mdev))
+		netdev->hw_features |= NETIF_F_HW_TC;
+
 	netdev->features          = netdev->hw_features;
 
 	/* Defaults */
@@ -4886,8 +4889,6 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_features	 |= NETIF_F_NTUPLE;
 #endif
 	}
-	if (mlx5_qos_is_supported(mdev))
-		netdev->features |= NETIF_F_HW_TC;
 
 	netdev->features         |= NETIF_F_HIGHDMA;
 	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
-- 
2.30.2



