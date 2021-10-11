Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DA3429080
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238766AbhJKOJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238090AbhJKOHZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E197E611BD;
        Mon, 11 Oct 2021 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960839;
        bh=4KQ5U+7bGhBtjV94l85hK8/mcbFL9tITmSNJtdhgxW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd0RK3LX++Jp2oQ+/YSplpz6gzKG5aiQF7xci7BxwjMkusSNkVVDLUhUl+SsqdaMf
         1LaNPQGdp25bwWL76yhNMfMtcMCQU7A9iSMr6ERNUMnXzCdV2gvV+lS8bDrfx1eanh
         V9J2lhZTQOaynLzZURetJnMRyBl+SsYGlYEzM0N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 073/151] netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification
Date:   Mon, 11 Oct 2021 15:45:45 +0200
Message-Id: <20211011134520.208184506@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6fb721cf781808ee2ca5e737fb0592cc68de3381 ]

Include the NLM_F_CREATE and NLM_F_EXCL flags in netlink event
notifications, otherwise userspace cannot distiguish between create and
add commands.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 47 +++++++++++++++++++++++--------
 net/netfilter/nft_quota.c         |  2 +-
 3 files changed, 37 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 148f5d8ee5ab..a16171c5fd9e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1202,7 +1202,7 @@ struct nft_object *nft_obj_lookup(const struct net *net,
 
 void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq,
-		    int event, int family, int report, gfp_t gfp);
+		    int event, u16 flags, int family, int report, gfp_t gfp);
 
 /**
  *	struct nft_object_type - stateful object type
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c8acd26c7201..c0851fec11d4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -780,6 +780,7 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -790,8 +791,11 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 	if (skb == NULL)
 		goto err;
 
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
+
 	err = nf_tables_fill_table_info(skb, ctx->net, ctx->portid, ctx->seq,
-					event, 0, ctx->family, ctx->table);
+					event, flags, ctx->family, ctx->table);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -1563,6 +1567,7 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct nftables_pernet *nft_net;
 	struct sk_buff *skb;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -1573,8 +1578,11 @@ static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 	if (skb == NULL)
 		goto err;
 
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
+
 	err = nf_tables_fill_chain_info(skb, ctx->net, ctx->portid, ctx->seq,
-					event, 0, ctx->family, ctx->table,
+					event, flags, ctx->family, ctx->table,
 					ctx->chain);
 	if (err < 0) {
 		kfree_skb(skb);
@@ -2945,6 +2953,8 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
 	}
 	if (ctx->flags & (NLM_F_APPEND | NLM_F_REPLACE))
 		flags |= NLM_F_APPEND;
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
 
 	err = nf_tables_fill_rule_info(skb, ctx->net, ctx->portid, ctx->seq,
 				       event, flags, ctx->family, ctx->table,
@@ -3957,8 +3967,9 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 			         gfp_t gfp_flags)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
-	struct sk_buff *skb;
 	u32 portid = ctx->portid;
+	struct sk_buff *skb;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -3969,7 +3980,10 @@ static void nf_tables_set_notify(const struct nft_ctx *ctx,
 	if (skb == NULL)
 		goto err;
 
-	err = nf_tables_fill_set(skb, ctx, set, event, 0);
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
+
+	err = nf_tables_fill_set(skb, ctx, set, event, flags);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -5245,12 +5259,13 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 				     const struct nft_set *set,
 				     const struct nft_set_elem *elem,
-				     int event, u16 flags)
+				     int event)
 {
 	struct nftables_pernet *nft_net;
 	struct net *net = ctx->net;
 	u32 portid = ctx->portid;
 	struct sk_buff *skb;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
@@ -5260,6 +5275,9 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	if (skb == NULL)
 		goto err;
 
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
+
 	err = nf_tables_fill_setelem_info(skb, ctx, 0, portid, event, flags,
 					  set, elem);
 	if (err < 0) {
@@ -6935,7 +6953,7 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 
 void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq, int event,
-		    int family, int report, gfp_t gfp)
+		    u16 flags, int family, int report, gfp_t gfp)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct sk_buff *skb;
@@ -6960,8 +6978,9 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 	if (skb == NULL)
 		goto err;
 
-	err = nf_tables_fill_obj_info(skb, net, portid, seq, event, 0, family,
-				      table, obj, false);
+	err = nf_tables_fill_obj_info(skb, net, portid, seq, event,
+				      flags & (NLM_F_CREATE | NLM_F_EXCL),
+				      family, table, obj, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
@@ -6978,7 +6997,7 @@ static void nf_tables_obj_notify(const struct nft_ctx *ctx,
 				 struct nft_object *obj, int event)
 {
 	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
-		       ctx->family, ctx->report, GFP_KERNEL);
+		       ctx->flags, ctx->family, ctx->report, GFP_KERNEL);
 }
 
 /*
@@ -7759,6 +7778,7 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	struct sk_buff *skb;
+	u16 flags = 0;
 	int err;
 
 	if (!ctx->report &&
@@ -7769,8 +7789,11 @@ static void nf_tables_flowtable_notify(struct nft_ctx *ctx,
 	if (skb == NULL)
 		goto err;
 
+	if (ctx->flags & (NLM_F_CREATE | NLM_F_EXCL))
+		flags |= ctx->flags & (NLM_F_CREATE | NLM_F_EXCL);
+
 	err = nf_tables_fill_flowtable_info(skb, ctx->net, ctx->portid,
-					    ctx->seq, event, 0,
+					    ctx->seq, event, flags,
 					    ctx->family, flowtable, hook_list);
 	if (err < 0) {
 		kfree_skb(skb);
@@ -8648,7 +8671,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_setelem_activate(net, te->set, &te->elem);
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
-						 NFT_MSG_NEWSETELEM, 0);
+						 NFT_MSG_NEWSETELEM);
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELSETELEM:
@@ -8656,7 +8679,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
-						 NFT_MSG_DELSETELEM, 0);
+						 NFT_MSG_DELSETELEM);
 			nft_setelem_remove(net, te->set, &te->elem);
 			if (!nft_setelem_is_catchall(te->set, &te->elem)) {
 				atomic_dec(&te->set->nelems);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 0363f533a42b..c4d1389f7185 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -60,7 +60,7 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 	if (overquota &&
 	    !test_and_set_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags))
 		nft_obj_notify(nft_net(pkt), obj->key.table, obj, 0, 0,
-			       NFT_MSG_NEWOBJ, nft_pf(pkt), 0, GFP_ATOMIC);
+			       NFT_MSG_NEWOBJ, 0, nft_pf(pkt), 0, GFP_ATOMIC);
 }
 
 static int nft_quota_do_init(const struct nlattr * const tb[],
-- 
2.33.0



