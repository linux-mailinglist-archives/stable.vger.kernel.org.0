Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F20E61F6B1
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 15:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiKGOzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 09:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiKGOzh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 09:55:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDA414011
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 06:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667832882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5YDpyh7gQt2etyn3t8m5beruEQiF/HQKLk+nNtKpSY=;
        b=CpZleLImN03tuBOE9mk0VNg/OwoAwBkTURY6MsF+9QFk4d2ucBkOrerq3gW1kNOJe78GBP
        YVfMqWEF2zUi0eFlFPzThs6FFDipYbQpgmmFb/UAc9Qtc4WxMfZ1n0q5kK7UZLdaJzYpuO
        FlEAnCAJvIgmCotBJ47L73BOJRAStlQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-mOJLn8XNO92Ed2FOryesGA-1; Mon, 07 Nov 2022 09:54:38 -0500
X-MC-Unique: mOJLn8XNO92Ed2FOryesGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C56BD185A794;
        Mon,  7 Nov 2022 14:54:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82B772028CE4;
        Mon,  7 Nov 2022 14:54:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 1/8] KVM: SVM: extract VMCB accessors to a new file
Date:   Mon,  7 Nov 2022 09:54:29 -0500
Message-Id: <20221107145436.276079-2-pbonzini@redhat.com>
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

Having inline functions confuses the compilation of asm-offsets.c,
which cannot find kvm_cache_regs.h because arch/x86/kvm is not in
asm-offset.c's include path.  Just extract the functions to a
new file.

No functional change intended.

Cc: stable@vger.kernel.org
Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/avic.c         |   1 +
 arch/x86/kvm/svm/nested.c       |   1 +
 arch/x86/kvm/svm/sev.c          |   1 +
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/svm/svm.h          | 200 ------------------------------
 arch/x86/kvm/svm/svm_onhyperv.c |   1 +
 arch/x86/kvm/svm/vmcb.h         | 211 ++++++++++++++++++++++++++++++++
 7 files changed, 216 insertions(+), 200 deletions(-)
 create mode 100644 arch/x86/kvm/svm/vmcb.h

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 6919dee69f18..cc651a3310b1 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -26,6 +26,7 @@
 #include "x86.h"
 #include "irq.h"
 #include "svm.h"
+#include "vmcb.h"
 
 /* AVIC GATAG is encoded using VM and VCPU IDs */
 #define AVIC_VCPU_ID_BITS		8
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 4c620999d230..6a90aefb7a8e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -28,6 +28,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "svm.h"
+#include "vmcb.h"
 #include "hyperv.h"
 
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..73a229a9975b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -25,6 +25,7 @@
 #include "mmu.h"
 #include "x86.h"
 #include "svm.h"
+#include "vmcb.h"
 #include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f0077d9357..cd71f53590b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -43,6 +43,7 @@
 #include "trace.h"
 
 #include "svm.h"
+#include "vmcb.h"
 #include "svm_ops.h"
 
 #include "kvm_onhyperv.h"
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 6a7686bf6900..222856788153 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,8 +22,6 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
-#include "kvm_cache_regs.h"
-
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 #define	IOPM_SIZE PAGE_SIZE * 3
@@ -327,27 +325,6 @@ static __always_inline bool sev_es_guest(struct kvm *kvm)
 #endif
 }
 
-static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
-{
-	vmcb->control.clean = 0;
-}
-
-static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
-{
-	vmcb->control.clean = VMCB_ALL_CLEAN_MASK
-			       & ~VMCB_ALWAYS_DIRTY_MASK;
-}
-
-static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
-{
-	vmcb->control.clean &= ~(1 << bit);
-}
-
-static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
-{
-        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
-}
-
 static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
@@ -363,161 +340,6 @@ static __always_inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
  */
 #define SVM_REGS_LAZY_LOAD_SET	(1 << VCPU_EXREG_PDPTR)
 
