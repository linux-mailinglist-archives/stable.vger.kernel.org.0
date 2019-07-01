Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE3F7CC
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbfD3Ln4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728550AbfD3Lny (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB4220449;
        Tue, 30 Apr 2019 11:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624632;
        bh=1HBqYsNPWsLtBwTmKxDm0xczKsjEEqtbj4JhXa85U8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRySst2MBGnA5r1TaZeKzotRN4bEVHV+juEt64VN0LVIii/Dt1p/XMJRKsPXavjVu
         GsdEp9qxHkR0dr5LysS39dAX9M4vY12bS523cJVDAbQG3XdOA2TJ1T+pWf8ItgzOEq
         Bq3S0TM1cxtIzWkBuXKNXDr6HdNl1b1kjtOSqrds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikhail Morfikov <mmorfikov@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 006/100] netfilter: nf_tables: unbind set in rule from commit path
Date:   Tue, 30 Apr 2019 13:37:35 +0200
Message-Id: <20190430113608.942203473@linuxfoundation.org>
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

Anonymous sets that are bound to rules from the same transaction trigger
a kernel splat from the abort path due to double set list removal and
double free.

This patch updates the logic to search for the transaction that is
responsible for creating the set and disable the set list removal and
release, given the rule is now responsible for this. Lookup is reverse
since the transaction that adds the set is likely to be at the tail of
the list.

Moreover, this patch adds the unbind step to deliver the event from the
commit path.  This should not be done from the worker thread, since we
have no guarantees of in-order delivery to the listener.

This patch removes the assumption that both activate and deactivate
callbacks need to be provided.

Fixes: cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate and destroy phase")
Reported-by: Mikhail Morfikov <mmorfikov@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 17 +++++--
 net/netfilter/nf_tables_api.c     | 85 +++++++++++++++----------------
 net/netfilter/nft_compat.c        |  6 ++-
 net/netfilter/nft_dynset.c        | 18 +++----
 net/netfilter/nft_immediate.c     |  6 ++-
 net/netfilter/nft_lookup.c        | 18 +++----
 net/netfilter/nft_objref.c        | 18 +++----
 7 files changed, 85 insertions(+), 83 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2c33958f3e7a..50c101e0286a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -469,9 +469,7 @@ struct nft_set_binding {
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding);
-void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding);
+			  struct nft_set_binding *binding, bool commit);
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
 
 /**
@@ -721,6 +719,13 @@ struct nft_expr_type {
 #define NFT_EXPR_STATEFUL		0x1
 #define NFT_EXPR_GC			0x2
 
+enum nft_trans_phase {
+	NFT_TRANS_PREPARE,
+	NFT_TRANS_ABORT,
+	NFT_TRANS_COMMIT,
+	NFT_TRANS_RELEASE
+};
+
 /**
  *	struct nft_expr_ops - nf_tables expression operations
  *
@@ -750,7 +755,8 @@ struct nft_expr_ops {
 	void				(*activate)(const struct nft_ctx *ctx,
 						    const struct nft_expr *expr);
 	void				(*deactivate)(const struct nft_ctx *ctx,
-						      const struct nft_expr *expr);
+						      const struct nft_expr *expr,
+						      enum nft_trans_phase phase);
 	void				(*destroy)(const struct nft_ctx *ctx,
 						   const struct nft_expr *expr);
 	void				(*destroy_clone)(const struct nft_ctx *ctx,
@@ -1321,12 +1327,15 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
+	bool				bound;
 };
 
 #define nft_trans_set(trans)	\
 	(((struct nft_trans_set *)trans->data)->set)
 #define nft_trans_set_id(trans)	\
 	(((struct nft_trans_set *)trans->data)->set_id)
+#define nft_trans_set_bound(trans)	\
+	(((struct nft_trans_set *)trans->data)->bound)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dd2b28a09bd4..9f4d37b794eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -112,6 +112,23 @@ static void nft_trans_destroy(struct nft_trans *trans)
 	kfree(trans);
 }
 
+static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	struct net *net = ctx->net;
+	struct nft_trans *trans;
+
+	if (!nft_set_is_anonymous(set))
+		return;
+
+	list_for_each_entry_reverse(trans, &net->nft.commit_list, list) {
+		if (trans->msg_type == NFT_MSG_NEWSET &&
+		    nft_trans_set(trans) == set) {
+			nft_trans_set_bound(trans) = true;
+			break;
+		}
+	}
+}
+
 static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
@@ -207,18 +224,6 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
-/* either expr ops provide both activate/deactivate, or neither */
-static bool nft_expr_check_ops(const struct nft_expr_ops *ops)
-{
-	if (!ops)
-		return true;
-
-	if (WARN_ON_ONCE((!ops->activate ^ !ops->deactivate)))
-		return false;
-
-	return true;
-}
-
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
@@ -234,14 +239,15 @@ static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 }
 
 static void nft_rule_expr_deactivate(const struct nft_ctx *ctx,
-				     struct nft_rule *rule)
+				     struct nft_rule *rule,
+				     enum nft_trans_phase phase)
 {
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
 	while (expr != nft_expr_last(rule) && expr->ops) {
 		if (expr->ops->deactivate)
-			expr->ops->deactivate(ctx, expr);
+			expr->ops->deactivate(ctx, expr, phase);
 
 		expr = nft_expr_next(expr);
 	}
@@ -292,7 +298,7 @@ static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
 		nft_trans_destroy(trans);
 		return err;
 	}
