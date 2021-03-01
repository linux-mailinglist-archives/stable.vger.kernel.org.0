Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE532900C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237820AbhCAUCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:02:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242115AbhCATux (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:50:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19344650E7;
        Mon,  1 Mar 2021 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621131;
        bh=MiiD1MWL6PY8LnU14twFLfstDbHagKFXtuDW7Ow3N7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QDZRqgUkCVQro2OTDNd/J55GeIrH6HcTl6W6+ibEn8yP7z/okTI6JsskUo0USWWV
         T6C4DWNTT95+WgQWRJAMNHX/WN38se/G0jW49MxDzFwcpyxm5n1RmCuR7jTGzf4Ddr
         Vxe9zumOB1m1DNxCzrkqBeAMNz5evBofNr3gdbdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Wu <yong.wu@mediatek.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 405/775] iommu: Move iotlb_sync_map out from __iommu_map
Date:   Mon,  1 Mar 2021 17:09:33 +0100
Message-Id: <20210301161221.600588163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit d8c1df02ac7f2c802a9b2afc0f5c888c4217f1d5 ]

In the end of __iommu_map, It alway call iotlb_sync_map.

This patch moves iotlb_sync_map out from __iommu_map since it is
unnecessary to call this for each sg segment especially iotlb_sync_map
is flush tlb all currently. Add a little helper _iommu_map for this.

Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20210107122909.16317-2-yong.wu@mediatek.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ffeebda8d6def..c304a6a30d42e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2426,9 +2426,6 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 		size -= pgsize;
 	}
 
-	if (ops->iotlb_sync_map)
-		ops->iotlb_sync_map(domain);
-
 	/* unroll mapping in case something went wrong */
 	if (ret)
 		iommu_unmap(domain, orig_iova, orig_size - size);
@@ -2438,18 +2435,31 @@ static int __iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return ret;
 }
 
+static int _iommu_map(struct iommu_domain *domain, unsigned long iova,
+		      phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
+{
+	const struct iommu_ops *ops = domain->ops;
+	int ret;
+
+	ret = __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
+	if (ret == 0 && ops->iotlb_sync_map)
+		ops->iotlb_sync_map(domain);
+
+	return ret;
+}
+
 int iommu_map(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
 	might_sleep();
-	return __iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
+	return _iommu_map(domain, iova, paddr, size, prot, GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
 int iommu_map_atomic(struct iommu_domain *domain, unsigned long iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
-	return __iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
+	return _iommu_map(domain, iova, paddr, size, prot, GFP_ATOMIC);
 }
 EXPORT_SYMBOL_GPL(iommu_map_atomic);
 
@@ -2533,6 +2543,7 @@ static size_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 			     struct scatterlist *sg, unsigned int nents, int prot,
 			     gfp_t gfp)
 {
+	const struct iommu_ops *ops = domain->ops;
 	size_t len = 0, mapped = 0;
 	phys_addr_t start;
 	unsigned int i = 0;
@@ -2563,6 +2574,8 @@ static size_t __iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 			sg = sg_next(sg);
 	}
 
+	if (ops->iotlb_sync_map)
+		ops->iotlb_sync_map(domain);
 	return mapped;
 
 out_err:
-- 
2.27.0



