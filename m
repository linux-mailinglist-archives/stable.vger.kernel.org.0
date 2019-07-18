Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C51C6C7B8
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387683AbfGRDC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfGRDC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:02:57 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4865F2173B;
        Thu, 18 Jul 2019 03:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563418975;
        bh=4zBeN29hXRqLF07pOMEpkYCQ4U86RElxUS11CjpLA7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uv5tf1XaBi02Gi+w3lhuLisKwcuhkKlMQfgPUvacMOCRALayWKdsJgyJhRtK1NavR
         C5eOJcHlVFYb7YEFb1TV/u8d9hvx/dT6tcBjAvw6n7sys2fbVklAsC1JOVYIhau0Pd
         ZdsUmUQ0ESOmen++RwvLlqWOA6yMgX/V7873ylhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.2 12/21] x86/irq: Seperate unused system vectors from spurious entry again
Date:   Thu, 18 Jul 2019 12:01:30 +0900
Message-Id: <20190718030033.513880766@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030030.456918453@linuxfoundation.org>
References: <20190718030030.456918453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit f8a8fe61fec8006575699559ead88b0b833d5cad upstream.

Quite some time ago the interrupt entry stubs for unused vectors in the
system vector range got removed and directly mapped to the spurious
interrupt vector entry point.

Sounds reasonable, but it's subtly broken. The spurious interrupt vector
entry point pushes vector number 0xFF on the stack which makes the whole
logic in __smp_spurious_interrupt() pointless.

As a consequence any spurious interrupt which comes from a vector != 0xFF
is treated as a real spurious interrupt (vector 0xFF) and not
acknowledged. That subsequently stalls all interrupt vectors of equal and
lower priority, which brings the system to a grinding halt.

This can happen because even on 64-bit the system vector space is not
guaranteed to be fully populated. A full compile time handling of the
unused vectors is not possible because quite some of them are conditonally
populated at runtime.

Bring the entry stubs back, which wastes 160 bytes if all stubs are unused,
but gains the proper handling back. There is no point to selectively spare
some of the stubs which are known at compile time as the required code in
the IDT management would be way larger and convoluted.

Do not route the spurious entries through common_interrupt and do_IRQ() as
the original code did. Route it to smp_spurious_interrupt() which evaluates
the vector number and acts accordingly now that the real vector numbers are
handed in.

Fixup the pr_warn so the actual spurious vector (0xff) is clearly
distiguished from the other vectors and also note for the vectored case
whether it was pending in the ISR or not.

 "Spurious APIC interrupt (vector 0xFF) on CPU#0, should never happen."
 "Spurious interrupt vector 0xed on CPU#1. Acked."
 "Spurious interrupt vector 0xee on CPU#1. Not pending!."

Fixes: 2414e021ac8d ("x86: Avoid building unused IRQ entry stubs")
Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Jan Beulich <jbeulich@suse.com>
Link: https://lkml.kernel.org/r/20190628111440.550568228@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S     |   24 ++++++++++++++++++++++++
 arch/x86/entry/entry_64.S     |   30 ++++++++++++++++++++++++++----
 arch/x86/include/asm/hw_irq.h |    2 ++
 arch/x86/kernel/apic/apic.c   |   33 ++++++++++++++++++++++-----------
 arch/x86/kernel/idt.c         |    3 ++-
 5 files changed, 76 insertions(+), 16 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1104,6 +1104,30 @@ ENTRY(irq_entries_start)
     .endr
 END(irq_entries_start)
 
+#ifdef CONFIG_X86_LOCAL_APIC
+	.align 8
+ENTRY(spurious_entries_start)
+    vector=FIRST_SYSTEM_VECTOR
+    .rept (NR_VECTORS - FIRST_SYSTEM_VECTOR)
+	pushl	$(~vector+0x80)			/* Note: always in signed byte range */
+    vector=vector+1
+	jmp	common_spurious
+	.align	8
+    .endr
+END(spurious_entries_start)
+
+common_spurious:
+	ASM_CLAC
+	addl	$-0x80, (%esp)			/* Adjust vector into the [-256, -1] range */
+	SAVE_ALL switch_stacks=1
+	ENCODE_FRAME_POINTER
+	TRACE_IRQS_OFF
+	movl	%esp, %eax
+	call	smp_spurious_interrupt
+	jmp	ret_from_intr
+ENDPROC(common_interrupt)
+#endif
+
 /*
  * the CPU automatically disables interrupts when executing an IRQ vector,
  * so IRQ-flags tracing has to follow that:
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -375,6 +375,18 @@ ENTRY(irq_entries_start)
     .endr
 END(irq_entries_start)
 
+	.align 8
+ENTRY(spurious_entries_start)
+    vector=FIRST_SYSTEM_VECTOR
+    .rept (NR_VECTORS - FIRST_SYSTEM_VECTOR)
+	UNWIND_HINT_IRET_REGS
+	pushq	$(~vector+0x80)			/* Note: always in signed byte range */
+	jmp	common_spurious
+	.align	8
+	vector=vector+1
+    .endr
+END(spurious_entries_start)
+
 .macro DEBUG_ENTRY_ASSERT_IRQS_OFF
 #ifdef CONFIG_DEBUG_ENTRY
 	pushq %rax
