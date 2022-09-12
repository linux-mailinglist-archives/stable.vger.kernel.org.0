Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB7245B5C51
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 16:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiILOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 10:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiILOgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 10:36:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D822F019
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 07:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3749CB80D4F
        for <stable@vger.kernel.org>; Mon, 12 Sep 2022 14:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908D8C433C1;
        Mon, 12 Sep 2022 14:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662993358;
        bh=z7nJcVVXKqOlirxsE4g3Al6Xy/7/qGDlbmIm5TVu3Jk=;
        h=Subject:To:Cc:From:Date:From;
        b=LXE96vDhtDn0ggZUvb1FDSEEp+b+snAfcWsCPFdK1c5WR1/LBGfQLFpMQFKaO7Icb
         SIXGZgSKSwVrq54NMt9/PkZssB8xPZu9ez1dQGU2bkwcsKGPxMiSjJoE/45XSe3lOr
         0oyD1fJUfqjUG/riQri/NOR31HNy8E8o06lU35tU=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Correctly calculate sagaw value of IOMMU" failed to apply to 5.10-stable tree
To:     baolu.lu@linux.intel.com, jroedel@suse.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 12 Sep 2022 16:36:21 +0200
Message-ID: <16629933814240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

53fc7ad6edf2 ("iommu/vt-d: Correctly calculate sagaw value of IOMMU")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 53fc7ad6edf210b497230ce74b61b322a202470c Mon Sep 17 00:00:00 2001
From: Lu Baolu <baolu.lu@linux.intel.com>
Date: Tue, 23 Aug 2022 14:15:55 +0800
Subject: [PATCH] iommu/vt-d: Correctly calculate sagaw value of IOMMU

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

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index b9d058c27568..b155c7af7d15 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -390,14 +390,36 @@ static inline int domain_pfn_supported(struct dmar_domain *domain,
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
 	int agaw;
 
-	sagaw = cap_sagaw(iommu->cap);
-	for (agaw = width_to_agaw(max_gaw);
-	     agaw >= 0; agaw--) {
+	sagaw = __iommu_calculate_sagaw(iommu);
+	for (agaw = width_to_agaw(max_gaw); agaw >= 0; agaw--) {
 		if (test_bit(agaw, &sagaw))
 			break;
 	}

