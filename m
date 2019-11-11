Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 858E7F7DE3
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbfKKTAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 14:00:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbfKKSyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0525321783;
        Mon, 11 Nov 2019 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498474;
        bh=XN8XpFTH7MqUoifrn6MJFPwO8c9PSLWI4Rcpkj2i8O8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEXR96IECiaXC7RYxql1UvV8uq3GulFDV5xkG7GvzeshHziKBWmL1xq/P3M+EiSOt
         FBaQMurya9BboTUBU5YzrovML/fpKab76ffDV74EUezbJBZFJSeRzUhLJBUcZWWxyJ
         FYrj5EdYopo3rJrponRzF0oMazndaFq1nZEkIP3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 130/193] netfilter: nft_payload: fix missing check for matching length in offloads
Date:   Mon, 11 Nov 2019 19:28:32 +0100
Message-Id: <20191111181510.765400368@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit a69a85da458f79088c38a38db034a4d64d9c32c3 ]

Payload offload rule should also check the length of the match.
Moreover, check for unsupported link-layer fields:

 nft --debug=netlink add rule firewall zones vlan id 100
 ...
 [ payload load 2b @ link header + 0 => reg 1 ]

this loads 2byte base on ll header and offset 0.

This also fixes unsupported raw payload match.

Fixes: 92ad6325cb89 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb60222e..5cb2d8908d2a5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -161,13 +161,21 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ethhdr, h_source):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  src, ETH_ALEN, reg);
 		break;
 	case offsetof(struct ethhdr, h_dest):
+		if (priv->len != ETH_ALEN)
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_ETH_ADDRS, eth_addrs,
 				  dst, ETH_ALEN, reg);
 		break;
+	default:
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -181,14 +189,23 @@ static int nft_payload_offload_ip(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct iphdr, saddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, src,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, daddr):
+		if (priv->len != sizeof(struct in_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4, dst,
 				  sizeof(struct in_addr), reg);
 		break;
 	case offsetof(struct iphdr, protocol):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -208,14 +225,23 @@ static int nft_payload_offload_ip6(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct ipv6hdr, saddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, src,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, daddr):
+		if (priv->len != sizeof(struct in6_addr))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6, dst,
 				  sizeof(struct in6_addr), reg);
 		break;
 	case offsetof(struct ipv6hdr, nexthdr):
+		if (priv->len != sizeof(__u8))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic, ip_proto,
 				  sizeof(__u8), reg);
 		nft_offload_set_dependency(ctx, NFT_OFFLOAD_DEP_TRANSPORT);
@@ -255,10 +281,16 @@ static int nft_payload_offload_tcp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct tcphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct tcphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
@@ -277,10 +309,16 @@ static int nft_payload_offload_udp(struct nft_offload_ctx *ctx,
 
 	switch (priv->offset) {
 	case offsetof(struct udphdr, source):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, src,
 				  sizeof(__be16), reg);
 		break;
 	case offsetof(struct udphdr, dest):
+		if (priv->len != sizeof(__be16))
+			return -EOPNOTSUPP;
+
 		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_PORTS, tp, dst,
 				  sizeof(__be16), reg);
 		break;
-- 
2.20.1



