Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C426012EC68
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgABWSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:33044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgABWSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:18:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BF9A21582;
        Thu,  2 Jan 2020 22:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003485;
        bh=YGM2qFamnFc9uygEBCTbK7gxDIsdjWegmSMNMdx/SqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TxHwad7xjLUWLUkJWBtrxsfvYsNc5wSrLBjbXaux1KqzJSADr5CV3TxaIW3cGYn7E
         lazS+yL7gKZmViH4qfnRW5tLEiTdRagjOixwOBmcl7saVBI+3GhQVehim5/nW1Ege+
         sOTpvxmC7ZHnWoQuCkyRjAXT7Mdw9y19V5+pn1Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 181/191] tcp/dccp: fix possible race __inet_lookup_established()
Date:   Thu,  2 Jan 2020 23:07:43 +0100
Message-Id: <20200102215848.703107722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 8dbd76e79a16b45b2ccb01d2f2e08dbf64e71e40 ]

Michal Kubecek and Firo Yang did a very nice analysis of crashes
happening in __inet_lookup_established().

Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
(via a close()/socket()/listen() cycle) without a RCU grace period,
I should not have changed listeners linkage in their hash table.

They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
so that a lookup can detect a socket in a hash list was moved in
another one.

Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
merge conflict for v4/v6 ordering fix"), we have to add
hlist_nulls_add_tail_rcu() helper.

Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Michal Kubecek <mkubecek@suse.cz>
Reported-by: Firo Yang <firo.yang@suse.com>
Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rculist_nulls.h |   37 +++++++++++++++++++++++++++++++++++++
 include/net/inet_hashtables.h |   12 +++++++++---
 include/net/sock.h            |    5 +++++
 net/ipv4/inet_diag.c          |    3 ++-
 net/ipv4/inet_hashtables.c    |   16 ++++++++--------
 net/ipv4/tcp_ipv4.c           |    7 ++++---
 6 files changed, 65 insertions(+), 15 deletions(-)

--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -101,6 +101,43 @@ static inline void hlist_nulls_add_head_
 }
 
 /**
+ * hlist_nulls_add_tail_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist_nulls,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_nulls_add_head_rcu()
+ * or hlist_nulls_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_nulls_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_nulls_add_tail_rcu(struct hlist_nulls_node *n,
+					    struct hlist_nulls_head *h)
+{
+	struct hlist_nulls_node *i, *last = NULL;
+
+	/* Note: write side code, so rcu accessors are not needed. */
+	for (i = h->first; !is_a_nulls(i); i = i->next)
+		last = i;
+
+	if (last) {
+		n->next = last->next;
+		n->pprev = &last->next;
+		rcu_assign_pointer(hlist_next_rcu(last), n);
+	} else {
+		hlist_nulls_add_head_rcu(n, h);
+	}
+}
+
+/**
  * hlist_nulls_for_each_entry_rcu - iterate over rcu list of given type
  * @tpos:	the type * to use as a loop cursor.
  * @pos:	the &struct hlist_nulls_node to use as a loop cursor.
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -103,13 +103,19 @@ struct inet_bind_hashbucket {
 	struct hlist_head	chain;
 };
 
-/*
- * Sockets can be hashed in established or listening table
+/* Sockets can be hashed in established or listening table.
+ * We must use different 'nulls' end-of-chain value for all hash buckets :
+ * A socket might transition from ESTABLISH to LISTEN state without
+ * RCU grace period. A lookup in ehash table needs to handle this case.
  */
+#define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
 	unsigned int		count;
-	struct hlist_head	head;
+	union {
+		struct hlist_head	head;
+		struct hlist_nulls_head	nulls_head;
+	};
 };
 
 /* This is for listening sockets, thus all sockets which possess wildcards. */
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -723,6 +723,11 @@ static inline void __sk_nulls_add_node_r
 	hlist_nulls_add_head_rcu(&sk->sk_nulls_node, list);
 }
 
