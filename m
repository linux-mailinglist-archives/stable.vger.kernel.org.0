Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5396545C67D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351800AbhKXOKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353604AbhKXOGQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6B7E633EB;
        Wed, 24 Nov 2021 13:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759513;
        bh=B536EK3DhJYpbOfYtBhSCY+lujpvzWO0y5FIzrnKslw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXZSsYcsZGgLYqzNgMGtKXlC9UD1a1+7fiWceXqX991B3+QmAbQfZyJ3M9X6XBT7i
         LcUfwC2ORUZ0F5eOyPe5JKf0In5HEhNInfyjg/V6IdQYgndGxYEKKmVUsAE4C9hf+J
         l9f/orJK8L1JZBQPv0ghqruPuZlL5T4R12XoTTyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 5.15 225/279] KVM: nVMX: dont use vcpu->arch.efer when checking host state on nested state load
Date:   Wed, 24 Nov 2021 12:58:32 +0100
Message-Id: <20211124115726.510075060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit af957eebfcc17433ee83ab85b1195a933ab5049c upstream.

When loading nested state, don't use check vcpu->arch.efer to get the
L1 host's 64-bit vs. 32-bit state and don't check it for consistency
with respect to VM_EXIT_HOST_ADDR_SPACE_SIZE, as register state in vCPU
may be stale when KVM_SET_NESTED_STATE is called---and architecturally
does not exist.  When restoring L2 state in KVM, the CPU is placed in
non-root where nested VMX code has no snapshot of L1 host state: VMX
(conditionally) loads host state fields loaded on VM-exit, but they need
not correspond to the state before entry.  A simple case occurs in KVM
itself, where the host RIP field points to vmx_vmexit rather than the
instruction following vmlaunch/vmresume.

However, for the particular case of L1 being in 32- or 64-bit mode
on entry, the exit controls can be treated instead as the source of
truth regarding the state of L1 on entry, and can be used to check
that vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE matches vmcs12.HOST_EFER if
vmcs12.VM_EXIT_LOAD_IA32_EFER is set.  The consistency check on CPU
EFER vs. vmcs12.VM_EXIT_HOST_ADDR_SPACE_SIZE, instead, happens only
on VM-Enter.  That's because, again, there's conceptually no "current"
L1 EFER to check on KVM_SET_NESTED_STATE.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20211115131837.195527-2-mlevitsk@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2854,6 +2854,17 @@ static int nested_vmx_check_controls(str
 	return 0;
 }
 
+static int nested_vmx_check_address_space_size(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+#ifdef CONFIG_X86_64
+	if (CC(!!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) !=
+		!!(vcpu->arch.efer & EFER_LMA)))
+		return -EINVAL;
+#endif
+	return 0;
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -2878,18 +2889,16 @@ static int nested_vmx_check_host_state(s
 		return -EINVAL;
 
 #ifdef CONFIG_X86_64
-	ia32e = !!(vcpu->arch.efer & EFER_LMA);
+	ia32e = !!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 #else
 	ia32e = false;
 #endif
 
 	if (ia32e) {
-		if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
-		    CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
+		if (CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
 			return -EINVAL;
 	} else {
-		if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
-		    CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
+		if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
 		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
 		    CC((vmcs12->host_rip) >> 32))
 			return -EINVAL;
@@ -3559,6 +3568,9 @@ static int nested_vmx_run(struct kvm_vcp
 	if (nested_vmx_check_controls(vcpu, vmcs12))
 		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_CONTROL_FIELD);
 
+	if (nested_vmx_check_address_space_size(vcpu, vmcs12))
+		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+
 	if (nested_vmx_check_host_state(vcpu, vmcs12))
 		return nested_vmx_fail(vcpu, VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 


