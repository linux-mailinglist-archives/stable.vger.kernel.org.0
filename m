Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3C35A489A
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiH2LM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiH2LMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950CC5E55C;
        Mon, 29 Aug 2022 04:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C4ACB80F4B;
        Mon, 29 Aug 2022 11:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6487C433D6;
        Mon, 29 Aug 2022 11:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771267;
        bh=kDjd2FE/jXFBce+2W7xX+iY7pB8sZC4yq71K0rfMbfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NO7iQo7bN5zkK4cyEhwiE9QpjbED5ht90Vqzx9yA4rGMBT4prszPcCzBii4R/A+Jm
         JliS1TS0rdHCwSpro/MrkTX4BDV3/LNZE2pSIq547iTSLuuDjShLjmyEacvWaY2Hma
         wWjtBMh5BNNW3JxX9O61GkRX17wOcZ8ETpkI+qvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/86] net: Fix data-races around sysctl_[rw]mem(_offset)?.
Date:   Mon, 29 Aug 2022 12:59:11 +0200
Message-Id: <20220829105758.375822382@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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
index 333131f47ac13..d31c2b9107e54 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2678,18 +2678,18 @@ static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
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
index dc92a67baea39..7d542eb461729 100644
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
index 78460eb39b3af..bfeb05f62b94f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -451,8 +451,8 @@ void tcp_init_sock(struct sock *sk)
 
 	icsk->icsk_sync_mss = tcp_sync_mss;
 
-	WRITE_ONCE(sk->sk_sndbuf, sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
-	WRITE_ONCE(sk->sk_rcvbuf, sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
+	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_route_forced_caps = NETIF_F_GSO;
@@ -1711,7 +1711,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else
-		cap = sock_net(sk)->ipv4.sysctl_tcp_rmem[2] >> 1;
+		cap = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
 	val = min(val, cap);
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 33a3fb04ac4df..41b44b311e8a0 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -425,7 +425,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 
 	if (sk->sk_sndbuf < sndmem)
 		WRITE_ONCE(sk->sk_sndbuf,
-			   min(sndmem, sock_net(sk)->ipv4.sysctl_tcp_wmem[2]));
+			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -460,7 +460,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	/* Optimize this! */
 	int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
-	int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
+	int window = tcp_win_from_space(sk, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2])) >> 1;
 
 	while (tp->rcv_ssthresh <= window) {
 		if (truesize <= skb->len)
@@ -565,16 +565,17 @@ static void tcp_clamp_window(struct sock *sk)
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
@@ -736,7 +737,7 @@ void tcp_rcv_space_adjust(struct sock *sk)
 
 		do_div(rcvwin, tp->advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 		if (rcvbuf > sk->sk_rcvbuf) {
 			WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 4c9274cb92d55..c90c9541996bf 100644
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
index d0e91aa7b30e5..e61c85873ea2f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1439,7 +1439,7 @@ static void mptcp_rcv_space_adjust(struct mptcp_sock *msk, int copied)
 
 		do_div(rcvwin, advmss);
 		rcvbuf = min_t(u64, rcvwin * rcvmem,
-			       sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[2]));
 
 		if (rcvbuf > sk->sk_rcvbuf) {
 			u32 window_clamp;
@@ -1872,8 +1872,8 @@ static int mptcp_init_sock(struct sock *sk)
 		return ret;
 
 	sk_sockets_allocated_inc(sk);
-	sk->sk_rcvbuf = sock_net(sk)->ipv4.sysctl_tcp_rmem[1];
-	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[1];
+	sk->sk_rcvbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]);
+	sk->sk_sndbuf = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]);
 
 	return 0;
 }
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 38256aabf4f1d..8f3c9fbb99165 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -504,7 +504,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
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



