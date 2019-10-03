Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699A8CA7A9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406114AbfJCQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406091AbfJCQvv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:51:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84F5B20862;
        Thu,  3 Oct 2019 16:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121510;
        bh=/kmuV4wuEj92n2i95I0f1iloxkNnae/rPOTXumlWj2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sAgxSMksC6rw4YvK3T/ntxXN68+rviO7T0isZCNEhqro9NhsEfmgSA8B4lPfFGBq+
         JyBpvfiWWrOGJTLTkoSgqNzTUalxa7yUd2wFCmLZQ6i1mn0PRzst/1ScFrZZNrSb8b
         R41GWjE2ghaMTKM9V7bi2no85xLlFJ5z9CAKn9T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.3 267/344] KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
Date:   Thu,  3 Oct 2019 17:53:52 +0200
Message-Id: <20191003154606.686576364@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 92f58b5c0181596d9f1e317b49ada2e728fb76eb upstream.

Use the fast invalidate mechasim to zap MMIO sptes on a MMIO generation
wrap.  The fast invalidate flow was reintroduced to fix a livelock bug
in kvm_mmu_zap_all() that can occur if kvm_mmu_zap_all() is invoked when
the guest has live vCPUs.  I.e. using kvm_mmu_zap_all() to handle the
MMIO generation wrap is theoretically susceptible to the livelock bug.

This effectively reverts commit 4771450c345dc ("Revert "KVM: MMU: drop
kvm_mmu_zap_mmio_sptes""), i.e. restores the behavior of commit
a8eca9dcc656a ("KVM: MMU: drop kvm_mmu_zap_mmio_sptes").

Note, this actually fixes commit 571c5af06e303 ("KVM: x86/mmu:
Voluntarily reschedule as needed when zapping MMIO sptes"), but there
is no need to incrementally revert back to using fast invalidate, e.g.
doing so doesn't provide any bisection or stability benefits.

Fixes: 571c5af06e303 ("KVM: x86/mmu: Voluntarily reschedule as needed when zapping MMIO sptes")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -395,8 +395,6 @@ static void mark_mmio_spte(struct kvm_vc
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< shadow_nonpresent_or_rsvd_mask_len;
 
-	page_header(__pa(sptep))->mmio_cached = true;
-
 	trace_mark_mmio_spte(sptep, gfn, access, gen);
 	mmu_spte_set(sptep, mask);
 }
@@ -5956,7 +5954,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-static void __kvm_mmu_zap_all(struct kvm *kvm, bool mmio_only)
+void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -5965,14 +5963,10 @@ static void __kvm_mmu_zap_all(struct kvm
 	spin_lock(&kvm->mmu_lock);
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
-		if (mmio_only && !sp->mmio_cached)
-			continue;
 		if (sp->role.invalid && sp->root_count)
 			continue;
-		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign)) {
-			WARN_ON_ONCE(mmio_only);
+		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
 			goto restart;
-		}
 		if (cond_resched_lock(&kvm->mmu_lock))
 			goto restart;
 	}
@@ -5981,11 +5975,6 @@ restart:
 	spin_unlock(&kvm->mmu_lock);
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
-{
-	return __kvm_mmu_zap_all(kvm, false);
-}
-
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 {
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
@@ -6007,7 +5996,7 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 	 */
 	if (unlikely(gen == 0)) {
 		kvm_debug_ratelimited("kvm: zapping shadow pages for mmio generation wraparound\n");
-		__kvm_mmu_zap_all(kvm, true);
+		kvm_mmu_zap_all_fast(kvm);
 	}
 }
 


