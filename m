Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143E09E083
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730668AbfH0IEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbfH0IEf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A85762173E;
        Tue, 27 Aug 2019 08:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893075;
        bh=OQkgxgGTLnCbPxSscnSx2iY9DtJqNtDtwWWvXJBBKe0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pReHA8dUA8MrKB3Ubv07v6VV1m9rqaaI55hSp26OAQQZycBqIGyHthmn4H1yOmu2c
         1nHhSSMYnYC5t3h4loULHVL9sNHyP7gf+5zfd9f0l9xen9nIHgtk1N0vM5vkVkQCfK
         UbpiHuXu/ow1DuY0GTCXa0KAF0Ca4n3Nz3Kdsqh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alex Willamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 113/162] Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"
Date:   Tue, 27 Aug 2019 09:50:41 +0200
Message-Id: <20190827072742.324569389@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit d012a06ab1d23178fc6856d8d2161fbcc4dd8ebd upstream.

This reverts commit 4e103134b862314dc2f2f18f2fb0ab972adc3f5f.
Alex Williamson reported regressions with device assignment with
this patch.  Even though the bug is probably elsewhere and still
latent, this is needed to fix the regression.

Fixes: 4e103134b862 ("KVM: x86/mmu: Zap only the relevant pages when removing a memslot", 2019-02-05)
Reported-by: Alex Willamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |   33 +--------------------------------
 1 file changed, 1 insertion(+), 32 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5649,38 +5649,7 @@ static void kvm_mmu_invalidate_zap_pages
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


