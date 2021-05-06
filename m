Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E53937537B
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 14:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhEFMPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 08:15:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38668 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhEFMPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 08:15:06 -0400
Date:   Thu, 06 May 2021 12:14:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620303246;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ez7a9LGPAAV41QzZ94EbuhRkbrINtAeGU2AekljcOWc=;
        b=s8bcdC4vR8d4wsvQN70wQl5mHaOE/dr3Pv2JKLF6sJ7pdJnFp0V26G7ws1ajLS8JQGD5OA
        bKvcVKWlTZMgPFoOtBsoVfl3UmXjPWKlfubGKlDo0BnuEO60hL3K7oPi309Vgn9QJ7tj99
        NclGLvRR/oJoCMuKq+f50pZcO5pce76PhOXH1F3SKdKZDrmY3rJ4fnH/mjP5gB/KioqMmn
        ionZi+pNzBsGt04bKi4EWyjtefNZIJchQDXMfYUu8xx4e66cx2fUWam6PvZse40uIJYa7f
        2Ljv3FZUIxoQqUlJRam2jSvtkRmsJF9N+JKh0j2EqRZRNZClQYCr9p4N49gvhQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620303246;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ez7a9LGPAAV41QzZ94EbuhRkbrINtAeGU2AekljcOWc=;
        b=Cx0zI1yw/MLZ3YXLVzwRY5txDkHr/dOu9fbU5RHzm0bbDjJvyo4lS9xMRPnA/bvpQFAa1z
        0k87ChDkTvO/1JDA==
From:   "tip-bot2 for Lai Jiangshan" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] KVM/VMX: Invoke NMI non-IST entry instead of IST entry
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <87r1imi8i1.ffs@nanos.tec.linutronix.de>
References: <87r1imi8i1.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <162030324615.29796.11969435265957959135.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     a217a6593cec8b315d4c2f344bae33660b39b703
Gitweb:        https://git.kernel.org/tip/a217a6593cec8b315d4c2f344bae33660b39b703
Author:        Lai Jiangshan <laijs@linux.alibaba.com>
AuthorDate:    Tue, 04 May 2021 21:50:14 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Wed, 05 May 2021 22:54:10 +02:00

KVM/VMX: Invoke NMI non-IST entry instead of IST entry

In VMX, the host NMI handler needs to be invoked after NMI VM-Exit.
Before commit 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via indirect
call instead of INTn"), this was done by INTn ("int $2"). But INTn
microcode is relatively expensive, so the commit reworked NMI VM-Exit
handling to invoke the kernel handler by function call.

But this missed a detail. The NMI entry point for direct invocation is
fetched from the IDT table and called on the kernel stack.  But on 64-bit
the NMI entry installed in the IDT expects to be invoked on the IST stack.
It relies on the "NMI executing" variable on the IST stack to work
correctly, which is at a fixed position in the IST stack.  When the entry
point is unexpectedly called on the kernel stack, the RSP-addressed "NMI
executing" variable is obviously also on the kernel stack and is
"uninitialized" and can cause the NMI entry code to run in the wrong way.

Provide a non-ist entry point for VMX which shares the C-function with
the regular NMI entry and invoke the new asm entry point instead.

On 32-bit this just maps to the regular NMI entry point as 32-bit has no
ISTs and is not affected.

[ tglx: Made it independent for backporting, massaged changelog ]

Fixes: 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via indirect call instead of INTn")
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Lai Jiangshan <laijs@linux.alibaba.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87r1imi8i1.ffs@nanos.tec.linutronix.de

---
 arch/x86/include/asm/idtentry.h | 15 +++++++++++++++
 arch/x86/kernel/nmi.c           | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          | 16 +++++++++-------
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index e35e342..73d45b0 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -588,6 +588,21 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	xenpv_exc_machine_check);
 #endif
 
 /* NMI */
+
+#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
+/*
+ * Special NOIST entry point for VMX which invokes this on the kernel
+ * stack. asm_exc_nmi() requires an IST to work correctly vs. the NMI
+ * 'executing' marker.
+ *
+ * On 32bit this just uses the regular NMI entry point because 32-bit does
+ * not have ISTs.
+ */
+DECLARE_IDTENTRY(X86_TRAP_NMI,		exc_nmi_noist);
+#else
+#define asm_exc_nmi_noist		asm_exc_nmi
+#endif
+
 DECLARE_IDTENTRY_NMI(X86_TRAP_NMI,	exc_nmi);
 #ifdef CONFIG_XEN_PV
 DECLARE_IDTENTRY_RAW(X86_TRAP_NMI,	xenpv_exc_nmi);
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index bf250a3..2ef961c 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -524,6 +524,16 @@ nmi_restart:
 		mds_user_clear_cpu_buffers();
 }
 
+#if defined(CONFIG_X86_64) && IS_ENABLED(CONFIG_KVM_INTEL)
+DEFINE_IDTENTRY_RAW(exc_nmi_noist)
+{
+	exc_nmi(regs);
+}
+#endif
+#if IS_MODULE(CONFIG_KVM_INTEL)
+EXPORT_SYMBOL_GPL(asm_exc_nmi_noist);
+#endif
+
 void stop_nmi(void)
 {
 	ignore_nmis++;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbe0cda..b21d751 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -36,6 +36,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/internal.h>
+#include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
 #include <asm/kexec.h>
@@ -6415,18 +6416,17 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
-static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
+static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
+					unsigned long entry)
 {
-	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
-
 	kvm_before_interrupt(vcpu);
-	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
+	vmx_do_interrupt_nmi_irqoff(entry);
 	kvm_after_interrupt(vcpu);
 }
 
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
+	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
@@ -6437,18 +6437,20 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
 	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
+		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
+	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
+	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	handle_interrupt_nmi_irqoff(vcpu, intr_info);
+	handle_interrupt_nmi_irqoff(vcpu, gate_offset(desc));
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
