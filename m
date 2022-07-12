Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8C5571A68
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 14:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbiGLMsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 08:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbiGLMsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 08:48:03 -0400
X-Greylist: delayed 933 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 12 Jul 2022 05:48:02 PDT
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 097ABB31D5;
        Tue, 12 Jul 2022 05:48:02 -0700 (PDT)
Received: from BC-Mail-Ex25.internal.baidu.com (unknown [172.31.51.19])
        by Forcepoint Email with ESMTPS id C99EE6BA46BF116996BE;
        Tue, 12 Jul 2022 20:32:25 +0800 (CST)
Received: from FB9D8C53FFFC188.internal.baidu.com (172.31.62.15) by
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 12 Jul 2022 20:32:27 +0800
From:   Wang Guangju <wangguangju@baidu.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <wanpengli@tencent.com>, <bp@alien8.de>,
        <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
        <hpa@zytor.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <wangguangju@baidu.com>, <lirongqing@baidu.com>
Subject: [PATCH v3] KVM: x86: Send EOI to SynIC vectors on accelerated EOI-induced VM-Exits
Date:   Tue, 12 Jul 2022 20:32:10 +0800
Message-ID: <20220712123210.89-1-wangguangju@baidu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.31.62.15]
X-ClientProxiedBy: BC-Mail-Ex27.internal.baidu.com (172.31.51.21) To
 BC-Mail-Ex25.internal.baidu.com (172.31.51.19)
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When EOI virtualization is performed on VMX, kvm_apic_set_eoi_accelerated()
is called upon EXIT_REASON_EOI_INDUCED but unlike its non-accelerated
apic_set_eoi() sibling, Hyper-V SINT vectors are left unhandled.

Send EOI to Hyper-V SINT vectors when handling acclerated EOI-induced
VM-Exits. KVM Hyper-V needs to handle the SINT EOI irrespective of whether
the EOI is acclerated or not.

Rename kvm_apic_set_eoi_accelerated() to kvm_apic_set_eoi() and let the
non-accelerated helper call the "acclerated" version. That will document
the delta between the non-accelerated path and the accelerated path.
In addition, guarantee to trace even if there's no valid vector to EOI in
the non-accelerated path in order to keep the semantics of the function
intact.

Fixes: 5c919412fe61 ("kvm/x86: Hyper-V synthetic interrupt controller")
Cc: <stable@vger.kernel.org>
Tested-by: Wang Guangju <wangguangju@baidu.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Co-developed-by: Li Rongqing <lirongqing@baidu.com>
Signed-off-by: Wang Guangju <wangguangju@baidu.com>
---
 v1 -> v2: Updated the commit message and implement a new inline function
 of apic_set_eoi_vector()

 v2 -> v3: Updated the subject and commit message, drop func 
 apic_set_eoi_vector() and rename kvm_apic_set_eoi_accelerated() 
 to kvm_apic_set_eoi()

 arch/x86/kvm/lapic.c   | 45 ++++++++++++++++++++++-----------------------
 arch/x86/kvm/lapic.h   |  2 +-
 arch/x86/kvm/vmx/vmx.c |  3 ++-
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f03facc..b2e72ab 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1269,46 +1269,45 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 	kvm_ioapic_update_eoi(apic->vcpu, vector, trigger_mode);
 }
 
+/*
+ * Send EOI for a valid vector.  The caller, or hardware when this is invoked
+ * after an accelerated EOI VM-Exit, is responsible for updating the vISR and
+ * vPPR.
+ */
+void kvm_apic_set_eoi(struct kvm_lapic *apic, int vector)
+{
+	trace_kvm_eoi(apic, vector);
+
+	if (to_hv_vcpu(apic->vcpu) &&
+	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
+		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+
+	kvm_ioapic_send_eoi(apic, vector);
+	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_apic_set_eoi);
+
 static int apic_set_eoi(struct kvm_lapic *apic)
 {
 	int vector = apic_find_highest_isr(apic);
 
-	trace_kvm_eoi(apic, vector);
-
 	/*
 	 * Not every write EOI will has corresponding ISR,
 	 * one example is when Kernel check timer on setup_IO_APIC
 	 */
-	if (vector == -1)
+	if (vector == -1) {
+		trace_kvm_eoi(apic, vector);
 		return vector;
+	}
 
 	apic_clear_isr(vector, apic);
 	apic_update_ppr(apic);
 
-	if (to_hv_vcpu(apic->vcpu) &&
-	    test_bit(vector, to_hv_synic(apic->vcpu)->vec_bitmap))
-		kvm_hv_synic_send_eoi(apic->vcpu, vector);
+	kvm_apic_set_eoi(apic, vector);
 
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
 	return vector;
 }
 
-/*
- * this interface assumes a trap-like exit, which has already finished
- * desired side effect including vISR and vPPR update.
- */
-void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector)
-{
-	struct kvm_lapic *apic = vcpu->arch.apic;
-
-	trace_kvm_eoi(apic, vector);
-
-	kvm_ioapic_send_eoi(apic, vector);
-	kvm_make_request(KVM_REQ_EVENT, apic->vcpu);
-}
-EXPORT_SYMBOL_GPL(kvm_apic_set_eoi_accelerated);
-
 void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_low, u32 icr_high)
 {
 	struct kvm_lapic_irq irq;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 762bf61..48260fa 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -126,7 +126,7 @@ u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
 void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data);
 
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset);
-void kvm_apic_set_eoi_accelerated(struct kvm_vcpu *vcpu, int vector);
+void kvm_apic_set_eoi(struct kvm_lapic *apic, int vector);
 
 int kvm_lapic_set_vapic_addr(struct kvm_vcpu *vcpu, gpa_t vapic_addr);
 void kvm_lapic_sync_from_vapic(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9258468..f8b9eb1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5519,9 +5519,10 @@ static int handle_apic_eoi_induced(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	int vector = exit_qualification & 0xff;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	/* EOI-induced VM exit is trap-like and thus no need to adjust IP */
-	kvm_apic_set_eoi_accelerated(vcpu, vector);
+	kvm_apic_set_eoi(apic, vector);
 	return 1;
 }
 
-- 
2.9.4

