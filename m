Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A172C370CE2
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbhEBOH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233712AbhEBOHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AD24613EA;
        Sun,  2 May 2021 14:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964358;
        bh=lC97Tj1ehvcUuFVzxczscYEkaTHn/Mum0iWhRqdNedE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGQgmrVI7RolCCJS3lTfC0X6BCUOnhaR5QMpaL7o5pSp1N2GNjnSPUfmELZ81CvTN
         PYxSRvX5/+eiI8TPhzmsLHbzl1GjH+8e63Tsqw76ziqFWUKD/G5zOXMzkVLYDhD1vU
         Z9yiD5x2/vObLlA+22IU68SuReUF5cvlFF/kJiPgIWHJ9blrTf+FX5BdgJYFtECelh
         eu4HZc9Az0tiR/NiIAHfFHoE9sNGaEHszKGIjIOqx7ekXtaQvikKCa2kp9K+xbhAiI
         5/kZKm2w4ZTP1qWzLGACWb32yEFK1lsh09R3NNYyzc68K6YYijSZACiHRND4Spn8HA
         Gy6/0s9XbfTIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 10/16] perf/arm_pmu_platform: Fix error handling
Date:   Sun,  2 May 2021 10:05:38 -0400
Message-Id: <20210502140544.2720138-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
index 4428852e1da1..bd5af219ca9b 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -222,7 +222,7 @@ int arm_pmu_device_probe(struct platform_device *pdev,
 
 	ret = armpmu_register(pmu);
 	if (ret)
-		goto out_free;
+		goto out_free_irqs;
 
 	return 0;
 
-- 
2.30.2

