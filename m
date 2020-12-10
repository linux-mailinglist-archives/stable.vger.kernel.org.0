Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A53F2D602E
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391266AbgLJOkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391261AbgLJOj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:39:56 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.9 73/75] netfilter: nftables_offload: set address type in control dissector
Date:   Thu, 10 Dec 2020 15:27:38 +0100
Message-Id: <20201210142609.617882825@linuxfoundation.org>
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

commit 3c78e9e0d33a27ab8050e4492c03c6a1f8d0ed6b upstream.

This patch adds nft_flow_rule_set_addr_type() to set the address type
from the nft_payload expression accordingly.

If the address type is not set in the control dissector then a rule that
matches either on source or destination IP address does not work.

After this patch, nft hardware offload generates the flow dissector
configuration as tc-flower does to match on an IP address.

This patch has been also tested functionally to make sure packets are
filtered out by the NIC.

This is also getting the code aligned with the existing netfilter flow
offload infrastructure which is also setting the control dissector.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables_offload.h |    4 ++++
 net/netfilter/nf_tables_offload.c         |   17 +++++++++++++++++
 net/netfilter/nft_payload.c               |    4 ++++
 3 files changed, 25 insertions(+)

--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -37,6 +37,7 @@ void nft_offload_update_dependency(struc
 
 struct nft_flow_key {
 	struct flow_dissector_key_basic			basic;
+	struct flow_dissector_key_control		control;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
 		struct flow_dissector_key_ipv6_addrs	ipv6;
@@ -62,6 +63,9 @@ struct nft_flow_rule {
 
 #define NFT_OFFLOAD_F_ACTION	(1 << 0)
 
+void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
+				 enum flow_dissector_key_id addr_type);
+
 struct nft_rule;
 struct nft_flow_rule *nft_flow_rule_create(struct net *net, const struct nft_rule *rule);
 void nft_flow_rule_destroy(struct nft_flow_rule *flow);
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -28,6 +28,23 @@ static struct nft_flow_rule *nft_flow_ru
 	return flow;
 }
 
+void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
+				 enum flow_dissector_key_id addr_type)
+{
+	struct nft_flow_match *match = &flow->match;
+	struct nft_flow_key *mask = &match->mask;
+	struct nft_flow_key *key = &match->key;
+
+	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL))
+		return;
+
+	key->control.addr_type = addr_type;
+	mask->control.addr_type = 0xffff;
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL);
+	match->dissector.offset[FLOW_DISSECTOR_KEY_CONTROL] =
+		offsetof(struct nft_flow_key, control);
+}
+
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 					   const struct nft_rule *rule)
 {
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -243,6 +243,7 @@ static int nft_payload_offload_ip(struct
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
 				  sizeof(struct in_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, daddr):
 		if (priv->len != sizeof(struct in_addr))
@@ -250,6 +251,7 @@ static int nft_payload_offload_ip(struct
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
 				  sizeof(struct in_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV4_ADDRS);
 		break;
 	case offsetof(struct iphdr, protocol):
 		if (priv->len != sizeof(__u8))
@@ -279,6 +281,7 @@ static int nft_payload_offload_ip6(struc
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
 				  sizeof(struct in6_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
 		if (priv->len != sizeof(struct in6_addr))
@@ -286,6 +289,7 @@ static int nft_payload_offload_ip6(struc
 
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
 				  sizeof(struct in6_addr), reg);
+		nft_flow_rule_set_addr_type(flow, FLOW_DISSECTOR_KEY_IPV6_ADDRS);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
 		if (priv->len != sizeof(__u8))


