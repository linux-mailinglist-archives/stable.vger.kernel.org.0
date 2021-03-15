Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D9B33B729
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhCON7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232186AbhCON6Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26BBD64F05;
        Mon, 15 Mar 2021 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816694;
        bh=wPUb7zSk3hPGqLqGomfBvu/tCAvJ00s5fF//vm3tWIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ec67GYz8m3C3khCJnv6QZNNCZGqVApy3uZFwC+ggNRU0/cURBtHMQpLNXyc+qqckb
         ZUp3S9O++/FyfBBijdmvE/757WZjQawsniTNijVnaQ1ed0CerXGnn4iHEs6y4xU15q
         FHXfjlH4X0kAHFZFum2xMrv9u49371/1Yz3nKOLM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 011/120] tcp: annotate tp->copied_seq lockless reads
Date:   Mon, 15 Mar 2021 14:56:02 +0100
Message-Id: <20210315135720.384809636@linuxfoundation.org>
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

[ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]

There are few places where we fetch tp->copied_seq while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Note that tcp_inq_hint() was already using READ_ONCE(tp->copied_seq)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c           |   18 +++++++++---------
 net/ipv4/tcp_diag.c      |    3 ++-
 net/ipv4/tcp_input.c     |    6 +++---
 net/ipv4/tcp_ipv4.c      |    2 +-
 net/ipv4/tcp_minisocks.c |    2 +-
 net/ipv4/tcp_output.c    |    2 +-
 net/ipv6/tcp_ipv6.c      |    2 +-
 7 files changed, 18 insertions(+), 17 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -567,7 +567,7 @@ __poll_t tcp_poll(struct file *file, str
 	    (state != TCP_SYN_RECV || tp->fastopen_rsk)) {
 		int target = sock_rcvlowat(sk, 0, INT_MAX);
 
-		if (tp->urg_seq == tp->copied_seq &&
+		if (tp->urg_seq == READ_ONCE(tp->copied_seq) &&
 		    !sock_flag(sk, SOCK_URGINLINE) &&
 		    tp->urg_data)
 			target++;
@@ -628,7 +628,7 @@ int tcp_ioctl(struct sock *sk, int cmd,
 		unlock_sock_fast(sk, slow);
 		break;
 	case SIOCATMARK:
-		answ = tp->urg_data && tp->urg_seq == tp->copied_seq;
+		answ = tp->urg_data && tp->urg_seq == READ_ONCE(tp->copied_seq);
 		break;
 	case SIOCOUTQ:
 		if (sk->sk_state == TCP_LISTEN)
@@ -1696,9 +1696,9 @@ int tcp_read_sock(struct sock *sk, read_
 		sk_eat_skb(sk, skb);
 		if (!desc->count)
 			break;
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 	}
-	tp->copied_seq = seq;
+	WRITE_ONCE(tp->copied_seq, seq);
 
 	tcp_rcv_space_adjust(sk);
 
@@ -1835,7 +1835,7 @@ static int tcp_zerocopy_receive(struct s
 out:
 	up_read(&current->mm->mmap_sem);
 	if (length) {
-		tp->copied_seq = seq;
+		WRITE_ONCE(tp->copied_seq, seq);
 		tcp_rcv_space_adjust(sk);
 
 		/* Clean up data we have read: This will do ACK frames. */
@@ -2112,7 +2112,7 @@ int tcp_recvmsg(struct sock *sk, struct
 			if (urg_offset < used) {
 				if (!urg_offset) {
 					if (!sock_flag(sk, SOCK_URGINLINE)) {
-						++*seq;
+						WRITE_ONCE(*seq, *seq + 1);
 						urg_hole++;
 						offset++;
 						used--;
@@ -2134,7 +2134,7 @@ int tcp_recvmsg(struct sock *sk, struct
 			}
 		}
 
-		*seq += used;
+		WRITE_ONCE(*seq, *seq + used);
 		copied += used;
 		len -= used;
 
@@ -2163,7 +2163,7 @@ skip_copy:
 
 	found_fin_ok:
 		/* Process the FIN. */
-		++*seq;
+		WRITE_ONCE(*seq, *seq + 1);
 		if (!(flags & MSG_PEEK))
 			sk_eat_skb(sk, skb);
 		break;
@@ -2578,7 +2578,7 @@ int tcp_disconnect(struct sock *sk, int
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 	tp->urg_data = 0;
 	tcp_write_queue_purge(sk);
 	tcp_fastopen_active_disable_ofo_check(sk);
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -30,7 +30,8 @@ static void tcp_diag_get_info(struct soc
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
-		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) - tp->copied_seq, 0);
+		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+					     READ_ONCE(tp->copied_seq), 0);
 		r->idiag_wqueue = tp->write_seq - tp->snd_una;
 	}
 	if (info)
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5889,7 +5889,7 @@ static int tcp_rcv_synsent_state_process
 		/* Remember, tcp_poll() does not lock socket!
 		 * Change state from SYN-SENT only after copied_seq
 		 * is initialized. */
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 		smc_check_reset_syn(tp);
 
@@ -5964,7 +5964,7 @@ discard:
 		}
 
 		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
-		tp->copied_seq = tp->rcv_nxt;
+		WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
 		/* RFC1323: The window in SYN & SYN/ACK segments is
@@ -6126,7 +6126,7 @@ int tcp_rcv_state_process(struct sock *s
 			tcp_rearm_rto(sk);
 		} else {
 			tcp_init_transfer(sk, BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB);
-			tp->copied_seq = tp->rcv_nxt;
+			WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 		}
 		smp_mb();
 		tcp_set_state(sk, TCP_ESTABLISHED);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2340,7 +2340,7 @@ static void get_tcp4_sock(struct sock *s
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -470,7 +470,7 @@ struct sock *tcp_create_openreq_child(co
 
 	seq = treq->rcv_isn + 1;
 	newtp->rcv_wup = seq;
-	newtp->copied_seq = seq;
+	WRITE_ONCE(newtp->copied_seq, seq);
 	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3381,7 +3381,7 @@ static void tcp_connect_init(struct sock
 	else
 		tp->rcv_tstamp = tcp_jiffies32;
 	tp->rcv_wup = tp->rcv_nxt;
-	tp->copied_seq = tp->rcv_nxt;
+	WRITE_ONCE(tp->copied_seq, tp->rcv_nxt);
 
 	inet_csk(sk)->icsk_rto = tcp_timeout_init(sk);
 	inet_csk(sk)->icsk_retransmits = 0;
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1839,7 +1839,7 @@ static void get_tcp6_sock(struct seq_fil
 		 * we might find a transient negative value.
 		 */
 		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
-				      tp->copied_seq, 0);
+				      READ_ONCE(tp->copied_seq), 0);
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "


