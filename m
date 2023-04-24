Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03EF6ECE27
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjDXN3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjDXN3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:29:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C497E6E9D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 959F662329
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E1CC433D2;
        Mon, 24 Apr 2023 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342959;
        bh=q3dPlesJV6Bwc2oYXcT0b3i7mZ1nhXNXeGlOjFuDq2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7uC9Rv9iIQ31x7IfZ+TKQZJr0kJCOv6iWLhWLdbt6SXj/TKlB2y/VQ+LTA0RrftS
         7PN+Fnd8RZZqWw8543EEgjis5yOrzHutoZNXSB6RhRqt0CA0uBLWO9dFtIAYFX98cG
         3ODmTSVV69IZTp5P5gq0CmJFpSGzkzVnpFNwI8Uc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/110] netfilter: nf_tables: validate catch-all set elements
Date:   Mon, 24 Apr 2023 15:16:45 +0200
Message-Id: <20230424131137.010152850@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d46fc894147cf98dd6e8210aa99ed46854191840 ]

catch-all set element might jump/goto to chain that uses expressions
that require validation.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  4 ++
 net/netfilter/nf_tables_api.c     | 64 ++++++++++++++++++++++++++++---
 net/netfilter/nft_lookup.c        | 36 ++---------------
 3 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9430128aae991..1b8e305bb54ae 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1085,6 +1085,10 @@ struct nft_chain {
 };
 
 int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain);
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem);
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set);
 
 enum nft_chain_types {
 	NFT_CHAIN_T_DEFAULT = 0,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc4f692d3005a..94ad50ac91602 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3439,6 +3439,64 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
+			 const struct nft_set_iter *iter,
+			 struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
+	const struct nft_data *data;
+	int err;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
+		return 0;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		pctx->level++;
+		err = nft_chain_validate(ctx, data->verdict.chain);
+		if (err < 0)
+			return err;
+		pctx->level--;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
@@ -4743,12 +4801,6 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-struct nft_set_elem_catchall {
-	struct list_head	list;
-	struct rcu_head		rcu;
-	void			*elem;
-};
-
 static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 				     struct nft_set *set)
 {
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index cae5a67241634..cecf8ab90e58f 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -199,37 +199,6 @@ static int nft_lookup_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static int nft_lookup_validate_setelem(const struct nft_ctx *ctx,
-				       struct nft_set *set,
-				       const struct nft_set_iter *iter,
-				       struct nft_set_elem *elem)
-{
-	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	struct nft_ctx *pctx = (struct nft_ctx *)ctx;
-	const struct nft_data *data;
-	int err;
-
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
-	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
-		return 0;
-
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		pctx->level++;
-		err = nft_chain_validate(ctx, data->verdict.chain);
-		if (err < 0)
-			return err;
-		pctx->level--;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static int nft_lookup_validate(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr,
 			       const struct nft_data **d)
@@ -245,9 +214,12 @@ static int nft_lookup_validate(const struct nft_ctx *ctx,
 	iter.skip	= 0;
 	iter.count	= 0;
 	iter.err	= 0;
-	iter.fn		= nft_lookup_validate_setelem;
+	iter.fn		= nft_setelem_validate;
 
 	priv->set->ops->walk(ctx, priv->set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_validate(ctx, priv->set);
+
 	if (iter.err < 0)
 		return iter.err;
 
-- 
2.39.2



