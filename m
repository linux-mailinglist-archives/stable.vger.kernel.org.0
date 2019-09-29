Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC25C14D8
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfI2N6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729503AbfI2N6a (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C18B21835;
        Sun, 29 Sep 2019 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765509;
        bh=KcT1AO6aASVQMvdJ3FAS42K0zGTJvtZ+7xmRiqmMuJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiHYQXJ/hCoN1hXbU5qYhtXuQ6bk7z8DeEP/TB5iLy6dZKhbPZteijZuZzecSoheF
         PKCARy7KhNy2cAslwrcTViSInCHKHGsXxzz9eaVywR/tCQSZHFE9SOOcHD7ebS1lMH
         FmcWN/vq1h/p8NxyGLVf28JSJCKntkQQpU4JjvA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Natali Shechtman <natali@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 15/63] net/mlx5e: Set ECN for received packets using CQE indication
Date:   Sun, 29 Sep 2019 15:53:48 +0200
Message-Id: <20190929135034.757504729@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Natali Shechtman <natali@mellanox.com>

[ Upstream commit f007c13d4ad62f494c83897eda96437005df4a91 ]

In multi-host (MH) NIC scheme, a single HW port serves multiple hosts
or sockets on the same host.
The HW uses a mechanism in the PCIe buffer which monitors
the amount of consumed PCIe buffers per host.
On a certain configuration, under congestion,
the HW emulates a switch doing ECN marking on packets using ECN
indication on the completion descriptor (CQE).

The driver needs to set the ECN bits on the packet SKB,
such that the network stack can react on that, this commit does that.

Needed by downstream patch which fixes a mlx5 checksum issue.

Fixes: bbceefce9adf ("net/mlx5e: Support RX CHECKSUM_COMPLETE")
Signed-off-by: Natali Shechtman <natali@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   35 ++++++++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    2 +
 3 files changed, 35 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -37,6 +37,7 @@
 #include <net/busy_poll.h>
 #include <net/ip6_checksum.h>
 #include <net/page_pool.h>
+#include <net/inet_ecn.h>
 #include "en.h"
 #include "en_tc.h"
 #include "eswitch.h"
@@ -688,12 +689,29 @@ static inline void mlx5e_skb_set_hash(st
 	skb_set_hash(skb, be32_to_cpu(cqe->rss_hash_result), ht);
 }
 
-static inline bool is_last_ethertype_ip(struct sk_buff *skb, int *network_depth)
+static inline bool is_last_ethertype_ip(struct sk_buff *skb, int *network_depth,
+					__be16 *proto)
 {
-	__be16 ethertype = ((struct ethhdr *)skb->data)->h_proto;
+	*proto = ((struct ethhdr *)skb->data)->h_proto;
+	*proto = __vlan_get_protocol(skb, *proto, network_depth);
+	return (*proto == htons(ETH_P_IP) || *proto == htons(ETH_P_IPV6));
+}
+
+static inline void mlx5e_enable_ecn(struct mlx5e_rq *rq, struct sk_buff *skb)
+{
+	int network_depth = 0;
+	__be16 proto;
+	void *ip;
+	int rc;
 
-	ethertype = __vlan_get_protocol(skb, ethertype, network_depth);
-	return (ethertype == htons(ETH_P_IP) || ethertype == htons(ETH_P_IPV6));
+	if (unlikely(!is_last_ethertype_ip(skb, &network_depth, &proto)))
+		return;
+
+	ip = skb->data + network_depth;
+	rc = ((proto == htons(ETH_P_IP)) ? IP_ECN_set_ce((struct iphdr *)ip) :
+					 IP6_ECN_set_ce(skb, (struct ipv6hdr *)ip));
+
+	rq->stats->ecn_mark += !!rc;
 }
 
 static u32 mlx5e_get_fcs(const struct sk_buff *skb)
@@ -717,6 +735,7 @@ static inline void mlx5e_handle_csum(str
 {
 	struct mlx5e_rq_stats *stats = rq->stats;
 	int network_depth = 0;
+	__be16 proto;
 
 	if (unlikely(!(netdev->features & NETIF_F_RXCSUM)))
 		goto csum_none;
@@ -738,7 +757,7 @@ static inline void mlx5e_handle_csum(str
 	if (short_frame(skb->len))
 		goto csum_unnecessary;
 
-	if (likely(is_last_ethertype_ip(skb, &network_depth))) {
+	if (likely(is_last_ethertype_ip(skb, &network_depth, &proto))) {
 		skb->ip_summed = CHECKSUM_COMPLETE;
 		skb->csum = csum_unfold((__force __sum16)cqe->check_sum);
 		if (network_depth > ETH_HLEN)
@@ -775,6 +794,8 @@ csum_none:
 	stats->csum_none++;
 }
 
+#define MLX5E_CE_BIT_MASK 0x80
+
 static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 				      u32 cqe_bcnt,
 				      struct mlx5e_rq *rq,
@@ -819,6 +840,10 @@ static inline void mlx5e_build_rx_skb(st
 	skb->mark = be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK;
 
 	mlx5e_handle_csum(netdev, cqe, rq, skb, !!lro_num_seg);
+	/* checking CE bit in cqe - MSB in ml_path field */
+	if (unlikely(cqe->ml_path & MLX5E_CE_BIT_MASK))
+		mlx5e_enable_ecn(rq, skb);
+
 	skb->protocol = eth_type_trans(skb, netdev);
 }
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -53,6 +53,7 @@ static const struct counter_desc sw_stat
 
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_ecn_mark) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_removed_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_none) },
@@ -144,6 +145,7 @@ void mlx5e_grp_sw_update_stats(struct ml
 		s->rx_bytes	+= rq_stats->bytes;
 		s->rx_lro_packets += rq_stats->lro_packets;
 		s->rx_lro_bytes	+= rq_stats->lro_bytes;
+		s->rx_ecn_mark	+= rq_stats->ecn_mark;
 		s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
 		s->rx_csum_none	+= rq_stats->csum_none;
 		s->rx_csum_complete += rq_stats->csum_complete;
@@ -1144,6 +1146,7 @@ static const struct counter_desc rq_stat
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, ecn_mark) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, wqe_err) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, mpwqe_filler_cqes) },
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -66,6 +66,7 @@ struct mlx5e_sw_stats {
 	u64 tx_nop;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
+	u64 rx_ecn_mark;
 	u64 rx_removed_vlan_packets;
 	u64 rx_csum_unnecessary;
 	u64 rx_csum_none;
@@ -184,6 +185,7 @@ struct mlx5e_rq_stats {
 	u64 csum_none;
 	u64 lro_packets;
 	u64 lro_bytes;
+	u64 ecn_mark;
 	u64 removed_vlan_packets;
 	u64 xdp_drop;
 	u64 xdp_redirect;


