Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB16B7245
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 10:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCMJPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 05:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCMJO4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 05:14:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916F15FFA;
        Mon, 13 Mar 2023 02:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 275AC60DCB;
        Mon, 13 Mar 2023 09:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB3AC433D2;
        Mon, 13 Mar 2023 09:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678698890;
        bh=BqX0yzkHnMslPQaCFe4e7zwG9PJqjDJ5W5zo6G/hUuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IksJToCBZZcF5+35G1xjo72x8zk0cezlMj5RXNLU3/DI5y8KqKLqaMo/rGO5ooeem
         /EfHjohzB3YiWJtc9LSSRFyAlCFxv8sS2Y9ARur4w3I7A7fP3quoInbaQerte7jE51
         VBnYHM2gwy9hT2spDMfFCYskvKKvUREtwrFif06+6Ltb6j+QGaOVxIQ2Ja9yjQqDEa
         2JTQIte/FCClkGViGSrj8LVs8i5Uyk3KgdmiVmXbjGqrhStF0uqHR23GVzNuX3E25a
         s0USrIwRmvxuOiWETA81o4yMPm9/01oFCllnxO/PdJScpCuUklPqgXbcTTAVfptDHB
         WCCnAYUJpruvQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbeGW-00HAzq-EG;
        Mon, 13 Mar 2023 09:14:48 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Disable interrupts while walking userspace PTs
Date:   Mon, 13 Mar 2023 09:14:24 +0000
Message-Id: <20230313091425.1962708-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313091425.1962708-1-maz@kernel.org>
References: <20230313091425.1962708-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ardb@kernel.org, will@kernel.org, qperret@google.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We walk the userspace PTs to discover what mapping size was
used there. However, this can race against the userspace tables
being freed, and we end-up in the weeds.

Thankfully, the mm code is being generous and will IPI us when
doing so. So let's implement our part of the bargain and disable
interrupts around the walk. This ensures that nothing terrible
happens during that time.

We still need to handle the removal of the page tables before
the walk. For that, allow get_user_mapping_size() to return an
error, and make sure this error can be propagated all the way
to the the exit handler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/mmu.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..d7b8b25942df 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -666,14 +666,23 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 				   CONFIG_PGTABLE_LEVELS),
 		.mm_ops		= &kvm_user_mm_ops,
 	};
+	unsigned long flags;
 	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
 	u32 level = ~0;
 	int ret;
 
+	/*
+	 * Disable IRQs so that we hazard against a concurrent
+	 * teardown of the userspace page tables (which relies on
+	 * IPI-ing threads).
+	 */
+	local_irq_save(flags);
 	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
-	VM_BUG_ON(ret);
-	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
-	VM_BUG_ON(!(pte & PTE_VALID));
+	local_irq_restore(flags);
+
+	/* Oops, the userspace PTs are gone... */
+	if (ret || level >= KVM_PGTABLE_MAX_LEVELS || !(pte & PTE_VALID))
+		return -EFAULT;
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
@@ -1079,7 +1088,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  *
  * Returns the size of the mapping.
  */
-static unsigned long
+static long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
@@ -1091,8 +1100,15 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
-	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
+	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+		int sz = get_user_mapping_size(kvm, hva);
+
+		if (sz < 0)
+			return sz;
+
+		if (sz < PMD_SIZE)
+			return PAGE_SIZE;
+
 		/*
 		 * The address we faulted on is backed by a transparent huge
 		 * page.  However, because we map the compound huge page and
@@ -1203,7 +1219,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
-	unsigned long vma_pagesize, fault_granule;
+	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
@@ -1350,6 +1366,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
+
+		if (vma_pagesize < 0) {
+			ret = vma_pagesize;
+			goto out_unlock;
+		}
 	}
 
 	if (fault_status != ESR_ELx_FSC_PERM && !device && kvm_has_mte(kvm)) {
-- 
2.34.1

