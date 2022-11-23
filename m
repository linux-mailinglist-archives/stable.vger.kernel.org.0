Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751F06357E0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbiKWJrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbiKWJqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359A21173C8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:44:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4945B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:44:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B90C433D7;
        Wed, 23 Nov 2022 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196641;
        bh=+9VFqZC54y2BQwYx0tved76Nc2geI9+itTM/IMz5by4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kg6vljHnErAQ33mZR9Dlm0EalLUU1DVGG7sQgr8ZLLxjbAbWriQNy1I9wZM0wi3gF
         KzWovqIXKUpPhbIgyhePFQcaiRNPqB1tOtGX2P6HbQUGl7zynwOgoTClUOS12lZ1Ja
         Bl18urckflsoF+Dr2Y2O28YAvoCUOl+5xCcf8gPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 070/314] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
Date:   Wed, 23 Nov 2022 09:48:35 +0100
Message-Id: <20221123084628.670173390@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 9f2febf3f04daebdaaa5a43cfa20e3844905c0f9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c     |  13 +---
 arch/x86/kvm/kvm-asm-offsets.c |   1 +
 arch/x86/kvm/svm/svm.c         |  37 ++++------
 arch/x86/kvm/svm/svm.h         |   4 +-
 arch/x86/kvm/svm/vmenter.S     | 119 ++++++++++++++++++++++++++++++++-
 5 files changed, 136 insertions(+), 38 deletions(-)

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
index c14fabd662f6..e80756ab141b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -722,6 +722,15 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
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
 
@@ -3902,16 +3911,16 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
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
@@ -3919,6 +3928,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
 	trace_kvm_entry(vcpu);
 
@@ -3977,26 +3987,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
index 8744f3b1d217..ea3049b978ea 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -683,7 +683,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
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
-- 
2.35.1



