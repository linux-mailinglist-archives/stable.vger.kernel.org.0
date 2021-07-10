Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5AD3C2E3E
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbhGJC0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233431AbhGJC0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4AB1613E1;
        Sat, 10 Jul 2021 02:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883795;
        bh=dg6PZhYDKEu5IrfYdh2th0q3Fhb88QjwQKmagB8cjX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VLySR1NoGl/ywAJ780fBS60WwUblR47Yg/apJG+MEdeObrNgHl6MAFkuaEHvvCEBO
         UP6BV+Fhpxc4eSzGBdNmUCl513v7t4N0hEUL7Qm+GZbfn9clsv9mzXPkveUNJ7Ee5p
         USq9EyIteJbRnYQ03MLFU5OTcrUffGscX8jaM2FdA5we3H+PhZrecY0mbXoRc4m8gu
         pAejzoPR45WB4MmJpthgGP1M2P/IIFsgCwQqfGEb3ksTM5Oa2n5D6MhwtyGu92LHRZ
         8iDJEJDa9wHJNIta9b+jxJuDIU9tYfjGL+Pnfg7nvifs7zymsao9clNVifM2fUDtr+
         /EArVdYZCtMYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org
Subject: [PATCH AUTOSEL 5.12 060/104] iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails
Date:   Fri,  9 Jul 2021 22:21:12 -0400
Message-Id: <20210710022156.3168825-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
 drivers/iommu/arm/arm-smmu/arm-smmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index d8c6bfde6a61..128c2c87b4e5 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -74,7 +74,7 @@ static bool using_legacy_binding, using_generic_binding;
 static inline int arm_smmu_rpm_get(struct arm_smmu_device *smmu)
 {
 	if (pm_runtime_enabled(smmu->dev))
-		return pm_runtime_get_sync(smmu->dev);
+		return pm_runtime_resume_and_get(smmu->dev);
 
 	return 0;
 }
-- 
2.30.2

