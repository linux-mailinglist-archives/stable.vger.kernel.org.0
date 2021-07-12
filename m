Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886BD3C482B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbhGLGgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:36:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236658AbhGLGfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F408611C0;
        Mon, 12 Jul 2021 06:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071541;
        bh=NUozkwmHPh6gfRjEmtU3I+0oeJFHpmWF6sODACJ4GiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNfpECHvLoTHXWzTdaq3sg1gtllAxRir/I5B29BiN3roajs4PigRqOTn+ej6lCDI0
         GvSjRIR5Ak9ZfEBc7U6JP//CNiLVfvPqNFWZepFMMn5qUcwj4GekRmXdwCZou80kgQ
         CrF/I0PXJ0FQpEqNknwNV6GjqCAQFe9NNW67KDug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 061/593] KVM: nVMX: Handle split-lock #AC exceptions that happen in L2
Date:   Mon, 12 Jul 2021 08:03:41 +0200
Message-Id: <20210712060849.878415750@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit b33bb78a1fada6445c265c585ee0dd0fc6279102 upstream.

Mark #ACs that won't be reinjected to the guest as wanted by L0 so that
KVM handles split-lock #AC from L2 instead of forwarding the exception to
L1.  Split-lock #AC isn't yet virtualized, i.e. L1 will treat it like a
regular #AC and do the wrong thing, e.g. reinject it into L2.

Fixes: e6f8b6c12f03 ("KVM: VMX: Extend VMXs #AC interceptor to handle split lock #AC in guest")
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622172244.3561540-1-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/nested.c |    3 +++
 arch/x86/kvm/vmx/vmcs.h   |    5 +++++
 arch/x86/kvm/vmx/vmx.c    |    4 ++--
 arch/x86/kvm/vmx/vmx.h    |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5787,6 +5787,9 @@ static bool nested_vmx_l0_wants_exit(str
 		else if (is_breakpoint(intr_info) &&
 			 vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
 			return true;
+		else if (is_alignment_check(intr_info) &&
+			 !vmx_guest_inject_ac(vcpu))
+			return true;
 		return false;
 	case EXIT_REASON_EXTERNAL_INTERRUPT:
 		return true;
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -117,6 +117,11 @@ static inline bool is_gp_fault(u32 intr_
 	return is_exception_n(intr_info, GP_VECTOR);
 }
 
+static inline bool is_alignment_check(u32 intr_info)
+{
+	return is_exception_n(intr_info, AC_VECTOR);
+}
+
 static inline bool is_machine_check(u32 intr_info)
 {
 	return is_exception_n(intr_info, MC_VECTOR);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4755,7 +4755,7 @@ static int handle_machine_check(struct k
  *  - Guest has #AC detection enabled in CR0
  *  - Guest EFLAGS has AC bit set
  */
-static inline bool guest_inject_ac(struct kvm_vcpu *vcpu)
+bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu)
 {
 	if (!boot_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT))
 		return true;
@@ -4864,7 +4864,7 @@ static int handle_exception_nmi(struct k
 		kvm_run->debug.arch.exception = ex_no;
 		break;
 	case AC_VECTOR:
-		if (guest_inject_ac(vcpu)) {
+		if (vmx_guest_inject_ac(vcpu)) {
 			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
 			return 1;
 		}
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -352,6 +352,7 @@ void vmx_set_segment(struct kvm_vcpu *vc
 u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
 		   int root_level);
 
+bool vmx_guest_inject_ac(struct kvm_vcpu *vcpu);
 void update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);


