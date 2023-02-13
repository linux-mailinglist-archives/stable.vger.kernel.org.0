Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D45366948F5
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjBMOzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjBMOyr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9865FCC
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 437536106F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5705FC433D2;
        Mon, 13 Feb 2023 14:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300080;
        bh=wndGZzRGH0bN3LY7nXy9TG5ClgqVUvXkXPpk7yqn9uA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqeG9km5+khFXjpMnvEBB5u2A0kpB0O9ygogeF/AxTyCVNFPhzUUxwrqXSwmsJ17c
         3pmYXmZC1Q81aLpUt0uQGQx39I73bESnQFMr0HCNh0IzXN3SSzoQ4Pvgq5xr21d5V7
         VYLIpnr3kldKuHyxuCV/9LfBRio2EcK45AxwFbFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kevin Yang <yyd@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/114] txhash: fix sk->sk_txrehash default
Date:   Mon, 13 Feb 2023 15:48:11 +0100
Message-Id: <20230213144745.111808100@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Yang <yyd@google.com>

[ Upstream commit c11204c78d6966c5bda6dd05c3ac5cbb193f93e3 ]

This code fix a bug that sk->sk_txrehash gets its default enable
value from sysctl_txrehash only when the socket is a TCP listener.

We should have sysctl_txrehash to set the default sk->sk_txrehash,
no matter TCP, nor listerner/connector.

Tested by following packetdrill:
  0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
  +0 socket(..., SOCK_DGRAM, IPPROTO_UDP) = 4
  // SO_TXREHASH == 74, default to sysctl_txrehash == 1
  +0 getsockopt(3, SOL_SOCKET, 74, [1], [4]) = 0
  +0 getsockopt(4, SOL_SOCKET, 74, [1], [4]) = 0

Fixes: 26859240e4ee ("txhash: Add socket option to control TX hash rethink behavior")
Signed-off-by: Kevin Yang <yyd@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c                 | 3 ++-
 net/ipv4/af_inet.c              | 1 +
 net/ipv4/inet_connection_sock.c | 3 ---
 net/ipv6/af_inet6.c             | 1 +
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 30407b2dd2ac4..ba6ea61b3458b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1524,6 +1524,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			ret = -EINVAL;
 			break;
 		}
+		if ((u8)val == SOCK_TXREHASH_DEFAULT)
+			val = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
 		/* Paired with READ_ONCE() in tcp_rtx_synack() */
 		WRITE_ONCE(sk->sk_txrehash, (u8)val);
 		break;
@@ -3428,7 +3430,6 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	sk->sk_pacing_rate = ~0UL;
 	WRITE_ONCE(sk->sk_pacing_shift, 10);
 	sk->sk_incoming_cpu = -1;
-	sk->sk_txrehash = SOCK_TXREHASH_DEFAULT;
 
 	sk_rx_queue_clear(sk);
 	/*
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 92d4237862518..5b19b77d5d759 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -347,6 +347,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 	sk->sk_destruct	   = inet_sock_destruct;
 	sk->sk_protocol	   = protocol;
 	sk->sk_backlog_rcv = sk->sk_prot->backlog_rcv;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	inet->uc_ttl	= -1;
 	inet->mc_loop	= 1;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 647b3c6b575ef..7152ede18f115 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1225,9 +1225,6 @@ int inet_csk_listen_start(struct sock *sk)
 	sk->sk_ack_backlog = 0;
 	inet_csk_delack_init(sk);
 
-	if (sk->sk_txrehash == SOCK_TXREHASH_DEFAULT)
-		sk->sk_txrehash = READ_ONCE(sock_net(sk)->core.sysctl_txrehash);
-
 	/* There is race window here: we announce ourselves listening,
 	 * but this transition is still not validated by get_port().
 	 * It is OK, because this socket enters to hash table only
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7b0cd54da452b..fb1bf6eb0ff8e 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -221,6 +221,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
 	np->repflow	= net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ESTABLISHED;
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
+	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
 	/* Init the ipv4 part of the socket since we can have sockets
 	 * using v6 API for ipv4.
-- 
2.39.0



