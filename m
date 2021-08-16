Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C333ED69B
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbhHPNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240954AbhHPNUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 099CD6330A;
        Mon, 16 Aug 2021 13:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119747;
        bh=rC7r7jOUzgLlGrdiyVQYDGNnNrSd60k/QMwxZsfHFdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMk7fVbAR2Aox846Vs0GKn1lEOJiImyf+k+Oy/jzfehS1wBXN1mMFQGyPfVKHKHRX
         KSIXxB8Qt9HRz0MhF1iKoJfscmV84IygQngbtPlFkOVnvXZA8/+V9Z44PlPGuDiY3L
         /xlHczTDAxfeR8vVPVSrP+Q3vPubqWf7cNmz5A80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 147/151] KVM: x86/mmu: Protect marking SPs unsync when using TDP MMU with spinlock
Date:   Mon, 16 Aug 2021 15:02:57 +0200
Message-Id: <20210816125448.920349481@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit ce25681d59ffc4303321e555a2d71b1946af07da upstream.

Add yet another spinlock for the TDP MMU and take it when marking indirect
shadow pages unsync.  When using the TDP MMU and L1 is running L2(s) with
nested TDP, KVM may encounter shadow pages for the TDP entries managed by
L1 (controlling L2) when handling a TDP MMU page fault.  The unsync logic
is not thread safe, e.g. the kvm_mmu_page fields are not atomic, and
misbehaves when a shadow page is marked unsync via a TDP MMU page fault,
which runs with mmu_lock held for read, not write.

Lack of a critical section manifests most visibly as an underflow of
unsync_children in clear_unsync_child_bit() due to unsync_children being
corrupted when multiple CPUs write it without a critical section and
without atomic operations.  But underflow is the best case scenario.  The
worst case scenario is that unsync_children prematurely hits '0' and
leads to guest memory corruption due to KVM neglecting to properly sync
shadow pages.

Use an entirely new spinlock even though piggybacking tdp_mmu_pages_lock
would functionally be ok.  Usurping the lock could degrade performance when
building upper level page tables on different vCPUs, especially since the
unsync flow could hold the lock for a comparatively long time depending on
the number of indirect shadow pages and the depth of the paging tree.

For simplicity, take the lock for all MMUs, even though KVM could fairly
easily know that mmu_lock is held for write.  If mmu_lock is held for
write, there cannot be contention for the inner spinlock, and marking
shadow pages unsync across multiple vCPUs will be slow enough that
bouncing the kvm_arch cacheline should be in the noise.

Note, even though L2 could theoretically be given access to its own EPT
entries, a nested MMU must hold mmu_lock for write and thus cannot race
against a TDP MMU page fault.  I.e. the additional spinlock only _needs_ to
be taken by the TDP MMU, as opposed to being taken by any MMU for a VM
that is running with the TDP MMU enabled.  Holding mmu_lock for read also
prevents the indirect shadow page from being freed.  But as above, keep
it simple and always take the lock.

Alternative #1, the TDP MMU could simply pass "false" for can_unsync and
effectively disable unsync behavior for nested TDP.  Write protecting leaf
shadow pages is unlikely to noticeably impact traditional L1 VMMs, as such
VMMs typically don't modify TDP entries, but the same may not hold true for
non-standard use cases and/or VMMs that are migrating physical pages (from
L1's perspective).

Alternative #2, the unsync logic could be made thread safe.  In theory,
simply converting all relevant kvm_mmu_page fields to atomics and using
atomic bitops for the bitmap would suffice.  However, (a) an in-depth audit
would be required, (b) the code churn would be substantial, and (c) legacy
shadow paging would incur additional atomic operations in performance
sensitive paths for no benefit (to legacy shadow paging).

Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210812181815.3378104-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/locking.rst |    8 ++++----
 arch/x86/include/asm/kvm_host.h    |    7 +++++++
 arch/x86/kvm/mmu/mmu.c             |   28 ++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 4 deletions(-)

--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -20,10 +20,10 @@ On x86:
 
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
 
-- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
-  taken inside kvm->arch.mmu_lock, and cannot be taken without already
-  holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
-  there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
+- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
+  kvm->arch.mmu_unsync_pages_lock are taken inside kvm->arch.mmu_lock, and
+  cannot be taken without already holding kvm->arch.mmu_lock (typically with
+  ``read_lock`` for the TDP MMU, thus the need for additional spinlocks).
 
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -987,6 +987,13 @@ struct kvm_arch {
 	struct list_head lpage_disallowed_mmu_pages;
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
+	/*
+	 * Protects marking pages unsync during page faults, as TDP MMU page
+	 * faults only take mmu_lock for read.  For simplicity, the unsync
+	 * pages lock is always taken when marking pages unsync regardless of
+	 * whether mmu_lock is held for read or write.
+	 */
+	spinlock_t mmu_unsync_pages_lock;
 
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2454,6 +2454,7 @@ bool mmu_need_write_protect(struct kvm_v
 			    bool can_unsync)
 {
 	struct kvm_mmu_page *sp;
+	bool locked = false;
 
 	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
@@ -2465,9 +2466,34 @@ bool mmu_need_write_protect(struct kvm_v
 		if (sp->unsync)
 			continue;
 
+		/*
+		 * TDP MMU page faults require an additional spinlock as they
+		 * run with mmu_lock held for read, not write, and the unsync
+		 * logic is not thread safe.  Take the spinklock regardless of
+		 * the MMU type to avoid extra conditionals/parameters, there's
+		 * no meaningful penalty if mmu_lock is held for write.
+		 */
+		if (!locked) {
+			locked = true;
+			spin_lock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
+
+			/*
+			 * Recheck after taking the spinlock, a different vCPU
+			 * may have since marked the page unsync.  A false
+			 * positive on the unprotected check above is not
+			 * possible as clearing sp->unsync _must_ hold mmu_lock
+			 * for write, i.e. unsync cannot transition from 0->1
+			 * while this CPU holds mmu_lock for read (or write).
+			 */
+			if (READ_ONCE(sp->unsync))
+				continue;
+		}
+
 		WARN_ON(sp->role.level != PG_LEVEL_4K);
 		kvm_unsync_page(vcpu, sp);
 	}
+	if (locked)
+		spin_unlock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
 
 	/*
 	 * We need to ensure that the marking of unsync pages is visible
@@ -5514,6 +5540,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
+	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
+
 	kvm_mmu_init_tdp_mmu(kvm);
 
 	node->track_write = kvm_mmu_pte_write;


