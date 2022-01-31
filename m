Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509F84A43A7
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377178AbiAaLWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378697AbiAaLUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA63C0604E5;
        Mon, 31 Jan 2022 03:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B0C6114F;
        Mon, 31 Jan 2022 11:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8334DC340E8;
        Mon, 31 Jan 2022 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627596;
        bh=2XoMdHyhCWacHgDF8xxYDHMPmrEmzbHUGPWlSLAPgFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ag9AICwFUjSz1txX8z4SzFK7cJ0bk+iISZRdfidyqkvgkVcKfwe3HfXU6dlNEff4G
         59oh5OO9S/apxV7ZnhrFfLuqEjzJnkfpvBg9Gc3SUf4qflYABvrMyh14E9YpG9D3+N
         TsvHMuFnsCBoswrvvBbpc7U0oeTICSC/jnSSo9KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/171] KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance
Date:   Mon, 31 Jan 2022 11:56:07 +0100
Message-Id: <20220131105233.502358533@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 094d00f8ca58c5d29b25e23b4daaed1ff1f13b41 ]

CMOs issued from EL2 cannot directly use the kernel helpers,
as EL2 doesn't have a mapping of the guest pages. Oops.

Instead, use the mm_ops indirection to use helpers that will
perform a mapping at EL2 and allow the CMO to be effective.

Fixes: 25aa28691bb9 ("KVM: arm64: Move guest CMOs to the fault handlers")
Reviewed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220114125038.1336965-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982eb..4c77ff556f0ae 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -921,13 +921,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 */
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
-	if (need_flush) {
-		kvm_pte_t *pte_follow = kvm_pte_follow(pte, mm_ops);
-
-		dcache_clean_inval_poc((unsigned long)pte_follow,
-				    (unsigned long)pte_follow +
-					    kvm_granule_size(level));
-	}
+	if (need_flush && mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 
 	if (childp)
 		mm_ops->put_page(childp);
@@ -1089,15 +1085,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
-	kvm_pte_t *pte_follow;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
 
-	pte_follow = kvm_pte_follow(pte, mm_ops);
-	dcache_clean_inval_poc((unsigned long)pte_follow,
-			    (unsigned long)pte_follow +
-				    kvm_granule_size(level));
+	if (mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 	return 0;
 }
 
-- 
2.34.1



