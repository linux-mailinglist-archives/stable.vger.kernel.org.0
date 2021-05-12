Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4733137CA5B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbhELQ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:29:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231764AbhELQVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9033261285;
        Wed, 12 May 2021 15:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834403;
        bh=ysjtPelP3VLrbcSf0jawYViv8f4OKICeVu5TAjMk2HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wO0abDpM3XBJ5O3luI7z2iSbWHH4IjKcBw1ZRNqJF74RpjWSwUQ+d2gib7CtkLugY
         pH+Njr22MZCr/kWebLp5ZvbPLyq6c8OsXjKGcK4IhF5FlrQm67DMsHmCqNx2L+6LHP
         4HKBeQGjXSZfZ5Qh0O911zPjelNH4eq5+xR8gj3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 530/601] netfilter: nftables_offload: special ethertype handling for VLAN
Date:   Wed, 12 May 2021 16:50:07 +0200
Message-Id: <20210512144845.311732119@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 783003f3bb8a565326e89d18bbd948ad8ffc816a ]

The nftables offload parser sets FLOW_DISSECTOR_KEY_BASIC .n_proto to the
ethertype field in the ethertype frame. However:

- FLOW_DISSECTOR_KEY_BASIC .n_proto field always stores either IPv4 or IPv6
  ethertypes.
- FLOW_DISSECTOR_KEY_VLAN .vlan_tpid stores either the 802.1q and 802.1ad
  ethertypes. Same as for FLOW_DISSECTOR_KEY_CVLAN.

This function adjusts the flow dissector to handle two scenarios:

1) FLOW_DISSECTOR_KEY_VLAN .vlan_tpid is set to 802.1q or 802.1ad.
   Then, transfer:
   - the .n_proto field to FLOW_DISSECTOR_KEY_VLAN .tpid.
   - the original FLOW_DISSECTOR_KEY_VLAN .tpid to the
     FLOW_DISSECTOR_KEY_CVLAN .tpid
   - the original FLOW_DISSECTOR_KEY_CVLAN .tpid to the .n_proto field.

2) .n_proto is set to 802.1q or 802.1ad. Then, transfer:
   - the .n_proto field to FLOW_DISSECTOR_KEY_VLAN .tpid.
   - the original FLOW_DISSECTOR_KEY_VLAN .tpid to the .n_proto field.

Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 9ae14270c543..2b00f7f47693 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -45,6 +45,48 @@ void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 		offsetof(struct nft_flow_key, control);
 }
 
+struct nft_offload_ethertype {
+	__be16 value;
+	__be16 mask;
+};
+
+static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
+					struct nft_flow_rule *flow)
+{
+	struct nft_flow_match *match = &flow->match;
+	struct nft_offload_ethertype ethertype;
+
+	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL) &&
+	    match->key.basic.n_proto != htons(ETH_P_8021Q) &&
+	    match->key.basic.n_proto != htons(ETH_P_8021AD))
+		return;
+
+	ethertype.value = match->key.basic.n_proto;
+	ethertype.mask = match->mask.basic.n_proto;
+
+	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_VLAN) &&
+	    (match->key.vlan.vlan_tpid == htons(ETH_P_8021Q) ||
+	     match->key.vlan.vlan_tpid == htons(ETH_P_8021AD))) {
+		match->key.basic.n_proto = match->key.cvlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.cvlan.vlan_tpid;
+		match->key.cvlan.vlan_tpid = match->key.vlan.vlan_tpid;
+		match->mask.cvlan.vlan_tpid = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+		match->dissector.offset[FLOW_DISSECTOR_KEY_CVLAN] =
+			offsetof(struct nft_flow_key, cvlan);
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
+	} else {
+		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
+		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
+		match->key.vlan.vlan_tpid = ethertype.value;
+		match->mask.vlan.vlan_tpid = ethertype.mask;
+		match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
+			offsetof(struct nft_flow_key, vlan);
+		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
+	}
+}
+
 struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 					   const struct nft_rule *rule)
 {
@@ -89,6 +131,8 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 
 		expr = nft_expr_next(expr);
 	}
+	nft_flow_rule_transfer_vlan(ctx, flow);
+
 	flow->proto = ctx->dep.l3num;
 	kfree(ctx);
 
-- 
2.30.2



