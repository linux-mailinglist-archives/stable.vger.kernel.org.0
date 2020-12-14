Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B282D9EFD
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408745AbgLNS1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502295AbgLNRiD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:03 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 074/105] s390: fix irq state tracing
Date:   Mon, 14 Dec 2020 18:28:48 +0100
Message-Id: <20201214172558.828055689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit b1cae1f84a0f609a34ebcaa087fbecef32f69882 ]

With commit 58c644ba512c ("sched/idle: Fix arch_cpu_idle() vs
tracing") common code calls arch_cpu_idle() with a lockdep state that
tells irqs are on.

This doesn't work very well for s390: psw_idle() will enable interrupts
to wait for an interrupt. As soon as an interrupt occurs the interrupt
handler will verify if the old context was psw_idle(). If that is the
case the interrupt enablement bits in the old program status word will
be cleared.

A subsequent test in both the external as well as the io interrupt
handler checks if in the old context interrupts were enabled. Due to
the above patching of the old program status word it is assumed the
old context had interrupts disabled, and therefore a call to
TRACE_IRQS_OFF (aka trace_hardirqs_off_caller) is skipped. Which in
turn makes lockdep incorrectly "think" that interrupts are enabled
within the interrupt handler.

Fix this by unconditionally calling TRACE_IRQS_OFF when entering
interrupt handlers. Also call unconditionally TRACE_IRQS_ON when
leaving interrupts handlers.

This leaves the special psw_idle() case, which now returns with
interrupts disabled, but has an "irqs on" lockdep state. So callers of
psw_idle() must adjust the state on their own, if required. This is
currently only __udelay_disabled().

Fixes: 58c644ba512c ("sched/idle: Fix arch_cpu_idle() vs tracing")
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 15 ---------------
 arch/s390/lib/delay.c    |  5 ++---
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index ca55db0823534..dd5cb6204335d 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -765,12 +765,7 @@ ENTRY(io_int_handler)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	TSTMSK	__LC_CPU_FLAGS,_CIF_IGNORE_IRQ
 	jo	.Lio_restore
-#if IS_ENABLED(CONFIG_TRACE_IRQFLAGS)
-	tmhh	%r8,0x300
-	jz	1f
 	TRACE_IRQS_OFF
-1:
-#endif
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 .Lio_loop:
 	lgr	%r2,%r11		# pass pointer to pt_regs
@@ -793,12 +788,7 @@ ENTRY(io_int_handler)
 	TSTMSK	__LC_CPU_FLAGS,_CIF_WORK
 	jnz	.Lio_work
 .Lio_restore:
-#if IS_ENABLED(CONFIG_TRACE_IRQFLAGS)
-	tm	__PT_PSW(%r11),3
-	jno	0f
 	TRACE_IRQS_ON
-0:
-#endif
 	lg	%r14,__LC_VDSO_PER_CPU
 	mvc	__LC_RETURN_PSW(16),__PT_PSW(%r11)
 	tm	__PT_PSW+1(%r11),0x01	# returning to user ?
@@ -980,12 +970,7 @@ ENTRY(ext_int_handler)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	TSTMSK	__LC_CPU_FLAGS,_CIF_IGNORE_IRQ
 	jo	.Lio_restore
-#if IS_ENABLED(CONFIG_TRACE_IRQFLAGS)
-	tmhh	%r8,0x300
-	jz	1f
 	TRACE_IRQS_OFF
-1:
-#endif
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs
 	lghi	%r3,EXT_INTERRUPT
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index daca7bad66de3..8c0c68e7770ea 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -33,7 +33,7 @@ EXPORT_SYMBOL(__delay);
 
 static void __udelay_disabled(unsigned long long usecs)
 {
-	unsigned long cr0, cr0_new, psw_mask, flags;
+	unsigned long cr0, cr0_new, psw_mask;
 	struct s390_idle_data idle;
 	u64 end;
 
@@ -45,9 +45,8 @@ static void __udelay_disabled(unsigned long long usecs)
 	psw_mask = __extract_psw() | PSW_MASK_EXT | PSW_MASK_WAIT;
 	set_clock_comparator(end);
 	set_cpu_flag(CIF_IGNORE_IRQ);
-	local_irq_save(flags);
 	psw_idle(&idle, psw_mask);
-	local_irq_restore(flags);
+	trace_hardirqs_off();
 	clear_cpu_flag(CIF_IGNORE_IRQ);
 	set_clock_comparator(S390_lowcore.clock_comparator);
 	__ctl_load(cr0, 0, 0);
-- 
2.27.0



