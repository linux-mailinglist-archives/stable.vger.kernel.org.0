Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 448FDF55A2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389024AbfKHTDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732439AbfKHTDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C17082067B;
        Fri,  8 Nov 2019 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239822;
        bh=wiH+irj//p+qJgDw6BWeSlXmeKrC5A3XHnPhOweIn3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujK8WJtbktVE0Wc28VuzuDwYl5E9ip1yhqLFlnX7oOfpY2luKxv8TUDQrp9pl3ZVA
         YN+dJtzt8hjH02Y4b69NdJgS8/GkaIACqXae7UcQIOgc52a3zgwD/bLXAr50gStFmP
         IOZGcojF+nDpg2vT+M1PEj/VpQlNtIeiCSP/xyVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jonathan Berger <jonathann1@walla.com>,
        Amit Klein <aksecurity@gmail.com>,
        Benny Pinkas <benny@pinkas.net>,
        Tom Herbert <tom@herbertland.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 71/79] net/flow_dissector: switch to siphash
Date:   Fri,  8 Nov 2019 19:50:51 +0100
Message-Id: <20191108174824.523533212@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 55667441c84fa5e0911a0aac44fb059c15ba6da2 ]

UDP IPv6 packets auto flowlabels are using a 32bit secret
(static u32 hashrnd in net/core/flow_dissector.c) and
apply jhash() over fields known by the receivers.

Attackers can easily infer the 32bit secret and use this information
to identify a device and/or user, since this 32bit secret is only
set at boot time.

Really, using jhash() to generate cookies sent on the wire
is a serious security concern.

Trying to change the rol32(hash, 16) in ip6_make_flowlabel() would be
a dead end. Trying to periodically change the secret (like in sch_sfq.c)
could change paths taken in the network for long lived flows.

Let's switch to siphash, as we did in commit df453700e8d8
("inet: switch IP ID generator to siphash")

Using a cryptographically strong pseudo random function will solve this
privacy issue and more generally remove other weak points in the stack.

Packet schedulers using skb_get_hash_perturb() benefit from this change.

Fixes: b56774163f99 ("ipv6: Enable auto flow labels by default")
Fixes: 42240901f7c4 ("ipv6: Implement different admin modes for automatic flow labels")
Fixes: 67800f9b1f4e ("ipv6: Call skb_get_hash_flowi6 to get skb->hash in ip6_make_flowlabel")
Fixes: cb1ce2ef387b ("ipv6: Implement automatic flow label generation on transmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Berger <jonathann1@walla.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reported-by: Benny Pinkas <benny@pinkas.net>
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h       |    3 ++-
 include/net/flow_dissector.h |    3 ++-
 include/net/fq.h             |    2 +-
 include/net/fq_impl.h        |    4 ++--
 net/core/flow_dissector.c    |   38 ++++++++++++++++----------------------
 net/sched/sch_hhf.c          |    8 ++++----
 net/sched/sch_sfb.c          |   13 +++++++------
 net/sched/sch_sfq.c          |   14 ++++++++------
 8 files changed, 42 insertions(+), 43 deletions(-)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1251,7 +1251,8 @@ static inline __u32 skb_get_hash_flowi6(
 	return skb->hash;
 }
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb);
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb);
 
 static inline __u32 skb_get_hash_raw(const struct sk_buff *skb)
 {
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/in6.h>
+#include <linux/siphash.h>
 #include <uapi/linux/if_ether.h>
 
 /**
@@ -252,7 +253,7 @@ struct flow_keys_basic {
 struct flow_keys {
 	struct flow_dissector_key_control control;
 #define FLOW_KEYS_HASH_START_FIELD basic
-	struct flow_dissector_key_basic basic;
+	struct flow_dissector_key_basic basic __aligned(SIPHASH_ALIGNMENT);
 	struct flow_dissector_key_tags tags;
 	struct flow_dissector_key_vlan vlan;
 	struct flow_dissector_key_vlan cvlan;
--- a/include/net/fq.h
+++ b/include/net/fq.h
@@ -70,7 +70,7 @@ struct fq {
 	struct list_head backlogs;
 	spinlock_t lock;
 	u32 flows_cnt;
-	u32 perturbation;
+	siphash_key_t	perturbation;
 	u32 limit;
 	u32 memory_limit;
 	u32 memory_usage;
--- a/include/net/fq_impl.h
+++ b/include/net/fq_impl.h
@@ -118,7 +118,7 @@ static struct fq_flow *fq_flow_classify(
 
 	lockdep_assert_held(&fq->lock);
 
-	hash = skb_get_hash_perturb(skb, fq->perturbation);
+	hash = skb_get_hash_perturb(skb, &fq->perturbation);
 	idx = reciprocal_scale(hash, fq->flows_cnt);
 	flow = &fq->flows[idx];
 
@@ -307,7 +307,7 @@ static int fq_init(struct fq *fq, int fl
 	INIT_LIST_HEAD(&fq->backlogs);
 	spin_lock_init(&fq->lock);
 	fq->flows_cnt = max_t(u32, flows_cnt, 1);
-	fq->perturbation = prandom_u32();
+	get_random_bytes(&fq->perturbation, sizeof(fq->perturbation));
 	fq->quantum = 300;
 	fq->limit = 8192;
 	fq->memory_limit = 16 << 20; /* 16 MBytes */
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1077,30 +1077,21 @@ out_bad:
 }
 EXPORT_SYMBOL(__skb_flow_dissect);
 
