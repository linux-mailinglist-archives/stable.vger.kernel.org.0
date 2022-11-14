Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AC66280CB
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237894AbiKNNJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbiKNNJK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66D625EAF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4427F61187
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B92C433D7;
        Mon, 14 Nov 2022 13:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431345;
        bh=UG3qP6q6sMQ5FxBbakHa91ku5WLfS9zWZkVlFF9d+OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yu0iHJ55ErSEryy4tXDvWJDw+VwfQSMYjs8QZ9V5kHO9Df5Z6zgZocMHEatplazTx
         neqq/MdpfzPR0zzfu/i0aakCwBjRLFi+ONmEw8J8OMVN5CRQjMhx9Ncye+eu96Tb0i
         m+MgXuzR2Zac6ET2lD5i9miOZxIgso/9PAZh384I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 171/190] KVM: SVM: retrieve VMCB from assembly
Date:   Mon, 14 Nov 2022 13:46:35 +0100
Message-Id: <20221114124506.323777233@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

commit f6d58266d731fd7e63163790aad21e0dbb1d5264 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/kvm-asm-offsets.c |    2 ++
 arch/x86/kvm/svm/svm.c         |    5 ++---
 arch/x86/kvm/svm/svm.h         |    4 ++--
 arch/x86/kvm/svm/vmenter.S     |   20 ++++++++++----------
 4 files changed, 16 insertions(+), 15 deletions(-)

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
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3915,12 +3915,11 @@ static fastpath_t svm_exit_handlers_fast
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
 
@@ -3931,7 +3930,7 @@ static noinstr void svm_vcpu_enter_exit(
 		 * vmcb02 when switching vmcbs for nested virtualization.
 		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(vmcb_pa, svm);
+		__svm_vcpu_run(svm);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -683,7 +683,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
+void __svm_vcpu_run(struct vcpu_svm *svm);
 
 #endif
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


