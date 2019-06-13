Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274B543FE4
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733105AbfFMQBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731443AbfFMIsj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DC64206BA;
        Thu, 13 Jun 2019 08:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415718;
        bh=lCtMrz1Mq5QbCuKsABMwSIKB8Wsbk8DG8I3IpegZgsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hGUOEpKcS7o9ZwUU8Vey5+mOhleQltgz5kmFGUOkZifY6Bh2p5kSqbBr9MlFxEI+I
         JFbJSvLV6TwhP+NpZUVR4I6Zgaednxv3vJuAmubeJ1BuO0f4vRRNnwB9Ig2a26e1Hy
         eoSN/vfdrF5sqiotHDUyr6kb84GVMlpH3gOU9xO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Xu Pengfei <pengfei.xu@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 102/155] iommu/vt-d: Flush IOTLB for untrusted device in time
Date:   Thu, 13 Jun 2019 10:33:34 +0200
Message-Id: <20190613075658.741939038@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f7b0c4ce8cb3c09cb3cbfc0c663268bf99e5fa9c ]

By default, for performance consideration, Intel IOMMU
driver won't flush IOTLB immediately after a buffer is
unmapped. It schedules a thread and flushes IOTLB in a
batched mode. This isn't suitable for untrusted device
since it still can access the memory even if it isn't
supposed to do so.

Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Xu Pengfei <pengfei.xu@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index cb656f503604..0feb3f70da16 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3736,6 +3736,7 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 	unsigned long iova_pfn;
 	struct intel_iommu *iommu;
 	struct page *freelist;
+	struct pci_dev *pdev = NULL;
 
 	if (iommu_no_mapping(dev))
 		return;
@@ -3751,11 +3752,14 @@ static void intel_unmap(struct device *dev, dma_addr_t dev_addr, size_t size)
 	start_pfn = mm_to_dma_pfn(iova_pfn);
 	last_pfn = start_pfn + nrpages - 1;
 
+	if (dev_is_pci(dev))
+		pdev = to_pci_dev(dev);
+
 	dev_dbg(dev, "Device unmapping: pfn %lx-%lx\n", start_pfn, last_pfn);
 
 	freelist = domain_unmap(domain, start_pfn, last_pfn);
 
-	if (intel_iommu_strict) {
+	if (intel_iommu_strict || (pdev && pdev->untrusted)) {
 		iommu_flush_iotlb_psi(iommu, domain, start_pfn,
 				      nrpages, !freelist, 0);
 		/* free iova */
-- 
2.20.1



