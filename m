Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF3E914BB9C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgA1OCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:49104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbgA1OCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68CA02468A;
        Tue, 28 Jan 2020 14:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220161;
        bh=z96g/3xDosZNylciW68NI72QCdEd8bJvVitO0b4LQyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDcMf3mOsnKCdQEm1UJRgrLdFQhKRNwL3DM71TNbbvEmOHQPToJ6uXTe5WIOg0RCu
         9bcgp17E5PkBTVbPnXre89jcml2brbi1oelgFytM9/9jt9lcKU3WFlhY0j9S87UBdP
         p85ASMYb1az3U5AIzFdtuvK1nwrNkDTj6hM1W5cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 010/104] net: rtnetlink: validate IFLA_MTU attribute in rtnl_create_link()
Date:   Tue, 28 Jan 2020 14:59:31 +0100
Message-Id: <20200128135818.657585380@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d836f5c69d87473ff65c06a6123e5b2cf5e56f5b ]

rtnl_create_link() needs to apply dev->min_mtu and dev->max_mtu
checks that we apply in do_setlink()

Otherwise malicious users can crash the kernel, for example after
an integer overflow :

BUG: KASAN: use-after-free in memset include/linux/string.h:365 [inline]
BUG: KASAN: use-after-free in __alloc_skb+0x37b/0x5e0 net/core/skbuff.c:238
Write of size 32 at addr ffff88819f20b9c0 by task swapper/0/0

CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x41 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:639
 check_memory_region_inline mm/kasan/generic.c:185 [inline]
 check_memory_region+0x134/0x1a0 mm/kasan/generic.c:192
 memset+0x24/0x40 mm/kasan/common.c:108
 memset include/linux/string.h:365 [inline]
 __alloc_skb+0x37b/0x5e0 net/core/skbuff.c:238
 alloc_skb include/linux/skbuff.h:1049 [inline]
 alloc_skb_with_frags+0x93/0x590 net/core/skbuff.c:5664
 sock_alloc_send_pskb+0x7ad/0x920 net/core/sock.c:2242
 sock_alloc_send_skb+0x32/0x40 net/core/sock.c:2259
 mld_newpack+0x1d7/0x7f0 net/ipv6/mcast.c:1609
 add_grhead.isra.0+0x299/0x370 net/ipv6/mcast.c:1713
 add_grec+0x7db/0x10b0 net/ipv6/mcast.c:1844
 mld_send_cr net/ipv6/mcast.c:1970 [inline]
 mld_ifc_timer_expire+0x3d3/0x950 net/ipv6/mcast.c:2477
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers kernel/time/timer.c:1773 [inline]
 __run_timers kernel/time/timer.c:1740 [inline]
 run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
 __do_softirq+0x262/0x98c kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x19b/0x1e0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 98 6b ea f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 44 1c 60 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 34 1c 60 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 4e 5d 9a f9 e8 79
RSP: 0018:ffffffff89807ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff13266ae RBX: ffffffff8987a1c0 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8987aa54
RBP: ffffffff89807d18 R08: ffffffff8987a1c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8a799980 R14: 0000000000000000 R15: 0000000000000000
 arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
 default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
 cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
 rest_init+0x23b/0x371 init/main.c:451
 arch_call_rest_init+0xe/0x1b
 start_kernel+0x904/0x943 init/main.c:784
 x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
 x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
 secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242

The buggy address belongs to the page:
page:ffffea00067c82c0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
raw: 057ffe0000000000 ffffea00067c82c8 ffffea00067c82c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88819f20b880: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88819f20b900: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88819f20b980: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                           ^
 ffff88819f20ba00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88819f20ba80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Fixes: 61e84623ace3 ("net: centralize net_device min/max MTU checking")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    2 ++
 net/core/dev.c            |   29 +++++++++++++++++++----------
 net/core/rtnetlink.c      |   13 +++++++++++--
 3 files changed, 32 insertions(+), 12 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3666,6 +3666,8 @@ int dev_set_alias(struct net_device *, c
 int dev_get_alias(const struct net_device *, char *, size_t);
 int dev_change_net_namespace(struct net_device *, struct net *, const char *);
 int __dev_set_mtu(struct net_device *, int);
+int dev_validate_mtu(struct net_device *dev, int mtu,
+		     struct netlink_ext_ack *extack);
 int dev_set_mtu_ext(struct net_device *dev, int mtu,
 		    struct netlink_ext_ack *extack);
 int dev_set_mtu(struct net_device *, int);
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7973,6 +7973,22 @@ int __dev_set_mtu(struct net_device *dev
 }
 EXPORT_SYMBOL(__dev_set_mtu);
 
+int dev_validate_mtu(struct net_device *dev, int new_mtu,
+		     struct netlink_ext_ack *extack)
+{
+	/* MTU must be positive, and in range */
+	if (new_mtu < 0 || new_mtu < dev->min_mtu) {
+		NL_SET_ERR_MSG(extack, "mtu less than device minimum");
+		return -EINVAL;
+	}
+
+	if (dev->max_mtu > 0 && new_mtu > dev->max_mtu) {
+		NL_SET_ERR_MSG(extack, "mtu greater than device maximum");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 /**
  *	dev_set_mtu_ext - Change maximum transfer unit
  *	@dev: device
@@ -7989,16 +8005,9 @@ int dev_set_mtu_ext(struct net_device *d
 	if (new_mtu == dev->mtu)
 		return 0;
 
-	/* MTU must be positive, and in range */
-	if (new_mtu < 0 || new_mtu < dev->min_mtu) {
-		NL_SET_ERR_MSG(extack, "mtu less than device minimum");
-		return -EINVAL;
-	}
-
-	if (dev->max_mtu > 0 && new_mtu > dev->max_mtu) {
-		NL_SET_ERR_MSG(extack, "mtu greater than device maximum");
-		return -EINVAL;
-	}
+	err = dev_validate_mtu(dev, new_mtu, extack);
+	if (err)
+		return err;
 
 	if (!netif_device_present(dev))
 		return -ENODEV;
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2959,8 +2959,17 @@ struct net_device *rtnl_create_link(stru
 	dev->rtnl_link_ops = ops;
 	dev->rtnl_link_state = RTNL_LINK_INITIALIZING;
 
-	if (tb[IFLA_MTU])
-		dev->mtu = nla_get_u32(tb[IFLA_MTU]);
+	if (tb[IFLA_MTU]) {
+		u32 mtu = nla_get_u32(tb[IFLA_MTU]);
+		int err;
+
+		err = dev_validate_mtu(dev, mtu, extack);
+		if (err) {
+			free_netdev(dev);
+			return ERR_PTR(err);
+		}
+		dev->mtu = mtu;
+	}
 	if (tb[IFLA_ADDRESS]) {
 		memcpy(dev->dev_addr, nla_data(tb[IFLA_ADDRESS]),
 				nla_len(tb[IFLA_ADDRESS]));


