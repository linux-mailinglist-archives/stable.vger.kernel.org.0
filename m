Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69DCD370CD1
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233420AbhEBOHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232696AbhEBOG0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8040561462;
        Sun,  2 May 2021 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964332;
        bh=aSgLEINy5phzqekUqvW789zAyvg6gO6wO38lAX5KAWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/QXYG7p0meDkv3uW9IznRFWZI7bfj7p7jUDZ1NDLfLvg7ezniPdn2dQni6FGo7zk
         CnwNhhbucVrPb0FFGv5JWsYLoYC0l5J0TG3qSLPsF2V8EtmSvCWurRUZcc/wZsfAY2
         ucvyKGhlA/CdfRCOEJVGqEOSsni3YaraU16hGcYHUVRV8Mrf+XGE+JxRXMvHHt2sc6
         rFVppaGiCV2xSXyQy7sznzUzZv2ZFiMVzxaL+Pr6rkYVLe4XmTeni22XoKUiFrONDL
         x0Zl9zUpR7eEnQzzTFv2mA5Mdq13A1oSjk7kRpQXhrI2aMgx/tyeprVTqoeaowXpZX
         jBbditEJnH2zQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 11/21] perf/arm_pmu_platform: Fix error handling
Date:   Sun,  2 May 2021 10:05:07 -0400
Message-Id: <20210502140517.2719912-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
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
index 96075cecb0ae..199293450acf 100644
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

