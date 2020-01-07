Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B03B1332FF
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgAGVH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729137AbgAGVH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:07:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDB4E214D8;
        Tue,  7 Jan 2020 21:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431277;
        bh=FmEoLirVxFYfYhzNaVwDrfd7DmCosCQvUSN3ZwTXEHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ew7be6QYPoAiV4sHWZTmKkFieyB9Mjc/twuWYzgwOYavIVZD8DeKi5NB7arO7SYXx
         kawZ0qQNN5OFcgoS46CGk19xdKIX5dSd2SrdbMwK+HpTP2x1By5815aQvCaByur0zt
         E0MXQ+TO+LnZ96NrAMDHNbKQuoju0nzRQ1PNP1O8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/115] tcp: annotate tp->rcv_nxt lockless reads
Date:   Tue,  7 Jan 2020 21:55:16 +0100
Message-Id: <20200107205308.865100963@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit dba7d9b8c739df27ff3a234c81d6c6b23e3986fa ]

There are few places where we fetch tp->rcv_nxt while
this field can change from IRQ or other cpu.

We need to add READ_ONCE() annotations, and also make
sure write sides use corresponding WRITE_ONCE() to avoid
store-tearing.

Note that tcp_inq_hint() was already using READ_ONCE(tp->rcv_nxt)

syzbot reported :

BUG: KCSAN: data-race in tcp_poll / tcp_queue_rcv

write to 0xffff888120425770 of 4 bytes by interrupt on cpu 0:
 tcp_rcv_nxt_update net/ipv4/tcp_input.c:3365 [inline]
 tcp_queue_rcv+0x180/0x380 net/ipv4/tcp_input.c:4638
 tcp_rcv_established+0xbf1/0xf50 net/ipv4/tcp_input.c:5616
 tcp_v4_do_rcv+0x381/0x4e0 net/ipv4/tcp_ipv4.c:1542
 tcp_v4_rcv+0x1a03/0x1bf0 net/ipv4/tcp_ipv4.c:1923
 ip_protocol_deliver_rcu+0x51/0x470 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
 netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
 napi_skb_finish net/core/dev.c:5671 [inline]
 napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
 receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061

read to 0xffff888120425770 of 4 bytes by task 7254 on cpu 1:
 tcp_stream_is_readable net/ipv4/tcp.c:480 [inline]
 tcp_poll+0x204/0x6b0 net/ipv4/tcp.c:554
 sock_poll+0xed/0x250 net/socket.c:1256
 vfs_poll include/linux/poll.h:90 [inline]
 ep_item_poll.isra.0+0x90/0x190 fs/eventpoll.c:892
 ep_send_events_proc+0x113/0x5c0 fs/eventpoll.c:1749
 ep_scan_ready_list.constprop.0+0x189/0x500 fs/eventpoll.c:704
 ep_send_events fs/eventpoll.c:1793 [inline]
 ep_poll+0xe3/0x900 fs/eventpoll.c:1930
 do_epoll_wait+0x162/0x180 fs/eventpoll.c:2294
 __do_sys_epoll_pwait fs/eventpoll.c:2325 [inline]
 __se_sys_epoll_pwait fs/eventpoll.c:2311 [inline]
 __x64_sys_epoll_pwait+0xcd/0x170 fs/eventpoll.c:2311
 do_syscall_64+0xcf/0x2f0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 7254 Comm: syz-fuzzer Not tainted 5.3.0+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c           | 4 ++--
 net/ipv4/tcp_diag.c      | 2 +-
 net/ipv4/tcp_input.c     | 6 +++---
 net/ipv4/tcp_ipv4.c      | 3 ++-
 net/ipv4/tcp_minisocks.c | 7 +++++--
 net/ipv6/tcp_ipv6.c      | 3 ++-
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index a7a804bece7a..7561fa1bcc3e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -488,7 +488,7 @@ static void tcp_tx_timestamp(struct sock *sk, u16 tsflags)
 static inline bool tcp_stream_is_readable(const struct tcp_sock *tp,
 					  int target, struct sock *sk)
 {
-	return (tp->rcv_nxt - tp->copied_seq >= target) ||
+	return (READ_ONCE(tp->rcv_nxt) - tp->copied_seq >= target) ||
 		(sk->sk_prot->stream_memory_read ?
 		sk->sk_prot->stream_memory_read(sk) : false);
 }
