Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6E461F6BA
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbiKGOz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiKGOzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:55:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D39D1DF0E
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eLn2B2UMIE/ykgitRBS/Bhc4JymhVepTpG9QJmEukqo=;
        b=XU91BJAZD1awWwe2HseP7C1Mcd5yOx0iUii/sIrZVQ28+kHoAWQnL2SCKnl+x/SG7VaXzY
        CYO6OSUVU/1PcWuxTZYEpuoW6sXQDiKpsiSghuuSrRjzwhgKwuHRPWUwNLmpIK40ClArt/
        pW7Ylf2cQLLpIhZHDKjxpeE4GfszXtw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-mvaUaWYROzOnmplZDfU9PQ-1; Mon, 07 Nov 2022 09:54:39 -0500
X-MC-Unique: mvaUaWYROzOnmplZDfU9PQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97F533826A48;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DFD32024CB7;
        Mon,  7 Nov 2022 14:54:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 4/8] KVM: SVM: move guest vmsave/vmload to assembly
Date:   Mon,  7 Nov 2022 09:54:32 -0500
Message-Id: <20221107145436.276079-5-pbonzini@redhat.com>
In-Reply-To: <20221107145436.276079-1-pbonzini@redhat.com>
References: <20221107145436.276079-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 arch/x86/kernel/asm-offsets.c |  2 ++
 arch/x86/kvm/svm/svm.c        |  9 -------
 arch/x86/kvm/svm/vmenter.S    | 50 +++++++++++++++++++++++++++--------
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 85de7e4fe59a..f01293a1e594 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -113,6 +113,8 @@ static void __used common(void)
 	if (IS_ENABLED(CONFIG_KVM_AMD)) {
 		BLANK();
 		OFFSET(SVM_vcpu_arch_regs, vcpu_svm, vcpu.arch.regs);
+		OFFSET(SVM_vmcb01, vcpu_svm, vmcb01);
+		OFFSET(KVM_VMCB_pa, kvm_vmcb_info, pa);
 	}
 
 	if (IS_ENABLED(CONFIG_KVM_INTEL)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4cfa62e66a0e..ae65cdcab660 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3924,16 +3924,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	} else {
 		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
 
-		/*
-		 * Use a single vmcb (vmcb01 because it's always valid) for
-		 * context switching guest state via VMLOAD/VMSAVE, that way
-		 * the state doesn't need to be copied between vmcb01 and
-		 * vmcb02 when switching vmcbs for nested virtualization.
-		 */
-		vmload(svm->vmcb01.pa);
 		__svm_vcpu_run(vmcb_pa, svm);
-		vmsave(svm->vmcb01.pa);
-
 		vmload(__sme_page_pa(sd->save_area));
 	}
 
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index dc558d0a589e..4709bc8868d7 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <linux/linkage.h>
 #include <asm/asm.h>
+#include <asm/asm-offsets.h>
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/nospec-branch.h>
@@ -27,6 +28,8 @@
 #define VCPU_R15	(SVM_vcpu_arch_regs + __VCPU_REGS_R15 * WORD_SIZE)
 #endif
 
+#define SVM_vmcb01_pa	(SVM_vmcb01 + KVM_VMCB_pa)
+
 .section .noinstr.text, "ax"
 
 /**
@@ -56,6 +59,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Move @svm to RDI. */
 	mov %_ASM_ARG2, %_ASM_DI
 
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
 	/* "POP" @vmcb to RAX. */
 	pop %_ASM_AX
 
@@ -80,16 +93,11 @@ SYM_FUNC_START(__svm_vcpu_run)
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
@@ -110,6 +118,18 @@ SYM_FUNC_START(__svm_vcpu_run)
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
@@ -159,11 +179,19 @@ SYM_FUNC_START(__svm_vcpu_run)
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


