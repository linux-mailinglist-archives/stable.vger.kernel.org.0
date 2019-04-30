Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2FEF64B
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbfD3Lph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbfD3Lpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3701921734;
        Tue, 30 Apr 2019 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624734;
        bh=WEoNykjKP16+wiqfjPVOtjKo0wE9nl74bTXa3RVoVpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOwT5GQ416FWOvxTjqfS0r86P+AGj/0dTbUVmtBCM3BfTOOMbEpNcNFFONHJAE7w9
         r2e5eR0ipNB5/rMHKlBNrns185t20hMsFRnbawHobg+6CEVx/qPr2SOf1c/mFp/iTj
         hz0GicQqJGYSM+ER9dFLWU09zaLc2Lf4roVRo4fU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jordan Glover <Golden_Miller83@protonmail.ch>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 007/100] netfilter: nft_compat: dont use refcount_inc on newly allocated entry
Date:   Tue, 30 Apr 2019 13:37:36 +0200
Message-Id: <20190430113608.981840724@linuxfoundation.org>
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

[ Upstream commit 947e492c0fc2132ae5fca081a9c2952ccaab0404 ]

When I moved the refcount to refcount_t type I missed the fact that
refcount_inc() will result in use-after-free warning with
CONFIG_REFCOUNT_FULL=y builds.

The correct fix would be to init the reference count to 1 at allocation
time, but, unfortunately we cannot do this, as we can't undo that
in case something else fails later in the batch.

So only solution I see is to special-case the 'new entry' condition
and replace refcount_inc() with a "delayed" refcount_set(1) in this case,
as done here.

The .activate callback can be removed to simplify things, we only
need to make sure that deactivate() decrements/unlinks the entry
from the list at end of transaction phase (commit or abort).

Fixes: 12c44aba6618 ("netfilter: nft_compat: use refcnt_t type for nft_xt reference count")
Reported-by: Jordan Glover <Golden_Miller83@protonmail.ch>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 62 ++++++++++++++------------------------
 1 file changed, 23 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 12a95eec9565..859eb3e12ddf 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -61,6 +61,21 @@ static struct nft_compat_net *nft_compat_pernet(struct net *net)
 	return net_generic(net, nft_compat_net_id);
 }
 
+static void nft_xt_get(struct nft_xt *xt)
+{
+	/* refcount_inc() warns on 0 -> 1 transition, but we can't
+	 * init the reference count to 1 in .select_ops -- we can't
+	 * undo such an increase when another expression inside the same
+	 * rule fails afterwards.
+	 */
+	if (xt->listcnt == 0)
+		refcount_set(&xt->refcnt, 1);
+	else
+		refcount_inc(&xt->refcnt);
+
+	xt->listcnt++;
+}
+
 static bool nft_xt_put(struct nft_xt *xt)
 {
 	if (refcount_dec_and_test(&xt->refcnt)) {
@@ -291,7 +306,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	refcount_inc(&nft_xt->refcnt);
+	nft_xt_get(nft_xt);
 	return 0;
 }
 
@@ -486,7 +501,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return ret;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	refcount_inc(&nft_xt->refcnt);
+	nft_xt_get(nft_xt);
 	return 0;
 }
 
@@ -540,45 +555,16 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
 }
 
-static void nft_compat_activate(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				struct list_head *h)
-{
-	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
-
-	if (xt->listcnt == 0)
-		list_add(&xt->head, h);
-
-	xt->listcnt++;
-}
-
-static void nft_compat_activate_mt(const struct nft_ctx *ctx,
-				   const struct nft_expr *expr)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
-
-	nft_compat_activate(ctx, expr, &cn->nft_match_list);
-}
-
-static void nft_compat_activate_tg(const struct nft_ctx *ctx,
-				   const struct nft_expr *expr)
-{
-	struct nft_compat_net *cn = nft_compat_pernet(ctx->net);
-
-	nft_compat_activate(ctx, expr, &cn->nft_target_list);
-}
-
 static void nft_compat_deactivate(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr,
 				  enum nft_trans_phase phase)
 {
 	struct nft_xt *xt = container_of(expr->ops, struct nft_xt, ops);
 
-	if (phase == NFT_TRANS_COMMIT)
-		return;
-
-	if (--xt->listcnt == 0)
-		list_del_init(&xt->head);
+	if (phase == NFT_TRANS_ABORT || phase == NFT_TRANS_COMMIT) {
+		if (--xt->listcnt == 0)
+			list_del_init(&xt->head);
+	}
 }
 
 static void
@@ -833,7 +819,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
-	nft_match->ops.activate = nft_compat_activate_mt;
 	nft_match->ops.deactivate = nft_compat_deactivate;
 	nft_match->ops.dump = nft_match_dump;
 	nft_match->ops.validate = nft_match_validate;
@@ -851,7 +836,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.size = matchsize;
 
-	nft_match->listcnt = 1;
+	nft_match->listcnt = 0;
 	list_add(&nft_match->head, &cn->nft_match_list);
 
 	return &nft_match->ops;
@@ -938,7 +923,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
-	nft_target->ops.activate = nft_compat_activate_tg;
 	nft_target->ops.deactivate = nft_compat_deactivate;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
@@ -949,7 +933,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	else
 		nft_target->ops.eval = nft_target_eval_xt;
 
-	nft_target->listcnt = 1;
+	nft_target->listcnt = 0;
 	list_add(&nft_target->head, &cn->nft_target_list);
 
 	return &nft_target->ops;
-- 
2.19.1