@@ -2866,7 +2866,7 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		else if (tp->repair_queue == TCP_SEND_QUEUE)
 			tp->write_seq = val;
 		else if (tp->repair_queue == TCP_RECV_QUEUE)
-			tp->rcv_nxt = val;
+			WRITE_ONCE(tp->rcv_nxt, val);
 		else
 			err = -EINVAL;
 		break;
diff --git a/net/ipv4/tcp_diag.c b/net/ipv4/tcp_diag.c
index 81148f7a2323..c9e97f304f98 100644
--- a/net/ipv4/tcp_diag.c
+++ b/net/ipv4/tcp_diag.c
@@ -30,7 +30,7 @@ static void tcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	} else if (sk->sk_type == SOCK_STREAM) {
 		const struct tcp_sock *tp = tcp_sk(sk);
 
-		r->idiag_rqueue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		r->idiag_rqueue = max_t(int, READ_ONCE(tp->rcv_nxt) - tp->copied_seq, 0);
 		r->idiag_wqueue = tp->write_seq - tp->snd_una;
 	}
 	if (info)
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 57e8dad956ec..3a08ee81cbc3 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3348,7 +3348,7 @@ static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
 
 	sock_owned_by_me((struct sock *)tp);
 	tp->bytes_received += delta;
-	tp->rcv_nxt = seq;
+	WRITE_ONCE(tp->rcv_nxt, seq);
 }
 
 /* Update our send window.
@@ -5829,7 +5829,7 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
 		/* Ok.. it's good. Set up sequence numbers and
 		 * move to established.
 		 */
-		tp->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
+		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
 		/* RFC1323: The window in SYN & SYN/ACK segments is
@@ -5932,7 +5932,7 @@ discard:
 			tp->tcp_header_len = sizeof(struct tcphdr);
 		}
 
-		tp->rcv_nxt = TCP_SKB_CB(skb)->seq + 1;
+		WRITE_ONCE(tp->rcv_nxt, TCP_SKB_CB(skb)->seq + 1);
 		tp->copied_seq = tp->rcv_nxt;
 		tp->rcv_wup = TCP_SKB_CB(skb)->seq + 1;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5553f6a833f3..6da393016c11 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2330,7 +2330,8 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
 		 */
-		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+				      tp->copied_seq, 0);
 
 	seq_printf(f, "%4d: %08X:%04X %08X:%04X %02X %08X:%08X %02X:%08lX "
 			"%08X %5u %8d %lu %d %pK %lu %lu %u %u %d",
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 12affb7864d9..7ba8a90772b0 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -454,6 +454,7 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	struct tcp_request_sock *treq = tcp_rsk(req);
 	struct inet_connection_sock *newicsk;
 	struct tcp_sock *oldtp, *newtp;
+	u32 seq;
 
 	if (!newsk)
 		return NULL;
@@ -467,8 +468,10 @@ struct sock *tcp_create_openreq_child(const struct sock *sk,
 	/* Now setup tcp_sock */
 	newtp->pred_flags = 0;
 
-	newtp->rcv_wup = newtp->copied_seq =
-	newtp->rcv_nxt = treq->rcv_isn + 1;
+	seq = treq->rcv_isn + 1;
+	newtp->rcv_wup = seq;
+	newtp->copied_seq = seq;
+	WRITE_ONCE(newtp->rcv_nxt, seq);
 	newtp->segs_in = 1;
 
 	newtp->snd_sml = newtp->snd_una =
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 9a117a79af65..c5f4e89b6ff3 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1839,7 +1839,8 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		/* Because we don't lock the socket,
 		 * we might find a transient negative value.
 		 */
-		rx_queue = max_t(int, tp->rcv_nxt - tp->copied_seq, 0);
+		rx_queue = max_t(int, READ_ONCE(tp->rcv_nxt) -
+				      tp->copied_seq, 0);
 
 	seq_printf(seq,
 		   "%4d: %08X%08X%08X%08X:%04X %08X%08X%08X%08X:%04X "
-- 
2.20.1



