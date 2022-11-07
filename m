Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B800861F6E3
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiKGO5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiKGO4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:56:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5551E3D6
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XKgh8H92mGyxILocGQ8OyFDbDcmkvLrdzgAcIU+/znI=;
        b=GU+hLiknvGdoZTNFfpmacEjdj01ACGR9vTTxjQE98yGzC+HYEkYqVdP+2USfT6Umcy4VIj
        dwGhwz/xuwM2MuLHEw1/1aRZLk2UCmJ8/dXWfvq2I94XjhkYLwamRZqAduD7BHNYLiJRq9
        ILizdclSwMWMFnc7oY6SqAquVJkadDI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-OMe671EyNXWE1KA7wGM0OQ-1; Mon, 07 Nov 2022 09:54:40 -0500
X-MC-Unique: OMe671EyNXWE1KA7wGM0OQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FBB587A9E1;
        Mon,  7 Nov 2022 14:54:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C982028DC1;
        Mon,  7 Nov 2022 14:54:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 7/8] KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly
Date:   Mon,  7 Nov 2022 09:54:35 -0500
Message-Id: <20221107145436.276079-8-pbonzini@redhat.com>
In-Reply-To: <20221107145436.276079-1-pbonzini@redhat.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets.c |  1 +
 arch/x86/kernel/cpu/bugs.c    | 13 ++---
 arch/x86/kvm/svm/svm.c        | 38 ++++++---------
 arch/x86/kvm/svm/svm.h        |  4 +-
 arch/x86/kvm/svm/vmenter.S    | 92 ++++++++++++++++++++++++++++++++++-
 5 files changed, 111 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 69d1fed51086..d0bd68af0a5a 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -115,6 +115,7 @@ static void __used common(void)
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(SVM_spec_ctrl, vcpu_svm, spec_ctrl);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 381c7dcffe25..31aa158a2e10 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -731,6 +731,15 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
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
 
@@ -3912,18 +3921,19 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
-static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	guest_state_enter_irqoff();
 
 	if (sev_es_guest(vcpu->kvm)) {
-		__svm_sev_es_vcpu_run(svm);
+		__svm_sev_es_vcpu_run(svm, spec_ctrl_intercepted);
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area));
+		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area),
+			       spec_ctrl_intercepted);
 	}
 
 	guest_state_exit_irqoff();
@@ -3932,6 +3942,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
 	trace_kvm_entry(vcpu);
 
@@ -3990,26 +4001,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
index 99410651f2a5..9d940d8736f0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -483,7 +483,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
-void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
+void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa, bool spec_ctrl_intercepted);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 45a4bd002494..9e381386ffdc 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -32,10 +32,64 @@
 
 .section .noinstr.text, "ax"
 
+.macro RESTORE_GUEST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "jmp 999f", \
+		"", X86_FEATURE_MSR_SPEC_CTRL, \
+		"jmp 999f", X86_FEATURE_V_SPEC_CTRL
+
+	/*
+	 * SPEC_CTRL handling: if the guest's SPEC_CTRL value differs from the
+	 * host's, write the MSR.
+	 *
+	 * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
+	 * there must not be any returns or indirect branches between this code
+	 * and vmentry.
+	 */
+	movl SVM_spec_ctrl(%_ASM_DI), %eax
+	cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
+	je 999f
+	mov $MSR_IA32_SPEC_CTRL, %ecx
+	xor %edx, %edx
+	wrmsr
+999:
+
+.endm
+
+.macro RESTORE_HOST_SPEC_CTRL
+	/* No need to do anything if SPEC_CTRL is unset or V_SPEC_CTRL is set */
+	ALTERNATIVE_2 "jmp 999f", \
+		"", X86_FEATURE_MSR_SPEC_CTRL, \
+		"jmp 999f", X86_FEATURE_V_SPEC_CTRL
+
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
+	je 999f
+	xor %edx, %edx
+	wrmsr
+999:
+
+.endm
+
+
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
  * @hsave_pa:	unsigned long
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -50,7 +104,12 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* @hsave_pa is needed last after vmexit, save it first.  */
+	/*
+	 * Both @spec_ctrl_intercepted and @hsave_pa are used only after vmexit.
+	 * @spec_ctrl_intercepted is needed later and accessed directly from
+	 * the stack in RESTORE_HOST_SPEC_CTRL, so save it first.
+	 */
+	push %_ASM_ARG3
 	push %_ASM_ARG2
 
 	/* Save @svm. */
@@ -61,6 +120,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov %_ASM_ARG1, %_ASM_DI
 .endif
 
+	RESTORE_GUEST_SPEC_CTRL
+
 	/*
 	 * Use a single vmcb (vmcb01 because it's always valid) for
 	 * context switching guest state via VMLOAD/VMSAVE, that way
@@ -138,6 +199,8 @@ SYM_FUNC_START(__svm_vcpu_run)
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -173,6 +236,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 	xor %r15d, %r15d
 #endif
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
@@ -210,6 +276,7 @@ SYM_FUNC_END(__svm_vcpu_run)
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @spec_ctrl_intercepted: bool
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
@@ -224,8 +291,21 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/* Save @spec_ctrl_intercepted for RESTORE_HOST_SPEC_CTRL. */
+	push %_ASM_ARG2
+
+	/* Save @svm. */
+	push %_ASM_ARG1
+
+.ifnc _ASM_ARG1, _ASM_DI
+	/* Move @svm to RDI for RESTORE_GUEST_SPEC_CTRL. */
+	mov %_ASM_ARG1, %_ASM_DI
+.endif
+
+	RESTORE_GUEST_SPEC_CTRL
+
 	/* Get svm->current_vmcb->pa into RAX. */
-	mov SVM_current_vmcb(%_ASM_ARG1), %_ASM_AX
+	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
 	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
@@ -235,11 +315,16 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 
 2:	cli
 
+	/* Pop @svm to RDI, guest registers have been saved already. */
+	pop %_ASM_DI
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
+	RESTORE_HOST_SPEC_CTRL
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -249,6 +334,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	 */
 	UNTRAIN_RET
 
+	/* "Pop" @spec_ctrl_intercepted.  */
+	pop %_ASM_BX
+
 	pop %_ASM_BX
 
 #ifdef CONFIG_X86_64
-- 
2.31.1