@@ -571,10 +583,20 @@ _ASM_NOKPROBE(interrupt_entry)
 
 /* Interrupt entry/exit. */
 
-	/*
-	 * The interrupt stubs push (~vector+0x80) onto the stack and
-	 * then jump to common_interrupt.
-	 */
+/*
+ * The interrupt stubs push (~vector+0x80) onto the stack and
+ * then jump to common_spurious/interrupt.
+ */
+common_spurious:
+	addq	$-0x80, (%rsp)			/* Adjust vector to [-256, -1] range */
+	call	interrupt_entry
+	UNWIND_HINT_REGS indirect=1
+	call	smp_spurious_interrupt		/* rdi points to pt_regs */
+	jmp	ret_from_intr
+END(common_spurious)
+_ASM_NOKPROBE(common_spurious)
+
+/* common_interrupt is a hotpath. Align it */
 	.p2align CONFIG_X86_L1_CACHE_SHIFT
 common_interrupt:
 	addq	$-0x80, (%rsp)			/* Adjust vector to [-256, -1] range */
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -150,6 +150,8 @@ extern char irq_entries_start[];
 #define trace_irq_entries_start irq_entries_start
 #endif
 
+extern char spurious_entries_start[];
+
 #define VECTOR_UNUSED		NULL
 #define VECTOR_SHUTDOWN		((void *)~0UL)
 #define VECTOR_RETRIGGERED	((void *)~1UL)
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2041,21 +2041,32 @@ __visible void __irq_entry smp_spurious_
 	entering_irq();
 	trace_spurious_apic_entry(vector);
 
+	inc_irq_stat(irq_spurious_count);
+
+	/*
+	 * If this is a spurious interrupt then do not acknowledge
+	 */
+	if (vector == SPURIOUS_APIC_VECTOR) {
+		/* See SDM vol 3 */
+		pr_info("Spurious APIC interrupt (vector 0xFF) on CPU#%d, should never happen.\n",
+			smp_processor_id());
+		goto out;
+	}
+
 	/*
-	 * Check if this really is a spurious interrupt and ACK it
-	 * if it is a vectored one.  Just in case...
-	 * Spurious interrupts should not be ACKed.
+	 * If it is a vectored one, verify it's set in the ISR. If set,
+	 * acknowledge it.
 	 */
 	v = apic_read(APIC_ISR + ((vector & ~0x1f) >> 1));
-	if (v & (1 << (vector & 0x1f)))
+	if (v & (1 << (vector & 0x1f))) {
+		pr_info("Spurious interrupt (vector 0x%02x) on CPU#%d. Acked\n",
+			vector, smp_processor_id());
 		ack_APIC_irq();
-
-	inc_irq_stat(irq_spurious_count);
-
-	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	pr_info("spurious APIC interrupt through vector %02x on CPU#%d, "
-		"should never happen.\n", vector, smp_processor_id());
-
+	} else {
+		pr_info("Spurious interrupt (vector 0x%02x) on CPU#%d. Not pending!\n",
+			vector, smp_processor_id());
+	}
+out:
 	trace_spurious_apic_exit(vector);
 	exiting_irq();
 }
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -319,7 +319,8 @@ void __init idt_setup_apic_and_irq_gates
 #ifdef CONFIG_X86_LOCAL_APIC
 	for_each_clear_bit_from(i, system_vectors, NR_VECTORS) {
 		set_bit(i, system_vectors);
-		set_intr_gate(i, spurious_interrupt);
+		entry = spurious_entries_start + 8 * (i - FIRST_SYSTEM_VECTOR);
+		set_intr_gate(i, entry);
 	}
 #endif
 }


