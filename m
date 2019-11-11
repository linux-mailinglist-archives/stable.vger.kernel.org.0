Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08586F7E2E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfKKSsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730240AbfKKSsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 858D320674;
        Mon, 11 Nov 2019 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498097;
        bh=eK51Yv3v7b3KxZ54DU+sFhlmbdZHrwVxHxNG2cvFhPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSsw08Iu29K7Dx5ZGJu8h5UjLsnizFVk8FPw0kcLF7EG8fi6LDMCil6ionAzLoGJ/
         Bu1y3Scxxued5YTvCNhCWX/o9EHyfNQWQjKMWh2A2HFP4RqgeF1EEFwl138mgW8WV9
         g2icBwdqenCWERXiLPfoU2FMq1kctWmtTUZDl1vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Hurley <john.hurley@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Simon Horman <simon.horman@netronome.com>,
        Louis Peens <louis.peens@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 021/193] net: sched: prevent duplicate flower rules from tcf_proto destroy race
Date:   Mon, 11 Nov 2019 19:26:43 +0100
Message-Id: <20191111181501.745091812@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

[ Upstream commit 59eb87cb52c9f7164804bc8639c4d03ba9b0c169 ]

When a new filter is added to cls_api, the function
tcf_chain_tp_insert_unique() looks up the protocol/priority/chain to
determine if the tcf_proto is duplicated in the chain's hashtable. It then
creates a new entry or continues with an existing one. In cls_flower, this
allows the function fl_ht_insert_unque to determine if a filter is a
duplicate and reject appropriately, meaning that the duplicate will not be
passed to drivers via the offload hooks. However, when a tcf_proto is
destroyed it is removed from its chain before a hardware remove hook is
hit. This can lead to a race whereby the driver has not received the
remove message but duplicate flows can be accepted. This, in turn, can
lead to the offload driver receiving incorrect duplicate flows and out of
order add/delete messages.

Prevent duplicates by utilising an approach suggested by Vlad Buslov. A
hash table per block stores each unique chain/protocol/prio being
destroyed. This entry is only removed when the full destroy (and hardware
offload) has completed. If a new flow is being added with the same
identiers as a tc_proto being detroyed, then the add request is replayed
until the destroy is complete.

Fixes: 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent execution")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reported-by: Louis Peens <louis.peens@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    4 ++
 net/sched/cls_api.c       |   83 +++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 83 insertions(+), 4 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -13,6 +13,7 @@
 #include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
