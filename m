Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9176A37CDAC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238966AbhELQ51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:60668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244040AbhELQm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F017A61D0A;
        Wed, 12 May 2021 16:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835793;
        bh=oYSkq20cqGf3TSJ6XuryktDSHljq7XAMF7O10/G1HMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13W2josPENZwb314x6ozEOpIo/kacUJJ7XeLxyVFPGZ8hJ4kuZLaKqLcSN3qNZcoT
         GHBe2oXKX9MsEmdsEPQNiPcqFb2CfslzYdNoUwHN9m2BoQ2AehCN83sXLChKKHxxCd
         owWFPx9vN0MV5faeDtJkxtfmwnlkKYNni/uaSkiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 452/677] iommu: Check dev->iommu in iommu_dev_xxx functions
Date:   Wed, 12 May 2021 16:48:18 +0200
Message-Id: <20210512144852.377040912@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

[ Upstream commit b9abb19fa5fd2d8a4be61c6cd4b2a48aa1a17f9c ]

The device iommu probe/attach might have failed leaving dev->iommu
to NULL and device drivers may still invoke these functions resulting
in a crash in iommu vendor driver code.

Hence make sure we check that.

Fixes: a3a195929d40 ("iommu: Add APIs for multiple domains per device")
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20210303173611.520-1-shameerali.kolothum.thodi@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommu.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index d0b0a15dba84..e10cfa99057c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2878,10 +2878,12 @@ EXPORT_SYMBOL_GPL(iommu_fwspec_add_ids);
  */
 int iommu_dev_enable_feature(struct device *dev, enum iommu_dev_features feat)
 {
-	const struct iommu_ops *ops = dev->bus->iommu_ops;
+	if (dev->iommu && dev->iommu->iommu_dev) {
+		const struct iommu_ops *ops = dev->iommu->iommu_dev->ops;
 
-	if (ops && ops->dev_enable_feat)
-		return ops->dev_enable_feat(dev, feat);
+		if (ops->dev_enable_feat)
+			return ops->dev_enable_feat(dev, feat);
+	}
 
 	return -ENODEV;
 }
@@ -2894,10 +2896,12 @@ EXPORT_SYMBOL_GPL(iommu_dev_enable_feature);
  */
 int iommu_dev_disable_feature(struct device *dev, enum iommu_dev_features feat)
 {
-	const struct iommu_ops *ops = dev->bus->iommu_ops;
+	if (dev->iommu && dev->iommu->iommu_dev) {
+		const struct iommu_ops *ops = dev->iommu->iommu_dev->ops;
 
-	if (ops && ops->dev_disable_feat)
-		return ops->dev_disable_feat(dev, feat);
+		if (ops->dev_disable_feat)
+			return ops->dev_disable_feat(dev, feat);
+	}
 
 	return -EBUSY;
 }
@@ -2905,10 +2909,12 @@ EXPORT_SYMBOL_GPL(iommu_dev_disable_feature);
 
 bool iommu_dev_feature_enabled(struct device *dev, enum iommu_dev_features feat)
 {
-	const struct iommu_ops *ops = dev->bus->iommu_ops;
+	if (dev->iommu && dev->iommu->iommu_dev) {
+		const struct iommu_ops *ops = dev->iommu->iommu_dev->ops;
 
-	if (ops && ops->dev_feat_enabled)
-		return ops->dev_feat_enabled(dev, feat);
+		if (ops->dev_feat_enabled)
+			return ops->dev_feat_enabled(dev, feat);
+	}
 
 	return false;
 }
-- 
2.30.2



