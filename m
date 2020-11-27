Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13B52C63CF
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgK0LVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:21:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726721AbgK0LVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 06:21:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606476079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GqbMRtCxZruoTwvbzdE4OugS/OPSg+DpVVIb/+sTqfY=;
        b=M9rAbe9HAZR3w4WPnF2BTEc0azwLcC8UaRZD+p6AeMgFMBK/EVCOvOV5xm7YP6LMeZew3g
        AQySiICDspmeS5zjEhlx78GWqlGUfgYjjKgJiUe/hocJ+2QP1QjaOhV2rmU5uo9XLbpAgS
        wgMw+DdvWiL20Vy+i0E6u+1AzNNIRTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-mLjARqwuNTyi9lA--OwecQ-1; Fri, 27 Nov 2020 06:21:17 -0500
X-MC-Unique: mLjARqwuNTyi9lA--OwecQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3F551006C97;
        Fri, 27 Nov 2020 11:21:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D5E75D6D1;
        Fri, 27 Nov 2020 11:21:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Filippo Sironi <sironi@amazon.de>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86: handle !lapic_in_kernel case in kvm_cpu_*_extint
Date:   Fri, 27 Nov 2020 06:21:13 -0500
Message-Id: <20201127112114.3219360-2-pbonzini@redhat.com>
In-Reply-To: <20201127112114.3219360-1-pbonzini@redhat.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Centralize handling of interrupts from the userspace APIC
in kvm_cpu_has_extint and kvm_cpu_get_extint, since
userspace APIC interrupts are handled more or less the
same as ExtINTs are with split irqchip.  This removes
duplicated code from kvm_cpu_has_injectable_intr and
kvm_cpu_has_interrupt, and makes the code more similar
between kvm_cpu_has_{extint,interrupt} on one side
and kvm_cpu_get_{extint,interrupt} on the other.

Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/irq.c   | 85 ++++++++++++++++++--------------------------
 arch/x86/kvm/lapic.c |  2 +-
 2 files changed, 35 insertions(+), 52 deletions(-)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 99d118ffc67d..e2d49a506e7f 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -42,15 +42,27 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
  */
 static int kvm_cpu_has_extint(struct kvm_vcpu *v)
 {
-	u8 accept = kvm_apic_accept_pic_intr(v);
+	/*
+	 * FIXME: interrupt.injected represents an interrupt that it's
+	 * side-effects have already been applied (e.g. bit from IRR
+	 * already moved to ISR). Therefore, it is incorrect to rely
+	 * on interrupt.injected to know if there is a pending
+	 * interrupt in the user-mode LAPIC.
+	 * This leads to nVMX/nSVM not be able to distinguish
+	 * if it should exit from L2 to L1 on EXTERNAL_INTERRUPT on
+	 * pending interrupt or should re-inject an injected
+	 * interrupt.
+	 */
+	if (!lapic_in_kernel(v))
+		return v->arch.interrupt.injected;
 
-	if (accept) {
-		if (irqchip_split(v->kvm))
-			return pending_userspace_extint(v);
-		else
-			return v->kvm->arch.vpic->output;
-	} else
+	if (!kvm_apic_accept_pic_intr(v))
 		return 0;
+
+	if (irqchip_split(v->kvm))
+		return pending_userspace_extint(v);
+	else
+		return v->kvm->arch.vpic->output;
 }
 
 /*
@@ -61,20 +73,6 @@ static int kvm_cpu_has_extint(struct kvm_vcpu *v)
  */
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v)
 {
-	/*
-	 * FIXME: interrupt.injected represents an interrupt that it's
-	 * side-effects have already been applied (e.g. bit from IRR
-	 * already moved to ISR). Therefore, it is incorrect to rely
-	 * on interrupt.injected to know if there is a pending
-	 * interrupt in the user-mode LAPIC.
-	 * This leads to nVMX/nSVM not be able to distinguish
-	 * if it should exit from L2 to L1 on EXTERNAL_INTERRUPT on
-	 * pending interrupt or should re-inject an injected
-	 * interrupt.
-	 */
-	if (!lapic_in_kernel(v))
-		return v->arch.interrupt.injected;
-
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
@@ -91,20 +89,6 @@ EXPORT_SYMBOL_GPL(kvm_cpu_has_injectable_intr);
  */
 int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 {
-	/*
-	 * FIXME: interrupt.injected represents an interrupt that it's
-	 * side-effects have already been applied (e.g. bit from IRR
-	 * already moved to ISR). Therefore, it is incorrect to rely
-	 * on interrupt.injected to know if there is a pending
-	 * interrupt in the user-mode LAPIC.
-	 * This leads to nVMX/nSVM not be able to distinguish
-	 * if it should exit from L2 to L1 on EXTERNAL_INTERRUPT on
-	 * pending interrupt or should re-inject an injected
-	 * interrupt.
-	 */
-	if (!lapic_in_kernel(v))
-		return v->arch.interrupt.injected;
-
 	if (kvm_cpu_has_extint(v))
 		return 1;
 
@@ -118,16 +102,21 @@ EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
  */
 static int kvm_cpu_get_extint(struct kvm_vcpu *v)
 {
-	if (kvm_cpu_has_extint(v)) {
-		if (irqchip_split(v->kvm)) {
-			int vector = v->arch.pending_external_vector;
-
-			v->arch.pending_external_vector = -1;
-			return vector;
-		} else
-			return kvm_pic_read_irq(v->kvm); /* PIC */
-	} else
+	if (!kvm_cpu_has_extint(v)) {
+		WARN_ON(!lapic_in_kernel(v));
 		return -1;
+	}
+
+	if (!lapic_in_kernel(v))
+		return v->arch.interrupt.nr;
+
+	if (irqchip_split(v->kvm)) {
+		int vector = v->arch.pending_external_vector;
+
+		v->arch.pending_external_vector = -1;
+		return vector;
+	} else
+		return kvm_pic_read_irq(v->kvm); /* PIC */
 }
 
 /*
@@ -135,13 +124,7 @@ static int kvm_cpu_get_extint(struct kvm_vcpu *v)
  */
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v)
 {
-	int vector;
-
-	if (!lapic_in_kernel(v))
-		return v->arch.interrupt.nr;
-
-	vector = kvm_cpu_get_extint(v);
-
+	int vector = kvm_cpu_get_extint(v);
 	if (vector != -1)
 		return vector;			/* PIC */
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 105e7859d1f2..bb5ff761d5e2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2465,7 +2465,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 	u32 ppr;
 
-	if (!kvm_apic_hw_enabled(apic))
+	if (!kvm_apic_present(vcpu))
 		return -1;
 
 	__apic_update_ppr(apic, &ppr);
-- 
2.28.0


