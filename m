Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8C812C99D
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbfL2SLk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:11:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:49364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730340AbfL2Rmt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:42:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E62320718;
        Sun, 29 Dec 2019 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641367;
        bh=svCtd9ohctx4ACJajx8QjZCRabodjwPuHMZWVj97hlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VjYIxwGa+1wE8sxWcNQGW8+qZix2W6OLU3U5BXVKkmHEfiJjIzDshAYMJkS7jeBU3
         VAeUxJsU736zeCX0DnuUjBdH9C+3Sa7dw7oQyy7jOxOiUFNsH/X4Or09FcuZPmXlNg
         GKKCJ8IGBzB6pmgukenMNwBGSy/j2/Jss8Th75Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 019/434] bonding: fix bond_neigh_init()
Date:   Sun, 29 Dec 2019 18:21:12 +0100
Message-Id: <20191229172703.447366134@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9e99bfefdbce2e23ef37487a3bcb4adf90a791d1 ]

1) syzbot reported an uninit-value in bond_neigh_setup() [1]

 bond_neigh_setup() uses a temporary on-stack 'struct neigh_parms parms',
 but only clears parms.neigh_setup field.

 A stacked bonding device would then enter bond_neigh_setup()
 and read garbage from parms->dev.

 If we get really unlucky and garbage is matching @dev, then we
 could recurse and eventually crash.

 Let's make sure the whole structure is cleared to avoid surprises.

2) bond_neigh_setup() can be called while another cpu manipulates
 the master device, removing or adding a slave.
 We need at least rcu protection to prevent use-after-free.

Note: Prior code does not support a stack of bonding devices,
      this patch does not attempt to fix this, and leave a comment instead.

[1]

BUG: KMSAN: uninit-value in bond_neigh_setup+0xa4/0x110 drivers/net/bonding/bond_main.c:3655
CPU: 0 PID: 11256 Comm: syz-executor.0 Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0x128/0x220 mm/kmsan/kmsan_report.c:108
 __msan_warning+0x57/0xa0 mm/kmsan/kmsan_instr.c:245
 bond_neigh_setup+0xa4/0x110 drivers/net/bonding/bond_main.c:3655
 bond_neigh_init+0x216/0x4b0 drivers/net/bonding/bond_main.c:3626
 ___neigh_create+0x169e/0x2c40 net/core/neighbour.c:613
 __neigh_create+0xbd/0xd0 net/core/neighbour.c:674
 ip6_finish_output2+0x149a/0x2670 net/ipv6/ip6_output.c:113
 __ip6_finish_output+0x83d/0x8f0 net/ipv6/ip6_output.c:142
 ip6_finish_output+0x2db/0x420 net/ipv6/ip6_output.c:152
 NF_HOOK_COND include/linux/netfilter.h:294 [inline]
 ip6_output+0x5d3/0x720 net/ipv6/ip6_output.c:175
 dst_output include/net/dst.h:436 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 mld_sendpack+0xebd/0x13d0 net/ipv6/mcast.c:1682
 mld_send_cr net/ipv6/mcast.c:1978 [inline]
 mld_ifc_timer_expire+0x116b/0x1680 net/ipv6/mcast.c:2477
 call_timer_fn+0x232/0x530 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers+0xd60/0x1270 kernel/time/timer.c:1773
 run_timer_softirq+0x2d/0x50 kernel/time/timer.c:1786
 __do_softirq+0x4a1/0x83a kernel/softirq.c:293
 invoke_softirq kernel/softirq.c:375 [inline]
 irq_exit+0x230/0x280 kernel/softirq.c:416
 exiting_irq+0xe/0x10 arch/x86/include/asm/apic.h:536
 smp_apic_timer_interrupt+0x48/0x70 arch/x86/kernel/apic/apic.c:1138
 apic_timer_interrupt+0x2e/0x40 arch/x86/entry/entry_64.S:835
 </IRQ>
