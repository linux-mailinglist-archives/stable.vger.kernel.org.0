Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0174D6F8
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbfFTSOZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728962AbfFTSOY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65CEB205F4;
        Thu, 20 Jun 2019 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054463;
        bh=VqzwzHHbmfYIgfW2lSoHJXCgE3kN9UfqUcUCgn0i6Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgtF71D25WrlgNXTD+gBKNe0JL5CPy9Lpas3IBQDxO/Mbk99Kjg3VMU43vHeZQsZj
         0uy7VZkeqpYgUDFMtcqV6gUcwucjDkg0sAO65OU9nyxYtZVvS4jDlbhX9KewTESMBB
         gy5TB+wiboiPo8nvr49m3KJ1MYTqDRVAHY63GGEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 37/98] netfilter: nf_tables: fix oops during rule dump
Date:   Thu, 20 Jun 2019 19:57:04 +0200
Message-Id: <20190620174350.778751666@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2c82c7e724ff51cab78e1afd5c2aaa31994fe41e ]

We can oops in nf_tables_fill_rule_info().

Its not possible to fetch previous element in rcu-protected lists
when deletions are not prevented somehow: list_del_rcu poisons
the ->prev pointer value.

Before rcu-conversion this was safe as dump operations did hold
nfnetlink mutex.

Pass previous rule as argument, obtained by keeping a pointer to
the previous rule during traversal.

Fixes: d9adf22a291883 ("netfilter: nf_tables: use call_rcu in netlink dumps")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aa5e7b00a581..101975386547 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2261,13 +2261,13 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 				    u32 flags, int family,
 				    const struct nft_table *table,
 				    const struct nft_chain *chain,
-				    const struct nft_rule *rule)
+				    const struct nft_rule *rule,
+				    const struct nft_rule *prule)
 {
 	struct nlmsghdr *nlh;
 	struct nfgenmsg *nfmsg;
 	const struct nft_expr *expr, *next;
 	struct nlattr *list;
-	const struct nft_rule *prule;
 	u16 type = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(struct nfgenmsg), flags);
@@ -2287,8 +2287,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 			 NFTA_RULE_PAD))
 		goto nla_put_failure;
 
-	if ((event != NFT_MSG_DELRULE) && (rule->list.prev != &chain->rules)) {
-		prule = list_prev_entry(rule, list);
+	if (event != NFT_MSG_DELRULE && prule) {
 		if (nla_put_be64(skb, NFTA_RULE_POSITION,
 				 cpu_to_be64(prule->handle),
 				 NFTA_RULE_PAD))
@@ -2335,7 +2334,7 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, 0, ctx->family, ctx->table,
-				       ctx->chain, rule);
+				       ctx->chain, rule, NULL);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -2360,12 +2359,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 				  const struct nft_chain *chain)
 {
 	struct net *net = sock_net(skb->sk);
+	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
-	const struct nft_rule *rule;
 
+	prule = NULL;
 	list_for_each_entry_rcu(rule, &chain->rules, list) {
 		if (!nft_is_active(net, rule))
-			goto cont;
+			goto cont_skip;
 		if (*idx < s_idx)
 			goto cont;
 		if (*idx > s_idx) {
@@ -2377,11 +2377,13 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule) < 0)
+					table, chain, rule, prule) < 0)
 			return 1;
 
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
+		prule = rule;
+cont_skip:
 		(*idx)++;
 	}
 	return 0;
@@ -2537,7 +2539,7 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 
 	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
-				       family, table, chain, rule);
+				       family, table, chain, rule, NULL);
 	if (err < 0)
 		goto err;
 
-- 
2.20.1



