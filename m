Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E0159426D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349463AbiHOVtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350335AbiHOVrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:47:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A7D606A0;
        Mon, 15 Aug 2022 12:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B996960FB9;
        Mon, 15 Aug 2022 19:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA5FC433C1;
        Mon, 15 Aug 2022 19:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591917;
        bh=YJ/dercJx3qtjQAaXxELHElcUTf1JjMCwNg9MoggzA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcwTWewouuPbhyQ5z1t5Wqp5cwREpGWdqC4Hlz9PEhUa7aMKGDz5YXVhT96A56ncU
         IVmd9vXTANKXdTAWFtaDb5N/TIlG5okSLc/4TviJCXJSbKMLmZkwB77GfgVGtQE8eP
         pwWo5fOYiZrXhJeB0FzQOiJ1QzQY0JfSStqhOdZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0030/1157] KVM: Fix multiple races in gfn=>pfn cache refresh
Date:   Mon, 15 Aug 2022 19:49:46 +0200
Message-Id: <20220815180440.639370367@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 58cd407ca4c6278cf9f9d09a2e663bf645b0c982 upstream.

Rework the gfn=>pfn cache (gpc) refresh logic to address multiple races
between the cache itself, and between the cache and mmu_notifier events.

The existing refresh code attempts to guard against races with the
mmu_notifier by speculatively marking the cache valid, and then marking
it invalid if a mmu_notifier invalidation occurs.  That handles the case
where an invalidation occurs between dropping and re-acquiring gpc->lock,
but it doesn't handle the scenario where the cache is refreshed after the
cache was invalidated by the notifier, but before the notifier elevates
mmu_notifier_count.  The gpc refresh can't use the "retry" helper as its
invalidation occurs _before_ mmu_notifier_count is elevated and before
mmu_notifier_range_start is set/updated.

  CPU0                                    CPU1
  ----                                    ----

  gfn_to_pfn_cache_invalidate_start()
  |
  -> gpc->valid = false;
                                          kvm_gfn_to_pfn_cache_refresh()
                                          |
                                          |-> gpc->valid = true;

                                          hva_to_pfn_retry()
                                          |
                                          -> acquire kvm->mmu_lock
                                             kvm->mmu_notifier_count == 0
                                             mmu_seq == kvm->mmu_notifier_seq
                                             drop kvm->mmu_lock
                                             return pfn 'X'
  acquire kvm->mmu_lock
  kvm_inc_notifier_count()
  drop kvm->mmu_lock()
  kernel frees pfn 'X'
                                          kvm_gfn_to_pfn_cache_check()
                                          |
                                          |-> gpc->valid == true

                                          caller accesses freed pfn 'X'

Key off of mn_active_invalidate_count to detect that a pfncache refresh
needs to wait for an in-progress mmu_notifier invalidation.  While
mn_active_invalidate_count is not guaranteed to be stable, it is
guaranteed to be elevated prior to an invalidation acquiring gpc->lock,
so either the refresh will see an active invalidation and wait, or the
invalidation will run after the refresh completes.

Speculatively marking the cache valid is itself flawed, as a concurrent
kvm_gfn_to_pfn_cache_check() would see a valid cache with stale pfn/khva
values.  The KVM Xen use case explicitly allows/wants multiple users;
even though the caches are allocated per vCPU, __kvm_xen_has_interrupt()
can read a different vCPU (or vCPUs).  Address this race by invalidating
the cache prior to dropping gpc->lock (this is made possible by fixing
the above mmu_notifier race).

Complicating all of this is the fact that both the hva=>pfn resolution
and mapping of the kernel address can sleep, i.e. must be done outside
of gpc->lock.

Fix the above races in one fell swoop, trying to fix each individual race
is largely pointless and essentially impossible to test, e.g. closing one
hole just shifts the focus to the other hole.

Fixes: 982ed0de4753 ("KVM: Reinstate gfn_to_pfn_cache with invalidation support")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220429210025.3293691-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |    9 ++
 virt/kvm/pfncache.c |  193 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 131 insertions(+), 71 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -724,6 +724,15 @@ static int kvm_mmu_notifier_invalidate_r
 	kvm->mn_active_invalidate_count++;
 	spin_unlock(&kvm->mn_invalidate_lock);
 
