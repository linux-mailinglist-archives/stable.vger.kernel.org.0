Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB551D733
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 14:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391601AbiEFMEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 08:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391600AbiEFMEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 08:04:49 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F66E3389E
        for <stable@vger.kernel.org>; Fri,  6 May 2022 05:01:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=llfl@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCRjzp0_1651838463;
Received: from localhost(mailfrom:llfl@linux.alibaba.com fp:SMTPD_---0VCRjzp0_1651838463)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 May 2022 20:01:03 +0800
From:   "Kun(llfl)" <llfl@linux.alibaba.com>
To:     Jiangbo Wu <jiangbo.wu@intel.com>
Cc:     Xu Yu <xuyu@linux.alibaba.com>, Kun <llfl@linux.alibaba.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>
Subject: [PATCH 06/19] iommu/vt-d: Fix clearing real DMA device's scalable-mode context entries
Date:   Fri,  6 May 2022 20:00:44 +0800
Message-Id: <20220506120057.77320-6-llfl@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220506120057.77320-1-llfl@linux.alibaba.com>
References: <20220506120057.77320-1-llfl@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

ANBZ: #1105

commit 474dd1c6506411752a9b2f2233eec11f1733a099 upstream.

The commit 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
fixes an issue of "sub-device is removed where the context entry is cleared
for all aliases". But this commit didn't consider the PASID entry and PASID
table in VT-d scalable mode. This fix increases the coverage of scalable
mode.

Suggested-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Fixes: 8038bdb855331 ("iommu/vt-d: Only clear real DMA device's context entries")
Fixes: 2b0140c69637e ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Cc: stable@vger.kernel.org # v5.6+
Cc: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Kun(llfl) <llfl@linux.alibaba.com>
---
 drivers/iommu/intel/iommu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 1a0027da6dad..34e498619210 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -5126,14 +5126,13 @@ static void __dmar_remove_one_dev_info(struct device_domain_info *info)
 	iommu = info->iommu;
 	domain = info->domain;
 
-	if (info->dev) {
+	if (info->dev && !dev_is_real_dma_subdevice(info->dev)) {
 		if (dev_is_pci(info->dev) && sm_supported(iommu))
 			intel_pasid_tear_down_entry(iommu, info->dev,
 					PASID_RID2PASID, false);
 
 		iommu_disable_dev_iotlb(info);
-		if (!dev_is_real_dma_subdevice(info->dev))
-			domain_context_clear(info);
+		domain_context_clear(info);
 		intel_pasid_free_table(info->dev);
 	}
 
-- 
2.32.0 (Apple Git-132)

