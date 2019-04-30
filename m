Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB50F7DB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfD3MC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 08:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729988AbfD3Lnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57FAE21707;
        Tue, 30 Apr 2019 11:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624619;
        bh=1rKjOyZV05Omol2gTCtEdosFT/zKB5T9AlPibSuWDqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S9p9bc4CX2247Ddt877sNuv55MUWPkLwdyjcDodSKCeBWF/r4fuJPVXLM1ZAUt4Ei
         dol5+ekXLzOhVJekqKB0ywYo15ekgwruhdZs5gpjUded6PKBxo4bq9XT+jWQ2GBebi
         VjavfWLHoiRQcL1oNPWy+IUCDiUnTZ/mWfkbZlAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 001/100] netfilter: nft_compat: use refcnt_t type for nft_xt reference count
Date:   Tue, 30 Apr 2019 13:37:30 +0200
Message-Id: <20190430113608.728252971@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
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

[ Upstream commit 12c44aba6618b7f6c437076e5722237190f6cd5f ]

Using standard integer type was fine while all operations on it were
guarded by the nftnl subsys mutex.

This isn't true anymore:
1. transactions are guarded only by a pernet mutex, so concurrent
   rule manipulation in different netns is racy
2. the ->destroy hook runs from a work queue after the transaction
   mutex has been released already.

cpu0                           cpu1 (net 1)        cpu2 (net 2)
 kworker
    nft_compat->destroy        nft_compat->init    nft_compat->init
      if (--nft_xt->ref == 0)   nft_xt->ref++        nft_xt->ref++

Switch to refcount_t.  Doing this however only fixes a minor aspect,
nft_compat also performs linked-list operations in an unsafe way.

This is addressed in the next two patches.

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
Fixes: 0935d5588400 ("netfilter: nf_tables: asynchronous release")
Reported-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 38da1f5436b4..24ec9552e126 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -26,7 +26,7 @@
 struct nft_xt {
 	struct list_head	head;
 	struct nft_expr_ops	ops;
-	unsigned int		refcnt;
+	refcount_t		refcnt;
 
 	/* Unlike other expressions, ops doesn't have static storage duration.
 	 * nft core assumes they do.  We use kfree_rcu so that nft core can
@@ -45,7 +45,7 @@ struct nft_xt_match_priv {
 
 static bool nft_xt_put(struct nft_xt *xt)
 {
-	if (--xt->refcnt == 0) {
+	if (refcount_dec_and_test(&xt->refcnt)) {
 		list_del(&xt->head);
 		kfree_rcu(xt, rcu_head);
 		return true;
@@ -273,7 +273,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return -EINVAL;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt->refcnt++;
+	refcount_inc(&nft_xt->refcnt);
 	return 0;
 }
 
@@ -468,7 +468,7 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		return ret;
 
 	nft_xt = container_of(expr->ops, struct nft_xt, ops);
-	nft_xt->refcnt++;
+	refcount_inc(&nft_xt->refcnt);
 	return 0;
 }
 
@@ -770,7 +770,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_match->refcnt = 0;
+	refcount_set(&nft_match->refcnt, 0);
 	nft_match->ops.type = &nft_match_type;
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
@@ -874,7 +874,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 		goto err;
 	}
 
-	nft_target->refcnt = 0;
+	refcount_set(&nft_target->refcnt, 0);
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	nft_target->ops.init = nft_target_init;
@@ -945,7 +945,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_target_list, head) {
 		struct xt_target *target = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(target->me);
 		kfree(xt);
@@ -954,7 +954,7 @@ static void __exit nft_compat_module_exit(void)
 	list_for_each_entry_safe(xt, next, &nft_match_list, head) {
 		struct xt_match *match = xt->ops.data;
 
-		if (WARN_ON_ONCE(xt->refcnt))
+		if (WARN_ON_ONCE(refcount_read(&xt->refcnt)))
 			continue;
 		module_put(match->me);
 		kfree(xt);
-- 
2.19.1