+	/*
+	 * Invalidate pfn caches _before_ invalidating the secondary MMUs, i.e.
+	 * before acquiring mmu_lock, to avoid holding mmu_lock while acquiring
+	 * each cache's lock.  There are relatively few caches in existence at
+	 * any given time, and the caches themselves can check for hva overlap,
+	 * i.e. don't need to rely on memslot overlap checks for performance.
+	 * Because this runs without holding mmu_lock, the pfn caches must use
+	 * mn_active_invalidate_count (see above) instead of mmu_notifier_count.
+	 */
 	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end,
 					  hva_range.may_block);
 
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -112,31 +112,122 @@ static void gpc_release_pfn_and_khva(str
 	}
 }
 
-static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, unsigned long uhva)
+static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
 {
+	/*
+	 * mn_active_invalidate_count acts for all intents and purposes
+	 * like mmu_notifier_count here; but the latter cannot be used
+	 * here because the invalidation of caches in the mmu_notifier
+	 * event occurs _before_ mmu_notifier_count is elevated.
+	 *
+	 * Note, it does not matter that mn_active_invalidate_count
+	 * is not protected by gpc->lock.  It is guaranteed to
+	 * be elevated before the mmu_notifier acquires gpc->lock, and
+	 * isn't dropped until after mmu_notifier_seq is updated.
+	 */
+	if (kvm->mn_active_invalidate_count)
+		return true;
+
+	/*
+	 * Ensure mn_active_invalidate_count is read before
+	 * mmu_notifier_seq.  This pairs with the smp_wmb() in
+	 * mmu_notifier_invalidate_range_end() to guarantee either the
+	 * old (non-zero) value of mn_active_invalidate_count or the
+	 * new (incremented) value of mmu_notifier_seq is observed.
+	 */
+	smp_rmb();
+	return kvm->mmu_notifier_seq != mmu_seq;
+}
+
+static kvm_pfn_t hva_to_pfn_retry(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+{
+	/* Note, the new page offset may be different than the old! */
+	void *old_khva = gpc->khva - offset_in_page(gpc->khva);
+	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
+	void *new_khva = NULL;
 	unsigned long mmu_seq;
-	kvm_pfn_t new_pfn;
-	int retry;
+
+	lockdep_assert_held(&gpc->refresh_lock);
+
+	lockdep_assert_held_write(&gpc->lock);
+
+	/*
+	 * Invalidate the cache prior to dropping gpc->lock, the gpa=>uhva
+	 * assets have already been updated and so a concurrent check() from a
+	 * different task may not fail the gpa/uhva/generation checks.
+	 */
+	gpc->valid = false;
 
 	do {
 		mmu_seq = kvm->mmu_notifier_seq;
 		smp_rmb();
 
+		write_unlock_irq(&gpc->lock);
+
+		/*
+		 * If the previous iteration "failed" due to an mmu_notifier
+		 * event, release the pfn and unmap the kernel virtual address
+		 * from the previous attempt.  Unmapping might sleep, so this
+		 * needs to be done after dropping the lock.  Opportunistically
+		 * check for resched while the lock isn't held.
+		 */
+		if (new_pfn != KVM_PFN_ERR_FAULT) {
+			/*
+			 * Keep the mapping if the previous iteration reused
+			 * the existing mapping and didn't create a new one.
+			 */
+			if (new_khva == old_khva)
+				new_khva = NULL;
+
+			gpc_release_pfn_and_khva(kvm, new_pfn, new_khva);
+
+			cond_resched();
+		}
+
 		/* We always request a writeable mapping */
-		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		new_pfn = hva_to_pfn(gpc->uhva, false, NULL, true, NULL);
 		if (is_error_noslot_pfn(new_pfn))
-			break;
+			goto out_error;
+
+		/*
+		 * Obtain a new kernel mapping if KVM itself will access the
+		 * pfn.  Note, kmap() and memremap() can both sleep, so this
+		 * too must be done outside of gpc->lock!
+		 */
+		if (gpc->usage & KVM_HOST_USES_PFN) {
+			if (new_pfn == gpc->pfn) {
+				new_khva = old_khva;
+			} else if (pfn_valid(new_pfn)) {
+				new_khva = kmap(pfn_to_page(new_pfn));
+#ifdef CONFIG_HAS_IOMEM
+			} else {
+				new_khva = memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+			}
+			if (!new_khva) {
+				kvm_release_pfn_clean(new_pfn);
+				goto out_error;
+			}
+		}
+
+		write_lock_irq(&gpc->lock);
 
-		KVM_MMU_READ_LOCK(kvm);
-		retry = mmu_notifier_retry_hva(kvm, mmu_seq, uhva);
-		KVM_MMU_READ_UNLOCK(kvm);
-		if (!retry)
-			break;
+		/*
+		 * Other tasks must wait for _this_ refresh to complete before
+		 * attempting to refresh.
+		 */
+		WARN_ON_ONCE(gpc->valid);
+	} while (mmu_notifier_retry_cache(kvm, mmu_seq));
+
+	gpc->valid = true;
+	gpc->pfn = new_pfn;
+	gpc->khva = new_khva + (gpc->gpa & ~PAGE_MASK);
+	return 0;
 
-		cond_resched();
-	} while (1);
+out_error:
+	write_lock_irq(&gpc->lock);
 
-	return new_pfn;
+	return -EFAULT;
 }
 
 int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
