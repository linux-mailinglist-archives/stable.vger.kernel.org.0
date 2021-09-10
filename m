Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4369A406210
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbhIJAoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233578AbhIJAUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8971061167;
        Fri, 10 Sep 2021 00:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233152;
        bh=cwsJNauNbuHbFGHrMlendi+VQYdVQon0xwi961peTX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLffUEN82rlNXpUyB2M16DfBw6q0G0FzsMymEnG1vEQwSgSCL+0HHTRMsBouzNnX/
         RC01ZUkvX5viMShpQZcIqteZ2C5TLpz/6uVvd/RnDftabzzlCvHeQUKVfA8aHdlq0t
         YhQT+H4AeW6s2E4OXxyRF3hkvoW29rqMdpCeiN4uqD66f937bp7iazZHqiq0BUOV0J
         1+iI/guijWnriw+L2GN9iMUCKFdbuM97jt9pCo0yYkpW+I57bBoYyQvWSr4LJiKees
         VK/0SBC0bm6E7Mrn60VYCdIkDKTy/6lUs/DvPmb1cSi+xWp6n9k5zkM5H/z9TjEL2R
         X0aTnM84kaqgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krishna Reddy <vdumpa@nvidia.com>,
        Ashish Mhetre <amhetre@nvidia.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.13 36/88] iommu/arm-smmu: Fix race condition during iommu_group creation
Date:   Thu,  9 Sep 2021 20:17:28 -0400
Message-Id: <20210910001820.174272-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
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
index 1a647e0ea3eb..5b82a08ef4b4 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1462,6 +1462,7 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 	struct iommu_group *group = NULL;
 	int i, idx;
 
+	mutex_lock(&smmu->stream_map_mutex);
 	for_each_cfg_sme(cfg, fwspec, i, idx) {
 		if (group && smmu->s2crs[idx].group &&
 		    group != smmu->s2crs[idx].group)
@@ -1470,8 +1471,10 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 		group = smmu->s2crs[idx].group;
 	}
 
-	if (group)
+	if (group) {
+		mutex_unlock(&smmu->stream_map_mutex);
 		return iommu_group_ref_get(group);
+	}
 
 	if (dev_is_pci(dev))
 		group = pci_device_group(dev);
@@ -1485,6 +1488,7 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
 		for_each_cfg_sme(cfg, fwspec, i, idx)
 			smmu->s2crs[idx].group = group;
 
+	mutex_unlock(&smmu->stream_map_mutex);
 	return group;
 }
 
-- 
2.30.2

