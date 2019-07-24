Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214F27395C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389092AbfGXTj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389290AbfGXTj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1639422BE9;
        Wed, 24 Jul 2019 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997167;
        bh=YKkxzls09CDuXMmHP2eIMDD3U5/bCpFVP8bu1M9acg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkjsQdBcefxVWUSJ6lRazesZSoMvFGbBG6glxuK8QpICVfcMcd/mO6f+Tg6oljyps
         WxLsBHyDnCSpi5lGoWBWxhs269sMq8Gdhuqt+XJVvMTVCFJsza+LQEMKTLskXQ2vi3
         nxqlSt9rzQ8c3sbSvBp2/2dSThw8tYg5sbq4OrQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.2 302/413] arm64: Fix interrupt tracing in the presence of NMIs
Date:   Wed, 24 Jul 2019 21:19:53 +0200
Message-Id: <20190724191757.512009853@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

commit 17ce302f3117e9518395847a3120c8a108b587b8 upstream.

In the presence of any form of instrumentation, nmi_enter() should be
done before calling any traceable code and any instrumentation code.

Currently, nmi_enter() is done in handle_domain_nmi(), which is much
too late as instrumentation code might get called before. Move the
nmi_enter/exit() calls to the arch IRQ vector handler.

On arm64, it is not possible to know if the IRQ vector handler was
called because of an NMI before acknowledging the interrupt. However, It
is possible to know whether normal interrupts could be taken in the
interrupted context (i.e. if taking an NMI in that context could
introduce a potential race condition).

When interrupting a context with IRQs disabled, call nmi_enter() as soon
as possible. In contexts with IRQs enabled, defer this to the interrupt
controller, which is in a better position to know if an interrupt taken
is an NMI.

Fixes: bc3c03ccb464 ("arm64: Enable the support of pseudo-NMIs")
Cc: <stable@vger.kernel.org> # 5.1.x-
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/entry.S    |   44 ++++++++++++++++++++++++++++++++-----------
 arch/arm64/kernel/irq.c      |   17 ++++++++++++++++
 drivers/irqchip/irq-gic-v3.c |    7 ++++++
 kernel/irq/irqdesc.c         |    8 +++++--
 4 files changed, 63 insertions(+), 13 deletions(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -424,6 +424,20 @@ tsk	.req	x28		// current thread_info
 	irq_stack_exit
 	.endm
 
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	/*
+	 * Set res to 0 if irqs were unmasked in interrupted context.
+	 * Otherwise set res to non-0 value.
+	 */
+	.macro	test_irqs_unmasked res:req, pmr:req
+alternative_if ARM64_HAS_IRQ_PRIO_MASKING
+	sub	\res, \pmr, #GIC_PRIO_IRQON
+alternative_else
+	mov	\res, xzr
+alternative_endif
+	.endm
+#endif
+
 	.text
 
 /*
@@ -620,19 +634,19 @@ ENDPROC(el1_sync)
 el1_irq:
 	kernel_entry 1
 	enable_da_f
-#ifdef CONFIG_TRACE_IRQFLAGS
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 alternative_if ARM64_HAS_IRQ_PRIO_MASKING
 	ldr	x20, [sp, #S_PMR_SAVE]
-alternative_else
-	mov	x20, #GIC_PRIO_IRQON
-alternative_endif
-	cmp	x20, #GIC_PRIO_IRQOFF
-	/* Irqs were disabled, don't trace */
-	b.ls	1f
+alternative_else_nop_endif
+	test_irqs_unmasked	res=x0, pmr=x20
+	cbz	x0, 1f
+	bl	asm_nmi_enter
+1:
 #endif
+
+#ifdef CONFIG_TRACE_IRQFLAGS
 	bl	trace_hardirqs_off
-1:
 #endif
 
 	irq_handler
@@ -651,14 +665,22 @@ alternative_else_nop_endif
 	bl	preempt_schedule_irq		// irq en/disable is done inside
 1:
 #endif
-#ifdef CONFIG_TRACE_IRQFLAGS
+
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 	/*
 	 * if IRQs were disabled when we received the interrupt, we have an NMI
 	 * and we are not re-enabling interrupt upon eret. Skip tracing.
 	 */
-	cmp	x20, #GIC_PRIO_IRQOFF
-	b.ls	1f
+	test_irqs_unmasked	res=x0, pmr=x20
+	cbz	x0, 1f
+	bl	asm_nmi_exit
+1:
+#endif
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+#ifdef CONFIG_ARM64_PSEUDO_NMI
+	test_irqs_unmasked	res=x0, pmr=x20
+	cbnz	x0, 1f
 #endif
 	bl	trace_hardirqs_on
 1:
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -16,8 +16,10 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <linux/irqchip.h>
+#include <linux/kprobes.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <asm/daifflags.h>
 #include <asm/vmap_stack.h>
 
 unsigned long irq_err_count;
@@ -65,3 +67,18 @@ void __init init_IRQ(void)
 	if (!handle_arch_irq)
 		panic("No interrupt controller found.");
 }
+
+/*
+ * Stubs to make nmi_enter/exit() code callable from ASM
+ */
+asmlinkage void notrace asm_nmi_enter(void)
+{
+	nmi_enter();
+}
+NOKPROBE_SYMBOL(asm_nmi_enter);
+
+asmlinkage void notrace asm_nmi_exit(void)
+{
+	nmi_exit();
+}
+NOKPROBE_SYMBOL(asm_nmi_exit);
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -461,8 +461,12 @@ static void gic_deactivate_unhandled(u32
 
 static inline void gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 {
+	bool irqs_enabled = interrupts_enabled(regs);
 	int err;
 
+	if (irqs_enabled)
+		nmi_enter();
+
 	if (static_branch_likely(&supports_deactivate_key))
 		gic_write_eoir(irqnr);
 	/*
@@ -474,6 +478,9 @@ static inline void gic_handle_nmi(u32 ir
 	err = handle_domain_nmi(gic_data.domain, irqnr, regs);
 	if (err)
 		gic_deactivate_unhandled(irqnr);
+
+	if (irqs_enabled)
+		nmi_exit();
 }
 
 static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -680,6 +680,8 @@ int __handle_domain_irq(struct irq_domai
  * @hwirq:	The HW irq number to convert to a logical one
  * @regs:	Register file coming from the low-level handling code
  *
+ *		This function must be called from an NMI context.
+ *
  * Returns:	0 on success, or -EINVAL if conversion has failed
  */
 int handle_domain_nmi(struct irq_domain *domain, unsigned int hwirq,
@@ -689,7 +691,10 @@ int handle_domain_nmi(struct irq_domain
 	unsigned int irq;
 	int ret = 0;
 
-	nmi_enter();
+	/*
+	 * NMI context needs to be setup earlier in order to deal with tracing.
+	 */
+	WARN_ON(!in_nmi());
 
 	irq = irq_find_mapping(domain, hwirq);
 
@@ -702,7 +707,6 @@ int handle_domain_nmi(struct irq_domain
 	else
 		ret = -EINVAL;
 
-	nmi_exit();
 	set_irq_regs(old_regs);
 	return ret;
 }


