Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0A16AF49C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbjCGTRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbjCGTR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072315504A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:01:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ACA361531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77136C433D2;
        Tue,  7 Mar 2023 19:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215680;
        bh=32oDUR/jzR9JiQWMc2QpmgTamnVWSOTMXys8t7u8Jgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5SWvgsz6vzgaGsj8vnMEYUSf9g+fFiHknAD4deS5u/HQfRhX9acBdFC6mWVW6/Df
         h1/ZgW6jJxJKqjnOBstWur0x0QhiBZRQDBQzAvQzBaZtFAZ9dqWR/suSBLQbiWsvqc
         orCfqwgtlrhpiqTRNHO9X5800z3JyI9K4mdMZiL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 340/567] iommu/vt-d: Use second level for GPA->HPA translation
Date:   Tue,  7 Mar 2023 18:01:16 +0100
Message-Id: <20230307165920.613550582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 032c5ee40e9fc68ed650a3f86f23259376ec93fc ]

The IOMMU VT-d implementation uses the first level for GPA->HPA translation
by default. Although both the first level and the second level could handle
the DMA translation, they're different in some way. For example, the second
level translation has separate controls for the Access/Dirty page tracking.
With the first level translation, there's no such control. On the other
hand, the second level translation has the page-level control for forcing
snoop, but the first level only has global control with pasid granularity.

This uses the second level for GPA->HPA translation so that we can provide
a consistent hardware interface for use cases like dirty page tracking for
live migration.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20210926114535.923263-1-baolu.lu@linux.intel.com
Link: https://lore.kernel.org/r/20211014053839.727419-6-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 257ec2907419 ("iommu/vt-d: Allow to use flush-queue when first level is default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 6be0fb10cb8a9..850b0590c24a5 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1917,9 +1917,18 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
  * Check and return whether first level is used by default for
  * DMA translation.
  */
-static bool first_level_by_default(void)
+static bool first_level_by_default(unsigned int type)
 {
-	return scalable_mode_support() && intel_cap_flts_sanity();
+	/* Only SL is available in legacy mode */
+	if (!scalable_mode_support())
+		return false;
+
+	/* Only level (either FL or SL) is available, just use it */
+	if (intel_cap_flts_sanity() ^ intel_cap_slts_sanity())
+		return intel_cap_flts_sanity();
+
+	/* Both levels are available, decide it based on domain type */
+	return type != IOMMU_DOMAIN_UNMANAGED;
 }
 
 static struct dmar_domain *alloc_domain(unsigned int type)
@@ -1932,7 +1941,7 @@ static struct dmar_domain *alloc_domain(unsigned int type)
 
 	memset(domain, 0, sizeof(*domain));
 	domain->nid = NUMA_NO_NODE;
-	if (first_level_by_default())
+	if (first_level_by_default(type))
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
 	INIT_LIST_HEAD(&domain->devices);
-- 
2.39.2



