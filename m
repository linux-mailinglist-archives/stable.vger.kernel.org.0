Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0F166492F
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbjAJSTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239202AbjAJSS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:18:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE16A8BF23
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C20BB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0038C433D2;
        Tue, 10 Jan 2023 18:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374587;
        bh=PG9bbsNRsUoTO+fMT1NbkkRe2sG2BtS68LlzWi+wv4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQupqi7RiZQ8YxzNVBu96X8MlQhgpvJBJfmjG1t4T6aEew0EYczPjkT8fahV/TacJ
         8HHrlUchK0CCAKr0xdvfiO+5EwPBKZydCQzDG8401e2Qoj+IHrydO3o06Phf21umEs
         UEIYosuTs7wulmJOFiM+B/RnPNeX7989Ep987vv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Slaby <jirislaby@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/159] tcp: Add TIME_WAIT sockets in bhash2.
Date:   Tue, 10 Jan 2023 19:03:32 +0100
Message-Id: <20230110180020.340075157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 936a192f974018b4f6040f6f77b1cc1e75bd8666 ]

Jiri Slaby reported regression of bind() with a simple repro. [0]

The repro creates a TIME_WAIT socket and tries to bind() a new socket
with the same local address and port.  Before commit 28044fc1d495 ("net:
Add a bhash2 table hashed by port and address"), the bind() failed with
-EADDRINUSE, but now it succeeds.

The cited commit should have put TIME_WAIT sockets into bhash2; otherwise,
inet_bhash2_conflict() misses TIME_WAIT sockets when validating bind()
requests if the address is not a wildcard one.

The straight option is to move sk_bind2_node from struct sock to struct
sock_common to add twsk to bhash2 as implemented as RFC. [1]  However, the
binary layout change in the struct sock could affect performances moving
hot fields on different cachelines.

To avoid that, we add another TIME_WAIT list in inet_bind2_bucket and check
it while validating bind().

[0]: https://lore.kernel.org/netdev/6b971a4e-c7d8-411e-1f92-fda29b5b2fb9@kernel.org/
[1]: https://lore.kernel.org/netdev/20221221151258.25748-2-kuniyu@amazon.com/

Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h    |  4 ++++
 include/net/inet_timewait_sock.h |  5 +++++
 net/ipv4/inet_connection_sock.c  | 26 ++++++++++++++++++++++----
 net/ipv4/inet_hashtables.c       |  8 +++++---
 net/ipv4/inet_timewait_sock.c    | 31 +++++++++++++++++++++++++++++--
 5 files changed, 65 insertions(+), 9 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 69174093078f..99bd823e97f6 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -108,6 +108,10 @@ struct inet_bind2_bucket {
 	struct hlist_node	node;
 	/* List of sockets hashed to this bucket */
 	struct hlist_head	owners;
+	/* bhash has twsk in owners, but bhash2 has twsk in
+	 * deathrow not to add a member in struct sock_common.
+	 */
+	struct hlist_head	deathrow;
 };
 
 static inline struct net *ib_net(const struct inet_bind_bucket *ib)
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 5b47545f22d3..4a8e578405cb 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -73,9 +73,14 @@ struct inet_timewait_sock {
 	u32			tw_priority;
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
+	struct inet_bind2_bucket	*tw_tb2;
+	struct hlist_node		tw_bind2_node;
 };
 #define tw_tclass tw_tos
 
+#define twsk_for_each_bound_bhash2(__tw, list) \
+	hlist_for_each_entry(__tw, list, tw_bind2_node)
+
 static inline struct inet_timewait_sock *inet_twsk(const struct sock *sk)
 {
 	return (struct inet_timewait_sock *)sk;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 4a34bc7cb15e..0465ada82799 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -173,22 +173,40 @@ static bool inet_bind_conflict(const struct sock *sk, struct sock *sk2,
 	return false;
 }
 
+static bool __inet_bhash2_conflict(const struct sock *sk, struct sock *sk2,
+				   kuid_t sk_uid, bool relax,
+				   bool reuseport_cb_ok, bool reuseport_ok)
+{
+	if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
+		return false;
+
+	return inet_bind_conflict(sk, sk2, sk_uid, relax,
+				  reuseport_cb_ok, reuseport_ok);
+}
+
 static bool inet_bhash2_conflict(const struct sock *sk,
 				 const struct inet_bind2_bucket *tb2,
 				 kuid_t sk_uid,
 				 bool relax, bool reuseport_cb_ok,
 				 bool reuseport_ok)
 {
+	struct inet_timewait_sock *tw2;
 	struct sock *sk2;
 
 	sk_for_each_bound_bhash2(sk2, &tb2->owners) {
-		if (sk->sk_family == AF_INET && ipv6_only_sock(sk2))
-			continue;
+		if (__inet_bhash2_conflict(sk, sk2, sk_uid, relax,
+					   reuseport_cb_ok, reuseport_ok))
+			return true;
+	}
 
-		if (inet_bind_conflict(sk, sk2, sk_uid, relax,
-				       reuseport_cb_ok, reuseport_ok))
+	twsk_for_each_bound_bhash2(tw2, &tb2->deathrow) {
+		sk2 = (struct sock *)tw2;
+
+		if (__inet_bhash2_conflict(sk, sk2, sk_uid, relax,
+					   reuseport_cb_ok, reuseport_ok))
 			return true;
 	}
+
 	return false;
 }
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 3cec471a2cd2..67f5e5440802 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -116,6 +116,7 @@ static void inet_bind2_bucket_init(struct inet_bind2_bucket *tb,
 #endif
 		tb->rcv_saddr = sk->sk_rcv_saddr;
 	INIT_HLIST_HEAD(&tb->owners);
+	INIT_HLIST_HEAD(&tb->deathrow);
 	hlist_add_head(&tb->node, &head->chain);
 }
 
@@ -137,7 +138,7 @@ struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *cachep,
 /* Caller must hold hashbucket lock for this tb with local BH disabled */
 void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb)
 {
-	if (hlist_empty(&tb->owners)) {
+	if (hlist_empty(&tb->owners) && hlist_empty(&tb->deathrow)) {
 		__hlist_del(&tb->node);
 		kmem_cache_free(cachep, tb);
 	}
@@ -1103,15 +1104,16 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, tb2, port);
 
-	spin_unlock(&head2->lock);
-
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
 		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
+
+	spin_unlock(&head2->lock);
 	spin_unlock(&head->lock);
+
 	if (tw)
 		inet_twsk_deschedule_put(tw);
 	local_bh_enable();
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 66fc940f9521..1d77d992e6e7 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -29,6 +29,7 @@
 void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
 			  struct inet_hashinfo *hashinfo)
 {
+	struct inet_bind2_bucket *tb2 = tw->tw_tb2;
 	struct inet_bind_bucket *tb = tw->tw_tb;
 
 	if (!tb)
@@ -37,6 +38,11 @@ void inet_twsk_bind_unhash(struct inet_timewait_sock *tw,
 	__hlist_del(&tw->tw_bind_node);
 	tw->tw_tb = NULL;
 	inet_bind_bucket_destroy(hashinfo->bind_bucket_cachep, tb);
+
+	__hlist_del(&tw->tw_bind2_node);
+	tw->tw_tb2 = NULL;
+	inet_bind2_bucket_destroy(hashinfo->bind2_bucket_cachep, tb2);
+
 	__sock_put((struct sock *)tw);
 }
 
@@ -45,7 +51,7 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 {
 	struct inet_hashinfo *hashinfo = tw->tw_dr->hashinfo;
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, tw->tw_hash);
-	struct inet_bind_hashbucket *bhead;
+	struct inet_bind_hashbucket *bhead, *bhead2;
 
 	spin_lock(lock);
 	sk_nulls_del_node_init_rcu((struct sock *)tw);
@@ -54,9 +60,13 @@ static void inet_twsk_kill(struct inet_timewait_sock *tw)
 	/* Disassociate with bind bucket. */
 	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), tw->tw_num,
 			hashinfo->bhash_size)];
