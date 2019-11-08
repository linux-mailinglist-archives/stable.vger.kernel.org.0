Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEC3F573F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfKHTTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389459AbfKHTAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C97DB22487;
        Fri,  8 Nov 2019 18:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239499;
        bh=cJbxRrxVUDrcamWC9gizAKBxjcLjcbmakCzcEreYM+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mlk/M9xlCuk7GsrpsPVNpi/lo2RgyzB3rcKzWN4OzaWvkFZp9O9U6bTefzKKtQ2Ci
         uGO8w1UZVewJLOu/ha06nZkj89dGafC+JNsNjGhqvqbqNqfq7HThmAa0h1XKmQ9Xt0
         C1AjisvXE/GnF2ZMV4CSPXleY79xh9O6aeUpEG6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 25/62] net: annotate accesses to sk->sk_incoming_cpu
Date:   Fri,  8 Nov 2019 19:50:13 +0100
Message-Id: <20191108174740.266785766@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7170a977743b72cf3eb46ef6ef89885dc7ad3621 ]

This socket field can be read and written by concurrent cpus.

Use READ_ONCE() and WRITE_ONCE() annotations to document this,
and avoid some compiler 'optimizations'.

KCSAN reported :

BUG: KCSAN: data-race in tcp_v4_rcv / tcp_v4_rcv

write to 0xffff88812220763c of 4 bytes by interrupt on cpu 0:
 sk_incoming_cpu_update include/net/sock.h:953 [inline]
 tcp_v4_rcv+0x1b3c/0x1bb0 net/ipv4/tcp_ipv4.c:1934
 ip_protocol_deliver_rcu+0x4d/0x420 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 do_softirq.part.0+0x6b/0x80 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x76/0x80 kernel/softirq.c:189

read to 0xffff88812220763c of 4 bytes by interrupt on cpu 1:
 sk_incoming_cpu_update include/net/sock.h:952 [inline]
 tcp_v4_rcv+0x181a/0x1bb0 net/ipv4/tcp_ipv4.c:1934
 ip_protocol_deliver_rcu+0x4d/0x420 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x110/0x140 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_local_deliver+0x133/0x210 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish+0x121/0x160 net/ipv4/ip_input.c:413
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip_rcv+0x18f/0x1a0 net/ipv4/ip_input.c:523
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 run_ksoftirqd+0x46/0x60 kernel/softirq.c:603
 smpboot_thread_fn+0x37d/0x4a0 kernel/smpboot.c:165

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h          |    4 ++--
 net/core/sock.c             |    4 ++--
 net/ipv4/inet_hashtables.c  |    2 +-
 net/ipv4/udp.c              |    2 +-
 net/ipv6/inet6_hashtables.c |    2 +-
 net/ipv6/udp.c              |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -916,8 +916,8 @@ static inline void sk_incoming_cpu_updat
 {
 	int cpu = raw_smp_processor_id();
 
-	if (unlikely(sk->sk_incoming_cpu != cpu))
-		sk->sk_incoming_cpu = cpu;
+	if (unlikely(READ_ONCE(sk->sk_incoming_cpu) != cpu))
+		WRITE_ONCE(sk->sk_incoming_cpu, cpu);
 }
 
 static inline void sock_rps_record_flow_hash(__u32 hash)
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1039,7 +1039,7 @@ set_rcvbuf:
 		break;
 
 	case SO_INCOMING_CPU:
-		sk->sk_incoming_cpu = val;
+		WRITE_ONCE(sk->sk_incoming_cpu, val);
 		break;
 
 	case SO_CNX_ADVICE:
@@ -1351,7 +1351,7 @@ int sock_getsockopt(struct socket *sock,
 		break;
 
 	case SO_INCOMING_CPU:
-		v.val = sk->sk_incoming_cpu;
+		v.val = READ_ONCE(sk->sk_incoming_cpu);
 		break;
 
 	case SO_MEMINFO:
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -193,7 +193,7 @@ static inline int compute_score(struct s
 			if (sk->sk_bound_dev_if)
 				score += 4;
 		}
-		if (sk->sk_incoming_cpu == raw_smp_processor_id())
+		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
 	return score;
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -419,7 +419,7 @@ static int compute_score(struct sock *sk
 			score += 4;
 	}
 
-	if (sk->sk_incoming_cpu == raw_smp_processor_id())
+	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
 	return score;
 }
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -118,7 +118,7 @@ static inline int compute_score(struct s
 			if (sk->sk_bound_dev_if)
 				score++;
 		}
-		if (sk->sk_incoming_cpu == raw_smp_processor_id())
+		if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 			score++;
 	}
 	return score;
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -170,7 +170,7 @@ static int compute_score(struct sock *sk
 			score++;
 	}
 
-	if (sk->sk_incoming_cpu == raw_smp_processor_id())
+	if (READ_ONCE(sk->sk_incoming_cpu) == raw_smp_processor_id())
 		score++;
 
 	return score;


