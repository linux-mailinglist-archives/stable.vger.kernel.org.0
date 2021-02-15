Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584931BCA0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhBOPcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:32:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhBOPbO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C97CC64E95;
        Mon, 15 Feb 2021 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402946;
        bh=KA+GgUN8BxJ+1IPKWYr3fbSEfwMSQZIHIY9T93JIjDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGftQL4X4sSFJkhUqLmHRF4JiE5CzZBSXLyWJDZlLEKvSEfIb6KMvBsXJijpiznbg
         zyivn6qavkHrPbrTEd3G/Ok4juuJri9B7JZyGkNSAINc4JJNTWdmzz8AxckNQPndIj
         QFZ2K5n/taScOuL1bQ1w6xwGLUCTxH/R6mTlj91w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/60] netfilter: nftables: fix possible UAF over chains from packet path in netns
Date:   Mon, 15 Feb 2021 16:27:18 +0100
Message-Id: <20210215152716.316351297@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 767d1216bff82507c945e92fe719dff2083bb2f4 ]

Although hooks are released via call_rcu(), chain and rule objects are
immediately released while packets are still walking over these bits.

This patch adds the .pre_exit callback which is invoked before
synchronize_rcu() in the netns framework to stay safe.

Remove a comment which is not valid anymore since the core does not use
synchronize_net() anymore since 8c873e219970 ("netfilter: core: free
hooks with call_rcu").

Suggested-by: Florian Westphal <fw@strlen.de>
Fixes: df05ef874b28 ("netfilter: nf_tables: release objects on netns destruction")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 40216c2a7dd72..373ea0e49f12d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7696,6 +7696,17 @@ int __nft_release_basechain(struct nft_ctx *ctx)
 }
 EXPORT_SYMBOL_GPL(__nft_release_basechain);
 
+static void __nft_release_hooks(struct net *net)
+{
+	struct nft_table *table;
+	struct nft_chain *chain;
+
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(chain, &table->chains, list)
+			nf_tables_unregister_hook(net, table, chain);
+	}
+}
+
 static void __nft_release_tables(struct net *net)
 {
 	struct nft_flowtable *flowtable, *nf;
@@ -7711,10 +7722,6 @@ static void __nft_release_tables(struct net *net)
 
 	list_for_each_entry_safe(table, nt, &net->nft.tables, list) {
 		ctx.family = table->family;
-
-		list_for_each_entry(chain, &table->chains, list)
-			nf_tables_unregister_hook(net, table, chain);
-		/* No packets are walking on these chains anymore. */
 		ctx.table = table;
 		list_for_each_entry(chain, &table->chains, list) {
 			ctx.chain = chain;
@@ -7762,6 +7769,11 @@ static int __net_init nf_tables_init_net(struct net *net)
 	return 0;
 }
 
+static void __net_exit nf_tables_pre_exit_net(struct net *net)
+{
+	__nft_release_hooks(net);
+}
+
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
@@ -7774,8 +7786,9 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 }
 
 static struct pernet_operations nf_tables_net_ops = {
-	.init	= nf_tables_init_net,
-	.exit	= nf_tables_exit_net,
+	.init		= nf_tables_init_net,
+	.pre_exit	= nf_tables_pre_exit_net,
+	.exit		= nf_tables_exit_net,
 };
 
 static int __init nf_tables_module_init(void)
-- 
2.27.0



