Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B2261AA4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731801AbgIHSiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F34C2405A;
        Tue,  8 Sep 2020 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580119;
        bh=DepqeG9sYAF2KlX9igkZ0nVmjEu++pVcPcJbsiFag3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JR3ZX5v2nUmXX6fisBXZ7tQcgThizNkD/nEcYjnfKSD//s9ztbBvFPpxSqygJYGCn
         C9VldlWkm05t537QLuksU3Ry/QEMTD+OcvVwGIBTppk+V9a08S9b/bchcjWVu7u1pt
         8FGsfmT0dJ0yxb6EJ0bZ/dT3K/hSXkG2yHfewr/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/88] netfilter: nfnetlink: nfnetlink_unicast() reports EAGAIN instead of ENOBUFS
Date:   Tue,  8 Sep 2020 17:25:39 +0200
Message-Id: <20200908152223.012883148@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
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
index cf09ab37b45b7..e713476ff29db 100644
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
index 159ec1533c980..5b4632826dc66 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -718,11 +718,11 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
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
@@ -1383,11 +1383,11 @@ static int nf_tables_getchain(struct net *net, struct sock *nlsk,
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
@@ -2488,11 +2488,11 @@ static int nf_tables_getrule(struct net *net, struct sock *nlsk,
 				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
 				       family, table, chain, rule);
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
@@ -3377,11 +3377,11 @@ static int nf_tables_getset(struct net *net, struct sock *nlsk,
 
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
@@ -4157,24 +4157,18 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -5273,10 +5267,11 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
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
@@ -5933,10 +5928,11 @@ static int nf_tables_getflowtable(struct net *net, struct sock *nlsk,
 					    NFT_MSG_NEWFLOWTABLE, 0, family,
 					    flowtable);
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
@@ -6097,10 +6093,11 @@ static int nf_tables_getgen(struct net *net, struct sock *nlsk,
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
index 7f2c1915763f8..9bacddc761ba4 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -148,10 +148,15 @@ int nfnetlink_set_err(struct net *net, u32 portid, u32 group, int error)
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
index 332c69d27b478..25298b3eb8546 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -359,8 +359,7 @@ __nfulnl_send(struct nfulnl_instance *inst)
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
index d33094f4ec41e..f81a3ce0fe48e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -685,7 +685,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	*packet_id_ptr = htonl(entry->id);
 
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
-	err = nfnetlink_unicast(nskb, net, queue->peer_portid, MSG_DONTWAIT);
+	err = nfnetlink_unicast(nskb, net, queue->peer_portid);
 	if (err < 0) {
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
-- 
2.25.1



