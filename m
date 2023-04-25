Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FF36EE1B0
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 14:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233637AbjDYMOX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 08:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjDYMOW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 08:14:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB344EF1
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 05:14:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A7CB62DB0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 12:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22164C4339C;
        Tue, 25 Apr 2023 12:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682424860;
        bh=cHsYInE/5/VtMOx1jRJroZVHEJ5p4Z38kwQmVafczdI=;
        h=From:To:Cc:Subject:Date:From;
        b=vQnJT5OfIlwg15X4GF4Lg28xNLib8xCxrp5enROuXv+LYcoU8+DXtnERaiK5LxtjO
         RvGpbQXFssaoyTbMB4ZDgmHuSkyqczogW7oCGQj8Qbe41hOsprAdOHrXRWxSVK9kDg
         6Eo2ahWBYNv01po+ffGhuvAXgaIoI68pFF0bu6D/Mkzn8gl3U/jvGziSSwwb8cFtFo
         I9Ry5tDYFxen4vYEczEmRFEIGfQqVAQa70vSWKrvATnpOMWBLtfKUO63dLL4yaTOae
         1oL4B4IAAHA37nM2vGxs3wjW2SHm/x2NU4pDHfKRCSWEktl45X0OkBD1NIZOTNsoMT
         hudtP//wd4xKA==
From:   Will Deacon <will@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kvmarm@lists.linux.dev,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>
Subject: [BACKPORT PATCH 5.15.y] KVM: arm64: Retry fault if vma_lookup() results become invalid
Date:   Tue, 25 Apr 2023 13:14:13 +0100
Message-Id: <20230425121413.8544-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

[ Upstream commit 13ec9308a85702af7c31f3638a2720863848a7f2 ]

Read mmu_invalidate_seq before dropping the mmap_lock so that KVM can
detect if the results of vma_lookup() (e.g. vma_shift) become stale
before it acquires kvm->mmu_lock. This fixes a theoretical bug where a
VMA could be changed by userspace after vma_lookup() and before KVM
reads the mmu_invalidate_seq, causing KVM to install page table entries
based on a (possibly) no-longer-valid vma_shift.

Re-order the MMU cache top-up to earlier in user_mem_abort() so that it
is not done after KVM has read mmu_invalidate_seq (i.e. so as to avoid
inducing spurious fault retries).

This bug has existed since KVM/ARM's inception. It's unlikely that any
sane userspace currently modifies VMAs in such a way as to trigger this
race. And even with directed testing I was unable to reproduce it. But a
sufficiently motivated host userspace might be able to exploit this
race.

Fixes: 94f8e6418d39 ("KVM: ARM: Handle guest faults in KVM")
Cc: stable@vger.kernel.org # 5.15 only
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230313235454.2964067-1-dmatlack@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
[will: Use FSC_PERM instead of ESR_ELx_FSC_PERM. Read 'mmu_notifier_seq'
 instead of 'mmu_invalidate_seq'. Fix up function references in comment.]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c | 47 ++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9b465cd55a8d..38a8095744a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -997,6 +997,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	if (fault_status != FSC_PERM ||
+	    (logging_active && write_fault)) {
+		ret = kvm_mmu_topup_memory_cache(memcache,
+						 kvm_mmu_cache_min_pages(kvm));
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Let's check if we will get back a huge page backed by hugetlbfs, or
 	 * get block mapping for device MMIO region.
@@ -1051,36 +1065,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fault_ipa &= ~(vma_pagesize - 1);
 
 	gfn = fault_ipa >> PAGE_SHIFT;
-	mmap_read_unlock(current->mm);
-
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(kvm));
-		if (ret)
-			return ret;
-	}
 
-	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	/*
-	 * Ensure the read of mmu_notifier_seq happens before we call
-	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
-	 * the page we just got a reference to gets unmapped before we have a
-	 * chance to grab the mmu_lock, which ensure that if the page gets
-	 * unmapped afterwards, the call to kvm_unmap_gfn will take it away
-	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
-	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
+	 * Read mmu_notifier_seq so that KVM can detect if the results of
+	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * acquiring kvm->mmu_lock.
 	 *
-	 * Besides, __gfn_to_pfn_memslot() instead of gfn_to_pfn_prot() is
-	 * used to avoid unnecessary overhead introduced to locate the memory
-	 * slot because it's always fixed even @gfn is adjusted for huge pages.
+	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
+	 * with the smp_wmb() in kvm_dec_notifier_count().
 	 */
-	smp_rmb();
+	mmu_seq = vcpu->kvm->mmu_notifier_seq;
+	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, NULL,
 				   write_fault, &writable, NULL);
-- 
2.40.0.634.g4ca3ef3211-goog

