Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A1C311473
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhBEWG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232879AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08EC66509F;
        Fri,  5 Feb 2021 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534444;
        bh=kUnAg6V5E2T857tT9YrWFkoF886SW64QHozO3tsBKgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rZoQqqn2GgSKy9S2LC3PnKFfcLNy5cb78iAkFcR0FQ8Eyr2hf0ZQWfDK+HFUj3eU7
         wud8Yrof5PIKak+gOGzegLHd330d8dkoUQKFShqMOUX/wayG/6i83i8VRnSpf5J9B1
         8GeKUlOi2SS8khs3lruXdWwEcWZEHtZqf2709xxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 05/17] net_sched: gen_estimator: support large ewma log
Date:   Fri,  5 Feb 2021 15:07:59 +0100
Message-Id: <20210205140650.039666853@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit dd5e073381f2ada3630f36be42833c6e9c78b75e upstream

syzbot report reminded us that very big ewma_log were supported in the past,
even if they made litle sense.

tc qdisc replace dev xxx root est 1sec 131072sec ...

While fixing the bug, also add boundary checks for ewma_log, in line
with range supported by iproute2.

UBSAN: shift-out-of-bounds in net/core/gen_estimator.c:83:38
shift exponent -1 is negative
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 est_timer.cold+0xbb/0x12d net/core/gen_estimator.c:83
 call_timer_fn+0x1a5/0x710 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x692/0xa80 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x17f/0x200 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of rate estimators")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20210114181929.1717985-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/gen_estimator.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -84,11 +84,11 @@ static void est_timer(struct timer_list
 	u64 rate, brate;
 
 	est_fetch_counters(est, &b);
-	brate = (b.bytes - est->last_bytes) << (10 - est->ewma_log - est->intvl_log);
-	brate -= (est->avbps >> est->ewma_log);
+	brate = (b.bytes - est->last_bytes) << (10 - est->intvl_log);
+	brate = (brate >> est->ewma_log) - (est->avbps >> est->ewma_log);
 
-	rate = (u64)(b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
-	rate -= (est->avpps >> est->ewma_log);
+	rate = (u64)(b.packets - est->last_packets) << (10 - est->intvl_log);
+	rate = (rate >> est->ewma_log) - (est->avpps >> est->ewma_log);
 
 	write_seqcount_begin(&est->seq);
 	est->avbps += brate;
@@ -147,6 +147,9 @@ int gen_new_estimator(struct gnet_stats_
 	if (parm->interval < -2 || parm->interval > 3)
 		return -EINVAL;
 
+	if (parm->ewma_log == 0 || parm->ewma_log >= 31)
+		return -EINVAL;
+
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
 	if (!est)
 		return -ENOBUFS;


