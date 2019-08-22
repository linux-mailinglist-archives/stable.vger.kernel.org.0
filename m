Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E45799A07
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388979AbfHVRJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:59670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390767AbfHVRJZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:25 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C81FB2341E;
        Thu, 22 Aug 2019 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493765;
        bh=cOf2rfe+VaUpMf0L+tSUMtZaVfkMnbr8iBkimBfYzD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1P8Hu9rYQ9BrOMuu6n5k1NJnNNdiVCNkNMI7KRHkK3FhUNcfT9TqDslHWnpaiu33n
         Di3DRnDRvm1AMDVMrNYxY5N+yhS8sH+Ig0j0pGklMtOT5ISG9PD9KHLZwHtodAvlKf
         JXE6NHsaKQqqMzMWztJs8ydPOb0uLGgvFr0tfAXM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 131/135] net/mlx5e: Use flow keys dissector to parse packets for ARFS
Date:   Thu, 22 Aug 2019 13:08:07 -0400
Message-Id: <20190822170811.13303-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 405b93eb764367a670e729da18e54dc42db32620 ]

The current ARFS code relies on certain fields to be set in the SKB
(e.g. transport_header) and extracts IP addresses and ports by custom
code that parses the packet. The necessary SKB fields, however, are not
always set at that point, which leads to an out-of-bounds access. Use
skb_flow_dissect_flow_keys() to get the necessary information reliably,
fix the out-of-bounds access and reuse the code.

