Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B582F143B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732863AbhAKNWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:22:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732740AbhAKNSp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29F6B2246B;
        Mon, 11 Jan 2021 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371083;
        bh=TiAEgY/qhJGrDG/gk3tmvc2efZDSqfTyUW2aM5LIOjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=048Vi6X23Rh+hAHt9asIfVjXnlbu/jO1q/OhuKQpmak43uN86FX8UtQhkiSuEq4Zj
         R7GXQpWGw3T8l0DSN3eG2pW5i5Xmco3Ml5+KD+c9s31YKFzectPmVI/d+3+W9rFRbt
         fS6o7Wfm19Ub81gtXSvmdMrR9i0sKQWEKpG7bWeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 135/145] net/mlx5e: Fix SWP offsets when vlan inserted by driver
Date:   Mon, 11 Jan 2021 14:02:39 +0100
Message-Id: <20210111130054.997561002@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

commit b544011f0e58ce43c40105468d6dc67f980a0c7a upstream.

In case WQE includes inline header the vlan is inserted by driver even
if vlan offload is set. On geneve over vlan interface where software
parser is used the SWP offsets should be updated according to the added
vlan.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h           |    9 +++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h |    8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c             |    9 +++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -366,6 +366,15 @@ struct mlx5e_swp_spec {
 	u8 tun_l4_proto;
 };
 
+static inline void mlx5e_eseg_swp_offsets_add_vlan(struct mlx5_wqe_eth_seg *eseg)
+{
+	/* SWP offsets are in 2-bytes words */
+	eseg->swp_outer_l3_offset += VLAN_HLEN / 2;
+	eseg->swp_outer_l4_offset += VLAN_HLEN / 2;
+	eseg->swp_inner_l3_offset += VLAN_HLEN / 2;
+	eseg->swp_inner_l4_offset += VLAN_HLEN / 2;
+}
+
 static inline void
 mlx5e_set_eseg_swp(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg,
 		   struct mlx5e_swp_spec *swp_spec)
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -51,7 +51,7 @@ static inline bool mlx5_geneve_tx_allowe
 }
 
 static inline void
-mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
+mlx5e_tx_tunnel_accel(struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
 	struct mlx5e_swp_spec swp_spec = {};
 	unsigned int offset = 0;
@@ -85,6 +85,8 @@ mlx5e_tx_tunnel_accel(struct sk_buff *sk
 	}
 
 	mlx5e_set_eseg_swp(skb, eseg, &swp_spec);
+	if (skb_vlan_tag_present(skb) &&  ihs)
+		mlx5e_eseg_swp_offsets_add_vlan(eseg);
 }
 
 #else
@@ -163,7 +165,7 @@ static inline unsigned int mlx5e_accel_t
 
 static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
 				       struct sk_buff *skb,
-				       struct mlx5_wqe_eth_seg *eseg)
+				       struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (xfrm_offload(skb))
@@ -172,7 +174,7 @@ static inline bool mlx5e_accel_tx_eseg(s
 
 #if IS_ENABLED(CONFIG_GENEVE)
 	if (skb->encapsulation)
-		mlx5e_tx_tunnel_accel(skb, eseg);
+		mlx5e_tx_tunnel_accel(skb, eseg, ihs);
 #endif
 
 	return true;
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -615,9 +615,9 @@ void mlx5e_tx_mpwqe_ensure_complete(stru
 
 static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_txqsq *sq,
 				   struct sk_buff *skb, struct mlx5e_accel_tx_state *accel,
-				   struct mlx5_wqe_eth_seg *eseg)
+				   struct mlx5_wqe_eth_seg *eseg, u16 ihs)
 {
-	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg)))
+	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg, ihs)))
 		return false;
 
 	mlx5e_txwqe_build_eseg_csum(sq, skb, accel, eseg);
@@ -647,7 +647,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *s
 		if (mlx5e_tx_skb_supports_mpwqe(skb, &attr)) {
 			struct mlx5_wqe_eth_seg eseg = {};
 
-			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg)))
+			if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &eseg,
+							     attr.ihs)))
 				return NETDEV_TX_OK;
 
 			mlx5e_sq_xmit_mpwqe(sq, skb, &eseg, netdev_xmit_more());
@@ -664,7 +665,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *s
 	/* May update the WQE, but may not post other WQEs. */
 	mlx5e_accel_tx_finish(sq, wqe, &accel,
 			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
-	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth)))
+	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &accel, &wqe->eth, attr.ihs)))
 		return NETDEV_TX_OK;
 
 	mlx5e_sq_xmit_wqe(sq, skb, &attr, &wqe_attr, wqe, pi, netdev_xmit_more());


