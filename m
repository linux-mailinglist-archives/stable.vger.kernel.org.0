Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEAF123699
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbfLQUKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfLQUKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:10:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CD6D2146E;
        Tue, 17 Dec 2019 20:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613449;
        bh=Aeftx0RiFoltP/GkP5iTSbFpXgr6WT6c5XhRqiw+aR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJyPXzVmjR+3zMD8k8IpMq6iR1EwCgBLt3H/03QhEoFnKA0eiRshacbp2tnLtqrnh
         DCjm/xwIYTGWulNHVb97GF9CpsYedHzW2JSuobFxzy87GhOtJY1lHA1GCOukkJJLQm
         kFUCgCPcZVNMaqC9+nmYvSbTU7VmzbTmcJNVBm5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 25/37] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
Date:   Tue, 17 Dec 2019 21:09:46 +0100
Message-Id: <20191217200730.290250938@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
References: <20191217200721.741054904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit df95467b6d2bfce49667ee4b71c67249b01957f7 ]

hsr_dev_xmit() calls hsr_port_get_hsr() to find master node and that would
return NULL if master node is not existing in the list.
But hsr_dev_xmit() doesn't check return pointer so a NULL dereference
could occur.

Test commands:
    ip netns add nst
    ip link add veth0 type veth peer name veth1
    ip link add veth2 type veth peer name veth3
    ip link set veth1 netns nst
    ip link set veth3 netns nst
    ip link set veth0 up
    ip link set veth2 up
    ip link add hsr0 type hsr slave1 veth0 slave2 veth2
    ip a a 192.168.100.1/24 dev hsr0
    ip link set hsr0 up
    ip netns exec nst ip link set veth1 up
    ip netns exec nst ip link set veth3 up
    ip netns exec nst ip link add hsr1 type hsr slave1 veth1 slave2 veth3
    ip netns exec nst ip a a 192.168.100.2/24 dev hsr1
    ip netns exec nst ip link set hsr1 up
    hping3 192.168.100.2 -2 --flood &
    modprobe -rv hsr

Splat looks like:
[  217.351122][ T1635] kasan: CONFIG_KASAN_INLINE enabled
[  217.352969][ T1635] kasan: GPF could be caused by NULL-ptr deref or user memory access
[  217.354297][ T1635] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[  217.355507][ T1635] CPU: 1 PID: 1635 Comm: hping3 Not tainted 5.4.0+ #192
[  217.356472][ T1635] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  217.357804][ T1635] RIP: 0010:hsr_dev_xmit+0x34/0x90 [hsr]
[  217.373010][ T1635] Code: 48 8d be 00 0c 00 00 be 04 00 00 00 48 83 ec 08 e8 21 be ff ff 48 8d 78 10 48 ba 00 b
[  217.376919][ T1635] RSP: 0018:ffff8880cd8af058 EFLAGS: 00010202
[  217.377571][ T1635] RAX: 0000000000000000 RBX: ffff8880acde6840 RCX: 0000000000000002
[  217.379465][ T1635] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: 0000000000000010
[  217.380274][ T1635] RBP: ffff8880acde6840 R08: ffffed101b440d5d R09: 0000000000000001
[  217.381078][ T1635] R10: 0000000000000001 R11: ffffed101b440d5c R12: ffff8880bffcc000
[  217.382023][ T1635] R13: ffff8880bffcc088 R14: 0000000000000000 R15: ffff8880ca675c00
[  217.383094][ T1635] FS:  00007f060d9d1740(0000) GS:ffff8880da000000(0000) knlGS:0000000000000000
[  217.384289][ T1635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  217.385009][ T1635] CR2: 00007faf15381dd0 CR3: 00000000d523c001 CR4: 00000000000606e0
[  217.385940][ T1635] Call Trace:
[  217.386544][ T1635]  dev_hard_start_xmit+0x160/0x740
[  217.387114][ T1635]  __dev_queue_xmit+0x1961/0x2e10
[  217.388118][ T1635]  ? check_object+0xaf/0x260
[  217.391466][ T1635]  ? __alloc_skb+0xb9/0x500
[  217.392017][ T1635]  ? init_object+0x6b/0x80
[  217.392629][ T1635]  ? netdev_core_pick_tx+0x2e0/0x2e0
[  217.393175][ T1635]  ? __alloc_skb+0xb9/0x500
[  217.393727][ T1635]  ? rcu_read_lock_sched_held+0x90/0xc0
[  217.394331][ T1635]  ? rcu_read_lock_bh_held+0xa0/0xa0
[  217.395013][ T1635]  ? kasan_unpoison_shadow+0x30/0x40
[  217.395668][ T1635]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  217.396280][ T1635]  ? __kmalloc_node_track_caller+0x3a8/0x3f0
[  217.399007][ T1635]  ? __kasan_kmalloc.constprop.4+0xa0/0xd0
[  217.400093][ T1635]  ? __kmalloc_reserve.isra.46+0x2e/0xb0
[  217.401118][ T1635]  ? memset+0x1f/0x40
[  217.402529][ T1635]  ? __alloc_skb+0x317/0x500
[  217.404915][ T1635]  ? arp_xmit+0xca/0x2c0
[ ... ]

Fixes: 311633b60406 ("hsr: switch ->dellink() to ->ndo_uninit()")
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_device.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -227,8 +227,13 @@ static int hsr_dev_xmit(struct sk_buff *
 	struct hsr_port *master;
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
-	skb->dev = master->dev;
-	hsr_forward_skb(skb, master);
+	if (master) {
+		skb->dev = master->dev;
+		hsr_forward_skb(skb, master);
+	} else {
+		atomic_long_inc(&dev->tx_dropped);
+		dev_kfree_skb_any(skb);
+	}
 	return NETDEV_TX_OK;
 }
 


