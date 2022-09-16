Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15D25BAAAE
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiIPKQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbiIPKPh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:15:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF879ACA18;
        Fri, 16 Sep 2022 03:11:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA62962A0A;
        Fri, 16 Sep 2022 10:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F65C433C1;
        Fri, 16 Sep 2022 10:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323059;
        bh=TnIWKRMFELKsFPuwvsePRu3B7JWZtC76Ge7Co2HkiDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbDe0SUgRwuZ/cqTmay/54aGv+sJ7O/xa5/WtawQVPNDVsgeaMiIoHCFi0TINspn5
         7WSWUyix6ojHouFN6hZc9HcvLa8BKTprzvgEwiCq1c4p/b3rqR3lfFyWGHgagaVAea
         8LpysD7qUmHoslB86mHHs3KVftR70oQ8/rsZtK2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/24] iommu/vt-d: Correctly calculate sagaw value of IOMMU
Date:   Fri, 16 Sep 2022 12:08:28 +0200
Message-Id: <20220916100445.509642848@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100445.354452396@linuxfoundation.org>
References: <20220916100445.354452396@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 53fc7ad6edf210b497230ce74b61b322a202470c ]

The Intel IOMMU driver possibly selects between the first-level and the
second-level translation tables for DMA address translation. However,
the levels of page-table walks for the 4KB base page size are calculated
from the SAGAW field of the capability register, which is only valid for
the second-level page table. This causes the IOMMU driver to stop working
if the hardware (or the emulated IOMMU) advertises only first-level
translation capability and reports the SAGAW field as 0.

This solves the above problem by considering both the first level and the
second level when calculating the supported page table levels.

Fixes: b802d070a52a1 ("iommu/vt-d: Use iova over first level")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20220817023558.3253263-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 477dde39823c7..93c60712a948e 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -560,14 +560,36 @@ static inline int domain_pfn_supported(struct dmar_domain *domain,
 	return !(addr_width < BITS_PER_LONG && pfn >> addr_width);
 }
 
+/*
+ * Calculate the Supported Adjusted Guest Address Widths of an IOMMU.
+ * Refer to 11.4.2 of the VT-d spec for the encoding of each bit of
+ * the returned SAGAW.
+ */
+static unsigned long __iommu_calculate_sagaw(struct intel_iommu *iommu)
+{
+	unsigned long fl_sagaw, sl_sagaw;
+
+	fl_sagaw = BIT(2) | (cap_fl1gp_support(iommu->cap) ? BIT(3) : 0);
+	sl_sagaw = cap_sagaw(iommu->cap);
+
+	/* Second level only. */
+	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
+		return sl_sagaw;
+
+	/* First level only. */
+	if (!ecap_slts(iommu->ecap))
+		return fl_sagaw;
+
+	return fl_sagaw & sl_sagaw;
+}
+
 static int __iommu_calculate_agaw(struct intel_iommu *iommu, int max_gaw)
 {
 	unsigned long sagaw;
 	int agaw = -1;
 
-	sagaw = cap_sagaw(iommu->cap);
-	for (agaw = width_to_agaw(max_gaw);
-	     agaw >= 0; agaw--) {
+	sagaw = __iommu_calculate_sagaw(iommu);
+	for (agaw = width_to_agaw(max_gaw); agaw >= 0; agaw--) {
 		if (test_bit(agaw, &sagaw))
 			break;
 	}
-- 
2.35.1



