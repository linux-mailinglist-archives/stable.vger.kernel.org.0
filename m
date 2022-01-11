Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6906548B11F
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242380AbiAKPmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:42:23 -0500
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:5191 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242993AbiAKPmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:42:23 -0500
IronPort-SDR: uyKYY3sKhDPj8/sFiM/F04ZTdvv3vssMZSshMkFgHc1WCs2iOMUY7XPj348LbrbfS+f9fxpK9v
 OkeKX/RjpReoWE7D+inxFZheRuHDpksfAD7WZWcaHQmihzVl53cMBAywAOC0EO6oC7D0Zi19xo
 HzVOnTnc61DPfKxjx7tcwS0fCztfAmEALA8LkYhLyWrSNHO8uz8Bwv5hOrKXCmIRGNe0zhdruw
 SQuzr4uU2uLj2K9Xggkcp3ugkPZkNy3ahYWxVK08L+Eb8eU/O9njpYnnLQWvcSr7HvPbHv00Nj
 gVXSfvhV1WIi69Ltj4RGTHgE
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208,223";a="70495147"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:42:22 -0800
IronPort-SDR: bnBmaf7jiab/T5s0VlsCfiX0uCk5+XM9nY5/RDORhX5bt8/2VOfrWeuwnwv5zF1k10KWCSze5c
 s0pWYbxoonafqFIIIyh8SWq+af7FuBqiezqugBwF1W0jxtQh9fEtkdzjKUGR981F39K3Lue1Po
 S2UZdW5blrq9Dw8WW3GqBixts7oJRA8pdStd5xTqbdPddJ1cb9Ggboin44f/mnP+NXJrgMb77A
 P2WwaNg2WHFtJBSj4dg7iW6E6rRfTv0D8uJn8YHGI/9l6PLAm6kHCZhBjv8XqZU12A4bVf8dJV
 Cds=
Date:   Tue, 11 Jan 2022 10:42:17 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: Re: [PATCH 4.19 stable 5/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2lWWNFpHXPtnV1@cat>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
X-ClientProxiedBy: svr-orw-mbx-11.mgc.mentorg.com (147.34.90.211) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From e6cec303e31d347aa44beb37876fa6763cc0430c Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 29 Oct 2020 13:50:03 +0100
Subject: [PATCH 5/5] netfilter: nf_tables: missing validation from the abort
 path

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
(cherry picked from commit c0391b6ab810381df632677a1dcbbbbd63d05b6d)
---
 include/linux/netfilter/nfnetlink.h |  9 ++++++++-
 net/netfilter/nf_tables_api.c       | 15 ++++++++++-----
 net/netfilter/nfnetlink.c           | 22 ++++++++++++++++++----
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 89016d08f6a2..f6267e2883f2 100644
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
index 54bf2ac44531..e15e574f035d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6734,11 +6734,15 @@ static void nf_tables_abort_release(struct nft_trans *trans)
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
@@ -6851,7 +6855,7 @@ static int __nf_tables_abort(struct net *net, bool autoload)
 		nf_tables_abort_release(trans);
 	}
 
-	if (autoload)
+	if (action == NFNL_ABORT_AUTOLOAD)
 		nf_tables_module_autoload(net);
 	else
 		nf_tables_module_autoload_cleanup(net);
@@ -6864,9 +6868,10 @@ static void nf_tables_cleanup(struct net *net)
 	nft_validate_state_update(net, NFT_VALIDATE_SKIP);
 }
 
-static int nf_tables_abort(struct net *net, struct sk_buff *skb, bool autoload)
+static int nf_tables_abort(struct net *net, struct sk_buff *skb,
+			   enum nfnl_abort_action action)
 {
-	int ret = __nf_tables_abort(net, autoload);
+	int ret = __nf_tables_abort(net, action);
 
 	mutex_unlock(&net->nft.commit_mutex);
 
@@ -7472,7 +7477,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	mutex_lock(&net->nft.commit_mutex);
 	if (!list_empty(&net->nft.commit_list))
-		__nf_tables_abort(net, false);
+		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 7454f135e19d..4f5dcdf1a39e 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -314,7 +314,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return netlink_ack(skb, nlh, -EINVAL, NULL);
 replay:
 	status = 0;
-
+replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
@@ -478,7 +478,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 done:
 	if (status & NFNL_BATCH_REPLAY) {
-		ss->abort(net, oskb, true);
+		ss->abort(net, oskb, NFNL_ABORT_AUTOLOAD);
 		nfnl_err_reset(&err_list);
 		kfree_skb(skb);
 		module_put(ss->owner);
@@ -489,11 +489,25 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
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
2.34.1

