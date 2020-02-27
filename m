Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68275171F21
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgB0OBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732939AbgB0OBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:01:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015C221556;
        Thu, 27 Feb 2020 14:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812090;
        bh=NLZDNgH+JCzASQdqmltQXuwK1A91CMeMs19qt5lj1TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JH3xYOSRr1O49EugPFyAhn307oi2ybhOp7c5lWESLDqkdaps1RlWh5wN+dWIggBVG
         QQV3fUxn7D0IBkbjslafWR2vAtEBNNbXxEkz34Dcn4XOTz8CmegzbGSXusOyYAtmPT
         jb7I+hKYLbsY6smNlUF+K9irLqQLIjkQZHo5ihJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 4.14 218/237] KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1
Date:   Thu, 27 Feb 2020 14:37:12 +0100
Message-Id: <20200227132312.203908410@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 91a5f413af596ad01097e59bf487eb07cb3f1331 upstream.

Even when APICv is disabled for L1 it can (and, actually, is) still
available for L2, this means we need to always call
vmx_deliver_nested_posted_interrupt() when attempting an interrupt
delivery.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/lapic.c            |    5 +----
 arch/x86/kvm/svm.c              |    7 ++++++-
 arch/x86/kvm/vmx.c              |   13 +++++++++----
 4 files changed, 17 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1006,7 +1006,7 @@ struct kvm_x86_ops {
 	void (*load_eoi_exitmap)(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 	void (*set_virtual_apic_mode)(struct kvm_vcpu *vcpu);
 	void (*set_apic_access_page_addr)(struct kvm_vcpu *vcpu, hpa_t hpa);
-	void (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
+	int (*deliver_posted_interrupt)(struct kvm_vcpu *vcpu, int vector);
 	int (*sync_pir_to_irr)(struct kvm_vcpu *vcpu);
 	int (*set_tss_addr)(struct kvm *kvm, unsigned int addr);
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -993,11 +993,8 @@ static int __apic_accept_irq(struct kvm_
 				apic_clear_vector(vector, apic->regs + APIC_TMR);
 		}
 
-		if (vcpu->arch.apicv_active)
-			kvm_x86_ops->deliver_posted_interrupt(vcpu, vector);
-		else {
+		if (kvm_x86_ops->deliver_posted_interrupt(vcpu, vector)) {
 			kvm_lapic_set_irr(vector, apic);
-
 			kvm_make_request(KVM_REQ_EVENT, vcpu);
 			kvm_vcpu_kick(vcpu);
 		}
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4631,8 +4631,11 @@ static void svm_load_eoi_exitmap(struct
 	return;
 }
 
-static void svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
+static int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 {
+	if (!vcpu->arch.apicv_active)
+		return -1;
+
 	kvm_lapic_set_irr(vec, vcpu->arch.apic);
 	smp_mb__after_atomic();
 
@@ -4641,6 +4644,8 @@ static void svm_deliver_avic_intr(struct
 		       kvm_cpu_get_apicid(vcpu->cpu));
 	else
 		kvm_vcpu_wake_up(vcpu);
+
+	return 0;
 }
 
 static bool svm_dy_apicv_has_pending_interrupt(struct kvm_vcpu *vcpu)
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5541,24 +5541,29 @@ static int vmx_deliver_nested_posted_int
  * 2. If target vcpu isn't running(root mode), kick it to pick up the
  * interrupt from PIR in next vmentry.
  */
-static void vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
+static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int r;
 
 	r = vmx_deliver_nested_posted_interrupt(vcpu, vector);
 	if (!r)
-		return;
+		return 0;
+
+	if (!vcpu->arch.apicv_active)
+		return -1;
 
 	if (pi_test_and_set_pir(vector, &vmx->pi_desc))
-		return;
+		return 0;
 
 	/* If a previous notification has sent the IPI, nothing to do.  */
 	if (pi_test_and_set_on(&vmx->pi_desc))
-		return;
+		return 0;
 
 	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
 		kvm_vcpu_kick(vcpu);
+
+	return 0;
 }
 
 /*


