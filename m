Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D711420F8B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhJDNfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhJDNdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66CC063233;
        Mon,  4 Oct 2021 13:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353330;
        bh=u6dkUD6+qi1YlkLMdVQi8ezQWVKe0Lra1exI6z3j9xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaU08Fb2/jVtGGCIutW3kqX/4yRJhoR2VOKWhh21Hn8kIlhS2vsw+8QyX6nxVnbFJ
         LtUGY7V0ikS9+04hwN1MNLPzKhn+TERx16cP5jH5lnPQXIPBA+fBbtTM6200kEJRAe
         pWNFXml+q2xtv48Gc4W3Ki9G9BA5KLlwBYhiPelA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Subject: [PATCH 5.14 086/172] netfilter: nf_tables: unlink table before deleting it
Date:   Mon,  4 Oct 2021 14:52:16 +0200
Message-Id: <20211004125047.765328694@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a499b03bf36b0c2e3b958a381d828678ab0ffc5e ]

syzbot reports following UAF:
BUG: KASAN: use-after-free in memcmp+0x18f/0x1c0 lib/string.c:955
 nla_strcmp+0xf2/0x130 lib/nlattr.c:836
 nft_table_lookup.part.0+0x1a2/0x460 net/netfilter/nf_tables_api.c:570
 nft_table_lookup net/netfilter/nf_tables_api.c:4064 [inline]
 nf_tables_getset+0x1b3/0x860 net/netfilter/nf_tables_api.c:4064
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504

Problem is that all get operations are lockless, so the commit_mutex
held by nft_rcv_nl_event() isn't enough to stop a parallel GET request
from doing read-accesses to the table object even after synchronize_rcu().

To avoid this, unlink the table first and store the table objects in
on-stack scratch space.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Reported-and-tested-by: syzbot+f31660cf279b0557160c@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 081437dd75b7..33e771cd847c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9599,7 +9599,6 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 		table->use--;
 		nf_tables_chain_destroy(&ctx);
 	}
-	list_del(&table->list);
 	nf_tables_table_destroy(&ctx);
 }
 
@@ -9612,6 +9611,8 @@ static void __nft_release_tables(struct net *net)
 		if (nft_table_has_owner(table))
 			continue;
 
+		list_del(&table->list);
+
 		__nft_release_table(net, table);
 	}
 }
@@ -9619,31 +9620,38 @@ static void __nft_release_tables(struct net *net)
 static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 			    void *ptr)
 {
+	struct nft_table *table, *to_delete[8];
 	struct nftables_pernet *nft_net;
 	struct netlink_notify *n = ptr;
-	struct nft_table *table, *nt;
 	struct net *net = n->net;
-	bool release = false;
+	unsigned int deleted;
+	bool restart = false;
 
 	if (event != NETLINK_URELEASE || n->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(net);
+	deleted = 0;
 	mutex_lock(&nft_net->commit_mutex);
+again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
 			__nft_release_hook(net, table);
-			release = true;
+			list_del_rcu(&table->list);
+			to_delete[deleted++] = table;
+			if (deleted >= ARRAY_SIZE(to_delete))
+				break;
 		}
 	}
-	if (release) {
+	if (deleted) {
+		restart = deleted >= ARRAY_SIZE(to_delete);
 		synchronize_rcu();
-		list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
-			if (nft_table_has_owner(table) &&
-			    n->portid == table->nlpid)
-				__nft_release_table(net, table);
-		}
+		while (deleted)
+			__nft_release_table(net, to_delete[--deleted]);
+
+		if (restart)
+			goto again;
 	}
 	mutex_unlock(&nft_net->commit_mutex);
 
-- 
2.33.0



