Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92905F7C9
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfD3LoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730060AbfD3Ln7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AB920449;
        Tue, 30 Apr 2019 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624638;
        bh=dP600AC7DQo3gguDMXyCcfzqzmM9zOck6aKvK/6AkbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFmkB+YUxHAc44udbClQpzV8zuPb/XkkEFnHZUyN8T6HhoW9Knhbc8q9IoVBFgXRl
         05QZlzTGYKUSLICATZfsuN3fV5FSFePfeicXbypVeaGVr0rIHwPgeYLSjGnfG7Xvj8
         pT1gj57PBwGeoDtV1X2rjvU2YUSOLyInBWhZgOns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 008/100] netfilter: nft_compat: use .release_ops and remove list of extension
Date:   Tue, 30 Apr 2019 13:37:37 +0200
Message-Id: <20190430113609.023900571@linuxfoundation.org>
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

[ Upstream commit b8e204006340b7aaf32bd2b9806c692f6e0cb38a ]

Add .release_ops, that is called in case of error at a later stage in
the expression initialization path, ie. .select_ops() has been already
set up operations and that needs to be undone. This allows us to unwind
.select_ops from the error path, ie. release the dynamic operations for
this extension.

Moreover, allocate one single operation instead of recycling them, this
comes at the cost of consuming a bit more memory per rule, but it
simplifies the infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |   3 +
 net/netfilter/nf_tables_api.c     |   7 +-
 net/netfilter/nft_compat.c        | 281 ++++++------------------------
 3 files changed, 64 insertions(+), 227 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 50c101e0286a..f66bb406004b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -690,10 +690,12 @@ static inline void nft_set_gc_batch_add(struct nft_set_gc_batch *gcb,
 	gcb->elems[gcb->head.cnt++] = elem;
 }
 
+struct nft_expr_ops;
 /**
  *	struct nft_expr_type - nf_tables expression type
  *
  *	@select_ops: function to select nft_expr_ops
+ *	@release_ops: release nft_expr_ops
  *	@ops: default ops, used when no select_ops functions is present
  *	@list: used internally
  *	@name: Identifier
@@ -706,6 +708,7 @@ static inline void nft_set_gc_batch_add(struct nft_set_gc_batch *gcb,
 struct nft_expr_type {
 	const struct nft_expr_ops	*(*select_ops)(const struct nft_ctx *,
 						       const struct nlattr * const tb[]);
+	void				(*release_ops)(const struct nft_expr_ops *ops);
 	const struct nft_expr_ops	*ops;
 	struct list_head		list;
 	const char			*name;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9f4d37b794eb..de5908d51758 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2123,6 +2123,7 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 {
 	struct nft_expr_info info;
 	struct nft_expr *expr;
+	struct module *owner;
 	int err;
 
 	err = nf_tables_expr_parse(ctx, nla, &info);
@@ -2142,7 +2143,11 @@ struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 err3:
 	kfree(expr);
 err2:
-	module_put(info.ops->type->owner);
+	owner = info.ops->type->owner;
+	if (info.ops->type->release_ops)
+		info.ops->type->release_ops(info.ops);
+
+	module_put(owner);
 err1:
 	return ERR_PTR(err);
 }
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 859eb3e12ddf..1245e02239d9 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -22,23 +22,6 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <net/netfilter/nf_tables.h>
-#include <net/netns/generic.h>
-
-struct nft_xt {
-	struct list_head	head;
-	struct nft_expr_ops	ops;
-	refcount_t		refcnt;
-
-	/* used only when transaction mutex is locked */
-	unsigned int		listcnt;
-
-	/* Unlike other expressions, ops doesn't have static storage duration.
-	 * nft core assumes they do.  We use kfree_rcu so that nft core can
-	 * can check expr->ops->size even after nft_compat->destroy() frees
-	 * the nft_xt struct that holds the ops structure.
-	 */
-	struct rcu_head		rcu_head;
-};
 
 /* Used for matches where *info is larger than X byte */
 #define NFT_MATCH_LARGE_THRESH	192
