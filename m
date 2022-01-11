Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF348B137
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 16:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240687AbiAKPrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 10:47:31 -0500
Received: from esa4.mentor.iphmx.com ([68.232.137.252]:56449 "EHLO
        esa4.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiAKPra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 10:47:30 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 10:47:30 EST
IronPort-SDR: FKdkXr6ZYxAjCCSyvJSKQ23QP48k+OA/yBiIYRDrXgxqhy3tO/1tetrmEimLh9dk+IA9bwX7A6
 TPO8aC4bNn92ORqvv0mrRewJ27pOKS7UBaQ1bn01wFj1Sm6+zRA0sAdrit+ev8n5GYiJt2ZN0U
 sok65jaGrLIX5Ztu0XYui16CHmf9PKHg4Ylx8M2Sc1a5OFMZh1uImqa50Wn9FfI/cNBpzIM3Hu
 5oeV0FSL6kXnazfsnAhMxSZTM6QXtrqIkf5ucgnWQohH/WCQW5vosYl5l/mXa6vsAisVyvXJkG
 IrySjKbT0M7gYJjr+IKThikJ
X-IronPort-AV: E=Sophos;i="5.88,279,1635235200"; 
   d="scan'208,223";a="70628365"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa4.mentor.iphmx.com with ESMTP; 11 Jan 2022 07:40:23 -0800
IronPort-SDR: QUYboqn5luhLOXRZDDk7SSsLRrbf8urn3hiECVmTwzpgJ1KZMgqRFxFIbmfUWE5nxUwqXg0Mmj
 OtlaCqnufEb6v5W3X0QEPFHX6OTdgR6Pu9ZQpXQ1xrsbgQlxKEAIUXaXRU6glzcgMf9cwNuVh3
 s8b5uQzKLvndDR0q/JPiLUh15Nu//rnY2/ZmzuFCXj1lEz/9H3rH6aPGtG5a2QVaKRPsqWDZg9
 iKYuyjpx6ngs0PEmZ5btECJPe9PSglzYDSW5+L7ieQaovTs4RXwI2AkAj6ZaRtRu+SaD18rCLp
 3ms=
Date:   Tue, 11 Jan 2022 10:40:18 -0500
From:   Amy Fong <Amy_Fong@mentor.com>
To:     <stable@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: Re: [PATCH 4.19 stable 1/5] Backport netfilter: nf_tables: autoload
 modules from the abort path
Message-ID: <Yd2k4t3maO91WXpQ@cat>
References: <Yd2kKZEWm6AdBYDE@cat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yd2kKZEWm6AdBYDE@cat>
X-ClientProxiedBy: svr-orw-mbx-10.mgc.mentorg.com (147.34.90.210) To
 svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From dda33be9e3fadf0b47e2afc8a0b381c3667622c3 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Wed, 29 Aug 2018 14:41:32 +0200
Subject: [PATCH 1/5] netfilter: nf_tables: asynchronous release

Release the committed transaction log from a work queue, moving
expensive synchronize_rcu out of the locked section and providing
opportunity to batch this.

On my test machine this cuts runtime of nft-test.py in half.
Based on earlier patch from Pablo Neira Ayuso.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 0935d558840099b3679c67bb7468dc78fcbad940)
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 56 +++++++++++++++++++++++++++----
 2 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 93253ba1eeac..c60d281c9a58 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1316,12 +1316,14 @@ static inline void nft_set_elem_clear_busy(struct nft_set_ext *ext)
  *
  *	@list: used internally
  *	@msg_type: message type
+ *	@put_net: ctx->net needs to be put
  *	@ctx: transaction context
  *	@data: internal information related to the transaction
  */
 struct nft_trans {
 	struct list_head		list;
 	int				msg_type;
+	bool				put_net;
 	struct nft_ctx			ctx;
 	char				data[0];
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9cc8e92f4b00..02e577e8fb8a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -29,6 +29,8 @@
 static LIST_HEAD(nf_tables_expressions);
 static LIST_HEAD(nf_tables_objects);
 static LIST_HEAD(nf_tables_flowtables);
+static LIST_HEAD(nf_tables_destroy_list);
+static DEFINE_SPINLOCK(nf_tables_destroy_list_lock);
 static u64 table_handle;
 
 enum {
@@ -66,6 +68,8 @@ static void nft_validate_state_update(struct net *net, u8 new_validate_state)
 
 	net->nft.validate_state = new_validate_state;
 }
+static void nf_tables_trans_destroy_work(struct work_struct *w);
+static DECLARE_WORK(trans_destroy_work, nf_tables_trans_destroy_work);
 
 static void nft_ctx_init(struct nft_ctx *ctx,
 			 struct net *net,
@@ -2503,7 +2507,6 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_expr *expr, *next;
 
-	lockdep_assert_held(&ctx->net->nft.commit_mutex);
 	/*
 	 * Careful: some expressions might not be initialized in case this
 	 * is called on error from nf_tables_newrule().
@@ -6300,19 +6303,28 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
+
+	if (trans->put_net)
+		put_net(trans->ctx.net);
+
 	kfree(trans);
 }
 
-static void nf_tables_commit_release(struct net *net)
+static void nf_tables_trans_destroy_work(struct work_struct *w)
 {
 	struct nft_trans *trans, *next;
+	LIST_HEAD(head);
+
+	spin_lock(&nf_tables_destroy_list_lock);
+	list_splice_init(&nf_tables_destroy_list, &head);
+	spin_unlock(&nf_tables_destroy_list_lock);
 
-	if (list_empty(&net->nft.commit_list))
+	if (list_empty(&head))
 		return;
 
 	synchronize_rcu();
 
-	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+	list_for_each_entry_safe(trans, next, &head, list) {
 		list_del(&trans->list);
 		nft_commit_release(trans);
 	}
@@ -6443,6 +6455,37 @@ static void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
+static void nf_tables_commit_release(struct net *net)
+{
+	struct nft_trans *trans;
+
+	/* all side effects have to be made visible.
+	 * For example, if a chain named 'foo' has been deleted, a
+	 * new transaction must not find it anymore.
+	 *
+	 * Memory reclaim happens asynchronously from work queue
+	 * to prevent expensive synchronize_rcu() in commit phase.
+	 */
+	if (list_empty(&net->nft.commit_list)) {
+		mutex_unlock(&net->nft.commit_mutex);
+		return;
+	}
+
+	trans = list_last_entry(&net->nft.commit_list,
+				struct nft_trans, list);
+	get_net(trans->ctx.net);
+	WARN_ON_ONCE(trans->put_net);
+
+	trans->put_net = true;
+	spin_lock(&nf_tables_destroy_list_lock);
+	list_splice_tail_init(&net->nft.commit_list, &nf_tables_destroy_list);
+	spin_unlock(&nf_tables_destroy_list_lock);
+
+	mutex_unlock(&net->nft.commit_mutex);
+
+	schedule_work(&trans_destroy_work);
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
@@ -6604,9 +6647,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
-	nf_tables_commit_release(net);
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
-	mutex_unlock(&net->nft.commit_mutex);
+	nf_tables_commit_release(net);
 
 	return 0;
 }
@@ -7387,6 +7429,7 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
+	spin_lock_init(&nf_tables_destroy_list_lock);
 	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		return err;
@@ -7426,6 +7469,7 @@ static void __exit nf_tables_module_exit(void)
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
 	nft_chain_filter_fini();
 	unregister_pernet_subsys(&nf_tables_net_ops);
+	cancel_work_sync(&trans_destroy_work);
 	rcu_barrier();
 	nf_tables_core_module_exit();
 }
-- 
2.34.1

