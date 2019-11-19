Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CF7101573
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfKSFoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:44:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbfKSFoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:44:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0E52075E;
        Tue, 19 Nov 2019 05:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142255;
        bh=yx7LKwTUSFp/Jv9bAC2z1ZvGkfcLgLukF/deIfRG3uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ph9b+x6jXAmlNztWNmftKKVdBZxTxGNLjO1/xsUKwlUiYrzALwIKkUAPiGqmP2El3
         IlNuQahoOBeLyWY9d6msf3xAwEP3gnmIIssF6PerzrhngOH2r/CBiRMeWSTF1Vtr6X
         0noA+kh5xr+ZyLqTOtVjhUW2qKoCKE5E6rDmL3AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 002/239] KVM: x86: introduce is_pae_paging
Date:   Tue, 19 Nov 2019 06:16:42 +0100
Message-Id: <20191119051256.559776124@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit bf03d4f9334728bf7c8ffc7de787df48abd6340e ]

Checking for 32-bit PAE is quite common around code that fiddles with
the PDPTRs.  Add a function to compress all checks into a single
invocation.

Moving to the common helper also fixes a subtle bug in kvm_set_cr3()
where it fails to check is_long_mode() and results in KVM incorrectly
attempting to load PDPTRs for a 64-bit guest.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sean: backport to 4.x; handle vmx.c split in 5.x, call out the bugfix]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 7 +++----
 arch/x86/kvm/x86.c | 8 ++++----
 arch/x86/kvm/x86.h | 5 +++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cd5a8e888eb6b..ab6384efc7916 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4468,7 +4468,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
@@ -4480,7 +4480,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
@@ -10906,8 +10906,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
 		 * must not be dereferenced.
 		 */
-		if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu) &&
-		    !nested_ept) {
+		if (is_pae_paging(vcpu) && !nested_ept) {
 			if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
 				*entry_failure_code = ENTRY_FAIL_PDPTE;
 				return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc1b6d5bb16d6..1f9360320a82c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -620,7 +620,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
+	if (!is_pae_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -849,8 +849,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_long_mode(vcpu) &&
 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
-	else if (is_pae(vcpu) && is_paging(vcpu) &&
-		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	else if (is_pae_paging(vcpu) &&
+		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	vcpu->arch.cr3 = cr3;
@@ -7787,7 +7787,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c88305d997b0f..68eb0d03e5fc3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -94,6 +94,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
 }
 
+static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
+{
+	return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
+}
+
 static inline u32 bit(int bitno)
 {
 	return 1 << (bitno & 31);
-- 
2.20.1



