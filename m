Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1881948B13E
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbiAKPs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:48:26 -0500
Received: from esa4.mentor.iphmx.com ([68.232.137.252]:56495 "EHLO
        esa4.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235534AbiAKPsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:48:25 -0500
IronPort-SDR: dvF1XLIoDnn5O/Lt1KoyRfp7+jWLpwiM0/dbM1vcva2iMBOUDmflndz2sp4FNffjSL+wB9xfQ0
 xkKFDcxpgJBJMoV5JoeC50Vkm6Ml/tb1jC43i32Pc87+7uqF1+5vqHJrgxJEmc9gL3HXMzys+2
 SoJcROpHN85EEe6aEdOoUydBWsvgMSVV0BKhH6uE9rHL6FUcRlTaTI3XYAjzaXfpxx8VDJ8/EU
 TaDFdCOk5w2bK14bBzPiLdZz6WrN6mySibUMM0u/B1SFCGVgUI+KGO0sqR1SOJTvheUhGSbjJH
 GFylseumA6oP3078WHLjcDvM
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208,223";a="70628400"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa4.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:41:18 -0800
IronPort-SDR: uIxNMt/0uipKpyzBRzTGYrcrUy4loNYl0c2q/ZIrzFWsJGg85BQuwwI8OkAEIocgNckDh7pvdn
 ldQB5xEH6fsi2OXXLYaYmBPRE3hUqdgKZpugl6HsRbLvv3AkEzE875TN59UFulSnTTuTcl/XHW
 Jt7mc3xXBTtWLCiScyTmhtwg4MFZBa7HdiGELDjSkY4JEWhCPc5XVkdmSpsrHgoMvvlHCC14YY
 Ql8B0P5XnV1qLELA8Cg85iAlnbwed4evpLDz6mowjhNaFf6ztNvw6B7Xczhd5t9CeDMWPM2avS
 Wvs=
Date:   Tue, 11 Jan 2022 10:41:13 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: Re: [PATCH 4.19 stable 3/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2lGfIuNxAO4Cn6@cat>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
X-ClientProxiedBy: svr-orw-mbx-10.mgc.mentorg.com (147.34.90.210) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From 5a9ec0a60c682805ceb0cca413d355f75c74b9ba Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 21 Jan 2020 16:48:03 +0100
Subject: [PATCH 3/5] netfilter: nf_tables: autoload modules from the abort
 path

This patch introduces a list of pending module requests. This new module
list is composed of nft_module_request objects that contain the module
name and one status field that tells if the module has been already
loaded (the 'done' field).

In the first pass, from the preparation phase, the netlink command finds
that a module is missing on this list. Then, a module request is
allocated and added to this list and nft_request_module() returns
-EAGAIN. This triggers the abort path with the autoload parameter set on
from nfnetlink, request_module() is called and the module request enters
the 'done' state. Since the mutex is released when loading modules from
the abort phase, the module list is zapped so this is iteration occurs
over a local list. Therefore, the request_module() calls happen when
object lists are in consistent state (after fulling aborting the
transaction) and the commit list is empty.

On the second pass, the netlink command will find that it already tried
to load the module, so it does not request it again and
nft_request_module() returns 0. Then, there is a look up to find the
object that the command was missing. If the module was successfully
loaded, the command proceeds normally since it finds the missing object
in place, otherwise -ENOENT is reported to userspace.

This patch also updates nfnetlink to include the reason to enter the
abort phase, which is required for this new autoload module rationale.

Fixes: ec7470b834fe ("netfilter: nf_tables: store transaction list locally while requesting module")
Reported-by: syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit eb014de4fd418de1a277913cba244e47274fe392)
---
 include/linux/netfilter/nfnetlink.h |   2 +-
 include/net/netns/nftables.h        |   1 +
 net/netfilter/nf_tables_api.c       | 126 ++++++++++++++++++++--------
 net/netfilter/nfnetlink.c           |   6 +-
 4 files changed, 94 insertions(+), 41 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index e713476ff29d..89016d08f6a2 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -31,7 +31,7 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	struct module *owner;
 	int (*commit)(struct net *net, struct sk_buff *skb);
-	int (*abort)(struct net *net, struct sk_buff *skb);
+	int (*abort)(struct net *net, struct sk_buff *skb, bool autoload);
 	void (*cleanup)(struct net *net);
 	bool (*valid_genid)(struct net *net, u32 genid);
 };