-static u32 hashrnd __read_mostly;
+static siphash_key_t hashrnd __read_mostly;
 static __always_inline void __flow_hash_secret_init(void)
 {
 	net_get_random_once(&hashrnd, sizeof(hashrnd));
 }
 
-static __always_inline u32 __flow_hash_words(const u32 *words, u32 length,
-					     u32 keyval)
+static const void *flow_keys_hash_start(const struct flow_keys *flow)
 {
-	return jhash2(words, length, keyval);
-}
-
-static inline const u32 *flow_keys_hash_start(const struct flow_keys *flow)
-{
-	const void *p = flow;
-
-	BUILD_BUG_ON(FLOW_KEYS_HASH_OFFSET % sizeof(u32));
-	return (const u32 *)(p + FLOW_KEYS_HASH_OFFSET);
+	BUILD_BUG_ON(FLOW_KEYS_HASH_OFFSET % SIPHASH_ALIGNMENT);
+	return &flow->FLOW_KEYS_HASH_START_FIELD;
 }
 
 static inline size_t flow_keys_hash_length(const struct flow_keys *flow)
 {
 	size_t diff = FLOW_KEYS_HASH_OFFSET + sizeof(flow->addrs);
-	BUILD_BUG_ON((sizeof(*flow) - FLOW_KEYS_HASH_OFFSET) % sizeof(u32));
 	BUILD_BUG_ON(offsetof(typeof(*flow), addrs) !=
 		     sizeof(*flow) - sizeof(flow->addrs));
 
@@ -1115,7 +1106,7 @@ static inline size_t flow_keys_hash_leng
 		diff -= sizeof(flow->addrs.tipckey);
 		break;
 	}
-	return (sizeof(*flow) - diff) / sizeof(u32);
+	return sizeof(*flow) - diff;
 }
 
 __be32 flow_get_u32_src(const struct flow_keys *flow)
@@ -1181,14 +1172,15 @@ static inline void __flow_hash_consisten
 	}
 }
 
