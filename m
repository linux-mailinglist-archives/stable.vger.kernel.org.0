Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2E593949
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244877AbiHOS7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239189AbiHOS5b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:57:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76524A829;
        Mon, 15 Aug 2022 11:32:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3F3DB8105D;
        Mon, 15 Aug 2022 18:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F11DC433C1;
        Mon, 15 Aug 2022 18:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588349;
        bh=gZsXOWi7YEW6JE1/4d/OmEBk6gcSE81edNlQ9cvR2fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijflYSf46pulCghQOAXLPNP5rAR4wRsMGBbYmxbBicTCQGVuHI1e2wIt86uknwFoV
         dl6fbmwU64jnV7BZmS2JSYui9gyrcQkMNtgKQwLqIhaelHaMp7uNr0UHIWGSJ1qvqw
         MnfVE+ul4Wt3fYktph/t293QzuWWcSAwmA8FX2Bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 375/779] ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
Date:   Mon, 15 Aug 2022 20:00:19 +0200
Message-Id: <20220815180353.308033176@linuxfoundation.org>
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

[ Upstream commit 5d368f03280d3678433a7f119efe15dfbbb87bc8 ]

INET6_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET6_MATCH() an inline function
to ease our changes.

v2: inline function only defined if IS_ENABLED(CONFIG_IPV6)
    Change the name to inet6_match(), this is no longer a macro.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet6_hashtables.h | 28 +++++++++++++++++++---------
 net/ipv4/inet_hashtables.c     |  2 +-
 net/ipv6/inet6_hashtables.c    |  6 +++---
 net/ipv6/udp.c                 |  2 +-
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 81b965953036..f259e1ae14ba 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -103,15 +103,25 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 			  const int dif);
 
 int inet6_hash(struct sock *sk);
-#endif /* IS_ENABLED(CONFIG_IPV6) */
 
-#define INET6_MATCH(__sk, __net, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_family == AF_INET6)			&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_daddr, (__saddr))		&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_rcv_saddr, (__daddr))	&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))	||			\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
+static inline bool inet6_match(struct net *net, const struct sock *sk,
+			       const struct in6_addr *saddr,
+			       const struct in6_addr *daddr,
+			       const __portpair ports,
+			       const int dif, const int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_family != AF_INET6 ||
+	    sk->sk_portpair != ports ||
+	    !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
+	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+		return false;
+
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
+#endif /* IS_ENABLED(CONFIG_IPV6) */
 
 #endif /* _INET6_HASHTABLES_H */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7c502c4a160b..26c4dd4ec459 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -536,7 +536,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (sk->sk_family == AF_INET6) {
-			if (unlikely(INET6_MATCH(esk, net,
+			if (unlikely(inet6_match(net, esk,
 						 &sk->sk_v6_daddr,
 						 &sk->sk_v6_rcv_saddr,
 						 ports, dif, sdif))) {
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 40203255ed88..b4a5e01e1201 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -71,12 +71,12 @@ struct sock *__inet6_lookup_established(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
-		if (!INET6_MATCH(sk, net, saddr, daddr, ports, dif, sdif))
+		if (!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))
 			continue;
 		if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 			goto out;
 
-		if (unlikely(!INET6_MATCH(sk, net, saddr, daddr, ports, dif, sdif))) {
+		if (unlikely(!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))) {
 			sock_gen_put(sk);
 			goto begin;
 		}
@@ -269,7 +269,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 		if (sk2->sk_hash != hash)
 			continue;
 
-		if (likely(INET6_MATCH(sk2, net, saddr, daddr, ports,
+		if (likely(inet6_match(net, sk2, saddr, daddr, ports,
 				       dif, sdif))) {
 			if (sk2->sk_state == TCP_TIME_WAIT) {
 				tw = inet_twsk(sk2);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 932c6f2a5494..4a9afdbd5f29 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1035,7 +1035,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (sk->sk_state == TCP_ESTABLISHED &&
-		    INET6_MATCH(sk, net, rmt_addr, loc_addr, ports, dif, sdif))
+		    inet6_match(net, sk, rmt_addr, loc_addr, ports, dif, sdif))
 			return sk;
 		/* Only check first socket in chain */
 		break;
-- 
2.35.1



