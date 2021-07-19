Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC013CE1B9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243386AbhGSP11 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348137AbhGSPYg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1650B61453;
        Mon, 19 Jul 2021 16:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710543;
        bh=xm9FjY3XVxg37fznIA78jycgoQyekMVmScL3Cef6DYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1+faxDXIKYKGLBxvGvmIzYjj6xTxNw1kaZjyOVhmnB5W8c+iR8DEfcSd81yv0RPx
         qTjrZ2hZn2gKqwWN6Frcf3KKWaDHjO+30ka/Qq6tAklR7BXQ2aDae0eWKR8cmd4u4t
         Qjby1LyBthf9b17qxBmhydp4PRqa7LEeHBybxj5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.13 017/351] iommu/vt-d: Fix clearing real DMA devices scalable-mode context entries
Date:   Mon, 19 Jul 2021 16:49:23 +0200
Message-Id: <20210719144945.098646798@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

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
Link: https://lore.kernel.org/r/20210712071712.3416949-1-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4483,14 +4483,13 @@ static void __dmar_remove_one_dev_info(s
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
 


