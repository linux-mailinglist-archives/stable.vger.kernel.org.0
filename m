Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB256D3F8D
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjDCIzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbjDCIzm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:55:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E32E172B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA295B815DD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D38C433D2;
        Mon,  3 Apr 2023 08:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680512137;
        bh=W209uo0Qa0KtdZUPVZkVdxxLJDmbEKBh1j/HvA5Mrjs=;
        h=Subject:To:Cc:From:Date:From;
        b=RGsaVlnCa5Kul9lHQZ2f+3mxwnb7fBFY3rvncnN1Q81Ndrdco3bq56xlKO2xs4kuf
         Hm/UpA7dsAWntigoRF3pPs/iSvuaC5nxBFW2zNtJyrbrDQrhmwmR9zdtV91WJZxLdV
         JuPH5W9xbpmSALOrmRTMamIj+kvz7BVpXZdlhBbY=
Subject: FAILED: patch "[PATCH] KVM: arm64: Retry fault if vma_lookup() results become" failed to apply to 5.4-stable tree
To:     dmatlack@google.com, maz@kernel.org, oliver.upton@linux.dev,
        seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:55:29 +0200
Message-ID: <2023040329-elongated-decal-968b@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.4.y
git checkout FETCH_HEAD
git cherry-pick -x 13ec9308a85702af7c31f3638a2720863848a7f2
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040329-elongated-decal-968b@gregkh' --subject-prefix 'PATCH 5.4.y' HEAD^..

Possible dependencies:

13ec9308a857 ("KVM: arm64: Retry fault if vma_lookup() results become invalid")
b0803ba72b55 ("KVM: arm64: Convert FSC_* over to ESR_ELx_FSC_*")
382b5b87a97d ("Merge branch kvm-arm64/mte-map-shared into kvmarm-master/next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 13ec9308a85702af7c31f3638a2720863848a7f2 Mon Sep 17 00:00:00 2001
From: David Matlack <dmatlack@google.com>
Date: Mon, 13 Mar 2023 16:54:54 -0700
Subject: [PATCH] KVM: arm64: Retry fault if vma_lookup() results become
 invalid

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
Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230313235454.2964067-1-dmatlack@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..f54408355d1d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1217,6 +1217,20 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	if (fault_status != ESR_ELx_FSC_PERM ||
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
@@ -1269,37 +1283,17 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
-	if (fault_status != ESR_ELx_FSC_PERM ||
-	    (logging_active && write_fault)) {
-		ret = kvm_mmu_topup_memory_cache(memcache,
-						 kvm_mmu_cache_min_pages(kvm));
-		if (ret)
-			return ret;
-	}
 
-	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
 	/*
-	 * Ensure the read of mmu_invalidate_seq happens before we call
-	 * gfn_to_pfn_prot (which calls get_user_pages), so that we don't risk
-	 * the page we just got a reference to gets unmapped before we have a
-	 * chance to grab the mmu_lock, which ensure that if the page gets
-	 * unmapped afterwards, the call to kvm_unmap_gfn will take it away
-	 * from us again properly. This smp_rmb() interacts with the smp_wmb()
-	 * in kvm_mmu_notifier_invalidate_<page|range_end>.
+	 * Read mmu_invalidate_seq so that KVM can detect if the results of
+	 * vma_lookup() or __gfn_to_pfn_memslot() become stale prior to
+	 * acquiring kvm->mmu_lock.
 	 *
-	 * Besides, __gfn_to_pfn_memslot() instead of gfn_to_pfn_prot() is
-	 * used to avoid unnecessary overhead introduced to locate the memory
-	 * slot because it's always fixed even @gfn is adjusted for huge pages.
+	 * Rely on mmap_read_unlock() for an implicit smp_rmb(), which pairs
+	 * with the smp_wmb() in kvm_mmu_invalidate_end().
 	 */
-	smp_rmb();
+	mmu_seq = vcpu->kvm->mmu_invalidate_seq;
+	mmap_read_unlock(current->mm);
 
 	pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
 				   write_fault, &writable, NULL);

