Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FD54C7493
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238651AbiB1Rpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbiB1Rov (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:44:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3C15F9A;
        Mon, 28 Feb 2022 09:37:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D62FB815AB;
        Mon, 28 Feb 2022 17:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A253C340E7;
        Mon, 28 Feb 2022 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069836;
        bh=hOcuQEIH6qE59QXpAlehuUVeFbLd8rnQk55x86ePhjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vUxc6tZy4RC2hYMHiOq09B3l9Mwql/cCUZaWJr0w09MOJjL9e73Dku0Z0P4rEXsLl
         ROkhkU600ASLbLkb80sgizuEXLV24QG7o4uKCW+MkpzKkrfXz/sUhu9JArwI3QLe/q
         jdweDLbQaHjFLziQHK8rUtedSyapSyjriJvyfYSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Nick Gregory <Nick.Gregory@Sophos.com>
Subject: [PATCH 5.15 029/139] netfilter: nf_tables_offload: incorrect flow offload action array size
Date:   Mon, 28 Feb 2022 18:23:23 +0100
Message-Id: <20220228172350.829426722@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b1a5983f56e371046dcf164f90bfaf704d2b89f6 upstream.

immediate verdict expression needs to allocate one slot in the flow offload
action array, however, immediate data expression does not need to do so.

fwd and dup expression need to allocate one slot, this is missing.

Add a new offload_action interface to report if this expression needs to
allocate one slot in the flow offload action array.

Fixes: be2861dc36d7 ("netfilter: nft_{fwd,dup}_netdev: add offload support")
Reported-and-tested-by: Nick Gregory <Nick.Gregory@Sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h         |    2 +-
 include/net/netfilter/nf_tables_offload.h |    2 --
 net/netfilter/nf_tables_offload.c         |    3 ++-
 net/netfilter/nft_dup_netdev.c            |    6 ++++++
 net/netfilter/nft_fwd_netdev.c            |    6 ++++++
 net/netfilter/nft_immediate.c             |   12 +++++++++++-
 6 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -883,9 +883,9 @@ struct nft_expr_ops {
 	int				(*offload)(struct nft_offload_ctx *ctx,
 						   struct nft_flow_rule *flow,
 						   const struct nft_expr *expr);
+	bool				(*offload_action)(const struct nft_expr *expr);
 	void				(*offload_stats)(struct nft_expr *expr,
 							 const struct flow_stats *stats);
-	u32				offload_flags;
 	const struct nft_expr_type	*type;
 	void				*data;
 };
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -67,8 +67,6 @@ struct nft_flow_rule {
 	struct flow_rule	*rule;
 };
 
-#define NFT_OFFLOAD_F_ACTION	(1 << 0)
-
 void nft_flow_rule_set_addr_type(struct nft_flow_rule *flow,
 				 enum flow_dissector_key_id addr_type);
 
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -94,7 +94,8 @@ struct nft_flow_rule *nft_flow_rule_crea
 
 	expr = nft_expr_first(rule);
 	while (nft_expr_more(rule, expr)) {
-		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
+		if (expr->ops->offload_action &&
+		    expr->ops->offload_action(expr))
 			num_actions++;
 
 		expr = nft_expr_next(expr);
--- a/net/netfilter/nft_dup_netdev.c
+++ b/net/netfilter/nft_dup_netdev.c
@@ -67,6 +67,11 @@ static int nft_dup_netdev_offload(struct
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_MIRRED, oif);
 }
 
+static bool nft_dup_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 static struct nft_expr_type nft_dup_netdev_type;
 static const struct nft_expr_ops nft_dup_netdev_ops = {
 	.type		= &nft_dup_netdev_type,
@@ -75,6 +80,7 @@ static const struct nft_expr_ops nft_dup
 	.init		= nft_dup_netdev_init,
 	.dump		= nft_dup_netdev_dump,
 	.offload	= nft_dup_netdev_offload,
+	.offload_action	= nft_dup_netdev_offload_action,
 };
 
 static struct nft_expr_type nft_dup_netdev_type __read_mostly = {
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -77,6 +77,11 @@ static int nft_fwd_netdev_offload(struct
 	return nft_fwd_dup_netdev_offload(ctx, flow, FLOW_ACTION_REDIRECT, oif);
 }
 
+static bool nft_fwd_netdev_offload_action(const struct nft_expr *expr)
+{
+	return true;
+}
+
 struct nft_fwd_neigh {
 	u8			sreg_dev;
 	u8			sreg_addr;
@@ -219,6 +224,7 @@ static const struct nft_expr_ops nft_fwd
 	.dump		= nft_fwd_netdev_dump,
 	.validate	= nft_fwd_validate,
 	.offload	= nft_fwd_netdev_offload,
+	.offload_action	= nft_fwd_netdev_offload_action,
 };
 
 static const struct nft_expr_ops *
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -213,6 +213,16 @@ static int nft_immediate_offload(struct
 	return 0;
 }
 
+static bool nft_immediate_offload_action(const struct nft_expr *expr)
+{
+	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+
+	if (priv->dreg == NFT_REG_VERDICT)
+		return true;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_imm_ops = {
 	.type		= &nft_imm_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_immediate_expr)),
@@ -224,7 +234,7 @@ static const struct nft_expr_ops nft_imm
 	.dump		= nft_immediate_dump,
 	.validate	= nft_immediate_validate,
 	.offload	= nft_immediate_offload,
-	.offload_flags	= NFT_OFFLOAD_F_ACTION,
+	.offload_action	= nft_immediate_offload_action,
 };
 
 struct nft_expr_type nft_imm_type __read_mostly = {


