Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8511E579DFE
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242345AbiGSM47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242348AbiGSM4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386019A5EE;
        Tue, 19 Jul 2022 05:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92C3E61632;
        Tue, 19 Jul 2022 12:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB59C341C6;
        Tue, 19 Jul 2022 12:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233344;
        bh=NV/iYrQCFOZgumCdSuOCefhbP7ab3riduxtKlHHxEA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xXbQ7l55Hq31uEqi49cmXANnZvWcIjdRDRerXG/GvAp3Mfp+dalBtyDd048s2frK4
         irX3wsmZyhdtPIo/bTXjVCsvZDBtW0mnEO5/jNcyjqUF7cZw3TMcOvJB0jlWsQSN4g
         FbufYJQHyjpIrZkBRjXzhUfOwFBZ/1b4uD4SvRnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 064/231] netfilter: conntrack: remove the percpu dying list
Date:   Tue, 19 Jul 2022 13:52:29 +0200
Message-Id: <20220719114719.576342637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1397af5bfd7d32b0cf2adb70a78c9a9e8f11d912 ]

Its no longer needed. Entries that need event redelivery are placed
on the new pernet dying list.

The advantage is that there is no need to take additional spinlock on
conntrack removal unless event redelivery failed or the conntrack entry
was never added to the table in the first place (confirmed bit not set).

The IPS_CONFIRMED bit now needs to be set as soon as the entry has been
unlinked from the unconfirmed list, else the destroy function may
attempt to unlink it a second time.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/conntrack.h        |  1 -
 net/netfilter/nf_conntrack_core.c    | 35 +++++-----------------------
 net/netfilter/nf_conntrack_ecache.c  |  1 -
 net/netfilter/nf_conntrack_netlink.c | 23 ++++++------------
 4 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 0294f3d473af..e985a3010b89 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -96,7 +96,6 @@ struct nf_ip_net {
 struct ct_pcpu {
 	spinlock_t		lock;
 	struct hlist_nulls_head unconfirmed;
-	struct hlist_nulls_head dying;
 };
 
 struct netns_ct {
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ca1d1d105163..9010b6e5a072 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -525,21 +525,6 @@ clean_from_lists(struct nf_conn *ct)
 	nf_ct_remove_expectations(ct);
 }
 
-/* must be called with local_bh_disable */
-static void nf_ct_add_to_dying_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* add this conntrack to the (per cpu) dying list */
-	ct->cpu = smp_processor_id();
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			     &pcpu->dying);
-	spin_unlock(&pcpu->lock);
-}
-
 /* must be called with local_bh_disable */
 static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
 {
@@ -556,11 +541,11 @@ static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
 }
 
 /* must be called with local_bh_disable */
-static void nf_ct_del_from_dying_or_unconfirmed_list(struct nf_conn *ct)
+static void nf_ct_del_from_unconfirmed_list(struct nf_conn *ct)
 {
 	struct ct_pcpu *pcpu;
 
-	/* We overload first tuple to link into unconfirmed or dying list.*/
+	/* We overload first tuple to link into unconfirmed list.*/
 	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
 
 	spin_lock(&pcpu->lock);
@@ -648,7 +633,8 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+	if (unlikely(!nf_ct_is_confirmed(ct)))
+		nf_ct_del_from_unconfirmed_list(ct);
 
 	local_bh_enable();
 
@@ -686,7 +672,6 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 	local_bh_disable();
 
 	__nf_ct_delete_from_lists(ct);
-	nf_ct_add_to_dying_list(ct);
 
 	local_bh_enable();
 }
@@ -700,8 +685,6 @@ static void nf_ct_add_to_ecache_list(struct nf_conn *ct)
 	hlist_nulls_add_head_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
 				 &cnet->ecache.dying_list);
 	spin_unlock(&cnet->ecache.dying_lock);
-#else
-	nf_ct_add_to_dying_list(ct);
 #endif
 }
 
@@ -995,7 +978,6 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 	struct nf_conn_tstamp *tstamp;
 
 	refcount_inc(&ct->ct_general.use);
-	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
 	tstamp = nf_conn_tstamp_find(ct);