@@ -147,7 +238,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	kvm_pfn_t old_pfn, new_pfn;
 	unsigned long old_uhva;
 	void *old_khva;
-	bool old_valid;
 	int ret = 0;
 
 	/*
@@ -169,7 +259,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	old_pfn = gpc->pfn;
 	old_khva = gpc->khva - offset_in_page(gpc->khva);
 	old_uhva = gpc->uhva;
-	old_valid = gpc->valid;
 
 	/* If the userspace HVA is invalid, refresh that first */
 	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
@@ -182,7 +271,6 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 		gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
 
 		if (kvm_is_error_hva(gpc->uhva)) {
-			gpc->pfn = KVM_PFN_ERR_FAULT;
 			ret = -EFAULT;
 			goto out;
 		}
@@ -194,60 +282,8 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	 * If the userspace HVA changed or the PFN was already invalid,
 	 * drop the lock and do the HVA to PFN lookup again.
 	 */
-	if (!old_valid || old_uhva != gpc->uhva) {
-		unsigned long uhva = gpc->uhva;
-		void *new_khva = NULL;
-
-		/* Placeholders for "hva is valid but not yet mapped" */
-		gpc->pfn = KVM_PFN_ERR_FAULT;
-		gpc->khva = NULL;
-		gpc->valid = true;
-
-		write_unlock_irq(&gpc->lock);
-
-		new_pfn = hva_to_pfn_retry(kvm, uhva);
-		if (is_error_noslot_pfn(new_pfn)) {
-			ret = -EFAULT;
-			goto map_done;
-		}
-
-		if (gpc->usage & KVM_HOST_USES_PFN) {
-			if (new_pfn == old_pfn) {
-				/*
-				 * Reuse the existing pfn and khva, but put the
-				 * reference acquired hva_to_pfn_retry(); the
-				 * cache still holds a reference to the pfn
-				 * from the previous refresh.
-				 */
-				gpc_release_pfn_and_khva(kvm, new_pfn, NULL);
-
-				new_khva = old_khva;
-				old_pfn = KVM_PFN_ERR_FAULT;
-				old_khva = NULL;
-			} else if (pfn_valid(new_pfn)) {
-				new_khva = kmap(pfn_to_page(new_pfn));
-#ifdef CONFIG_HAS_IOMEM
-			} else {
-				new_khva = memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
-#endif
-			}
-			if (new_khva)
-				new_khva += page_offset;
-			else
-				ret = -EFAULT;
-		}
-
-	map_done:
-		write_lock_irq(&gpc->lock);
-		if (ret) {
-			gpc->valid = false;
-			gpc->pfn = KVM_PFN_ERR_FAULT;
-			gpc->khva = NULL;
-		} else {
-			/* At this point, gpc->valid may already have been cleared */
-			gpc->pfn = new_pfn;
-			gpc->khva = new_khva;
-		}
+	if (!gpc->valid || old_uhva != gpc->uhva) {
+		ret = hva_to_pfn_retry(kvm, gpc);
 	} else {
 		/* If the HVA→PFN mapping was already valid, don't unmap it. */
 		old_pfn = KVM_PFN_ERR_FAULT;
@@ -255,11 +291,26 @@ int kvm_gfn_to_pfn_cache_refresh(struct
 	}
 
  out:
+	/*
+	 * Invalidate the cache and purge the pfn/khva if the refresh failed.
+	 * Some/all of the uhva, gpa, and memslot generation info may still be
+	 * valid, leave it as is.
+	 */
+	if (ret) {
+		gpc->valid = false;
+		gpc->pfn = KVM_PFN_ERR_FAULT;
+		gpc->khva = NULL;
+	}
+
+	/* Snapshot the new pfn before dropping the lock! */
+	new_pfn = gpc->pfn;
+
 	write_unlock_irq(&gpc->lock);
 
 	mutex_unlock(&gpc->refresh_lock);
 
-	gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
+	if (old_pfn != new_pfn)
+		gpc_release_pfn_and_khva(kvm, old_pfn, old_khva);
 
 	return ret;
 }


