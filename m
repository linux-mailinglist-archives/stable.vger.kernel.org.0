Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8C3CE0FF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344654AbhGSPTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347152AbhGSPPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:15:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81643606A5;
        Mon, 19 Jul 2021 15:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710180;
        bh=beYeCVqpXG//mMve1jdsA+aMH4RCqJHoakwYn0A5V8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsP8b2gkFSPYakUkpFXM4mBxBkyrxNnEpFiIiIbVlQCm9OWoRq5T9L8MMPDCl7aL/
         8jpIq9EJQJafjtayYGVp7I2QxssCKr87JlVtEh4mITeS8akpc/xSMNZmLv9zCkDRGX
         IPbHBI3HgxwYaUnPBO9cqThjYq6RPN1m2FKedgOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/243] iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation
Date:   Mon, 19 Jul 2021 16:51:44 +0200
Message-Id: <20210719144943.328401125@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit 7c8f176d6a3fa18aa0f8875da6f7c672ed2a8554 ]

The reference counting issue happens in several exception handling paths
of arm_smmu_iova_to_phys_hard(). When those error scenarios occur, the
function forgets to decrease the refcount of "smmu" increased by
arm_smmu_rpm_get(), causing a refcount leak.

Fix this issue by jumping to "out" label when those error scenarios
occur.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Reviewed-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/1623293391-17261-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 052f0a1bf037..df24bbe3ea4f 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -1284,6 +1284,7 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 	u64 phys;
 	unsigned long va, flags;
 	int ret, idx = cfg->cbndx;
+	phys_addr_t addr = 0;
 
 	ret = arm_smmu_rpm_get(smmu);
 	if (ret < 0)
@@ -1303,6 +1304,7 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 		dev_err(dev,
 			"iova to phys timed out on %pad. Falling back to software table walk.\n",
 			&iova);
+		arm_smmu_rpm_put(smmu);
 		return ops->iova_to_phys(ops, iova);
 	}
 
@@ -1311,12 +1313,14 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 	if (phys & ARM_SMMU_CB_PAR_F) {
 		dev_err(dev, "translation fault!\n");
 		dev_err(dev, "PAR = 0x%llx\n", phys);
-		return 0;
+		goto out;
 	}
 
+	addr = (phys & GENMASK_ULL(39, 12)) | (iova & 0xfff);
+out:
 	arm_smmu_rpm_put(smmu);
 
-	return (phys & GENMASK_ULL(39, 12)) | (iova & 0xfff);
+	return addr;
 }
 
 static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
-- 
2.30.2



