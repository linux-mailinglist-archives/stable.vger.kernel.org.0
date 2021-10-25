Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB2F43A242
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbhJYTrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236106AbhJYTo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B87A060E97;
        Mon, 25 Oct 2021 19:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190727;
        bh=7tBYm1ODoqwlUagp5EX5UQQrBDcqT4sUxILv3p7tMP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urNd7K7up0xNNeB95D/AeMLrxxhAnMqvCEd62y36jEaMCcFERIYUPJo+m+3HEIOCn
         6yCCsoimM3nWsWqe2bPMQWeK+fJRYScpIG9z9ZD5e5jilLFAkiagMW3kdnP4lQBbBz
         iQvUGhQAQ0Z24+mdsVmkynCUeQFnwah+X5IV1aBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emeel Hakim <ehakim@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 056/169] net/mlx5e: IPsec: Fix work queue entry ethernet segment checksum flags
Date:   Mon, 25 Oct 2021 21:13:57 +0200
Message-Id: <20211025191024.700291644@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit 1d000323940137332d4d62c6332b6daf5f07aba7 ]

Current Work Queue Entry (WQE) checksum (csum) flags in the ethernet
segment (eseg) in case of IPsec crypto offload datapath are not aligned
with PRM/HW expectations.

Currently the driver always sets the l3_inner_csum flag in case of IPsec
because of the wrong usage of skb->encapsulation as indicator for inner
IPsec header since skb->encapsulation is always ON for IPsec packets
since IPsec itself is an encapsulation protocol. The above forced a
failing attempts of calculating csum of non-existing segments (like in
the IP|ESP|TCP packet case which does not have an l3_inner) which led
to lots of packet drops hence the low throughput.

Fix by using xo->inner_ipproto as indicator for inner IPsec header
instead of skb->encapsulation in addition to setting the csum flags
as following:
* Tunnel Mode:
* Pkt: MAC  IP     ESP  IP    L4
* CSUM: l3_cs | l3_inner_cs | l4_inner_cs
*
* Transport Mode:
* Pkt: MAC  IP     ESP  L4
* CSUM: l3_cs [ | l4_cs (checksum partial case)]
*
* Tunnel(VXLAN TCP/UDP) over Transport Mode
* Pkt: MAC  IP     ESP  UDP  VXLAN  IP    L4
* CSUM: l3_cs | l3_inner_cs | l4_inner_cs

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c63d78eda606..188994d091c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -213,19 +213,18 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
 
-/* If packet is not IP's CHECKSUM_PARTIAL (e.g. icmd packet),
- * need to set L3 checksum flag for IPsec
- */
 static void
 ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
+	struct xfrm_offload *xo = xfrm_offload(skb);
+
 	eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
-	if (skb->encapsulation) {
-		eseg->cs_flags |= MLX5_ETH_WQE_L3_INNER_CSUM;
+	if (xo->inner_ipproto) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_INNER_CSUM | MLX5_ETH_WQE_L3_INNER_CSUM;
+	} else if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
+		eseg->cs_flags |= MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial_inner++;
-	} else {
-		sq->stats->csum_partial++;
 	}
 }
 
@@ -234,6 +233,11 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			    struct mlx5e_accel_tx_state *accel,
 			    struct mlx5_wqe_eth_seg *eseg)
 {
+	if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
+		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+		return;
+	}
+
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM;
 		if (skb->encapsulation) {
@@ -249,8 +253,6 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial++;
 #endif
-	} else if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
-		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
 	} else
 		sq->stats->csum_none++;
 }
-- 
2.33.0