@@ -1024,7 +1006,6 @@ static int __nf_ct_resolve_clash(struct sk_buff *skb,
 		nf_conntrack_get(&ct->ct_general);
 
 		nf_ct_acct_merge(ct, ctinfo, loser_ct);
-		nf_ct_add_to_dying_list(loser_ct);
 		nf_ct_put(loser_ct);
 		nf_ct_set(skb, ct, ctinfo);
 
@@ -1157,7 +1138,6 @@ nf_ct_resolve_clash(struct sk_buff *skb, struct nf_conntrack_tuple_hash *h,
 		return ret;
 
 drop:
-	nf_ct_add_to_dying_list(loser_ct);
 	NF_CT_STAT_INC(net, drop);
 	NF_CT_STAT_INC(net, insert_failed);
 	return NF_DROP;
@@ -1224,10 +1204,10 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * user context, else we insert an already 'dead' hash, blocking
 	 * further use of that particular connection -JM.
 	 */
-	nf_ct_del_from_dying_or_unconfirmed_list(ct);
+	nf_ct_del_from_unconfirmed_list(ct);
+	ct->status |= IPS_CONFIRMED;
 
 	if (unlikely(nf_ct_is_dying(ct))) {
-		nf_ct_add_to_dying_list(ct);
 		NF_CT_STAT_INC(net, insert_failed);
 		goto dying;
 	}
@@ -1251,7 +1231,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 			goto out;
 		if (chainlen++ > max_chainlen) {
 chaintoolong:
-			nf_ct_add_to_dying_list(ct);
 			NF_CT_STAT_INC(net, chaintoolong);
 			NF_CT_STAT_INC(net, insert_failed);
 			ret = NF_DROP;
@@ -2800,7 +2779,6 @@ void nf_conntrack_init_end(void)
  * We need to use special "null" values, not used in hash table
  */
 #define UNCONFIRMED_NULLS_VAL	((1<<30)+0)
-#define DYING_NULLS_VAL		((1<<30)+1)
 
 int nf_conntrack_init_net(struct net *net)
 {
@@ -2821,7 +2799,6 @@ int nf_conntrack_init_net(struct net *net)
 
 		spin_lock_init(&pcpu->lock);
 		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed, UNCONFIRMED_NULLS_VAL);
-		INIT_HLIST_NULLS_HEAD(&pcpu->dying, DYING_NULLS_VAL);
 	}
 
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 334b2b4e5e8b..7472c544642f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -94,7 +94,6 @@ static enum retry_state ecache_work_evict_list(struct nf_conntrack_net *cnet)
 	hlist_nulls_for_each_entry_safe(h, n, &evicted_list, hnnode) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 
-		hlist_nulls_add_fake(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 		hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode);
 		nf_ct_put(ct);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index a4ec2aad2187..2e9c8183e4a2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -62,7 +62,6 @@ struct ctnetlink_list_dump_ctx {
 	struct nf_conn *last;
 	unsigned int cpu;
 	bool done;
-	bool retrans_done;
 };
 
 static int ctnetlink_dump_tuples_proto(struct sk_buff *skb,
@@ -1751,13 +1750,12 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 }
 
 static int
-ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying)
+ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
 	struct nf_conn *ct, *last;
 	struct nf_conntrack_tuple_hash *h;
 	struct hlist_nulls_node *n;
-	struct hlist_nulls_head *list;
 	struct net *net = sock_net(skb->sk);
 	int res, cpu;
 
@@ -1774,12 +1772,11 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 
 		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
 		spin_lock_bh(&pcpu->lock);
-		list = dying ? &pcpu->dying : &pcpu->unconfirmed;
 restart:
-		hlist_nulls_for_each_entry(h, n, list, hnnode) {
+		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 
-			res = ctnetlink_dump_one_entry(skb, cb, ct, dying);
+			res = ctnetlink_dump_one_entry(skb, cb, ct, false);
 			if (res < 0) {
 				ctx->cpu = cpu;
 				spin_unlock_bh(&pcpu->lock);
@@ -1812,8 +1809,8 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 	struct hlist_nulls_node *n;
 #endif
 
-	if (ctx->retrans_done)
-		return ctnetlink_dump_list(skb, cb, true);
+	if (ctx->done)
+		return 0;
 
 	ctx->last = NULL;
 
@@ -1842,10 +1839,10 @@ ctnetlink_dump_dying(struct sk_buff *skb, struct netlink_callback *cb)
 
 	spin_unlock_bh(&ecache_net->dying_lock);
 #endif
+	ctx->done = true;
 	nf_ct_put(last);
-	ctx->retrans_done = true;
 
-	return ctnetlink_dump_list(skb, cb, true);
+	return skb->len;
 }
 
 static int ctnetlink_get_ct_dying(struct sk_buff *skb,
@@ -1863,12 +1860,6 @@ static int ctnetlink_get_ct_dying(struct sk_buff *skb,
 	return -EOPNOTSUPP;
 }
 
-static int
-ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	return ctnetlink_dump_list(skb, cb, false);
-}
-
 static int ctnetlink_get_ct_unconfirmed(struct sk_buff *skb,
 					const struct nfnl_info *info,
 					const struct nlattr * const cda[])
-- 
2.35.1



