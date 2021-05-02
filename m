Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65B0F370C68
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhEBOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232931AbhEBOFs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 400C3613AA;
        Sun,  2 May 2021 14:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964295;
        bh=pRWQTNa7zbL1/pzwcPx3kyuHU2n1W3cd+i3yqgWC/zQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLW66OaKBLmBQZjCZ8guIcxlaka52w9wk6wTZ3kGydII3ihqsmn01H4u3UJHITuo1
         EHrnaPHfPGPPpvWlyewwhS2775Trv0eouUcJEphK59TR+M4xsUWCUk26Tyaw3hSRTV
         UlWZ09Yb5bL+vRzv496fgEHWlMbDLQrwiXFZMzjodxGG3xcNrGI9PxEfA3Xt1WvExD
         0tZbf+IBMR1sJ8CnWu1xMkTn2lNdYd9Gdn9GNneNfAH180SlcXFEBcGAsGl/wKetgM
         7FwYn0w3OfpcO61zqXs26LpT3625F6bY+tLN2k0siUqnMQDUDQEgbVYzUM8XkAIVz1
         IhlyCXGMXpNxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 17/34] perf/arm_pmu_platform: Fix error handling
Date:   Sun,  2 May 2021 10:04:17 -0400
Message-Id: <20210502140434.2719553-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit e338cb6bef254821a8c095018fd27254d74bfd6a ]

If we're aborting after failing to register the PMU device,
we probably don't want to leak the IRQs that we've claimed.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/53031a607fc8412a60024bfb3bb8cd7141f998f5.1616774562.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index 933bd8410fc2..e35cb76c8d10 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -236,7 +236,7 @@ int arm_pmu_device_probe(struct platform_device *pdev,
 
 	ret = armpmu_register(pmu);
 	if (ret)
-		goto out_free;
+		goto out_free_irqs;
 
 	return 0;
 
-- 
2.30.2