@@ -47,46 +30,6 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
-struct nft_compat_net {
-	struct list_head nft_target_list;
-	struct list_head nft_match_list;
-};
-
-static unsigned int nft_compat_net_id __read_mostly;
-static struct nft_expr_type nft_match_type;
-static struct nft_expr_type nft_target_type;
-
-static struct nft_compat_net *nft_compat_pernet(struct net *net)
-{
-	return net_generic(net, nft_compat_net_id);
-}
-
-static void nft_xt_get(struct nft_xt *xt)
-{
-	/* refcount_inc() warns on 0 -> 1 transition, but we can't
-	 * init the reference count to 1 in .select_ops -- we can't
-	 * undo such an increase when another expression inside the same
-	 * rule fails afterwards.
-	 */
-	if (xt->listcnt == 0)
-		refcount_set(&xt->refcnt, 1);
-	else
-		refcount_inc(&xt->refcnt);
-
-	xt->listcnt++;
-}
-
-static bool nft_xt_put(struct nft_xt *xt)
-{
-	if (refcount_dec_and_test(&xt->refcnt)) {
-		WARN_ON_ONCE(!list_empty(&xt->head));
-		kfree_rcu(xt, rcu_head);
-		return true;
-	}
-
-	return false;
-}
-
 static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 						const char *tablename)
 {
@@ -281,7 +224,6 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_target *target = expr->ops->data;
 	struct xt_tgchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_TARGET_INFO]));
-	struct nft_xt *nft_xt;
 	u16 proto = 0;
 	bool inv = false;
 	union nft_entry e = {};
@@ -305,8 +247,6 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (!target->target)
 		return -EINVAL;
 
-	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt_get(nft_xt);
 	return 0;
 }
 
@@ -325,8 +265,8 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 
-	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
-		module_put(me);
+	module_put(me);
+	kfree(expr->ops);
 }
 
 static int nft_target_dump(struct sk_buff *skb, const struct nft_expr *expr)
@@ -480,7 +420,6 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	struct xt_match *match = expr->ops->data;
 	struct xt_mtchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
-	struct nft_xt *nft_xt;
 	u16 proto = 0;
 	bool inv = false;
 	union nft_entry e = {};
@@ -496,13 +435,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
-	ret = xt_check_match(&par, size, proto, inv);
-	if (ret < 0)
-		return ret;
-
-	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt_get(nft_xt);
-	return 0;
+	return xt_check_match(&par, size, proto, inv);
 }
 
 static int
@@ -545,8 +478,8 @@ __nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 
-	if (nft_xt_put(container_of(expr->ops, struct nft_xt, ops)))
-		module_put(me);
+	module_put(me);
+	kfree(expr->ops);
 }
 
 static void
@@ -555,18 +488,6 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
 }
 
-static void nft_compat_deactivate(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  enum nft_trans_phase phase)
-{
-	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
-
-	if (phase == NFT_TRANS_ABORT || phase == NFT_TRANS_COMMIT) {
-		if (--xt->listcnt == 0)
-			list_del_init(&xt->head);
-	}
-}
-
 static void
 nft_match_large_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -760,19 +681,13 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 	.cb		= nfnl_nft_compat_cb,
 };
 
