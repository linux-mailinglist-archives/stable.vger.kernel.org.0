Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFD0627B45
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 11:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiKNK7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 05:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbiKNK7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 05:59:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794FC2037A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 02:59:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB7460FF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 10:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A683FC433D6;
        Mon, 14 Nov 2022 10:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423582;
        bh=i8iqXxWfUQRywy2ZEVTptxeq5L52rHqvZ/jqKPUeZns=;
        h=Subject:To:Cc:From:Date:From;
        b=rdHww5Uv/m64+YsFKKRhHDdtllHsHLxkgEhXtnSDWfsifNIzxyOgyE3MNnCsBTaiE
         jXsOlUzTvgIVSGtf59vftvbiO71EFviaiHwfeVxLKuOYgtX/FRxKZUE111kokdXGz7
         8jFsusA2Z+rxLZfX5T+OQ2EBHJZgkgUHVlyjF74c=
Subject: FAILED: patch "[PATCH] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly" failed to apply to 5.15-stable tree
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 11:59:30 +0100
Message-ID: <166842357032180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

9f2febf3f04d ("KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly")
e287bd005ad9 ("KVM: SVM: restore host save area from assembly")
e61ab42de874 ("KVM: SVM: move guest vmsave/vmload back to assembly")
73412dfeea72 ("KVM: SVM: do not allocate struct svm_cpu_data dynamically")
181d0fb0bb02 ("KVM: SVM: remove dead field from struct svm_cpu_data")
f6d58266d731 ("KVM: SVM: retrieve VMCB from assembly")
f7ef280132f9 ("KVM: SVM: adjust register allocation for __svm_vcpu_run()")
16fdc1de169e ("KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm")
debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")
07853adc29a0 ("KVM: VMX: Prevent RSB underflow before vmenter")
fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
bb06650634d3 ("KVM: VMX: Convert launched argument to flags")
8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
acac5e98ef8d ("x86/speculation: Remove x86_spec_ctrl_mask")
bbb69e8bee1b ("x86/speculation: Use cached host SPEC_CTRL value for guest entry/exit")
7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
c779bc1a9002 ("x86/bugs: Optimize SPEC_CTRL MSR writes")
caa0ff24d5d0 ("x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value")
a149180fbcf3 ("x86: Add magic AMD return-thunk")
d9e9d2300681 ("x86,objtool: Create .return_sites")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f2febf3f04daebdaaa5a43cfa20e3844905c0f9 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 30 Sep 2022 14:24:40 -0400
Subject: [PATCH] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly

Restoration of the host IA32_SPEC_CTRL value is probably too late
with respect to the return thunk training sequence.

With respect to the user/kernel boundary, AMD says, "If software chooses
to toggle STIBP (e.g., set STIBP on kernel entry, and clear it on kernel
exit), software should set STIBP to 1 before executing the return thunk
training sequence." I assume the same requirements apply to the guest/host
boundary. The return thunk training sequence is in vmenter.S, quite close
to the VM-exit. On hosts without V_SPEC_CTRL, however, the host's
IA32_SPEC_CTRL value is not restored until much later.

To avoid this, move the restoration of host SPEC_CTRL to assembly and,
for consistency, move the restoration of the guest SPEC_CTRL as well.
This is not particularly difficult, apart from some care to cover both
32- and 64-bit, and to share code between SEV-ES and normal vmentry.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Suggested-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index da7c361f47e0..6ec0b7ce7453 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -196,22 +196,15 @@ void __init check_bugs(void)
 }
 
 /*
- * NOTE: This function is *only* called for SVM.  VMX spec_ctrl handling is
- * done in vmenter.S.
+ * NOTE: This function is *only* called for SVM, since Intel uses
+ * MSR_IA32_SPEC_CTRL for SSBD.
  */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
+	u64 guestval, hostval;
 	struct thread_info *ti = current_thread_info();
 
-	if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-		if (hostval != guestval) {
-			msrval = setguest ? guestval : hostval;
-			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
-		}
-	}
-
 	/*
 	 * If SSBD is not handled in MSR_SPEC_CTRL on AMD, update
 	 * MSR_AMD64_L2_CFG or MSR_VIRT_SPEC_CTRL if supported.
diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index 1b805cd24d66..24a710d37323 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -16,6 +16,7 @@ static void __used common(void)
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(SVM_spec_ctrl, vcpu_svm, spec_ctrl);
 		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 		OFFSET(SD_save_area_pa, svm_cpu_data, save_area_pa);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 469c1b5617af..cf1aed25f4ab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -720,6 +720,15 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
 	u32 offset;
 	u32 *msrpm;
 
+	/*
+	 * For non-nested case:
+	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
+	 * save it.
+	 *
+	 * For nested case:
+	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
+	 * save it.
+	 */
 	msrpm = is_guest_mode(vcpu) ? to_svm(vcpu)->nested.msrpm:
 				      to_svm(vcpu)->msrpm;
 
@@ -3901,16 +3910,16 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	guest_state_enter_irqoff();
 
 	if (sev_es_guest(vcpu->kvm))
-		__svm_sev_es_vcpu_run(svm);
+		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
 	else
-		__svm_vcpu_run(svm);
+		__svm_vcpu_run(svm, spec_ctrl_intercepted);
 
 	guest_state_exit_irqoff();
 }
@@ -3918,6 +3927,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
 	trace_kvm_entry(vcpu);
 
@@ -3976,26 +3986,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
 		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	svm_vcpu_enter_exit(vcpu);
