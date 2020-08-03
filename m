Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A193923A4CB
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgHCMaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729035AbgHCMaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EB1E2054F;
        Mon,  3 Aug 2020 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457821;
        bh=/MYNAPYE/vhRm3KQ1iV5bwTlt3kOQSZhVZGSqqU20N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYMw0hZ14OGloNhm5KzJyEcGilI16KiDPVrndiHZqc2qPnrDR1PC71lWEIJYu2Sh6
         NklH4yuRGX60ftLEWrv3zAYdNjLj3MZCp9RtYK4X2ilZ5sG08HVXKoSHAu1sBqEmvP
         rfO/8hRKyn54Lpc4SSZd8j+VZeruxLxJ9F+QVPkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will Deacon <will@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH 5.4 85/90] KVM: arm64: Dont inherit exec permission across page-table levels
Date:   Mon,  3 Aug 2020 14:19:47 +0200
Message-Id: <20200803121901.710117656@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit b757b47a2fcba584d4a32fd7ee68faca510ab96f upstream.

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

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Tested-by: Quentin Perret <qperret@google.com>
Reviewed-by: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200723101714.15873-1-will@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/arm/mmu.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1199,7 +1199,7 @@ static bool stage2_get_leaf_entry(struct
 	return true;
 }
 
-static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
+static bool stage2_is_exec(struct kvm *kvm, phys_addr_t addr, unsigned long sz)
 {
 	pud_t *pudp;
 	pmd_t *pmdp;
@@ -1211,11 +1211,11 @@ static bool stage2_is_exec(struct kvm *k
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
@@ -1805,7 +1805,8 @@ static int user_mem_abort(struct kvm_vcp
 	 * execute permissions, and we preserve whatever we have.
 	 */
 	needs_exec = exec_fault ||
-		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
+		(fault_status == FSC_PERM &&
+		 stage2_is_exec(kvm, fault_ipa, vma_pagesize));
 
 	if (vma_pagesize == PUD_SIZE) {
 		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);


