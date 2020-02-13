Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1B215C165
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgBMPXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgBMPXA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:00 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0523E2469C;
        Thu, 13 Feb 2020 15:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607380;
        bh=TmD2bJfVghIxBgeQMl8W9YvpnhUUlp0KThkHrdEJluQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03UMn17SzNp+Zxi1QQf1pxJS6sNwaVfJBny6jkVtRj2gD2U1zORxUY89GpX5caUg3
         wIbq1VxIdBL6APjXzHnMK4K0cQafGd3djV/N6ypGPjg1KEBltBp/GRMWoR78ZpOUV/
         HmWZgACH/XXPSa4fArmsqyVnj96dJrryWD1wMM+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 59/91] bonding/alb: properly access headers in bond_alb_xmit()
Date:   Thu, 13 Feb 2020 07:20:16 -0800
Message-Id: <20200213151844.799234178@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38f88c45404293bbc027b956def6c10cbd45c616 ]

syzbot managed to send an IPX packet through bond_alb_xmit()
and af_packet and triggered a use-after-free.

First, bond_alb_xmit() was using ipx_hdr() helper to reach
the IPX header, but ipx_hdr() was using the transport offset
instead of the network offset. In the particular syzbot
report transport offset was 0xFFFF

This patch removes ipx_hdr() since it was only (mis)used from bonding.

Then we need to make sure IPv4/IPv6/IPX headers are pulled
in skb->head before dereferencing anything.

BUG: KASAN: use-after-free in bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
Read of size 2 at addr ffff8801ce56dfff by task syz-executor.2/18108
 (if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) ...)

Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 [<ffffffff8441fc42>] __dump_stack lib/dump_stack.c:17 [inline]
 [<ffffffff8441fc42>] dump_stack+0x14d/0x20b lib/dump_stack.c:53
 [<ffffffff81a7dec4>] print_address_description+0x6f/0x20b mm/kasan/report.c:282
 [<ffffffff81a7e0ec>] kasan_report_error mm/kasan/report.c:380 [inline]
 [<ffffffff81a7e0ec>] kasan_report mm/kasan/report.c:438 [inline]
 [<ffffffff81a7e0ec>] kasan_report.cold+0x8c/0x2a0 mm/kasan/report.c:422
 [<ffffffff81a7dc4f>] __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:469
 [<ffffffff82c8c00a>] bond_alb_xmit+0x153a/0x1590 drivers/net/bonding/bond_alb.c:1452
 [<ffffffff82c60c74>] __bond_start_xmit drivers/net/bonding/bond_main.c:4199 [inline]
 [<ffffffff82c60c74>] bond_start_xmit+0x4f4/0x1570 drivers/net/bonding/bond_main.c:4224
 [<ffffffff83baa558>] __netdev_start_xmit include/linux/netdevice.h:4525 [inline]
 [<ffffffff83baa558>] netdev_start_xmit include/linux/netdevice.h:4539 [inline]
 [<ffffffff83baa558>] xmit_one net/core/dev.c:3611 [inline]
 [<ffffffff83baa558>] dev_hard_start_xmit+0x168/0x910 net/core/dev.c:3627
 [<ffffffff83bacf35>] __dev_queue_xmit+0x1f55/0x33b0 net/core/dev.c:4238
 [<ffffffff83bae3a8>] dev_queue_xmit+0x18/0x20 net/core/dev.c:4278
 [<ffffffff84339189>] packet_snd net/packet/af_packet.c:3226 [inline]
 [<ffffffff84339189>] packet_sendmsg+0x4919/0x70b0 net/packet/af_packet.c:3252
 [<ffffffff83b1ac0c>] sock_sendmsg_nosec net/socket.c:673 [inline]
 [<ffffffff83b1ac0c>] sock_sendmsg+0x12c/0x160 net/socket.c:684
 [<ffffffff83b1f5a2>] __sys_sendto+0x262/0x380 net/socket.c:1996
 [<ffffffff83b1f700>] SYSC_sendto net/socket.c:2008 [inline]
 [<ffffffff83b1f700>] SyS_sendto+0x40/0x60 net/socket.c:2004

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_alb.c |   44 +++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1371,26 +1371,31 @@ int bond_alb_xmit(struct sk_buff *skb, s
 	bool do_tx_balance = true;
 	u32 hash_index = 0;
 	const u8 *hash_start = NULL;
-	struct ipv6hdr *ip6hdr;
 
 	skb_reset_mac_header(skb);
 	eth_data = eth_hdr(skb);
 
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-		const struct iphdr *iph = ip_hdr(skb);
+		const struct iphdr *iph;
 
 		if (ether_addr_equal_64bits(eth_data->h_dest, mac_bcast) ||
-		    (iph->daddr == ip_bcast) ||
-		    (iph->protocol == IPPROTO_IGMP)) {
+		    (!pskb_network_may_pull(skb, sizeof(*iph)))) {
+			do_tx_balance = false;
+			break;
+		}
+		iph = ip_hdr(skb);
+		if (iph->daddr == ip_bcast || iph->protocol == IPPROTO_IGMP) {
 			do_tx_balance = false;
 			break;
 		}
 		hash_start = (char *)&(iph->daddr);
 		hash_size = sizeof(iph->daddr);
-	}
 		break;
