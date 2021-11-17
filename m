Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4415454257
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 09:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbhKQIKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 03:10:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234390AbhKQIKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 03:10:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637136471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XjV5fBqhy8BbrVmQuut3sNPg0t9OqFdRt53NVLlK0gc=;
        b=OJESRqU+USF+KjmVULkMEDfzwq8RPny/lzmoigzyoX0ZF4LZqB0tLulrtcKKzukDlfYi52
        yQnwl0VHHEbpPwvpyr1eTL7HJAG2eU/pB4sa7Xo9uwC2z7eDn1VxrHfVFFTexDj7tVLigV
        AZlGJnSXo7dghCyjekIIWpZo00150ZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-LmHRSOnbP_6tqwOBgDc4uw-1; Wed, 17 Nov 2021 03:07:46 -0500
X-MC-Unique: LmHRSOnbP_6tqwOBgDc4uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9E2B1023F4D;
        Wed, 17 Nov 2021 08:07:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B7C71F45B;
        Wed, 17 Nov 2021 08:07:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH] KVM: x86: check PIR even for vCPUs with disabled APICv
Date:   Wed, 17 Nov 2021 03:07:44 -0500
Message-Id: <20211117080744.995111-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After fixing the handling of POSTED_INTR_WAKEUP_VECTOR for vCPUs with
disabled APICv, take care of POSTED_INTR_VECTOR.  The IRTE for an assigned
device can trigger a POSTED_INTR_VECTOR even if APICv is disabled on the
vCPU that receives it.  In that case, the interrupt will just cause a
vmexit and leave the ON bit set together with the PIR bit corresponding
to the interrupt.

Right now, the interrupt would not be delivered until APICv is re-enabled.
However, fixing this is just a matter of always doing the PIR->IRR
synchronization, even if the vCPU does not have APICv enabled.

This is not a problem for performance, or if anything it is an
improvement.  static_call_cond will elide the function call if APICv is
not present or disabled, or if (as is the case for AMD hardware) it does
not require a sync_pir_to_irr callback.  And in the common case where
kvm_vcpu_apicv_active(vcpu) is true, one fewer check has to be performed.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dcefb1485362..eda86378dcff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4445,8 +4445,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
-	if (kvm_vcpu_apicv_active(vcpu))
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -9645,8 +9644,7 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
-		if (kvm_vcpu_apicv_active(vcpu))
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -9919,10 +9917,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	/*
 	 * This handles the case where a posted interrupt was
-	 * notified with kvm_vcpu_kick.
+	 * notified with kvm_vcpu_kick.  Assigned devices can
+	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
+	 * so do it even if !kvm_vcpu_apicv_active(vcpu).
 	 */
-	if (kvm_lapic_enabled(vcpu) && kvm_vcpu_apicv_active(vcpu))
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	if (kvm_lapic_enabled(vcpu))
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
-- 
2.27.0

