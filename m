Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E60F1017FE
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729914AbfKSFgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:36:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbfKSFgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:36:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D8CF20672;
        Tue, 19 Nov 2019 05:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141765;
        bh=7e2XOAxRCZkEiFfovhqWgSe7n5iO8CPSFgffFPsUjWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TOz2HwTK9Ip9yRdhMOV44KhaIGcmI4DQ3/jcZYPvilcJCRX4dr15ukY/jEsbIF5ar
         PrR2L5wLxXWswDz3Al4PWyeyDJ3VDxQ/FdPPlKmAA5HLMMXj6UAKB6gfk/v3KCgm3f
         Idmc/FQ5xtnfZRrie7Xp1sNt0W6gOiyg+spZRA+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/422] netfilter: nf_tables: avoid BUG_ON usage
Date:   Tue, 19 Nov 2019 06:17:10 +0100
Message-Id: <20191119051414.205983228@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit fa5950e498e7face21a1761f327e6c1152f778c3 ]

None of these spots really needs to crash the kernel.
In one two cases we can jsut report error to userspace, in the other
cases we can just use WARN_ON (and leak memory instead).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++++---
 net/netfilter/nft_cmp.c       | 6 ++++--
 net/netfilter/nft_reject.c    | 6 ++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 24fddf0322790..289d079008ee8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1031,7 +1031,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 static void nf_tables_table_destroy(struct nft_ctx *ctx)
 {
-	BUG_ON(ctx->table->use > 0);
+	if (WARN_ON(ctx->table->use > 0))
+		return;
 
 	rhltable_destroy(&ctx->table->chains_ht);
 	kfree(ctx->table->name);
@@ -1446,7 +1447,8 @@ static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
 
-	BUG_ON(chain->use > 0);
+	if (WARN_ON(chain->use > 0))
+		return;
 
 	/* no concurrent access possible anymore */
 	nf_tables_chain_free_chain_rules(chain);
@@ -7253,7 +7255,8 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule, *nr;
 
-	BUG_ON(!nft_is_base_chain(ctx->chain));
+	if (WARN_ON(!nft_is_base_chain(ctx->chain)))
+		return 0;
 
 	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
 	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index fa90a8402845d..79d48c1d06f4d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -79,7 +79,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	err = nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
@@ -129,7 +130,8 @@ static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 
 	err = nft_data_init(NULL, &data, sizeof(data), &desc,
 			    tb[NFTA_CMP_DATA]);
-	BUG_ON(err < 0);
+	if (err < 0)
+		return err;
 
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 29f5bd2377b0d..b48e58cceeb72 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -94,7 +94,8 @@ static u8 icmp_code_v4[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmp_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMP_NET_UNREACH;
 
 	return icmp_code_v4[code];
 }
@@ -111,7 +112,8 @@ static u8 icmp_code_v6[NFT_REJECT_ICMPX_MAX + 1] = {
 
 int nft_reject_icmpv6_code(u8 code)
 {
-	BUG_ON(code > NFT_REJECT_ICMPX_MAX);
+	if (WARN_ON_ONCE(code > NFT_REJECT_ICMPX_MAX))
+		return ICMPV6_NOROUTE;
 
 	return icmp_code_v6[code];
 }
-- 
2.20.1



