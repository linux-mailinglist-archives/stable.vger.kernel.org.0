Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BF3F5673
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390735AbfKHTI4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:08:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731858AbfKHTIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:08:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B87C2087E;
        Fri,  8 Nov 2019 19:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240133;
        bh=RWbStq+fKYR+1RUlQz67+a9dAeLcFUMJ7yEQAVWyvsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=umRMIyUSUVcll0MHq40EdVYTTu6XjUALQNr28AvM5hpUaFtCE5P8ZweaITrKykPwY
         gunCZrcbUyn/dbCBgHYiBpxyjqUx8xUDG4TFy94ftdqKhFrH1zgXPCOPwL040A/9KO
         X2OccKR+Gi8yHyMvohHp0ccJqI1dmUKvjYGwQJJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 099/140] udp: use skb_queue_empty_lockless()
Date:   Fri,  8 Nov 2019 19:50:27 +0100
Message-Id: <20191108174911.235642946@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 137a0dbe3426fd7bcfe3f8117b36a87b3590e4eb ]

syzbot reported a data-race [1].

We should use skb_queue_empty_lockless() to document that we are
not ensuring a mutual exclusion and silence KCSAN.

[1]
BUG: KCSAN: data-race in __skb_recv_udp / __udp_enqueue_schedule_skb

write to 0xffff888122474b50 of 8 bytes by interrupt on cpu 0:
 __skb_insert include/linux/skbuff.h:1852 [inline]
 __skb_queue_before include/linux/skbuff.h:1958 [inline]
 __skb_queue_tail include/linux/skbuff.h:1991 [inline]
 __udp_enqueue_schedule_skb+0x2c1/0x410 net/ipv4/udp.c:1470
 __udp_queue_rcv_skb net/ipv4/udp.c:1940 [inline]
 udp_queue_rcv_one_skb+0x7bd/0xc70 net/ipv4/udp.c:2057
 udp_queue_rcv_skb+0xb5/0x400 net/ipv4/udp.c:2074
 udp_unicast_rcv_skb.isra.0+0x7e/0x1c0 net/ipv4/udp.c:2233
 __udp4_lib_rcv+0xa44/0x17c0 net/ipv4/udp.c:2300
 udp_rcv+0x2b/0x40 net/ipv4/udp.c:2470
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

read to 0xffff888122474b50 of 8 bytes by task 8921 on cpu 1:
 skb_queue_empty include/linux/skbuff.h:1494 [inline]
 __skb_recv_udp+0x18d/0x500 net/ipv4/udp.c:1653
 udp_recvmsg+0xe1/0xb10 net/ipv4/udp.c:1712
 inet_recvmsg+0xbb/0x250 net/ipv4/af_inet.c:838
 sock_recvmsg_nosec+0x5c/0x70 net/socket.c:871
 ___sys_recvmsg+0x1a0/0x3e0 net/socket.c:2480
 do_recvmmsg+0x19a/0x5c0 net/socket.c:2601
 __sys_recvmmsg+0x1ef/0x200 net/socket.c:2680
 __do_sys_recvmmsg net/socket.c:2703 [inline]
 __se_sys_recvmmsg net/socket.c:2696 [inline]
 __x64_sys_recvmmsg+0x89/0xb0 net/socket.c:2696
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 8921 Comm: syz-executor.4 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1588,7 +1588,7 @@ static int first_packet_length(struct so
 
 	spin_lock_bh(&rcvq->lock);
 	skb = __first_packet_length(sk, rcvq, &total);
-	if (!skb && !skb_queue_empty(sk_queue)) {
+	if (!skb && !skb_queue_empty_lockless(sk_queue)) {
 		spin_lock(&sk_queue->lock);
 		skb_queue_splice_tail_init(sk_queue, rcvq);
 		spin_unlock(&sk_queue->lock);
@@ -1661,7 +1661,7 @@ struct sk_buff *__skb_recv_udp(struct so
 				return skb;
 			}
 
-			if (skb_queue_empty(sk_queue)) {
+			if (skb_queue_empty_lockless(sk_queue)) {
 				spin_unlock_bh(&queue->lock);
 				goto busy_check;
 			}
@@ -1687,7 +1687,7 @@ busy_check:
 				break;
 
 			sk_busy_loop(sk, flags & MSG_DONTWAIT);
-		} while (!skb_queue_empty(sk_queue));
+		} while (!skb_queue_empty_lockless(sk_queue));
 
 		/* sk_queue is empty, reader_queue may contain peeked packets */
 	} while (timeo &&


