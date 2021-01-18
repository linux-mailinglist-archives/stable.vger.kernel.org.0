Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841692FA96D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 19:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407150AbhARS5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 13:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390463AbhARLk2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:40:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0911522227;
        Mon, 18 Jan 2021 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970012;
        bh=AMf2XduLJZ8mvuOmtjo4BzDeXKEJpnzlU7VH+CZ5sVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ni41QnSeeBtLk/pJzCjNoPOH7sa83evicJA2cwx/zUA38WQgE4r9fz0XpUaPXFvtb
         YRY7YsB77TKEolorcNp7IAcB7ukgurXESniTyanif+eyHEwGsTBsXKeJaW1bn7FOIB
         a1UrBujkbPCVT/2s2N6fVVq1XQ0DUHfua5/EWcs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 76/76] netfilter: nft_compat: remove flush counter optimization
Date:   Mon, 18 Jan 2021 12:35:16 +0100
Message-Id: <20210118113344.604874964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 2f941622fd88328ca75806c45c9e9709286a0609 upstream.

WARNING: CPU: 1 PID: 16059 at lib/refcount.c:31 refcount_warn_saturate+0xdf/0xf
[..]
 __nft_mt_tg_destroy+0x42/0x50 [nft_compat]
 nft_target_destroy+0x63/0x80 [nft_compat]
 nf_tables_expr_destroy+0x1b/0x30 [nf_tables]
 nf_tables_rule_destroy+0x3a/0x70 [nf_tables]
 nf_tables_exit_net+0x186/0x3d0 [nf_tables]

Happens when a compat expr is destoyed from abort path.
There is no functional impact; after this work queue is flushed
unconditionally if its pending.

This removes the waitcount optimization.  Test of repeated
iptables-restore of a ~60k kubernetes ruleset doesn't indicate
a slowdown.  In case the counter is needed after all for some workloads
we can revert this and increment the refcount for the
!= NFT_PREPARE_TRANS case to avoid the increment/decrement imbalance.

While at it, also flush for match case, this was an oversight
in the original patch.

Fixes: ffe8923f109b7e ("netfilter: nft_compat: make sure xtables destructors have run")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_compat.c |   37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -27,8 +27,6 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
-static refcount_t nft_compat_pending_destroy = REFCOUNT_INIT(1);
-
 static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 						const char *tablename)
 {
@@ -215,6 +213,17 @@ static int nft_parse_compat(const struct
 	return 0;
 }
 
+static void nft_compat_wait_for_destructors(void)
+{
+	/* xtables matches or targets can have side effects, e.g.
+	 * creation/destruction of /proc files.
+	 * The xt ->destroy functions are run asynchronously from
+	 * work queue.  If we have pending invocations we thus
+	 * need to wait for those to finish.
+	 */
+	nf_tables_trans_destroy_flush_work();
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -238,14 +247,7 @@ nft_target_init(const struct nft_ctx *ct
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	/* xtables matches or targets can have side effects, e.g.
-	 * creation/destruction of /proc files.
-	 * The xt ->destroy functions are run asynchronously from
-	 * work queue.  If we have pending invocations we thus
-	 * need to wait for those to finish.
-	 */
-	if (refcount_read(&nft_compat_pending_destroy) > 1)
-		nf_tables_trans_destroy_flush_work();
+	nft_compat_wait_for_destructors();
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
@@ -260,7 +262,6 @@ nft_target_init(const struct nft_ctx *ct
 
 static void __nft_mt_tg_destroy(struct module *me, const struct nft_expr *expr)
 {
-	refcount_dec(&nft_compat_pending_destroy);
 	module_put(me);
 	kfree(expr->ops);
 }
@@ -468,6 +469,8 @@ __nft_match_init(const struct nft_ctx *c
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
+	nft_compat_wait_for_destructors();
+
 	return xt_check_match(&par, size, proto, inv);
 }
 
@@ -716,14 +719,6 @@ static const struct nfnetlink_subsystem
 
 static struct nft_expr_type nft_match_type;
 
-static void nft_mt_tg_deactivate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 enum nft_trans_phase phase)
-{
-	if (phase == NFT_TRANS_COMMIT)
-		refcount_inc(&nft_compat_pending_destroy);
-}
-
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -762,7 +757,6 @@ nft_match_select_ops(const struct nft_ct
 	ops->type = &nft_match_type;
 	ops->eval = nft_match_eval;
 	ops->init = nft_match_init;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->destroy = nft_match_destroy;
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
@@ -853,7 +847,6 @@ nft_target_select_ops(const struct nft_c
 	ops->size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
@@ -917,8 +910,6 @@ static void __exit nft_compat_module_exi
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
-
-	WARN_ON_ONCE(refcount_read(&nft_compat_pending_destroy) != 1);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);


