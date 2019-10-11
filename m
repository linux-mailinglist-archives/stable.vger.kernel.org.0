Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9DB5D4665
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 19:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfJKRPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 13:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbfJKRPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 13:15:36 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B075A11A24;
        Fri, 11 Oct 2019 17:15:36 +0000 (UTC)
Received: from donizetti.redhat.com (unknown [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE6505D6C8;
        Fri, 11 Oct 2019 17:15:32 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     cinco-list@redhat.com
Cc:     Alex Willamson <alex.williamson@redhat.com>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [EMBARGOED RHEL8.1 PATCH v5 02/14] Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
Date:   Fri, 11 Oct 2019 19:15:14 +0200
Message-Id: <20191011171526.365-3-pbonzini@redhat.com>
In-Reply-To: <20191011171526.365-1-pbonzini@redhat.com>
References: <20191011171526.365-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Fri, 11 Oct 2019 17:15:36 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 4e103134b862314dc2f2f18f2fb0ab972adc3f5f.
Alex Williamson reported regressions with device assignment with
this patch.  Even though the bug is probably elsewhere and still
latent, this is needed to fix the regression.

Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
Reported-by: Alex Willamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit d012a06ab1d23178fc6856d8d2161fbcc4dd8ebd)
---
 arch/x86/kvm/mmu.c | 33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 55dcdd312017..d3ec7d3c0ed3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5641,38 +5641,7 @@ static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	struct kvm_mmu_page *sp;
-	LIST_HEAD(invalid_list);
-	unsigned long i;
-	bool flush;
-	gfn_t gfn;
-
-	spin_lock(&kvm->mmu_lock);
-
-	if (list_empty(&kvm->arch.active_mmu_pages))
-		goto out_unlock;
-
-	flush = slot_handle_all_level(kvm, slot, kvm_zap_rmapp, false);
-
-	for (i = 0; i < slot->npages; i++) {
-		gfn = slot->base_gfn + i;
-
-		for_each_valid_sp(kvm, sp, gfn) {
-			if (sp->gfn != gfn)
-				continue;
-
-			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
-		}
-		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-			flush = false;
-			cond_resched_lock(&kvm->mmu_lock);
-		}
-	}
-	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
-
-out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	kvm_mmu_zap_all(kvm);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.21.0


