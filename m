Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE90D6280D6
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237901AbiKNNJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237925AbiKNNJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:09:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FE52873F
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EB55B80EA6
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8B2C433C1;
        Mon, 14 Nov 2022 13:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431364;
        bh=h3tJH3NKV7JvcPFMgcLnEJXJHQV9I7FpmLAjwsK1uFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihqjxEdB0eUxOuMJ5t2EQ6i4hhfs0xz8AWgQWc6uBEqa7FrMWFma6wZ4mnohg1IrR
         g5vA52jhSS2AucfQGtIe7waD4Xr/IKpuIgQUvleU+5xQSe26LTNRGjYT++MKinWILi
         7ftgpWGq9vz0StRkCyzWr4oo8dPWpk8UOzS6Ub30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 168/190] KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm
Date:   Mon, 14 Nov 2022 13:46:32 +0100
Message-Id: <20221114124506.199828361@linuxfoundation.org>
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

commit 16fdc1de169ee0a4e59a8c02244414ec7acd55c3 upstream.

Since registers are reachable through vcpu_svm, and we will
need to access more fields of that struct, pass it instead
of the regs[] array.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/Makefile          |    3 +++
 arch/x86/kvm/kvm-asm-offsets.c |    6 ++++++
 arch/x86/kvm/svm/svm.c         |    2 +-
 arch/x86/kvm/svm/svm.h         |    2 +-
 arch/x86/kvm/svm/vmenter.S     |   37 +++++++++++++++++++------------------
 5 files changed, 30 insertions(+), 20 deletions(-)

--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -35,6 +35,9 @@ obj-$(CONFIG_KVM)	+= kvm.o
 obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
 obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
 
+AFLAGS_svm/vmenter.o    := -iquote $(obj)
+$(obj)/svm/vmenter.o: $(obj)/kvm-asm-offsets.h
+
 AFLAGS_vmx/vmenter.o    := -iquote $(obj)
 $(obj)/vmx/vmenter.o: $(obj)/kvm-asm-offsets.h
 
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -8,9 +8,15 @@
 
 #include <linux/kbuild.h>
 #include "vmx/vmx.h"
+#include "svm/svm.h"
 
 static void __used common(void)
 {
+	if (IS_ENABLED(CONFIG_KVM_AMD)) {
+		BLANK();
+		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
+	}
+
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 		BLANK();
 		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3931,7 +3931,7 @@ static noinstr void svm_vcpu_enter_exit(
 		 * vmcb02 when switching vmcbs for nested virtualization.
 		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(vmcb_pa, (unsigned long *)&vcpu->arch.regs);
+		__svm_vcpu_run(vmcb_pa, svm);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
 
 #endif
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -4,27 +4,28 @@
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
+#include "kvm-asm-offsets.h"
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
 /* Intentionally omit RAX as it's context switched by hardware */
-#define VCPU_RCX	__VCPU_REGS_RCX * WORD_SIZE
-#define VCPU_RDX	__VCPU_REGS_RDX * WORD_SIZE
-#define VCPU_RBX	__VCPU_REGS_RBX * WORD_SIZE
+#define VCPU_RCX	(SVM_vcpu_arch_regs + __VCPU_REGS_RCX * WORD_SIZE)
+#define VCPU_RDX	(SVM_vcpu_arch_regs + __VCPU_REGS_RDX * WORD_SIZE)
+#define VCPU_RBX	(SVM_vcpu_arch_regs + __VCPU_REGS_RBX * WORD_SIZE)
 /* Intentionally omit RSP as it's context switched by hardware */
-#define VCPU_RBP	__VCPU_REGS_RBP * WORD_SIZE
-#define VCPU_RSI	__VCPU_REGS_RSI * WORD_SIZE
-#define VCPU_RDI	__VCPU_REGS_RDI * WORD_SIZE
+#define VCPU_RBP	(SVM_vcpu_arch_regs + __VCPU_REGS_RBP * WORD_SIZE)
+#define VCPU_RSI	(SVM_vcpu_arch_regs + __VCPU_REGS_RSI * WORD_SIZE)
+#define VCPU_RDI	(SVM_vcpu_arch_regs + __VCPU_REGS_RDI * WORD_SIZE)
 
 #ifdef CONFIG_X86_64
-#define VCPU_R8		__VCPU_REGS_R8  * WORD_SIZE
-#define VCPU_R9		__VCPU_REGS_R9  * WORD_SIZE
-#define VCPU_R10	__VCPU_REGS_R10 * WORD_SIZE
-#define VCPU_R11	__VCPU_REGS_R11 * WORD_SIZE
-#define VCPU_R12	__VCPU_REGS_R12 * WORD_SIZE
-#define VCPU_R13	__VCPU_REGS_R13 * WORD_SIZE
-#define VCPU_R14	__VCPU_REGS_R14 * WORD_SIZE
-#define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
+#define VCPU_R8		(SVM_vcpu_arch_regs + __VCPU_REGS_R8  * WORD_SIZE)
+#define VCPU_R9		(SVM_vcpu_arch_regs + __VCPU_REGS_R9  * WORD_SIZE)
+#define VCPU_R10	(SVM_vcpu_arch_regs + __VCPU_REGS_R10 * WORD_SIZE)
+#define VCPU_R11	(SVM_vcpu_arch_regs + __VCPU_REGS_R11 * WORD_SIZE)
+#define VCPU_R12	(SVM_vcpu_arch_regs + __VCPU_REGS_R12 * WORD_SIZE)
+#define VCPU_R13	(SVM_vcpu_arch_regs + __VCPU_REGS_R13 * WORD_SIZE)
+#define VCPU_R14	(SVM_vcpu_arch_regs + __VCPU_REGS_R14 * WORD_SIZE)
+#define VCPU_R15	(SVM_vcpu_arch_regs + __VCPU_REGS_R15 * WORD_SIZE)
 #endif
 
 .section .noinstr.text, "ax"
@@ -32,7 +33,7 @@
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @vmcb_pa:	unsigned long
- * @regs:	unsigned long * (to guest registers)
+ * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -47,13 +48,13 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* Save @regs. */
+	/* Save @svm. */
 	push %_ASM_ARG2
 
 	/* Save @vmcb. */
 	push %_ASM_ARG1
 
-	/* Move @regs to RAX. */
+	/* Move @svm to RAX. */
 	mov %_ASM_ARG2, %_ASM_AX
 
 	/* Load guest registers. */
@@ -89,7 +90,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
-	/* "POP" @regs to RAX. */
+	/* "POP" @svm to RAX. */
 	pop %_ASM_AX
 
 	/* Save all guest registers.  */