diff --git a/include/net/netns/nftables.h b/include/net/netns/nftables.h
index 286fd960896f..a1a8d45adb42 100644
--- a/include/net/netns/nftables.h
+++ b/include/net/netns/nftables.h
@@ -7,6 +7,7 @@
 struct netns_nftables {
 	struct list_head	tables;
 	struct list_head	commit_list;
+	struct list_head	module_list;
 	struct mutex		commit_mutex;
 	unsigned int		base_seq;
 	u8			gencursor;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ec38de1f7a1..6329d23c8b35 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -501,35 +501,45 @@ __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 	return NULL;
 }
 
-/*
- * Loading a module requires dropping mutex that guards the transaction.
- * A different client might race to start a new transaction meanwhile. Zap the
- * list of pending transaction and then restore it once the mutex is grabbed
- * again. Users of this function return EAGAIN which implicitly triggers the
- * transaction abort path to clean up the list of pending transactions.
- */
+struct nft_module_request {
+	struct list_head	list;
+	char			module[MODULE_NAME_LEN];
+	bool			done;
+};
+
 #ifdef CONFIG_MODULES
-static void nft_request_module(struct net *net, const char *fmt, ...)
+static int nft_request_module(struct net *net, const char *fmt, ...)
 {
 	char module_name[MODULE_NAME_LEN];
-	LIST_HEAD(commit_list);
+	struct nft_module_request *req;
 	va_list args;
 	int ret;
 
-	list_splice_init(&net->nft.commit_list, &commit_list);
-
 	va_start(args, fmt);
 	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
 	va_end(args);
 	if (ret >= MODULE_NAME_LEN)
-		return;
+		return 0;
 
-	mutex_unlock(&net->nft.commit_mutex);
-	request_module("%s", module_name);
-	mutex_lock(&net->nft.commit_mutex);
+	list_for_each_entry(req, &net->nft.module_list, list) {
+		if (!strcmp(req->module, module_name)) {
+			if (req->done)
+				return 0;
 
-	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
-	list_splice(&commit_list, &net->nft.commit_list);
+			/* A request to load this module already exists. */
+			return -EAGAIN;
+		}
+	}
+
+	req = kmalloc(sizeof(*req), GFP_KERNEL);
+	if (!req)
+		return -ENOMEM;
+
+	req->done = false;
+	strlcpy(req->module, module_name, MODULE_NAME_LEN);
+	list_add_tail(&req->list, &net->nft.module_list);
+
+	return -EAGAIN;
 }
 #endif
 
