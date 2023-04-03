Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5366D4923
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjDCOfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjDCOfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697B616F20
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C536B8074A
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B22BC433EF;
        Mon,  3 Apr 2023 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532499;
        bh=Pe/ab0Mk67lxo83ur4Liwhu+v3Z6539B/P+VYR4gFbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7xc6N425uc0SzVo6QwrxT6tZgxqNYYBYn2p7GzBr1fg2E85QPswuoGUtlpXq04wk
         y3KPMO3fTuDTSt7454gme6q6i2tqEtAPUsinHT4KcyxLy0jhWy1L01/HL2igORbf7i
         vR/8O8+7niB/qHUhw2KlV6BuNbCW6iSWbSBqJ774=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.15 88/99] KVM: arm64: Disable interrupts while walking userspace PTs
Date:   Mon,  3 Apr 2023 16:09:51 +0200
Message-Id: <20230403140406.686699946@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit e86fc1a3a3e9b4850fe74d738e3cfcf4297d8bba upstream.

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
Link: https://lore.kernel.org/r/20230316174546.3777507-2-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -468,14 +468,33 @@ static int get_user_mapping_size(struct
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
+	if (ret)
+		return ret;
+
+	/*
+	 * Not seeing an error, but not updating level? Something went
+	 * deeply wrong...
+	 */
+	if (WARN_ON(level >= KVM_PGTABLE_MAX_LEVELS))
+		return -EFAULT;
+
+	/* Oops, the userspace PTs are gone... Replay the fault */
+	if (!kvm_pte_valid(pte))
+		return -EAGAIN;
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
 }
@@ -826,7 +845,7 @@ static bool fault_supports_stage2_huge_m
  *
  * Returns the size of the mapping.
  */
-static unsigned long
+static long
 transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
@@ -838,8 +857,15 @@ transparent_hugepage_adjust(struct kvm *
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
@@ -957,7 +983,7 @@ static int user_mem_abort(struct kvm_vcp
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
-	unsigned long vma_pagesize, fault_granule;
+	long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 
@@ -1104,6 +1130,11 @@ static int user_mem_abort(struct kvm_vcp
 			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
 								   hva, &pfn,
 								   &fault_ipa);
+
+		if (vma_pagesize < 0) {
+			ret = vma_pagesize;
+			goto out_unlock;
+		}
 	}
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {


