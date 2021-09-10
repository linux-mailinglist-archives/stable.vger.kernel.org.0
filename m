Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F062406159
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhIJAmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231783AbhIJASV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6CFB61205;
        Fri, 10 Sep 2021 00:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233016;
        bh=HzWGiUBcd5h3eyAJNDp6MCd9lPQkfKfLxSpl5vndjh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI2ZHJTFVnVV9TV0rFdGFr5hGd8uvpfU1x12SN5Fwul0aUDTEVBr/gVTXwydtJiiK
         fJAp/19t7/Gq5lTtmwhw0UQag3aNatqmEec0TZycHBGjeBr3a/YwF5AtAc0P7BUXR8
         CT7n62Ox0hMoqWztvOBzoK8dmldApW8Mh3FyiSOAjR/7cKyxrUuc7p8od5OyG4uII5
         dhn1wKYIkZ8K54E2c53/5/jEYQ+Ez9A2iB8ZAbJKOGSb9Af/4SU2zCQd/mBvsmXaKe
         fNc5hSA42Z6Ism6APUIKLZvUUWH2Lxlt04iwhDn+WnEqU6OEwo1OerZjAnRSTxIkla
         r9mLc11TBgKPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krishna Reddy <vdumpa@nvidia.com>,
        Ashish Mhetre <amhetre@nvidia.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.14 42/99] iommu/arm-smmu: Fix race condition during iommu_group creation
Date:   Thu,  9 Sep 2021 20:15:01 -0400
Message-Id: <20210910001558.173296-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishna Reddy <vdumpa@nvidia.com>

[ Upstream commit b1a1347912a742a4e1fcdc9df6302dd9dd2c3405 ]

When two devices with same SID are getting probed concurrently through
iommu_probe_device(), the iommu_group sometimes is getting allocated more
than once as call to arm_smmu_device_group() is not protected for
concurrency. Furthermore, it leads to each device holding a different
iommu_group and domain pointer, separate IOVA space and only one of the
devices' domain is used for translations from IOMMU. This causes accesses
from other device to fault or see incorrect translations.
Fix this by protecting iommu_group allocation from concurrency in
arm_smmu_device_group().

Signed-off-by: Krishna Reddy <vdumpa@nvidia.com>
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Link: https://lore.kernel.org/r/1628570641-9127-3-git-send-email-amhetre@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index f22dbeb1e510..3b4743d830b8 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1478,6 +1478,7 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	struct iommu_group *group = NULL;
 	int i, idx;
 
+	mutex_lock(&smmu->stream_map_mutex);
 	for_each_cfg_sme(cfg, fwspec, i, idx) {
 		if (group && smmu->s2crs[idx].group &&
 		    group != smmu->s2crs[idx].group)
@@ -1486,8 +1487,10 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 		group = smmu->s2crs[idx].group;
 	}
 
-	if (group)
+	if (group) {
+		mutex_unlock(&smmu->stream_map_mutex);
 		return iommu_group_ref_get(group);
+	}
 
 	if (dev_is_pci(dev))
 		group = pci_device_group(dev);
@@ -1501,6 +1504,7 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 		for_each_cfg_sme(cfg, fwspec, i, idx)
 			smmu->s2crs[idx].group = group;
 
+	mutex_unlock(&smmu->stream_map_mutex);
 	return group;
 }
 
-- 
2.30.2

