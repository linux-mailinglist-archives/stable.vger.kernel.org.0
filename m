Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B295593F90
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245558AbiHOVUs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345754AbiHOVRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E519E3942;
        Mon, 15 Aug 2022 12:21:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D63AC60EF0;
        Mon, 15 Aug 2022 19:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EF8C433D6;
        Mon, 15 Aug 2022 19:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591271;
        bh=iZFd9z97YtMV3WCy5/Eyrxb+ZVXfH1kFgooGwXNH438=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgPJdUJZwPTmiFMevXBjvzIOE9S2+9aSLWt79IsQhVwZC0qyiGyv6BnTioOlaVakI
         n14Hy9S+WxvXSCNMYaukVfxhxK1nR4MoHeGsy0rurIRs4bBkqWhOo49QU1Fvjt1knx
         S/ha57msdc48FMKJtCfocdPJEp8SN1mPiQtXxuWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Manning <mvrmanning@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0526/1095] net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set
Date:   Mon, 15 Aug 2022 19:58:45 +0200
Message-Id: <20220815180451.317397256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 6395f6b9a5d2..bf5654ce711e 100644
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



