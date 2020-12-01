Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642AF2C9CB2
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387977AbgLAI6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387971AbgLAI6h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68BB422241;
        Tue,  1 Dec 2020 08:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813076;
        bh=N/C1JiIj6VQne11zfGbWAwPrbPCiG77eVWMcMavvBug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yy6NEPg1foXdWd0BhdfZ4r2hr/N3WGUVELguFC92pmzRXl1zbpJIg3jvIWCcT2LTu
         lgQtYacnDiSNPLxlf8O2BOLvrgqVZJ4cqV6ML43dvPMXnYMzzMAfC8kEwGDhHLeG9n
         IgDBl8t51YfC4sVCK3C5gjK4ilE1uBl5Xrl/8PNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nikos Tsironis <ntsironis@arrikto.com>
Subject: [PATCH 4.14 09/50] KVM: x86: Fix split-irqchip vs interrupt injection window request
Date:   Tue,  1 Dec 2020 09:53:08 +0100
Message-Id: <20201201084646.008889795@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 71cc849b7093bb83af966c0e60cb11b7f35cd746 upstream.

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
if we would not be able to return to userspace.  Therefore,
kvm_cpu_accept_dm_intr(vcpu) is basically !kvm_cpu_has_extint(vcpu)
ANDed with the existing check for masked ExtINT.  It all makes sense:

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
Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Tested-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/irq.c              |    2 +-
 arch/x86/kvm/x86.c              |   18 ++++++++++--------
 3 files changed, 12 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1395,6 +1395,7 @@ int kvm_test_age_hva(struct kvm *kvm, un
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_cpu_has_extint(struct kvm_vcpu *v);
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -52,7 +52,7 @@ static int pending_userspace_extint(stru
  * check if there is pending interrupt from
  * non-APIC source without intack.
  */
-static int kvm_cpu_has_extint(struct kvm_vcpu *v)
+int kvm_cpu_has_extint(struct kvm_vcpu *v)
 {
 	u8 accept = kvm_apic_accept_pic_intr(v);
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3144,21 +3144,23 @@ static int kvm_vcpu_ioctl_set_lapic(stru
 
 static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 {
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
 	return (!lapic_in_kernel(vcpu) ||
 		kvm_apic_accept_pic_intr(vcpu));
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
 


