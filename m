Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81EED5937B2
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244794AbiHOTCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244874AbiHOS73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66814AD5C;
        Mon, 15 Aug 2022 11:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B275B81074;
        Mon, 15 Aug 2022 18:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E517C433C1;
        Mon, 15 Aug 2022 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588355;
        bh=gN0AZ4KaMAhv6HkJ0uXltNqatxe15poS66mDjc+otfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQu0FUans9zmWp7KfWBZvf+t/hBQLEqvGawbcleFBeLrTqVdisFNroPoSyILVmur+
         jOTLd/I3QYEbIdrJf/1Y2MS7tcci8z+Gqe5/wU/EnsjxJmsAv390m36VmRNjuZ+tAr
         2Fz5uR83YAJmB+JJuqYtg/b0mqdGDa9MV1JV4ob4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Manning <mvrmanning@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 376/779] net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set
Date:   Mon, 15 Aug 2022 20:00:20 +0200
Message-Id: <20220815180353.349648511@linuxfoundation.org>
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

From: Mike Manning <mvrmanning@gmail.com>

[ Upstream commit 944fd1aeacb627fa617f85f8e5a34f7ae8ea4d8e ]

The commit 3c82a21f4320 ("net: allow binding socket in a VRF when
there's an unbound socket") changed the inet socket lookup to avoid
packets in a VRF from matching an unbound socket. This is to ensure the
necessary isolation between the default and other VRFs for routing and
forwarding. VRF-unaware processes running in the default VRF cannot
access another VRF and have to be run with 'ip vrf exec <vrf>'. This is
to be expected with tcp_l3mdev_accept disabled, but could be reallowed
when this sysctl option is enabled. So instead of directly checking dif
and sdif in inet[6]_match, here call inet_sk_bound_dev_eq(). This
allows a match on unbound socket for non-zero sdif i.e. for packets in
a VRF, if tcp_l3mdev_accept is enabled.

Fixes: 3c82a21f4320 ("net: allow binding socket in a VRF when there's an unbound socket")
Signed-off-by: Mike Manning <mvrmanning@gmail.com>
Link: https://lore.kernel.org/netdev/a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de/
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet6_hashtables.h |  7 +++----
 include/net/inet_hashtables.h  | 19 +++----------------
 include/net/inet_sock.h        | 11 +++++++++++
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index f259e1ae14ba..56f1286583d3 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -110,8 +110,6 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
 			       const __portpair ports,
 			       const int dif, const int sdif)
 {
-	int bound_dev_if;
-
 	if (!net_eq(sock_net(sk), net) ||
 	    sk->sk_family != AF_INET6 ||
 	    sk->sk_portpair != ports ||
@@ -119,8 +117,9 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
 	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
 		return false;
 
-	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-	return bound_dev_if == dif || bound_dev_if == sdif;
+	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
+	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
+				    sdif);
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 825ad1d06d05..53c22b64e972 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -203,17 +203,6 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
 	hashinfo->ehash_locks = NULL;
 }
 
-static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
-					int dif, int sdif)
-{
-#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
-				 bound_dev_if, dif, sdif);
-#else
-	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-#endif
-}
-
 struct inet_bind_bucket *
 inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
 			struct inet_bind_hashbucket *head,
@@ -311,16 +300,14 @@ static inline bool INET_MATCH(struct net *net, const struct sock *sk,
 			      const __addrpair cookie, const __portpair ports,
 			      int dif, int sdif)
 {
-	int bound_dev_if;
-
 	if (!net_eq(sock_net(sk), net) ||
 	    sk->sk_portpair != ports ||
 	    sk->sk_addrpair != cookie)
 	        return false;
 
-	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
-	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-	return bound_dev_if == dif || bound_dev_if == sdif;
+	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
+	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
+				    sdif);
 }
 
 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index c307a547d2cb..2c2b41ea7f81 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -149,6 +149,17 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
 	return bound_dev_if == dif || bound_dev_if == sdif;
 }
 
+static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
+					int dif, int sdif)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
+				 bound_dev_if, dif, sdif);
+#else
+	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
+#endif
+}
+
 struct inet_cork {
 	unsigned int		flags;
 	__be32			addr;
-- 
2.35.1



