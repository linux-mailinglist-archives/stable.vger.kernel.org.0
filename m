Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C985FF65F
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 00:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiJNW1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 18:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJNW07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 18:26:59 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ED611B2D0
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 15:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665786419; x=1697322419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XDKD/usTEB8kliM9fbr4NT72/kjDAAoSpZ7Dkj845TI=;
  b=h+pntKLqJplI/A6NUX2U3bCBp1pU0lP+5rQgSxw4oORBCP0CuN79BAkF
   N6Tb8lWIT1MWeI92bSk/0MN6XpUTZrl0Eq5ENS4YaVn0HC2TTLxvKrAv5
   t9nNfh2L5fNP2zzURnWypjitki/DHZaNQ0ok2RSp2RD7CoXyoEGNS3t2/
   I=;
X-IronPort-AV: E=Sophos;i="5.95,185,1661817600"; 
   d="scan'208";a="140478737"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 22:26:58 +0000
Received: from EX13MTAUEE001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-7a21ed79.us-east-1.amazon.com (Postfix) with ESMTPS id 1C8BC2223AD;
        Fri, 14 Oct 2022 22:26:55 +0000 (UTC)
Received: from EX19D028UEC002.ant.amazon.com (10.252.137.139) by
 EX13MTAUEE001.ant.amazon.com (10.43.62.226) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 14 Oct 2022 22:26:55 +0000
Received: from EX13MTAUEB002.ant.amazon.com (10.43.60.12) by
 EX19D028UEC002.ant.amazon.com (10.252.137.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.15; Fri, 14 Oct 2022 22:26:55 +0000
Received: from dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com
 (10.189.73.169) by mail-relay.amazon.com (10.43.60.234) with Microsoft SMTP
 Server id 15.0.1497.42 via Frontend Transport; Fri, 14 Oct 2022 22:26:55
 +0000
Received: by dev-dsk-risbhat-2b-8bdc64cd.us-west-2.amazon.com (Postfix, from userid 22673075)
        id 13F0F28E4; Fri, 14 Oct 2022 22:26:54 +0000 (UTC)
From:   Rishabh Bhatnagar <risbhat@amazon.com>
To:     <surajjs@amazon.com>, <luizcap@amazon.com>, <aams@amazon.de>
CC:     <mbacco@amazon.com>, David Woodhouse <dwmw2@infradead.org>,
        <stable@vger.kernel.org>, David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 2/9] KVM: x86: Fix recording of guest steal time / preempted status
Date:   Fri, 14 Oct 2022 22:26:36 +0000
Message-ID: <20221014222643.25815-4-risbhat@amazon.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221014222643.25815-1-risbhat@amazon.com>
References: <20221014222643.25815-1-risbhat@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

commit 7e2175ebd695f17860c5bd4ad7616cce12ed4591 upstream.

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
[risbhat@amazon.com: Use the older mark_page_dirty_in_slot api without
kvm argument]
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/x86.c              | 105 +++++++++++++++++++++++---------
 2 files changed, 76 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 38c63a78aba6..2b35f8139f15 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -663,7 +663,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_pfn_cache cache;
+		struct gfn_to_hva_cache cache;
 	} st;
 
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3640b298c42e..cd1e6710bc33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3013,53 +3013,92 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct kvm_host_map map;
-	struct kvm_steal_time *st;
+	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
+	struct kvm_steal_time __user *st;
+	struct kvm_memslots *slots;
+	u64 steal;
+	u32 version;
 
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
+	mark_page_dirty_in_slot(ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4044,8 +4083,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
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
@@ -4053,16 +4094,23 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
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
+	mark_page_dirty_in_slot(ghc->memslot, gpa_to_gfn(ghc->gpa));
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -10145,11 +10193,8 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_pfn_cache *cache = &vcpu->arch.st.cache;
 	int idx;
 
-	kvm_release_pfn(cache->pfn, cache->dirty, cache);
-
 	kvmclock_reset(vcpu);
 
 	kvm_x86_ops.vcpu_free(vcpu);
-- 
2.37.1

