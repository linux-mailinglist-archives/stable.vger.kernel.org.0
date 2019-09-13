Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DFEB2008
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389423AbfIMNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:13:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388309AbfIMNN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:13:59 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9175120CC7;
        Fri, 13 Sep 2019 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380438;
        bh=KmeSFAnkxuACv75RkUKZMaeouCltjKXcCuUZlpk6AKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYfOaKA47GZtL6ZcE5h1h4uQtEODoThlOqdnAytjwqpsSU/IeCHsu6oKSDQ5UoQzb
         Z6dhbidSKOQyWzzyK3KqtAfn0/JCST6zuVEYsLt78MRHsreYX8amfXzTdEmdyw7hG4
         Xz6Y8FEmzvrOe8ooXenk4vsGfDgznYMcfeDmaMzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/190] KVM: PPC: Book3S HV: Fix race between kvm_unmap_hva_range and MMU mode switch
Date:   Fri, 13 Sep 2019 14:05:19 +0100
Message-Id: <20190913130604.871833303@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 234ff0b729ad882d20f7996591a964965647addf ]

Testing has revealed an occasional crash which appears to be caused
by a race between kvmppc_switch_mmu_to_hpt and kvm_unmap_hva_range_hv.
The symptom is a NULL pointer dereference in __find_linux_pte() called
from kvm_unmap_radix() with kvm->arch.pgtable == NULL.

Looking at kvmppc_switch_mmu_to_hpt(), it does indeed clear
kvm->arch.pgtable (via kvmppc_free_radix()) before setting
kvm->arch.radix to NULL, and there is nothing to prevent
kvm_unmap_hva_range_hv() or the other MMU callback functions from
being called concurrently with kvmppc_switch_mmu_to_hpt() or
kvmppc_switch_mmu_to_radix().

This patch therefore adds calls to spin_lock/unlock on the kvm->mmu_lock
around the assignments to kvm->arch.radix, and makes sure that the
partition-scoped radix tree or HPT is only freed after changing
kvm->arch.radix.

This also takes the kvm->mmu_lock in kvmppc_rmap_reset() to make sure
that the clearing of each rmap array (one per memslot) doesn't happen
concurrently with use of the array in the kvm_unmap_hva_range_hv()
or the other MMU callbacks.

Fixes: 18c3640cefc7 ("KVM: PPC: Book3S HV: Add infrastructure for running HPT guests on radix host")
Cc: stable@vger.kernel.org # v4.15+
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c |  3 +++
 arch/powerpc/kvm/book3s_hv.c        | 15 +++++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 68e14afecac85..a488c105b9234 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -744,12 +744,15 @@ void kvmppc_rmap_reset(struct kvm *kvm)
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, slots) {
+		/* Mutual exclusion with kvm_unmap_hva_range etc. */
+		spin_lock(&kvm->mmu_lock);
 		/*
 		 * This assumes it is acceptable to lose reference and
 		 * change bits across a reset.
 		 */
 		memset(memslot->arch.rmap, 0,
 		       memslot->npages * sizeof(*memslot->arch.rmap));
+		spin_unlock(&kvm->mmu_lock);
 	}
 	srcu_read_unlock(&kvm->srcu, srcu_idx);
 }
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 083dcedba11ce..9595db30e6b87 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3813,12 +3813,15 @@ static int kvmppc_hv_setup_htab_rma(struct kvm_vcpu *vcpu)
 /* Must be called with kvm->lock held and mmu_ready = 0 and no vcpus running */
 int kvmppc_switch_mmu_to_hpt(struct kvm *kvm)
 {
+	kvmppc_rmap_reset(kvm);
+	kvm->arch.process_table = 0;
+	/* Mutual exclusion with kvm_unmap_hva_range etc. */
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.radix = 0;
+	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_radix(kvm);
 	kvmppc_update_lpcr(kvm, LPCR_VPM1,
 			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
-	kvmppc_rmap_reset(kvm);
-	kvm->arch.radix = 0;
-	kvm->arch.process_table = 0;
 	return 0;
 }
 
@@ -3831,10 +3834,14 @@ int kvmppc_switch_mmu_to_radix(struct kvm *kvm)
 	if (err)
 		return err;
 
+	kvmppc_rmap_reset(kvm);
+	/* Mutual exclusion with kvm_unmap_hva_range etc. */
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.radix = 1;
+	spin_unlock(&kvm->mmu_lock);
 	kvmppc_free_hpt(&kvm->arch.hpt);
 	kvmppc_update_lpcr(kvm, LPCR_UPRT | LPCR_GTSE | LPCR_HR,
 			   LPCR_VPM1 | LPCR_UPRT | LPCR_GTSE | LPCR_HR);
-	kvm->arch.radix = 1;
 	return 0;
 }
 
-- 
2.20.1



