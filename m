Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A53CD0E3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 11:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhGSIvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 04:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234946AbhGSIvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 04:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C636108B;
        Mon, 19 Jul 2021 09:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626687102;
        bh=ZNxmlvdUb8fBOwWkgSaL7im8ZMjduGzaxeThsjxnZms=;
        h=Subject:To:Cc:From:Date:From;
        b=Ox3qT60i9WsXKFAkH+NwhVfTXTTvnLOWvsxqTNe2ky7f2P0uxcGCxRpiqmfohcqRt
         sE+kc1uH1IDG5WWVRYHnPdejKDACqmsbeJbm6c4S3hr/rxTYEjHt4gqXvyz3tTHA/S
         FhnNXHol1hupvAbS32SBe6wSAXWZh1cx1fUSuLa8=
Subject: FAILED: patch "[PATCH] iommu/vt-d: Fix clearing real DMA device's scalable-mode" failed to apply to 5.10-stable tree
To:     baolu.lu@linux.intel.com, jonathan.derrick@intel.com,
        jroedel@suse.de, sanjay.k.kumar@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 19 Jul 2021 11:31:40 +0200
Message-ID: <162668710010045@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 474dd1c6506411752a9b2f2233eec11f1733a099 Mon Sep 17 00:00:00 2001
From: Lu Baolu <baolu.lu@linux.intel.com>
Date: Mon, 12 Jul 2021 15:17:12 +0800
Subject: [PATCH] iommu/vt-d: Fix clearing real DMA device's scalable-mode
 context entries

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
Link: https://lore.kernel.org/r/20210712071712.3416949-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 57270290d62b..dd22fc7d5176 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4472,14 +4472,13 @@ static void __dmar_remove_one_dev_info(struct device_domain_info *info)
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
 

