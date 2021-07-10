Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A99C3C302D
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234616AbhGJCdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:33:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhGJCbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F0CA6143D;
        Sat, 10 Jul 2021 02:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884076;
        bh=owq9dcDj6W5tIDWtWgDI7aDMSiBLW0RSApzKwfmDGlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYlwyB0eGUIWJvxe+D1/rTYjJiWVzwJruYqJgtUb87dkrzx1hlHR10GBMCq+GpGUU
         eMgqM3pQXQeqjZ1+p3lOyH4zEXtHMoXAW20irUS/7UscvV3oMA/qfQgAel6dkkwsQA
         pVoM7SNVsU9FGFdD1YFMhQb6h3gZo7zQjjjVx9CTM+OWKwOCuA5w2Lva1BCjGJxycP
         UQwwrrQprbbEXaSM07YJgkieU1x6TMQJlzhRDqJklC1CyzhPvDqYCiDflDCAxz8+Cm
         252YA6P9lMG+7ydxDp/NJzvMhLDPj4zFuEy3RHbXpE4MJL8R85zmMk3SW06G+j2mj0
         mtXupOR7MAE/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.4 36/63] iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails
Date:   Fri,  9 Jul 2021 22:26:42 -0400
Message-Id: <20210710022709.3170675-36-sashal@kernel.org>
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

[ Upstream commit 1adf30f198c26539a62d761e45af72cde570413d ]

arm_smmu_rpm_get() invokes pm_runtime_get_sync(), which increases the
refcount of the "smmu" even though the return value is less than 0.

The reference counting issue happens in some error handling paths of
arm_smmu_rpm_get() in its caller functions. When arm_smmu_rpm_get()
fails, the caller functions forget to decrease the refcount of "smmu"
increased by arm_smmu_rpm_get(), causing a refcount leak.

Fix this issue by calling pm_runtime_resume_and_get() instead of
pm_runtime_get_sync() in arm_smmu_rpm_get(), which can keep the refcount
balanced in case of failure.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Link: https://lore.kernel.org/r/1623293672-17954-1-git-send-email-xiyuyang19@fudan.edu.cn
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 7c503a6bc585..abf4cf285548 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -114,7 +114,7 @@ static bool using_legacy_binding, using_generic_binding;
 static inline int arm_smmu_rpm_get(struct arm_smmu_device *smmu)
 {
 	if (pm_runtime_enabled(smmu->dev))
-		return pm_runtime_get_sync(smmu->dev);
+		return pm_runtime_resume_and_get(smmu->dev);
 
 	return 0;
 }
-- 
2.30.2

