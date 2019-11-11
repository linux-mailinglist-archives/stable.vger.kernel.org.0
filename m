Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E9AF839F
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfKKXhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:37:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:41352 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfKKXhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 18:37:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 15:37:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="197848772"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 11 Nov 2019 15:37:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4.14 STABLE 2/2] KVM: x86: introduce is_pae_paging
Date:   Mon, 11 Nov 2019 15:37:18 -0800
Message-Id: <20191111233718.28438-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111233718.28438-1-sean.j.christopherson@intel.com>
References: <20191111233718.28438-1-sean.j.christopherson@intel.com>
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
index 02c0326dc259..532598637b24 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4476,7 +4476,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
@@ -4488,7 +4488,7 @@ static void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
@@ -10914,8 +10914,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
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
index 801e7faba728..ddab027a0370 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -619,7 +619,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
+	if (!is_pae_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -848,8 +848,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_long_mode(vcpu) &&
 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
-	else if (is_pae(vcpu) && is_paging(vcpu) &&
-		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	else if (is_pae_paging(vcpu) &&
+		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	vcpu->arch.cr3 = cr3;
@@ -7751,7 +7751,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c88305d997b0..68eb0d03e5fc 100644
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
2.24.0

