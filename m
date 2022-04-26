Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10E0C50F5FA
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345378AbiDZIlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345641AbiDZIjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6283EB9A;
        Tue, 26 Apr 2022 01:30:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38EEFB81CF3;
        Tue, 26 Apr 2022 08:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7E1C385A0;
        Tue, 26 Apr 2022 08:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961833;
        bh=LwGGb6JIOLex05rke6+xcqEbh2ZONWEwTAe9M3fkFl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mp4rJO7jPomeFCKzC+5LJ0XqhcSa3RB18KWd7s9YqcL6nw74murgejsjqz3sLT9TD
         QTJe2a/kbp7DCi8i36a/WgMlgA2oY+nLPTl+axIRvLEAPYreFGgQLBwZ0JpPZbdQub
         PGrY6KqF9oXB/kIVtit8FlOeo/r+vyN+4+dzP+fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Dias <rdias@singlestore.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/62] tcp: fix race condition when creating child sockets from syncookies
Date:   Tue, 26 Apr 2022 10:20:46 +0200
Message-Id: <20220426081737.403701275@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
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

From: Ricardo Dias <rdias@singlestore.com>

[ Upstream commit 01770a166165738a6e05c3d911fb4609cc4eb416 ]

When the TCP stack is in SYN flood mode, the server child socket is
created from the SYN cookie received in a TCP packet with the ACK flag
set.

The child socket is created when the server receives the first TCP
packet with a valid SYN cookie from the client. Usually, this packet
corresponds to the final step of the TCP 3-way handshake, the ACK
packet. But is also possible to receive a valid SYN cookie from the
first TCP data packet sent by the client, and thus create a child socket
from that SYN cookie.

Since a client socket is ready to send data as soon as it receives the
SYN+ACK packet from the server, the client can send the ACK packet (sent
by the TCP stack code), and the first data packet (sent by the userspace
program) almost at the same time, and thus the server will equally
receive the two TCP packets with valid SYN cookies almost at the same
instant.

When such event happens, the TCP stack code has a race condition that
occurs between the momement a lookup is done to the established
connections hashtable to check for the existence of a connection for the
same client, and the moment that the child socket is added to the
established connections hashtable. As a consequence, this race condition
can lead to a situation where we add two child sockets to the
established connections hashtable and deliver two sockets to the
userspace program to the same client.

This patch fixes the race condition by checking if an existing child
socket exists for the same client when we are adding the second child
socket to the established connections socket. If an existing child
socket exists, we drop the packet and discard the second child socket
to the same client.

Signed-off-by: Ricardo Dias <rdias@singlestore.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20201120111133.GA67501@rdias-suse-pc.lan
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h   |  5 ++-
 net/dccp/ipv4.c                 |  2 +-
 net/dccp/ipv6.c                 |  2 +-
 net/ipv4/inet_connection_sock.c |  2 +-
 net/ipv4/inet_hashtables.c      | 68 +++++++++++++++++++++++++++++----
 net/ipv4/tcp_ipv4.c             | 15 +++++++-
 net/ipv6/tcp_ipv6.c             | 13 ++++++-
 7 files changed, 91 insertions(+), 16 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 59802eb8d2cc..a1869a678944 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -247,8 +247,9 @@ void inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 			 unsigned long high_limit);
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h);
 
-bool inet_ehash_insert(struct sock *sk, struct sock *osk);
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk);
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk);
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk,
+			 bool *found_dup_sk);
 int __inet_hash(struct sock *sk, struct sock *osk);
 int inet_hash(struct sock *sk);
 void inet_unhash(struct sock *sk);
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index d19557c6d04b..7cf903f9e29a 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -427,7 +427,7 @@ struct sock *dccp_v4_request_recv_sock(const struct sock *sk,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	if (*own_req)
 		ireq->ireq_opt = NULL;
 	else
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 9f73ccf46c9b..7c24927e9c2c 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -538,7 +538,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 		dccp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
 		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 85a88425edc4..6cbf0db57ad0 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -791,7 +791,7 @@ static void reqsk_queue_hash_req(struct request_sock *req,
 	timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
 	mod_timer(&req->rsk_timer, jiffies + timeout);
 
-	inet_ehash_insert(req_to_sk(req), NULL);
+	inet_ehash_insert(req_to_sk(req), NULL, NULL);
 	/* before letting lookups find us, make sure all req fields
 	 * are committed to memory and refcnt initialized.
 	 */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 72fdf1fcbcaa..cbbeb0eea0c3 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -20,6 +20,9 @@
 #include <net/addrconf.h>
 #include <net/inet_connection_sock.h>
 #include <net/inet_hashtables.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/inet6_hashtables.h>
+#endif
 #include <net/secure_seq.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -470,10 +473,52 @@ static u32 inet_sk_port_offset(const struct sock *sk)
 					  inet->inet_dport);
 }
 
-/* insert a socket into ehash, and eventually remove another one
- * (The another one can be a SYN_RECV or TIMEWAIT
+/* Searches for an exsiting socket in the ehash bucket list.
+ * Returns true if found, false otherwise.
  */
