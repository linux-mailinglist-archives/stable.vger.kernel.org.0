Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF07F73D
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfD3LsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbfD3LsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:48:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28FD021670;
        Tue, 30 Apr 2019 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624883;
        bh=ylvAkE9KQmttoptaTlEyEHPGibN9973ZHhChuIL98EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpGec2Ve5EDS3gZTl9NeqWSKq1xJpAYixd5wD5dicXroh1WBjqipV/4nLG89daRjZ
         OJa/9WUvOQsIMh2YVOiULhBXqdnKtRUof+NNTNiFYQ5fD2kCpXWfcahlh4SDOrdp32
         upYEhwPqYaDEszUAhTevnVw8dwaMQmHkB5NwzBfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?V=C3=A1clav=20Zindulka?= <vaclav.zindulka@tlapnet.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 01/89] netfilter: nf_tables: bogus EBUSY when deleting set after flush
Date:   Tue, 30 Apr 2019 13:37:52 +0200
Message-Id: <20190430113609.874540592@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 273fe3f1006ea5ebc63d6729e43e8e45e32b256a ]

Set deletion after flush coming in the same batch results in EBUSY. Add
set use counter to track the number of references to this set from
rules. We cannot rely on the list of bindings for this since such list
is still populated from the preparation phase.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nf_tables_api.c     | 28 +++++++++++++++++++++++++++-
 net/netfilter/nft_dynset.c        | 13 +++++++++----
 net/netfilter/nft_lookup.c        | 13 +++++++++----
 net/netfilter/nft_objref.c        | 13 +++++++++----
 5 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0612439909dc..9e0b9ecb43db 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -382,6 +382,7 @@ void nft_unregister_set(struct nft_set_type *type);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
+ *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
  *	@timeout: default timeout value in jiffies
@@ -407,6 +408,7 @@ struct nft_set {
 	u32				dtype;
 	u32				objtype;
 	u32				size;
+	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
 	u64				timeout;
@@ -467,6 +469,10 @@ struct nft_set_binding {
 	u32				flags;
 };
 
+enum nft_trans_phase;
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase);
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index acb124ce92ec..e2aac80f9b7b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3624,6 +3624,9 @@ err1:
 
 static void nft_set_destroy(struct nft_set *set)
 {
+	if (WARN_ON(set->use > 0))
+		return;
+
 	set->ops->destroy(set);
 	module_put(to_set_type(set->ops)->owner);
 	kfree(set->name);
@@ -3664,7 +3667,7 @@ static int nf_tables_delset(struct net *net, struct sock *nlsk,
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(set);
 	}
-	if (!list_empty(&set->bindings) ||
+	if (set->use ||
 	    (nlh->nlmsg_flags & NLM_F_NONREC && atomic_read(&set->nelems) > 0)) {
 		NL_SET_BAD_ATTR(extack, attr);
 		return -EBUSY;
@@ -3694,6 +3697,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_binding *i;
 	struct nft_set_iter iter;
 
+	if (set->use == UINT_MAX)
+		return -EOVERFLOW;
+
 	if (!list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		return -EBUSY;
 
@@ -3721,6 +3727,7 @@ bind:
 	binding->chain = ctx->chain;
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	nft_set_trans_bind(ctx, set);
+	set->use++;
 
 	return 0;
 }
@@ -3740,6 +3747,25 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
+void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
+			      struct nft_set_binding *binding,
+			      enum nft_trans_phase phase)
+{
+	switch (phase) {
+	case NFT_TRANS_PREPARE:
+		set->use--;
+		return;
+	case NFT_TRANS_ABORT:
+	case NFT_TRANS_RELEASE:
+		set->use--;
+		/* fall through */
+	default:
+		nf_tables_unbind_set(ctx, set, binding,
+				     phase == NFT_TRANS_COMMIT);
+	}
+}
+EXPORT_SYMBOL_GPL(nf_tables_deactivate_set);
+
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index f1172f99752b..eb7f9a5f2aeb 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -241,11 +241,15 @@ static void nft_dynset_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_dynset_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
@@ -293,6 +297,7 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
+	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 14496da5141d..161c3451a747 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -127,11 +127,15 @@ static void nft_lookup_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_lookup_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr)
+{
+	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
@@ -222,6 +226,7 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
+	.activate	= nft_lookup_activate,
 	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index ae178e914486..d8737c115257 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -161,11 +161,15 @@ static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	if (phase == NFT_TRANS_PREPARE)
-		return;
+	nf_tables_deactivate_set(ctx, priv->set, &priv->binding, phase);
+}
+
+static void nft_objref_map_activate(const struct nft_ctx *ctx,
+				    const struct nft_expr *expr)
+{
+	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
-			     phase == NFT_TRANS_COMMIT);
+	priv->set->use++;
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
@@ -182,6 +186,7 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
+	.activate	= nft_objref_map_activate,
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-- 
2.19.1



