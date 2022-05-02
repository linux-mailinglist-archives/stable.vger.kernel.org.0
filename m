Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE45517A3B
	for <lists+stable@lfdr.de>; Tue,  3 May 2022 00:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiEBW6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 18:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiEBW6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 18:58:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAF71B79C
        for <stable@vger.kernel.org>; Mon,  2 May 2022 15:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AE38B81A63
        for <stable@vger.kernel.org>; Mon,  2 May 2022 22:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2558C385A4;
        Mon,  2 May 2022 22:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651532066;
        bh=JZFW6lhPjsKEzP+pOvxKH418KGbT2kDerDfSpbpLysg=;
        h=Subject:To:Cc:From:Date:From;
        b=ROcM0VUIr3ozT3BKEb8NrEvw4b1bnf8ORLPHCNyDPTVWS8/3JCvbCRBI/qV+i80uZ
         tlUNBrO3pSYF8GUj0HdF7QDM2M2G+VPFATlZZpCZycB+QA7O8GUhW2i/h3xIke2mrh
         gD80YYiSOv7EjbHqDX6GYwN9e3a7S4juaxEVEXP8=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed" failed to apply to 5.15-stable tree
To:     seanjc@google.com, bgardon@google.com, dmatlack@google.com,
        mlevitsk@redhat.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 May 2022 00:54:25 +0200
Message-ID: <165153206514108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 86931ff7207bc045fa5439ef97b31859613dc303 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Apr 2022 23:34:16 +0000
Subject: [PATCH] KVM: x86/mmu: Do not create SPTEs for GFNs that exceed
 host.MAXPHYADDR

Disallow memslots and MMIO SPTEs whose gpa range would exceed the host's
MAXPHYADDR, i.e. don't create SPTEs for gfns that exceed host.MAXPHYADDR.
The TDP MMU bounds its zapping based on host.MAXPHYADDR, and so if the
guest, possibly with help from userspace, manages to coerce KVM into
creating a SPTE for an "impossible" gfn, KVM will leak the associated
shadow pages (page tables):

  WARNING: CPU: 10 PID: 1122 at arch/x86/kvm/mmu/tdp_mmu.c:57
                                kvm_mmu_uninit_tdp_mmu+0x4b/0x60 [kvm]
  Modules linked in: kvm_intel kvm irqbypass
  CPU: 10 PID: 1122 Comm: set_memory_regi Tainted: G        W         5.18.0-rc1+ #293
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_mmu_uninit_tdp_mmu+0x4b/0x60 [kvm]
  Call Trace:
   <TASK>
   kvm_arch_destroy_vm+0x130/0x1b0 [kvm]
   kvm_destroy_vm+0x162/0x2d0 [kvm]
   kvm_vm_release+0x1d/0x30 [kvm]
   __fput+0x82/0x240
   task_work_run+0x5b/0x90
   exit_to_user_mode_prepare+0xd2/0xe0
   syscall_exit_to_user_mode+0x1d/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>

On bare metal, encountering an impossible gpa in the page fault path is
well and truly impossible, barring CPU bugs, as the CPU will signal #PF
during the gva=>gpa translation (or a similar failure when stuffing a
physical address into e.g. the VMCS/VMCB).  But if KVM is running as a VM
itself, the MAXPHYADDR enumerated to KVM may not be the actual MAXPHYADDR
of the underlying hardware, in which case the hardware will not fault on
the illegal-from-KVM's-perspective gpa.

Alternatively, KVM could continue allowing the dodgy behavior and simply
zap the max possible range.  But, for hosts with MAXPHYADDR < 52, that's
a (minor) waste of cycles, and more importantly, KVM can't reasonably
support impossible memslots when running on bare metal (or with an
accurate MAXPHYADDR as a VM).  Note, limiting the overhead by checking if
KVM is running as a guest is not a safe option as the host isn't required
to announce itself to the guest in any way, e.g. doesn't need to set the
HYPERVISOR CPUID bit.

A second alternative to disallowing the memslot behavior would be to
disallow creating a VM with guest.MAXPHYADDR > host.MAXPHYADDR.  That
restriction is undesirable as there are legitimate use cases for doing
so, e.g. using the highest host.MAXPHYADDR out of a pool of heterogeneous
systems so that VMs can be migrated between hosts with different
MAXPHYADDRs without running afoul of the allow_smaller_maxphyaddr mess.

