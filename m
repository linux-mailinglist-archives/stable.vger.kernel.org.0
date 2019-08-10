Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 255B188D94
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfHJUrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:47:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726837AbfHJUoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:04 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDY-00053a-KX; Sat, 10 Aug 2019 21:44:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003f0-6T; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Ben Gardon" <bgardon@google.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.279874124@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 089/157] kvm: mmu: Fix overflow on kvm mmu page limit
 calculation
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Gardon <bgardon@google.com>

commit bc8a3d8925a8fa09fa550e0da115d95851ce33c6 upstream.

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++++------
 arch/x86/kvm/mmu.c              | 13 ++++++-------
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/x86.c              |  4 ++--
 4 files changed, 15 insertions(+), 16 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -88,7 +88,7 @@ static inline gfn_t gfn_to_index(gfn_t g
 #define IOPL_SHIFT 12
 
 #define KVM_PERMILLE_MMU_PAGES 20
-#define KVM_MIN_ALLOC_MMU_PAGES 64
+#define KVM_MIN_ALLOC_MMU_PAGES 64UL
 #define KVM_MMU_HASH_SHIFT 10
 #define KVM_NUM_MMU_PAGES (1 << KVM_MMU_HASH_SHIFT)
 #define KVM_MIN_FREE_MMU_PAGES 5
@@ -552,9 +552,9 @@ struct kvm_apic_map {
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
@@ -810,8 +810,8 @@ void kvm_mmu_write_protect_pt_masked(str
 				     gfn_t gfn_offset, unsigned long mask);
 void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm);
-unsigned int kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
+unsigned long kvm_mmu_calculate_mmu_pages(struct kvm *kvm);
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
 
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1492,7 +1492,7 @@ static int is_empty_shadow_page(u64 *spt
  * aggregate version in order to make the slab shrinker
  * faster
  */
-static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, int nr)
+static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, unsigned long nr)
 {
 	kvm->arch.n_used_mmu_pages += nr;
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
@@ -2207,7 +2207,7 @@ static bool prepare_zap_oldest_mmu_page(
  * Changing the number of mmu pages allocated to the vm
  * Note: if goal_nr_mmu_pages is too small, you will get dead lock
  */
-void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
+void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long goal_nr_mmu_pages)
 {
 	LIST_HEAD(invalid_list);
 
@@ -4505,10 +4505,10 @@ nomem:
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
 
@@ -4518,8 +4518,7 @@ unsigned int kvm_mmu_calculate_mmu_pages
 		nr_pages += memslot->npages;
 
 	nr_mmu_pages = nr_pages * KVM_PERMILLE_MMU_PAGES / 1000;
-	nr_mmu_pages = max(nr_mmu_pages,
-			(unsigned int) KVM_MIN_ALLOC_MMU_PAGES);
+	nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
 
 	return nr_mmu_pages;
 }
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -81,7 +81,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_
 		bool execonly);
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 
-static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
+static inline unsigned long kvm_mmu_available_pages(struct kvm *kvm)
 {
 	if (kvm->arch.n_max_mmu_pages > kvm->arch.n_used_mmu_pages)
 		return kvm->arch.n_max_mmu_pages -
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3529,7 +3529,7 @@ static int kvm_vm_ioctl_set_identity_map
 }
 
 static int kvm_vm_ioctl_set_nr_mmu_pages(struct kvm *kvm,
-					  u32 kvm_nr_mmu_pages)
+					 unsigned long kvm_nr_mmu_pages)
 {
 	if (kvm_nr_mmu_pages < KVM_MIN_ALLOC_MMU_PAGES)
 		return -EINVAL;
@@ -3543,7 +3543,7 @@ static int kvm_vm_ioctl_set_nr_mmu_pages
 	return 0;
 }
 
-static int kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
+static unsigned long kvm_vm_ioctl_get_nr_mmu_pages(struct kvm *kvm)
 {
 	return kvm->arch.n_max_mmu_pages;
 }

