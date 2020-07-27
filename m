Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23B022F02B
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbgG0OWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731868AbgG0OW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:22:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74F0E2075A;
        Mon, 27 Jul 2020 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859747;
        bh=aRs0fHRFF09H6T/bvPZZeOQfEt5/6AqayuAMVUN2x9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6nh2axNkaB8FfgGztQ0h6duOT25JAzA/DHEAoGuOPJGhGIlPDlRrjqYt5EOba6IC
         fZL0HYHYaJHWStx6o9+P8JayPzPHbBQLB9JvecR89LpBwYL44jTOJ/43GUxmSAopUN
         epzBcUZqEx7lmbOk9orO4jsssc2wCBKyERALzubM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 049/179] netfilter: nf_tables: fix nat hook table deletion
Date:   Mon, 27 Jul 2020 16:03:44 +0200
Message-Id: <20200727134935.057147558@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1e9451cbda456a170518b2bfd643e2cb980880bf ]

sybot came up with following transaction:
 add table ip syz0
 add chain ip syz0 syz2 { type nat hook prerouting priority 0; policy accept; }
 add table ip syz0 { flags dormant; }
 delete chain ip syz0 syz2
 delete table ip syz0

which yields:
hook not found, pf 2 num 0
WARNING: CPU: 0 PID: 6775 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
[..]
 nft_unregister_basechain_hooks net/netfilter/nf_tables_api.c:206 [inline]
 nft_table_disable net/netfilter/nf_tables_api.c:835 [inline]
 nf_tables_table_disable net/netfilter/nf_tables_api.c:868 [inline]
 nf_tables_commit+0x32d3/0x4d70 net/netfilter/nf_tables_api.c:7550
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:486 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:544 [inline]
 nfnetlink_rcv+0x14a5/0x1e50 net/netfilter/nfnetlink.c:562
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]

Problem is that when I added ability to override base hook registration
to make nat basechains register with the nat core instead of netfilter
core, I forgot to update nft_table_disable() to use that instead of
the 'raw' hook register interface.

In syzbot transaction, the basechain is of 'nat' type. Its registered
with the nat core.  The switch to 'dormant mode' attempts to delete from
netfilter core instead.

After updating nft_table_disable/enable to use the correct helper,
nft_(un)register_basechain_hooks can be folded into the only remaining
caller.

Because nft_trans_table_enable() won't do anything when the DORMANT flag
is set, remove the flag first, then re-add it in case re-enablement
fails, else this patch breaks sequence:

add table ip x { flags dormant; }
/* add base chains */
add table ip x

The last 'add' will remove the dormant flags, but won't have any other
effect -- base chains are not registered.
Then, next 'set dormant flag' will create another 'hook not found'
splat.

Reported-by: syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com
Fixes: 4e25ceb80b58 ("netfilter: nf_tables: allow chain type to override hook register")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 41 ++++++++++++-----------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9780bd93b7e49..e1d678af8749b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -188,24 +188,6 @@ static void nft_netdev_unregister_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 }
 
-static int nft_register_basechain_hooks(struct net *net, int family,
-					struct nft_base_chain *basechain)
-{
-	if (family == NFPROTO_NETDEV)
-		return nft_netdev_register_hooks(net, &basechain->hook_list);
-
-	return nf_register_net_hook(net, &basechain->ops);
-}
-
-static void nft_unregister_basechain_hooks(struct net *net, int family,
-					   struct nft_base_chain *basechain)
-{
-	if (family == NFPROTO_NETDEV)
-		nft_netdev_unregister_hooks(net, &basechain->hook_list);
-	else
-		nf_unregister_net_hook(net, &basechain->ops);
-}
-
 static int nf_tables_register_hook(struct net *net,
 				   const struct nft_table *table,
 				   struct nft_chain *chain)
@@ -223,7 +205,10 @@ static int nf_tables_register_hook(struct net *net,
 	if (basechain->type->ops_register)
 		return basechain->type->ops_register(net, ops);
 
-	return nft_register_basechain_hooks(net, table->family, basechain);
+	if (table->family == NFPROTO_NETDEV)
+		return nft_netdev_register_hooks(net, &basechain->hook_list);
+
+	return nf_register_net_hook(net, &basechain->ops);
 }
 
 static void nf_tables_unregister_hook(struct net *net,
@@ -242,7 +227,10 @@ static void nf_tables_unregister_hook(struct net *net,
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	nft_unregister_basechain_hooks(net, table->family, basechain);
+	if (table->family == NFPROTO_NETDEV)
+		nft_netdev_unregister_hooks(net, &basechain->hook_list);
+	else
+		nf_unregister_net_hook(net, &basechain->ops);
 }
 
 static int nft_trans_table_add(struct nft_ctx *ctx, int msg_type)
@@ -832,8 +820,7 @@ static void nft_table_disable(struct net *net, struct nft_table *table, u32 cnt)
 		if (cnt && i++ == cnt)
 			break;
 
-		nft_unregister_basechain_hooks(net, table->family,
-					       nft_base_chain(chain));
+		nf_tables_unregister_hook(net, table, chain);
 	}
 }
 
@@ -848,8 +835,7 @@ static int nf_tables_table_enable(struct net *net, struct nft_table *table)
 		if (!nft_is_base_chain(chain))
 			continue;
 
-		err = nft_register_basechain_hooks(net, table->family,
-						   nft_base_chain(chain));
+		err = nf_tables_register_hook(net, table, chain);
 		if (err < 0)
 			goto err_register_hooks;
 
@@ -894,11 +880,12 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 		nft_trans_table_enable(trans) = false;
 	} else if (!(flags & NFT_TABLE_F_DORMANT) &&
 		   ctx->table->flags & NFT_TABLE_F_DORMANT) {
+		ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
 		ret = nf_tables_table_enable(ctx->net, ctx->table);
-		if (ret >= 0) {
-			ctx->table->flags &= ~NFT_TABLE_F_DORMANT;
+		if (ret >= 0)
 			nft_trans_table_enable(trans) = true;
-		}
+		else
+			ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	}
 	if (ret < 0)
 		goto err;
-- 
2.25.1



