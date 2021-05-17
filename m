Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7212238308E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhEQO21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:28:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239347AbhEQO0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:26:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9419061482;
        Mon, 17 May 2021 14:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260800;
        bh=TxcJQ6jI6zaqIP/o4w/cIvc59qoo3ZelUW/bq3STMsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hV9lygT6aLfzgMXeQpNPvs8UPcRG0mJBp4dfz0zuz4NxUIyHPzUIKn45mApiyMhFm
         AaHOpOhfynn6MlqPDA4lRhDQPlym8wKOY77JkYNmgh2RgpnX5tA7fa0osHBj5RIoir
         JS2O/wG+PbZFC1ZwYbn4pZIwdEJXHVMfm0SutjuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.11 007/329] KVM/VMX: Invoke NMI non-IST entry instead of IST entry
Date:   Mon, 17 May 2021 15:58:38 +0200
Message-Id: <20210517140302.282554303@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

commit a217a6593cec8b315d4c2f344bae33660b39b703 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/idtentry.h |   15 +++++++++++++++
 arch/x86/kernel/nmi.c           |   10 ++++++++++
 arch/x86/kvm/vmx/vmx.c          |   16 +++++++++-------
 3 files changed, 34 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -588,6 +588,21 @@ DECLARE_IDTENTRY_RAW(X86_TRAP_MC,	exc_ma
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
@@ -6334,18 +6335,17 @@ static void vmx_apicv_post_state_restore
 
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
@@ -6356,18 +6356,20 @@ static void handle_exception_nmi_irqoff(
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