@@ -554,10 +564,9 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (autoload) {
-		nft_request_module(net, "nft-chain-%u-%.*s", family,
-				   nla_len(nla), (const char *)nla_data(nla));
-		type = __nf_tables_chain_type_lookup(nla, family);
-		if (type != NULL)
+		if (nft_request_module(net, "nft-chain-%u-%.*s", family,
+				       nla_len(nla),
+				       (const char *)nla_data(nla)) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -2013,9 +2022,8 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 static int nft_expr_type_request_module(struct net *net, u8 family,
 					struct nlattr *nla)
 {
-	nft_request_module(net, "nft-expr-%u-%.*s", family,
-			   nla_len(nla), (char *)nla_data(nla));
-	if (__nft_expr_type_get(family, nla))
+	if (nft_request_module(net, "nft-expr-%u-%.*s", family,
+			       nla_len(nla), (char *)nla_data(nla)) == -EAGAIN)
 		return -EAGAIN;
 
 	return 0;
@@ -2041,9 +2049,9 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
 		if (nft_expr_type_request_module(net, family, nla) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 
-		nft_request_module(net, "nft-expr-%.*s",
-				   nla_len(nla), (char *)nla_data(nla));
-		if (__nft_expr_type_get(family, nla))
+		if (nft_request_module(net, "nft-expr-%.*s",
+				       nla_len(nla),
+				       (char *)nla_data(nla)) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -2129,6 +2137,13 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 				       (const struct nlattr * const *)info->tb);
 		if (IS_ERR(ops)) {
 			err = PTR_ERR(ops);
+#ifdef CONFIG_MODULES
+			if (err == -EAGAIN)
+				if (nft_expr_type_request_module(ctx->net,
+								 ctx->family,
+								 tb[NFTA_EXPR_NAME]) != -EAGAIN)
+					err = -ENOENT;
+#endif
 			goto err1;
 		}
 	} else
@@ -2910,8 +2925,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (list_empty(&nf_tables_set_types)) {
-		nft_request_module(ctx->net, "nft-set");
-		if (!list_empty(&nf_tables_set_types))
+		if (nft_request_module(ctx->net, "nft-set") == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -5003,8 +5017,7 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nft-obj-%u", objtype);
-		if (__nft_obj_type_get(objtype))
+		if (nft_request_module(net, "nft-obj-%u", objtype) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -5558,8 +5571,7 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nf-flowtable-%u", family);
-		if (__nft_flowtable_type_get(family))
+		if (nft_request_module(net, "nf-flowtable-%u", family) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -6466,6 +6478,18 @@ static void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
+static void nf_tables_module_autoload_cleanup(struct net *net)
+{
+	struct nft_module_request *req, *next;
+
+	WARN_ON_ONCE(!list_empty(&net->nft.commit_list));
+	list_for_each_entry_safe(req, next, &net->nft.module_list, list) {
+		WARN_ON_ONCE(!req->done);
+		list_del(&req->list);
+		kfree(req);
+	}
+}
+
 static void nf_tables_commit_release(struct net *net)
 {
 	struct nft_trans *trans;
@@ -6478,6 +6502,7 @@ static void nf_tables_commit_release(struct net *net)
 	 * to prevent expensive synchronize_rcu() in commit phase.
 	 */
 	if (list_empty(&net->nft.commit_list)) {
+		nf_tables_module_autoload_cleanup(net);
 		mutex_unlock(&net->nft.commit_mutex);
 		return;
 	}
@@ -6492,6 +6517,7 @@ static void nf_tables_commit_release(struct net *net)
 	list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
+	nf_tables_module_autoload_cleanup(net);
 	mutex_unlock(&net->nft.commit_mutex);
 
 	schedule_work(&trans_destroy_work);
@@ -6664,6 +6690,26 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+static void nf_tables_module_autoload(struct net *net)
+{
+	struct nft_module_request *req, *next;
+	LIST_HEAD(module_list);
+
+	list_splice_init(&net->nft.module_list, &module_list);
+	mutex_unlock(&net->nft.commit_mutex);
+	list_for_each_entry_safe(req, next, &module_list, list) {
+		if (req->done) {
+			list_del(&req->list);
+			kfree(req);
+		} else {
+			request_module("%s", req->module);
+			req->done = true;
+		}
+	}
+	mutex_lock(&net->nft.commit_mutex);
+	list_splice(&module_list, &net->nft.module_list);
+}
+
 static void nf_tables_abort_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -6693,7 +6739,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int __nf_tables_abort(struct net *net)
+static int __nf_tables_abort(struct net *net, bool autoload)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
@@ -6810,6 +6856,11 @@ static int __nf_tables_abort(struct net *net)
 		nf_tables_abort_release(trans);
 	}
 
+	if (autoload)
+		nf_tables_module_autoload(net);
+	else
+		nf_tables_module_autoload_cleanup(net);
+
 	return 0;
 }
 
@@ -6818,9 +6869,9 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
 {
-	int ret = __nf_tables_abort(net);
+	int ret = __nf_tables_abort(net, autoload);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -7414,6 +7465,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
+	INIT_LIST_HEAD(&net->nft.module_list);
 	mutex_init(&net->nft.commit_mutex);
 	net->nft.base_seq = 1;
 	net->nft.validate_state = NFT_VALIDATE_SKIP;
@@ -7425,7 +7477,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net);
+		__nf_tables_abort(net, false);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 9bacddc761ba..7454f135e19d 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -478,7 +478,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb);
+		ss->abort(net, oskb, true);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -489,11 +489,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			status |= NFNL_BATCH_REPLAY;
 			goto done;
 		} else if (err) {
-			ss->abort(net, oskb);
+			ss->abort(net, oskb, false);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		}
 	} else {
-		ss->abort(net, oskb);
+		ss->abort(net, oskb, false);
 	}
 	if (ss->cleanup)
 		ss->cleanup(net);
-- 
2.34.1

