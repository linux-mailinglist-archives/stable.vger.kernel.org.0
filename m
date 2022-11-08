Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8687C6217EA
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 16:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiKHPSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 10:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbiKHPRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 10:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FCD5985A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 07:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4OWPw63fLRICW6p1KOnQzB3r+hxhRmvIFnSfh/jmtvI=;
        b=IfThso7VDlNmXA7QBwc+9UojzmXc8lFBEencJ4yI9kNRjBB8xYlx25VV8jkMocw7qMcwXb
        hP6RHuOY+x6TtPlls5JnLW2BVetdK/gZNzONF5B8kGRxHKQhtFsa87efR4SRs4GY5wdJV0
        E018uVf+IAYmVozb1pGuh4Ie6SCrT3I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-189-JfRKkigmOcWihdGvR61SZA-1; Tue, 08 Nov 2022 10:15:36 -0500
X-MC-Unique: JfRKkigmOcWihdGvR61SZA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C45502A2AD7E;
        Tue,  8 Nov 2022 15:15:34 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 89C2F40C6FA3;
        Tue,  8 Nov 2022 15:15:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2 6/8] KVM: SVM: restore host save area from assembly
Date:   Tue,  8 Nov 2022 10:15:30 -0500
Message-Id: <20221108151532.1377783-7-pbonzini@redhat.com>
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

This is needed so that FILL_RETURN_BUFFER has access to the
percpu area via the GS segment base.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Analyzed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c     |  3 +--
 arch/x86/kvm/svm/svm.h     |  2 +-
 arch/x86/kvm/svm/svm_ops.h |  5 -----
 arch/x86/kvm/svm/vmenter.S | 13 +++++++++++++
 4 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ba4feb19cb6..e15f6ea9e5cc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3922,8 +3922,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		__svm_vcpu_run(svm);
-		vmload(__sme_page_pa(sd->save_area));
+		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area));
 	}
 
 	guest_state_exit_irqoff();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7ff1879e73c5..932f26be5675 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 /* vmenter.S */
 
 void __svm_sev_es_vcpu_run(struct vcpu_svm *svm);
-void __svm_vcpu_run(struct vcpu_svm *svm);
+void __svm_vcpu_run(struct vcpu_svm *svm, unsigned long hsave_pa);
 
 #endif
diff --git a/arch/x86/kvm/svm/svm_ops.h b/arch/x86/kvm/svm/svm_ops.h
index 9430d6437c9f..36c8af87a707 100644
--- a/arch/x86/kvm/svm/svm_ops.h
+++ b/arch/x86/kvm/svm/svm_ops.h
@@ -61,9 +61,4 @@ static __always_inline void vmsave(unsigned long pa)
 	svm_asm1(vmsave, "a" (pa), "memory");
 }
 
-static __always_inline void vmload(unsigned long pa)
-{
-	svm_asm1(vmload, "a" (pa), "memory");
-}
-
 #endif /* __KVM_X86_SVM_OPS_H */
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 5bc2ed7d79c0..0a4272faf80f 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -35,6 +35,7 @@
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode
  * @svm:	struct vcpu_svm *
+ * @hsave_pa:	unsigned long
  */
 SYM_FUNC_START(__svm_vcpu_run)
 	push %_ASM_BP
@@ -49,6 +50,9 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/* @hsave_pa is needed last after vmexit, save it first.  */
+	push %_ASM_ARG2
+
 	/* Save @svm. */
 	push %_ASM_ARG1
 
@@ -124,6 +128,11 @@ SYM_FUNC_START(__svm_vcpu_run)
 5:	vmsave %_ASM_AX
 6:
 
+	/* Pop @hsave_pa and restore GSBASE, allowing access to percpu data.  */
+	pop %_ASM_AX
+7:	vmload %_ASM_AX
+8:
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
@@ -187,10 +196,14 @@ SYM_FUNC_START(__svm_vcpu_run)
 50:	cmpb $0, kvm_rebooting
 	jne 6b
 	ud2
+70:	cmpb $0, kvm_rebooting
+	jne 8b
+	ud2
 
 	_ASM_EXTABLE(1b, 10b)
 	_ASM_EXTABLE(3b, 30b)
 	_ASM_EXTABLE(5b, 50b)
+	_ASM_EXTABLE(7b, 70b)
 
 SYM_FUNC_END(__svm_vcpu_run)
 
-- 
2.31.1


