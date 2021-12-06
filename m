Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293DD469DCC
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357341AbhLFPdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60986 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349231AbhLFP1s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3665B81123;
        Mon,  6 Dec 2021 15:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1838C341C2;
        Mon,  6 Dec 2021 15:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804256;
        bh=yKyAfZPjtiq9Uxhh4U2UPF+QwEqHofHkY8znYQ3R52c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBZFMnHC3axhFRrxAVzfbtM1vhyr4HupFPz7EjCmYFMK4RxN1w2GekGUkoKihrPvI
         Nab4wMJEbGVHftyaNSx3STqIGslurmKvX9o+ZUBxZZNErKjSZwyLyWpcR0U7Li/TMr
         RK4ZWlFha3a3B0ykIzqoNSB8q6dqW7sS4GGMm/tA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 083/207] KVM: x86: check PIR even for vCPUs with disabled APICv
Date:   Mon,  6 Dec 2021 15:55:37 +0100
Message-Id: <20211206145613.118259448@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 37c4dbf337c5c2cdb24365ffae6ed70ac1e74d7a upstream.

The IRTE for an assigned device can trigger a POSTED_INTR_VECTOR even
if APICv is disabled on the vCPU that receives it.  In that case, the
interrupt will just cause a vmexit and leave the ON bit set together
with the PIR bit corresponding to the interrupt.

Right now, the interrupt would not be delivered until APICv is re-enabled.
However, fixing this is just a matter of always doing the PIR->IRR
synchronization, even if the vCPU has temporarily disabled APICv.

This is not a problem for performance, or if anything it is an
improvement.  First, in the common case where vcpu->arch.apicv_active is
true, one fewer check has to be performed.  Second, static_call_cond will
elide the function call if APICv is not present or disabled.  Finally,
in the case for AMD hardware we can remove the sync_pir_to_irr callback:
it is only needed for apic_has_interrupt_for_ppr, and that function
already has a fallback for !APICv.

Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Message-Id: <20211123004311.2954158-4-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c   |    2 +-
 arch/x86/kvm/svm/svm.c |    1 -
 arch/x86/kvm/x86.c     |   18 +++++++++---------
 3 files changed, 10 insertions(+), 11 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -707,7 +707,7 @@ static void pv_eoi_clr_pending(struct kv
 static int apic_has_interrupt_for_ppr(struct kvm_lapic *apic, u32 ppr)
 {
 	int highest_irr;
-	if (apic->vcpu->arch.apicv_active)
+	if (kvm_x86_ops.sync_pir_to_irr)
 		highest_irr = static_call(kvm_x86_sync_pir_to_irr)(apic->vcpu);
 	else
 		highest_irr = apic_find_highest_irr(apic);
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4592,7 +4592,6 @@ static struct kvm_x86_ops svm_x86_ops __
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
-	.sync_pir_to_irr = kvm_lapic_find_highest_irr,
 	.apicv_post_state_restore = avic_post_state_restore,
 
 	.set_tss_addr = svm_set_tss_addr,
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4405,8 +4405,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *
 static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
-	if (vcpu->arch.apicv_active)
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	return kvm_apic_get_state(vcpu, s);
 }
@@ -9433,8 +9432,7 @@ static void vcpu_scan_ioapic(struct kvm_
 	if (irqchip_split(vcpu->kvm))
 		kvm_scan_ioapic_routes(vcpu, vcpu->arch.ioapic_handled_vectors);
 	else {
-		if (vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 		if (ioapic_in_kernel(vcpu->kvm))
 			kvm_ioapic_scan_entry(vcpu, vcpu->arch.ioapic_handled_vectors);
 	}
@@ -9704,10 +9702,12 @@ static int vcpu_enter_guest(struct kvm_v
 
 	/*
 	 * This handles the case where a posted interrupt was
-	 * notified with kvm_vcpu_kick.
+	 * notified with kvm_vcpu_kick.  Assigned devices can
+	 * use the POSTED_INTR_VECTOR even if APICv is disabled,
+	 * so do it even if APICv is disabled on this vCPU.
 	 */
-	if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-		static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+	if (kvm_lapic_enabled(vcpu))
+		static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 	if (kvm_vcpu_exit_request(vcpu)) {
 		vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -9743,8 +9743,8 @@ static int vcpu_enter_guest(struct kvm_v
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-		if (kvm_lapic_enabled(vcpu) && vcpu->arch.apicv_active)
-			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+		if (kvm_lapic_enabled(vcpu))
+			static_call_cond(kvm_x86_sync_pir_to_irr)(vcpu);
 
 		if (unlikely(kvm_vcpu_exit_request(vcpu))) {
 			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;


