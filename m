Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCCB4CF69E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiCGJm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241130AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2232717;
        Mon,  7 Mar 2022 01:40:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B23B810BC;
        Mon,  7 Mar 2022 09:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4A9C340E9;
        Mon,  7 Mar 2022 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646027;
        bh=8HHHIc/6dYPATmHRJwYrCr2nnQqxKaoscnZMWOcTvso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnMgWn4R6yfj4tdoSN9enAvjy4clynQ+nQdVF2Y603b3QXNtTvdS8rORiHDrFMyAf
         d/EPvL+xDvE8Bq0ktyt/t9NJWTVoNN011i4LiZH1htLRcYPfC8DfXCRL/q/ZTAR/bg
         g8SzKnB+ZAamLjCrWCNor8quKZWSK27sYgDj//LY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/262] net/mlx5e: IPsec: Refactor checksum code in tx data path
Date:   Mon,  7 Mar 2022 10:17:34 +0100
Message-Id: <20220307091705.577114699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit 428ffea0711a11efa0c1c4ee1fac27903ed091be ]

Part of code that is related solely to IPsec is always compiled in the
driver code regardless if the IPsec functionality is enabled or disabled
in the driver code, this will add unnecessary branch in case IPsec is
disabled at Tx data path.

Move IPsec related code to IPsec related file such that in case of IPsec
is disabled and because of unlikely macro the compiler should be able to
optimize and omit the checksum IPsec code all together from Tx data path

Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 26 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 20 ++------------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 5120a59361e6a..b98db50c3418d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -127,6 +127,25 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
+	if (!mlx5e_ipsec_eseg_meta(eseg))
+		return false;
+
+	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
+	if (xo->inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial_inner++;
+	}
+
+	return true;
+}
 #else
 static inline
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
@@ -143,6 +162,13 @@ static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false;
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 { return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+
+static inline bool
+mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+				  struct mlx5_wqe_eth_seg *eseg)
+{
+	return false;
+}
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 188994d091c54..7fd33b356cc8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -38,6 +38,7 @@
 #include "en/txrx.h"
 #include "ipoib/ipoib.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
@@ -213,30 +214,13 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
 
-static void
-ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
-			    struct mlx5_wqe_eth_seg *eseg)
-{
-	struct xfrm_offload *xo = xfrm_offload(skb);
-
-	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (xo->inner_ipproto) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
-	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
-		sq->stats->csum_partial_inner++;
-	}
-}
-
 static inline void
 mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5e_accel_tx_state *accel,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
-	if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+	if (unlikely(mlx5e_ipsec_txwqe_build_eseg_csum(sq, skb, eseg)))
 		return;
-	}
 
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-- 
2.34.1



