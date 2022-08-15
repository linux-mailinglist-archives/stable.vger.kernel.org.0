Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED79C59396E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244503AbiHOS7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244486AbiHOS5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C55333377;
        Mon, 15 Aug 2022 11:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3521E61029;
        Mon, 15 Aug 2022 18:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22645C433C1;
        Mon, 15 Aug 2022 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588346;
        bh=xFwjR9b18S4XtkLD52WBdoOw1GgnqbnoSM0RUQFkw24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z4Ae2GORnukJYeoTVZuI/tUyOQwufp96kH2It5Rx+UR09B5TgQg69A6PCRKS5/faU
         OPIfdQIO1oQtJq6fr31LVNiEipzz9SozJCePJkosmMim/MbGrLOXNgvKV2gH8kOL6h
         INeXnpPNNeRbpyyXGoqNpvDctYKrPKgub3e0shqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/779] inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
Date:   Mon, 15 Aug 2022 20:00:18 +0200
Message-Id: <20220815180353.259445390@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4915d50e300e96929d2462041d6f6c6f061167fd ]

INET_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET_MATCH() an inline function
to ease our changes.

v2:

We remove the 32bit version of it, as modern compilers
should generate the same code really, no need to
try to be smarter.

Also make 'struct net *net' the first argument.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_hashtables.h | 35 ++++++++++++++++-------------------
 include/net/sock.h            |  3 ---
 net/ipv4/inet_hashtables.c    | 15 +++++----------
 net/ipv4/udp.c                |  3 +--
 4 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 749bb1e46087..825ad1d06d05 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -295,7 +295,6 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 	((__force __portpair)(((__u32)(__dport) << 16) | (__force __u32)(__be16)(__sport)))
 #endif
 
-#if (BITS_PER_LONG == 64)
 #ifdef __BIG_ENDIAN
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
 	const __addrpair __name = (__force __addrpair) ( \
@@ -307,24 +306,22 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 				   (((__force __u64)(__be32)(__daddr)) << 32) | \
 				   ((__force __u64)(__be32)(__saddr)))
 #endif /* __BIG_ENDIAN */
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_addrpair == (__cookie))			&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))			||	\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
-#else /* 32-bit arch */
-#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
-	const int __name __deprecated __attribute__((unused))
-
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))		&&		\
-	 ((__sk)->sk_daddr	== (__saddr))		&&		\
-	 ((__sk)->sk_rcv_saddr	== (__daddr))		&&		\
-	 (((__sk)->sk_bound_dev_if == (__dif))		||		\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))	&&		\
-	 net_eq(sock_net(__sk), (__net)))
-#endif /* 64-bit arch */
+
+static inline bool INET_MATCH(struct net *net, const struct sock *sk,
+			      const __addrpair cookie, const __portpair ports,
+			      int dif, int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_portpair != ports ||
+	    sk->sk_addrpair != cookie)
+	        return false;
+
+	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 
 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
  * not check it for lookups anymore, thanks Alexey. -DaveM
diff --git a/include/net/sock.h b/include/net/sock.h
index e0a88bb0a58c..49a6315d521f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -161,9 +161,6 @@ typedef __u64 __bitwise __addrpair;
  *	for struct sock and struct inet_timewait_sock.
  */
 struct sock_common {
-	/* skc_daddr and skc_rcv_saddr must be grouped on a 8 bytes aligned
-	 * address on 64bit arches : cf INET_MATCH()
-	 */
 	union {
 		__addrpair	skc_addrpair;
 		struct {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 342f3df77835..7c502c4a160b 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -410,13 +410,11 @@ struct sock *__inet_lookup_established(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
-		if (likely(INET_MATCH(sk, net, acookie,
-				      saddr, daddr, ports, dif, sdif))) {
+		if (likely(INET_MATCH(net, sk, acookie, ports, dif, sdif))) {
 			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				goto out;
-			if (unlikely(!INET_MATCH(sk, net, acookie,
-						 saddr, daddr, ports,
-						 dif, sdif))) {
+			if (unlikely(!INET_MATCH(net, sk, acookie,
+						 ports, dif, sdif))) {
 				sock_gen_put(sk);
 				goto begin;
 			}
@@ -465,8 +463,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 		if (sk2->sk_hash != hash)
 			continue;
 
-		if (likely(INET_MATCH(sk2, net, acookie,
-					 saddr, daddr, ports, dif, sdif))) {
+		if (likely(INET_MATCH(net, sk2, acookie, ports, dif, sdif))) {
 			if (sk2->sk_state == TCP_TIME_WAIT) {
 				tw = inet_twsk(sk2);
 				if (twsk_unique(sk, sk2, twp))
@@ -532,9 +529,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 		if (esk->sk_hash != sk->sk_hash)
 			continue;
 		if (sk->sk_family == AF_INET) {
-			if (unlikely(INET_MATCH(esk, net, acookie,
-						sk->sk_daddr,
-						sk->sk_rcv_saddr,
+			if (unlikely(INET_MATCH(net, esk, acookie,
 						ports, dif, sdif))) {
 				return true;
 			}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4ad4daa16cce..efef7ba44e1d 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2554,8 +2554,7 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 	struct sock *sk;
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
-		if (INET_MATCH(sk, net, acookie, rmt_addr,
-			       loc_addr, ports, dif, sdif))
+		if (INET_MATCH(net, sk, acookie, ports, dif, sdif))
 			return sk;
 		/* Only check first socket in chain */
 		break;
-- 
2.35.1



