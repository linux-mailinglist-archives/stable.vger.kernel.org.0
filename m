Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055A061F6BB
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiKGOz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbiKGOzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:55:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB51DF03
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RrSPTN1GL42ZbtbNo+KxgmJrO8rxOhcX7z7n51uQ838=;
        b=SM+KJOLJRWj+Yw6c2sXrCSKwFm6VnIkxQcMaoyA/vCBvozdKC1z0mrOWWrKqpO9/dd2tca
        zu0QbyHCEBzJ5rZKhDIfgkRDyd43FsHwCUPqner20FqPceH+MJc03nqX61ChH48UWQi2al
        G+8VJDOwSvRwcK1uK4hxQccyEUZsS+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-mZ2SsyslOgyInQB00oTyfg-1; Mon, 07 Nov 2022 09:54:38 -0500
X-MC-Unique: mZ2SsyslOgyInQB00oTyfg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13C20101A528;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE3632028CE4;
        Mon,  7 Nov 2022 14:54:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 2/8] KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
Date:   Mon,  7 Nov 2022 09:54:30 -0500
Message-Id: <20221107145436.276079-3-pbonzini@redhat.com>
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

Since registers are reachable through vcpu_svm, and we will
need to access more fields of that struct, pass it instead
of the regs[] array.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets.c |  6 ++++++
 arch/x86/kvm/svm/svm.c        |  2 +-
 arch/x86/kvm/svm/svm.h        |  2 +-
 arch/x86/kvm/svm/vmenter.S    | 36 +++++++++++++++++------------------
 4 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index cb50589a7102..85de7e4fe59a 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -20,6 +20,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tdx.h>
 #include "../kvm/vmx/vmx.h"
+#include "../kvm/svm/svm.h"
 
 #ifdef CONFIG_XEN
 #include <xen/interface/xen.h>
@@ -109,6 +110,11 @@ static void __used common(void)
 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
 
+	if (IS_ENABLED(CONFIG_KVM_AMD)) {
+		BLANK();
+		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
+	}
+
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
 		BLANK();
 		OFFSET(VMX_spec_ctrl, vcpu_vmx, spec_ctrl);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd71f53590b2..4cfa62e66a0e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3931,7 +3931,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		 * vmcb02 when switching vmcbs for nested virtualization.
 		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(vmcb_pa, (unsigned long *)&vcpu->arch.regs);
+		__svm_vcpu_run(vmcb_pa, svm);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 222856788153..5f8dfc9cd9a7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -484,6 +484,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 723f8534986c..8fac744361e5 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -8,23 +8,23 @@
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
@@ -32,7 +32,7 @@
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @vmcb_pa:	unsigned long
- * @regs:	unsigned long * (to guest registers)
+ * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -47,13 +47,13 @@ SYM_FUNC_START(__svm_vcpu_run)
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
@@ -89,7 +89,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
 #endif
 
-	/* "POP" @regs to RAX. */
+	/* "POP" @svm to RAX. */
 	pop %_ASM_AX
 
 	/* Save all guest registers.  */
-- 
2.31.1


