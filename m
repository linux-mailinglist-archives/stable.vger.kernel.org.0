Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C148B106F14
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfKVK4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:56:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730192AbfKVK4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:56:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6671F20715;
        Fri, 22 Nov 2019 10:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420191;
        bh=ovoyqWI14Df1eJWOmr2Kpy+YWKyrlJN+s3cI1lS9jL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbOOvuaBVJ5n2zKPcbN66a0MpyhyK4PYKuo84Tu3w4wOOyNUR4ORmNZTcisY1+Yl9
         rnhCkMOP4vF8tLJ5zBHvuJqTdQU+NerrvUWatkhCSS59ChDcvSO4EJqniOIItuC92F
         czz0kneqsMZqmdI2v+8EEVxDy2VGjarhxKreab2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/220] tcp: up initial rmem to 128KB and SYN rwin to around 64KB
Date:   Fri, 22 Nov 2019 11:26:29 +0100
Message-Id: <20191122100914.228710869@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuchung Cheng <ycheng@google.com>

[ Upstream commit a337531b942bd8a03e7052444d7e36972aac2d92 ]

Previously TCP initial receive buffer is ~87KB by default and
the initial receive window is ~29KB (20 MSS). This patch changes
the two numbers to 128KB and ~64KB (rounding down to the multiples
of MSS) respectively. The patch also simplifies the calculations s.t.
the two numbers are directly controlled by sysctl tcp_rmem[1]:

  1) Initial receiver buffer budget (sk_rcvbuf): while this should
     be configured via sysctl tcp_rmem[1], previously tcp_fixup_rcvbuf()
     always override and set a larger size when a new connection
     establishes.

  2) Initial receive window in SYN: previously it is set to 20
     packets if MSS <= 1460. The number 20 was based on the initial
     congestion window of 10: the receiver needs twice amount to
     avoid being limited by the receive window upon out-of-order
     delivery in the first window burst. But since this only
     applies if the receiving MSS <= 1460, connection using large MTU
     (e.g. to utilize receiver zero-copy) may be limited by the
     receive window.

With this patch TCP memory configuration is more straight-forward and
more properly sized to modern high-speed networks by default. Several
popular stacks have been announcing 64KB rwin in SYNs as well.

Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c        |  4 ++--
 net/ipv4/tcp_input.c  | 25 ++-----------------------
 net/ipv4/tcp_output.c | 25 ++++---------------------
 3 files changed, 8 insertions(+), 46 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 647ba447bf1ab..a7a804bece7ac 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3910,8 +3910,8 @@ void __init tcp_init(void)
 	init_net.ipv4.sysctl_tcp_wmem[2] = max(64*1024, max_wshare);
 
 	init_net.ipv4.sysctl_tcp_rmem[0] = SK_MEM_QUANTUM;
-	init_net.ipv4.sysctl_tcp_rmem[1] = 87380;
-	init_net.ipv4.sysctl_tcp_rmem[2] = max(87380, max_rshare);
+	init_net.ipv4.sysctl_tcp_rmem[1] = 131072;
+	init_net.ipv4.sysctl_tcp_rmem[2] = max(131072, max_rshare);
 
 	pr_info("Hash tables configured (established %u bind %u)\n",
 		tcp_hashinfo.ehash_mask + 1, tcp_hashinfo.bhash_size);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 14a6a489937c1..0e2b07be08585 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -426,26 +426,7 @@ static void tcp_grow_window(struct sock *sk, const struct sk_buff *skb)
 	}
 }
 
-/* 3. Tuning rcvbuf, when connection enters established state. */
-static void tcp_fixup_rcvbuf(struct sock *sk)
-{
-	u32 mss = tcp_sk(sk)->advmss;
-	int rcvmem;
-
-	rcvmem = 2 * SKB_TRUESIZE(mss + MAX_TCP_HEADER) *
-		 tcp_default_init_rwnd(mss);
-
-	/* Dynamic Right Sizing (DRS) has 2 to 3 RTT latency
-	 * Allow enough cushion so that sender is not limited by our window
-	 */
-	if (sock_net(sk)->ipv4.sysctl_tcp_moderate_rcvbuf)
-		rcvmem <<= 2;
-
-	if (sk->sk_rcvbuf < rcvmem)
-		sk->sk_rcvbuf = min(rcvmem, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]);
-}
-
-/* 4. Try to fixup all. It is made immediately after connection enters
+/* 3. Try to fixup all. It is made immediately after connection enters
  *    established state.
  */
 void tcp_init_buffer_space(struct sock *sk)
@@ -454,8 +435,6 @@ void tcp_init_buffer_space(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	int maxwin;
 
-	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK))
-		tcp_fixup_rcvbuf(sk);
 	if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
 		tcp_sndbuf_expand(sk);
 
@@ -485,7 +464,7 @@ void tcp_init_buffer_space(struct sock *sk)
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 }
 
-/* 5. Recalculate window clamp after socket hit its memory bounds. */
+/* 4. Recalculate window clamp after socket hit its memory bounds. */
 static void tcp_clamp_window(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 2697e4397e46c..53f910bb55087 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -179,21 +179,6 @@ static inline void tcp_event_ack_sent(struct sock *sk, unsigned int pkts,
 	inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);
 }
 
-
-u32 tcp_default_init_rwnd(u32 mss)
-{
-	/* Initial receive window should be twice of TCP_INIT_CWND to
-	 * enable proper sending of new unsent data during fast recovery
-	 * (RFC 3517, Section 4, NextSeg() rule (2)). Further place a
-	 * limit when mss is larger than 1460.
-	 */
-	u32 init_rwnd = TCP_INIT_CWND * 2;
-
-	if (mss > 1460)
-		init_rwnd = max((1460 * init_rwnd) / mss, 2U);
-	return init_rwnd;
-}
-
 /* Determine a window scaling and initial window to offer.
  * Based on the assumption that the given amount of space
  * will be offered. Store the results in the tp structure.
@@ -228,7 +213,10 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 	if (sock_net(sk)->ipv4.sysctl_tcp_workaround_signed_windows)
 		(*rcv_wnd) = min(space, MAX_TCP_WINDOW);
 	else
-		(*rcv_wnd) = space;
+		(*rcv_wnd) = min_t(u32, space, U16_MAX);
+
+	if (init_rcv_wnd)
+		*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
 
 	(*rcv_wscale) = 0;
 	if (wscale_ok) {
@@ -241,11 +229,6 @@ void tcp_select_initial_window(const struct sock *sk, int __space, __u32 mss,
 			(*rcv_wscale)++;
 		}
 	}
-
-	if (!init_rcv_wnd) /* Use default unless specified otherwise */
-		init_rcv_wnd = tcp_default_init_rwnd(mss);
-	*rcv_wnd = min(*rcv_wnd, init_rcv_wnd * mss);
-
 	/* Set the clamp no higher than max representable value */
 	(*window_clamp) = min_t(__u32, U16_MAX << (*rcv_wscale), *window_clamp);
 }
-- 
2.20.1



