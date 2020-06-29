Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC820D9EE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbgF2TwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:52:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387717AbgF2Tkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7665024911;
        Mon, 29 Jun 2020 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444466;
        bh=nClVM/6n33gE2bdRgvpM6esDuLr+bUqP/M+CYFqdkwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXz9O1iNpdTh7oXhAU/Ls774wXsqpxs+2C+tsdCpiv4uI0ORfPcU58raCWD5AkVO2
         RCRXASt0w/6DJDCo/aKzruv9i4YmN05vhZOZWico33xhnLqy0uoSoXljaR1qgb4Ni/
         KAoRB1oy1ydxh6oHezGJhDTWQkElJUpOQ6uFxgnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 146/178] KVM: nVMX: Plumb L2 GPA through to PML emulation
Date:   Mon, 29 Jun 2020 11:24:51 -0400
Message-Id: <20200629152523.2494198-147-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
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
 arch/x86/kvm/vmx/vmx.c          | 6 +++---
 5 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7d91a3f5b26ab..742de9d97ba14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1160,7 +1160,7 @@ struct kvm_x86_ops {
 	void (*enable_log_dirty_pt_masked)(struct kvm *kvm,
 					   struct kvm_memory_slot *slot,
 					   gfn_t offset, unsigned long mask);
-	int (*write_log_dirty)(struct kvm_vcpu *vcpu);
+	int (*write_log_dirty)(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 	/* pmu operations of sub-arch */
 	const struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a3824ae9a634c..aab02ea2d2cb2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1819,10 +1819,10 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
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
index d55674f44a18b..6f2208cf30df3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -209,7 +209,7 @@ void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 				    struct kvm_memory_slot *slot, u64 gfn);
-int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
+int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu, gpa_t l2_gpa);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 4e3f137ffa8c8..a20fc1ba607f3 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -220,7 +220,7 @@ static inline unsigned FNAME(gpte_access)(u64 gpte)
 static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 					     struct kvm_mmu *mmu,
 					     struct guest_walker *walker,
-					     int write_fault)
+					     gpa_t addr, int write_fault)
 {
 	unsigned level, index;
 	pt_element_t pte, orig_pte;
@@ -245,7 +245,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 				!(pte & PT_GUEST_DIRTY_MASK)) {
 			trace_kvm_mmu_set_dirty_bit(table_gfn, index, sizeof(pte));
 #if PTTYPE == PTTYPE_EPT
-			if (kvm_arch_write_log_dirty(vcpu))
+			if (kvm_arch_write_log_dirty(vcpu, addr))
 				return -EINVAL;
 #endif
 			pte |= PT_GUEST_DIRTY_MASK;
@@ -442,7 +442,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			(PT_GUEST_DIRTY_SHIFT - PT_GUEST_ACCESSED_SHIFT);
 
 	if (unlikely(!accessed_dirty)) {
-		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker, write_fault);
+		ret = FNAME(update_accessed_dirty_bits)(vcpu, mmu, walker,
+							addr, write_fault);
 		if (unlikely(ret < 0))
 			goto error;
 		else if (ret)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5fac01865a2dc..2e6d400ce0a01 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7272,11 +7272,11 @@ static void vmx_flush_log_dirty(struct kvm *kvm)
 	kvm_flush_pml_buffers(kvm);
 }
 
-static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
+static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
 	struct vmcs12 *vmcs12;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	gpa_t gpa, dst;
+	gpa_t dst;
 
 	if (is_guest_mode(vcpu)) {
 		WARN_ON_ONCE(vmx->nested.pml_full);
@@ -7295,7 +7295,7 @@ static int vmx_write_pml_buffer(struct kvm_vcpu *vcpu)
 			return 1;
 		}
 
-		gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS) & ~0xFFFull;
+		gpa &= ~0xFFFull;
 		dst = vmcs12->pml_address + sizeof(u64) * vmcs12->guest_pml_index;
 
 		if (kvm_write_guest_page(vcpu->kvm, gpa_to_gfn(dst), &gpa,
-- 
2.25.1

