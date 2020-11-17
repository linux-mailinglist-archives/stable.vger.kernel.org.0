Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC982B6588
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730733AbgKQNz7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:57532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731220AbgKQNWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:22:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3858420781;
        Tue, 17 Nov 2020 13:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619375;
        bh=EPlApPdhdg0EgtNraY6c2Mu/5MvNdNYih0DOuKVOx1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CdAPCNccLKkvYmSylgFhb7yVtvcmbC2m7Qc6aYasRM3pzuPLfaq3uB2p++rzVbAKz
         9XMD+EStk2p/y82GczpKeVPp4mEDQ2nDHzVsno+GPEuXrbFVerAwEzoN2iDKBQhD1i
         nfURLYdL1CLZOCajZYtmtkbmgK3HIJC2HYhNphnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/151] netfilter: nf_tables: missing validation from the abort path
Date:   Tue, 17 Nov 2020 14:04:08 +0100
Message-Id: <20201117122122.292011369@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c0391b6ab810381df632677a1dcbbbbd63d05b6d ]

If userspace does not include the trailing end of batch message, then
nfnetlink aborts the transaction. This allows to check that ruleset
updates trigger no errors.

After this patch, invoking this command from the prerouting chain:

 # nft -c add rule x y fib saddr . oif type local

fails since oif is not supported there.

This patch fixes the lack of rule validation from the abort/check path
to catch configuration errors such as the one above.

Fixes: a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter/nfnetlink.h |  9 ++++++++-
 net/netfilter/nf_tables_api.c       | 15 ++++++++++-----
 net/netfilter/nfnetlink.c           | 22 ++++++++++++++++++----
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 89016d08f6a27..f6267e2883f26 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -24,6 +24,12 @@ struct nfnl_callback {
 	const u_int16_t attr_count;		/* number of nlattr's */
 };
 
+enum nfnl_abort_action {
+	NFNL_ABORT_NONE		= 0,
+	NFNL_ABORT_AUTOLOAD,
+	NFNL_ABORT_VALIDATE,
+};
+
 struct nfnetlink_subsystem {
 	const char *name;
 	__u8 subsys_id;			/* nfnetlink subsystem ID */
@@ -31,7 +37,8 @@ struct nfnetlink_subsystem {
 	const struct nfnl_callback *cb;	/* callback for individual types */
 	struct module *owner;
 	int (*commit)(struct net *net, struct sk_buff *skb);
-	int (*abort)(struct net *net, struct sk_buff *skb, bool autoload);
+	int (*abort)(struct net *net, struct sk_buff *skb,
+		     enum nfnl_abort_action action);
 	void (*cleanup)(struct net *net);
 	bool (*valid_genid)(struct net *net, u32 genid);
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5a77b7a177229..51391d5d22656 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7010,11 +7010,15 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	kfree(trans);
 }
 
-static int __nf_tables_abort(struct net *net, bool autoload)
+static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
 
+	if (action == NFNL_ABORT_VALIDATE &&
+	    nf_tables_validate(net) < 0)
+		return -EAGAIN;
+
 	list_for_each_entry_safe_reverse(trans, next, &net->nft.commit_list,
 					 list) {
 		switch (trans->msg_type) {
@@ -7132,7 +7136,7 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 		nf_tables_abort_release(trans);
 	}
 
-	if (autoload)
+	if (action == NFNL_ABORT_AUTOLOAD)
 		nf_tables_module_autoload(net);
 	else
 		nf_tables_module_autoload_cleanup(net);
@@ -7145,9 +7149,10 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb,
+			   enum nfnl_abort_action action)
 {
-	int ret = __nf_tables_abort(net, autoload);
+	int ret = __nf_tables_abort(net, action);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -7754,7 +7759,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net, false);
+		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 6d03b09096210..81c86a156c6c0 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -315,7 +315,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return netlink_ack(skb, nlh, -EINVAL, NULL);
 replay:
 	status = 0;
-
+replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
@@ -481,7 +481,7 @@ ack:
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb, true);
+		ss->abort(net, oskb, NFNL_ABORT_AUTOLOAD);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -492,11 +492,25 @@ done:
 			status |= NFNL_BATCH_REPLAY;
 			goto done;
 		} else if (err) {
-			ss->abort(net, oskb, false);
+			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		}
 	} else {
-		ss->abort(net, oskb, false);
+		enum nfnl_abort_action abort_action;
+
+		if (status & NFNL_BATCH_FAILURE)
+			abort_action = NFNL_ABORT_NONE;
+		else
+			abort_action = NFNL_ABORT_VALIDATE;
+
+		err = ss->abort(net, oskb, abort_action);
+		if (err == -EAGAIN) {
+			nfnl_err_reset(&err_list);
+			kfree_skb(skb);
+			module_put(ss->owner);
+			status |= NFNL_BATCH_FAILURE;
+			goto replay_abort;
+		}
 	}
 	if (ss->cleanup)
 		ss->cleanup(net);
-- 
2.27.0



