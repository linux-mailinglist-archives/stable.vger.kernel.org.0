Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F319229911
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 15:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgGVNPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 09:15:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgGVNPZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jul 2020 09:15:25 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 789AD2065F;
        Wed, 22 Jul 2020 13:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595423725;
        bh=309SgFrYGECpYvDHgcro6cdfQgAxAGKwgUlh3qTsjuA=;
        h=From:To:Cc:Subject:Date:From;
        b=H/6pyqqqhPSmMeEE5/uBBZbKv3zqe9HKg+3ZBp1wkHglSljjD1nGHr9OgaQUXAc8h
         Q2XstCynrehvAXFE4B6wZBaKriNhpKPLp1h5n0rYldwxs3eMi8ERjl+7ZZJTZLBELM
         nqeNbcTzDJJD4NKvzrk33LnRr69tm9k+z2ihy5fw=
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Don't inherit exec permission across page-table levels
Date:   Wed, 22 Jul 2020 14:15:10 +0100
Message-Id: <20200722131511.14639-1-will@kernel.org>
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
Cc: Quentin Perret <qperret@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
---

Found by code inspection, rather than something actually going wrong.

 arch/arm64/kvm/mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8c0035cab6b6..69dc36d1d486 100644
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
@@ -1338,9 +1338,9 @@ static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
 		return false;
 
 	if (pudp)
-		return kvm_s2pud_exec(pudp);
+		return sz == PUD_SIZE && kvm_s2pud_exec(pudp);
 	else if (pmdp)
-		return kvm_s2pmd_exec(pmdp);
+		return sz == PMD_SIZE && kvm_s2pmd_exec(pmdp);
 	else
 		return kvm_s2pte_exec(ptep);
 }
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

