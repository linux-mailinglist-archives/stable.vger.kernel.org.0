Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4DFB1F32
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbfIMNQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:16:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389942AbfIMNQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:16:52 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA8FE206A5;
        Fri, 13 Sep 2019 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380611;
        bh=UDJ26B7JP8EXyUO2Tic+I61nSqCI9M9AXRFqu1IRyG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrlhKnGpbN5bWqTSDqa5BJsYlSyRCgR7/otVE8HOX45XQBmFXOKYuPZfRaMjzr3pq
         A/miTfLZNTPEUs40mvtyI7n341Wwf5/D4xJfLwsiYsDdzdo7+C3usHG3chaKxjk9Wu
         wBa70XiH7O+1yjR4co6GBPYmR20/u96NtiYPLcec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/190] kvm: mmu: Fix overflow on kvm mmu page limit calculation
Date:   Fri, 13 Sep 2019 14:06:08 +0100
Message-Id: <20190913130608.792012663@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bc8a3d8925a8fa09fa550e0da115d95851ce33c6 ]

KVM bases its memory usage limits on the total number of guest pages
across all memslots. However, those limits, and the calculations to
produce them, use 32 bit unsigned integers. This can result in overflow
if a VM has more guest pages that can be represented by a u32. As a
result of this overflow, KVM can use a low limit on the number of MMU
pages it will allocate. This makes KVM unable to map all of guest memory
at once, prompting spurious faults.

Tested: Ran all kvm-unit-tests on an Intel Haswell machine. This patch
	introduced no new failures.

Signed-off-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++++------
 arch/x86/kvm/mmu.c              | 13 ++++++-------
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b6417454a9d79..0d3f5cf3ff3ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -117,7 +117,7 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 }
 
 #define KVM_PERMILLE_MMU_PAGES 20
-#define KVM_MIN_ALLOC_MMU_PAGES 64
+#define KVM_MIN_ALLOC_MMU_PAGES 64UL
 #define KVM_MMU_HASH_SHIFT 12
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
@@ -796,9 +796,9 @@ enum kvm_irqchip_mode {
 };
 
 struct kvm_arch {
-	unsigned int n_used_mmu_pages;
-	unsigned int n_requested_mmu_pages;
-	unsigned int n_max_mmu_pages;
+	unsigned long n_used_mmu_pages;
+	unsigned long n_requested_mmu_pages;
+	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
 	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
@@ -1201,8 +1201,8 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				   gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
-unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
+unsigned long kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 bool pdptrs_changed(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cdc0c460950f3..88940261fb537 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1954,7 +1954,7 @@ static int is_empty_shadow_page(u64 *spt)
  * aggregate version in order to make the slab shrinker
  * faster
  */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
@@ -2704,7 +2704,7 @@ static bool prepare_zap_oldest_mmu_page(struct kvm *kvm,
  * Changing the number of mmu pages allocated to the vm
  * Note: if goal_nr_mmu_pages is too small, you will get dead lock
  */
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
 	LIST_HEAD(invalid_list);
 
@@ -5926,10 +5926,10 @@ out:
 /*
  * Caculate mmu pages needed for kvm.
  */
-unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
+unsigned long kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 {
-	unsigned int nr_mmu_pages;
-	unsigned int  nr_pages = 0;
+	unsigned long nr_mmu_pages;
+	unsigned long nr_pages = 0;
 	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 	int i;
@@ -5942,8 +5942,7 @@ unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm)
 	}
 
 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages,
-			   (unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
+	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
 
 	return nr_mmu_pages;
 }
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1fab69c0b2f32..65892288bf510 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -69,7 +69,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 
-static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
+static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
 {
 	if (kvm->arch.n_max_mmu_pages > kvm->arch.n_used_mmu_pages)
 		return kvm->arch.n_max_mmu_pages -
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86e35df8fbce3..33b2e3e07f925 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4116,7 +4116,7 @@ static int kvm_vm_ioctl_set_identity_map_addr(struct kvm *kvm,
 }
 
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
-					  u32 kvm_nr_mmu_pages)
+					 unsigned long kvm_nr_mmu_pages)
 {
 	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
 		return -EINVAL;
@@ -4130,7 +4130,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
 	return 0;
 }
 
-static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
+static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
 	return kvm->arch.n_max_mmu_pages;
 }
-- 
2.20.1



