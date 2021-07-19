Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C363CDF4E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344128AbhGSPJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344816AbhGSPGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722C660FED;
        Mon, 19 Jul 2021 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709650;
        bh=l1+Dx61/cWPcTwFaYUWs/nFxBvnaM5RYdBseYqHyH0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8osGVHlwnIIVj7l42UlNhmOTW0YTkJmVgzCgIVrbfUqkCKg6KGQuKAwUoxkYhIh7
         fNgsjHQalHE8uMUeUhKYKHDXWTYTYXuL56FKI7AX/MnGhry/GYN61oOtrYZI2DD++m
         NfvU5M8HEW7aMeUILnNB5kQ9ilibJvi8mu2FoOVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/149] iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation
Date:   Mon, 19 Jul 2021 16:52:31 +0200
Message-Id: <20210719144911.646673537@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
 drivers/iommu/arm-smmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index abf4cf285548..2185ea5191c1 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1231,6 +1231,7 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 	u64 phys;
 	unsigned long va, flags;
 	int ret, idx = cfg->cbndx;
+	phys_addr_t addr = 0;
 
 	ret = arm_smmu_rpm_get(smmu);
 	if (ret < 0)
@@ -1249,6 +1250,7 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 		dev_err(dev,
 			"iova to phys timed out on %pad. Falling back to software table walk.\n",
 			&iova);
+		arm_smmu_rpm_put(smmu);
 		return ops->iova_to_phys(ops, iova);
 	}
 
@@ -1257,12 +1259,14 @@ static phys_addr_t arm_smmu_iova_to_phys_hard(struct iommu_domain *domain,
 	if (phys & CB_PAR_F) {
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



