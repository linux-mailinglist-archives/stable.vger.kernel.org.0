Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93485627B52
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbiKNLAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiKNLAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:00:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBA71EAD8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:00:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE18B60FE9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D35C433D6;
        Mon, 14 Nov 2022 11:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423634;
        bh=x0a6o0+1h1P/tDA/64QKqTGoSGpw+R8awRgbloEBjH0=;
        h=Subject:To:Cc:From:Date:From;
        b=gB6rY2/nIVkNQVPf2auy9/bZdhnvdm1kwMPy/qmo6MIjepv1aJDeRhIBr0irIyXiO
         DOXVzqBm27JsO9sgX+ryXs/gUef+zFJ0b80KSZE/FNxWi8R4BT6vbLLnJJbk0vpVnE
         TZp4aP/1Vu58eiG0wq6CkYxHsBMueQLrLCyzuDKE=
Subject: FAILED: patch "[PATCH] KVM: SVM: retrieve VMCB from assembly" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:00:22 +0100
Message-ID: <1668423622228217@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f6d58266d731 ("KVM: SVM: retrieve VMCB from assembly")
f7ef280132f9 ("KVM: SVM: adjust register allocation for __svm_vcpu_run()")
16fdc1de169e ("KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm")
debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")
bb06650634d3 ("KVM: VMX: Convert launched argument to flags")
8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")
59bd54a84d15 ("x86/tdx: Detect running as a TDX guest in early boot")
6198311093da ("x86/cc: Move arch/x86/{kernel/cc_platform.c => coco/core.c}")
f94909ceb1ed ("x86: Prepare asm files for straight-line-speculation")
22da5a07c75e ("x86/lib/atomic64_386_32: Rename things")
1367afaa2ee9 ("x86/entry: Use the correct fence macro after swapgs in kernel CR3")
c07e45553da1 ("x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()")
6e5772c8d9cf ("Merge tag 'x86_cc_for_v5.16_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6d58266d731fd7e63163790aad21e0dbb1d5264 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 7 Nov 2022 04:17:29 -0500
Subject: [PATCH] KVM: SVM: retrieve VMCB from assembly

Continue moving accesses to struct vcpu_svm to vmenter.S.  Reducing the
number of arguments limits the chance of mistakes due to different
registers used for argument passing in 32- and 64-bit ABIs; pushing the
VMCB argument and almost immediately popping it into a different
register looks pretty weird.

32-bit ABI is not a concern for __svm_sev_es_vcpu_run() which is 64-bit
only; however, it will soon need @svm to save/restore SPEC_CTRL so stay
consistent with __svm_vcpu_run() and let them share the same prototype.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index 30db96852e2d..f1b694e431ae 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -15,6 +15,8 @@ static void __used common(void)
 	if (IS_ENABLED(CONFIG_KVM_AMD)) {
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
+		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b412bc5773c5..0c86c435c51f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3914,12 +3914,11 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned long vmcb_pa = svm->current_vmcb->pa;
 
 	guest_state_enter_irqoff();
 
 	if (sev_es_guest(vcpu->kvm)) {
-		__svm_sev_es_vcpu_run(vmcb_pa);
+		__svm_sev_es_vcpu_run(svm);
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
@@ -3930,7 +3929,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		 * vmcb02 when switching vmcbs for nested virtualization.
 		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(vmcb_pa, svm);
+		__svm_vcpu_run(svm);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 447e25c9101a..7ff1879e73c5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -683,7 +683,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
+void __svm_vcpu_run(struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 531510ab6072..d07bac1952c5 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -32,7 +32,6 @@
 
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
- * @vmcb_pa:	unsigned long
  * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_vcpu_run)
@@ -49,16 +48,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BX
 
 	/* Save @svm. */
-	push %_ASM_ARG2
-
-	/* Save @vmcb. */
 	push %_ASM_ARG1
 
+.ifnc _ASM_ARG1, _ASM_DI
 	/* Move @svm to RDI. */
-	mov %_ASM_ARG2, %_ASM_DI
+	mov %_ASM_ARG1, %_ASM_DI
+.endif
 
-	/* "POP" @vmcb to RAX. */
-	pop %_ASM_AX
+	/* Get svm->current_vmcb->pa into RAX. */
+	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
+	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Load guest registers. */
 	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
@@ -170,7 +169,7 @@ SYM_FUNC_END(__svm_vcpu_run)
 
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
- * @vmcb_pa:	unsigned long
+ * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
@@ -185,8 +184,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* Move @vmcb to RAX. */
-	mov %_ASM_ARG1, %_ASM_AX
+	/* Get svm->current_vmcb->pa into RAX. */
+	mov SVM_current_vmcb(%_ASM_ARG1), %_ASM_AX
+	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
 	sti

