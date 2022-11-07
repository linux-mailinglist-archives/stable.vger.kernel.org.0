Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADCB61F6DF
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiKGO5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiKGO4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:56:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27AA1DF3E
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a52I+9dBo63DVUvruE2JWcTU/NQRvq6IWFpQ0EqB1i0=;
        b=cRwAUhtmBB/fG8uJDfOs50ZNrtO4ad0zjeA/uGej61HtKCtJm2LEWFZcur4elBhTmqHi22
        /Qc11KP42rLPS/HHjRPcS5x2NPn+3XKZEO2aKt0B5Op9eVs8RWjL1kCsqETdrgWNLAIFwJ
        SAK0iq+QPKy8Lnbnzcf8F8hQExQB3AU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-3_Q7O6SgMUu9bD3brT7YpA-1; Mon, 07 Nov 2022 09:54:39 -0500
X-MC-Unique: 3_Q7O6SgMUu9bD3brT7YpA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9AA4185A7A8;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0B862027061;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 5/8] KVM: SVM: retrieve VMCB from assembly
Date:   Mon,  7 Nov 2022 09:54:33 -0500
Message-Id: <20221107145436.276079-6-pbonzini@redhat.com>
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

This is needed in order to keep the number of arguments to 3 or less,
so that they are all passed in registers on either 32-bit or 64-bit
builds.

It is not strictly necessary for __svm_sev_es_vcpu_run, but staying
consistent is a good idea since it makes __svm_sev_es_vcpu_run a
stripped version of _svm_vcpu_run.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/asm-offsets.c |  1 +
 arch/x86/kvm/svm/svm.c        |  5 ++---
 arch/x86/kvm/svm/svm.h        |  4 ++--
 arch/x86/kvm/svm/vmenter.S    | 20 ++++++++++----------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index f01293a1e594..69d1fed51086 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -114,6 +114,7 @@ static void __used common(void)
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
+		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ae65cdcab660..550a364be8d3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3915,16 +3915,15 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
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
 
-		__svm_vcpu_run(vmcb_pa, svm);
+		__svm_vcpu_run(svm);
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5f8dfc9cd9a7..c5b8ec370108 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -483,7 +483,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
 /* vmenter.S */
 
-void __svm_sev_es_vcpu_run(unsigned long vmcb_pa);
-void __svm_vcpu_run(unsigned long vmcb_pa, struct vcpu_svm *svm);
+void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
+void __svm_vcpu_run(struct vcpu_svm *svm);
 
 #endif
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 4709bc8868d7..9738ce41fac9 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -34,7 +34,6 @@
 
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
- * @vmcb_pa:	unsigned long
  * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_vcpu_run)
@@ -51,13 +50,12 @@ SYM_FUNC_START(__svm_vcpu_run)
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
 
 	/*
 	 * Use a single vmcb (vmcb01 because it's always valid) for
@@ -69,8 +67,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 1:	vmload %_ASM_AX
 2:
 
-	/* "POP" @vmcb to RAX. */
-	pop %_ASM_AX
+	/* Get svm->current_vmcb->pa into RAX. */
+	mov SVM_current_vmcb(%_ASM_DI), %_ASM_AX
+	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Load guest registers. */
 	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
@@ -197,7 +196,7 @@ SYM_FUNC_END(__svm_vcpu_run)
 
 /**
  * __svm_sev_es_vcpu_run - Run a SEV-ES vCPU via a transition to SVM guest mode
- * @vmcb_pa:	unsigned long
+ * @svm:	struct vcpu_svm *
  */
 SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	push %_ASM_BP
@@ -212,8 +211,9 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 #endif
 	push %_ASM_BX
 
-	/* Move @vmcb to RAX. */
-	mov %_ASM_ARG1, %_ASM_AX
+	/* Get svm->current_vmcb->pa into RAX. */
+	mov SVM_current_vmcb(%_ASM_ARG1), %_ASM_AX
+	mov KVM_VMCB_pa(%_ASM_AX), %_ASM_AX
 
 	/* Enter guest mode */
 	sti
-- 
2.31.1


