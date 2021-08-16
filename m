Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625283ED682
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239339AbhHPNVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240648AbhHPNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D25C61BFE;
        Mon, 16 Aug 2021 13:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119709;
        bh=J9hWoK0lsOGd+mpI9n2uhtEnBSESi06ddCmT/+f9Ask=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lM0wf9d6TvaHjf0uinl97sxEV6BQVz0GRq6ErK2w4jGdSNXcfRnEbvxL4Q6uGoc9z
         bHezJmj6sY44sTpdhz2n16+Co647ppAOGr1LcMc5DnyYrlI9HcNJLRTW3gZ3yEdFf+
         DBdfYIVm3Q1FPMUC71a2LIpu0ji2HR5xtrv3EWD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 099/151] net: igmp: fix data-race in igmp_ifc_timer_expire()
Date:   Mon, 16 Aug 2021 15:02:09 +0200
Message-Id: <20210816125447.341253885@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4a2b285e7e103d4d6c6ed3e5052a0ff74a5d7f15 ]

Fix the data-race reported by syzbot [1]
Issue here is that igmp_ifc_timer_expire() can update in_dev->mr_ifc_count
while another change just occured from another context.

in_dev->mr_ifc_count is only 8bit wide, so the race had little
consequences.

[1]
BUG: KCSAN: data-race in igmp_ifc_event / igmp_ifc_timer_expire

write to 0xffff8881051e3062 of 1 bytes by task 12547 on cpu 0:
 igmp_ifc_event+0x1d5/0x290 net/ipv4/igmp.c:821
 igmp_group_added+0x462/0x490 net/ipv4/igmp.c:1356
 ____ip_mc_inc_group+0x3ff/0x500 net/ipv4/igmp.c:1461
 __ip_mc_join_group+0x24d/0x2c0 net/ipv4/igmp.c:2199
 ip_mc_join_group_ssm+0x20/0x30 net/ipv4/igmp.c:2218
 do_ip_setsockopt net/ipv4/ip_sockglue.c:1285 [inline]
 ip_setsockopt+0x1827/0x2a80 net/ipv4/ip_sockglue.c:1423
 tcp_setsockopt+0x8c/0xa0 net/ipv4/tcp.c:3657
 sock_common_setsockopt+0x5d/0x70 net/core/sock.c:3362
 __sys_setsockopt+0x18f/0x200 net/socket.c:2159
 __do_sys_setsockopt net/socket.c:2170 [inline]
 __se_sys_setsockopt net/socket.c:2167 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881051e3062 of 1 bytes by interrupt on cpu 1:
 igmp_ifc_timer_expire+0x706/0xa30 net/ipv4/igmp.c:808
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1419
 expire_timers+0x135/0x250 kernel/time/timer.c:1464
 __run_timers+0x358/0x420 kernel/time/timer.c:1732
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1745
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu+0x9a/0xb0 kernel/softirq.c:636
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1100
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
 console_unlock+0x8e8/0xb30 kernel/printk/printk.c:2646
 vprintk_emit+0x125/0x3d0 kernel/printk/printk.c:2174
 vprintk_default+0x22/0x30 kernel/printk/printk.c:2185
 vprintk+0x15a/0x170 kernel/printk/printk_safe.c:392
 printk+0x62/0x87 kernel/printk/printk.c:2216
 selinux_netlink_send+0x399/0x400 security/selinux/hooks.c:6041
 security_netlink_send+0x42/0x90 security/security.c:2070
 netlink_sendmsg+0x59e/0x7c0 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg net/socket.c:723 [inline]
 ____sys_sendmsg+0x360/0x4d0 net/socket.c:2392
 ___sys_sendmsg net/socket.c:2446 [inline]
 __sys_sendmsg+0x1ed/0x270 net/socket.c:2475
 __do_sys_sendmsg net/socket.c:2484 [inline]
 __se_sys_sendmsg net/socket.c:2482 [inline]
 __x64_sys_sendmsg+0x42/0x50 net/socket.c:2482
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0x90 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x01 -> 0x02

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 12539 Comm: syz-executor.1 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6b3c558a4f23..a51360087b19 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -803,10 +803,17 @@ static void igmp_gq_timer_expire(struct timer_list *t)
 static void igmp_ifc_timer_expire(struct timer_list *t)
 {
 	struct in_device *in_dev = from_timer(in_dev, t, mr_ifc_timer);
+	u8 mr_ifc_count;
 
 	igmpv3_send_cr(in_dev);
-	if (in_dev->mr_ifc_count) {
-		in_dev->mr_ifc_count--;
+restart:
+	mr_ifc_count = READ_ONCE(in_dev->mr_ifc_count);
+
+	if (mr_ifc_count) {
+		if (cmpxchg(&in_dev->mr_ifc_count,
+			    mr_ifc_count,
+			    mr_ifc_count - 1) != mr_ifc_count)
+			goto restart;
 		igmp_ifc_start_timer(in_dev,
 				     unsolicited_report_interval(in_dev));
 	}
@@ -818,7 +825,7 @@ static void igmp_ifc_event(struct in_device *in_dev)
 	struct net *net = dev_net(in_dev->dev);
 	if (IGMP_V1_SEEN(in_dev) || IGMP_V2_SEEN(in_dev))
 		return;
-	in_dev->mr_ifc_count = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
+	WRITE_ONCE(in_dev->mr_ifc_count, in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv);
 	igmp_ifc_start_timer(in_dev, 1);
 }
 
@@ -957,7 +964,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 				in_dev->mr_qri;
 		}
 		/* cancel the interface change timer */
-		in_dev->mr_ifc_count = 0;
+		WRITE_ONCE(in_dev->mr_ifc_count, 0);
 		if (del_timer(&in_dev->mr_ifc_timer))
 			__in_dev_put(in_dev);
 		/* clear deleted report items */
@@ -1724,7 +1731,7 @@ void ip_mc_down(struct in_device *in_dev)
 		igmp_group_dropped(pmc);
 
 #ifdef CONFIG_IP_MULTICAST
-	in_dev->mr_ifc_count = 0;
+	WRITE_ONCE(in_dev->mr_ifc_count, 0);
 	if (del_timer(&in_dev->mr_ifc_timer))
 		__in_dev_put(in_dev);
 	in_dev->mr_gq_running = 0;
@@ -1941,7 +1948,7 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		pmc->sfmode = MCAST_INCLUDE;
 #ifdef CONFIG_IP_MULTICAST
 		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
-		in_dev->mr_ifc_count = pmc->crcount;
+		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
 		igmp_ifc_event(pmc->interface);
@@ -2120,7 +2127,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 		/* else no filters; keep old mode for reports */
 
 		pmc->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
-		in_dev->mr_ifc_count = pmc->crcount;
+		WRITE_ONCE(in_dev->mr_ifc_count, pmc->crcount);
 		for (psf = pmc->sources; psf; psf = psf->sf_next)
 			psf->sf_crcount = 0;
 		igmp_ifc_event(in_dev);
-- 
2.30.2



