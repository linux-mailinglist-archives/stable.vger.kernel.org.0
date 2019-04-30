Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC26AF629
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbfD3Lnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:54394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730008AbfD3Lns (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2206C20449;
        Tue, 30 Apr 2019 11:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624627;
        bh=mcG4bxiT62agVN+/5uDUUQh3M/OB3bDp0haUKaJTbjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEuzhr4mKYSuwbsHkXwM6/vhnC2J8Qbzu+Q/s3Z1n2IXQazmRwdWWZjl4BvJBvY0q
         o11K8t31JztPAL7cdgg3KfO825ZlLSrFPnr6n+klzNjzL6P05BHpYF+oYQpl8nhx4L
         5SkMQgSwsYWZ+cLry1c8KBfsptzmP0r8dikox+EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 004/100] netfilter: nft_compat: destroy function must not have side effects
Date:   Tue, 30 Apr 2019 13:37:33 +0200
Message-Id: <20190430113608.853693719@linuxfoundation.org>
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

The nft_compat destroy function deletes the nft_xt object from a list.
This isn't allowed anymore. Destroy functions are called asynchronously,
i.e. next batch can find the object that has a pending ->destroy()
invocation:

cpu0                       cpu1
 worker
   ->destroy               for_each_entry()
	                     if (x == ...
			        return x->ops;
     list_del(x)
     kfree_rcu(x)
                           expr->ops->... // ops was free'd

To resolve this, the list_del needs to occur before the transaction
mutex gets released.  nf_tables has a 'deactivate' hook for this
purpose, so use that to unlink the object from the list.

Fixes: 0935d5588400 ("netfilter: nf_tables: asynchronous release")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 48 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 61c098555507..432139b7fa1f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -29,6 +29,9 @@ struct nft_xt {
 	struct nft_expr_ops	ops;
 	refcount_t		refcnt;
 
+	/* used only when transaction mutex is locked */
+	unsigned int		listcnt;
+
 	/* Unlike other expressions, ops doesn't have static storage duration.
 	 * nft core assumes they do.  We use kfree_rcu so that nft core can
 	 * can check expr->ops->size even after nft_compat->destroy() frees
@@ -61,7 +64,7 @@ static struct nft_compat_net *nft_compat_pernet(struct net *net)
 static bool nft_xt_put(struct nft_xt *xt)
 {
 	if (refcount_dec_and_test(&xt->refcnt)) {
-		list_del(&xt->head);
+		WARN_ON_ONCE(!list_empty(&xt->head));
 		kfree_rcu(xt, rcu_head);
 		return true;
 	}
@@ -537,6 +540,43 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
 }
 
+static void nft_compat_activate(const struct nft_ctx *ctx,
+				const struct nft_expr *expr,
+				struct list_head *h)
+{
+	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
+
+	if (xt->listcnt == 0)
+		list_add(&xt->head, h);
+
+	xt->listcnt++;
+}
+
+static void nft_compat_activate_mt(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
+
+	nft_compat_activate(ctx, expr, &cn->nft_match_list);
+}
+
+static void nft_compat_activate_tg(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr)
+{
+	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
+
+	nft_compat_activate(ctx, expr, &cn->nft_target_list);
+}
+
+static void nft_compat_deactivate(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
+
+	if (--xt->listcnt == 0)
+		list_del_init(&xt->head);
+}
+
 static void
 nft_match_large_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 {
@@ -789,6 +829,8 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
+	nft_match->ops.activate = nft_compat_activate_mt;
+	nft_match->ops.deactivate = nft_compat_deactivate;
 	nft_match->ops.dump = nft_match_dump;
 	nft_match->ops.validate = nft_match_validate;
 	nft_match->ops.data = match;
@@ -805,6 +847,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.size = matchsize;
 
+	nft_match->listcnt = 1;
 	list_add(&nft_match->head, &cn->nft_match_list);
 
 	return &nft_match->ops;
@@ -891,6 +934,8 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
+	nft_target->ops.activate = nft_compat_activate_tg;
+	nft_target->ops.deactivate = nft_compat_deactivate;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
 	nft_target->ops.data = target;
@@ -900,6 +945,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	else
 		nft_target->ops.eval = nft_target_eval_xt;
 
+	nft_target->listcnt = 1;
 	list_add(&nft_target->head, &cn->nft_target_list);
 
 	return &nft_target->ops;
-- 
2.19.1



