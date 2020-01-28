Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F7014B690
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgA1OFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:05:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:52846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbgA1OFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:18 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 539D2205F4;
        Tue, 28 Jan 2020 14:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220317;
        bh=WeNql1s/ZBtGz1k+khlE3jvxSB8QCjuTQmpdKQrKDUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmz8Dr+xZCMkywMeSu6uDUYxVsN6HZA316HW8FIYRSHPIdMLxSu1xRDh7+EnZXMOE
         tVLtEeUCd/MdSzqSCHaV2kpZNlqRaqLQ5D5aLi0w9NPjjsXpKVySptZTxm+iwnIvWl
         42j7bSMlXVV5RrnQOs+TPnP062jg12u/2Tljjj1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+29125d208b3dae9a7019@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 103/104] netfilter: nf_tables: autoload modules from the abort path
Date:   Tue, 28 Jan 2020 15:01:04 +0100
Message-Id: <20200128135831.129806684@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit eb014de4fd418de1a277913cba244e47274fe392 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/netfilter/nfnetlink.h |    2 
 include/net/netns/nftables.h        |    1 
 net/netfilter/nf_tables_api.c       |  126 ++++++++++++++++++++++++------------
 net/netfilter/nfnetlink.c           |    6 -
 4 files changed, 91 insertions(+), 44 deletions(-)

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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -514,35 +514,45 @@ __nf_tables_chain_type_lookup(const stru
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
 
@@ -566,10 +576,9 @@ nf_tables_chain_type_lookup(struct net *
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
@@ -2073,9 +2082,8 @@ static const struct nft_expr_type *__nft
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
@@ -2101,9 +2109,9 @@ static const struct nft_expr_type *nft_e
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
@@ -2194,9 +2202,10 @@ static int nf_tables_expr_parse(const st
 			err = PTR_ERR(ops);
 #ifdef CONFIG_MODULES
 			if (err == -EAGAIN)
-				nft_expr_type_request_module(ctx->net,
-							     ctx->family,
-							     tb[NFTA_EXPR_NAME]);
+				if (nft_expr_type_request_module(ctx->net,
+								 ctx->family,
+								 tb[NFTA_EXPR_NAME]) != -EAGAIN)
+					err = -ENOENT;
 #endif
 			goto err1;
 		}
@@ -3033,8 +3042,7 @@ nft_select_set_ops(const struct nft_ctx
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (list_empty(&nf_tables_set_types)) {
-		nft_request_module(ctx->net, "nft-set");
-		if (!list_empty(&nf_tables_set_types))
+		if (nft_request_module(ctx->net, "nft-set") == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -5160,8 +5168,7 @@ nft_obj_type_get(struct net *net, u32 ob
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nft-obj-%u", objtype);
-		if (__nft_obj_type_get(objtype))
+		if (nft_request_module(net, "nft-obj-%u", objtype) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -5777,8 +5784,7 @@ nft_flowtable_type_get(struct net *net,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nf-flowtable-%u", family);
-		if (__nft_flowtable_type_get(family))
+		if (nft_request_module(net, "nf-flowtable-%u", family) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -6725,6 +6731,18 @@ static void nft_chain_del(struct nft_cha
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
@@ -6737,6 +6755,7 @@ static void nf_tables_commit_release(str
 	 * to prevent expensive synchronize_rcu() in commit phase.
 	 */
 	if (list_empty(&net->nft.commit_list)) {
+		nf_tables_module_autoload_cleanup(net);
 		mutex_unlock(&net->nft.commit_mutex);
 		return;
 	}
@@ -6751,6 +6770,7 @@ static void nf_tables_commit_release(str
 	list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
+	nf_tables_module_autoload_cleanup(net);
 	mutex_unlock(&net->nft.commit_mutex);
 
 	schedule_work(&trans_destroy_work);
@@ -6942,6 +6962,26 @@ static int nf_tables_commit(struct net *
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
@@ -6971,7 +7011,7 @@ static void nf_tables_abort_release(stru
 	kfree(trans);
 }
 
-static int __nf_tables_abort(struct net *net)
+static int __nf_tables_abort(struct net *net, bool autoload)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
@@ -7093,6 +7133,11 @@ static int __nf_tables_abort(struct net
 		nf_tables_abort_release(trans);
 	}
 
+	if (autoload)
+		nf_tables_module_autoload(net);
+	else
+		nf_tables_module_autoload_cleanup(net);
+
 	return 0;
 }
 
@@ -7101,9 +7146,9 @@ static void nf_tables_cleanup(struct net
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
 {
-	int ret = __nf_tables_abort(net);
+	int ret = __nf_tables_abort(net, autoload);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -7698,6 +7743,7 @@ static int __net_init nf_tables_init_net
 {
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
+	INIT_LIST_HEAD(&net->nft.module_list);
 	mutex_init(&net->nft.commit_mutex);
 	net->nft.base_seq = 1;
 	net->nft.validate_state = NFT_VALIDATE_SKIP;
@@ -7709,7 +7755,7 @@ static void __net_exit nf_tables_exit_ne
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net);
+		__nf_tables_abort(net, false);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -476,7 +476,7 @@ ack:
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb);
+		ss->abort(net, oskb, true);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -487,11 +487,11 @@ done:
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


