Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38E645340C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 15:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhKPOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 09:25:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22027 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237236AbhKPOZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 09:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637072530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=j4fQpNyu2pGaDoE12djfDxdstokOhujexoT8EXQgWW4=;
        b=XPHqhM0+BND57RR8c+Yyzy2pTRpajtm17ftZt5HCUbmptMB/bTomnQQAIJO6gAHxX3ieJ2
        euvXXjwurdKqQJKM4juJYlhRNGuwhlbZ2f655kf3F0hnUGsVsR2R62Qkfp7D0ht2D1f74F
        zM8NQSVY2QjxY8MIyZoXit4s0U1AymI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-2cDFxo97N3-XE4B677b26A-1; Tue, 16 Nov 2021 09:22:07 -0500
X-MC-Unique: 2cDFxo97N3-XE4B677b26A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 226A3100CD00;
        Tue, 16 Nov 2021 14:22:06 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A368A5F4EF;
        Tue, 16 Nov 2021 14:22:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jgross@suse.com, Sean Christopherson <seanjc@google.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: x86: Use a stable condition around all VT-d PI paths
Date:   Tue, 16 Nov 2021 09:22:05 -0500
Message-Id: <20211116142205.719375-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, checks for whether VT-d PI can be used refer to the current
status of the feature in the current vCPU; or they more or less pick
vCPU 0 in case a specific vCPU is not available.

However, these checks do not attempt to synchronize with changes to
the IRTE.  In particular, there is no path that updates the IRTE when
APICv is re-activated on vCPU 0; and there is no path to wakeup a CPU
that has APICv disabled, if the wakeup occurs because of an IRTE
that points to a posted interrupt.

To fix this, always go through the VT-d PI path as long as there are
assigned devices and APICv is available on both the host and the VM side.
Since the relevant condition was copied over three times, take the hint
and factor it into a separate function.

Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 5f81ef092bd4..b64dd1374ed9 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -5,6 +5,7 @@
 #include <asm/cpu.h>
 
 #include "lapic.h"
+#include "irq.h"
 #include "posted_intr.h"
 #include "trace.h"
 #include "vmx.h"
@@ -77,13 +78,18 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 		pi_set_on(pi_desc);
 }
 
+static bool vmx_can_use_vtd_pi(struct kvm *kvm)
+{
+	return kvm_arch_has_assigned_device(kvm) &&
+		irq_remapping_cap(IRQ_POSTING_CAP) &&
+		irqchip_in_kernel(kvm) && enable_apicv;
+}
+
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm))
 		return;
 
 	/* Set SN when the vCPU is preempted */
@@ -141,9 +147,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old, new;
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
-		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
-		!kvm_vcpu_apicv_active(vcpu))
+	if (!vmx_can_use_vtd_pi(vcpu->kvm))
 		return 0;
 
 	WARN_ON(irqs_disabled());
@@ -270,9 +274,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
 	struct vcpu_data vcpu_info;
 	int idx, ret = 0;
 
-	if (!kvm_arch_has_assigned_device(kvm) ||
-	    !irq_remapping_cap(IRQ_POSTING_CAP) ||
-	    !kvm_vcpu_apicv_active(kvm->vcpus[0]))
+	if (!vmx_can_use_vtd_pi(kvm))
 		return 0;
 
 	idx = srcu_read_lock(&kvm->irq_srcu);
-- 
2.27.0

