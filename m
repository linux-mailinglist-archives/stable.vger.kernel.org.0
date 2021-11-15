Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53F04520C2
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhKPA40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343558AbhKOTVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BAC763313;
        Mon, 15 Nov 2021 18:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001731;
        bh=YtvZQXR6blEQrRhqV8Hoc5MCz0xWdczojaCz4kx+HGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFUfmlbGhK6QqtE8ulWMj3KRUjzmwX455giNyXM+PLTaPHQUX/6kdL5X0rKfcPfJ0
         jO61rjONvCsH0cBMY9B9E7DEXVzx/fySXNoD+Tqggfu1+tTlpC50viAShnIXBUGnas
         XXBUtl6pDKiHG94aPIJSXrR47OB4Ki4MxfC+K0bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 298/917] net: annotate data-race in neigh_output()
Date:   Mon, 15 Nov 2021 17:56:33 +0100
Message-Id: <20211115165438.866447357@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d18785e213866935b4c3dc0c33c3e18801ce0ce8 ]

neigh_output() reads n->nud_state and hh->hh_len locklessly.

This is fine, but we need to add annotations and document this.

We evaluate skip_cache first to avoid reading these fields
if the cache has to by bypassed.

syzbot report:

BUG: KCSAN: data-race in __neigh_event_send / ip_finish_output2

write to 0xffff88810798a885 of 1 bytes by interrupt on cpu 1:
 __neigh_event_send+0x40d/0xac0 net/core/neighbour.c:1128
 neigh_event_send include/net/neighbour.h:444 [inline]
 neigh_resolve_output+0x104/0x410 net/core/neighbour.c:1476
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x80a/0xaa0 net/ipv4/ip_output.c:221
 ip_finish_output+0x3b5/0x510 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0x164/0x220 net/ipv4/ip_output.c:126
 __ip_queue_xmit+0x9d3/0xa20 net/ipv4/ip_output.c:525
 ip_queue_xmit+0x34/0x40 net/ipv4/ip_output.c:539
 __tcp_transmit_skb+0x142a/0x1a00 net/ipv4/tcp_output.c:1405
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 tcp_xmit_probe_skb net/ipv4/tcp_output.c:4011 [inline]
 tcp_write_wakeup+0x4a9/0x810 net/ipv4/tcp_output.c:4064
 tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4079
 tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
 tcp_write_timer_handler+0x394/0x520 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xb9/0x180 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1421
 expire_timers+0x135/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x430 kernel/time/timer.c:1734
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1747
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x4e/0xa0 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
 acpi_idle_do_entry drivers/acpi/processor_idle.c:553 [inline]
 acpi_idle_enter+0x258/0x2e0 drivers/acpi/processor_idle.c:688
 cpuidle_enter_state+0x2b4/0x760 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x3c/0x60 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x1a3/0x250 kernel/sched/idle.c:306
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:403
 secondary_startup_64_no_verify+0xb1/0xbb

read to 0xffff88810798a885 of 1 bytes by interrupt on cpu 0:
 neigh_output include/net/neighbour.h:507 [inline]
 ip_finish_output2+0x79a/0xaa0 net/ipv4/ip_output.c:221
 ip_finish_output+0x3b5/0x510 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0x164/0x220 net/ipv4/ip_output.c:126
 __ip_queue_xmit+0x9d3/0xa20 net/ipv4/ip_output.c:525
 ip_queue_xmit+0x34/0x40 net/ipv4/ip_output.c:539
 __tcp_transmit_skb+0x142a/0x1a00 net/ipv4/tcp_output.c:1405
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 tcp_xmit_probe_skb net/ipv4/tcp_output.c:4011 [inline]
 tcp_write_wakeup+0x4a9/0x810 net/ipv4/tcp_output.c:4064
 tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4079
 tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
 tcp_write_timer_handler+0x394/0x520 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xb9/0x180 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1421
 expire_timers+0x135/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x430 kernel/time/timer.c:1734
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1747
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x4e/0xa0 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
 acpi_idle_do_entry drivers/acpi/processor_idle.c:553 [inline]
 acpi_idle_enter+0x258/0x2e0 drivers/acpi/processor_idle.c:688
 cpuidle_enter_state+0x2b4/0x760 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x3c/0x60 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x1a3/0x250 kernel/sched/idle.c:306
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:403
 rest_init+0xee/0x100 init/main.c:734
 arch_call_rest_init+0xa/0xb
 start_kernel+0x5e4/0x669 init/main.c:1142
 secondary_startup_64_no_verify+0xb1/0xbb

value changed: 0x20 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 22ced1381ede5..990f9b1d17092 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -504,10 +504,15 @@ static inline int neigh_output(struct neighbour *n, struct sk_buff *skb,
 {
 	const struct hh_cache *hh = &n->hh;
 
-	if ((n->nud_state & NUD_CONNECTED) && hh->hh_len && !skip_cache)
+	/* n->nud_state and hh->hh_len could be changed under us.
+	 * neigh_hh_output() is taking care of the race later.
+	 */
+	if (!skip_cache &&
+	    (READ_ONCE(n->nud_state) & NUD_CONNECTED) &&
+	    READ_ONCE(hh->hh_len))
 		return neigh_hh_output(hh, skb);
-	else
-		return n->output(n, skb);
+
+	return n->output(n, skb);
 }
 
 static inline struct neighbour *
-- 
2.33.0



