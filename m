Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B572F6C0
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731048AbfD3Lv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731064AbfD3Lv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:51:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03BEC2054F;
        Tue, 30 Apr 2019 11:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625116;
        bh=MKT2bNFm90NwYn7V4A/L8svS/z68gQVVGCrahN5th0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0PEMMdkevAOxJCuI+8ZaSzS3q/CIu5JgEYMVPkYe2BFhuj/w1MrSdWTIQp+H2V2gV
         3JhBpomahSLLun2gouQU1kGLv7LhScWU6qdg6JtkU/EdMu0D3K0b0cAp/q6CbMrhKF
         UTg8JTvF/zUo9jEc4LOp0HArbBGYBcRTNOhk/n6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.0 86/89] net/mlx5e: Fix the max MTU check in case of XDP
Date:   Tue, 30 Apr 2019 13:39:17 +0200
Message-Id: <20190430113613.837946199@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit d460c2718906252a2a69bc6f89b537071f792e6e ]

MLX5E_XDP_MAX_MTU was calculated incorrectly. It didn't account for
NET_IP_ALIGN and MLX5E_HW2SW_MTU, and it also misused MLX5_SKB_FRAG_SZ.
This commit fixes the calculations and adds a brief explanation for the
formula used.

Fixes: a26a5bdf3ee2d ("net/mlx5e: Restrict the combination of large MTU and XDP")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |   20 ++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h  |    3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 +++--
 3 files changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -33,6 +33,26 @@
 #include <linux/bpf_trace.h>
 #include "en/xdp.h"
 
+int mlx5e_xdp_max_mtu(struct mlx5e_params *params)
+{
+	int hr = NET_IP_ALIGN + XDP_PACKET_HEADROOM;
+
+	/* Let S := SKB_DATA_ALIGN(sizeof(struct skb_shared_info)).
+	 * The condition checked in mlx5e_rx_is_linear_skb is:
+	 *   SKB_DATA_ALIGN(sw_mtu + hard_mtu + hr) + S <= PAGE_SIZE         (1)
+	 *   (Note that hw_mtu == sw_mtu + hard_mtu.)
+	 * What is returned from this function is:
+	 *   max_mtu = PAGE_SIZE - S - hr - hard_mtu                         (2)
+	 * After assigning sw_mtu := max_mtu, the left side of (1) turns to
+	 * SKB_DATA_ALIGN(PAGE_SIZE - S) + S, which is equal to PAGE_SIZE,
+	 * because both PAGE_SIZE and S are already aligned. Any number greater
+	 * than max_mtu would make the left side of (1) greater than PAGE_SIZE,
+	 * so max_mtu is the maximum MTU allowed.
+	 */
+
+	return MLX5E_HW2SW_MTU(params, SKB_MAX_HEAD(hr));
+}
+
 static inline bool
 mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_dma_info *di,
 		    struct xdp_buff *xdp)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -34,13 +34,12 @@
 
 #include "en.h"
 
-#define MLX5E_XDP_MAX_MTU ((int)(PAGE_SIZE - \
-				 MLX5_SKB_FRAG_SZ(XDP_PACKET_HEADROOM)))
 #define MLX5E_XDP_MIN_INLINE (ETH_HLEN + VLAN_HLEN)
 #define MLX5E_XDP_TX_EMPTY_DS_COUNT \
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */)
 
+int mlx5e_xdp_max_mtu(struct mlx5e_params *params);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 		      void *va, u16 *rx_headroom, u32 *len);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq, struct mlx5e_rq *rq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3816,7 +3816,7 @@ int mlx5e_change_mtu(struct net_device *
 	if (params->xdp_prog &&
 	    !mlx5e_rx_is_linear_skb(priv->mdev, &new_channels.params)) {
 		netdev_err(netdev, "MTU(%d) > %d is not allowed while XDP enabled\n",
-			   new_mtu, MLX5E_XDP_MAX_MTU);
+			   new_mtu, mlx5e_xdp_max_mtu(params));
 		err = -EINVAL;
 		goto out;
 	}
@@ -4280,7 +4280,8 @@ static int mlx5e_xdp_allowed(struct mlx5
 
 	if (!mlx5e_rx_is_linear_skb(priv->mdev, &new_channels.params)) {
 		netdev_warn(netdev, "XDP is not allowed with MTU(%d) > %d\n",
-			    new_channels.params.sw_mtu, MLX5E_XDP_MAX_MTU);
+			    new_channels.params.sw_mtu,
+			    mlx5e_xdp_max_mtu(&new_channels.params));
 		return -EINVAL;
 	}
 