Note that any guest.MAXPHYADDR is valid with shadow paging, and it is
even useful in order to test KVM with MAXPHYADDR=52 (i.e. without
any reserved physical address bits).

The now common kvm_mmu_max_gfn() is inclusive instead of exclusive.
The memslot and TDP MMU code want an exclusive value, but the name
implies the returned value is inclusive, and the MMIO path needs an
inclusive check.

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Fixes: 524a1e4e381f ("KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping all SPTEs")
Cc: stable@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220428233416.2446833-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e6cae6f22683..a335e7f1f69e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -65,6 +65,30 @@ static __always_inline u64 rsvd_bits(int s, int e)
 	return ((2ULL << (e - s)) - 1) << s;
 }
 
+/*
+ * The number of non-reserved physical address bits irrespective of features
+ * that repurpose legal bits, e.g. MKTME.
+ */
+extern u8 __read_mostly shadow_phys_bits;
+
+static inline gfn_t kvm_mmu_max_gfn(void)
+{
+	/*
+	 * Note that this uses the host MAXPHYADDR, not the guest's.
+	 * EPT/NPT cannot support GPAs that would exceed host.MAXPHYADDR;
+	 * assuming KVM is running on bare metal, guest accesses beyond
+	 * host.MAXPHYADDR will hit a #PF(RSVD) and never cause a vmexit
+	 * (either EPT Violation/Misconfig or #NPF), and so KVM will never
+	 * install a SPTE for such addresses.  If KVM is running as a VM
+	 * itself, on the other hand, it might see a MAXPHYADDR that is less
+	 * than hardware's real MAXPHYADDR.  Using the host MAXPHYADDR
+	 * disallows such SPTEs entirely and simplifies the TDP MMU.
+	 */
+	int max_gpa_bits = likely(tdp_enabled) ? shadow_phys_bits : 52;
+
+	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
+}
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f9080ee50ffa..5f6225c384e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2992,9 +2992,15 @@ static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fa
 		/*
 		 * If MMIO caching is disabled, emulate immediately without
 		 * touching the shadow page tables as attempting to install an
-		 * MMIO SPTE will just be an expensive nop.
+		 * MMIO SPTE will just be an expensive nop.  Do not cache MMIO
+		 * whose gfn is greater than host.MAXPHYADDR, any guest that
+		 * generates such gfns is running nested and is being tricked
+		 * by L0 userspace (you can observe gfn > L1.MAXPHYADDR if
+		 * and only if L1's MAXPHYADDR is inaccurate with respect to
+		 * the hardware's).
 		 */
-		if (unlikely(!shadow_mmio_value)) {
+		if (unlikely(!shadow_mmio_value) ||
+		    unlikely(fault->gfn > kvm_mmu_max_gfn())) {
 			*ret_val = RET_PF_EMULATE;
 			return true;
 		}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..e4abeb5df1b1 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -201,12 +201,6 @@ static inline bool is_removed_spte(u64 spte)
  */
 extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 
-/*
- * The number of non-reserved physical address bits irrespective of features
- * that repurpose legal bits, e.g. MKTME.
- */
-extern u8 __read_mostly shadow_phys_bits;
-
 static inline bool is_mmio_spte(u64 spte)
 {
 	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c472769e0300..edc68538819b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -815,14 +815,15 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_host(void)
+static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
 {
 	/*
-	 * Bound TDP MMU walks at host.MAXPHYADDR, guest accesses beyond that
-	 * will hit a #PF(RSVD) and never hit an EPT Violation/Misconfig / #NPF,
-	 * and so KVM will never install a SPTE for such addresses.
+	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
+	 * a gpa range that would exceed the max gfn, and KVM does not create
+	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
+	 * the slow emulation path every time.
 	 */
-	return 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	return kvm_mmu_max_gfn() + 1;
 }
 
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -830,7 +831,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_host();
+	gfn_t end = tdp_mmu_max_gfn_exclusive();
 	gfn_t start = 0;
 
 	for_each_tdp_pte_min_level(iter, root, zap_level, start, end) {
@@ -923,7 +924,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	end = min(end, tdp_mmu_max_gfn_host());
+	end = min(end, tdp_mmu_max_gfn_exclusive());
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 547ba00ef64f..43174a8d9497 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11995,8 +11995,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
+			return -EINVAL;
+
 		return kvm_alloc_memslot_metadata(kvm, new);
+	}
 
 	if (change == KVM_MR_FLAGS_ONLY)
 		memcpy(&new->arch, &old->arch, sizeof(old->arch));