-static bool nft_match_cmp(const struct xt_match *match,
-			  const char *name, u32 rev, u32 family)
-{
-	return strcmp(match->name, name) == 0 && match->revision == rev &&
-	       (match->family == NFPROTO_UNSPEC || match->family == family);
-}
+static struct nft_expr_type nft_match_type;
 
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
 {
-	struct nft_compat_net *cn;
-	struct nft_xt *nft_match;
+	struct nft_expr_ops *ops;
 	struct xt_match *match;
 	unsigned int matchsize;
 	char *mt_name;
@@ -788,16 +703,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	rev = ntohl(nla_get_be32(tb[NFTA_MATCH_REV]));
 	family = ctx->family;
 
-	cn = nft_compat_pernet(ctx->net);
-
-	/* Re-use the existing match if it's already loaded. */
-	list_for_each_entry(nft_match, &cn->nft_match_list, head) {
-		struct xt_match *match = nft_match->ops.data;
-
-		if (nft_match_cmp(match, mt_name, rev, family))
-			return &nft_match->ops;
-	}
-
 	match = xt_request_find_match(family, mt_name, rev);
 	if (IS_ERR(match))
 		return ERR_PTR(-ENOENT);
@@ -807,65 +712,62 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	/* This is the first time we use this match, allocate operations */
-	nft_match = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
-	if (nft_match == NULL) {
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	if (!ops) {
 		err = -ENOMEM;
 		goto err;
 	}
 
-	refcount_set(&nft_match->refcnt, 0);
-	nft_match->ops.type = &nft_match_type;
-	nft_match->ops.eval = nft_match_eval;
-	nft_match->ops.init = nft_match_init;
-	nft_match->ops.destroy = nft_match_destroy;
-	nft_match->ops.deactivate = nft_compat_deactivate;
-	nft_match->ops.dump = nft_match_dump;
-	nft_match->ops.validate = nft_match_validate;
-	nft_match->ops.data = match;
+	ops->type = &nft_match_type;
+	ops->eval = nft_match_eval;
+	ops->init = nft_match_init;
+	ops->destroy = nft_match_destroy;
+	ops->dump = nft_match_dump;
+	ops->validate = nft_match_validate;
+	ops->data = match;
 
 	matchsize = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
 	if (matchsize > NFT_MATCH_LARGE_THRESH) {
 		matchsize = NFT_EXPR_SIZE(sizeof(struct nft_xt_match_priv));
 
-		nft_match->ops.eval = nft_match_large_eval;
-		nft_match->ops.init = nft_match_large_init;
-		nft_match->ops.destroy = nft_match_large_destroy;
-		nft_match->ops.dump = nft_match_large_dump;
+		ops->eval = nft_match_large_eval;
+		ops->init = nft_match_large_init;
+		ops->destroy = nft_match_large_destroy;
+		ops->dump = nft_match_large_dump;
 	}
 
-	nft_match->ops.size = matchsize;
+	ops->size = matchsize;
 
-	nft_match->listcnt = 0;
-	list_add(&nft_match->head, &cn->nft_match_list);
-
-	return &nft_match->ops;
+	return ops;
 err:
 	module_put(match->me);
 	return ERR_PTR(err);
 }
 
+static void nft_match_release_ops(const struct nft_expr_ops *ops)
+{
+	struct xt_match *match = ops->data;
+
+	module_put(match->me);
+	kfree(ops);
+}
+
 static struct nft_expr_type nft_match_type __read_mostly = {
 	.name		= "match",
 	.select_ops	= nft_match_select_ops,
+	.release_ops	= nft_match_release_ops,
 	.policy		= nft_match_policy,
 	.maxattr	= NFTA_MATCH_MAX,
 	.owner		= THIS_MODULE,
 };
 
-static bool nft_target_cmp(const struct xt_target *tg,
-			   const char *name, u32 rev, u32 family)
-{
-	return strcmp(tg->name, name) == 0 && tg->revision == rev &&
-	       (tg->family == NFPROTO_UNSPEC || tg->family == family);
-}
+static struct nft_expr_type nft_target_type;
 
 static const struct nft_expr_ops *
 nft_target_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
 {
-	struct nft_compat_net *cn;
-	struct nft_xt *nft_target;
+	struct nft_expr_ops *ops;
 	struct xt_target *target;
 	char *tg_name;
 	u32 rev, family;
@@ -885,18 +787,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	    strcmp(tg_name, "standard") == 0)
 		return ERR_PTR(-EINVAL);
 
-	cn = nft_compat_pernet(ctx->net);
-	/* Re-use the existing target if it's already loaded. */
-	list_for_each_entry(nft_target, &cn->nft_target_list, head) {
-		struct xt_target *target = nft_target->ops.data;
-
-		if (!target->target)
-			continue;
-
-		if (nft_target_cmp(target, tg_name, rev, family))
-			return &nft_target->ops;
-	}
-
 	target = xt_request_find_target(family, tg_name, rev);
 	if (IS_ERR(target))
 		return ERR_PTR(-ENOENT);
@@ -911,113 +801,55 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	/* This is the first time we use this target, allocate operations */
-	nft_target = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
-	if (nft_target == NULL) {
+	ops = kzalloc(sizeof(struct nft_expr_ops), GFP_KERNEL);
+	if (!ops) {
 		err = -ENOMEM;
 		goto err;
 	}
 
-	refcount_set(&nft_target->refcnt, 0);
-	nft_target->ops.type = &nft_target_type;
-	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
-	nft_target->ops.init = nft_target_init;
-	nft_target->ops.destroy = nft_target_destroy;
-	nft_target->ops.deactivate = nft_compat_deactivate;
-	nft_target->ops.dump = nft_target_dump;
-	nft_target->ops.validate = nft_target_validate;
-	nft_target->ops.data = target;
+	ops->type = &nft_target_type;
+	ops->size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
+	ops->init = nft_target_init;
+	ops->destroy = nft_target_destroy;
+	ops->dump = nft_target_dump;
+	ops->validate = nft_target_validate;
+	ops->data = target;
 
 	if (family == NFPROTO_BRIDGE)
-		nft_target->ops.eval = nft_target_eval_bridge;
+		ops->eval = nft_target_eval_bridge;
 	else
-		nft_target->ops.eval = nft_target_eval_xt;
-
-	nft_target->listcnt = 0;
-	list_add(&nft_target->head, &cn->nft_target_list);
+		ops->eval = nft_target_eval_xt;
 
-	return &nft_target->ops;
+	return ops;
 err:
 	module_put(target->me);
 	return ERR_PTR(err);
 }
 
+static void nft_target_release_ops(const struct nft_expr_ops *ops)
+{
+	struct xt_target *target = ops->data;
+
+	module_put(target->me);
+	kfree(ops);
+}
+
 static struct nft_expr_type nft_target_type __read_mostly = {
 	.name		= "target",
 	.select_ops	= nft_target_select_ops,
+	.release_ops	= nft_target_release_ops,
 	.policy		= nft_target_policy,
 	.maxattr	= NFTA_TARGET_MAX,
 	.owner		= THIS_MODULE,
 };
 
-static int __net_init nft_compat_init_net(struct net *net)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(net);
-
-	INIT_LIST_HEAD(&cn->nft_target_list);
-	INIT_LIST_HEAD(&cn->nft_match_list);
-
-	return 0;
-}
-
-static void __net_exit nft_compat_exit_net(struct net *net)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(net);
-	struct nft_xt *xt, *next;
-
-	if (list_empty(&cn->nft_match_list) &&
-	    list_empty(&cn->nft_target_list))
-		return;
-
-	/* If there was an error that caused nft_xt expr to not be initialized
-	 * fully and noone else requested the same expression later, the lists
-	 * contain 0-refcount entries that still hold module reference.
-	 *
-	 * Clean them here.
-	 */
-	mutex_lock(&net->nft.commit_mutex);
-	list_for_each_entry_safe(xt, next, &cn->nft_target_list, head) {
-		struct xt_target *target = xt->ops.data;
-
-		list_del_init(&xt->head);
-
-		if (refcount_read(&xt->refcnt))
-			continue;
-		module_put(target->me);
-		kfree(xt);
-	}
-
-	list_for_each_entry_safe(xt, next, &cn->nft_match_list, head) {
-		struct xt_match *match = xt->ops.data;
-
-		list_del_init(&xt->head);
-
-		if (refcount_read(&xt->refcnt))
-			continue;
-		module_put(match->me);
-		kfree(xt);
-	}
-	mutex_unlock(&net->nft.commit_mutex);
-}
-
-static struct pernet_operations nft_compat_net_ops = {
-	.init	= nft_compat_init_net,
-	.exit	= nft_compat_exit_net,
-	.id	= &nft_compat_net_id,
-	.size	= sizeof(struct nft_compat_net),
-};
-
 static int __init nft_compat_module_init(void)
 {
 	int ret;
 
-	ret = register_pernet_subsys(&nft_compat_net_ops);
-	if (ret < 0)
-		goto err_target;
-
 	ret = nft_register_expr(&nft_match_type);
 	if (ret < 0)
-		goto err_pernet;
+		return ret;
 
 	ret = nft_register_expr(&nft_target_type);
 	if (ret < 0)
@@ -1034,8 +866,6 @@ err_target:
 	nft_unregister_expr(&nft_target_type);
 err_match:
 	nft_unregister_expr(&nft_match_type);
-err_pernet:
-	unregister_pernet_subsys(&nft_compat_net_ops);
 	return ret;
 }
 
@@ -1044,7 +874,6 @@ static void __exit nft_compat_module_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
-	unregister_pernet_subsys(&nft_compat_net_ops);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
-- 
2.19.1



