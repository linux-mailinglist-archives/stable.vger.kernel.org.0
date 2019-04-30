Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 879D1F627
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfD3Lnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729998AbfD3Lnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79AFB21707;
        Tue, 30 Apr 2019 11:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624625;
        bh=xNV8S1JS2KMFJMxx9tQPiOcoSRl7uCHi3b09jxgRNEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imhGIbUaoW6+eMpKOJ5kZbOAoALswt44U804k9SrvaaHJw7EE4dJ/74M3JqRY9Wzi
         pccUUTc6fvj1doElQ/GTL3sgEyMpl0YKEpLdd3Pr8vIBWgEroj5zPp/GDNtQMqkKo2
         +elJGoTaN1VaTy+ur/nPGdJCdBpX0kaDNvwJ7S8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/100] netfilter: nf_tables: split set destruction in deactivate and destroy phase
Date:   Tue, 30 Apr 2019 13:37:32 +0200
Message-Id: <20190430113608.812398683@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cd5125d8f51882279f50506bb9c7e5e89dc9bef3 ]

Splits unbind_set into destroy_set and unbinding operation.

Unbinding removes set from lists (so new transaction would not
find it anymore) but keeps memory allocated (so packet path continues
to work).

Rebind function is added to allow unrolling in case transaction
that wants to remove set is aborted.

Destroy function is added to free the memory, but this could occur
outside of transaction in the future.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  7 +++++-
 net/netfilter/nf_tables_api.c     | 36 +++++++++++++++++++++----------
 net/netfilter/nft_dynset.c        | 21 +++++++++++++++++-
 net/netfilter/nft_lookup.c        | 20 ++++++++++++++++-
 net/netfilter/nft_objref.c        | 20 ++++++++++++++++-
 5 files changed, 89 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0f39ac487012..2c33958f3e7a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -470,6 +470,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding);
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
+			  struct nft_set_binding *binding);
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
 
 /**
  *	enum nft_set_extensions - set extension type IDs
@@ -724,7 +727,9 @@ struct nft_expr_type {
  *	@eval: Expression evaluation function
  *	@size: full expression size, including private data size
  *	@init: initialization function
- *	@destroy: destruction function
+ *	@activate: activate expression in the next generation
+ *	@deactivate: deactivate expression in next generation
+ *	@destroy: destruction function, called after synchronize_rcu
  *	@dump: function to dump parameters
  *	@type: expression type
  *	@validate: validate expression, called during loop detection
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c06393fc716d..667f6eccbec7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -301,7 +301,7 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 			     struct nft_set *set)
 {
 	struct nft_trans *trans;
@@ -321,7 +321,7 @@ static int nft_trans_set_add(struct nft_ctx *ctx, int msg_type,
 	return 0;
 }
 
-static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
+static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
 
@@ -3568,13 +3568,6 @@ static void nft_set_destroy(struct nft_set *set)
 	kvfree(set);
 }
 
-static void nf_tables_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
-{
-	list_del_rcu(&set->list);
-	nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
-	nft_set_destroy(set);
-}
-
 static int nf_tables_delset(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -3669,17 +3662,38 @@ bind:
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
 			  struct nft_set_binding *binding)
+{
+	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
+	    nft_is_active(ctx->net, set))
+		list_add_tail_rcu(&set->list, &ctx->table->sets);
+
+	list_add_tail_rcu(&binding->list, &set->bindings);
+}
+EXPORT_SYMBOL_GPL(nf_tables_rebind_set);
+
+void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+		          struct nft_set_binding *binding)
 {
 	list_del_rcu(&binding->list);
 
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
 	    nft_is_active(ctx->net, set))
-		nf_tables_set_destroy(ctx, set);
+		list_del_rcu(&set->list);
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
+	    nft_is_active(ctx->net, set)) {
+		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
+		nft_set_destroy(set);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
+
 const struct nft_set_ext_type nft_set_ext_types[] = {
 	[NFT_SET_EXT_KEY]		= {
 		.align	= __alignof__(u32),
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6e91a37d57f2..07d4efd3d851 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -235,14 +235,31 @@ err1:
 	return err;
 }
 
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_dynset_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
 	if (priv->expr != NULL)
 		nft_expr_destroy(ctx, priv->expr);
+
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -279,6 +296,8 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
+	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index ad13e8643599..227b2b15a19c 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -121,12 +121,28 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_lookup_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
 			       const struct nft_expr *expr)
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -209,6 +225,8 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
+	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
 	.validate	= nft_lookup_validate,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index cdf348f751ec..a3185ca2a3a9 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -155,12 +155,28 @@ nla_put_failure:
 	return -1;
 }
 
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
+}
+
+static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+}
+
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
 				   const struct nft_expr *expr)
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	nf_tables_destroy_set(ctx, priv->set);
 }
 
 static struct nft_expr_type nft_objref_type;
@@ -169,6 +185,8 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
+	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
 };
-- 
2.19.1



