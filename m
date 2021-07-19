Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101233CDF4D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343882AbhGSPJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344818AbhGSPGy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:06:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCBDE60FE7;
        Mon, 19 Jul 2021 15:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709647;
        bh=owq9dcDj6W5tIDWtWgDI7aDMSiBLW0RSApzKwfmDGlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WvuqjeLdsnlsS9/ckWqikGYfzkFVHrnEoe6AtZVFFb9be5p0jy4ZPkXFj3zlI8AwK
         n7I03iBevLSmjhdH1mSZ3JPEGe+V1mQ8q2w0Ne5Gp1T29t23qOpoOhX1ePWhQ/UKLm
         pGdJXWy5fd4SHKrRcR5OBJytP3a7WA38Q1f/mIw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/149] iommu/arm-smmu: Fix arm_smmu_device refcount leak when arm_smmu_rpm_get fails
Date:   Mon, 19 Jul 2021 16:52:30 +0200
Message-Id: <20210719144911.422049820@linuxfoundation.org>
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



