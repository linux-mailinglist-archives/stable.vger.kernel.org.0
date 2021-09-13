Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ED440947C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241058AbhIMOba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:31:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346883AbhIMO3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58E8E61B73;
        Mon, 13 Sep 2021 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541043;
        bh=+Zu1pgGVllMnvRvGzW5ASeV95Xu79FmbpBM3//tfPnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXs5+p62qhlxv04nAwDqWjYVKoSrxxII92+OEMSlFCMgeN98BFooJmoc3FHboFIZS
         Xm1ZEZcVrfiC5MAGKS6tflh837q9OUUUgn4z0IF/Oi5SFfDLdPnOg6HPByqXrX50RV
         dxrlxePUpGxbqQkGupwGF9l1yavYx8tRpcYvFDSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 132/334] net/mlx5e: Block LRO if firmware asks for tunneled LRO
Date:   Mon, 13 Sep 2021 15:13:06 +0200
Message-Id: <20210913131117.831653275@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 26ab7b384525ccfa678c518577f7f0d841209c8b ]

This commit does a cleanup in LRO configuration.

LRO is a parameter of an RQ, but its state is changed by modifying a TIR
related to the RQ.

The current status: LRO for tunneled packets is not supported in the
driver, inner TIRs may enable LRO on creation, but LRO status of inner
TIRs isn't changed in mlx5e_modify_tirs_lro(). This is inconsistent, but
as long as the firmware doesn't declare support for tunneled LRO, it
works, because the same RQs are shared between the inner and outer TIRs.

This commit does two fixes:

1. If the firmware has the tunneled LRO capability, LRO is blocked
altogether, because it's not possible to block it for inner TIRs only,
when the same RQs are shared between inner and outer TIRs, and the
driver won't be able to handle tunneled LRO traffic.

2. mlx5e_modify_tirs_lro() is patched to modify LRO state for all TIRs,
including inner ones, because all TIRs related to an RQ should agree on
their LRO state.

Fixes: 7b3722fa9ef6 ("net/mlx5e: Support RSS for GRE tunneled packets")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                     |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 24f919ef9b8e..b7be1ef4cbb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2567,6 +2567,14 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
 		if (err)
 			goto free_in;
+
+		/* Verify inner tirs resources allocated */
+		if (!priv->inner_indir_tir[0].tirn)
+			continue;
+
+		err = mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
+		if (err)
+			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
@@ -4812,7 +4820,14 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_TX;
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_RX;
 
+	/* Tunneled LRO is not supported in the driver, and the same RQs are
+	 * shared between inner and outer TIRs, so the driver can't disable LRO
+	 * for inner TIRs while having it enabled for outer TIRs. Due to this,
+	 * block LRO altogether if the firmware declares tunneled LRO support.
+	 */
 	if (!!MLX5_CAP_ETH(mdev, lro_cap) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
 		netdev->vlan_features    |= NETIF_F_LRO;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b0009aa3647f..6bbae0c3bc0b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -921,7 +921,8 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         scatter_fcs[0x1];
 	u8         enhanced_multi_pkt_send_wqe[0x1];
 	u8         tunnel_lso_const_out_ip_id[0x1];
-	u8         reserved_at_1c[0x2];
+	u8         tunnel_lro_gre[0x1];
+	u8         tunnel_lro_vxlan[0x1];
 	u8         tunnel_stateless_gre[0x1];
 	u8         tunnel_stateless_vxlan[0x1];
 
-- 
2.30.2



