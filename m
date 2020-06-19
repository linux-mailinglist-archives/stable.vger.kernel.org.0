Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6F92011F1
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393776AbgFSPrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404289AbgFSP0M (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75F321556;
        Fri, 19 Jun 2020 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580370;
        bh=NmONvKJ0gOKK07cv1ukhga0XXabhbQVXjH/GnFicpKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oxhQ8rOltAQ5ZgcTMmtibDoFTZQ5eJU4kECAzRJnCII3rBkbcDzlY7fU9XV+8i56Q
         mLF5Irtt2H09NCaF+pVESihpPP7tDcjBylogKr9NUyhk7ILXO4y/iaPAC1gmWgY9AE
         bipwlW46LykpisyRVoHEoVTkdivta2A9uvELkzow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 224/376] macvlan: Skip loopback packets in RX handler
Date:   Fri, 19 Jun 2020 16:32:22 +0200
Message-Id: <20200619141720.920266557@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@nokia.com>

[ Upstream commit 81f3dc9349ce0bf7b8447f147f45e70f0a5b36a6 ]

Ignore loopback-originatig packets soon enough and don't try to process L2
header where it doesn't exist. The very similar br_handle_frame() in bridge
code performs exactly the same check.

This is an example of such ICMPv6 packet:

skb len=96 headroom=40 headlen=96 tailroom=56
mac=(40,0) net=(40,40) trans=80
shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
csum(0xae2e9a2f ip_summed=1 complete_sw=0 valid=0 level=0)
hash(0xc97ebd88 sw=1 l4=1) proto=0x86dd pkttype=5 iif=24
dev name=etha01.212 feat=0x0x0000000040005000
skb headroom: 00000000: 00 7c 86 52 84 88 ff ff 00 00 00 00 00 00 08 00
skb headroom: 00000010: 45 00 00 9e 5d 5c 40 00 40 11 33 33 00 00 00 01
skb headroom: 00000020: 02 40 43 80 00 00 86 dd
skb linear:   00000000: 60 09 88 bd 00 38 3a ff fe 80 00 00 00 00 00 00
skb linear:   00000010: 00 40 43 ff fe 80 00 00 ff 02 00 00 00 00 00 00
skb linear:   00000020: 00 00 00 00 00 00 00 01 86 00 61 00 40 00 00 2d
skb linear:   00000030: 00 00 00 00 00 00 00 00 03 04 40 e0 00 00 01 2c
skb linear:   00000040: 00 00 00 78 00 00 00 00 fd 5f 42 68 23 87 a8 81
skb linear:   00000050: 00 00 00 00 00 00 00 00 01 01 02 40 43 80 00 00
skb tailroom: 00000000: ...
skb tailroom: 00000010: ...
skb tailroom: 00000020: ...
skb tailroom: 00000030: ...

Call Trace, how it happens exactly:
 ...
 macvlan_handle_frame+0x321/0x425 [macvlan]
 ? macvlan_forward_source+0x110/0x110 [macvlan]
 __netif_receive_skb_core+0x545/0xda0
 ? enqueue_task_fair+0xe5/0x8e0
 ? __netif_receive_skb_one_core+0x36/0x70
 __netif_receive_skb_one_core+0x36/0x70
 process_backlog+0x97/0x140
 net_rx_action+0x1eb/0x350
 ? __hrtimer_run_queues+0x136/0x2e0
 __do_softirq+0xe3/0x383
 do_softirq_own_stack+0x2a/0x40
 </IRQ>
 do_softirq.part.4+0x4e/0x50
 netif_rx_ni+0x60/0xd0
 dev_loopback_xmit+0x83/0xf0
 ip6_finish_output2+0x575/0x590 [ipv6]
 ? ip6_cork_release.isra.1+0x64/0x90 [ipv6]
 ? __ip6_make_skb+0x38d/0x680 [ipv6]
 ? ip6_output+0x6c/0x140 [ipv6]
 ip6_output+0x6c/0x140 [ipv6]
 ip6_send_skb+0x1e/0x60 [ipv6]
 rawv6_sendmsg+0xc4b/0xe10 [ipv6]
 ? proc_put_long+0xd0/0xd0
 ? rw_copy_check_uvector+0x4e/0x110
 ? sock_sendmsg+0x36/0x40
 sock_sendmsg+0x36/0x40
 ___sys_sendmsg+0x2b6/0x2d0
 ? proc_dointvec+0x23/0x30
 ? addrconf_sysctl_forward+0x8d/0x250 [ipv6]
 ? dev_forward_change+0x130/0x130 [ipv6]
 ? _raw_spin_unlock+0x12/0x30
 ? proc_sys_call_handler.isra.14+0x9f/0x110
 ? __call_rcu+0x213/0x510
 ? get_max_files+0x10/0x10
 ? trace_hardirqs_on+0x2c/0xe0
 ? __sys_sendmsg+0x63/0xa0
 __sys_sendmsg+0x63/0xa0
 do_syscall_64+0x6c/0x1e0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 0482adc9916b..e900ebb94499 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -447,6 +447,10 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 	int ret;
 	rx_handler_result_t handle_res;
 
+	/* Packets from dev_loopback_xmit() do not have L2 header, bail out */
+	if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
+		return RX_HANDLER_PASS;
+
 	port = macvlan_port_get_rcu(skb->dev);
 	if (is_multicast_ether_addr(eth->h_dest)) {
 		unsigned int hash;
-- 
2.25.1



