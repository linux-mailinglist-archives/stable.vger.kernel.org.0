Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38251622E84
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiKIOzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiKIOyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1461C901
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ziNhSUjDCxOf3tFufpgSDwXvzmpHWVmJrvJfUAYMhyM=;
        b=ABwaB0aKwA2lSvnyCwpXOr9Q798P5SmOta5mAGyO+jn9t7FD0lCJT2EPUXEVomRUc0W5EV
        EyFdt4KAturwlNvF9Z6vODDgBOZGcP0z4Nb5fMwE3K75PUFXCi4859TI1287g48b0y5EVf
        QovSEUbumpr/b0gJ+DvvvPAuo9juzu4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-EPXywpKpOI6Nfpjfy3zKmg-1; Wed, 09 Nov 2022 09:52:01 -0500
X-MC-Unique: EPXywpKpOI6Nfpjfy3zKmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B588823F91;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CBA01401C24;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com,
        stable@vger.kernel.org
Subject: [PATCH 04/11] KVM: SVM: retrieve VMCB from assembly
Date:   Wed,  9 Nov 2022 09:51:49 -0500
Message-Id: <20221109145156.84714-5-pbonzini@redhat.com>
In-Reply-To: <20221109145156.84714-1-pbonzini@redhat.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Continue moving all accesses to struct vcpu_svm directly in vmenter.S.
This limits the confusion due to different registers used for
argument passing in 32- and 64-bit ABIs.

It is not strictly necessary for __svm_sev_es_vcpu_run, but staying
consistent is a good idea since it makes __svm_sev_es_vcpu_run a
stripped version of _svm_vcpu_run.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/kvm-asm-offsets.c |  2 ++
 arch/x86/kvm/svm/svm.c         |  5 ++---
 arch/x86/kvm/svm/svm.h         |  4 ++--
 arch/x86/kvm/svm/vmenter.S     | 20 ++++++++++----------
 4 files changed, 16 insertions(+), 15 deletions(-)

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
-- 
2.31.1


