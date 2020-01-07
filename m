Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CC3133186
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgAGVBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgAGVBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 519AD24681;
        Tue,  7 Jan 2020 21:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430891;
        bh=Cu6WUYjVklpSku1CcDn5eTexZEt9pRmA5OBB/yN8Tko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8YxTPbU8KnfZ279+1gfO3qoHIdWnsw8T3UUS3mBOceIdSZQ42lNN8HCrOAySzxEY
         m5Wn6mDIx2hI5fKC+RvuDafuqShL2w8rY2NAljVZHnXFnK4JiaD3IK42n3klojdU9j
         teCVg2VJAzNeiCsf/iuLkRTKmfnRdgty9xWrT+kQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 140/191] net/sched: annotate lockless accesses to qdisc->empty
Date:   Tue,  7 Jan 2020 21:54:20 +0100
Message-Id: <20200107205340.472013034@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 90b2be27bb0e56483f335cc10fb59ec66882b949 upstream.

KCSAN reported the following race [1]

BUG: KCSAN: data-race in __dev_queue_xmit / net_tx_action

read to 0xffff8880ba403508 of 1 bytes by task 21814 on cpu 1:
 __dev_xmit_skb net/core/dev.c:3389 [inline]
 __dev_queue_xmit+0x9db/0x1b40 net/core/dev.c:3761
 dev_queue_xmit+0x21/0x30 net/core/dev.c:3825
 neigh_hh_output include/net/neighbour.h:500 [inline]
 neigh_output include/net/neighbour.h:509 [inline]
 ip6_finish_output2+0x873/0xec0 net/ipv6/ip6_output.c:116
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880ba403508 of 1 bytes by interrupt on cpu 0:
 qdisc_run_begin include/net/sch_generic.h:160 [inline]
 qdisc_run include/net/pkt_sched.h:120 [inline]
 net_tx_action+0x2b1/0x6c0 net/core/dev.c:4551
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 do_softirq.part.0+0x6b/0x80 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x76/0x80 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:688 [inline]
 ip6_finish_output2+0x7bb/0xec0 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:142 [inline]
 __ip6_finish_output+0x2d7/0x330 net/ipv6/ip6_output.c:127
 ip6_finish_output+0x41/0x160 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0xf2/0x280 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 ip6_local_out+0x74/0x90 net/ipv6/output_core.c:179
 ip6_send_skb+0x53/0x110 net/ipv6/ip6_output.c:1795
 udp_v6_send_skb.isra.0+0x3ec/0xa70 net/ipv6/udp.c:1173
 udpv6_sendmsg+0x1906/0x1c20 net/ipv6/udp.c:1471
 inet6_sendmsg+0x6d/0x90 net/ipv6/af_inet6.c:576
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0x9f/0xc0 net/socket.c:657
 ___sys_sendmsg+0x2b7/0x5d0 net/socket.c:2311
 __sys_sendmmsg+0x123/0x350 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x64/0x80 net/socket.c:2439
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 21817 Comm: syz-executor.2 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: d518d2ed8640 ("net/sched: fix race between deactivation and dequeue for NOLOCK qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sch_generic.h |    6 +++---
 net/core/dev.c            |    2 +-
 net/sched/sch_generic.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -149,8 +149,8 @@ static inline bool qdisc_is_percpu_stats
 static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 {
 	if (qdisc_is_percpu_stats(qdisc))
-		return qdisc->empty;
-	return !qdisc->q.qlen;
+		return READ_ONCE(qdisc->empty);
+	return !READ_ONCE(qdisc->q.qlen);
 }
 
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
@@ -158,7 +158,7 @@ static inline bool qdisc_run_begin(struc
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
-		qdisc->empty = false;
+		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3386,7 +3386,7 @@ static inline int __dev_xmit_skb(struct
 	qdisc_calculate_pkt_len(skb, q);
 
 	if (q->flags & TCQ_F_NOLOCK) {
-		if ((q->flags & TCQ_F_CAN_BYPASS) && q->empty &&
+		if ((q->flags & TCQ_F_CAN_BYPASS) && READ_ONCE(q->empty) &&
 		    qdisc_run_begin(q)) {
 			if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED,
 					      &q->state))) {
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -657,7 +657,7 @@ static struct sk_buff *pfifo_fast_dequeu
 	if (likely(skb)) {
 		qdisc_update_stats_at_dequeue(qdisc, skb);
 	} else {
-		qdisc->empty = true;
+		WRITE_ONCE(qdisc->empty, true);
 	}
 
 	return skb;


