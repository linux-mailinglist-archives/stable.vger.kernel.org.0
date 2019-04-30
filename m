Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1906F5F0
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfD3Lkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfD3Lks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA09121734;
        Tue, 30 Apr 2019 11:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624447;
        bh=vgmPRk/9/S1fAFZzg4K4FanFVfEiwbJUQ4AGa/rCjGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruOS1u+YiqKFR263LFe4O7xobL4TMqlnXG/VClL05Hl1BHfnqb3vJJIRjN9bxf6Wt
         HcpEnbQYBFWBjIdP/MgcVJcojyhV7mlKfZW9G15SfRUCBXnM5lFUtwDfhpkFp+qmfE
         hY/ko1vaoojnht35dGmgrO7R7Hrge95JFRCH8uhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.9 39/41] ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
Date:   Tue, 30 Apr 2019 13:38:50 +0200
Message-Id: <20190430113534.694357144@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 70b095c84326640eeacfd69a411db8fc36e8ab1a ]

IPV6=m
DEFRAG_IPV6=m
CONNTRACK=y yields:

net/netfilter/nf_conntrack_proto.o: In function `nf_ct_netns_do_get':
net/netfilter/nf_conntrack_proto.c:802: undefined reference to `nf_defrag_ipv6_enable'
net/netfilter/nf_conntrack_proto.o:(.rodata+0x640): undefined reference to `nf_conntrack_l4proto_icmpv6'

Setting DEFRAG_IPV6=y causes undefined references to ip6_rhash_params
ip6_frag_init and ip6_expire_frag_queue so it would be needed to force
IPV6=y too.

This patch gets rid of the 'followup linker error' by removing
the dependency of ipv6.ko symbols from netfilter ipv6 defrag.

Shared code is placed into a header, then used from both.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ipv6.h                        |   29 --------
 include/net/ipv6_frag.h                   |  104 ++++++++++++++++++++++++++++++
 net/ieee802154/6lowpan/reassembly.c       |    2 
 net/ipv6/netfilter/nf_conntrack_reasm.c   |   17 +++-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |    3 
 net/ipv6/reassembly.c                     |   92 ++------------------------
 net/openvswitch/conntrack.c               |    1 
 7 files changed, 126 insertions(+), 122 deletions(-)
 create mode 100644 include/net/ipv6_frag.h

--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -511,35 +511,6 @@ static inline bool ipv6_prefix_equal(con
 }
 #endif
 
-struct inet_frag_queue;
-
-enum ip6_defrag_users {
-	IP6_DEFRAG_LOCAL_DELIVER,
-	IP6_DEFRAG_CONNTRACK_IN,
-	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_OUT,
-	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
-	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
-	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
-};
-
-void ip6_frag_init(struct inet_frag_queue *q, const void *a);
-extern const struct rhashtable_params ip6_rhash_params;
-
-/*
- *	Equivalent of ipv4 struct ip
- */
-struct frag_queue {
-	struct inet_frag_queue	q;
-
-	int			iif;
-	unsigned int		csum;
-	__u16			nhoffset;
-	u8			ecn;
-};
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq);
-
 static inline bool ipv6_addr_any(const struct in6_addr *a)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
--- /dev/null
+++ b/include/net/ipv6_frag.h
@@ -0,0 +1,104 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _IPV6_FRAG_H
+#define _IPV6_FRAG_H
+#include <linux/kernel.h>
+#include <net/addrconf.h>
+#include <net/ipv6.h>
+#include <net/inet_frag.h>
+
+enum ip6_defrag_users {
+	IP6_DEFRAG_LOCAL_DELIVER,
+	IP6_DEFRAG_CONNTRACK_IN,
+	__IP6_DEFRAG_CONNTRACK_IN	= IP6_DEFRAG_CONNTRACK_IN + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_OUT,
+	__IP6_DEFRAG_CONNTRACK_OUT	= IP6_DEFRAG_CONNTRACK_OUT + USHRT_MAX,
+	IP6_DEFRAG_CONNTRACK_BRIDGE_IN,
+	__IP6_DEFRAG_CONNTRACK_BRIDGE_IN = IP6_DEFRAG_CONNTRACK_BRIDGE_IN + USHRT_MAX,
+};
+
+/*
+ *	Equivalent of ipv4 struct ip
+ */
+struct frag_queue {
+	struct inet_frag_queue	q;
+
+	int			iif;
+	__u16			nhoffset;
+	u8			ecn;
+};
+
+#if IS_ENABLED(CONFIG_IPV6)
+static inline void ip6frag_init(struct inet_frag_queue *q, const void *a)
+{
+	struct frag_queue *fq = container_of(q, struct frag_queue, q);
+	const struct frag_v6_compare_key *key = a;
+
+	q->key.v6 = *key;
+	fq->ecn = 0;
+}
+
+static inline u32 ip6frag_key_hashfn(const void *data, u32 len, u32 seed)
+{
+	return jhash2(data,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline u32 ip6frag_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct inet_frag_queue *fq = data;
+
+	return jhash2((const u32 *)&fq->key.v6,
+		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
+}
+
+static inline int
+ip6frag_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
+{
+	const struct frag_v6_compare_key *key = arg->key;
+	const struct inet_frag_queue *fq = ptr;
+
+	return !!memcmp(&fq->key, key, sizeof(*key));
+}
+
+static inline void
+ip6frag_expire_frag_queue(struct net *net, struct frag_queue *fq)
+{
+	struct net_device *dev = NULL;
+	struct sk_buff *head;
+
+	rcu_read_lock();
+	spin_lock(&fq->q.lock);
+
+	if (fq->q.flags & INET_FRAG_COMPLETE)
+		goto out;
+
+	inet_frag_kill(&fq->q);
+
+	dev = dev_get_by_index_rcu(net, fq->iif);
+	if (!dev)
+		goto out;
+
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
+	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
+
+	/* Don't send error if the first segment did not arrive. */
+	head = fq->q.fragments;
+	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
+		goto out;
+
+	head->dev = dev;
+	skb_get(head);
+	spin_unlock(&fq->q.lock);
+
+	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
+	kfree_skb(head);
+	goto out_rcu_unlock;
+
+out:
+	spin_unlock(&fq->q.lock);
+out_rcu_unlock:
+	rcu_read_unlock();
+	inet_frag_put(&fq->q);
+}
+#endif
+#endif
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -25,7 +25,7 @@
 
 #include <net/ieee802154_netdev.h>
 #include <net/6lowpan.h>
-#include <net/ipv6.h>
+#include <net/ipv6_frag.h>
 #include <net/inet_frag.h>
 
 #include "6lowpan_i.h"
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -33,9 +33,8 @@
 
 #include <net/sock.h>
 #include <net/snmp.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
-#include <net/ipv6.h>
 #include <net/protocol.h>
 #include <net/transp_v6.h>
 #include <net/rawv6.h>
@@ -158,7 +157,7 @@ static void nf_ct_frag6_expire(unsigned
 	fq = container_of((struct inet_frag_queue *)data, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, nf_frag.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 /* Creation primitives. */
@@ -634,16 +633,24 @@ static struct pernet_operations nf_ct_ne
 	.exit = nf_ct_net_exit,
 };
 
+static const struct rhashtable_params nfct_rhash_params = {
+	.head_offset		= offsetof(struct inet_frag_queue, node),
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
+	.automatic_shrinking	= true,
+};
+
 int nf_ct_frag6_init(void)
 {
 	int ret = 0;
 
-	nf_frags.constructor = ip6_frag_init;
+	nf_frags.constructor = ip6frag_init;
 	nf_frags.destructor = NULL;
 	nf_frags.qsize = sizeof(struct frag_queue);
 	nf_frags.frag_expire = nf_ct_frag6_expire;
 	nf_frags.frags_cache_name = nf_frags_cache_name;
-	nf_frags.rhash_params = ip6_rhash_params;
+	nf_frags.rhash_params = nfct_rhash_params;
 	ret = inet_frags_init(&nf_frags);
 	if (ret)
 		goto out;
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -14,8 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/icmp.h>
 #include <linux/sysctl.h>
-#include <net/ipv6.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -57,7 +57,7 @@
 #include <net/rawv6.h>
 #include <net/ndisc.h>
 #include <net/addrconf.h>
-#include <net/inet_frag.h>
+#include <net/ipv6_frag.h>
 #include <net/inet_ecn.h>
 
 static const char ip6_frag_cache_name[] = "ip6-frags";
@@ -79,61 +79,6 @@ static struct inet_frags ip6_frags;
 static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *prev,
 			  struct net_device *dev);
 
-void ip6_frag_init(struct inet_frag_queue *q, const void *a)
-{
-	struct frag_queue *fq = container_of(q, struct frag_queue, q);
-	const struct frag_v6_compare_key *key = a;
-
-	q->key.v6 = *key;
-	fq->ecn = 0;
-}
-EXPORT_SYMBOL(ip6_frag_init);
-
-void ip6_expire_frag_queue(struct net *net, struct frag_queue *fq)
-{
-	struct net_device *dev = NULL;
-	struct sk_buff *head;
-
-	rcu_read_lock();
-	spin_lock(&fq->q.lock);
-
-	if (fq->q.flags & INET_FRAG_COMPLETE)
-		goto out;
-
-	inet_frag_kill(&fq->q);
-
-	dev = dev_get_by_index_rcu(net, fq->iif);
-	if (!dev)
-		goto out;
-
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMFAILS);
-	__IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_REASMTIMEOUT);
-
-	/* Don't send error if the first segment did not arrive. */
-	head = fq->q.fragments;
-	if (!(fq->q.flags & INET_FRAG_FIRST_IN) || !head)
-		goto out;
-
-	/* But use as source device on which LAST ARRIVED
-	 * segment was received. And do not use fq->dev
-	 * pointer directly, device might already disappeared.
-	 */
-	head->dev = dev;
-	skb_get(head);
-	spin_unlock(&fq->q.lock);
-
-	icmpv6_send(head, ICMPV6_TIME_EXCEED, ICMPV6_EXC_FRAGTIME, 0);
-	kfree_skb(head);
-	goto out_rcu_unlock;
-
-out:
-	spin_unlock(&fq->q.lock);
-out_rcu_unlock:
-	rcu_read_unlock();
-	inet_frag_put(&fq->q);
-}
-EXPORT_SYMBOL(ip6_expire_frag_queue);
-
 static void ip6_frag_expire(unsigned long data)
 {
 	struct frag_queue *fq;
@@ -142,7 +87,7 @@ static void ip6_frag_expire(unsigned lon
 	fq = container_of((struct inet_frag_queue *)data, struct frag_queue, q);
 	net = container_of(fq->q.net, struct net, ipv6.frags);
 
-	ip6_expire_frag_queue(net, fq);
+	ip6frag_expire_frag_queue(net, fq);
 }
 
 static struct frag_queue *
@@ -701,42 +646,19 @@ static struct pernet_operations ip6_frag
 	.exit = ipv6_frags_exit_net,
 };
 
-static u32 ip6_key_hashfn(const void *data, u32 len, u32 seed)
-{
-	return jhash2(data,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static u32 ip6_obj_hashfn(const void *data, u32 len, u32 seed)
-{
-	const struct inet_frag_queue *fq = data;
-
-	return jhash2((const u32 *)&fq->key.v6,
-		      sizeof(struct frag_v6_compare_key) / sizeof(u32), seed);
-}
-
-static int ip6_obj_cmpfn(struct rhashtable_compare_arg *arg, const void *ptr)
-{
-	const struct frag_v6_compare_key *key = arg->key;
-	const struct inet_frag_queue *fq = ptr;
-
-	return !!memcmp(&fq->key, key, sizeof(*key));
-}
-
-const struct rhashtable_params ip6_rhash_params = {
+static const struct rhashtable_params ip6_rhash_params = {
 	.head_offset		= offsetof(struct inet_frag_queue, node),
-	.hashfn			= ip6_key_hashfn,
-	.obj_hashfn		= ip6_obj_hashfn,
-	.obj_cmpfn		= ip6_obj_cmpfn,
+	.hashfn			= ip6frag_key_hashfn,
+	.obj_hashfn		= ip6frag_obj_hashfn,
+	.obj_cmpfn		= ip6frag_obj_cmpfn,
 	.automatic_shrinking	= true,
 };
-EXPORT_SYMBOL(ip6_rhash_params);
 
 int __init ipv6_frag_init(void)
 {
 	int ret;
 
-	ip6_frags.constructor = ip6_frag_init;
+	ip6_frags.constructor = ip6frag_init;
 	ip6_frags.destructor = NULL;
 	ip6_frags.qsize = sizeof(struct frag_queue);
 	ip6_frags.frag_expire = ip6_frag_expire;
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/ipv6/nf_defrag_ipv6.h>
+#include <net/ipv6_frag.h>
 
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <linux/netfilter/nf_nat.h>


