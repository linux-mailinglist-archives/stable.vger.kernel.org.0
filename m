Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5E2D6019
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391309AbgLJOk2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgLJOkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:40:25 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.9 74/75] netfilter: nftables_offload: build mask based from the matching bytes
Date:   Thu, 10 Dec 2020 15:27:39 +0100
Message-Id: <20201210142609.666076520@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit a5d45bc0dc50f9dd83703510e9804d813a9cac32 upstream.

Userspace might match on prefix bytes of header fields if they are on
the byte boundary, this requires that the mask is adjusted accordingly.
Use NFT_OFFLOAD_MATCH_EXACT() for meta since prefix byte matching is not
allowed for this type of selector.

The bitwise expression might be optimized out by userspace, hence the
kernel needs to infer the prefix from the number of payload bytes to
match on. This patch adds nft_payload_offload_mask() to calculate the
bitmask to match on the prefix.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables_offload.h |    3 +
 net/netfilter/nft_cmp.c                   |    8 +--
 net/netfilter/nft_meta.c                  |   16 +++----
 net/netfilter/nft_payload.c               |   66 ++++++++++++++++++++++--------
 4 files changed, 64 insertions(+), 29 deletions(-)

--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -78,6 +78,9 @@ int nft_flow_rule_offload_commit(struct
 		offsetof(struct nft_flow_key, __base.__field);		\
 	(__reg)->len		= __len;				\
 	(__reg)->key		= __key;				\
+
+#define NFT_OFFLOAD_MATCH_EXACT(__key, __base, __field, __len, __reg)	\
+	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -123,11 +123,11 @@ static int __nft_cmp_offload(struct nft_
 	u8 *mask = (u8 *)&flow->match.mask;
 	u8 *key = (u8 *)&flow->match.key;
 
-	if (priv->op != NFT_CMP_EQ || reg->len != priv->len)
+	if (priv->op != NFT_CMP_EQ || priv->len > reg->len)
 		return -EOPNOTSUPP;
 
-	memcpy(key + reg->offset, &priv->data, priv->len);
-	memcpy(mask + reg->offset, &reg->mask, priv->len);
+	memcpy(key + reg->offset, &priv->data, reg->len);
+	memcpy(mask + reg->offset, &reg->mask, reg->len);
 
 	flow->match.dissector.used_keys |= BIT(reg->key);
 	flow->match.dissector.offset[reg->key] = reg->base_offset;
@@ -137,7 +137,7 @@ static int __nft_cmp_offload(struct nft_
 	    nft_reg_load16(priv->data.data) != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
-	nft_offload_update_dependency(ctx, &priv->data, priv->len);
+	nft_offload_update_dependency(ctx, &priv->data, reg->len);
 
 	return 0;
 }
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -724,22 +724,22 @@ static int nft_meta_get_offload(struct n
 
 	switch (priv->key) {
 	case NFT_META_PROTOCOL:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
-				  sizeof(__u16), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_BASIC, basic, n_proto,
+					sizeof(__u16), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case NFT_META_L4PROTO:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
-				  sizeof(__u8), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
+					sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
 		break;
 	case NFT_META_IIF:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
-				  ingress_ifindex, sizeof(__u32), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_META, meta,
+					ingress_ifindex, sizeof(__u32), reg);
 		break;
 	case NFT_META_IIFTYPE:
-		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_META, meta,
-				  ingress_iftype, sizeof(__u16), reg);
+		NFT_OFFLOAD_MATCH_EXACT(FLOW_DISSECTOR_KEY_META, meta,
+					ingress_iftype, sizeof(__u16), reg);
 		break;
 	default:
 		return -EOPNOTSUPP;
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -164,6 +164,34 @@ nla_put_failure:
 	return -1;
 }
 
+static bool nft_payload_offload_mask(struct nft_offload_reg *reg,
+				     u32 priv_len, u32 field_len)
+{
+	unsigned int remainder, delta, k;
+	struct nft_data mask = {};
+	__be32 remainder_mask;
+
+	if (priv_len == field_len) {
+		memset(&reg->mask, 0xff, priv_len);
+		return true;
+	} else if (priv_len > field_len) {
+		return false;
+	}
+
+	memset(&mask, 0xff, field_len);
+	remainder = priv_len % sizeof(u32);
+	if (remainder) {
+		k = priv_len / sizeof(u32);
+		delta = field_len - priv_len;
+		remainder_mask = htonl(~((1 << (delta * BITS_PER_BYTE)) - 1));
+		mask.data[k] = (__force u32)remainder_mask;
+	}
+
+	memcpy(&reg->mask, &mask, field_len);
+
+	return true;
+}
+
 static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 				  struct nft_flow_rule *flow,
 				  const struct nft_payload *priv)
@@ -172,21 +200,21 @@ static int nft_payload_offload_ll(struct
 
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
-		if (priv->len != ETH_ALEN)
+		if (!nft_payload_offload_mask(reg, priv->len, ETH_ALEN))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  src, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_dest):
-		if (priv->len != ETH_ALEN)
+		if (!nft_payload_offload_mask(reg, priv->len, ETH_ALEN))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_proto):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
@@ -194,14 +222,14 @@ static int nft_payload_offload_ll(struct
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_TCI):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
 				  vlan_tci, sizeof(__be16), reg);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
@@ -209,7 +237,7 @@ static int nft_payload_offload_ll(struct
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_NETWORK);
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_TCI) + sizeof(struct vlan_hdr):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
@@ -217,7 +245,7 @@ static int nft_payload_offload_ll(struct
 		break;
 	case offsetof(struct vlan_ethhdr, h_vlan_encapsulated_proto) +
 							sizeof(struct vlan_hdr):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_CVLAN, vlan,
@@ -238,7 +266,8 @@ static int nft_payload_offload_ip(struct
 
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
-		if (priv->len != sizeof(struct in_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
@@ -246,7 +275,8 @@ static int nft_payload_offload_ip(struct
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, daddr):
-		if (priv->len != sizeof(struct in_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
@@ -254,7 +284,7 @@ static int nft_payload_offload_ip(struct
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, protocol):
-		if (priv->len != sizeof(__u8))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__u8)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
@@ -276,7 +306,8 @@ static int nft_payload_offload_ip6(struc
 
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
-		if (priv->len != sizeof(struct in6_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in6_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
@@ -284,7 +315,8 @@ static int nft_payload_offload_ip6(struc
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
-		if (priv->len != sizeof(struct in6_addr))
+		if (!nft_payload_offload_mask(reg, priv->len,
+					      sizeof(struct in6_addr)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
@@ -292,7 +324,7 @@ static int nft_payload_offload_ip6(struc
 		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
-		if (priv->len != sizeof(__u8))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__u8)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
@@ -334,14 +366,14 @@ static int nft_payload_offload_tcp(struc
 
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct tcphdr, dest):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
@@ -362,14 +394,14 @@ static int nft_payload_offload_udp(struc
 
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct udphdr, dest):
-		if (priv->len != sizeof(__be16))
+		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
 			return -EOPNOTSUPP;
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,


