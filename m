Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFEA6280CC
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiKNNJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237897AbiKNNJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2215828732
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A77BAB80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AC5C433D6;
        Mon, 14 Nov 2022 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431348;
        bh=zgzlJs2n7xBf3k2I2QxCQCJVxj396ZDTARldtcBpdGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NDfPGN/zbA60gpbXOAkk8PModKYLv4Th1k0EHzL3WC0AbBb+YhntrowZhqBP7tXM5
         BD7rLXCO18XmvsgWCrT+na0FqLgjw2s4jxvTaPbryxMjXTnKsCTbrA80QfSNgfMhSA
         2j9jf9BtnUmv9hfL0S2y+kYc9HU/t9lJbOc6pUXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 172/190] KVM: SVM: move guest vmsave/vmload back to assembly
Date:   Mon, 14 Nov 2022 13:46:36 +0100
Message-Id: <20221114124506.374885700@linuxfoundation.org>
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

commit e61ab42de874c5af8c5d98b327c77a374d9e7da1 upstream.

It is error-prone that code after vmexit cannot access percpu data
because GSBASE has not been restored yet.  It forces MSR_IA32_SPEC_CTRL
save/restore to happen very late, after the predictor untraining
sequence, and it gets in the way of return stack depth tracking
(a retbleed mitigation that is in linux-next as of 2022-11-09).

As a first step towards fixing that, move the VMCB VMSAVE/VMLOAD to
assembly, essentially undoing commit fb0c4a4fee5a ("KVM: SVM: move
VMLOAD/VMSAVE to C code", 2021-03-15).  The reason for that commit was
that it made it simpler to use a different VMCB for VMLOAD/VMSAVE versus
VMRUN; but that is not a big hassle anymore thanks to the kvm-asm-offsets
machinery and other related cleanups.

The idea on how to number the exception tables is stolen from
a prototype patch by Peter Zijlstra.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Link: <https://lore.kernel.org/all/f571e404-e625-bae1-10e9-449b2eb4cbd8@citrix.com/>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/kvm-asm-offsets.c |    1 
 arch/x86/kvm/svm/svm.c         |    9 -------
 arch/x86/kvm/svm/vmenter.S     |   49 +++++++++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -16,6 +16,7 @@ static void __used common(void)
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3923,16 +3923,7 @@ static noinstr void svm_vcpu_enter_exit(
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		/*
-		 * Use a single vmcb (vmcb01 because it's always valid) for
-		 * context switching guest state via VMLOAD/VMSAVE, that way
-		 * the state doesn't need to be copied between vmcb01 and
-		 * vmcb02 when switching vmcbs for nested virtualization.
-		 */
-		vmload(svm->vmcb01.pa);
 		__svm_vcpu_run(svm);
-		vmsave(svm->vmcb01.pa);
-
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -28,6 +28,8 @@
 #define VCPU_R15	(SVM_vcpu_arch_regs + __VCPU_REGS_R15 * WORD_SIZE)
 #endif
 
+#define SVM_vmcb01_pa	(SVM_vmcb01 + KVM_VMCB_pa)
+
 .section .noinstr.text, "ax"
 
 /**
@@ -55,6 +57,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov %_ASM_ARG1, %_ASM_DI
 .endif
 
+	/*
+	 * Use a single vmcb (vmcb01 because it's always valid) for
+	 * context switching guest state via VMLOAD/VMSAVE, that way
+	 * the state doesn't need to be copied between vmcb01 and
+	 * vmcb02 when switching vmcbs for nested virtualization.
+	 */
+	mov SVM_vmcb01_pa(%_ASM_DI), %_ASM_AX
+1:	vmload %_ASM_AX
+2:
+
 	/* Get svm->current_vmcb->pa into RAX. */
 	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
 	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
@@ -80,16 +92,11 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Enter guest mode */
 	sti
 
-1:	vmrun %_ASM_AX
-
-2:	cli
-
-#ifdef CONFIG_RETPOLINE
-	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
-	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
-#endif
+3:	vmrun %_ASM_AX
+4:
+	cli
 
-	/* "POP" @svm to RAX. */
+	/* Pop @svm to RAX while it's the only available register. */
 	pop %_ASM_AX
 
 	/* Save all guest registers.  */
@@ -110,6 +117,18 @@ SYM_FUNC_START(__svm_vcpu_run)
 	mov %r15, VCPU_R15(%_ASM_AX)
 #endif
 
+	/* @svm can stay in RDI from now on.  */
+	mov %_ASM_AX, %_ASM_DI
+
+	mov SVM_vmcb01_pa(%_ASM_DI), %_ASM_AX
+5:	vmsave %_ASM_AX
+6:
+
+#ifdef CONFIG_RETPOLINE
+	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+#endif
+
 	/*
 	 * Mitigate RETBleed for AMD/Hygon Zen uarch. RET should be
 	 * untrained as soon as we exit the VM and are back to the
@@ -159,11 +178,19 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_BP
 	RET
 
-3:	cmpb $0, kvm_rebooting
+10:	cmpb $0, kvm_rebooting
 	jne 2b
 	ud2
+30:	cmpb $0, kvm_rebooting
+	jne 4b
+	ud2
+50:	cmpb $0, kvm_rebooting
+	jne 6b
+	ud2
 
-	_ASM_EXTABLE(1b, 3b)
+	_ASM_EXTABLE(1b, 10b)
+	_ASM_EXTABLE(3b, 30b)
+	_ASM_EXTABLE(5b, 50b)
 
 SYM_FUNC_END(__svm_vcpu_run)
 


