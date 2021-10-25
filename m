Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDEFF43A246
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbhJYTrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236612AbhJYTo5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:44:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69F4360187;
        Mon, 25 Oct 2021 19:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190723;
        bh=Kw2pnTLaMolyqnbKdYQUDurXX5IzbfZt67LnOkHyEz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RsuSxG/xf8wk3eKsgwwo+3c2h6Brc4ivL+zYeBBORy9K2RifmKBifSb+bMwMvPGOp
         F+o/8ooG/z9LPDyusSMtQIOgP7ktL95x/GzJSZ9YfLd5sl/Z3v+lAaOXZY+p4YOaa7
         mIuNJBK+KL2HT0wg0492/dumBxhxb1S7e7oXBS7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emeel Hakim <ehakim@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 055/169] net/mlx5e: IPsec: Fix a misuse of the software parsers fields
Date:   Mon, 25 Oct 2021 21:13:56 +0200
Message-Id: <20211025191024.592815653@linuxfoundation.org>
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

[ Upstream commit d10457f85d4ae4d32c0df0cd65358a78c577fbe6 ]

IPsec crypto offload current Software Parser (SWP) fields settings in
the ethernet segment (eseg) are not aligned with PRM/HW expectations.
Among others in case of IP|ESP|TCP packet, current driver sets the
offsets for inner_l3 and inner_l4 although there is no inner l3/l4
headers relative to ESP header in such packets.

SWP provides the offsets for HW ,so it can be used to find csum fields
to offload the checksum, however these are not necessarily used by HW
and are used as fallback in case HW fails to parse the packet, e.g
when performing IPSec Transport Aware (IP | ESP | TCP) there is no
need to add SW parse on inner packet. So in some cases packets csum
was calculated correctly , whereas in other cases it failed. The later
faced csum errors (caused by wrong packet length calculations) which
led to lots of packet drops hence the low throughput.

Fix by setting the SWP fields as expected in a IP|ESP|TCP packet.

the following describe the expected SWP offsets:
* Tunnel Mode:
* SWP:      OutL3       InL3  InL4
* Pkt: MAC  IP     ESP  IP    L4
*
* Transport Mode:
* SWP:      OutL3       OutL4
* Pkt: MAC  IP     ESP  L4
*
* Tunnel(VXLAN TCP/UDP) over Transport Mode
* SWP:      OutL3                   InL3  InL4
* Pkt: MAC  IP     ESP  UDP  VXLAN  IP    L4

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 51 ++++++++++---------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 33de8f0092a6..fb5397324aa4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -141,8 +141,7 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 	 * Pkt: MAC  IP     ESP  IP    L4
 	 *
 	 * Transport Mode:
-	 * SWP:      OutL3       InL4
-	 *           InL3
+	 * SWP:      OutL3       OutL4
 	 * Pkt: MAC  IP     ESP  L4
 	 *
 	 * Tunnel(VXLAN TCP/UDP) over Transport Mode
@@ -171,31 +170,35 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 		return;
 
 	if (!xo->inner_ipproto) {
-		eseg->swp_inner_l3_offset = skb_network_offset(skb) / 2;
-		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
-		if (skb->protocol == htons(ETH_P_IPV6))
-			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-		if (xo->proto == IPPROTO_UDP)
+		switch (xo->proto) {
+		case IPPROTO_UDP:
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_OUTER_L4_UDP;
+			fallthrough;
+		case IPPROTO_TCP:
+			/* IP | ESP | TCP */
+			eseg->swp_outer_l4_offset = skb_inner_transport_offset(skb) / 2;
+			break;
+		default:
+			break;
+		}
+	} else {
+		/* Tunnel(VXLAN TCP/UDP) over Transport Mode */
+		switch (xo->inner_ipproto) {
+		case IPPROTO_UDP:
 			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		return;
-	}
-
-	/* Tunnel(VXLAN TCP/UDP) over Transport Mode */
-	switch (xo->inner_ipproto) {
-	case IPPROTO_UDP:
-		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
-		fallthrough;
-	case IPPROTO_TCP:
-		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
-		eseg->swp_inner_l4_offset = (skb->csum_start + skb->head - skb->data) / 2;
-		if (skb->protocol == htons(ETH_P_IPV6))
-			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
-		break;
-	default:
-		break;
+			fallthrough;
+		case IPPROTO_TCP:
+			eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
+			eseg->swp_inner_l4_offset =
+				(skb->csum_start + skb->head - skb->data) / 2;
+			if (skb->protocol == htons(ETH_P_IPV6))
+				eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+			break;
+		default:
+			break;
+		}
 	}
 
-	return;
 }
 
 void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
-- 
2.33.0



