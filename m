Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639F46217D2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 16:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiKHPQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 10:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbiKHPQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 10:16:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EA8554ED
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 07:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bMG0zZf9sjdVoQjqJauupdPNMgqEhKDhB0nF9x5a16U=;
        b=TTuc0D8Y8TenrLuizKtP8q54s+eHpg1MRRO1FrqUBqJRuTfU6/Qn/jUabauJgQqUw4sV7z
        SY4X8lDx8mfPwHDFVAVZUYKssC4REvpYZfhJ61QdSDSjJp3zvyt6b0QFSqKRZ+8ST3yWwh
        UdW+8URfXt3NnXJyDo2H0C7gU2QJZv0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-zXmpC2wVPnuTtzBX1oexiQ-1; Tue, 08 Nov 2022 10:15:34 -0500
X-MC-Unique: zXmpC2wVPnuTtzBX1oexiQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AE8DD2A2AD70;
        Tue,  8 Nov 2022 15:15:33 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 741A340C94AA;
        Tue,  8 Nov 2022 15:15:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2 2/8] KVM: SVM: replace regs argument of __svm_vcpu_run with vcpu_svm
Date:   Tue,  8 Nov 2022 10:15:26 -0500
Message-Id: <20221108151532.1377783-3-pbonzini@redhat.com>
In-Reply-To: <20221108151532.1377783-1-pbonzini@redhat.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 arch/x86/kvm/Makefile          |  3 +++
 arch/x86/kvm/kvm-asm-offsets.c |  6 ++++++
 arch/x86/kvm/svm/svm.c         |  2 +-
 arch/x86/kvm/svm/svm.h         |  2 +-
 arch/x86/kvm/svm/vmenter.S     | 37 +++++++++++++++++-----------------
 5 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a02cf9baacc8..f453a0f96e24 100644
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
 
diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index 9d84f2b32d7f..30db96852e2d 100644
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..b412bc5773c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3930,7 +3930,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 		 * vmcb02 when switching vmcbs for nested virtualization.
 		 */
 		vmload(svm->vmcb01.pa);
-		__svm_vcpu_run(vmcb_pa, (unsigned long *)&vcpu->arch.regs);
+		__svm_vcpu_run(vmcb_pa, svm);
 		vmsave(svm->vmcb01.pa);
 
 		vmload(__sme_page_pa(sd->save_area));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..447e25c9101a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
+void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 723f8534986c..f0ff41103e4c 100644
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
-- 
2.31.1