+	bhead2 = inet_bhashfn_portaddr(hashinfo, (struct sock *)tw,
+				       twsk_net(tw), tw->tw_num);
 
 	spin_lock(&bhead->lock);
+	spin_lock(&bhead2->lock);
 	inet_twsk_bind_unhash(tw, hashinfo);
+	spin_unlock(&bhead2->lock);
 	spin_unlock(&bhead->lock);
 
 	refcount_dec(&tw->tw_dr->tw_refcount);
@@ -93,6 +103,12 @@ static void inet_twsk_add_bind_node(struct inet_timewait_sock *tw,
 	hlist_add_head(&tw->tw_bind_node, list);
 }
 
+static void inet_twsk_add_bind2_node(struct inet_timewait_sock *tw,
+				     struct hlist_head *list)
+{
+	hlist_add_head(&tw->tw_bind2_node, list);
+}
+
 /*
  * Enter the time wait state. This is called with locally disabled BH.
  * Essentially we whip up a timewait bucket, copy the relevant info into it
@@ -105,17 +121,28 @@ void inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 	struct inet_ehash_bucket *ehead = inet_ehash_bucket(hashinfo, sk->sk_hash);
 	spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
-	struct inet_bind_hashbucket *bhead;
+	struct inet_bind_hashbucket *bhead, *bhead2;
+
 	/* Step 1: Put TW into bind hash. Original socket stays there too.
 	   Note, that any socket with inet->num != 0 MUST be bound in
 	   binding cache, even if it is closed.
 	 */
 	bhead = &hashinfo->bhash[inet_bhashfn(twsk_net(tw), inet->inet_num,
 			hashinfo->bhash_size)];
+	bhead2 = inet_bhashfn_portaddr(hashinfo, sk, twsk_net(tw), inet->inet_num);
+
 	spin_lock(&bhead->lock);
+	spin_lock(&bhead2->lock);
+
 	tw->tw_tb = icsk->icsk_bind_hash;
 	WARN_ON(!icsk->icsk_bind_hash);
 	inet_twsk_add_bind_node(tw, &tw->tw_tb->owners);
+
+	tw->tw_tb2 = icsk->icsk_bind2_hash;
+	WARN_ON(!icsk->icsk_bind2_hash);
+	inet_twsk_add_bind2_node(tw, &tw->tw_tb2->deathrow);
+
+	spin_unlock(&bhead2->lock);
 	spin_unlock(&bhead->lock);
 
 	spin_lock(lock);
-- 
2.35.1



