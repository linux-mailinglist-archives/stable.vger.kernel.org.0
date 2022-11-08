Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355836217E7
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 16:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiKHPR6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 10:17:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbiKHPRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 10:17:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F50858039
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 07:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667920538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0/Wm0E8iAhcRDXOgKZx+fFOSzdDhpefxd0judCP/Yc=;
        b=di+MJdyrqYWLwLFIHwwjLVW5Iy4elkNKr7sE5XNgGFffl0gAR5YG9ZBfAfxnNsz/vxE/qE
        edWhLlZPG4tB7H5i1cTh7Lc2M4bPoXI2bnzGvE9Dx8jQHxIQgAUwyUjt+VTPh5OTqFtqOG
        sR5jh6JRpzyAfT0tBJ83GhQB8h+QwnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-jet1hRbeMQSRw2ihg1V_NQ-1; Tue, 08 Nov 2022 10:15:35 -0500
X-MC-Unique: jet1hRbeMQSRw2ihg1V_NQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81DEA185A7A9;
        Tue,  8 Nov 2022 15:15:34 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4775E40C6FA3;
        Tue,  8 Nov 2022 15:15:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH v2 5/8] KVM: SVM: move guest vmsave/vmload to assembly
Date:   Tue,  8 Nov 2022 10:15:29 -0500
Message-Id: <20221108151532.1377783-6-pbonzini@redhat.com>
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

FILL_RETURN_BUFFER can access percpu data, therefore vmload of the
host save area must be executed first.  First of all, move the
VMCB vmsave/vmload to assembly.

The idea on how to number the exception tables is stolen from
a prototype patch by Peter Zijlstra.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Link: <https://lore.kernel.org/all/f571e404-e625-bae1-10e9-449b2eb4cbd8@citrix.com/>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/kvm-asm-offsets.c |  1 +
 arch/x86/kvm/svm/svm.c         |  9 -------
 arch/x86/kvm/svm/vmenter.S     | 49 ++++++++++++++++++++++++++--------
 3 files changed, 39 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index f1b694e431ae..f83e88b85bf2 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -16,6 +16,7 @@ static void __used common(void)
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
+		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c86c435c51f..0ba4feb19cb6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3922,16 +3922,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
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
 
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index d07bac1952c5..5bc2ed7d79c0 100644
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
 
-- 
2.31.1


