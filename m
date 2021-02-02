Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C35A30C061
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhBBN40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhBBNyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A61AD64FD3;
        Tue,  2 Feb 2021 13:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273469;
        bh=U7HNZD5zZ1flbnrXuaGM5OWWHu/vOy1T3smhO+6FDnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FVYoSvCBQRoRpwIaYvnIBHZIi7axcDpBybjkGrG0M6/04MKnjiEX1O8jgCrs3Eqv
         Gk5s8r4ogczYZy4nR5C/km2FNg2zCL+iWz03RW7yHw8L8WnTC7p6cwdB/EZVZHNH6w
         Q9hcgaxjM4IIdqjCCWqYB8Oi+Vqi/24bhfjNU3+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/142] net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled
Date:   Tue,  2 Feb 2021 14:38:02 +0100
Message-Id: <20210202133002.617653572@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 156878d0e697187c7d207ee6c22afe50b7f3678c ]

The cited commit introduce new CONFIG_MLX5_CLS_ACT kconfig variable
to control compilation of TC hardware offloads implementation.
When this configuration is disabled the driver is still wrongly
reports in ethtool that hw-tc-offload is supported.

Fixed by reporting hw-tc-offload is supported only when
CONFIG_MLX5_CLS_ACT is enabled.

Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC support")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ebce97921e03c..ba6c75618a710 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4990,7 +4990,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    FT_CAP(modify_root) &&
 	    FT_CAP(identified_miss_table_mode) &&
 	    FT_CAP(flow_table_modify)) {
-#ifdef CONFIG_MLX5_ESWITCH
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 		netdev->hw_features      |= NETIF_F_HW_TC;
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 67247c33b9fd6..304435e561170 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -738,7 +738,9 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 
 	netdev->features       |= NETIF_F_NETNS_LOCAL;
 
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	netdev->hw_features    |= NETIF_F_HW_TC;
+#endif
 	netdev->hw_features    |= NETIF_F_SG;
 	netdev->hw_features    |= NETIF_F_IP_CSUM;
 	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
-- 
2.27.0



