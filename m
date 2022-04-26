Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D03450F6A1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344525AbiDZI5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345872AbiDZI4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9BA814AF;
        Tue, 26 Apr 2022 01:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EC3F604F5;
        Tue, 26 Apr 2022 08:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD301C385A4;
        Tue, 26 Apr 2022 08:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962484;
        bh=vonBHZmZTiMKb/W/aFHjmS7EBkqFcVoRWuDP6uvv0GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HWlUqw5RAdwdSeaWKRmWOpxuff82Mo8gmI88Tru60yCBFO3+w3EK9CCc4jwMT84so
         2rh74U1ePB8GYJ6stSQ/LziV8GwK2wWjfmHbs0D5JD59R2HbvAWKovkFjfnXahAapH
         UxrhPFasZILz9xY1sMagbCVogHH5OoizwvksLcqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 111/124] netfilter: conntrack: convert to refcount_t api
Date:   Tue, 26 Apr 2022 10:21:52 +0200
Message-Id: <20220426081750.449092793@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 719774377622bc4025d2a74f551b5dc2158c6c30 upstream.

Convert nf_conn reference counting from atomic_t to refcount_t based api.
refcount_t api provides more runtime sanity checks and will warn on
certain constructs, e.g. refcount_inc() on a zero reference count, which
usually indicates use-after-free.

For this reason template allocation is changed to init the refcount to
1, the subsequenct add operations are removed.

Likewise, init_conntrack() is changed to set the initial refcount to 1
instead refcount_inc().

This is safe because the new entry is not (yet) visible to other cpus.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netfilter/nf_conntrack_common.h |    8 ++++----
 net/netfilter/nf_conntrack_core.c             |   26 +++++++++++++-------------
 net/netfilter/nf_conntrack_expect.c           |    4 ++--
 net/netfilter/nf_conntrack_netlink.c          |    6 +++---
 net/netfilter/nf_conntrack_standalone.c       |    4 ++--
 net/netfilter/nf_flow_table_core.c            |    2 +-
 net/netfilter/nf_synproxy_core.c              |    1 -
 net/netfilter/nft_ct.c                        |    4 +---
 net/netfilter/xt_CT.c                         |    3 +--
 net/openvswitch/conntrack.c                   |    1 -
 net/sched/act_ct.c                            |    1 -
 11 files changed, 27 insertions(+), 33 deletions(-)

--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,7 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -25,19 +25,19 @@ struct ip_conntrack_stat {
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
 struct nf_conntrack {
-	atomic_t use;
+	refcount_t use;
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
+	if (nfct && refcount_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->use);
+		refcount_inc(&nfct->use);
 }
 
 #endif /* _NF_CONNTRACK_COMMON_H */
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -598,7 +598,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	atomic_set(&tmpl->ct_general.use, 0);
+	refcount_set(&tmpl->ct_general.use, 1);
 
 	return tmpl;
 }
@@ -631,7 +631,7 @@ destroy_conntrack(struct nf_conntrack *n
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
-	WARN_ON(atomic_read(&nfct->use) != 0);
+	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -755,7 +755,7 @@ nf_ct_match(const struct nf_conn *ct1, c
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -823,7 +823,7 @@ __nf_conntrack_find_get(struct net *net,
 		 * in, try to obtain a reference and re-check tuple
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -920,7 +920,7 @@ nf_conntrack_hash_check_insert(struct nf
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	atomic_set(&ct->ct_general.use, 2);
+	refcount_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -971,7 +971,7 @@ static void __nf_conntrack_insert_prepar
 {
 	struct nf_conn_tstamp *tstamp;
 
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
@@ -1364,7 +1364,7 @@ static unsigned int early_drop_list(stru
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!atomic_inc_not_zero(&tmp->ct_general.use))
+		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1513,7 +1513,7 @@ static void gc_worker(struct work_struct
 				continue;
 
 			/* need to take reference to avoid possible races */
-			if (!atomic_inc_not_zero(&tmp->ct_general.use))
+			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
 			if (gc_worker_skip_ct(tmp)) {
@@ -1622,7 +1622,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	atomic_set(&ct->ct_general.use, 0);
+	refcount_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&cnet->count);
@@ -1647,7 +1647,7 @@ void nf_conntrack_free(struct nf_conn *c
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
+	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
@@ -1739,8 +1739,8 @@ init_conntrack(struct net *net, struct n
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, bump refcount */
-	nf_conntrack_get(&ct->ct_general);
+	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	refcount_set(&ct->ct_general.use, 1);
 	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
@@ -2352,7 +2352,7 @@ get_next_corpse(int (*iter)(struct nf_co
 
 	return NULL;
 found:
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -203,12 +203,12 @@ nf_ct_find_expectation(struct net *net,
 	 * about to invoke ->destroy(), or nf_ct_delete() via timeout
 	 * or early_drop().
 	 *
-	 * The atomic_inc_not_zero() check tells:  If that fails, we
+	 * The refcount_inc_not_zero() check tells:  If that fails, we
 	 * know that the ct is being destroyed.  If it succeeds, we
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
+		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -508,7 +508,7 @@ nla_put_failure:
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -1200,7 +1200,7 @@ restart:
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    atomic_inc_not_zero(&ct->ct_general.use))
+				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1748,7 +1748,7 @@ restart:
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 						  ct, dying ? true : false, 0);
 			if (res < 0) {
-				if (!atomic_inc_not_zero(&ct->ct_general.use))
+				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -303,7 +303,7 @@ static int ct_seq_show(struct seq_file *
 	int ret = 0;
 
 	WARN_ON(!ct);
-	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -370,7 +370,7 @@ static int ct_seq_show(struct seq_file *
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -48,7 +48,7 @@ struct flow_offload *flow_offload_alloc(
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
-	    !atomic_inc_not_zero(&ct->ct_general.use)))
+	    !refcount_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -349,7 +349,6 @@ static int __net_init synproxy_net_init(
 		goto err2;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 	snet->tmpl = ct;
 
 	snet->stats = alloc_percpu(struct synproxy_stats);
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -259,7 +259,7 @@ static void nft_ct_set_zone_eval(const s
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(atomic_read(&ct->ct_general.use) == 1)) {
+	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
 		/* previous skb got queued to userspace */
@@ -270,7 +270,6 @@ static void nft_ct_set_zone_eval(const s
 		}
 	}
 
-	atomic_inc(&ct->ct_general.use);
 	nf_ct_set(skb, ct, IP_CT_NEW);
 }
 #endif
@@ -375,7 +374,6 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 			return false;
 		}
 
-		atomic_set(&tmp->ct_general.use, 1);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
 
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -24,7 +24,7 @@ static inline int xt_ct_target(struct sk
 		return XT_CONTINUE;
 
 	if (ct) {
-		atomic_inc(&ct->ct_general.use);
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_set(skb, ct, IP_CT_NEW);
 	} else {
 		nf_ct_set(skb, ct, IP_CT_UNTRACKED);
@@ -201,7 +201,6 @@ static int xt_ct_tg_check(const struct x
 			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 out:
 	info->ct = ct;
 	return 0;
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1722,7 +1722,6 @@ int ovs_ct_copy_action(struct net *net,
 		goto err_free_ct;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
-	nf_conntrack_get(&ct_info.ct->ct_general);
 	return 0;
 err_free_ct:
 	__ovs_ct_free_action(&ct_info);
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1232,7 +1232,6 @@ static int tcf_ct_fill_params(struct net
 		return -ENOMEM;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
-	nf_conntrack_get(&tmpl->ct_general);
 	p->tmpl = tmpl;
 
 	return 0;


