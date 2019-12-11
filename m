Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED22D11AFA3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbfLKPO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:14:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730907AbfLKPO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23A922B48;
        Wed, 11 Dec 2019 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077268;
        bh=Iq1nL2L/lJyBsynIxJSWLxogTsQyJ926IbRHWl1SMQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uhn6xmeTy84kARidHdAv3PToB7sT2kO488dZWDKZIxSv7FQKo2S+b/MOqvSipTjto
         vXxuTT8nrbZvzrhuxxbUBa9Aj9YmwHChEK9YIdCZBDu7tIWfARhjpuaocyNjsqLBVf
         KhS93oFIACxvOtQxQI1Wu/p3wK20cju9HW4aLBpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Reto Buerki <reet@codelabs.ch>
Subject: [PATCH 5.3 079/105] KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter
Date:   Wed, 11 Dec 2019 16:06:08 +0100
Message-Id: <20191211150257.684251189@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 04f11ef45810da5ae2542dd78cc353f3761bd2cb upstream.

Write the desired L2 CR3 into vmcs02.GUEST_CR3 during nested VM-Enter
instead of deferring the VMWRITE until vmx_set_cr3().  If the VMWRITE
is deferred, then KVM can consume a stale vmcs02.GUEST_CR3 when it
refreshes vmcs12->guest_cr3 during nested_vmx_vmexit() if the emulated
VM-Exit occurs without actually entering L2, e.g. if the nested run
is squashed because nested VM-Enter (from L1) is putting L2 into HLT.

Note, the above scenario can occur regardless of whether L1 is
intercepting HLT, e.g. L1 can intercept HLT and then re-enter L2 with
vmcs.GUEST_ACTIVITY_STATE=HALTED.  But practically speaking, a VMM will
likely put a guest into HALTED if and only if it's not intercepting HLT.

In an ideal world where EPT *requires* unrestricted guest (and vice
versa), VMX could handle CR3 similar to how it handles RSP and RIP,
e.g. mark CR3 dirty and conditionally load it at vmx_vcpu_run().  But
the unrestricted guest silliness complicates the dirty tracking logic
to the point that explicitly handling vmcs02.GUEST_CR3 during nested
VM-Enter is a simpler overall implementation.

Cc: stable@vger.kernel.org
Reported-and-tested-by: Reto Buerki <reet@codelabs.ch>
Tested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |   10 ++++++++++
 arch/x86/kvm/vmx/vmx.c    |   10 +++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2392,6 +2392,16 @@ static int prepare_vmcs02(struct kvm_vcp
 				entry_failure_code))
 		return -EINVAL;
 
+	/*
+	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
+	 * on nested VM-Exit, which can occur without actually running L2 and
+	 * thus without hitting vmx_set_cr3(), e.g. if L1 is entering L2 with
+	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept the
+	 * transition to HLT instead of running L2.
+	 */
+	if (enable_ept)
+		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
+
 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
 	    is_pae_paging(vcpu)) {
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2878,6 +2878,7 @@ u64 construct_eptp(struct kvm_vcpu *vcpu
 void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	struct kvm *kvm = vcpu->kvm;
+	bool update_guest_cr3 = true;
 	unsigned long guest_cr3;
 	u64 eptp;
 
@@ -2894,15 +2895,18 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu,
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
-		if (enable_unrestricted_guest || is_paging(vcpu) ||
-		    is_guest_mode(vcpu))
+		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
+		if (is_guest_mode(vcpu))
+			update_guest_cr3 = false;
+		else if (enable_unrestricted_guest || is_paging(vcpu))
 			guest_cr3 = kvm_read_cr3(vcpu);
 		else
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		ept_load_pdptrs(vcpu);
 	}
 
-	vmcs_writel(GUEST_CR3, guest_cr3);
+	if (update_guest_cr3)
+		vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)