RIP: 0010:kmsan_free_page+0x18d/0x1c0 mm/kmsan/kmsan_shadow.c:439
Code: 4c 89 ff 44 89 f6 e8 82 0d ee ff 65 ff 0d 9f 26 3b 60 65 8b 05 98 26 3b 60 85 c0 75 24 e8 5b f6 35 ff 4c 89 6d d0 ff 75 d0 9d <48> 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 0b 0f 0b 0f 0b 0f
RSP: 0018:ffffb328034af818 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffffe2d7471f8360 RCX: 0000000000000000
RDX: ffffffffadea7000 RSI: 0000000000000004 RDI: ffff93496fcda104
RBP: ffffb328034af850 R08: ffff934a47e86d00 R09: ffff93496fc41900
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000246 R14: 0000000000000000 R15: ffffe2d7472225c0
 free_pages_prepare mm/page_alloc.c:1138 [inline]
 free_pcp_prepare mm/page_alloc.c:1230 [inline]
 free_unref_page_prepare+0x1d9/0x770 mm/page_alloc.c:3025
 free_unref_page mm/page_alloc.c:3074 [inline]
 free_the_page mm/page_alloc.c:4832 [inline]
 __free_pages+0x154/0x230 mm/page_alloc.c:4840
 __vunmap+0xdac/0xf20 mm/vmalloc.c:2277
 __vfree mm/vmalloc.c:2325 [inline]
 vfree+0x7c/0x170 mm/vmalloc.c:2355
 copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:883 [inline]
 get_entries net/ipv6/netfilter/ip6_tables.c:1041 [inline]
 do_ip6t_get_ctl+0xfa4/0x1030 net/ipv6/netfilter/ip6_tables.c:1709
 nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
 nf_getsockopt+0x481/0x4e0 net/netfilter/nf_sockopt.c:122
 ipv6_getsockopt+0x264/0x510 net/ipv6/ipv6_sockglue.c:1400
 tcp_getsockopt+0x1c6/0x1f0 net/ipv4/tcp.c:3688
 sock_common_getsockopt+0x13f/0x180 net/core/sock.c:3110
 __sys_getsockopt+0x533/0x7b0 net/socket.c:2129
 __do_sys_getsockopt net/socket.c:2144 [inline]
 __se_sys_getsockopt+0xe1/0x100 net/socket.c:2141
 __x64_sys_getsockopt+0x62/0x80 net/socket.c:2141
 do_syscall_64+0xb6/0x160 arch/x86/entry/common.c:291
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d20a
Code: b8 34 01 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 8d 8b fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 6a 8b fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:0000000000a6f618 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 0000000000a6f640 RCX: 000000000045d20a
RDX: 0000000000000041 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 0000000000717cc0 R08: 0000000000a6f63c R09: 0000000000004000
R10: 0000000000a6f740 R11: 0000000000000212 R12: 0000000000000003
R13: 0000000000000000 R14: 0000000000000029 R15: 0000000000715b00

Local variable description: ----parms@bond_neigh_init
Variable was created at:
 bond_neigh_init+0x8c/0x4b0 drivers/net/bonding/bond_main.c:3617
 bond_neigh_init+0x8c/0x4b0 drivers/net/bonding/bond_main.c:3617

Fixes: 9918d5bf329d ("bonding: modify only neigh_parms owned by us")
Fixes: 234bcf8a499e ("net/bonding: correctly proxy slave neigh param setup ndo function")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bonding/bond_main.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3612,24 +3612,35 @@ static int bond_neigh_init(struct neighb
 	const struct net_device_ops *slave_ops;
 	struct neigh_parms parms;
 	struct slave *slave;
-	int ret;
+	int ret = 0;
 
-	slave = bond_first_slave(bond);
+	rcu_read_lock();
+	slave = bond_first_slave_rcu(bond);
 	if (!slave)
-		return 0;
+		goto out;
 	slave_ops = slave->dev->netdev_ops;
 	if (!slave_ops->ndo_neigh_setup)
-		return 0;
+		goto out;
 
-	parms.neigh_setup = NULL;
+	/* TODO: find another way [1] to implement this.
+	 * Passing a zeroed structure is fragile,
+	 * but at least we do not pass garbage.
+	 *
+	 * [1] One way would be that ndo_neigh_setup() never touch
+	 *     struct neigh_parms, but propagate the new neigh_setup()
+	 *     back to ___neigh_create() / neigh_parms_alloc()
+	 */
+	memset(&parms, 0, sizeof(parms));
 	ret = slave_ops->ndo_neigh_setup(slave->dev, &parms);
-	if (ret)
-		return ret;
 
-	if (!parms.neigh_setup)
-		return 0;
+	if (ret)
+		goto out;
 
-	return parms.neigh_setup(n);
+	if (parms.neigh_setup)
+		ret = parms.neigh_setup(n);
+out:
+	rcu_read_unlock();
+	return ret;
 }
 
 /* The bonding ndo_neigh_setup is called at init time beofre any


