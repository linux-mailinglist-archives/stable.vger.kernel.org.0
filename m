Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36503CA588
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404053AbfJCQfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404256AbfJCQfO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 104B82086A;
        Thu,  3 Oct 2019 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120513;
        bh=ZgCkLt2JG903zWS9Ruydm29M6HwhLE/8rg89Q6YLjK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qK1lO6g5K30xjNxupeKQ8FJaZCblwn7XVIcfPIN0Gks1kzLMK4x00AKprcpj3LPIK
         6mF4cbUb+9nFFol9oHlvNe5wGk6GlSLRNCpIz6ruZWo2QEfr1cmTuSkT0G8Y0rJDdo
         2GkftVkkoI4/+kFDV+oY1ppPPTpCfQXb0vnyi31U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 243/313] KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes
Date:   Thu,  3 Oct 2019 17:53:41 +0200
Message-Id: <20191003154556.956790264@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Graf <graf@amazon.com>

commit fdcf756213756c23b533ca4974d1f48c6a4d4281 upstream.

We can easily route hardware interrupts directly into VM context when
they target the "Fixed" or "LowPriority" delivery modes.

However, on modes such as "SMI" or "Init", we need to go via KVM code
to actually put the vCPU into a different mode of operation, so we can
not post the interrupt

Add code in the VMX and SVM PI logic to explicitly refuse to establish
posted mappings for advanced IRQ deliver modes. This reflects the logic
in __apic_accept_irq() which also only ever passes Fixed and LowPriority
interrupts as posted interrupts into the guest.

This fixes a bug I have with code which configures real hardware to
inject virtual SMIs into my guest.

Signed-off-by: Alexander Graf <graf@amazon.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    7 +++++++
 arch/x86/kvm/svm.c              |    4 +++-
 arch/x86/kvm/vmx/vmx.c          |    6 +++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1576,6 +1576,13 @@ bool kvm_intr_is_single_vcpu(struct kvm
 void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 		     struct kvm_lapic_irq *irq);
 
+static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
+{
+	/* We can only post Fixed and LowPrio IRQs */
+	return (irq->delivery_mode == dest_Fixed ||
+		irq->delivery_mode == dest_LowestPrio);
+}
+
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops->vcpu_blocking)
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5252,7 +5252,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct
 
 	kvm_set_msi_irq(kvm, e, &irq);
 
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq)) {
 		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
 			 __func__, irq.vector);
 		return -1;
@@ -5306,6 +5307,7 @@ static int svm_update_pi_irte(struct kvm
 		 * 1. When cannot target interrupt to a specific vcpu.
 		 * 2. Unsetting posted interrupt.
 		 * 3. APIC virtialization is disabled for the vcpu.
+		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 		 */
 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7325,10 +7325,14 @@ static int vmx_update_pi_irte(struct kvm
 		 * irqbalance to make the interrupts single-CPU.
 		 *
 		 * We will support full lowest-priority interrupt later.
+		 *
+		 * In addition, we can only inject generic interrupts using
+		 * the PI mechanism, refuse to route others through it.
 		 */
 
 		kvm_set_msi_irq(kvm, e, &irq);
-		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+		    !kvm_irq_is_postable(&irq)) {
 			/*
 			 * Make sure the IRTE is in remapped mode if
 			 * we don't handle it in posted mode.


