Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D35033B6FF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhCON7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhCON6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FBA864F19;
        Mon, 15 Mar 2021 13:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816695;
        bh=YK6SNUgni5tr2e3RnJh/XBRvphOtoSaXM0nwiP95bX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xoVJ1+qEf30sMWMrFARusfIEdea72tERwvsInijONHljliq/Q7A9UTQ072w2oV3WC
         WXDFL41a1ZIl2XQNaejv4BujRfyJgAh5DKeUDwRFZt0PIdlUY1tYuQgVaTUqBaYXg2
         jKIyITI+LlUBIDo4/WzydNPhiSmVhrO50fYfq2vU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 012/120] tcp: annotate tp->write_seq lockless reads
Date:   Mon, 15 Mar 2021 14:56:03 +0100
Message-Id: <20210315135720.418426545@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0f31746452e6793ad6271337438af8f4defb8940 ]

There are few places where we fetch tp->write_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h        |    2 +-
 net/ipv4/tcp.c           |   20 ++++++++++++--------
 net/ipv4/tcp_diag.c      |    2 +-
 net/ipv4/tcp_ipv4.c      |   21 ++++++++++++---------
 net/ipv4/tcp_minisocks.c |    2 +-
 net/ipv4/tcp_output.c    |    4 ++--
 net/ipv6/tcp_ipv6.c      |   13 +++++++------
 7 files changed, 36 insertions(+), 28 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1880,7 +1880,7 @@ static inline u32 tcp_notsent_lowat(cons
 static inline bool tcp_stream_memory_free(const struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
-	u32 notsent_bytes = tp->write_seq - tp->snd_nxt;
+	u32 notsent_bytes = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 
 	return notsent_bytes < tcp_notsent_lowat(tp);
 }
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -637,7 +637,7 @@ int tcp_ioctl(struct sock *sk, int cmd,
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_una;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_una;
 		break;
 	case SIOCOUTQNSD:
 		if (sk->sk_state == TCP_LISTEN)
@@ -646,7 +646,7 @@ int tcp_ioctl(struct sock *sk, int cmd,
 		if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV))
 			answ = 0;
 		else
-			answ = tp->write_seq - tp->snd_nxt;
+			answ = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 		break;
 	default:
 		return -ENOIOCTLCMD;
@@ -1037,7 +1037,7 @@ new_segment:
 		sk->sk_wmem_queued += copy;
 		sk_mem_charge(sk, copy);
 		skb->ip_summed = CHECKSUM_PARTIAL;
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -1391,7 +1391,7 @@ new_segment:
 		if (!copied)
 			TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_PSH;
 
-		tp->write_seq += copy;
+		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
 		TCP_SKB_CB(skb)->end_seq += copy;
 		tcp_skb_pcount_set(skb, 0);
 
@@ -2556,6 +2556,7 @@ int tcp_disconnect(struct sock *sk, int
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	int old_state = sk->sk_state;
+	u32 seq;
 
 	if (old_state != TCP_CLOSE)
 		tcp_set_state(sk, TCP_CLOSE);
@@ -2593,9 +2594,12 @@ int tcp_disconnect(struct sock *sk, int
 	sock_reset_flag(sk, SOCK_DONE);
 	tp->srtt_us = 0;
 	tp->rcv_rtt_last_tsecr = 0;
-	tp->write_seq += tp->max_window + 2;
-	if (tp->write_seq == 0)
-		tp->write_seq = 1;
+
+	seq = tp->write_seq + tp->max_window + 2;
+	if (!seq)
+		seq = 1;
+	WRITE_ONCE(tp->write_seq, seq);
+
 	tp->snd_cwnd = 2;
 	icsk->icsk_probes_out = 0;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
@@ -2885,7 +2889,7 @@ static int do_tcp_setsockopt(struct sock
 		if (sk->sk_state != TCP_CLOSE)
 			err = -EPERM;
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
-			tp->write_seq = val;
+			WRITE_ONCE(tp->write_seq, val);
 		else if (tp->repair_queue == TCP_RECV_QUEUE) {
 			WRITE_ONCE(tp->rcv_nxt, val);
 			WRITE_ONCE(tp->copied_seq, val);
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -32,7 +32,7 @@ static void tcp_diag_get_info(struct soc
 
 		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
 					     READ_ONCE(tp->copied_seq), 0);
-		r->idiag_wqueue = tp->write_seq - tp->snd_una;
+		r->idiag_wqueue = READ_ONCE(tp->write_seq) - tp->snd_una;
 	}
 	if (info)
 		tcp_get_info(sk, info);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -169,9 +169,11 @@ int tcp_twsk_unique(struct sock *sk, str
 		 * without appearing to create any others.
 		 */
 		if (likely(!tp->repair)) {
-			tp->write_seq = tcptw->tw_snd_nxt + 65535 + 2;
-			if (tp->write_seq == 0)
-				tp->write_seq = 1;
+			u32 seq = tcptw->tw_snd_nxt + 65535 + 2;
+
+			if (!seq)
+				seq = 1;
+			WRITE_ONCE(tp->write_seq, seq);
 			tp->rx_opt.ts_recent	   = tcptw->tw_ts_recent;
 			tp->rx_opt.ts_recent_stamp = tcptw->tw_ts_recent_stamp;
 		}
@@ -258,7 +260,7 @@ int tcp_v4_connect(struct sock *sk, stru
 		tp->rx_opt.ts_recent	   = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
 		if (likely(!tp->repair))
-			tp->write_seq	   = 0;
+			WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	inet->inet_dport = usin->sin_port;
@@ -296,10 +298,11 @@ int tcp_v4_connect(struct sock *sk, stru
 
 	if (likely(!tp->repair)) {
 		if (!tp->write_seq)
-			tp->write_seq = secure_tcp_seq(inet->inet_saddr,
-						       inet->inet_daddr,
-						       inet->inet_sport,
-						       usin->sin_port);
+			WRITE_ONCE(tp->write_seq,
+				   secure_tcp_seq(inet->inet_saddr,
+						  inet->inet_daddr,
+						  inet->inet_sport,
+						  usin->sin_port));
 		tp->tsoffset = secure_tcp_ts_off(sock_net(sk),
 						 inet->inet_saddr,
 						 inet->inet_daddr);
@@ -2345,7 +2348,7 @@ static void get_tcp4_sock(struct sock *s
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
 		i, src, srcp, dest, destp, state,
-		tp->write_seq - tp->snd_una,
+		READ_ONCE(tp->write_seq) - tp->snd_una,
 		rx_queue,
 		timer_active,
 		jiffies_delta_to_clock_t(timer_expires - jiffies),
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(co
 	newtp->app_limited = ~0U;
 
 	tcp_init_xmit_timers(newsk);
-	newtp->write_seq = newtp->pushed_seq = treq->snt_isn + 1;
+	WRITE_ONCE(newtp->write_seq, newtp->pushed_seq = treq->snt_isn + 1);
 
 	newtp->rx_opt.saw_tstamp = 0;
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1175,7 +1175,7 @@ static void tcp_queue_skb(struct sock *s
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	/* Advance write_seq and place onto the write_queue. */
-	tp->write_seq = TCP_SKB_CB(skb)->end_seq;
+	WRITE_ONCE(tp->write_seq, TCP_SKB_CB(skb)->end_seq);
 	__skb_header_release(skb);
 	tcp_add_write_queue_tail(sk, skb);
 	sk->sk_wmem_queued += skb->truesize;
@@ -3397,7 +3397,7 @@ static void tcp_connect_queue_skb(struct
 	__skb_header_release(skb);
 	sk->sk_wmem_queued += skb->truesize;
 	sk_mem_charge(sk, skb->truesize);
-	tp->write_seq = tcb->end_seq;
+	WRITE_ONCE(tp->write_seq, tcb->end_seq);
 	tp->packets_out += tcp_skb_pcount(skb);
 }
 
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -206,7 +206,7 @@ static int tcp_v6_connect(struct sock *s
 	    !ipv6_addr_equal(&sk->sk_v6_daddr, &usin->sin6_addr)) {
 		tp->rx_opt.ts_recent = 0;
 		tp->rx_opt.ts_recent_stamp = 0;
-		tp->write_seq = 0;
+		WRITE_ONCE(tp->write_seq, 0);
 	}
 
 	sk->sk_v6_daddr = usin->sin6_addr;
@@ -304,10 +304,11 @@ static int tcp_v6_connect(struct sock *s
 
 	if (likely(!tp->repair)) {
 		if (!tp->write_seq)
-			tp->write_seq = secure_tcpv6_seq(np->saddr.s6_addr32,
-							 sk->sk_v6_daddr.s6_addr32,
-							 inet->inet_sport,
-							 inet->inet_dport);
+			WRITE_ONCE(tp->write_seq,
+				   secure_tcpv6_seq(np->saddr.s6_addr32,
+						    sk->sk_v6_daddr.s6_addr32,
+						    inet->inet_sport,
+						    inet->inet_dport));
 		tp->tsoffset = secure_tcpv6_ts_off(sock_net(sk),
 						   np->saddr.s6_addr32,
 						   sk->sk_v6_daddr.s6_addr32);
@@ -1850,7 +1851,7 @@ static void get_tcp6_sock(struct seq_fil
 		   dest->s6_addr32[0], dest->s6_addr32[1],
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   state,
-		   tp->write_seq - tp->snd_una,
+		   READ_ONCE(tp->write_seq) - tp->snd_una,
 		   rx_queue,
 		   timer_active,
 		   jiffies_delta_to_clock_t(timer_expires - jiffies),


