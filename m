Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF2586AAA
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbiHAMTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiHAMTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B804F4AD5C;
        Mon,  1 Aug 2022 04:59:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 389A9B810A2;
        Mon,  1 Aug 2022 11:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F58C433D7;
        Mon,  1 Aug 2022 11:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355192;
        bh=IHr1aUmBLBq6hdDkxtYE0BDsldJN3WkLHNFC/2Bp760=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEGCMvAw0KCI7OjnRQxliPUbcgHTVeyWYDlu5eew2dsnmlefSQ6q0OmpHBDP+zZ+B
         sXIdFcam7SrBVzJEJZY5NpEaZ244qIU/ZpbPlgG6IBjjXt8Ps4IF4PVX55seIVY0HG
         kX2nYOQbXMpXCH3c+PmoicPOQZ/jalSjLjU4yy3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 59/88] net: Fix data-races around sysctl_[rw]mem(_offset)?.
Date:   Mon,  1 Aug 2022 13:47:13 +0200
Message-Id: <20220801114140.746927246@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 02739545951ad4c1215160db7fbf9b7a918d3c0b ]

While reading these sysctl variables, they can be changed concurrently.
Thus, we need to add READ_ONCE() to their readers.

  - .sysctl_rmem
  - .sysctl_rwmem
  - .sysctl_rmem_offset
  - .sysctl_wmem_offset
  - sysctl_tcp_rmem[1, 2]
  - sysctl_tcp_wmem[1, 2]
  - sysctl_decnet_rmem[1]
  - sysctl_decnet_wmem[1]
  - sysctl_tipc_rmem[1]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h     |  8 ++++----
 net/decnet/af_decnet.c |  4 ++--
 net/ipv4/tcp.c         |  6 +++---
 net/ipv4/tcp_input.c   | 13 +++++++------
 net/ipv4/tcp_output.c  |  2 +-
 net/mptcp/protocol.c   |  6 +++---
 net/tipc/socket.c      |  2 +-
 7 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6bef0ffb1e7b..9563a093fdfc 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2834,18 +2834,18 @@ static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_wmem ? */
 	if (proto->sysctl_wmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_wmem_offset));
 
-	return *proto->sysctl_wmem;
+	return READ_ONCE(*proto->sysctl_wmem);
 }
 
 static inline int sk_get_rmem0(const struct sock *sk, const struct proto *proto)
 {
 	/* Does this proto have per netns sysctl_rmem ? */
 	if (proto->sysctl_rmem_offset)
-		return *(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset);
+		return READ_ONCE(*(int *)((void *)sock_net(sk) + proto->sysctl_rmem_offset));
 
-	return *proto->sysctl_rmem;
+	return READ_ONCE(*proto->sysctl_rmem);
 }
 
 /* Default TCP Small queue budget is ~1 ms of data (1sec >> 10)
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index dc92a67baea3..7d542eb46172 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -480,8 +480,8 @@ static struct sock *dn_alloc_sock(struct net *net, struct socket *sock, gfp_t gf
 	sk->sk_family      = PF_DECnet;
 	sk->sk_protocol    = 0;
 	sk->sk_allocation  = gfp;
-	sk->sk_sndbuf	   = sysctl_decnet_wmem[1];
-	sk->sk_rcvbuf	   = sysctl_decnet_rmem[1];
+	sk->sk_sndbuf	   = READ_ONCE(sysctl_decnet_wmem[1]);
+	sk->sk_rcvbuf	   = READ_ONCE(sysctl_decnet_rmem[1]);
 
 	/* Initialization of DECnet Session Control Port		*/
 	scp = DN_SK(sk);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 60b46f2a6896..91735d631a28 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -452,8 +452,8 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
-	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
 	sk_sockets_allocated_inc(sk);
 }
@@ -1743,7 +1743,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else
-		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
+		cap = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 	val = min(val, cap);
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index de066fad7dfe..f09b1321a960 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,7 +426,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 
 	if (sk->sk_sndbuf < sndmem)
 		WRITE_ONCE(sk->sk_sndbuf,
-			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
+			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -461,7 +461,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
-	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
+	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
 		if (truesize <= skb->len)
@@ -574,16 +574,17 @@ static void tcp_clamp_window(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
+	int rmem2;
 
 	icsk->icsk_ack.quick = 0;
+	rmem2 = READ_ONCE(net->ipv4.sysctl_tcp_rmem[2]);
 
-	if (sk->sk_rcvbuf < net->ipv4.sysctl_tcp_rmem[2] &&
+	if (sk->sk_rcvbuf < rmem2 &&
 	    !(sk->sk_userlocks & SOCK_RCVBUF_LOCK) &&
 	    !tcp_under_memory_pressure(sk) &&
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
-			   min(atomic_read(&sk->sk_rmem_alloc),
-			       net->ipv4.sysctl_tcp_rmem[2]));
+			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -745,7 +746,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		do_div(rcvwin, tp->advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		if (rcvbuf > sk->sk_rcvbuf) {
 			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 60c9f7f444e0..66836b8bd46f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -238,7 +238,7 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	*rcv_wscale = 0;
 	if (wscale_ok) {
 		/* Set window scaling on max possible window */
-		space = max_t(u32, space, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+		space = max_t(u32, space, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		space = max_t(u32, space, sysctl_rmem_max);
 		space = min_t(u32, space, *window_clamp);
 		*rcv_wscale = clamp_t(int, ilog2(space) - 15,
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e2790a6e90fb..07b5a2044cab 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1900,7 +1900,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 		do_div(rcvwin, advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 
 		if (rcvbuf > sk->sk_rcvbuf) {
 			u32 window_clamp;
@@ -2597,8 +2597,8 @@ static int mptcp_init_sock(struct sock *sk)
 	mptcp_ca_reset(sk);
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	sk->sk_sndbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 
 	return 0;
 }
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 43509c7e90fc..f1c3b8eb4b3d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -517,7 +517,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	timer_setup(&sk->sk_timer, tipc_sk_timeout, 0);
 	sk->sk_shutdown = 0;
 	sk->sk_backlog_rcv = tipc_sk_backlog_rcv;
-	sk->sk_rcvbuf = sysctl_tipc_rmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sysctl_tipc_rmem[1]);
 	sk->sk_data_ready = tipc_data_ready;
 	sk->sk_write_space = tipc_write_space;
 	sk->sk_destruct = tipc_sock_destruct;
-- 
2.35.1