-bool inet_ehash_insert(struct sock *sk, struct sock *osk)
+static bool inet_ehash_lookup_by_sk(struct sock *sk,
+				    struct hlist_nulls_head *list)
+{
+	const __portpair ports = INET_COMBINED_PORTS(sk->sk_dport, sk->sk_num);
+	const int sdif = sk->sk_bound_dev_if;
+	const int dif = sk->sk_bound_dev_if;
+	const struct hlist_nulls_node *node;
+	struct net *net = sock_net(sk);
+	struct sock *esk;
+
+	INET_ADDR_COOKIE(acookie, sk->sk_daddr, sk->sk_rcv_saddr);
+
+	sk_nulls_for_each_rcu(esk, node, list) {
+		if (esk->sk_hash != sk->sk_hash)
+			continue;
+		if (sk->sk_family == AF_INET) {
+			if (unlikely(INET_MATCH(esk, net, acookie,
+						sk->sk_daddr,
+						sk->sk_rcv_saddr,
+						ports, dif, sdif))) {
+				return true;
+			}
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+		else if (sk->sk_family == AF_INET6) {
+			if (unlikely(INET6_MATCH(esk, net,
+						 &sk->sk_v6_daddr,
+						 &sk->sk_v6_rcv_saddr,
+						 ports, dif, sdif))) {
+				return true;
+			}
+		}
+#endif
+	}
+	return false;
+}
+
+/* Insert a socket into ehash, and eventually remove another one
+ * (The another one can be a SYN_RECV or TIMEWAIT)
+ * If an existing socket already exists, socket sk is not inserted,
+ * and sets found_dup_sk parameter to true.
+ */
+bool inet_ehash_insert(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 	struct hlist_nulls_head *list;
@@ -492,16 +537,23 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
 	if (osk) {
 		WARN_ON_ONCE(sk->sk_hash != osk->sk_hash);
 		ret = sk_nulls_del_node_init_rcu(osk);
+	} else if (found_dup_sk) {
+		*found_dup_sk = inet_ehash_lookup_by_sk(sk, list);
+		if (*found_dup_sk)
+			ret = false;
 	}
+
 	if (ret)
 		__sk_nulls_add_node_rcu(sk, list);
+
 	spin_unlock(lock);
+
 	return ret;
 }
 
-bool inet_ehash_nolisten(struct sock *sk, struct sock *osk)
+bool inet_ehash_nolisten(struct sock *sk, struct sock *osk, bool *found_dup_sk)
 {
-	bool ok = inet_ehash_insert(sk, osk);
+	bool ok = inet_ehash_insert(sk, osk, found_dup_sk);
 
 	if (ok) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
@@ -545,7 +597,7 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
-		inet_ehash_nolisten(sk, osk);
+		inet_ehash_nolisten(sk, osk, NULL);
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -641,7 +693,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
 		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL);
+			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;
 		}
@@ -720,7 +772,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	inet_bind_hash(sk, tb, port);
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
-		inet_ehash_nolisten(sk, (struct sock *)tw);
+		inet_ehash_nolisten(sk, (struct sock *)tw, NULL);
 	}
 	if (tw)
 		inet_twsk_bind_unhash(tw, hinfo);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2ce85e52aea7..727f5ed4c57b 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1426,6 +1426,7 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 				  bool *own_req)
 {
 	struct inet_request_sock *ireq;
+	bool found_dup_sk = false;
 	struct inet_sock *newinet;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
@@ -1496,12 +1497,22 @@ struct sock *tcp_v4_syn_recv_sock(const struct sock *sk, struct sk_buff *skb,
 
 	if (__inet_inherit_port(sk, newsk) < 0)
 		goto put_and_exit;
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (likely(*own_req)) {
 		tcp_move_syn(newtp, req);
 		ireq->ireq_opt = NULL;
 	} else {
-		newinet->inet_opt = NULL;
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		} else {
+			newinet->inet_opt = NULL;
+		}
 	}
 	return newsk;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 3903cc0ab188..51c900e9bfe2 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1142,6 +1142,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	const struct ipv6_pinfo *np = tcp_inet6_sk(sk);
 	struct ipv6_txoptions *opt;
 	struct inet_sock *newinet;
+	bool found_dup_sk = false;
 	struct tcp_sock *newtp;
 	struct sock *newsk;
 #ifdef CONFIG_TCP_MD5SIG
@@ -1308,7 +1309,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 		tcp_done(newsk);
 		goto out;
 	}
-	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash));
+	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
+				       &found_dup_sk);
 	if (*own_req) {
 		tcp_move_syn(newtp, req);
 
@@ -1323,6 +1325,15 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 				skb_set_owner_r(newnp->pktoptions, newsk);
 			}
 		}
+	} else {
+		if (!req_unhash && found_dup_sk) {
+			/* This code path should only be executed in the
+			 * syncookie case only
+			 */
+			bh_unlock_sock(newsk);
+			sock_put(newsk);
+			newsk = NULL;
+		}
 	}
 
 	return newsk;
-- 
2.35.1