-	case ETH_P_IPV6:
+	}
+	case ETH_P_IPV6: {
+		const struct ipv6hdr *ip6hdr;
+
 		/* IPv6 doesn't really use broadcast mac address, but leave
 		 * that here just in case.
 		 */
@@ -1407,7 +1412,11 @@ int bond_alb_xmit(struct sk_buff *skb, s
 			break;
 		}
 
-		/* Additianally, DAD probes should not be tx-balanced as that
+		if (!pskb_network_may_pull(skb, sizeof(*ip6hdr))) {
+			do_tx_balance = false;
+			break;
+		}
+		/* Additionally, DAD probes should not be tx-balanced as that
 		 * will lead to false positives for duplicate addresses and
 		 * prevent address configuration from working.
 		 */
@@ -1417,17 +1426,26 @@ int bond_alb_xmit(struct sk_buff *skb, s
 			break;
 		}
 
-		hash_start = (char *)&(ipv6_hdr(skb)->daddr);
-		hash_size = sizeof(ipv6_hdr(skb)->daddr);
+		hash_start = (char *)&ip6hdr->daddr;
+		hash_size = sizeof(ip6hdr->daddr);
 		break;
-	case ETH_P_IPX:
-		if (ipx_hdr(skb)->ipx_checksum != IPX_NO_CHECKSUM) {
+	}
+	case ETH_P_IPX: {
+		const struct ipxhdr *ipxhdr;
+
+		if (pskb_network_may_pull(skb, sizeof(*ipxhdr))) {
+			do_tx_balance = false;
+			break;
+		}
+		ipxhdr = (struct ipxhdr *)skb_network_header(skb);
+
+		if (ipxhdr->ipx_checksum != IPX_NO_CHECKSUM) {
 			/* something is wrong with this packet */
 			do_tx_balance = false;
 			break;
 		}
 
-		if (ipx_hdr(skb)->ipx_type != IPX_TYPE_NCP) {
+		if (ipxhdr->ipx_type != IPX_TYPE_NCP) {
 			/* The only protocol worth balancing in
 			 * this family since it has an "ARP" like
 			 * mechanism
@@ -1436,9 +1454,11 @@ int bond_alb_xmit(struct sk_buff *skb, s
 			break;
 		}
 
+		eth_data = eth_hdr(skb);
 		hash_start = (char *)eth_data->h_dest;
 		hash_size = ETH_ALEN;
 		break;
+	}
 	case ETH_P_ARP:
 		do_tx_balance = false;
 		if (bond_info->rlb_enabled)


