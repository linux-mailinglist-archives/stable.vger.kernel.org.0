Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5E627B5A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 12:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbiKNLBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 06:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiKNLBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 06:01:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C6A51E731
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 03:01:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1C5160FF8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 11:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B526BC433C1;
        Mon, 14 Nov 2022 11:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668423673;
        bh=6mbgvsVqyVt1K01nSNyAuOTTYTHNPS/HFtVK7gcEYtw=;
        h=Subject:To:Cc:From:Date:From;
        b=K8T1JqoBbZE6PK5lfZ4XYFeohBfehF4QWsdB1bR6ZoBuuLYR8azoaFuD/LS3X2WyR
         TlUaTh3UEvLm/foZNy4LJkaYkKUiagGrFIk/TjoxEYCHvzx5e4rHaotCAzPXHttuCm
         PMvbMFhFD07iw23yJSJXDYYUnD1V5w8XL68lv9wM=
Subject: FAILED: patch "[PATCH] KVM: SVM: restore host save area from assembly" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, andrew.cooper3@citrix.com, nathan@kernel.org,
        seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Nov 2022 12:00:48 +0100
Message-ID: <1668423648106125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

e287bd005ad9 ("KVM: SVM: restore host save area from assembly")
e61ab42de874 ("KVM: SVM: move guest vmsave/vmload back to assembly")
73412dfeea72 ("KVM: SVM: do not allocate struct svm_cpu_data dynamically")
181d0fb0bb02 ("KVM: SVM: remove dead field from struct svm_cpu_data")
f6d58266d731 ("KVM: SVM: retrieve VMCB from assembly")
f7ef280132f9 ("KVM: SVM: adjust register allocation for __svm_vcpu_run()")
16fdc1de169e ("KVM: SVM: replace regs argument of __svm_vcpu_run() with vcpu_svm")
debc5a1ec0d1 ("KVM: x86: use a separate asm-offsets.c file")
bb06650634d3 ("KVM: VMX: Convert launched argument to flags")
8bd200d23ec4 ("KVM: VMX: Flatten __vmx_vcpu_run()")
527a534c7326 ("x86/tdx: Provide common base for SEAMCALL and TDCALL C wrappers")
59bd54a84d15 ("x86/tdx: Detect running as a TDX guest in early boot")
1ebdbeb03efe ("Merge tag 'for-linus' of git://git.kernel.org/pub/scm/virt/kvm/kvm")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e287bd005ad9d85dd6271dd795d3ecfb6bca46ad Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 7 Nov 2022 03:49:59 -0500
Subject: [PATCH] KVM: SVM: restore host save area from assembly

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
 

