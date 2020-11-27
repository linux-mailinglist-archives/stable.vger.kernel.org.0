Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7453C2C63D4
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 12:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgK0LVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 06:21:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729229AbgK0LVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 06:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606476080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omUDNReG1prilXKk/8Ftb102BHflLPMFss9vgnb5l+8=;
        b=W7NcY9nDDq5Cen04bEcQPM0VSSvG54yyA+aHtI0clXzlDtRAB2hbx4CS4G09DFzMDpMfRi
        4OkPvJjiACMml+M9aGeFpS+OTBBdNRijqq+pbvU9c8jrC7NDD9+JEuQb/Gr8G7YEvxxs4f
        1OZAgRNPB6VD5Fc3BP+zMWp/4OgJlKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-kn8k_OCqMuaPcIqwtQlYPg-1; Fri, 27 Nov 2020 06:21:18 -0500
X-MC-Unique: kn8k_OCqMuaPcIqwtQlYPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EDD4185E498;
        Fri, 27 Nov 2020 11:21:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE75E5D6D1;
        Fri, 27 Nov 2020 11:21:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>, stable@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection window request
Date:   Fri, 27 Nov 2020 06:21:14 -0500
Message-Id: <20201127112114.3219360-3-pbonzini@redhat.com>
In-Reply-To: <20201127112114.3219360-1-pbonzini@redhat.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

kvm_cpu_accept_dm_intr and kvm_vcpu_ready_for_interrupt_injection are
a hodge-podge of conditions, hacked together to get something that
more or less works.  But what is actually needed is much simpler;
in both cases the fundamental question is, do we have a place to stash
an interrupt if userspace does KVM_INTERRUPT?

In userspace irqchip mode, that is !vcpu->arch.interrupt.injected.
Currently kvm_event_needs_reinjection(vcpu) covers it, but it is
unnecessarily restrictive.

In split irqchip mode it's a bit more complicated, we need to check
kvm_apic_accept_pic_intr(vcpu) (the IRQ window exit is basically an INTACK
cycle and thus requires ExtINTs not to be masked) as well as
!pending_userspace_extint(vcpu).  However, there is no need to
check kvm_event_needs_reinjection(vcpu), since split irqchip keeps
pending ExtINT state separate from event injection state, and checking
kvm_cpu_has_interrupt(vcpu) is wrong too since ExtINT has higher
priority than APIC interrupts.  In fact the latter fixes a bug:
when userspace requests an IRQ window vmexit, an interrupt in the
local APIC can cause kvm_cpu_has_interrupt() to be true and thus
kvm_vcpu_ready_for_interrupt_injection() to return false.  When this
happens, vcpu_run does not exit to userspace but the interrupt window
vmexits keep occurring.  The VM loops without any hope of making progress.

Once we try to fix these with something like

     return kvm_arch_interrupt_allowed(vcpu) &&
-        !kvm_cpu_has_interrupt(vcpu) &&
-        !kvm_event_needs_reinjection(vcpu) &&
-        kvm_cpu_accept_dm_intr(vcpu);
+        (!lapic_in_kernel(vcpu)
+         ? !vcpu->arch.interrupt.injected
+         : (kvm_apic_accept_pic_intr(vcpu)
+            && !pending_userspace_extint(v)));

we realize two things.  First, thanks to the previous patch the complex
conditional can reuse !kvm_cpu_has_extint(vcpu).  Second, the interrupt
window request in vcpu_enter_guest()

        bool req_int_win =
                dm_request_for_irq_injection(vcpu) &&
                kvm_cpu_accept_dm_intr(vcpu);

should be kept in sync with kvm_vcpu_ready_for_interrupt_injection():
it is unnecessary to ask the processor for an interrupt window
if we would not be able to return to userspace.  Therefore, the
complex conditional is really the correct implementation of
kvm_cpu_accept_dm_intr(vcpu).  It all makes sense:

- we can accept an interrupt from userspace if there is a place
  to stash it (and, for irqchip split, ExtINTs are not masked).
  Interrupts from userspace _can_ be accepted even if right now
  EFLAGS.IF=0.

- in order to tell userspace we will inject its interrupt ("IRQ
  window open" i.e. kvm_vcpu_ready_for_interrupt_injection), both
  KVM and the vCPU need to be ready to accept the interrupt.

... and this is what the patch implements.

Reported-by: David Woodhouse <dwmw@amazon.co.uk>
Analyzed-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/irq.c              |  2 +-
 arch/x86/kvm/x86.c              | 17 +++++++----------
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d44858b69353..ddaf3e01a854 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1655,6 +1655,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index e2d49a506e7f..fa01f07e449e 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -40,7 +40,7 @@ static int pending_userspace_extint(struct kvm_vcpu *v)
  * check if there is pending interrupt from
  * non-APIC source without intack.
  */
-static int kvm_cpu_has_extint(struct kvm_vcpu *v)
+int kvm_cpu_has_extint(struct kvm_vcpu *v)
 {
 	/*
 	 * FIXME: interrupt.injected represents an interrupt that it's
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 447edc0d1d5a..54124b6211df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4051,21 +4051,22 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 
 static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 {
-	return (!lapic_in_kernel(vcpu) ||
-		kvm_apic_accept_pic_intr(vcpu));
+	/*
+	 * We can accept userspace's request for interrupt injection
+	 * as long as we have a place to store the interrupt number.
+	 * The actual injection will happen when the CPU is able to
+	 * deliver the interrupt.
+	 */
+	if (kvm_cpu_has_extint(vcpu))
+		return false;
+
+	/* Acknowledging ExtINT does not happen if LINT0 is masked.  */
+	return !(lapic_in_kernel(vcpu) && !kvm_apic_accept_pic_intr(vcpu));
 }
 
-/*
- * if userspace requested an interrupt window, check that the
- * interrupt window is open.
- *
- * No need to exit to userspace if we already have an interrupt queued.
- */
 static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 {
 	return kvm_arch_interrupt_allowed(vcpu) &&
-		!kvm_cpu_has_interrupt(vcpu) &&
-		!kvm_event_needs_reinjection(vcpu) &&
 		kvm_cpu_accept_dm_intr(vcpu);
 }
 
-- 
2.28.0

