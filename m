Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0346ECA8FE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404303AbfJCQfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404301AbfJCQfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCBE320830;
        Thu,  3 Oct 2019 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120543;
        bh=EO7ryEqMLUz6/vAOoxJO8OwMgOIlxoB/IhAvgKSHIYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2vjDdJVzSh57+z15MPG7km+RKEk6BR+JgAz1RPEPHon1URPm+vvg3wHwrZAirb62
         LddM9ZQ84sjM0u042Vk5okga0xiyJG2OBLdkDR/HfL9EHoSrDFNYP2jG8uCmW7gP+2
         TYaeHA47scal8JFLzpy1mOlWSqPEuc2GiCN6J/pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 244/313] KVM: x86/mmu: Use fast invalidate mechanism to zap MMIO sptes
Date:   Thu,  3 Oct 2019 17:53:42 +0200
Message-Id: <20191003154557.046977117@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -389,8 +389,6 @@ static void mark_mmio_spte(struct kvm_vc
 	mask |= (gpa & shadow_nonpresent_or_rsvd_mask)
 		<< shadow_nonpresent_or_rsvd_mask_len;
 
-	page_header(__pa(sptep))->mmio_cached = true;
-
 	trace_mark_mmio_spte(sptep, gfn, access, gen);
 	mmu_spte_set(sptep, mask);
 }
@@ -5952,7 +5950,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_slot_set_dirty);
 
-static void __kvm_mmu_zap_all(struct kvm *kvm, bool mmio_only)
+void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -5961,14 +5959,10 @@ static void __kvm_mmu_zap_all(struct kvm
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
@@ -5977,11 +5971,6 @@ restart:
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
@@ -6003,7 +5992,7 @@ void kvm_mmu_invalidate_mmio_sptes(struc
 	 */
 	if (unlikely(gen == 0)) {
 		kvm_debug_ratelimited("kvm: zapping shadow pages for mmio generation wraparound\n");
-		__kvm_mmu_zap_all(kvm, true);
+		kvm_mmu_zap_all_fast(kvm);
 	}
 }
 