+#include <linux/hashtable.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 #include <net/flow_offload.h>
@@ -359,6 +360,7 @@ struct tcf_proto {
 	bool			deleting;
 	refcount_t		refcnt;
 	struct rcu_head		rcu;
+	struct hlist_node	destroy_ht_node;
 };
 
 struct qdisc_skb_cb {
@@ -409,6 +411,8 @@ struct tcf_block {
 		struct list_head filter_chain_list;
 	} chain0;
 	struct rcu_head rcu;
+	DECLARE_HASHTABLE(proto_destroy_ht, 7);
+	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
 #ifdef CONFIG_PROVE_LOCKING
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/idr.h>
 #include <linux/rhashtable.h>
+#include <linux/jhash.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netlink.h>
@@ -45,6 +46,62 @@ static LIST_HEAD(tcf_proto_base);
 /* Protects list of registered TC modules. It is pure SMP lock. */
 static DEFINE_RWLOCK(cls_mod_lock);
 
+static u32 destroy_obj_hashfn(const struct tcf_proto *tp)
+{
+	return jhash_3words(tp->chain->index, tp->prio,
+			    (__force __u32)tp->protocol, 0);
+}
+
+static void tcf_proto_signal_destroying(struct tcf_chain *chain,
+					struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+
+	mutex_lock(&block->proto_destroy_lock);
+	hash_add_rcu(block->proto_destroy_ht, &tp->destroy_ht_node,
+		     destroy_obj_hashfn(tp));
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
+static bool tcf_proto_cmp(const struct tcf_proto *tp1,
+			  const struct tcf_proto *tp2)
+{
+	return tp1->chain->index == tp2->chain->index &&
+	       tp1->prio == tp2->prio &&
+	       tp1->protocol == tp2->protocol;
+}
+
+static bool tcf_proto_exists_destroying(struct tcf_chain *chain,
+					struct tcf_proto *tp)
+{
+	u32 hash = destroy_obj_hashfn(tp);
+	struct tcf_proto *iter;
+	bool found = false;
+
+	rcu_read_lock();
+	hash_for_each_possible_rcu(chain->block->proto_destroy_ht, iter,
+				   destroy_ht_node, hash) {
+		if (tcf_proto_cmp(tp, iter)) {
+			found = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return found;
+}
+
+static void
+tcf_proto_signal_destroyed(struct tcf_chain *chain, struct tcf_proto *tp)
+{
+	struct tcf_block *block = chain->block;
+
+	mutex_lock(&block->proto_destroy_lock);
+	if (hash_hashed(&tp->destroy_ht_node))
+		hash_del_rcu(&tp->destroy_ht_node);
+	mutex_unlock(&block->proto_destroy_lock);
+}
+
 /* Find classifier type by string name */
 
 static const struct tcf_proto_ops *__tcf_proto_lookup_ops(const char *kind)
@@ -232,9 +289,11 @@ static void tcf_proto_get(struct tcf_pro
 static void tcf_chain_put(struct tcf_chain *chain);
 
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
-			      struct netlink_ext_ack *extack)
+			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
 	tp->ops->destroy(tp, rtnl_held, extack);
+	if (sig_destroy)
+		tcf_proto_signal_destroyed(tp->chain, tp);
 	tcf_chain_put(tp->chain);
 	module_put(tp->ops->owner);
 	kfree_rcu(tp, rcu);
@@ -244,7 +303,7 @@ static void tcf_proto_put(struct tcf_pro
 			  struct netlink_ext_ack *extack)
 {
 	if (refcount_dec_and_test(&tp->refcnt))
-		tcf_proto_destroy(tp, rtnl_held, extack);
+		tcf_proto_destroy(tp, rtnl_held, true, extack);
 }
 
 static int walker_check_empty(struct tcf_proto *tp, void *fh,
@@ -368,6 +427,7 @@ static bool tcf_chain_detach(struct tcf_
 static void tcf_block_destroy(struct tcf_block *block)
 {
 	mutex_destroy(&block->lock);
+	mutex_destroy(&block->proto_destroy_lock);
 	kfree_rcu(block, rcu);
 }
 
@@ -543,6 +603,12 @@ static void tcf_chain_flush(struct tcf_c
 
 	mutex_lock(&chain->filter_chain_lock);
 	tp = tcf_chain_dereference(chain->filter_chain, chain);
+	while (tp) {
+		tp_next = rcu_dereference_protected(tp->next, 1);
+		tcf_proto_signal_destroying(chain, tp);
+		tp = tp_next;
+	}
+	tp = tcf_chain_dereference(chain->filter_chain, chain);
 	RCU_INIT_POINTER(chain->filter_chain, NULL);
 	tcf_chain0_head_change(chain, NULL);
 	chain->flushing = true;
@@ -1002,6 +1068,7 @@ static struct tcf_block *tcf_block_creat
 		return ERR_PTR(-ENOMEM);
 	}
 	mutex_init(&block->lock);
+	mutex_init(&block->proto_destroy_lock);
 	flow_block_init(&block->flow_block);
 	INIT_LIST_HEAD(&block->chain_list);
 	INIT_LIST_HEAD(&block->owner_list);
@@ -1754,6 +1821,12 @@ static struct tcf_proto *tcf_chain_tp_in
 
 	mutex_lock(&chain->filter_chain_lock);
 
+	if (tcf_proto_exists_destroying(chain, tp_new)) {
+		mutex_unlock(&chain->filter_chain_lock);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	tp = tcf_chain_tp_find(chain, &chain_info,
 			       protocol, prio, false);
 	if (!tp)
@@ -1761,10 +1834,10 @@ static struct tcf_proto *tcf_chain_tp_in
 	mutex_unlock(&chain->filter_chain_lock);
 
 	if (tp) {
-		tcf_proto_destroy(tp_new, rtnl_held, NULL);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
 		tp_new = tp;
 	} else if (err) {
-		tcf_proto_destroy(tp_new, rtnl_held, NULL);
+		tcf_proto_destroy(tp_new, rtnl_held, false, NULL);
 		tp_new = ERR_PTR(err);
 	}
 
@@ -1802,6 +1875,7 @@ static void tcf_chain_tp_delete_empty(st
 		return;
 	}
 
+	tcf_proto_signal_destroying(chain, tp);
 	next = tcf_chain_dereference(chain_info.next, chain);
 	if (tp == chain->filter_chain)
 		tcf_chain0_head_change(chain, next);
@@ -2321,6 +2395,7 @@ static int tc_del_tfilter(struct sk_buff
 		err = -EINVAL;
 		goto errout_locked;
 	} else if (t->tcm_handle == 0) {
+		tcf_proto_signal_destroying(chain, tp);
 		tcf_chain_tp_remove(chain, &chain_info, tp);
 		mutex_unlock(&chain->filter_chain_lock);
 


