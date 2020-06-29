Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABB20DC5B
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732856AbgF2TaS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732814AbgF2TaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13D2F2529E;
        Mon, 29 Jun 2020 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445008;
        bh=EVjxFtF+aTI5ckUpms2Wz29+/on6r4RnyXcq/86ywLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pxPRPeMtKGiin0uT0PZt6TpNxaV20No7eH4T1KkSJuHwcioJTnP/GoD9vdIxLxfj
         SCnHMa5PeExeqJ8LMUus6UP1JXZoGSHFFYxVizAknNOvgdNdwSabx3MeuEHqhdB9Ec
         wpsdz5bJQbUuP9CC0bW8CTgW4ahb9gV5tOcbpgDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 109/131] KVM: nVMX: Plumb L2 GPA through to PML emulation
Date:   Mon, 29 Jun 2020 11:34:40 -0400
Message-Id: <20200629153502.2494656-110-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 2dbebf7ae1ed9a420d954305e2c9d5ed39ec57c3 upstream.

Explicitly pass the L2 GPA to kvm_arch_write_log_dirty(), which for all
intents and purposes is vmx_write_pml_buffer(), instead of having the
latter pull the GPA from vmcs.GUEST_PHYSICAL_ADDRESS.  If the dirty bit
update is the result of KVM emulation (rare for L2), then the GPA in the
VMCS may be stale and/or hold a completely unrelated GPA.

Fixes: c5f983f6e8455 ("nVMX: Implement emulated Page Modification Logging")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200622215832.22090-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/mmu.c              | 4 ++--
 arch/x86/kvm/mmu.h              | 2 +-
 arch/x86/kvm/paging_tmpl.h      | 7 ++++---
 arch/x86/kvm/vmx.c              | 5 ++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 33136395db8fc..ce7b3b22ae86b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1099,7 +1099,7 @@ struct kvm_x86_ops {
 	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
-	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0679303e5f3db..712bc103ef3ad 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1732,10 +1732,10 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
  * Emulate arch specific page modification logging for the
  * nested hypervisor
  */
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu)
+int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa)
 {
 	if (kvm_x86_ops->write_log_dirty)
-		return kvm_x86_ops->write_log_dirty(vcpu);
+		return kvm_x86_ops->write_log_dirty(vcpu, l2_gpa);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f7b2de7b6382f..0b62c817f63f5 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -215,7 +215,7 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
+int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 61f10a4fd8074..8220190b06050 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -202,7 +202,7 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 					     struct kvm_mmu *mmu,
 					     struct guest_walker *walker,
-					     int write_fault)
+					     gpa_t addr, int write_fault)
 {
 	unsigned level, index;
 	pt_element_t pte, orig_pte;
@@ -227,7 +227,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 				!(pte & PT_GUEST_DIRTY_MASK)) {
 			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 #if PTTYPE == PTTYPE_EPT
-			if (kvm_arch_write_log_dirty(vcpu))
+			if (kvm_arch_write_log_dirty(vcpu, addr))
 				return -EINVAL;
 #endif
 			pte |= PT_GUEST_DIRTY_MASK;
@@ -424,7 +424,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);
 
 	if (unlikely(!accessed_dirty)) {
-		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker, write_fault);
+		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker,
+							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
 		else if (ret)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2c4baff7553b0..f90a9d4d16417 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -13845,11 +13845,10 @@ static void vmx_flush_log_dirty(struct kvm *kvm)
 	kvm_flush_pml_buffers(kvm);
 }
 
-static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
+static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gpa_t gpa;
 	struct page *page = NULL;
 	u64 *pml_address;
 
@@ -13870,7 +13869,7 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
 			return 1;
 		}
 
-		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS) & ~0xFFFull;
+		gpa &= ~0xFFFull;
 
 		page = kvm_vcpu_gpa_to_page(vcpu, vmcs12->pml_address);
 		if (is_error_page(page))
-- 
2.25.1

