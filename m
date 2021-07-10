Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88EE73C3035
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhGJCdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232654AbhGJCcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BE0861441;
        Sat, 10 Jul 2021 02:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884077;
        bh=l1+Dx61/cWPcTwFaYUWs/nFxBvnaM5RYdBseYqHyH0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gt6ex4lXgcQXf3mNe6DIPzMWFwln/oUyLJj+0DDCOP1Ke28hRSz94Bkqeh9zMebp9
         mxTAYynPIaQnYvIYeNq2lL3UtPtihnsJLenwv4LUtxlEVoZ7wgd4dky5gU0rQrP/EK
         uV2ZrWE3Q3Z6lcv3xplhT/PCTHlns1ggApNYM/SoqN8ZExHBQpsKc9R/kvD6XWMflm
         Qu8QP4aXJFPeyZYothiVCv5F0fE7Dal3Un7ROjKJyA7WrQmoUcegbdBxQ39LtMuyD0
         1eNCR8DFCYkeEgJ/2VzPwe59YuVGNRqhOm2irMTNSeRDF6QHnHYtobRnslyw5JA2ij
         sQ2lDyOE0dTdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 37/63] iommu/arm-smmu: Fix arm_smmu_device refcount leak in address translation
Date:   Fri,  9 Jul 2021 22:26:43 -0400
Message-Id: <20210710022709.3170675-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022709.3170675-1-sashal@kernel.org>
References: <20210710022709.3170675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