+static inline void __sk_nulls_add_node_tail_rcu(struct sock *sk, struct hlist_nulls_head *list)
+{
+	hlist_nulls_add_tail_rcu(&sk->sk_nulls_node, list);
+}
+
 static inline void sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_head *list)
 {
 	sock_hold(sk);
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -914,11 +914,12 @@ void inet_diag_dump_icsk(struct inet_has
 
 		for (i = s_i; i < INET_LHTABLE_SIZE; i++) {
 			struct inet_listen_hashbucket *ilb;
+			struct hlist_nulls_node *node;
 
 			num = 0;
 			ilb = &hashinfo->listening_hash[i];
 			spin_lock(&ilb->lock);
-			sk_for_each(sk, &ilb->head) {
+			sk_nulls_for_each(sk, node, &ilb->nulls_head) {
 				struct inet_sock *inet = inet_sk(sk);
 
 				if (!net_eq(sock_net(sk), net))
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -516,10 +516,11 @@ static int inet_reuseport_add_sock(struc
 				   struct inet_listen_hashbucket *ilb)
 {
 	struct inet_bind_bucket *tb = inet_csk(sk)->icsk_bind_hash;
+	const struct hlist_nulls_node *node;
 	struct sock *sk2;
 	kuid_t uid = sock_i_uid(sk);
 
-	sk_for_each_rcu(sk2, &ilb->head) {
+	sk_nulls_for_each_rcu(sk2, node, &ilb->nulls_head) {
 		if (sk2 != sk &&
 		    sk2->sk_family == sk->sk_family &&
 		    ipv6_only_sock(sk2) == ipv6_only_sock(sk) &&
@@ -555,9 +556,9 @@ int __inet_hash(struct sock *sk, struct
 	}
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
 		sk->sk_family == AF_INET6)
-		hlist_add_tail_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
 	else
-		hlist_add_head_rcu(&sk->sk_node, &ilb->head);
+		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	inet_hash2(hashinfo, sk);
 	ilb->count++;
 	sock_set_flag(sk, SOCK_RCU_FREE);
@@ -606,11 +607,9 @@ void inet_unhash(struct sock *sk)
 		reuseport_detach_sock(sk);
 	if (ilb) {
 		inet_unhash2(hashinfo, sk);
-		 __sk_del_node_init(sk);
-		 ilb->count--;
-	} else {
-		__sk_nulls_del_node_init_rcu(sk);
+		ilb->count--;
 	}
+	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 unlock:
 	spin_unlock_bh(lock);
@@ -750,7 +749,8 @@ void inet_hashinfo_init(struct inet_hash
 
 	for (i = 0; i < INET_LHTABLE_SIZE; i++) {
 		spin_lock_init(&h->listening_hash[i].lock);
-		INIT_HLIST_HEAD(&h->listening_hash[i].head);
+		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
+				      i + LISTENING_NULLS_BASE);
 		h->listening_hash[i].count = 0;
 	}
 
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2149,13 +2149,14 @@ static void *listening_get_next(struct s
 	struct tcp_iter_state *st = seq->private;
 	struct net *net = seq_file_net(seq);
 	struct inet_listen_hashbucket *ilb;
+	struct hlist_nulls_node *node;
 	struct sock *sk = cur;
 
 	if (!sk) {
 get_head:
 		ilb = &tcp_hashinfo.listening_hash[st->bucket];
 		spin_lock(&ilb->lock);
-		sk = sk_head(&ilb->head);
+		sk = sk_nulls_head(&ilb->nulls_head);
 		st->offset = 0;
 		goto get_sk;
 	}
@@ -2163,9 +2164,9 @@ get_head:
 	++st->num;
 	++st->offset;
 
-	sk = sk_next(sk);
+	sk = sk_nulls_next(sk);
 get_sk:
-	sk_for_each_from(sk) {
+	sk_nulls_for_each_from(sk, node) {
 		if (!net_eq(sock_net(sk), net))
 			continue;
 		if (sk->sk_family == afinfo->family)


