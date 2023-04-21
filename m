Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79BE6EA46C
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 09:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDUHQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 03:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDUHQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 03:16:29 -0400
Received: from out-7.mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E908B8
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 00:16:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682061384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HVwrRvTnohCVnViQT3+RQvX2trKSr77AUYMps4yPJEI=;
        b=LKExfMYn5s9dklYR3TkylzMBXxMdymdCbcdq5K76F8fs5kUamf1EXr66m2BVl+FHeoUsib
        wbf6uj/5Gg1S78aE/ARhtgkUQA4Bjv0yVBfK/6w5/XmWuQzYcYK6x3uurxEKXoNVAR1TJ8
        eKRs8s8Chby/8p3OZe6cyDoElFfL2+w=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        David Matlack <dmatlack@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Infer the PA offset from IPA in stage-2 map walker
Date:   Fri, 21 Apr 2023 07:16:05 +0000
Message-ID: <20230421071606.1603916-2-oliver.upton@linux.dev>
In-Reply-To: <20230421071606.1603916-1-oliver.upton@linux.dev>
References: <20230421071606.1603916-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Until now, the page table walker counted increments to the PA and IPA
of a walk in two separate places. While the PA is incremented as soon as
a leaf PTE is installed in stage2_map_walker_try_leaf(), the IPA is
actually bumped in the generic table walker context. Critically,
__kvm_pgtable_visit() rereads the PTE after the LEAF callback returns
to work out if a table or leaf was installed, and only bumps the IPA for
a leaf PTE.

This arrangement worked fine when we handled faults behind the write lock,
as the walker had exclusive access to the stage-2 page tables. However,
commit 1577cb5823ce ("KVM: arm64: Handle stage-2 faults in parallel")
started handling all stage-2 faults behind the read lock, opening up a
race where a walker could increment the PA but not the IPA of a walk.
Nothing good ensues, as the walker starts mapping with the incorrect
IPA -> PA relationship.

For example, assume that two vCPUs took a data abort on the same IPA.
One observes that dirty logging is disabled, and the other observed that
it is enabled:

  vCPU attempting PMD mapping		  vCPU attempting PTE mapping
  ======================================  =====================================
  /* install PMD */
  stage2_make_pte(ctx, leaf);
  data->phys += granule;
  					  /* replace PMD with a table */
  					  stage2_try_break_pte(ctx, data->mmu);
					  stage2_make_pte(ctx, table);
  /* table is observed */
  ctx.old = READ_ONCE(*ptep);
  table = kvm_pte_table(ctx.old, level);

  /*
   * map walk continues w/o incrementing
   * IPA.
   */
   __kvm_pgtable_walk(..., level + 1);

Bring an end to the whole mess by using the IPA as the single source of
truth for how far along a walk has gotten. Work out the correct PA to
map by calculating the IPA offset from the beginning of the walk and add
that to the starting physical address.

Cc: stable@vger.kernel.org
Fixes: 1577cb5823ce ("KVM: arm64: Handle stage-2 faults in parallel")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 32 ++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..dc3c072e862f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -209,6 +209,7 @@ struct kvm_pgtable_visit_ctx {
 	kvm_pte_t				old;
 	void					*arg;
 	struct kvm_pgtable_mm_ops		*mm_ops;
+	u64					start;
 	u64					addr;
 	u64					end;
 	u32					level;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..140f82300db5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -58,6 +58,7 @@
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
+	u64				start;
 	u64				addr;
 	u64				end;
 };
@@ -201,6 +202,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		.old	= READ_ONCE(*ptep),
 		.arg	= data->walker->arg,
 		.mm_ops	= mm_ops,
+		.start	= data->start,
 		.addr	= data->addr,
 		.end	= data->end,
 		.level	= level,
@@ -293,6 +295,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker)
 {
 	struct kvm_pgtable_walk_data walk_data = {
+		.start	= ALIGN_DOWN(addr, PAGE_SIZE),
 		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
@@ -794,20 +797,43 @@ static bool stage2_pte_executable(kvm_pte_t pte)
 	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
+static u64 stage2_map_walker_phys_addr(const struct kvm_pgtable_visit_ctx *ctx,
+				       const struct stage2_map_data *data)
+{
+	u64 phys = data->phys;
+
+	/*
+	 * Stage-2 walks to update ownership data are communicated to the map
+	 * walker using an invalid PA. Avoid offsetting an already invalid PA,
+	 * which could overflow and make the address valid again.
+	 */
+	if (!kvm_phys_is_valid(phys))
+		return phys;
+
+	/*
+	 * Otherwise, work out the correct PA based on how far the walk has
+	 * gotten.
+	 */
+	return phys + (ctx->addr - ctx->start);
+}
+
 static bool stage2_leaf_mapping_allowed(const struct kvm_pgtable_visit_ctx *ctx,
 					struct stage2_map_data *data)
 {
+	u64 phys = stage2_map_walker_phys_addr(ctx, data);
+
 	if (data->force_pte && (ctx->level < (KVM_PGTABLE_MAX_LEVELS - 1)))
 		return false;
 
-	return kvm_block_mapping_supported(ctx, data->phys);
+	return kvm_block_mapping_supported(ctx, phys);
 }
 
 static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				      struct stage2_map_data *data)
 {
 	kvm_pte_t new;
-	u64 granule = kvm_granule_size(ctx->level), phys = data->phys;
+	u64 phys = stage2_map_walker_phys_addr(ctx, data);
+	u64 granule = kvm_granule_size(ctx->level);
 	struct kvm_pgtable *pgt = data->mmu->pgt;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
@@ -841,8 +867,6 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 
 	stage2_make_pte(ctx, new);
 
-	if (kvm_phys_is_valid(phys))
-		data->phys += granule;
 	return 0;
 }
 
-- 
2.40.0.634.g4ca3ef3211-goog

