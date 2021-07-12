Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48BA3C4EF5
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242638AbhGLHWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242039AbhGLHTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:19:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73F6E61574;
        Mon, 12 Jul 2021 07:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074179;
        bh=5RBP4naidKyQUpt3TyGxsn7mo6o5fz5Qv0pQJM67Sd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PirWSvgePRzOz07r+L6zcn9CnCOn5ZihSvPNAf045VhsBLCEJOrjQ/JNXLohtpWKD
         9ymXAx0PYadueZitONQ4UDAahmZlaPb+kgvpLmyupsN35ZXjrEOmW2KMf2Xfemq6SE
         p6XtYQOgD/Fe61lZpFMNg6W2xXinaU4G3AhAblLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 449/700] netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
Date:   Mon, 12 Jul 2021 08:08:52 +0200
Message-Id: <20210712061024.308249984@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ea45fdf82cc90430bb7c280e5e53821e833782c5 ]

The VLAN transfer logic should actually check for
FLOW_DISSECTOR_KEY_BASIC, not FLOW_DISSECTOR_KEY_CONTROL. Moreover, do
not fallback to case 2) .n_proto is set to 802.1q or 802.1ad, if
FLOW_DISSECTOR_KEY_BASIC is unset.

Fixes: 783003f3bb8a ("netfilter: nftables_offload: special ethertype handling for VLAN")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2b00f7f47693..9ce776175214 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -54,15 +54,10 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 					struct nft_flow_rule *flow)
 {
 	struct nft_flow_match *match = &flow->match;
-	struct nft_offload_ethertype ethertype;
-
-	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_CONTROL) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021Q) &&
-	    match->key.basic.n_proto != htons(ETH_P_8021AD))
-		return;
-
-	ethertype.value = match->key.basic.n_proto;
-	ethertype.mask = match->mask.basic.n_proto;
+	struct nft_offload_ethertype ethertype = {
+		.value	= match->key.basic.n_proto,
+		.mask	= match->mask.basic.n_proto,
+	};
 
 	if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_VLAN) &&
 	    (match->key.vlan.vlan_tpid == htons(ETH_P_8021Q) ||
@@ -76,7 +71,9 @@ static void nft_flow_rule_transfer_vlan(struct nft_offload_ctx *ctx,
 		match->dissector.offset[FLOW_DISSECTOR_KEY_CVLAN] =
 			offsetof(struct nft_flow_key, cvlan);
 		match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CVLAN);
-	} else {
+	} else if (match->dissector.used_keys & BIT(FLOW_DISSECTOR_KEY_BASIC) &&
+		   (match->key.basic.n_proto == htons(ETH_P_8021Q) ||
+		    match->key.basic.n_proto == htons(ETH_P_8021AD))) {
 		match->key.basic.n_proto = match->key.vlan.vlan_tpid;
 		match->mask.basic.n_proto = match->mask.vlan.vlan_tpid;
 		match->key.vlan.vlan_tpid = ethertype.value;
-- 
2.30.2



