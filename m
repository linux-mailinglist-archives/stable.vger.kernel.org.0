Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470AE4EF437
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349019AbiDAOxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350054AbiDAOrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB91E2A03F5;
        Fri,  1 Apr 2022 07:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D89C260A64;
        Fri,  1 Apr 2022 14:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D8CC3410F;
        Fri,  1 Apr 2022 14:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823793;
        bh=OvF6t2EGTm+JmxnUQZpM+QgMaTFbq/PD/YPATXWW9b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCXn53OIIfUgBs+xMvowr3Q99lNAalkUER0ag1RHgX+7DPGQ7CTs4DKIe3GBckbss
         OyY+N0MAHupe3OhidocFFxC/lALoyaZYOi0t4iSeRpr55F+ohs0kqo6gh4t0Dvfcvt
         lR/D6UcmuWF0MgJGB+R1pXFRKp+Tt4WkdncE1q5i0RN+1Fiqe2phebR1gsrpolAwrN
         LtbhvTW2dK9KG26AUdkFHpMIMOMyn7wjSwsOkYvik9wnnnX/HluSAFISgw6US8trtM
         M93rbQNZ9eTrqEIl3GXIKe2+dpFX8m4C6xWyEKmTLkB/7irLI7MGGt7zezgKFI+pT9
         nsB+Ab8BVa6AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Yunfei Wang <yf.wang@mediatek.com>,
        Miles Chen <miles.chen@mediatek.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>, joro@8bytes.org,
        will@kernel.org, matthias.bgg@gmail.com,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 080/109] iommu/iova: Improve 32-bit free space estimate
Date:   Fri,  1 Apr 2022 10:32:27 -0400
Message-Id: <20220401143256.1950537-80-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 5b61343b50590fb04a3f6be2cdc4868091757262 ]

For various reasons based on the allocator behaviour and typical
use-cases at the time, when the max32_alloc_size optimisation was
introduced it seemed reasonable to couple the reset of the tracked
size to the update of cached32_node upon freeing a relevant IOVA.
However, since subsequent optimisations focused on helping genuine
32-bit devices make best use of even more limited address spaces, it
is now a lot more likely for cached32_node to be anywhere in a "full"
32-bit address space, and as such more likely for space to become
available from IOVAs below that node being freed.

At this point, the short-cut in __cached_rbnode_delete_update() really
doesn't hold up any more, and we need to fix the logic to reliably
provide the expected behaviour. We still want cached32_node to only move
upwards, but we should reset the allocation size if *any* 32-bit space
has become available.

Reported-by: Yunfei Wang <yf.wang@mediatek.com>
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Miles Chen <miles.chen@mediatek.com>
Link: https://lore.kernel.org/r/033815732d83ca73b13c11485ac39336f15c3b40.1646318408.git.robin.murphy@arm.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iova.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iova.c b/drivers/iommu/iova.c
index 920fcc27c9a1..cae5a73ff518 100644
--- a/drivers/iommu/iova.c
+++ b/drivers/iommu/iova.c
@@ -154,10 +154,11 @@ __cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
 	cached_iova = to_iova(iovad->cached32_node);
 	if (free == cached_iova ||
 	    (free->pfn_hi < iovad->dma_32bit_pfn &&
-	     free->pfn_lo >= cached_iova->pfn_lo)) {
+	     free->pfn_lo >= cached_iova->pfn_lo))
 		iovad->cached32_node = rb_next(&free->node);
+
+	if (free->pfn_lo < iovad->dma_32bit_pfn)
 		iovad->max32_alloc_size = iovad->dma_32bit_pfn;
-	}
 
 	cached_iova = to_iova(iovad->cached_node);
 	if (free->pfn_lo >= cached_iova->pfn_lo)
-- 
2.34.1

