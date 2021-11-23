Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF58459943
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhKWAq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 19:46:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231879AbhKWAqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 19:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djWH1QVBC8UL7oOjf75CixUbXsVs6CMM1/YZOUel/lM=;
        b=hxKWTl6sYzHMdHQrkufpVblwNVimKInsTXrty26/XxeLWM6ZwHOJk0a/SP8wZLJB2WgLlx
        pCAWXqjvnliptq9ea8IgH3KssggDBGMwBV6lzhlJcHxlptzRFBN9Q843PaeYeLAyVLDlLp
        8Sosm4OAsgiMWYMz+jeB7Vjc9Z4oi1I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-598-YrP_Yp5fOneWXWUH5HrjBQ-1; Mon, 22 Nov 2021 19:43:14 -0500
X-MC-Unique: YrP_Yp5fOneWXWUH5HrjBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7834D188C147;
        Tue, 23 Nov 2021 00:43:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1939B56A92;
        Tue, 23 Nov 2021 00:43:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 3/4] KVM: x86: check PIR even for vCPUs with disabled APICv
Date:   Mon, 22 Nov 2021 19:43:10 -0500
Message-Id: <20211123004311.2954158-4-pbonzini@redhat.com>
In-Reply-To: <20211123004311.2954158-1-pbonzini@redhat.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IRTE for an assigned device can trigger a POSTED_INTR_VECTOR even
if APICv is disabled on the vCPU that receives it.  In that case, the
interrupt will just cause a vmexit and leave the ON bit set together
with the PIR bit corresponding to the interrupt.

Right now, the interrupt would not be delivered until APICv is re-enabled.
However, fixing this is just a matter of always doing the PIR->IRR
synchronization, even if the vCPU has temporarily disabled APICv.

This is not a problem for performance, or if anything it is an
improvement.  First, in the common case where vcpu->arch.apicv_active is
true, one fewer check has to be performed.  Second, static_call_cond will
elide the function call if APICv is not present or disabled.  Finally,
in the case for AMD hardware we can remove the sync_pir_to_irr callback:
it is only needed for apic_has_interrupt_for_ppr, and that function
already has a fallback for !APICv.

Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c   |  2 +-
 arch/x86/kvm/svm/svm.c |  1 -
 arch/x86/kvm/x86.c     | 18 +++++++++---------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..f206fc35deff 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -707,7 +707,7 @@ static void pv_eoi_clr_pending(struct kvm_vcpu *vcpu)
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
-	if (apic->vcpu->arch.apicv_active)
+	if (kvm_x86_ops.sync_pir_to_irr)
 		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5630c241d5f6..d0f68d11ec70 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4651,7 +4651,6 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
-	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
 	.apicv_post_state_restore = avic_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 441f4769173e..a8f12c83db4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4448,8 +4448,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
-	if (vcpu->arch.apicv_active)
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -9528,8 +9527,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
-		if (vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -9802,10 +9800,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	/*
 	 * This handles the case where a posted interrupt was
-	 * notified with kvm_vcpu_kick.
+	 * notified with kvm_vcpu_kick.  Assigned devices can
+	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
+	 * so do it even if APICv is disabled on this vCPU.
 	 */
-	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	if (kvm_lapic_enabled(vcpu))
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -9849,8 +9849,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+		if (kvm_lapic_enabled(vcpu))
+			static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
-- 
2.27.0


