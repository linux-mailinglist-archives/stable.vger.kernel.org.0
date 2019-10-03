Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56FC7CA736
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406095AbfJCQvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:51:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406091AbfJCQvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:51:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A20C20865;
        Thu,  3 Oct 2019 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121504;
        bh=kZKX+WXC1U2w0BVodPYLHkkSHyZCectetgUe9b8Nhiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NOHfIBfxJ/vOZdwIwddCQasgp/lNC3KmLusqmRiPwJ6/hI/kljjj0tadycXOBWBNK
         dNnFeBP8wZyfi9/YMwE/+TT8AO20dCGrtyLeKluYbQG5mqOeUqhxexCPQEBdZIn75X
         3WQsD1UZBFfbGEz6c33rrJhh504neODLXu7R2xkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.3 265/344] KVM: x86: Disable posted interrupts for non-standard IRQs delivery modes
Date:   Thu,  3 Oct 2019 17:53:50 +0200
Message-Id: <20191003154606.541781024@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
@@ -1583,6 +1583,13 @@ bool kvm_intr_is_single_vcpu(struct kvm
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
@@ -5274,7 +5274,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct
 
 	kvm_set_msi_irq(kvm, e, &irq);
 
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq)) {
 		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
 			 __func__, irq.vector);
 		return -1;
@@ -5328,6 +5329,7 @@ static int svm_update_pi_irte(struct kvm
 		 * 1. When cannot target interrupt to a specific vcpu.
 		 * 2. Unsetting posted interrupt.
 		 * 3. APIC virtialization is disabled for the vcpu.
+		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 		 */
 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7369,10 +7369,14 @@ static int vmx_update_pi_irte(struct kvm
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