-static inline u32 __flow_hash_from_keys(struct flow_keys *keys, u32 keyval)
+static inline u32 __flow_hash_from_keys(struct flow_keys *keys,
+					const siphash_key_t *keyval)
 {
 	u32 hash;
 
 	__flow_hash_consistentify(keys);
 
-	hash = __flow_hash_words(flow_keys_hash_start(keys),
-				 flow_keys_hash_length(keys), keyval);
+	hash = siphash(flow_keys_hash_start(keys),
+		       flow_keys_hash_length(keys), keyval);
 	if (!hash)
 		hash = 1;
 
@@ -1198,12 +1190,13 @@ static inline u32 __flow_hash_from_keys(
 u32 flow_hash_from_keys(struct flow_keys *keys)
 {
 	__flow_hash_secret_init();
-	return __flow_hash_from_keys(keys, hashrnd);
+	return __flow_hash_from_keys(keys, &hashrnd);
 }
 EXPORT_SYMBOL(flow_hash_from_keys);
 
 static inline u32 ___skb_get_hash(const struct sk_buff *skb,
-				  struct flow_keys *keys, u32 keyval)
+				  struct flow_keys *keys,
+				  const siphash_key_t *keyval)
 {
 	skb_flow_dissect_flow_keys(skb, keys,
 				   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
@@ -1251,7 +1244,7 @@ u32 __skb_get_hash_symmetric(const struc
 			   NULL, 0, 0, 0,
 			   FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL);
 
-	return __flow_hash_from_keys(&keys, hashrnd);
+	return __flow_hash_from_keys(&keys, &hashrnd);
 }
 EXPORT_SYMBOL_GPL(__skb_get_hash_symmetric);
 
@@ -1271,13 +1264,14 @@ void __skb_get_hash(struct sk_buff *skb)
 
 	__flow_hash_secret_init();
 
-	hash = ___skb_get_hash(skb, &keys, hashrnd);
+	hash = ___skb_get_hash(skb, &keys, &hashrnd);
 
 	__skb_set_sw_hash(skb, hash, flow_keys_have_l4(&keys));
 }
 EXPORT_SYMBOL(__skb_get_hash);
 
-__u32 skb_get_hash_perturb(const struct sk_buff *skb, u32 perturb)
+__u32 skb_get_hash_perturb(const struct sk_buff *skb,
+			   const siphash_key_t *perturb)
 {
 	struct flow_keys keys;
 
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -4,11 +4,11 @@
  * Copyright (C) 2013 Nandita Dukkipati <nanditad@google.com>
  */
 
-#include <linux/jhash.h>
 #include <linux/jiffies.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/vmalloc.h>
+#include <linux/siphash.h>
 #include <net/pkt_sched.h>
 #include <net/sock.h>
 
@@ -125,7 +125,7 @@ struct wdrr_bucket {
 
 struct hhf_sched_data {
 	struct wdrr_bucket buckets[WDRR_BUCKET_CNT];
-	u32		   perturbation;   /* hash perturbation */
+	siphash_key_t	   perturbation;   /* hash perturbation */
 	u32		   quantum;        /* psched_mtu(qdisc_dev(sch)); */
 	u32		   drop_overlimit; /* number of times max qdisc packet
 					    * limit was hit
@@ -263,7 +263,7 @@ static enum wdrr_bucket_idx hhf_classify
 	}
 
 	/* Get hashed flow-id of the skb. */
-	hash = skb_get_hash_perturb(skb, q->perturbation);
+	hash = skb_get_hash_perturb(skb, &q->perturbation);
 
 	/* Check if this packet belongs to an already established HH flow. */
 	flow_pos = hash & HHF_BIT_MASK;
@@ -580,7 +580,7 @@ static int hhf_init(struct Qdisc *sch, s
 
 	sch->limit = 1000;
 	q->quantum = psched_mtu(qdisc_dev(sch));
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	INIT_LIST_HEAD(&q->new_buckets);
 	INIT_LIST_HEAD(&q->old_buckets);
 
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -22,7 +22,7 @@
 #include <linux/errno.h>
 #include <linux/skbuff.h>
 #include <linux/random.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/ip.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
@@ -49,7 +49,7 @@ struct sfb_bucket {
  * (Section 4.4 of SFB reference : moving hash functions)
  */
 struct sfb_bins {
-	u32		  perturbation; /* jhash perturbation */
+	siphash_key_t	  perturbation; /* siphash key */
 	struct sfb_bucket bins[SFB_LEVELS][SFB_NUMBUCKETS];
 };
 
@@ -221,7 +221,8 @@ static u32 sfb_compute_qlen(u32 *prob_r,
 
 static void sfb_init_perturbation(u32 slot, struct sfb_sched_data *q)
 {
-	q->bins[slot].perturbation = prandom_u32();
+	get_random_bytes(&q->bins[slot].perturbation,
+			 sizeof(q->bins[slot].perturbation));
 }
 
 static void sfb_swap_slot(struct sfb_sched_data *q)
@@ -318,9 +319,9 @@ static int sfb_enqueue(struct sk_buff *s
 		/* If using external classifiers, get result and record it. */
 		if (!sfb_classify(skb, fl, &ret, &salt))
 			goto other_drop;
-		sfbhash = jhash_1word(salt, q->bins[slot].perturbation);
+		sfbhash = siphash_1u32(salt, &q->bins[slot].perturbation);
 	} else {
-		sfbhash = skb_get_hash_perturb(skb, q->bins[slot].perturbation);
+		sfbhash = skb_get_hash_perturb(skb, &q->bins[slot].perturbation);
 	}
 
 
@@ -356,7 +357,7 @@ static int sfb_enqueue(struct sk_buff *s
 		/* Inelastic flow */
 		if (q->double_buffering) {
 			sfbhash = skb_get_hash_perturb(skb,
-			    q->bins[slot].perturbation);
+			    &q->bins[slot].perturbation);
 			if (!sfbhash)
 				sfbhash = 1;
 			sfb_skb_cb(skb)->hashes[slot] = sfbhash;
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -18,7 +18,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/skbuff.h>
-#include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <net/netlink.h>
@@ -121,7 +121,7 @@ struct sfq_sched_data {
 	u8		headdrop;
 	u8		maxdepth;	/* limit of packets per flow */
 
-	u32		perturbation;
+	siphash_key_t 	perturbation;
 	u8		cur_depth;	/* depth of longest slot */
 	u8		flags;
 	unsigned short  scaled_quantum; /* SFQ_ALLOT_SIZE(quantum) */
@@ -161,7 +161,7 @@ static inline struct sfq_head *sfq_dep_h
 static unsigned int sfq_hash(const struct sfq_sched_data *q,
 			     const struct sk_buff *skb)
 {
-	return skb_get_hash_perturb(skb, q->perturbation) & (q->divisor - 1);
+	return skb_get_hash_perturb(skb, &q->perturbation) & (q->divisor - 1);
 }
 
 static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
@@ -611,9 +611,11 @@ static void sfq_perturbation(struct time
 	struct sfq_sched_data *q = from_timer(q, t, perturb_timer);
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	siphash_key_t nkey;
 
+	get_random_bytes(&nkey, sizeof(nkey));
 	spin_lock(root_lock);
-	q->perturbation = prandom_u32();
+	q->perturbation = nkey;
 	if (!q->filter_list && q->tail)
 		sfq_rehash(sch);
 	spin_unlock(root_lock);
@@ -692,7 +694,7 @@ static int sfq_change(struct Qdisc *sch,
 	del_timer(&q->perturb_timer);
 	if (q->perturb_period) {
 		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
-		q->perturbation = prandom_u32();
+		get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 	}
 	sch_tree_unlock(sch);
 	kfree(p);
@@ -749,7 +751,7 @@ static int sfq_init(struct Qdisc *sch, s
 	q->quantum = psched_mtu(qdisc_dev(sch));
 	q->scaled_quantum = SFQ_ALLOT_SIZE(q->quantum);
 	q->perturb_period = 0;
-	q->perturbation = prandom_u32();
+	get_random_bytes(&q->perturbation, sizeof(q->perturbation));
 
 	if (opt) {
 		int err = sfq_change(sch, opt);


