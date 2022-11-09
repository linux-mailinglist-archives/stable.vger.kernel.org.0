Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCA622E74
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiKIOyK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiKIOyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F921DDCA
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XEckSWmxJ2CGAaPmB+HGd3M/gvibUCZukP3DHFWc0Io=;
        b=IjRKDZ5bXKHOtBUGokLK46syzhTSqKugRek1Z8Lad2gEB3vxPqLQZ/TOtPtRIo9f6SeZxg
        oP5Bng2CA9ABKtPiQM7JG3AOqugUrAykxnVdic35ApTb6DT5noD7iNmEuSNzeVYuMJ3eDb
        6Rrwnltso9KqWwUEb9tm9JGG+D0/UWM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-9OMrFGDjNeO4GKTdbjwIJw-1; Wed, 09 Nov 2022 09:52:01 -0500
X-MC-Unique: 9OMrFGDjNeO4GKTdbjwIJw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90385185A7A9;
        Wed,  9 Nov 2022 14:51:59 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 56E55140EBF5;
        Wed,  9 Nov 2022 14:51:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH 09/11] KVM: SVM: restore host save area from assembly
Date:   Wed,  9 Nov 2022 09:51:54 -0500
Message-Id: <20221109145156.84714-10-pbonzini@redhat.com>
In-Reply-To: <20221109145156.84714-1-pbonzini@redhat.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Allow access to the percpu area via the GS segment base, which is
needed in order to access the saved host spec_ctrl value.  In linux-next
FILL_RETURN_BUFFER also needs to access percpu data.

For simplicity, the physical address of the save area is added to struct
svm_cpu_data.

Cc: stable@vger.kernel.org
Fixes: a149180fbcf3 ("x86: Add magic AMD return-thunk")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Analyzed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/kvm-asm-offsets.c |  1 +
 arch/x86/kvm/svm/svm.c         | 14 ++++++--------
 arch/x86/kvm/svm/svm.h         |  2 ++
 arch/x86/kvm/svm/svm_ops.h     |  5 -----
 arch/x86/kvm/svm/vmenter.S     | 17 +++++++++++++++++
 5 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/kvm-asm-offsets.c b/arch/x86/kvm/kvm-asm-offsets.c
index f83e88b85bf2..1b805cd24d66 100644
--- a/arch/x86/kvm/kvm-asm-offsets.c
+++ b/arch/x86/kvm/kvm-asm-offsets.c
@@ -18,6 +18,7 @@ static void __used common(void)
 		OFFSET(SVM_current_vmcb, vcpu_svm, current_vmcb);
 		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
 		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
+		OFFSET(SD_save_area_pa, svm_cpu_data, save_area_pa);
 	}
 
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e3a47eb5002..469c1b5617af 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -592,7 +592,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
+	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		/*
@@ -648,6 +648,7 @@ static void svm_cpu_uninit(int cpu)
 
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
+	sd->save_area_pa = 0;
 	sd->save_area = NULL;
 }
 
@@ -665,6 +666,7 @@ static int svm_cpu_init(int cpu)
 	if (ret)
 		goto free_save_area;
 
+	sd->save_area_pa = __sme_page_pa(sd->save_area);
 	return 0;
 
 free_save_area:
@@ -1450,7 +1452,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
 	 */
-	vmsave(__sme_page_pa(sd->save_area));
+	vmsave(sd->save_area_pa);
 	if (sev_es_guest(vcpu->kvm)) {
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
@@ -3905,14 +3907,10 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
 	guest_state_enter_irqoff();
 
-	if (sev_es_guest(vcpu->kvm)) {
+	if (sev_es_guest(vcpu->kvm))
 		__svm_sev_es_vcpu_run(svm);
-	} else {
-		struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
-
+	else
 		__svm_vcpu_run(svm);
-		vmload(__sme_page_pa(sd->save_area));
-	}
 
 	guest_state_exit_irqoff();
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2af6a71126c1..83955a4e520e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -287,6 +287,8 @@ struct svm_cpu_data {
 	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
+	unsigned long save_area_pa;
+
 	struct vmcb *current_vmcb;
 
 	/* index = sev_asid, value = vmcb pointer */
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
index 5bc2ed7d79c0..57440acfc73e 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -49,6 +49,14 @@ SYM_FUNC_START(__svm_vcpu_run)
 #endif
 	push %_ASM_BX
 
+	/*
+	 * Save variables needed after vmexit on the stack, in inverse
+	 * order compared to when they are needed.
+	 */
+
+	/* Needed to restore access to percpu variables.  */
+	__ASM_SIZE(push) PER_CPU_VAR(svm_data + SD_save_area_pa)
+
 	/* Save @svm. */
 	push %_ASM_ARG1
 
@@ -124,6 +132,11 @@ SYM_FUNC_START(__svm_vcpu_run)
 5:	vmsave %_ASM_AX
 6:
 
+	/* Restores GSBASE among other things, allowing access to percpu data.  */
+	pop %_ASM_AX
+7:	vmload %_ASM_AX
+8:
+
 #ifdef CONFIG_RETPOLINE
 	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
 	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
@@ -187,10 +200,14 @@ SYM_FUNC_START(__svm_vcpu_run)
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


