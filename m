Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC8644F7CB
	for <lists+stable@lfdr.de>; Sun, 14 Nov 2021 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhKNMUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Nov 2021 07:20:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:40012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhKNMUb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 14 Nov 2021 07:20:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C7BF60EBC;
        Sun, 14 Nov 2021 12:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636892257;
        bh=jjIZGEIwXZUHqN/0z3RLhuOLRBxkhfFoYJJBkZkmPGw=;
        h=Subject:To:Cc:From:Date:From;
        b=QEtKHzIpoLFwUsOOu2DIE9N2Df5ffHy5RSSpEDTpiKxWPwbRz5Kov8FcvslT6FO61
         OJwhz5v+kNUch6CASW8ggIzCcoR8ulmOuU14oxgcuLwNFjOSBZrBNCF8D32Q6NQPa+
         zpmWY5auBR9994GzVv8I+MDTRJfBfp3/cnWdAsTs=
Subject: FAILED: patch "[PATCH] KVM: x86: Fix recording of guest steal time / preempted" failed to apply to 4.19-stable tree
To:     dwmw2@infradead.org, dwmw@amazon.co.uk, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Nov 2021 13:17:34 +0100
Message-ID: <1636892254160222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7e2175ebd695f17860c5bd4ad7616cce12ed4591 Mon Sep 17 00:00:00 2001
From: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 2 Nov 2021 17:36:39 +0000
Subject: [PATCH] KVM: x86: Fix recording of guest steal time / preempted
 status

In commit b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is
not missed") we switched to using a gfn_to_pfn_cache for accessing the
guest steal time structure in order to allow for an atomic xchg of the
preempted field. This has a couple of problems.

Firstly, kvm_map_gfn() doesn't work at all for IOMEM pages when the
atomic flag is set, which it is in kvm_steal_time_set_preempted(). So a
guest vCPU using an IOMEM page for its steal time would never have its
preempted field set.

Secondly, the gfn_to_pfn_cache is not invalidated in all cases where it
should have been. There are two stages to the GFN->PFN conversion;
first the GFN is converted to a userspace HVA, and then that HVA is
looked up in the process page tables to find the underlying host PFN.
Correct invalidation of the latter would require being hooked up to the
MMU notifiers, but that doesn't happen---so it just keeps mapping and
unmapping the *wrong* PFN after the userspace page tables change.

In the !IOMEM case at least the stale page *is* pinned all the time it's
cached, so it won't be freed and reused by anyone else while still
receiving the steal time updates. The map/unmap dance only takes care
of the KVM administrivia such as marking the page dirty.

Until the gfn_to_pfn cache handles the remapping automatically by
integrating with the MMU notifiers, we might as well not get a
kernel mapping of it, and use the perfectly serviceable userspace HVA
that we already have.  We just need to implement the atomic xchg on
the userspace address with appropriate exception handling, which is
fairly trivial.

Cc: stable@vger.kernel.org
Fixes: b043138246a4 ("x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <3645b9b889dac6438394194bb5586a46b68d581f.camel@infradead.org>
[I didn't entirely agree with David's assessment of the
 usefulness of the gfn_to_pfn cache, and integrated the outcome
 of the discussion in the above commit message. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..32345241e620 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -748,7 +748,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_pfn_cache cache;
+		struct gfn_to_hva_cache cache;
 	} st;
 
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac83d873d65b..e7d2ef944cc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3260,8 +3260,11 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	u64 steal;
+	u32 version;
 
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
 		kvm_xen_runstate_set_running(vcpu);
@@ -3271,47 +3274,83 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
 
-	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
-			&map, &vcpu->arch.st.cache, false))
+	if (WARN_ON_ONCE(current->mm != vcpu->kvm->mm))
 		return;
 
-	st = map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots = kvm_memslots(vcpu->kvm);
+
+	if (unlikely(slots->generation != ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
+		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+
+		/* We rely on the fact that it fits in a single page. */
+		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
+
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
+		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
+			return;
+	}
+
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	if (!user_access_begin(st, sizeof(*st)))
+		return;
 
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
-		u8 st_preempted = xchg(&st->preempted, 0);
+		u8 st_preempted = 0;
+		int err = -EFAULT;
+
+		asm volatile("1: xchgb %0, %2\n"
+			     "xor %1, %1\n"
+			     "2:\n"
+			     _ASM_EXTABLE_UA(1b, 2b)
+			     : "+r" (st_preempted),
+			       "+&r" (err)
+			     : "m" (st->preempted));
+		if (err)
+			goto out;
+
+		user_access_end();
+
+		vcpu->arch.st.preempted = 0;
 
 		trace_kvm_pv_tlb_flush(vcpu->vcpu_id,
 				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
+
+		if (!user_access_begin(st, sizeof(*st)))
+			goto dirty;
 	} else {
-		st->preempted = 0;
+		unsafe_put_user(0, &st->preempted, out);
+		vcpu->arch.st.preempted = 0;
 	}
 
-	vcpu->arch.st.preempted = 0;
-
-	if (st->version & 1)
-		st->version += 1;  /* first time write, random junk */
+	unsafe_get_user(version, &st->version, out);
+	if (version & 1)
+		version += 1;  /* first time write, random junk */
 
-	st->version += 1;
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
 
 	smp_wmb();
 
-	st->steal += current->sched_info.run_delay -
+	unsafe_get_user(steal, &st->steal, out);
+	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
+	unsafe_put_user(steal, &st->steal, out);
 
-	smp_wmb();
-
-	st->version += 1;
+	version += 1;
+	unsafe_put_user(version, &st->version, out);
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+ out:
+	user_access_end();
+ dirty:
+	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4351,8 +4390,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	static const u8 preempted = KVM_VCPU_PREEMPTED;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
@@ -4360,16 +4401,23 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
-			&vcpu->arch.st.cache, true))
+	/* This happens on process exit */
+	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
 
-	st = map.hva +
-		offset_in_page(vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS);
+	slots = kvm_memslots(vcpu->kvm);
+
+	if (unlikely(slots->generation != ghc->generation ||
+		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
+		return;
 
-	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+	st = (struct kvm_steal_time __user *)ghc->hva;
+	BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
+		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
+
+	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -11022,11 +11070,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
 	int idx;
 
-	kvm_release_pfn(cache->pfn, cache->dirty, cache);
-
 	kvmclock_reset(vcpu);
 
 	static_call(kvm_x86_vcpu_free)(vcpu);

