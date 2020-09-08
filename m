Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FEE261C07
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgIHTNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:13:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbgIHQFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:05:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B71522473;
        Tue,  8 Sep 2020 15:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579519;
        bh=NqxuL9g6SZ8+WHH5T06kLpoc6y+kSkRhjswZ+xFP9pA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUG559AtdbcWLIavJ2x+8EmQ6dq87m64Taer4iYQUR1VmuMrIJnzXgzOlzKqeRrsH
         RO3jsiwTu7TK1ZzLrMSUr9RvZupbgNtJEGIbSbYbUy6JN4pQwM7btsS8Tth3V8lIr+
         EnbW5m7+yrz8sQaiNPSj5nrt9Zovtuujhrszr+yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 082/186] netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS
Date:   Tue,  8 Sep 2020 17:23:44 +0200
Message-Id: <20200908152245.616307154@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ee921183557af39c1a0475f982d43b0fcac25e2e ]

Frontend callback reports EAGAIN to nfnetlink to retry a command, this
is used to signal that module autoloading is required. Unfortunately,
nlmsg_unicast() reports EAGAIN in case the receiver socket buffer gets
full, so it enters a busy-loop.

This patch updates nfnetlink_unicast() to turn EAGAIN into ENOBUFS and
to use nlmsg_unicast(). Remove the flags field in nfnetlink_unicast()
since this is always MSG_DONTWAIT in the existing code which is exactly
what nlmsg_unicast() passes to netlink_unicast() as parameter.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/nfnetlink.h |  3 +-
 net/netfilter/nf_tables_api.c       | 61 ++++++++++++++---------------
 net/netfilter/nfnetlink.c           | 11 ++++--
 net/netfilter/nfnetlink_log.c       |  3 +-
 net/netfilter/nfnetlink_queue.c     |  2 +-
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 851425c3178f1..89016d08f6a27 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -43,8 +43,7 @@ int nfnetlink_has_listeners(struct net *net, unsigned int group);
 int nfnetlink_send(struct sk_buff *skb, struct net *net, u32 portid,
 		   unsigned int group, int echo, gfp_t flags);
 int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error);
-int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid,
-		      int flags);
+int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid);
 
 static inline u16 nfnl_msg_type(u8 subsys, u8 msg_type)
 {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 39be0a3015c63..05059f620d41e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -797,11 +797,11 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
 					nlh->nlmsg_seq, NFT_MSG_NEWTABLE, 0,
 					family, table);
 	if (err < 0)
-		goto err;
+		goto err_fill_table_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_table_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -1527,11 +1527,11 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
 					nlh->nlmsg_seq, NFT_MSG_NEWCHAIN, 0,
 					family, table, chain);
 	if (err < 0)
-		goto err;
+		goto err_fill_chain_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_chain_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -2898,11 +2898,11 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule, NULL);
 	if (err < 0)
-		goto err;
+		goto err_fill_rule_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_rule_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -3829,11 +3829,11 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 
 	err = nf_tables_fill_set(skb2, &ctx, set, NFT_MSG_NEWSET, 0);
 	if (err < 0)
-		goto err;
+		goto err_fill_set_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
 
-err:
+err_fill_set_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -4721,24 +4721,18 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
-		goto err1;
+		return err;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
 					  NFT_MSG_NEWSETELEM, 0, set, &elem);
 	if (err < 0)
-		goto err2;
+		goto err_fill_setelem;
 
-	err = nfnetlink_unicast(skb, ctx->net, ctx->portid, MSG_DONTWAIT);
-	/* This avoids a loop in nfnetlink. */
-	if (err < 0)
-		goto err1;
+	return nfnetlink_unicast(skb, ctx->net, ctx->portid);
 
-	return 0;
-err2:
+err_fill_setelem:
 	kfree_skb(skb);
-err1:
-	/* this avoids a loop in nfnetlink. */
-	return err == -EAGAIN ? -ENOBUFS : err;
+	return err;
 }
 
 /* called with rcu_read_lock held */
@@ -5992,10 +5986,11 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
 				      nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
 				      family, table, obj, reset);
 	if (err < 0)
-		goto err;
+		goto err_fill_obj_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_obj_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -6844,10 +6839,11 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
 					    flowtable, &flowtable->hook_list);
 	if (err < 0)
-		goto err;
+		goto err_fill_flowtable_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_flowtable_info:
 	kfree_skb(skb2);
 	return err;
 }
@@ -7018,10 +7014,11 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
 	err = nf_tables_fill_gen_info(skb2, net, NETLINK_CB(skb).portid,
 				      nlh->nlmsg_seq);
 	if (err < 0)
-		goto err;
+		goto err_fill_gen_info;
 
-	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
-err:
+	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+
+err_fill_gen_info:
 	kfree_skb(skb2);
 	return err;
 }
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 5f24edf958309..3a2e64e13b227 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -149,10 +149,15 @@ int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error)
 }
 EXPORT_SYMBOL_GPL(nfnetlink_set_err);
 
-int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid,
-		      int flags)
+int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid)
 {
-	return netlink_unicast(net->nfnl, skb, portid, flags);
+	int err;
+
+	err = nlmsg_unicast(net->nfnl, skb, portid);
+	if (err == -EAGAIN)
+		err = -ENOBUFS;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0ba020ca38e68..7ca2ca4bba055 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -356,8 +356,7 @@ __nfulnl_send(struct nfulnl_instance *inst)
 			goto out;
 		}
 	}
-	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid,
-			  MSG_DONTWAIT);
+	nfnetlink_unicast(inst->skb, inst->net, inst->peer_portid);
 out:
 	inst->qlen = 0;
 	inst->skb = NULL;
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3243a31f6e829..70d086944bcc7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -681,7 +681,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	*packet_id_ptr = htonl(entry->id);
 
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
-	err = nfnetlink_unicast(nskb, net, queue->peer_portid, MSG_DONTWAIT);
+	err = nfnetlink_unicast(nskb, net, queue->peer_portid);
 	if (err < 0) {
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
-- 
2.25.1



