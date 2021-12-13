Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11E147294D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhLMKTc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238948AbhLMKPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:15:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029EFC0D941E;
        Mon, 13 Dec 2021 01:55:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4220CE0E6B;
        Mon, 13 Dec 2021 09:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A0AC34604;
        Mon, 13 Dec 2021 09:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389313;
        bh=odmEsfDm6TOHJpP7tZ6AaJP0+19wi3rkYp8kCQzl87Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=irb/uphEYXYIhiBmlkpOc5dE99MNclhLEXpocCHqEEtpG9FFt83c6sz/0qTQ4INx0
         yIgHMBpMRNRGMnhd2gt3J6N9ITjVHfGNmATOKVTVG+mP0u1In2d7jxdnlBcdlBJMDJ
         j4O09zWkdQymGPoxsApTxhKnOe3eBAGTG0YILcdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        "Sachin D. Patil" <sdp.sachin@gmail.com>,
        "V. Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 055/171] net/sched: fq_pie: prevent dismantle issue
Date:   Mon, 13 Dec 2021 10:29:30 +0100
Message-Id: <20211213092946.937983096@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit 61c2402665f1e10c5742033fce18392e369931d7 upstream.

For some reason, fq_pie_destroy() did not copy
working code from pie_destroy() and other qdiscs,
thus causing elusive bug.

Before calling del_timer_sync(&q->adapt_timer),
we need to ensure timer will not rearm itself.

rcu: INFO: rcu_preempt self-detected stall on CPU
rcu:    0-....: (4416 ticks this GP) idle=60d/1/0x4000000000000000 softirq=10433/10434 fqs=2579
        (t=10501 jiffies g=13085 q=3989)
NMI backtrace for cpu 0
CPU: 0 PID: 13 Comm: ksoftirqd/0 Not tainted 5.16.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 nmi_cpu_backtrace.cold+0x47/0x144 lib/nmi_backtrace.c:111
 nmi_trigger_cpumask_backtrace+0x1b3/0x230 lib/nmi_backtrace.c:62
 trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
 rcu_dump_cpu_stacks+0x25e/0x3f0 kernel/rcu/tree_stall.h:343
 print_cpu_stall kernel/rcu/tree_stall.h:627 [inline]
 check_cpu_stall kernel/rcu/tree_stall.h:711 [inline]
 rcu_pending kernel/rcu/tree.c:3878 [inline]
 rcu_sched_clock_irq.cold+0x9d/0x746 kernel/rcu/tree.c:2597
 update_process_times+0x16d/0x200 kernel/time/timer.c:1785
 tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:226
 tick_sched_timer+0x1b0/0x2d0 kernel/time/tick-sched.c:1428
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x1c0/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_interrupt+0x31c/0x790 kernel/time/hrtimer.c:1811
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1086 [inline]
 __sysvec_apic_timer_interrupt+0x146/0x530 arch/x86/kernel/apic/apic.c:1103
 sysvec_apic_timer_interrupt+0x8e/0xc0 arch/x86/kernel/apic/apic.c:1097
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:638
RIP: 0010:write_comp_data kernel/kcov.c:221 [inline]
RIP: 0010:__sanitizer_cov_trace_const_cmp1+0x1d/0x80 kernel/kcov.c:273
Code: 54 c8 20 48 89 10 c3 66 0f 1f 44 00 00 53 41 89 fb 41 89 f1 bf 03 00 00 00 65 48 8b 0c 25 40 70 02 00 48 89 ce 4c 8b 54 24 08 <e8> 4e f7 ff ff 84 c0 74 51 48 8b 81 88 15 00 00 44 8b 81 84 15 00
RSP: 0018:ffffc90000d27b28 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff888064bf1bf0 RCX: ffff888011928000
RDX: ffff888011928000 RSI: ffff888011928000 RDI: 0000000000000003
RBP: ffff888064bf1c28 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff875d8295 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880783dd300 R14: 0000000000000000 R15: 0000000000000000
 pie_calculate_probability+0x405/0x7c0 net/sched/sch_pie.c:418
 fq_pie_timer+0x170/0x2a0 net/sched/sch_fq_pie.c:383
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1421
 expire_timers kernel/time/timer.c:1466 [inline]
 __run_timers.part.0+0x675/0xa20 kernel/time/timer.c:1734
 __run_timers kernel/time/timer.c:1715 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1747
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>

Fixes: ec97ecf1ebe4 ("net: sched: add Flow Queue PIE packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Cc: Sachin D. Patil <sdp.sachin@gmail.com>
Cc: V. Saicharan <vsaicharan1998@gmail.com>
Cc: Mohit Bhasi <mohitbhasi1998@gmail.com>
Cc: Leslie Monis <lesliemonis@gmail.com>
Cc: Gautam Ramakrishnan <gautamramk@gmail.com>
Link: https://lore.kernel.org/r/20211209084937.3500020-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_fq_pie.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -531,6 +531,7 @@ static void fq_pie_destroy(struct Qdisc
 	struct fq_pie_sched_data *q = qdisc_priv(sch);
 
 	tcf_block_put(q->block);
+	q->p_params.tupdate = 0;
 	del_timer_sync(&q->adapt_timer);
 	kvfree(q->flows);
 }


