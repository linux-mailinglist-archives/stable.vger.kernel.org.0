Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6912D65A8
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390509AbgLJObf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:31:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:39216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390496AbgLJObb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:31:31 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 04/31] geneve: pull IP header before ECN decapsulation
Date:   Thu, 10 Dec 2020 15:26:41 +0100
Message-Id: <20201210142602.311220485@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.099683598@linuxfoundation.org>
References: <20201210142602.099683598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

IP_ECN_decapsulate() and IP6_ECN_decapsulate() assume
IP header is already pulled.

geneve does not ensure this yet.

Fixing this generically in IP_ECN_decapsulate() and
IP6_ECN_decapsulate() is not possible, since callers
pass a pointer that might be freed by pskb_may_pull()

syzbot reported :

BUG: KMSAN: uninit-value in __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
BUG: KMSAN: uninit-value in INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
CPU: 1 PID: 8941 Comm: syz-executor.0 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x21c/0x280 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x5f/0xa0 mm/kmsan/kmsan_instr.c:197
 __INET_ECN_decapsulate include/net/inet_ecn.h:238 [inline]
 INET_ECN_decapsulate+0x345/0x1db0 include/net/inet_ecn.h:260
 geneve_rx+0x2103/0x2980 include/net/inet_ecn.h:306
 geneve_udp_encap_recv+0x105c/0x1340 drivers/net/geneve.c:377
 udp_queue_rcv_one_skb+0x193a/0x1af0 net/ipv4/udp.c:2093
 udp_queue_rcv_skb+0x282/0x1050 net/ipv4/udp.c:2167
 udp_unicast_rcv_skb net/ipv4/udp.c:2325 [inline]
 __udp4_lib_rcv+0x399d/0x5880 net/ipv4/udp.c:2394
 udp_rcv+0x5c/0x70 net/ipv4/udp.c:2564
 ip_protocol_deliver_rcu+0x572/0xc50 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x583/0x8d0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:449 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0x5c3/0x840 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core net/core/dev.c:5315 [inline]
 __netif_receive_skb+0x1ec/0x640 net/core/dev.c:5429
 process_backlog+0x523/0xc10 net/core/dev.c:6319
 napi_poll+0x420/0x1010 net/core/dev.c:6763
 net_rx_action+0x35c/0xd40 net/core/dev.c:6833
 __do_softirq+0x1a9/0x6fa kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x6e/0x90 arch/x86/kernel/irq_64.c:77
 do_softirq kernel/softirq.c:343 [inline]
 __local_bh_enable_ip+0x184/0x1d0 kernel/softirq.c:195
 local_bh_enable+0x36/0x40 include/linux/bottom_half.h:32
 rcu_read_unlock_bh include/linux/rcupdate.h:730 [inline]
 __dev_queue_xmit+0x3a9b/0x4520 net/core/dev.c:4167
 dev_queue_xmit+0x4b/0x60 net/core/dev.c:4173
 packet_snd net/packet/af_packet.c:2992 [inline]
 packet_sendmsg+0x86f9/0x99d0 net/packet/af_packet.c:3017
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg net/socket.c:671 [inline]
 __sys_sendto+0x9dc/0xc80 net/socket.c:1992
 __do_sys_sendto net/socket.c:2004 [inline]
 __se_sys_sendto+0x107/0x130 net/socket.c:2000
 __x64_sys_sendto+0x6e/0x90 net/socket.c:2000
 do_syscall_64+0x9f/0x140 arch/x86/entry/common.c:48
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20201201090507.4137906-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/geneve.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index f48006c22a8a6..5eb7f409dc10b 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -254,11 +254,21 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		skb_dst_set(skb, &tun_dst->dst);
 
 	/* Ignore packet loops (and multicast echo) */
-	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
-		geneve->dev->stats.rx_errors++;
-		goto drop;
+	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr))
+		goto rx_error;
+
+	switch (skb_protocol(skb, true)) {
+	case htons(ETH_P_IP):
+		if (pskb_may_pull(skb, sizeof(struct iphdr)))
+			goto rx_error;
+		break;
+	case htons(ETH_P_IPV6):
+		if (pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+			goto rx_error;
+		break;
+	default:
+		goto rx_error;
 	}
-
 	oiph = skb_network_header(skb);
 	skb_reset_network_header(skb);
 
@@ -299,6 +309,8 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		u64_stats_update_end(&stats->syncp);
 	}
 	return;
+rx_error:
+	geneve->dev->stats.rx_errors++;
 drop:
 	/* Consume bad packet */
 	kfree_skb(skb);
-- 
2.27.0



