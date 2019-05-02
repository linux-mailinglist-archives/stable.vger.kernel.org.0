Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661F811D68
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfEBPaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:30:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbfEBPaL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:30:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E4EC20B7C;
        Thu,  2 May 2019 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811010;
        bh=7Iyaf6jf1Bvb6rz700mdG28gfVARJsxhyzrN5GnKVUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJ9k0FMuZ1FsuVzciUxxxGLMbT8XrRpaM6CRmCo+Js6K2RJ8N0uY9JAJQ60Xq0MeD
         h/6H5ll7RnQCxEtEayWbBluuY5IsCYNWyUjH1TJ9vD5PQuPP/prf2IS+4l+hpt/S8m
         4kvsa0wXVWqKucrXvnHcQNinXPoMhZFUwKgbO7Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Xiang <zhengxiang9@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 041/101] KVM: arm/arm64: Fix handling of stage2 huge mappings
Date:   Thu,  2 May 2019 17:20:43 +0200
Message-Id: <20190502143342.432628466@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3c3736cd32bf5197aed1410ae826d2d254a5b277 ]

We rely on the mmu_notifier call backs to handle the split/merge
of huge pages and thus we are guaranteed that, while creating a
block mapping, either the entire block is unmapped at stage2 or it
is missing permission.

However, we miss a case where the block mapping is split for dirty
logging case and then could later be made block mapping, if we cancel the
dirty logging. This not only creates inconsistent TLB entries for
the pages in the the block, but also leakes the table pages for
PMD level.

Handle this corner case for the huge mappings at stage2 by
unmapping the non-huge mapping for the block. This could potentially
release the upper level table. So we need to restart the table walk
once we unmap the range.

Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zheng Xiang <zhengxiang9@huawei.com>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm/include/asm/stage2_pgtable.h |  2 +
 virt/kvm/arm/mmu.c                    | 59 +++++++++++++++++++--------
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index de2089501b8b..9e11dce55e06 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -75,6 +75,8 @@ static inline bool kvm_stage2_has_pud(struct kvm *kvm)
 
 #define S2_PMD_MASK				PMD_MASK
 #define S2_PMD_SIZE				PMD_SIZE
+#define S2_PUD_MASK				PUD_MASK
+#define S2_PUD_SIZE				PUD_SIZE
 
 static inline bool kvm_stage2_has_pmd(struct kvm *kvm)
 {
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 5cc22cdaa5ba..31e22b615d99 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1060,25 +1060,43 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 {
 	pmd_t *pmd, old_pmd;
 
+retry:
 	pmd = stage2_get_pmd(kvm, cache, addr);
 	VM_BUG_ON(!pmd);
 
 	old_pmd = *pmd;
+	/*
+	 * Multiple vcpus faulting on the same PMD entry, can
+	 * lead to them sequentially updating the PMD with the
+	 * same value. Following the break-before-make
+	 * (pmd_clear() followed by tlb_flush()) process can
+	 * hinder forward progress due to refaults generated
+	 * on missing translations.
+	 *
+	 * Skip updating the page table if the entry is
+	 * unchanged.
+	 */
+	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
+		return 0;
+
 	if (pmd_present(old_pmd)) {
 		/*
-		 * Multiple vcpus faulting on the same PMD entry, can
-		 * lead to them sequentially updating the PMD with the
-		 * same value. Following the break-before-make
-		 * (pmd_clear() followed by tlb_flush()) process can
-		 * hinder forward progress due to refaults generated
-		 * on missing translations.
+		 * If we already have PTE level mapping for this block,
+		 * we must unmap it to avoid inconsistent TLB state and
+		 * leaking the table page. We could end up in this situation
+		 * if the memory slot was marked for dirty logging and was
+		 * reverted, leaving PTE level mappings for the pages accessed
+		 * during the period. So, unmap the PTE level mapping for this
+		 * block and retry, as we could have released the upper level
+		 * table in the process.
 		 *
-		 * Skip updating the page table if the entry is
-		 * unchanged.
+		 * Normal THP split/merge follows mmu_notifier callbacks and do
+		 * get handled accordingly.
 		 */
-		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
-			return 0;
-
+		if (!pmd_thp_or_huge(old_pmd)) {
+			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
+			goto retry;
+		}
 		/*
 		 * Mapping in huge pages should only happen through a
 		 * fault.  If a page is merged into a transparent huge
@@ -1090,8 +1108,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
 		 * should become splitting first, unmapped, merged,
 		 * and mapped back in on-demand.
 		 */
-		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
-
+		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
@@ -1107,6 +1124,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 {
 	pud_t *pudp, old_pud;
 
+retry:
 	pudp = stage2_get_pud(kvm, cache, addr);
 	VM_BUG_ON(!pudp);
 
@@ -1114,14 +1132,23 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
 
 	/*
 	 * A large number of vcpus faulting on the same stage 2 entry,
-	 * can lead to a refault due to the
-	 * stage2_pud_clear()/tlb_flush(). Skip updating the page
-	 * tables if there is no change.
+	 * can lead to a refault due to the stage2_pud_clear()/tlb_flush().
+	 * Skip updating the page tables if there is no change.
 	 */
 	if (pud_val(old_pud) == pud_val(*new_pudp))
 		return 0;
 
 	if (stage2_pud_present(kvm, old_pud)) {
+		/*
+		 * If we already have table level mapping for this block, unmap
+		 * the range for this block and retry.
+		 */
+		if (!stage2_pud_huge(kvm, old_pud)) {
+			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
+			goto retry;
+		}
+
+		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
 		kvm_tlb_flush_vmid_ipa(kvm, addr);
 	} else {
-- 
2.19.1



