Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD15F8320
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 23:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKKWy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 17:54:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:34124 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfKKWy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 17:54:29 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 14:54:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="202469946"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 11 Nov 2019 14:54:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4.19 STABLE] KVM: x86: introduce is_pae_paging
Date:   Mon, 11 Nov 2019 14:54:23 -0800
Message-Id: <20191111225423.29309-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Upstream commit bf03d4f9334728bf7c8ffc7de787df48abd6340e.

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
---
 arch/x86/kvm/vmx.c | 7 +++----
 arch/x86/kvm/x86.c | 8 ++++----
 arch/x86/kvm/x86.h | 5 +++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6f7b3acdab26..83acaed244ba 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5181,7 +5181,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
@@ -5193,7 +5193,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
@@ -12021,8 +12021,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
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
index 6ae8a013af31..b9b87fb75ac0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -633,7 +633,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
+	if (!is_pae_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -884,8 +884,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_long_mode(vcpu) &&
 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
-	else if (is_pae(vcpu) && is_paging(vcpu) &&
-		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	else if (is_pae_paging(vcpu) &&
+		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
@@ -8312,7 +8312,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3a91ea760f07..608e5f8c5d0a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -139,6 +139,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
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
2.24.0

