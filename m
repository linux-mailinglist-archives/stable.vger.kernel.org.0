Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8783014B19B
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgA1JLr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:11:47 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53327 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgA1JLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:11:47 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id BF1C0601;
        Tue, 28 Jan 2020 04:11:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 28 Jan 2020 04:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=n3SfAa
        e+Q3L9AmHFMjR4QLeNcxGqS/eeSE6rKoz0jIU=; b=m4UcTCkqCAHF51Mb9sLJTV
        79iVEkYqojga2yKPWhawiPhz5EaLk5QP6hhHlrvQn5XGth2FPf5AcpF7Kdd4cHdi
        ZyALtCYUvCI7Ig78VkzifORF+PWSrnQEtmj1Z/8RAfk0782FVagLIyAXUT2trx2O
        enGotUHGO05q63huFAYRUHoAat4a2lgz169X2tBToU6YliRsOPMZV10yA2lBcA0j
        jGV8vn3bBEqYuqVfrbZgH+zDN9zeWJJI8cN8G6fEgoeBCkbDw7TfXuF/Y7tzNYbn
        wg8hWAEKjlystqt7cUuLrPDzV7TNekvFUlvlrC00871/d8bH1s8wa8qcAPzkdMRA
        ==
X-ME-Sender: <xms:0fovXgz8tkKVLp0PYDxcenw5kUfiNNyohsIRL26oTGYwTnVXXSlaJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    kfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0fovXixDAR-xZReE5LpK4QKM-42guvWaWis_7ANYmEb-BU2O4bCY2w>
    <xmx:0fovXtJI423p9ifI0IgY_3XwEGK5qq5_ON-tG3u890FV2cSgQkta4g>
    <xmx:0fovXks5QSB_XCr_V1fBBP4WC2yH1-vM7t4xp1Ea_a6Yh3Cf2U9y_g>
    <xmx:0fovXgTHiDhXRk-UbccR9eGPZ3ujtbbon10GKs-EAeDd5YIJk9PK7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B724C328005D;
        Tue, 28 Jan 2020 04:11:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: autoload modules from the abort path" failed to apply to 4.19-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Jan 2020 10:11:43 +0100
Message-ID: <1580202703221189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eb014de4fd418de1a277913cba244e47274fe392 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 21 Jan 2020 16:48:03 +0100
Subject: [PATCH] netfilter: nf_tables: autoload modules from the abort path

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

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index cf09ab37b45b..851425c3178f 100644
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
index 4aa01c1253b1..7e63b481cc86 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -578,35 +578,45 @@ __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
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
 
@@ -630,10 +640,9 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
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
@@ -2341,9 +2350,8 @@ static const struct nft_expr_type *__nft_expr_type_get(u8 family,
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
@@ -2369,9 +2377,9 @@ static const struct nft_expr_type *nft_expr_type_get(struct net *net,
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
@@ -2462,9 +2470,10 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
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
@@ -3301,8 +3310,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (list_empty(&nf_tables_set_types)) {
-		nft_request_module(ctx->net, "nft-set");
-		if (!list_empty(&nf_tables_set_types))
+		if (nft_request_module(ctx->net, "nft-set") == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -5428,8 +5436,7 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nft-obj-%u", objtype);
-		if (__nft_obj_type_get(objtype))
+		if (nft_request_module(net, "nft-obj-%u", objtype) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -6002,8 +6009,7 @@ nft_flowtable_type_get(struct net *net, u8 family)
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
 	if (type == NULL) {
-		nft_request_module(net, "nf-flowtable-%u", family);
-		if (__nft_flowtable_type_get(family))
+		if (nft_request_module(net, "nf-flowtable-%u", family) == -EAGAIN)
 			return ERR_PTR(-EAGAIN);
 	}
 #endif
@@ -7005,6 +7011,18 @@ static void nft_chain_del(struct nft_chain *chain)
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
@@ -7017,6 +7035,7 @@ static void nf_tables_commit_release(struct net *net)
 	 * to prevent expensive synchronize_rcu() in commit phase.
 	 */
 	if (list_empty(&net->nft.commit_list)) {
+		nf_tables_module_autoload_cleanup(net);
 		mutex_unlock(&net->nft.commit_mutex);
 		return;
 	}
@@ -7031,6 +7050,7 @@ static void nf_tables_commit_release(struct net *net)
 	list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
 	spin_unlock(&nf_tables_destroy_list_lock);
 
+	nf_tables_module_autoload_cleanup(net);
 	mutex_unlock(&net->nft.commit_mutex);
 
 	schedule_work(&trans_destroy_work);
@@ -7222,6 +7242,26 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -7251,7 +7291,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int __nf_tables_abort(struct net *net)
+static int __nf_tables_abort(struct net *net, bool autoload)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
@@ -7373,6 +7413,11 @@ static int __nf_tables_abort(struct net *net)
 		nf_tables_abort_release(trans);
 	}
 
+	if (autoload)
+		nf_tables_module_autoload(net);
+	else
+		nf_tables_module_autoload_cleanup(net);
+
 	return 0;
 }
 
@@ -7381,9 +7426,9 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
 {
-	int ret = __nf_tables_abort(net);
+	int ret = __nf_tables_abort(net, autoload);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -7978,6 +8023,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.tables);
 	INIT_LIST_HEAD(&net->nft.commit_list);
+	INIT_LIST_HEAD(&net->nft.module_list);
 	mutex_init(&net->nft.commit_mutex);
 	net->nft.base_seq = 1;
 	net->nft.validate_state = NFT_VALIDATE_SKIP;
@@ -7989,7 +8035,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net);
+		__nf_tables_abort(net, false);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abbb452cf6c..99127e2d95a8 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -476,7 +476,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb);
+		ss->abort(net, oskb, true);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -487,11 +487,11 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
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

