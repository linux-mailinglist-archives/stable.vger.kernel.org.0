Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FCF61F6E1
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbiKGO5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbiKGO4k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3B111457
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxC4ET12VN55YVyqetOo6RD2ywSPtMRXUSJhnwR7Q90=;
        b=RvexNNAWvPHr6982FmBe3WP9N8djNnKF7qcMiKNf4jefTvmicOLv4pd0Vt7FNZn7P9rTWp
        pIe8P8c7fdwlMKRHw1Lx+NCTLonyOhqIzTN+3QkhG+vfllBSWrfUBQ/As9zj/q1JFxK/nu
        fEEFj0ZZBhp0QjlH0q1AbsRqNE/M93c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-gCx0CZFfMB68ZukcM2s1_g-1; Mon, 07 Nov 2022 09:54:39 -0500
X-MC-Unique: gCx0CZFfMB68ZukcM2s1_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27F22101A52A;
        Mon,  7 Nov 2022 14:54:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E29ED2027061;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 6/8] KVM: SVM: restore host save area from assembly
Date:   Mon,  7 Nov 2022 09:54:34 -0500
Message-Id: <20221107145436.276079-7-pbonzini@redhat.com>
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
index 550a364be8d3..381c7dcffe25 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3923,8 +3923,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		__svm_vcpu_run(svm);
-		vmload(__sme_page_pa(sd->save_area));
+		__svm_vcpu_run(svm, __sme_page_pa(sd->save_area));
 	}
 
 	guest_state_exit_irqoff();
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c5b8ec370108..99410651f2a5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -484,6 +484,6 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm);
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
index 9738ce41fac9..45a4bd002494 100644
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


