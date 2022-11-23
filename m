Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509956357AF
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiKWJqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238261AbiKWJqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D0D8C0B7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9977EB81E54
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD81C433C1;
        Wed, 23 Nov 2022 09:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196600;
        bh=8Zrqd4ctnRAS19LH8qg/v6mAORs9nuICriFrRekWqWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED83woitwMCY1gDVrBbkjwMJCFRwRte7PrYTSlOC3WilATEZPK5ilORXbJPX3FuyJ
         HGebwBLw0+lazTNRQ0C+lTtkIDDiMaMWV4QomDEWHHNKydgYOI12yRBAWwGbcMl3fr
         XnwmsplhhKFDh6AvtxHKPDGnwssF+69xiNBToEuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: [PATCH 6.0 069/314] KVM: SVM: restore host save area from assembly
Date:   Wed, 23 Nov 2022 09:48:34 +0100
Message-Id: <20221123084628.616461533@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit e287bd005ad9d85dd6271dd795d3ecfb6bca46ad ]

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
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 6b2f332f5d54..c14fabd662f6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -594,7 +594,7 @@ static int svm_hardware_enable(void)
 
 	wrmsrl(MSR_EFER, efer | EFER_SVME);
 
-	wrmsrl(MSR_VM_HSAVE_PA, __sme_page_pa(sd->save_area));
+	wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 		/*
@@ -650,6 +650,7 @@ static void svm_cpu_uninit(int cpu)
 
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
+	sd->save_area_pa = 0;
 	sd->save_area = NULL;
 }
 
@@ -667,6 +668,7 @@ static int svm_cpu_init(int cpu)
 	if (ret)
 		goto free_save_area;
 
+	sd->save_area_pa = __sme_page_pa(sd->save_area);
 	return 0;
 
 free_save_area:
@@ -1452,7 +1454,7 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 * Save additional host state that will be restored on VMEXIT (sev-es)
 	 * or subsequent vmload of host save area.
 	 */
-	vmsave(__sme_page_pa(sd->save_area));
+	vmsave(sd->save_area_pa);
 	if (sev_es_guest(vcpu->kvm)) {
 		struct sev_es_save_area *hostsa;
 		hostsa = (struct sev_es_save_area *)(page_address(sd->save_area) + 0x400);
@@ -3906,14 +3908,10 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 
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
index f1483209e186..8744f3b1d217 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -288,6 +288,8 @@ struct svm_cpu_data {
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
2.35.1



