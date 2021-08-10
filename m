Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B883E8063
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhHJRsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235698AbhHJRq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:46:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BC6B61269;
        Tue, 10 Aug 2021 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617231;
        bh=fNPtfrp28LaSfSpbWJM34vfHfDNjAfRX7etTHkIj/xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvLGqX/tW3j+mNHMVfovdDVoA6MEXubql0KMq/lrqqCZOSqGnLYv4cM8uZr5JWYPM
         05k0j8jT304apQ15jKmXery5NrhRcWf91NrY5Pj2rX4L8SK5LZkse8rXeY58vCE2+L
         FI6hUBaxxXFCpI3C88yGPK4UgFwd1/vd3qG+pbf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Varad Gautam <varad.gautam@suse.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH 5.10 102/135] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Date:   Tue, 10 Aug 2021 19:30:36 +0200
Message-Id: <20210810172959.224082888@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

commit 2580d3f40022642452dd8422bfb8c22e54cf84bb upstream.

xfrm_bydst_resize() calls synchronize_rcu() while holding
hash_resize_mutex. But then on PREEMPT_RT configurations,
xfrm_policy_lookup_bytype() may acquire that mutex while running in an
RCU read side critical section. This results in a deadlock.

In fact the scope of hash_resize_mutex is way beyond the purpose of
xfrm_policy_lookup_bytype() to just fetch a coherent and stable policy
for a given destination/direction, along with other details.

The lower level net->xfrm.xfrm_policy_lock, which among other things
protects per destination/direction references to policy entries, is
enough to serialize and benefit from priority inheritance against the
write side. As a bonus, it makes it officially a per network namespace
synchronization business where a policy table resize on namespace A
shouldn't block a policy lookup on namespace B.

Fixes: 77cc278f7b20 (xfrm: policy: Use sequence counters with associated lock)
Cc: stable@vger.kernel.org
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Varad Gautam <varad.gautam@suse.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netns/xfrm.h |    1 +
 net/xfrm/xfrm_policy.c   |   17 ++++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -74,6 +74,7 @@ struct netns_xfrm {
 #endif
 	spinlock_t		xfrm_state_lock;
 	seqcount_t		xfrm_state_hash_generation;
+	seqcount_spinlock_t	xfrm_policy_hash_generation;
 
 	spinlock_t xfrm_policy_lock;
 	struct mutex xfrm_cfg_mutex;
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -155,7 +155,6 @@ static struct xfrm_policy_afinfo const _
 						__read_mostly;
 
 static struct kmem_cache *xfrm_dst_cache __ro_after_init;
-static __read_mostly seqcount_mutex_t xfrm_policy_hash_generation;
 
 static struct rhashtable xfrm_policy_inexact_table;
 static const struct rhashtable_params xfrm_pol_inexact_params;
@@ -585,7 +584,7 @@ static void xfrm_bydst_resize(struct net
 		return;
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
-	write_seqcount_begin(&xfrm_policy_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 
 	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
 				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
@@ -596,7 +595,7 @@ static void xfrm_bydst_resize(struct net
 	rcu_assign_pointer(net->xfrm.policy_bydst[dir].table, ndst);
 	net->xfrm.policy_bydst[dir].hmask = nhashmask;
 
-	write_seqcount_end(&xfrm_policy_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	synchronize_rcu();
@@ -1245,7 +1244,7 @@ static void xfrm_hash_rebuild(struct wor
 	} while (read_seqretry(&net->xfrm.policy_hthresh.lock, seq));
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
-	write_seqcount_begin(&xfrm_policy_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 
 	/* make sure that we can insert the indirect policies again before
 	 * we start with destructive action.
@@ -1354,7 +1353,7 @@ static void xfrm_hash_rebuild(struct wor
 
 out_unlock:
 	__xfrm_policy_inexact_flush(net);
-	write_seqcount_end(&xfrm_policy_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	mutex_unlock(&hash_resize_mutex);
@@ -2095,9 +2094,9 @@ static struct xfrm_policy *xfrm_policy_l
 	rcu_read_lock();
  retry:
 	do {
-		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
+		sequence = read_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 		chain = policy_hash_direct(net, daddr, saddr, family, dir);
-	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
+	} while (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence));
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2128,7 +2127,7 @@ static struct xfrm_policy *xfrm_policy_l
 	}
 
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
+	if (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence))
 		goto retry;
 
 	if (ret && !xfrm_pol_hold_rcu(ret))
@@ -4123,6 +4122,7 @@ static int __net_init xfrm_net_init(stru
 	/* Initialize the per-net locks here */
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
 	spin_lock_init(&net->xfrm.xfrm_policy_lock);
+	seqcount_spinlock_init(&net->xfrm.xfrm_policy_hash_generation, &net->xfrm.xfrm_policy_lock);
 	mutex_init(&net->xfrm.xfrm_cfg_mutex);
 
 	rv = xfrm_statistics_init(net);
@@ -4167,7 +4167,6 @@ void __init xfrm_init(void)
 {
 	register_pernet_subsys(&xfrm_net_ops);
 	xfrm_dev_init();
-	seqcount_mutex_init(&xfrm_policy_hash_generation, &hash_resize_mutex);
 	xfrm_input_init();
 
 #ifdef CONFIG_XFRM_ESPINTCP