-	nft_rule_expr_deactivate(ctx, rule);
+	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_PREPARE);
 
 	return 0;
 }
@@ -1926,9 +1932,6 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
-	if (!nft_expr_check_ops(type->ops))
-		return -EINVAL;
-
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
@@ -2076,10 +2079,6 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 			err = PTR_ERR(ops);
 			goto err1;
 		}
-		if (!nft_expr_check_ops(ops)) {
-			err = -EINVAL;
-			goto err1;
-		}
 	} else
 		ops = type->ops;
 
@@ -2477,7 +2476,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 static void nf_tables_rule_release(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
-	nft_rule_expr_deactivate(ctx, rule);
+	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
 }
 
@@ -3677,39 +3676,30 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 bind:
 	binding->chain = ctx->chain;
 	list_add_tail_rcu(&binding->list, &set->bindings);
+	nft_set_trans_bind(ctx, set);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_rebind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding)
-{
-	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
-	    nft_is_active(ctx->net, set))
-		list_add_tail_rcu(&set->list, &ctx->table->sets);
-
-	list_add_tail_rcu(&binding->list, &set->bindings);
-}
-EXPORT_SYMBOL_GPL(nf_tables_rebind_set);
-
 void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-		          struct nft_set_binding *binding)
+			  struct nft_set_binding *binding, bool event)
 {
 	list_del_rcu(&binding->list);
 
-	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
-	    nft_is_active(ctx->net, set))
+	if (list_empty(&set->bindings) && nft_set_is_anonymous(set)) {
 		list_del_rcu(&set->list);
+		if (event)
+			nf_tables_set_notify(ctx, set, NFT_MSG_DELSET,
+					     GFP_KERNEL);
+	}
 }
 EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set)
 {
-	if (list_empty(&set->bindings) && nft_set_is_anonymous(set) &&
-	    nft_is_active(ctx->net, set)) {
-		nf_tables_set_notify(ctx, set, NFT_MSG_DELSET, GFP_ATOMIC);
+	if (list_empty(&set->bindings) && nft_set_is_anonymous(set))
 		nft_set_destroy(set);
-	}
 }
 EXPORT_SYMBOL_GPL(nf_tables_destroy_set);
 
@@ -6462,6 +6452,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_DELRULE);
+			nft_rule_expr_deactivate(&trans->ctx,
+						 nft_trans_rule(trans),
+						 NFT_TRANS_COMMIT);
 			break;
 		case NFT_MSG_NEWSET:
 			nft_clear(net, nft_trans_set(trans));
@@ -6549,7 +6542,8 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_NEWSET:
-		nft_set_destroy(nft_trans_set(trans));
+		if (!nft_trans_set_bound(trans))
+			nft_set_destroy(nft_trans_set(trans));
 		break;
 	case NFT_MSG_NEWSETELEM:
 		nft_set_elem_destroy(nft_trans_elem_set(trans),
@@ -6610,7 +6604,9 @@ static int __nf_tables_abort(struct net *net)
 		case NFT_MSG_NEWRULE:
 			trans->ctx.chain->use--;
 			list_del_rcu(&nft_trans_rule(trans)->list);
-			nft_rule_expr_deactivate(&trans->ctx, nft_trans_rule(trans));
+			nft_rule_expr_deactivate(&trans->ctx,
+						 nft_trans_rule(trans),
+						 NFT_TRANS_ABORT);
 			break;
 		case NFT_MSG_DELRULE:
 			trans->ctx.chain->use++;
@@ -6620,7 +6616,8 @@ static int __nf_tables_abort(struct net *net)
 			break;
 		case NFT_MSG_NEWSET:
 			trans->ctx.table->use--;
-			list_del_rcu(&nft_trans_set(trans)->list);
+			if (!nft_trans_set_bound(trans))
+				list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
 			trans->ctx.table->use++;
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 432139b7fa1f..12a95eec9565 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -569,10 +569,14 @@ static void nft_compat_activate_tg(const struct nft_ctx *ctx,
 }
 
 static void nft_compat_deactivate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
 
+	if (phase == NFT_TRANS_COMMIT)
+		return;
+
 	if (--xt->listcnt == 0)
 		list_del_init(&xt->head);
 }
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 07d4efd3d851..f1172f99752b 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -235,20 +235,17 @@ err1:
 	return err;
 }
 
