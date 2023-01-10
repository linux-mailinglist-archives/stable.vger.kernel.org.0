Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4836648EC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbjAJSQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbjAJSPy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:15:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5691F1706F
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D4F6184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA07CC433EF;
        Tue, 10 Jan 2023 18:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374435;
        bh=6R2knIInNLe4P0YMsTDWAA0pbRMNEWXFi8r7HIWyekw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrfXm1L9EMHHBIH/0vuCP66OAH8DdTOv61oAHeyOzuZgd6pPs+udSUAWN6O1QoVpg
         qBaykPuC382XNxqypU7AHrk627ZwgCj0IE/qILvahuf37EqT2SIIkogsZS2psI2C15
         2OmyY0NsbvM9bE/TCVYv1HlHAAPSbs3hTlsoV7o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/159] netfilter: nf_tables: add function to create set stateful expressions
Date:   Tue, 10 Jan 2023 19:02:45 +0100
Message-Id: <20230110180018.853048652@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a8fe4154fa5a1bae590b243ed60f871e5a5e1378 ]

Add a helper function to allocate and initialize the stateful expressions
that are defined in a set.

This patch allows to reuse this code from the set update path, to check
that type of the update matches the existing set in the kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: f6594c372afd ("netfilter: nf_tables: perform type checking for existing sets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 106 ++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a31f8dc40646..9f35a249c2c3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4340,6 +4340,59 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 	return err;
 }
 
+static int nft_set_expr_alloc(struct nft_ctx *ctx, struct nft_set *set,
+			      const struct nlattr * const *nla,
+			      struct nft_expr **exprs, int *num_exprs,
+			      u32 flags)
+{
+	struct nft_expr *expr;
+	int err, i;
+
+	if (nla[NFTA_SET_EXPR]) {
+		expr = nft_set_elem_expr_alloc(ctx, set, nla[NFTA_SET_EXPR]);
+		if (IS_ERR(expr)) {
+			err = PTR_ERR(expr);
+			goto err_set_expr_alloc;
+		}
+		exprs[0] = expr;
+		(*num_exprs)++;
+	} else if (nla[NFTA_SET_EXPRESSIONS]) {
+		struct nlattr *tmp;
+		int left;
+
+		if (!(flags & NFT_SET_EXPR)) {
+			err = -EINVAL;
+			goto err_set_expr_alloc;
+		}
+		i = 0;
+		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
+			if (i == NFT_SET_EXPR_MAX) {
+				err = -E2BIG;
+				goto err_set_expr_alloc;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_set_expr_alloc;
+			}
+			expr = nft_set_elem_expr_alloc(ctx, set, tmp);
+			if (IS_ERR(expr)) {
+				err = PTR_ERR(expr);
+				goto err_set_expr_alloc;
+			}
+			exprs[i++] = expr;
+			(*num_exprs)++;
+		}
+	}
+
+	return 0;
+
+err_set_expr_alloc:
+	for (i = 0; i < *num_exprs; i++)
+		nft_expr_destroy(ctx, exprs[i]);
+
+	return err;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -4347,7 +4400,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
-	struct nft_expr *expr = NULL;
 	struct net *net = info->net;
 	struct nft_set_desc desc;
 	struct nft_table *table;
@@ -4355,6 +4407,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	size_t alloc_size;
+	int num_exprs = 0;
 	char *name;
 	int err, i;
 	u16 udlen;
@@ -4481,6 +4534,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			return PTR_ERR(set);
 		}
 	} else {
+		struct nft_expr *exprs[NFT_SET_EXPR_MAX] = {};
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 			return -EEXIST;
@@ -4488,6 +4543,13 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		err = nft_set_expr_alloc(&ctx, set, nla, exprs, &num_exprs, flags);
+		if (err < 0)
+			return err;
+
+		for (i = 0; i < num_exprs; i++)
+			nft_expr_destroy(&ctx, exprs[i]);
+
 		return 0;
 	}
 
@@ -4555,43 +4617,11 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_set_init;
 
-	if (nla[NFTA_SET_EXPR]) {
-		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
-		if (IS_ERR(expr)) {
-			err = PTR_ERR(expr);
-			goto err_set_expr_alloc;
-		}
-		set->exprs[0] = expr;
-		set->num_exprs++;
-	} else if (nla[NFTA_SET_EXPRESSIONS]) {
-		struct nft_expr *expr;
-		struct nlattr *tmp;
-		int left;
-
-		if (!(flags & NFT_SET_EXPR)) {
-			err = -EINVAL;
-			goto err_set_expr_alloc;
-		}
-		i = 0;
-		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
-			if (i == NFT_SET_EXPR_MAX) {
-				err = -E2BIG;
-				goto err_set_expr_alloc;
-			}
-			if (nla_type(tmp) != NFTA_LIST_ELEM) {
-				err = -EINVAL;
-				goto err_set_expr_alloc;
-			}
-			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
-			if (IS_ERR(expr)) {
-				err = PTR_ERR(expr);
-				goto err_set_expr_alloc;
-			}
-			set->exprs[i++] = expr;
-			set->num_exprs++;
-		}
-	}
+	err = nft_set_expr_alloc(&ctx, set, nla, set->exprs, &num_exprs, flags);
+	if (err < 0)
+		goto err_set_destroy;
 
+	set->num_exprs = num_exprs;
 	set->handle = nf_tables_alloc_handle(table);
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
@@ -4605,7 +4635,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
-
+err_set_destroy:
 	ops->destroy(set);
 err_set_init:
 	kfree(set->name);
-- 
2.35.1



