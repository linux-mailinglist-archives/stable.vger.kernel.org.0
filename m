Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37E459942
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 01:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhKWAq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 19:46:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231875AbhKWAqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 19:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qJn1K/aaSYXROg1XO2gBLioFKceRY2rZyLsbMWOOr0U=;
        b=Cb2Nh9sTbB0RKDQN9DZIiNR7E4P3BCd8JTIqkEavm0ACYLpt8feZzJIgbZCzFXCPj2dPZN
        T3/QqGA2a88550y1KEhb2uxHT+7jGlFdKNzbu3D/6Bdk7nNgzrYMsRhhG0JY9ZKbJ2ayiO
        leJIKoZTJyo+Nc2uB7n3Ye6loOt844A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-kftjUFaUP-urIIIPxSLZIA-1; Mon, 22 Nov 2021 19:43:14 -0500
X-MC-Unique: kftjUFaUP-urIIIPxSLZIA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F338B100CCC0;
        Tue, 23 Nov 2021 00:43:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95E4018428;
        Tue, 23 Nov 2021 00:43:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@vger.kernel.org
Subject: [PATCH 2/4] KVM: VMX: prepare sync_pir_to_irr for running with APICv disabled
Date:   Mon, 22 Nov 2021 19:43:09 -0500
Message-Id: <20211123004311.2954158-3-pbonzini@redhat.com>
In-Reply-To: <20211123004311.2954158-1-pbonzini@redhat.com>
References: <20211123004311.2954158-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If APICv is disabled for this vCPU, assigned devices may
still attempt to post interrupts.  In that case, we need
to cancel the vmentry and deliver the interrupt with
KVM_REQ_EVENT.  Extend the existing code that handles
injection of L1 interrupts into L2 to cover this case
as well.

vmx_hwapic_irr_update is only called when APICv is active
so it would be confusing to add a check for
vcpu->arch.apicv_active in there.  Instead, just use
vmx_set_rvi directly in vmx_sync_pir_to_irr.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba66c171d951..cccf1eab58ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6264,7 +6264,7 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 	int max_irr;
 	bool max_irr_updated;
 
-	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
+	if (KVM_BUG_ON(!enable_apicv, vcpu->kvm))
 		return -EIO;
 
 	if (pi_test_on(&vmx->pi_desc)) {
@@ -6276,20 +6276,31 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
 		smp_mb__after_atomic();
 		max_irr_updated =
 			kvm_apic_update_irr(vcpu, vmx->pi_desc.pir, &max_irr);
-
-		/*
-		 * If we are running L2 and L1 has a new pending interrupt
-		 * which can be injected, this may cause a vmexit or it may
-		 * be injected into L2.  Either way, this interrupt will be
-		 * processed via KVM_REQ_EVENT, not RVI, because we do not use
-		 * virtual interrupt delivery to inject L1 interrupts into L2.
-		 */
-		if (is_guest_mode(vcpu) && max_irr_updated)
-			kvm_make_request(KVM_REQ_EVENT, vcpu);
 	} else {
 		max_irr = kvm_lapic_find_highest_irr(vcpu);
+		max_irr_updated = false;
 	}
-	vmx_hwapic_irr_update(vcpu, max_irr);
+
+	/*
+	 * If virtual interrupt delivery is not in use, the interrupt
+	 * will be processed via KVM_REQ_EVENT, not RVI.  This can happen
+	 * in two cases:
+	 *
+	 * 1) If we are running L2 and L1 has a new pending interrupt
+	 * which can be injected, this may cause a vmexit or it may
+	 * be injected into L2.  We do not use virtual interrupt
+	 * delivery to inject L1 interrupts into L2.
+	 *
+	 * 2) If APICv is disabled for this vCPU, assigned devices may
+	 * still attempt to post interrupts.  The posted interrupt
+	 * vector will cause a vmexit and the subsequent entry will
+	 * call sync_pir_to_irr.
+	 */
+	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active)
+		vmx_set_rvi(max_irr);
+	else if (max_irr_updated)
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+
 	return max_irr;
 }
 
-- 
2.27.0


