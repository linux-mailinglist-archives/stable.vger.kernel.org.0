Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB5AF5727
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732654AbfKHTSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:18:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389507AbfKHTAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78EA72248B;
        Fri,  8 Nov 2019 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239502;
        bh=86nb92PDTNLvFu8dy83PXzdtNe20eFOcQojuKusXuR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaInbbAHw/3gNX5OpPYs18PGj6pquhgI/A/JpJXV969LZCFn7YyfFuatTRCTpvjZW
         QNhLAL7eCRZ0Z72n3eyw6q4cMjnlsanf2wSHbErMDBteA7K8Rd/yJSyeCy/T/YoV4j
         kOQVjUZWZUqaAL4s59IdrpcL1LFR2B+6rAkALpjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 26/62] net: annotate lockless accesses to sk->sk_napi_id
Date:   Fri,  8 Nov 2019 19:50:14 +0100
Message-Id: <20191108174740.783238674@linuxfoundation.org>
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

[ Upstream commit ee8d153d46a3b98c064ee15c0c0a3bbf1450e5a1 ]

We already annotated most accesses to sk->sk_napi_id

We missed sk_mark_napi_id() and sk_mark_napi_id_once()
which might be called without socket lock held in UDP stack.

KCSAN reported :
BUG: KCSAN: data-race in udpv6_queue_rcv_one_skb / udpv6_queue_rcv_one_skb

write to 0xffff888121c6d108 of 4 bytes by interrupt on cpu 0:
 sk_mark_napi_id include/net/busy_poll.h:125 [inline]
 __udpv6_queue_rcv_skb net/ipv6/udp.c:571 [inline]
 udpv6_queue_rcv_one_skb+0x70c/0xb40 net/ipv6/udp.c:672
 udpv6_queue_rcv_skb+0xb5/0x400 net/ipv6/udp.c:689
 udp6_unicast_rcv_skb.isra.0+0xd7/0x180 net/ipv6/udp.c:832
 __udp6_lib_rcv+0x69c/0x1770 net/ipv6/udp.c:913
 udpv6_rcv+0x2b/0x40 net/ipv6/udp.c:1015
 ip6_protocol_deliver_rcu+0x22a/0xbe0 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x30/0x50 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x177/0x190 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish+0x110/0x140 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x1a1/0x1b0 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955
 napi_poll net/core/dev.c:6392 [inline]
 net_rx_action+0x3ae/0xa90 net/core/dev.c:6460

write to 0xffff888121c6d108 of 4 bytes by interrupt on cpu 1:
 sk_mark_napi_id include/net/busy_poll.h:125 [inline]
 __udpv6_queue_rcv_skb net/ipv6/udp.c:571 [inline]
 udpv6_queue_rcv_one_skb+0x70c/0xb40 net/ipv6/udp.c:672
 udpv6_queue_rcv_skb+0xb5/0x400 net/ipv6/udp.c:689
 udp6_unicast_rcv_skb.isra.0+0xd7/0x180 net/ipv6/udp.c:832
 __udp6_lib_rcv+0x69c/0x1770 net/ipv6/udp.c:913
 udpv6_rcv+0x2b/0x40 net/ipv6/udp.c:1015
 ip6_protocol_deliver_rcu+0x22a/0xbe0 net/ipv6/ip6_input.c:409
 ip6_input_finish+0x30/0x50 net/ipv6/ip6_input.c:450
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ip6_input+0x177/0x190 net/ipv6/ip6_input.c:459
 dst_input include/net/dst.h:442 [inline]
 ip6_rcv_finish+0x110/0x140 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:305 [inline]
 NF_HOOK include/linux/netfilter.h:299 [inline]
 ipv6_rcv+0x1a1/0x1b0 net/ipv6/ip6_input.c:284
 __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5010
 __netif_receive_skb+0x37/0xf0 net/core/dev.c:5124
 process_backlog+0x1d3/0x420 net/core/dev.c:5955

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 10890 Comm: syz-executor.0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: e68b6e50fa35 ("udp: enable busy polling for all sockets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/busy_poll.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -134,7 +134,7 @@ static inline void skb_mark_napi_id(stru
 static inline void sk_mark_napi_id(struct sock *sk, const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	sk->sk_napi_id = skb->napi_id;
+	WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 }
 
@@ -143,8 +143,8 @@ static inline void sk_mark_napi_id_once(
 					const struct sk_buff *skb)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	if (!sk->sk_napi_id)
-		sk->sk_napi_id = skb->napi_id;
+	if (!READ_ONCE(sk->sk_napi_id))
+		WRITE_ONCE(sk->sk_napi_id, skb->napi_id);
 #endif
 }
 


