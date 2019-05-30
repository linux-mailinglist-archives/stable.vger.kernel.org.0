Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A332F6FB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 07:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfE3DJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727536AbfE3DJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:27 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F6B24479;
        Thu, 30 May 2019 03:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185767;
        bh=VMAVDhYlf8UytxJ5fjCqwzG9Fe/FJnxlukvbYTMVkKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+PyQSl8Tbvh/Foq3M4ax3V8AMaAyPHPhg9sfPf8OrYpRjJtnqVJcsmeAK1J/Qf6h
         K4eveExoL6yn3LoFUOjKiw365BOecslkQHipbf1v/tNLm/HhmkUZSfLSjvr9872KKI
         PaAViHp35DdcTu6BWq+l2YurXSlVtKRujqptoGhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 5.1 015/405] kvm: Check irqchip mode before assign irqfd
Date:   Wed, 29 May 2019 20:00:13 -0700
Message-Id: <20190530030541.268402067@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Xu <peterx@redhat.com>

commit 654f1f13ea56b92bacade8ce2725aea0457f91c0 upstream.

When assigning kvm irqfd we didn't check the irqchip mode but we allow
KVM_IRQFD to succeed with all the irqchip modes.  However it does not
make much sense to create irqfd even without the kernel chips.  Let's
provide a arch-dependent helper to check whether a specific irqfd is
allowed by the arch.  At least for x86, it should make sense to check:

- when irqchip mode is NONE, all irqfds should be disallowed, and,

- when irqchip mode is SPLIT, irqfds that are with resamplefd should
  be disallowed.

For either of the case, previously we'll silently ignore the irq or
the irq ack event if the irqchip mode is incorrect.  However that can
cause misterious guest behaviors and it can be hard to triage.  Let's
fail KVM_IRQFD even earlier to detect these incorrect configurations.

CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Radim Krčmář <rkrcmar@redhat.com>
CC: Alex Williamson <alex.williamson@redhat.com>
CC: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/irq.c |    7 +++++++
 arch/x86/kvm/irq.h |    1 +
 virt/kvm/eventfd.c |    9 +++++++++
 3 files changed, 17 insertions(+)

--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -172,3 +172,10 @@ void __kvm_migrate_timers(struct kvm_vcp
 	__kvm_migrate_apic_timer(vcpu);
 	__kvm_migrate_pit_timer(vcpu);
 }
+
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
+{
+	bool resample = args->flags & KVM_IRQFD_FLAG_RESAMPLE;
+
+	return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
+}
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -114,6 +114,7 @@ static inline int irqchip_in_kernel(stru
 	return mode != KVM_IRQCHIP_NONE;
 }
 
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -44,6 +44,12 @@
 
 static struct workqueue_struct *irqfd_cleanup_wq;
 
+bool __attribute__((weak))
+kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
+{
+	return true;
+}
+
 static void
 irqfd_inject(struct work_struct *work)
 {
@@ -297,6 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct
 	if (!kvm_arch_intc_initialized(kvm))
 		return -EAGAIN;
 
+	if (!kvm_arch_irqfd_allowed(kvm, args))
+		return -EINVAL;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL_ACCOUNT);
 	if (!irqfd)
 		return -ENOMEM;