-
-	/*
-	 * We do not use IBRS in the kernel. If this vCPU has used the
-	 * SPEC_CTRL MSR it may have left it on; save the value and
-	 * turn it off. This is much more efficient than blindly adding
-	 * it to the atomic save/restore list. Especially as the former
-	 * (Saving guest MSRs on vmexit) doesn't even exist in KVM.
-	 *
-	 * For non-nested case:
-	 * If the L01 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 *
-	 * For nested case:
-	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
-	 * save it.
-	 */
-	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
-	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
+	svm_vcpu_enter_exit(vcpu, spec_ctrl_intercepted);
 
 	if (!sev_es_guest(vcpu->kvm))
 		reload_tss(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 83955a4e520e..199a2ecef1ce 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -682,7 +682,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
-void __svm_vcpu_run(struct vcpu_svm *svm);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
+void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 57440acfc73e..34367dc203f2 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -32,9 +32,69 @@
 
 .section .noinstr.text, "ax"
 
+.macro RESTORE_GUEST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "", \
+		"jmp 800f", X86_FEATURE_MSR_SPEC_CTRL, \
+		"", X86_FEATURE_V_SPEC_CTRL
+801:
+.endm
+.macro RESTORE_GUEST_SPEC_CTRL_BODY
+800:
+	/*
+	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
+	 * host's, write the MSR.  This is kept out-of-line so that the common
+	 * case does not have to jump.
+	 *
+	 * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
+	 * there must not be any returns or indirect branches between this code
+	 * and vmentry.
+	 */
+	movl SVM_spec_ctrl(%_ASM_DI), %eax
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	je 801b
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	xor %edx, %edx
+	wrmsr
+	jmp 801b
+.endm
+
+.macro RESTORE_HOST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "", \
+		"jmp 900f", X86_FEATURE_MSR_SPEC_CTRL, \
+		"", X86_FEATURE_V_SPEC_CTRL
+901:
+.endm
+.macro RESTORE_HOST_SPEC_CTRL_BODY
+900:
+	/* Same for after vmexit.  */
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+
+	/*
+	 * Load the value that the guest had written into MSR_IA32_SPEC_CTRL,
+	 * if it was not intercepted during guest execution.
+	 */
+	cmpb $0, (%_ASM_SP)
+	jnz 998f
+	rdmsr
+	movl %eax, SVM_spec_ctrl(%_ASM_DI)
+998:
+
+	/* Now restore the host value of the MSR if different from the guest's.  */
+	movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	cmp SVM_spec_ctrl(%_ASM_DI), %eax
+	je 901b
+	xor %edx, %edx
+	wrmsr
+	jmp 901b
+.endm
+
+
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -54,17 +114,26 @@ SYM_FUNC_START(__svm_vcpu_run)
 	 * order compared to when they are needed.
 	 */
 
+	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
+	push %_ASM_ARG2
+
 	/* Needed to restore access to percpu variables.  */
 	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
 
-	/* Save @svm. */
+	/* Finally save @svm. */
 	push %_ASM_ARG1
 
 .ifnc _ASM_ARG1, _ASM_DI
-	/* Move @svm to RDI. */
+	/*
+	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
+	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
+	 */
 	mov %_ASM_ARG1, %_ASM_DI
 .endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_GUEST_SPEC_CTRL
+
 	/*
 	 * Use a single vmcb (vmcb01 because it's always valid) for
 	 * context switching guest state via VMLOAD/VMSAVE, that way
@@ -142,6 +211,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -177,6 +249,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	xor %r15d, %r15d
 #endif
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
@@ -191,6 +266,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_BP
 	RET
 
+	RESTORE_GUEST_SPEC_CTRL_BODY
+	RESTORE_HOST_SPEC_CTRL_BODY
+
 10:	cmpb $0, kvm_rebooting
 	jne 2b
 	ud2
@@ -214,6 +292,7 @@ SYM_FUNC_END(__svm_vcpu_run)
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
@@ -228,8 +307,30 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/*
+	 * Save variables needed after vmexit on the stack, in inverse
+	 * order compared to when they are needed.
+	 */
+
+	/* Accessed directly from the stack in RESTORE_HOST_SPEC_CTRL.  */
+	push %_ASM_ARG2
+
+	/* Save @svm. */
+	push %_ASM_ARG1
+
+.ifnc _ASM_ARG1, _ASM_DI
+	/*
+	 * Stash @svm in RDI early. On 32-bit, arguments are in RAX, RCX
+	 * and RDX which are clobbered by RESTORE_GUEST_SPEC_CTRL.
+	 */
+	mov %_ASM_ARG1, %_ASM_DI
+.endif
+
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_GUEST_SPEC_CTRL
+
 	/* Get svm->current_vmcb->pa into RAX. */
-	mov SVM_current_vmcb(%_ASM_ARG1), %_ASM_AX
+	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
 	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
@@ -239,11 +340,17 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
+	/* Pop @svm to RDI, guest registers have been saved already. */
+	pop %_ASM_DI
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	/* Clobbers RAX, RCX, RDX.  */
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -253,6 +360,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 	UNTRAIN_RET
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
@@ -267,6 +377,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	pop %_ASM_BP
 	RET
 
+	RESTORE_GUEST_SPEC_CTRL_BODY
+	RESTORE_HOST_SPEC_CTRL_BODY
+
 3:	cmpb $0, kvm_rebooting
 	jne 2b
 	ud2

