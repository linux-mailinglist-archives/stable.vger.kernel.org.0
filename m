Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5984D44008
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbfFMQCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:02:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731406AbfFMIrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9798F20851;
        Thu, 13 Jun 2019 08:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415672;
        bh=6AsnjSp4I8XPLFUdtj4253p9jBp5YwDl72Dnx/K14u0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10pfZn07hOgHGbiE3LLTnBgAxAr5vUoUeP6WP31MQvq2CQgXd1rSE1FEQ7MTNuRHH
         Og+CrBpye8N+c/u1/59rEKZ0RDe52UIffbXP2dA5BgwTi+0I1SAYsKdlKb+z0DzeZE
         mvywfJQ8FQlB2KTe3Yr3fanaDxbdvnJiLSOMr80M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 067/155] netfilter: nf_tables: fix base chain stat rcu_dereference usage
Date:   Thu, 13 Jun 2019 10:32:59 +0200
Message-Id: <20190613075656.746734042@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit edbd82c5fba009f68d20b5db585be1e667c605f6 ]

Following splat gets triggered when nfnetlink monitor is running while
xtables-nft selftests are running:

net/netfilter/nf_tables_api.c:1272 suspicious rcu_dereference_check() usage!
other info that might help us debug this:

1 lock held by xtables-nft-mul/27006:
 #0: 00000000e0f85be9 (&net->nft.commit_mutex){+.+.}, at: nf_tables_valid_genid+0x1a/0x50
Call Trace:
 nf_tables_fill_chain_info.isra.45+0x6cc/0x6e0
 nf_tables_chain_notify+0xf8/0x1a0
 nf_tables_commit+0x165c/0x1740

nf_tables_fill_chain_info() can be called both from dumps (rcu read locked)
or from the transaction path if a userspace process subscribed to nftables
notifications.

In the 'table dump' case, rcu_access_pointer() cannot be used: We do not
hold transaction mutex so the pointer can be NULLed right after the check.
Just unconditionally fetch the value, then have the helper return
immediately if its NULL.

In the notification case we don't hold the rcu read lock, but updates are
prevented due to transaction mutex. Use rcu_dereference_check() to make lockdep
aware of this.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1606eaa5ae0d..aa5e7b00a581 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1190,6 +1190,9 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
 	u64 pkts, bytes;
 	int cpu;
 
+	if (!stats)
+		return 0;
+
 	memset(&total, 0, sizeof(total));
 	for_each_possible_cpu(cpu) {
 		cpu_stats = per_cpu_ptr(stats, cpu);
@@ -1247,6 +1250,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	if (nft_is_base_chain(chain)) {
 		const struct nft_base_chain *basechain = nft_base_chain(chain);
 		const struct nf_hook_ops *ops = &basechain->ops;
+		struct nft_stats __percpu *stats;
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, NFTA_CHAIN_HOOK);
@@ -1268,8 +1272,9 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 		if (nla_put_string(skb, NFTA_CHAIN_TYPE, basechain->type->name))
 			goto nla_put_failure;
 
-		if (rcu_access_pointer(basechain->stats) &&
-		    nft_dump_stats(skb, rcu_dereference(basechain->stats)))
+		stats = rcu_dereference_check(basechain->stats,
+					      lockdep_commit_lock_is_held(net));
+		if (nft_dump_stats(skb, stats))
 			goto nla_put_failure;
 	}
 
-- 
2.20.1



