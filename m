Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7CE2E64B1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632981AbgL1PwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391199AbgL1NiE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0637321D94;
        Mon, 28 Dec 2020 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162643;
        bh=pWFcgJnEpPRBx3+LSSh3e7Tj68NxMszCxzBSFJwjvT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+cCtl0L1F2sWsNWtnx21OcrphCQNlaXWSWDER0Icpijhc+oGNFUBQdM1kNXNVgBy
         23Lb8zuY4iOzIhCZiLJ1bs14XVp0yybfL1WQbiybVKK7ALuWHz78dopfe2Xoyp7HOl
         36CPDoyTx9VllpsLxCdKeIKVoFfb7Az0YZC8MszY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/453] netfilter: nft_compat: make sure xtables destructors have run
Date:   Mon, 28 Dec 2020 13:44:19 +0100
Message-Id: <20201228124938.370882595@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ffe8923f109b7ea92c0842c89e61300eefa11c94 ]

Pablo Neira found that after recent update of xt_IDLETIMER the
iptables-nft tests sometimes show an error.

He tracked this down to the delayed cleanup used by nf_tables core:
del rule (transaction A)
add rule (transaction B)

Its possible that by time transaction B (both in same netns) runs,
the xt target destructor has not been invoked yet.

For native nft expressions this is no problem because all expressions
that have such side effects make sure these are handled from the commit
phase, rather than async cleanup.

For nft_compat however this isn't true.

Instead of forcing synchronous behaviour for nft_compat, keep track
of the number of outstanding destructor calls.

When we attempt to create a new expression, flush the cleanup worker
to make sure destructors have completed.

With lots of help from Pablo Neira.

Reported-by: Pablo Neira Ayso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++--
 net/netfilter/nft_compat.c        | 36 +++++++++++++++++++++++++++----
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index a576bcbba2fcc..6a6fcd10d3185 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1462,4 +1462,6 @@ void nft_chain_filter_fini(void);
 
 void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
+
+void nf_tables_trans_destroy_flush_work(void);
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 459b7c0547115..7753d6f1467c9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6605,6 +6605,12 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	}
 }
 
+void nf_tables_trans_destroy_flush_work(void)
+{
+	flush_work(&trans_destroy_work);
+}
+EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
+
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
 	struct nft_rule *rule;
@@ -6776,9 +6782,9 @@ static void nf_tables_commit_release(struct net *net)
 	spin_unlock(&nf_tables_destroy_list_lock);
 
 	nf_tables_module_autoload_cleanup(net);
-	mutex_unlock(&net->nft.commit_mutex);
-
 	schedule_work(&trans_destroy_work);
+
+	mutex_unlock(&net->nft.commit_mutex);
 }
 
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f9adca62ccb3d..0e3e0ff805812 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -27,6 +27,8 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
+static refcount_t nft_compat_pending_destroy = REFCOUNT_INIT(1);
+
 static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 						const char *tablename)
 {
@@ -236,6 +238,15 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
+	/* xtables matches or targets can have side effects, e.g.
+	 * creation/destruction of /proc files.
+	 * The xt ->destroy functions are run asynchronously from
+	 * work queue.  If we have pending invocations we thus
+	 * need to wait for those to finish.
+	 */
+	if (refcount_read(&nft_compat_pending_destroy) > 1)
+		nf_tables_trans_destroy_flush_work();
+
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
 		return ret;
@@ -247,6 +258,13 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return 0;
 }
 
+static void __nft_mt_tg_destroy(struct module *me, const struct nft_expr *expr)
+{
+	refcount_dec(&nft_compat_pending_destroy);
+	module_put(me);
+	kfree(expr->ops);
+}
+
 static void
 nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -262,8 +280,7 @@ nft_target_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 
-	module_put(me);
-	kfree(expr->ops);
+	__nft_mt_tg_destroy(me, expr);
 }
 
 static int nft_extension_dump_info(struct sk_buff *skb, int attr,
@@ -494,8 +511,7 @@ __nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 
-	module_put(me);
-	kfree(expr->ops);
+	__nft_mt_tg_destroy(me, expr);
 }
 
 static void
@@ -700,6 +716,14 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
+static void nft_mt_tg_deactivate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 enum nft_trans_phase phase)
+{
+	if (phase == NFT_TRANS_COMMIT)
+		refcount_inc(&nft_compat_pending_destroy);
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -738,6 +762,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->type = &nft_match_type;
 	ops->eval = nft_match_eval;
 	ops->init = nft_match_init;
+	ops->deactivate = nft_mt_tg_deactivate,
 	ops->destroy = nft_match_destroy;
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
@@ -828,6 +853,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
+	ops->deactivate = nft_mt_tg_deactivate,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
@@ -891,6 +917,8 @@ static void __exit nft_compat_module_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
+
+	WARN_ON_ONCE(refcount_read(&nft_compat_pending_destroy) != 1);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
-- 
2.27.0