-static void nft_dynset_activate(const struct nft_ctx *ctx,
-				const struct nft_expr *expr)
-{
-	struct nft_dynset *priv = nft_expr_priv(expr);
-
-	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
-}
-
 static void nft_dynset_deactivate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	if (phase == NFT_TRANS_PREPARE)
+		return;
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
+			     phase == NFT_TRANS_COMMIT);
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
@@ -296,7 +293,6 @@ static const struct nft_expr_ops nft_dynset_ops = {
 	.eval		= nft_dynset_eval,
 	.init		= nft_dynset_init,
 	.destroy	= nft_dynset_destroy,
-	.activate	= nft_dynset_activate,
 	.deactivate	= nft_dynset_deactivate,
 	.dump		= nft_dynset_dump,
 };
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 0777a93211e2..3f6d1d2a6281 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -72,10 +72,14 @@ static void nft_immediate_activate(const struct nft_ctx *ctx,
 }
 
 static void nft_immediate_deactivate(const struct nft_ctx *ctx,
-				     const struct nft_expr *expr)
+				     const struct nft_expr *expr,
+				     enum nft_trans_phase phase)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
+	if (phase == NFT_TRANS_COMMIT)
+		return;
+
 	return nft_data_release(&priv->data, nft_dreg_to_type(priv->dreg));
 }
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 227b2b15a19c..14496da5141d 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -121,20 +121,17 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_lookup_activate(const struct nft_ctx *ctx,
-				const struct nft_expr *expr)
-{
-	struct nft_lookup *priv = nft_expr_priv(expr);
-
-	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
-}
-
 static void nft_lookup_deactivate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr)
+				  const struct nft_expr *expr,
+				  enum nft_trans_phase phase)
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	if (phase == NFT_TRANS_PREPARE)
+		return;
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
+			     phase == NFT_TRANS_COMMIT);
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
@@ -225,7 +222,6 @@ static const struct nft_expr_ops nft_lookup_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_lookup)),
 	.eval		= nft_lookup_eval,
 	.init		= nft_lookup_init,
-	.activate	= nft_lookup_activate,
 	.deactivate	= nft_lookup_deactivate,
 	.destroy	= nft_lookup_destroy,
 	.dump		= nft_lookup_dump,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index a3185ca2a3a9..ae178e914486 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -155,20 +155,17 @@ nla_put_failure:
 	return -1;
 }
 
-static void nft_objref_map_activate(const struct nft_ctx *ctx,
-				    const struct nft_expr *expr)
-{
-	struct nft_objref_map *priv = nft_expr_priv(expr);
-
-	nf_tables_rebind_set(ctx, priv->set, &priv->binding);
-}
-
 static void nft_objref_map_deactivate(const struct nft_ctx *ctx,
-				      const struct nft_expr *expr)
+				      const struct nft_expr *expr,
+				      enum nft_trans_phase phase)
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	nf_tables_unbind_set(ctx, priv->set, &priv->binding);
+	if (phase == NFT_TRANS_PREPARE)
+		return;
+
+	nf_tables_unbind_set(ctx, priv->set, &priv->binding,
+			     phase == NFT_TRANS_COMMIT);
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
@@ -185,7 +182,6 @@ static const struct nft_expr_ops nft_objref_map_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_objref_map)),
 	.eval		= nft_objref_map_eval,
 	.init		= nft_objref_map_init,
-	.activate	= nft_objref_map_activate,
 	.deactivate	= nft_objref_map_deactivate,
 	.destroy	= nft_objref_map_destroy,
 	.dump		= nft_objref_map_dump,
-- 
2.19.1



