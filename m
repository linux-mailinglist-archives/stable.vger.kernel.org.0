Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B77822AC4A
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgGWKRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 06:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgGWKRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jul 2020 06:17:24 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CC152065F;
        Thu, 23 Jul 2020 10:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595499443;
        bh=4ztxpVxuw3J+NpHwpRVfU/Jf180Pmhs4xnxPAm51wUs=;
        h=From:To:Cc:Subject:Date:From;
        b=uNTuvWwqErBygQv3JeLNHv0IiQ3j9TdR4W3XzYel9D6a9dXijN7MY0nqEa0mh3RWh
         63LPeEuUo9nR2EYp5S17wy3E+d02+h8aIrdiDxorrsmwUu1DIrm6jvOxJolSGB8/qI
         uy0TfwnlvMz1mL3/TvzXf7eiKSwiAP5VPdd3z6EU=
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>
Subject: [PATCH v2] KVM: arm64: Don't inherit exec permission across page-table levels
Date:   Thu, 23 Jul 2020 11:17:14 +0100
Message-Id: <20200723101714.15873-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a stage-2 page-table contains an executable, read-only mapping at the
pte level (e.g. due to dirty logging being enabled), a subsequent write
fault to the same page which tries to install a larger block mapping
(e.g. due to dirty logging having been disabled) will erroneously inherit
the exec permission and consequently skip I-cache invalidation for the
rest of the block.

Ensure that exec permission is only inherited by write faults when the
new mapping is of the same size as the existing one. A subsequent
instruction abort will result in I-cache invalidation for the entire
block mapping.

Cc: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Tested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---

v2: Fix pte size check and allow inheriting to smaller granule.

 arch/arm64/kvm/mmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c0035cab6b6..31058e6e7c2a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1326,7 +1326,7 @@ static bool stage2_get_leaf_entry(struct kvm *kvm, phys_addr_t addr,
 	return true;
 }
 
-static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
 {
 	pud_t *pudp;
 	pmd_t *pmdp;
@@ -1338,11 +1338,11 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return false;
 
 	if (pudp)
-		return kvm_s2pud_exec(pudp);
+		return sz <= PUD_SIZE && kvm_s2pud_exec(pudp);
 	else if (pmdp)
-		return kvm_s2pmd_exec(pmdp);
+		return sz <= PMD_SIZE && kvm_s2pmd_exec(pmdp);
 	else
-		return kvm_s2pte_exec(ptep);
+		return sz == PAGE_SIZE && kvm_s2pte_exec(ptep);
 }
 
 static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
@@ -1958,7 +1958,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * execute permissions, and we preserve whatever we have.
 	 */
 	needs_exec = exec_fault ||
-		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
+		(fault_status == FSC_PERM &&
+		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
 
 	if (vma_pagesize == PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
-- 
2.28.0.rc0.105.gf9edc3c819-goog

