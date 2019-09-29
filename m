Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82BDFC14CE
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbfI2N6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729294AbfI2N6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD172082F;
        Sun, 29 Sep 2019 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765492;
        bh=xSVCcNYPoiddy2ru/RSdMNMGPSvUvg4ndjubIp2ZvdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ex6C+k+qaRy+lS6wBXMfw2k2NNEiSSkSVdYXHqJa4IbmaSlpg/ARMCX++c+w3MgZF
         ae96NzSnvcBQR4BGPwLAoubx/cDjQHfxdvIXGYPZ9RQPbpwtywdXIYHc8WHc0PFuiA
         WKzzbkT3lD4WVERqZ0gnB8k+Hlaznf06gfnqTHno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 20/63] net/mlx5e: Rx, Fixup skb checksum for packets with tail padding
Date:   Sun, 29 Sep 2019 15:53:53 +0200
Message-Id: <20190929135035.936857742@linuxfoundation.org>
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

From: Saeed Mahameed <saeedm@mellanox.com>

[ Upstream commit 0aa1d18615c163f92935b806dcaff9157645233a ]

When an ethernet frame with ip payload is padded, the padding octets are
not covered by the hardware checksum.

Prior to the cited commit, skb checksum was forced to be CHECKSUM_NONE
when padding is detected. After it, the kernel will try to trim the
padding bytes and subtract their checksum from skb->csum.

In this patch we fixup skb->csum for any ip packet with tail padding of
any size, if any padding found.
FCS case is just one special case of this general purpose patch, hence,
it is removed.

Fixes: 88078d98d1bb ("net: pskb_trim_rcsum() and CHECKSUM_COMPLETE are friends"),
Cc: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   79 +++++++++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    4 +
 3 files changed, 74 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -714,17 +714,6 @@ static inline void mlx5e_enable_ecn(stru
 	rq->stats->ecn_mark += !!rc;
 }
 
-static u32 mlx5e_get_fcs(const struct sk_buff *skb)
-{
-	const void *fcs_bytes;
-	u32 _fcs_bytes;
-
-	fcs_bytes = skb_header_pointer(skb, skb->len - ETH_FCS_LEN,
-				       ETH_FCS_LEN, &_fcs_bytes);
-
-	return __get_unaligned_cpu32(fcs_bytes);
-}
-
 static u8 get_ip_proto(struct sk_buff *skb, int network_depth, __be16 proto)
 {
 	void *ip_p = skb->data + network_depth;
@@ -735,6 +724,68 @@ static u8 get_ip_proto(struct sk_buff *s
 
 #define short_frame(size) ((size) <= ETH_ZLEN + ETH_FCS_LEN)
 
+#define MAX_PADDING 8
+
+static void
+tail_padding_csum_slow(struct sk_buff *skb, int offset, int len,
+		       struct mlx5e_rq_stats *stats)
+{
+	stats->csum_complete_tail_slow++;
+	skb->csum = csum_block_add(skb->csum,
+				   skb_checksum(skb, offset, len, 0),
+				   offset);
+}
+
+static void
+tail_padding_csum(struct sk_buff *skb, int offset,
+		  struct mlx5e_rq_stats *stats)
+{
+	u8 tail_padding[MAX_PADDING];
+	int len = skb->len - offset;
+	void *tail;
+
+	if (unlikely(len > MAX_PADDING)) {
+		tail_padding_csum_slow(skb, offset, len, stats);
+		return;
+	}
+
+	tail = skb_header_pointer(skb, offset, len, tail_padding);
+	if (unlikely(!tail)) {
+		tail_padding_csum_slow(skb, offset, len, stats);
+		return;
+	}
+
+	stats->csum_complete_tail++;
+	skb->csum = csum_block_add(skb->csum, csum_partial(tail, len, 0), offset);
+}
+
+static void
+mlx5e_skb_padding_csum(struct sk_buff *skb, int network_depth, __be16 proto,
+		       struct mlx5e_rq_stats *stats)
+{
+	struct ipv6hdr *ip6;
+	struct iphdr   *ip4;
+	int pkt_len;
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		ip4 = (struct iphdr *)(skb->data + network_depth);
+		pkt_len = network_depth + ntohs(ip4->tot_len);
+		break;
+	case htons(ETH_P_IPV6):
+		ip6 = (struct ipv6hdr *)(skb->data + network_depth);
+		pkt_len = network_depth + sizeof(*ip6) + ntohs(ip6->payload_len);
+		break;
+	default:
+		return;
+	}
+
+	if (likely(pkt_len >= skb->len))
+		return;
+
+	tail_padding_csum(skb, pkt_len, stats);
+}
+
 static inline void mlx5e_handle_csum(struct net_device *netdev,
 				     struct mlx5_cqe64 *cqe,
 				     struct mlx5e_rq *rq,
@@ -783,10 +834,8 @@ static inline void mlx5e_handle_csum(str
 			skb->csum = csum_partial(skb->data + ETH_HLEN,
 						 network_depth - ETH_HLEN,
 						 skb->csum);
-		if (unlikely(netdev->features & NETIF_F_RXFCS))
-			skb->csum = csum_block_add(skb->csum,
-						   (__force __wsum)mlx5e_get_fcs(skb),
-						   skb->len - ETH_FCS_LEN);
+
+		mlx5e_skb_padding_csum(skb, network_depth, proto, stats);
 		stats->csum_complete++;
 		return;
 	}
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -58,6 +58,8 @@ static const struct counter_desc sw_stat
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_none) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_complete_tail_slow) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_drop) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_redirect) },
@@ -149,6 +151,8 @@ void mlx5e_grp_sw_update_stats(struct ml
 		s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
 		s->rx_csum_none	+= rq_stats->csum_none;
 		s->rx_csum_complete += rq_stats->csum_complete;
+		s->rx_csum_complete_tail += rq_stats->csum_complete_tail;
+		s->rx_csum_complete_tail_slow += rq_stats->csum_complete_tail_slow;
 		s->rx_csum_unnecessary += rq_stats->csum_unnecessary;
 		s->rx_csum_unnecessary_inner += rq_stats->csum_unnecessary_inner;
 		s->rx_xdp_drop     += rq_stats->xdp_drop;
@@ -1139,6 +1143,8 @@ static const struct counter_desc rq_stat
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, bytes) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete_tail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_complete_tail_slow) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_unnecessary_inner) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, csum_none) },
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -71,6 +71,8 @@ struct mlx5e_sw_stats {
 	u64 rx_csum_unnecessary;
 	u64 rx_csum_none;
 	u64 rx_csum_complete;
+	u64 rx_csum_complete_tail;
+	u64 rx_csum_complete_tail_slow;
 	u64 rx_csum_unnecessary_inner;
 	u64 rx_xdp_drop;
 	u64 rx_xdp_redirect;
@@ -180,6 +182,8 @@ struct mlx5e_rq_stats {
 	u64 packets;
 	u64 bytes;
 	u64 csum_complete;
+	u64 csum_complete_tail;
+	u64 csum_complete_tail_slow;
 	u64 csum_unnecessary;
 	u64 csum_unnecessary_inner;
 	u64 csum_none;


