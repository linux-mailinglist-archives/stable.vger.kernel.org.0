Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CB7300B8F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbhAVSlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbhAVOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79EC23B21;
        Fri, 22 Jan 2021 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324892;
        bh=xXE0x+s5CzYAH7joDz3I+l+LuCoHWNNdi1xpCX1ckBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVR+B8UK5/1U1f6XUfwd3RrfliQohaPp8zItgpJTSPbxOt4fSwijRy6Ye9jxulT92
         Xyktq8s8c/amFFw8U2t9NYv0+rX3/HSFhYvXLiyxlC0xUwFFzoL5ECQyfx9/8lhPT/
         nOmsZQJ66cB11M2LmVmvFZSYjsSB8QGU4Il2svmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 46/50] net: use skb_list_del_init() to remove from RX sublists
Date:   Fri, 22 Jan 2021 15:12:27 +0100
Message-Id: <20210122135737.063168430@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 22f6bbb7bcfcef0b373b0502a7ff390275c575dd ]

list_del() leaves the skb->next pointer poisoned, which can then lead to
 a crash in e.g. OVS forwarding.  For example, setting up an OVS VXLAN
 forwarding bridge on sfc as per:

========
$ ovs-vsctl show
5dfd9c47-f04b-4aaa-aa96-4fbb0a522a30
    Bridge "br0"
        Port "br0"
            Interface "br0"
                type: internal
        Port "enp6s0f0"
            Interface "enp6s0f0"
        Port "vxlan0"
            Interface "vxlan0"
                type: vxlan
                options: {key="1", local_ip="10.0.0.5", remote_ip="10.0.0.4"}
    ovs_version: "2.5.0"
========
(where 10.0.0.5 is an address on enp6s0f1)
and sending traffic across it will lead to the following panic:
========
general protection fault: 0000 [#1] SMP PTI
CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.20.0-rc3-ehc+ #701
Hardware name: Dell Inc. PowerEdge R710/0M233H, BIOS 6.4.0 07/23/2013
RIP: 0010:dev_hard_start_xmit+0x38/0x200
Code: 53 48 89 fb 48 83 ec 20 48 85 ff 48 89 54 24 08 48 89 4c 24 18 0f 84 ab 01 00 00 48 8d 86 90 00 00 00 48 89 f5 48 89 44 24 10 <4c> 8b 33 48 c7 03 00 00 00 00 48 8b 05 c7 d1 b3 00 4d 85 f6 0f 95
RSP: 0018:ffff888627b437e0 EFLAGS: 00010202
RAX: 0000000000000000 RBX: dead000000000100 RCX: ffff88862279c000
RDX: ffff888614a342c0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888618a88000 R08: 0000000000000001 R09: 00000000000003e8
R10: 0000000000000000 R11: ffff888614a34140 R12: 0000000000000000
R13: 0000000000000062 R14: dead000000000100 R15: ffff888616430000
FS:  0000000000000000(0000) GS:ffff888627b40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6d2bc6d000 CR3: 000000000200a000 CR4: 00000000000006e0
Call Trace:
 <IRQ>
 __dev_queue_xmit+0x623/0x870
 ? masked_flow_lookup+0xf7/0x220 [openvswitch]
 ? ep_poll_callback+0x101/0x310
 do_execute_actions+0xaba/0xaf0 [openvswitch]
 ? __wake_up_common+0x8a/0x150
 ? __wake_up_common_lock+0x87/0xc0
 ? queue_userspace_packet+0x31c/0x5b0 [openvswitch]
 ovs_execute_actions+0x47/0x120 [openvswitch]
 ovs_dp_process_packet+0x7d/0x110 [openvswitch]
 ovs_vport_receive+0x6e/0xd0 [openvswitch]
 ? dst_alloc+0x64/0x90
 ? rt_dst_alloc+0x50/0xd0
 ? ip_route_input_slow+0x19a/0x9a0
 ? __udp_enqueue_schedule_skb+0x198/0x1b0
 ? __udp4_lib_rcv+0x856/0xa30
 ? __udp4_lib_rcv+0x856/0xa30
 ? cpumask_next_and+0x19/0x20
 ? find_busiest_group+0x12d/0xcd0
 netdev_frame_hook+0xce/0x150 [openvswitch]
 __netif_receive_skb_core+0x205/0xae0
 __netif_receive_skb_list_core+0x11e/0x220
 netif_receive_skb_list+0x203/0x460
 ? __efx_rx_packet+0x335/0x5e0 [sfc]
 efx_poll+0x182/0x320 [sfc]
 net_rx_action+0x294/0x3c0
 __do_softirq+0xca/0x297
 irq_exit+0xa6/0xb0
 do_IRQ+0x54/0xd0
 common_interrupt+0xf/0xf
 </IRQ>
========
So, in all listified-receive handling, instead pull skbs off the lists with
 skb_list_del_init().

Fixes: 9af86f933894 ("net: core: fix use-after-free in __netif_receive_skb_list_core")
Fixes: 7da517a3bc52 ("net: core: Another step of skb receive list processing")
Fixes: a4ca8b7df73c ("net: ipv4: fix drop handling in ip_list_rcv() and ip_list_rcv_finish()")
Fixes: d8269e2cbf90 ("net: ipv6: listify ipv6_rcv() and ip6_rcv_finish()")
Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ for 4.14.y and older, just take the skbuff.h change - gregkh ]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1335,6 +1335,17 @@ static inline void skb_zcopy_abort(struc
 	}
 }
 
+static inline void skb_mark_not_on_list(struct sk_buff *skb)
+{
+	skb->next = NULL;
+}
+
+static inline void skb_list_del_init(struct sk_buff *skb)
+{
+	__list_del_entry(&skb->list);
+	skb_mark_not_on_list(skb);
+}
+
 /**
  *	skb_queue_empty - check if a queue is empty
  *	@list: queue head