Fixes: 18c908e477dc ("net/mlx5e: Add accelerated RFS support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_arfs.c | 97 +++++++------------
 1 file changed, 34 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
index 8657e0f26995b..2c75b2752f58d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c
@@ -437,12 +437,6 @@ arfs_hash_bucket(struct arfs_table *arfs_t, __be16 src_port,
 	return &arfs_t->rules_hash[bucket_idx];
 }
 
-static u8 arfs_get_ip_proto(const struct sk_buff *skb)
-{
-	return (skb->protocol == htons(ETH_P_IP)) ?
-		ip_hdr(skb)->protocol : ipv6_hdr(skb)->nexthdr;
-}
-
 static struct arfs_table *arfs_get_table(struct mlx5e_arfs_tables *arfs,
 					 u8 ip_proto, __be16 etype)
 {
@@ -602,31 +596,9 @@ static void arfs_handle_work(struct work_struct *work)
 	arfs_may_expire_flow(priv);
 }
 
-/* return L4 destination port from ip4/6 packets */
-static __be16 arfs_get_dst_port(const struct sk_buff *skb)
-{
-	char *transport_header;
-
-	transport_header = skb_transport_header(skb);
-	if (arfs_get_ip_proto(skb) == IPPROTO_TCP)
-		return ((struct tcphdr *)transport_header)->dest;
-	return ((struct udphdr *)transport_header)->dest;
-}
-
-/* return L4 source port from ip4/6 packets */
-static __be16 arfs_get_src_port(const struct sk_buff *skb)
-{
-	char *transport_header;
-
-	transport_header = skb_transport_header(skb);
-	if (arfs_get_ip_proto(skb) == IPPROTO_TCP)
-		return ((struct tcphdr *)transport_header)->source;
-	return ((struct udphdr *)transport_header)->source;
-}
-
 static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 					 struct arfs_table *arfs_t,
-					 const struct sk_buff *skb,
+					 const struct flow_keys *fk,
 					 u16 rxq, u32 flow_id)
 {
 	struct arfs_rule *rule;
@@ -641,19 +613,19 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 	INIT_WORK(&rule->arfs_work, arfs_handle_work);
 
 	tuple = &rule->tuple;
-	tuple->etype = skb->protocol;
+	tuple->etype = fk->basic.n_proto;
+	tuple->ip_proto = fk->basic.ip_proto;
 	if (tuple->etype == htons(ETH_P_IP)) {
-		tuple->src_ipv4 = ip_hdr(skb)->saddr;
-		tuple->dst_ipv4 = ip_hdr(skb)->daddr;
+		tuple->src_ipv4 = fk->addrs.v4addrs.src;
+		tuple->dst_ipv4 = fk->addrs.v4addrs.dst;
 	} else {
-		memcpy(&tuple->src_ipv6, &ipv6_hdr(skb)->saddr,
+		memcpy(&tuple->src_ipv6, &fk->addrs.v6addrs.src,
 		       sizeof(struct in6_addr));
-		memcpy(&tuple->dst_ipv6, &ipv6_hdr(skb)->daddr,
+		memcpy(&tuple->dst_ipv6, &fk->addrs.v6addrs.dst,
 		       sizeof(struct in6_addr));
 	}
-	tuple->ip_proto = arfs_get_ip_proto(skb);
-	tuple->src_port = arfs_get_src_port(skb);
-	tuple->dst_port = arfs_get_dst_port(skb);
+	tuple->src_port = fk->ports.src;
+	tuple->dst_port = fk->ports.dst;
 
 	rule->flow_id = flow_id;
 	rule->filter_id = priv->fs.arfs.last_filter_id++ % RPS_NO_FILTER;
@@ -664,37 +636,33 @@ static struct arfs_rule *arfs_alloc_rule(struct mlx5e_priv *priv,
 	return rule;
 }
 
-static bool arfs_cmp_ips(struct arfs_tuple *tuple,
-			 const struct sk_buff *skb)
+static bool arfs_cmp(const struct arfs_tuple *tuple, const struct flow_keys *fk)
 {
-	if (tuple->etype == htons(ETH_P_IP) &&
-	    tuple->src_ipv4 == ip_hdr(skb)->saddr &&
-	    tuple->dst_ipv4 == ip_hdr(skb)->daddr)
-		return true;
-	if (tuple->etype == htons(ETH_P_IPV6) &&
-	    (!memcmp(&tuple->src_ipv6, &ipv6_hdr(skb)->saddr,
-		     sizeof(struct in6_addr))) &&
-	    (!memcmp(&tuple->dst_ipv6, &ipv6_hdr(skb)->daddr,
-		     sizeof(struct in6_addr))))
-		return true;
+	if (tuple->src_port != fk->ports.src || tuple->dst_port != fk->ports.dst)
+		return false;
+	if (tuple->etype != fk->basic.n_proto)
+		return false;
+	if (tuple->etype == htons(ETH_P_IP))
+		return tuple->src_ipv4 == fk->addrs.v4addrs.src &&
+		       tuple->dst_ipv4 == fk->addrs.v4addrs.dst;
+	if (tuple->etype == htons(ETH_P_IPV6))
+		return !memcmp(&tuple->src_ipv6, &fk->addrs.v6addrs.src,
+			       sizeof(struct in6_addr)) &&
+		       !memcmp(&tuple->dst_ipv6, &fk->addrs.v6addrs.dst,
+			       sizeof(struct in6_addr));
 	return false;
 }
 
 static struct arfs_rule *arfs_find_rule(struct arfs_table *arfs_t,
-					const struct sk_buff *skb)
+					const struct flow_keys *fk)
 {
 	struct arfs_rule *arfs_rule;
 	struct hlist_head *head;
-	__be16 src_port = arfs_get_src_port(skb);
-	__be16 dst_port = arfs_get_dst_port(skb);
 
-	head = arfs_hash_bucket(arfs_t, src_port, dst_port);
+	head = arfs_hash_bucket(arfs_t, fk->ports.src, fk->ports.dst);
 	hlist_for_each_entry(arfs_rule, head, hlist) {
-		if (arfs_rule->tuple.src_port == src_port &&
-		    arfs_rule->tuple.dst_port == dst_port &&
-		    arfs_cmp_ips(&arfs_rule->tuple, skb)) {
+		if (arfs_cmp(&arfs_rule->tuple, fk))
 			return arfs_rule;
-		}
 	}
 
 	return NULL;
@@ -707,20 +675,24 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 	struct mlx5e_arfs_tables *arfs = &priv->fs.arfs;
 	struct arfs_table *arfs_t;
 	struct arfs_rule *arfs_rule;
+	struct flow_keys fk;
+
+	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
+		return -EPROTONOSUPPORT;
 
-	if (skb->protocol != htons(ETH_P_IP) &&
-	    skb->protocol != htons(ETH_P_IPV6))
+	if (fk.basic.n_proto != htons(ETH_P_IP) &&
+	    fk.basic.n_proto != htons(ETH_P_IPV6))
 		return -EPROTONOSUPPORT;
 
 	if (skb->encapsulation)
 		return -EPROTONOSUPPORT;
 
-	arfs_t = arfs_get_table(arfs, arfs_get_ip_proto(skb), skb->protocol);
+	arfs_t = arfs_get_table(arfs, fk.basic.ip_proto, fk.basic.n_proto);
 	if (!arfs_t)
 		return -EPROTONOSUPPORT;
 
 	spin_lock_bh(&arfs->arfs_lock);
-	arfs_rule = arfs_find_rule(arfs_t, skb);
+	arfs_rule = arfs_find_rule(arfs_t, &fk);
 	if (arfs_rule) {
 		if (arfs_rule->rxq == rxq_index) {
 			spin_unlock_bh(&arfs->arfs_lock);
@@ -728,8 +700,7 @@ int mlx5e_rx_flow_steer(struct net_device *dev, const struct sk_buff *skb,
 		}
 		arfs_rule->rxq = rxq_index;
 	} else {
-		arfs_rule = arfs_alloc_rule(priv, arfs_t, skb,
-					    rxq_index, flow_id);
+		arfs_rule = arfs_alloc_rule(priv, arfs_t, &fk, rxq_index, flow_id);
 		if (!arfs_rule) {
 			spin_unlock_bh(&arfs->arfs_lock);
 			return -ENOMEM;
-- 
2.20.1