-static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
-{
-	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	__set_bit(bit, (unsigned long *)&control->intercepts);
-}
-
-static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
-{
-	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	__clear_bit(bit, (unsigned long *)&control->intercepts);
-}
-
-static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
-{
-	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	return test_bit(bit, (unsigned long *)&control->intercepts);
-}
-
-static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
-{
-	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
-	return test_bit(bit, (unsigned long *)&control->intercepts);
-}
-
-static inline void set_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	if (!sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
-	}
-
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_dr_intercepts(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	vmcb->control.intercepts[INTERCEPT_DR] = 0;
-
-	/* DR7 access must remain intercepted for an SEV-ES guest */
-	if (sev_es_guest(svm->vcpu.kvm)) {
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
-		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
-	}
-
-	recalc_intercepts(svm);
-}
-
-static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	WARN_ON_ONCE(bit >= 32);
-	vmcb_set_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	WARN_ON_ONCE(bit >= 32);
-	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	vmcb_set_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
-{
-	struct vmcb *vmcb = svm->vmcb01.ptr;
-
-	vmcb_clr_intercept(&vmcb->control, bit);
-
-	recalc_intercepts(svm);
-}
-
-static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
-{
-	return vmcb_is_intercept(&svm->vmcb->control, bit);
-}
-
-static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
-{
-	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
-}
-
-static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
-{
-	if (!vgif)
-		return NULL;
-
-	if (is_guest_mode(&svm->vcpu) && !nested_vgif_enabled(svm))
-		return svm->nested.vmcb02.ptr;
-	else
-		return svm->vmcb01.ptr;
-}
-
-static inline void enable_gif(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = get_vgif_vmcb(svm);
-
-	if (vmcb)
-		vmcb->control.int_ctl |= V_GIF_MASK;
-	else
-		svm->vcpu.arch.hflags |= HF_GIF_MASK;
-}
-
-static inline void disable_gif(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = get_vgif_vmcb(svm);
-
-	if (vmcb)
-		vmcb->control.int_ctl &= ~V_GIF_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
-}
-
-static inline bool gif_set(struct vcpu_svm *svm)
-{
-	struct vmcb *vmcb = get_vgif_vmcb(svm);
-
-	if (vmcb)
-		return !!(vmcb->control.int_ctl & V_GIF_MASK);
-	else
-		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
-}
-
 static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 {
 	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
@@ -567,28 +389,6 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
 #define NESTED_EXIT_DONE	1	/* Exit caused nested vmexit  */
 #define NESTED_EXIT_CONTINUE	2	/* Further checks needed      */
 
-static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_svm *svm = to_svm(vcpu);
-
-	return is_guest_mode(vcpu) && (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK);
-}
-
-static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
-{
-	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
-}
-
-static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
-{
-	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
-}
-
-static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
-{
-	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
-}
-
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
 			 u64 vmcb_gpa, struct vmcb *vmcb12, bool from_vmrun);
 void svm_leave_nested(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 8cdc62c74a96..ae0a101329e6 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -8,6 +8,7 @@
 #include <asm/mshyperv.h>
 
 #include "svm.h"
+#include "vmcb.h"
 #include "svm_ops.h"
 
 #include "hyperv.h"
diff --git a/arch/x86/kvm/svm/vmcb.h b/arch/x86/kvm/svm/vmcb.h
new file mode 100644
index 000000000000..8757cda27e3a
--- /dev/null
+++ b/arch/x86/kvm/svm/vmcb.h
@@ -0,0 +1,211 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Kernel-based Virtual Machine driver for Linux
+ *
+ * AMD SVM support - VMCB accessors
+ */
+
+#ifndef __SVM_VMCB_H
+#define __SVM_VMCB_H
+
+#include "kvm_cache_regs.h"
+
+static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
+{
+	vmcb->control.clean = 0;
+}
+
+static inline void vmcb_mark_all_clean(struct vmcb *vmcb)
+{
+	vmcb->control.clean = VMCB_ALL_CLEAN_MASK
+			       & ~VMCB_ALWAYS_DIRTY_MASK;
+}
+
+static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
+{
+	vmcb->control.clean &= ~(1 << bit);
+}
+
+static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
+{
+        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
+}
+
+static inline void vmcb_set_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	__set_bit(bit, (unsigned long *)&control->intercepts);
+}
+
+static inline void vmcb_clr_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	__clear_bit(bit, (unsigned long *)&control->intercepts);
+}
+
+static inline bool vmcb_is_intercept(struct vmcb_control_area *control, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	return test_bit(bit, (unsigned long *)&control->intercepts);
+}
+
+static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *control, u32 bit)
+{
+	WARN_ON_ONCE(bit >= 32 * MAX_INTERCEPT);
+	return test_bit(bit, (unsigned long *)&control->intercepts);
+}
+
+static inline void set_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	if (!sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR0_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR1_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR2_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR3_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR4_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR5_WRITE);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR6_WRITE);
+	}
+
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_dr_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb->control.intercepts[INTERCEPT_DR] = 0;
+
+	/* DR7 access must remain intercepted for an SEV-ES guest */
+	if (sev_es_guest(svm->vcpu.kvm)) {
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_READ);
+		vmcb_set_intercept(&vmcb->control, INTERCEPT_DR7_WRITE);
+	}
+
+	recalc_intercepts(svm);
+}
+
+static inline void set_exception_intercept(struct vcpu_svm *svm, u32 bit)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	WARN_ON_ONCE(bit >= 32);
+	vmcb_set_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_exception_intercept(struct vcpu_svm *svm, u32 bit)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	WARN_ON_ONCE(bit >= 32);
+	vmcb_clr_intercept(&vmcb->control, INTERCEPT_EXCEPTION_OFFSET + bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void svm_set_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb_set_intercept(&vmcb->control, bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void svm_clr_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = svm->vmcb01.ptr;
+
+	vmcb_clr_intercept(&vmcb->control, bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
+{
+	return vmcb_is_intercept(&svm->vmcb->control, bit);
+}
+
+static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
+{
+	return svm->vgif_enabled && (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
+}
+
+static inline struct vmcb *get_vgif_vmcb(struct vcpu_svm *svm)
+{
+	if (!vgif)
+		return NULL;
+
+	if (is_guest_mode(&svm->vcpu) && !nested_vgif_enabled(svm))
+		return svm->nested.vmcb02.ptr;
+	else
+		return svm->vmcb01.ptr;
+}
+
+static inline void enable_gif(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl |= V_GIF_MASK;
+	else
+		svm->vcpu.arch.hflags |= HF_GIF_MASK;
+}
+
+static inline void disable_gif(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		vmcb->control.int_ctl &= ~V_GIF_MASK;
+	else
+		svm->vcpu.arch.hflags &= ~HF_GIF_MASK;
+}
+
+static inline bool gif_set(struct vcpu_svm *svm)
+{
+	struct vmcb *vmcb = get_vgif_vmcb(svm);
+
+	if (vmcb)
+		return !!(vmcb->control.int_ctl & V_GIF_MASK);
+	else
+		return !!(svm->vcpu.arch.hflags & HF_GIF_MASK);
+}
+
+static inline bool nested_svm_virtualize_tpr(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	return is_guest_mode(vcpu) && (svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK);
+}
+
+static inline bool nested_exit_on_smi(struct vcpu_svm *svm)
+{
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_SMI);
+}
+
+static inline bool nested_exit_on_intr(struct vcpu_svm *svm)
+{
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_INTR);
+}
+
+static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
+{
+	return vmcb12_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
+}
+
+#endif
-- 
2.31.1


