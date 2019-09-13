Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E13DFB1F44
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390090AbfIMNRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390087AbfIMNRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:39 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B888C20CC7;
        Fri, 13 Sep 2019 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380658;
        bh=mLR2BCaytQkPmVa9DK57OKlT8ix7XXhhbsX47B7kRnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFcAByXDZ91RkhsOk5BUMb+rvWDCIKMf8cHFkpOd7mkj9epXKUFjLDDcmEMUjoLkJ
         F+3J8hae53YJ1G1JQmqOWHz0M8aQoyZzZ6eB0b/X+Pg/T7zsTC5ooa2YAoD0cGAUtN
         AB4cB1AevlhphI/nSdZ7j5SfAqyJgqt2Hm6Mdbpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Peter Xu <peterx@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/190] kvm: Check irqchip mode before assign irqfd
Date:   Fri, 13 Sep 2019 14:06:31 +0100
Message-Id: <20190913130610.853718968@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 654f1f13ea56b92bacade8ce2725aea0457f91c0 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/irq.c | 7 +++++++
 arch/x86/kvm/irq.h | 1 +
 virt/kvm/eventfd.c | 9 +++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index faa264822cee3..007bc654f928a 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -172,3 +172,10 @@ void __kvm_migrate_timers(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index d5005cc265217..fd210cdd49839 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -114,6 +114,7 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 	return mode != KVM_IRQCHIP_NONE;
 }
 
+bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_apic_nmi_wd_deliver(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index b20b751286fc6..757a17f5ebdeb 100644
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
@@ -297,6 +303,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (!kvm_arch_intc_initialized(kvm))
 		return -EAGAIN;
 
+	if (!kvm_arch_irqfd_allowed(kvm, args))
+		return -EINVAL;
+
 	irqfd = kzalloc(sizeof(*irqfd), GFP_KERNEL);
 	if (!irqfd)
 		return -ENOMEM;
-- 
2.20.1



