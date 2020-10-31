Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6479C2A157E
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgJaLfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:32918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726815AbgJaLfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:35:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C9420739;
        Sat, 31 Oct 2020 11:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144109;
        bh=VWh0fUkWEhdVndoNEnc0IgVYD0aAWkARHoQalJhUS+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1K0lt0RSxg4XT/CE8CNEov/Sh2dT/RbwiXTGie7+WWXFCyBSdbB2SGq9bgCro8kst
         w87N7E0kyqdJzwRplCzltlJQWiqUrgq21yymNcHy5cw+w6nao9h1AnGZI/EH3IUwBh
         D3nh0JRtFJzKku0bSwvUYHcBspqg6+qEtuLZ9M3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 01/49] netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create
Date:   Sat, 31 Oct 2020 12:34:57 +0100
Message-Id: <20201031113455.517393550@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113455.439684970@linuxfoundation.org>
References: <20201031113455.439684970@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

commit 31cc578ae2de19c748af06d859019dced68e325d upstream.

This patch fixes the issue due to:

BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
net/netfilter/nf_tables_offload.c:40
Read of size 8 at addr ffff888103910b58 by task syz-executor227/16244

The error happens when expr->ops is accessed early on before performing the boundary check and after nft_expr_next() moves the expr to go out-of-bounds.

This patch checks the boundary condition before expr->ops that fixes the slab-out-of-bounds Read issue.

Add nft_expr_more() and use it to fix this problem.

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/netfilter/nf_tables.h |    6 ++++++
 net/netfilter/nf_tables_api.c     |    6 +++---
 net/netfilter/nf_tables_offload.c |    4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -872,6 +872,12 @@ static inline struct nft_expr *nft_expr_
 	return (struct nft_expr *)&rule->data[rule->dlen];
 }
 
+static inline bool nft_expr_more(const struct nft_rule *rule,
+				 const struct nft_expr *expr)
+{
+	return expr != nft_expr_last(rule) && expr->ops;
+}
+
 static inline struct nft_userdata *nft_userdata(const struct nft_rule *rule)
 {
 	return (void *)&rule->data[rule->dlen];
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -254,7 +254,7 @@ static void nft_rule_expr_activate(const
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->activate)
 			expr->ops->activate(ctx, expr);
 
@@ -269,7 +269,7 @@ static void nft_rule_expr_deactivate(con
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->deactivate)
 			expr->ops->deactivate(ctx, expr, phase);
 
@@ -2642,7 +2642,7 @@ static void nf_tables_rule_destroy(const
 	 * is called on error from nf_tables_newrule().
 	 */
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		next = nft_expr_next(expr);
 		nf_tables_expr_destroy(ctx, expr);
 		expr = next;
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -37,7 +37,7 @@ struct nft_flow_rule *nft_flow_rule_crea
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
 			num_actions++;
 
@@ -61,7 +61,7 @@ struct nft_flow_rule *nft_flow_rule_crea
 	ctx->net = net;
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (nft_expr_more(rule, expr)) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
 			goto err_out;


