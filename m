Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6FA34CA6F
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbhC2Iig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234417AbhC2IgT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:36:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7334C6192E;
        Mon, 29 Mar 2021 08:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006954;
        bh=g/C9XFXNB0xGDDSsgKumGA5DUmDJUcoXZj96GypIQD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pX/jSw+Xo9aTHK/ZDtc5gEFKJ2JFpIBQLZtNajQDA6OvP8G0W+vKFQboO7MXGXn8H
         7aNx8rKFGLwTZjCmA98B6KzMbc4GnBuD4cEsEzJ944P3URTN1+N9dvhNbY9cyTbNYu
         V1VGlMjLGk10WWaEDFK4TsPSrbSVpeAWw7UY7iz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 167/254] netfilter: nftables: allow to update flowtable flags
Date:   Mon, 29 Mar 2021 09:58:03 +0200
Message-Id: <20210329075638.662367741@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 7b35582cd04ace2fd1807c1b624934e465cc939d ]

Honor flowtable flags from the control update path. Disallow disabling
to toggle hardware offload support though.

Fixes: 8bb69f3b2918 ("netfilter: nf_tables: add flowtable offload control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4b6ecf532623..6799f95eea65 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1531,6 +1531,7 @@ struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
 	bool				update;
 	struct list_head		hook_list;
+	u32				flags;
 };
 
 #define nft_trans_flowtable(trans)	\
@@ -1539,6 +1540,8 @@ struct nft_trans_flowtable {
 	(((struct nft_trans_flowtable *)trans->data)->update)
 #define nft_trans_flowtable_hooks(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->hook_list)
+#define nft_trans_flowtable_flags(trans)	\
+	(((struct nft_trans_flowtable *)trans->data)->flags)
 
 int __init nft_chain_filter_init(void);
 void nft_chain_filter_fini(void);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2aae0df0d70d..24a7a6b17268 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6808,6 +6808,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
+	u32 flags;
 	int err;
 
 	err = nft_flowtable_parse_hook(ctx, nla[NFTA_FLOWTABLE_HOOK],
@@ -6822,6 +6823,17 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		}
 	}
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flags & ~NFT_FLOWTABLE_MASK)
+			return -EOPNOTSUPP;
+		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
+			return -EOPNOTSUPP;
+	} else {
+		flags = flowtable->data.flags;
+	}
+
 	err = nft_register_flowtable_net_hooks(ctx->net, ctx->table,
 					       &flowtable_hook.list, flowtable);
 	if (err < 0)
@@ -6835,6 +6847,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		goto err_flowtable_update_hook;
 	}
 
+	nft_trans_flowtable_flags(trans) = flags;
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
@@ -8144,6 +8157,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_NEWFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
+				nft_trans_flowtable(trans)->data.flags =
+					nft_trans_flowtable_flags(trans);
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
-- 
2.30.1



