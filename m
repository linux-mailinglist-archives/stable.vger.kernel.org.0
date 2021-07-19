Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE33CE44F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhGSPnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347561AbhGSPjc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A2761375;
        Mon, 19 Jul 2021 16:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711551;
        bh=HGzPH/kZU3EuHBtmCNthJWOisw7LLQrFiy75ALmkrAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CbPe4WAwIWsYJQO0ajbKh5uaAXrMA2peuZq392uqC/BIVXs8l99YnT6Qx26owkrw
         aLDcrlkmaiivrrfpS4Q7TkjHmKLZ8uWv64UTohFpaoe0G0kpmqzYMXsQhCf0WuirbQ
         DqdwqyE7lvx+B2ZgF3Gi6S/1z7GXrhJC2k1iaKXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.12 012/292] iommu/vt-d: Fix clearing real DMA devices scalable-mode context entries
Date:   Mon, 19 Jul 2021 16:51:14 +0200
Message-Id: <20210719144942.935102034@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
@@ -4503,14 +4503,13 @@ static void __dmar_remove_one_dev_info(s
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
 


