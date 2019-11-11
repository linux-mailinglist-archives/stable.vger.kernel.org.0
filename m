Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF59DF7CAA
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfKKSsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730232AbfKKSs3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBF0221655;
        Mon, 11 Nov 2019 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498107;
        bh=rfmAehunEdpVebtmUwggjQET1YynDZix6Sa7tZjv/Ao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uva2T8cnAqAGZEYFYOorWJKzOmx3VJzyAC0maz4RkylVxNpYlNuzKvYsnLBn7dMJk
         E+xwm7bBhWZKigVyGdS3wGCjK5wKy68OK9bwv69ja7mgwvvkr434/92r9AlX6ULHJj
         Ku3JctEwpVub7QMLisnJcbugKysD/QUFXdu+5pWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 005/193] net: fix data-race in neigh_event_send()
Date:   Mon, 11 Nov 2019 19:26:27 +0100
Message-Id: <20191111181500.241458849@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1b53d64435d56902fc234ff2507142d971a09687 ]

KCSAN reported the following data-race [1]

The fix will also prevent the compiler from optimizing out
the condition.

[1]

BUG: KCSAN: data-race in neigh_resolve_output / neigh_resolve_output

write to 0xffff8880a41dba78 of 8 bytes by interrupt on cpu 1:
 neigh_event_send include/net/neighbour.h:443 [inline]
 neigh_resolve_output+0x78/0x480 net/core/neighbour.c:1474
 neigh_output include/net/neighbour.h:511 [inline]
 ip_finish_output2+0x4af/0xe40 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x23a/0x490 net/ipv4/ip_output.c:290
 ip_finish_output+0x41/0x160 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip_output+0xdf/0x210 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0x74/0x90 net/ipv4/ip_output.c:125
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:237
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 __tcp_retransmit_skb+0x4bd/0x15f0 net/ipv4/tcp_output.c:2976
 tcp_retransmit_skb+0x36/0x1a0 net/ipv4/tcp_output.c:2999
 tcp_retransmit_timer+0x719/0x16d0 net/ipv4/tcp_timer.c:515
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:598
 tcp_write_timer+0xd1/0xf0 net/ipv4/tcp_timer.c:618

read to 0xffff8880a41dba78 of 8 bytes by interrupt on cpu 0:
 neigh_event_send include/net/neighbour.h:442 [inline]
 neigh_resolve_output+0x57/0x480 net/core/neighbour.c:1474
 neigh_output include/net/neighbour.h:511 [inline]
 ip_finish_output2+0x4af/0xe40 net/ipv4/ip_output.c:228
 __ip_finish_output net/ipv4/ip_output.c:308 [inline]
 __ip_finish_output+0x23a/0x490 net/ipv4/ip_output.c:290
 ip_finish_output+0x41/0x160 net/ipv4/ip_output.c:318
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip_output+0xdf/0x210 net/ipv4/ip_output.c:432
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0x74/0x90 net/ipv4/ip_output.c:125
 __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
 ip_queue_xmit+0x45/0x60 include/net/ip.h:237
 __tcp_transmit_skb+0xe81/0x1d60 net/ipv4/tcp_output.c:1169
 tcp_transmit_skb net/ipv4/tcp_output.c:1185 [inline]
 __tcp_retransmit_skb+0x4bd/0x15f0 net/ipv4/tcp_output.c:2976
 tcp_retransmit_skb+0x36/0x1a0 net/ipv4/tcp_output.c:2999
 tcp_retransmit_timer+0x719/0x16d0 net/ipv4/tcp_timer.c:515
 tcp_write_timer_handler+0x42d/0x510 net/ipv4/tcp_timer.c:598

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/neighbour.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -439,8 +439,8 @@ static inline int neigh_event_send(struc
 {
 	unsigned long now = jiffies;
 	
-	if (neigh->used != now)
-		neigh->used = now;
+	if (READ_ONCE(neigh->used) != now)
+		WRITE_ONCE(neigh->used, now);
 	if (!(neigh->nud_state&(NUD_CONNECTED|NUD_DELAY|NUD_PROBE)))
 		return __neigh_event_send(neigh, skb);
 	return 0;


