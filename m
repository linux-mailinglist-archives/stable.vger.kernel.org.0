Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D851E3BB146
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhGDXLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhGDXKR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DF606135D;
        Sun,  4 Jul 2021 23:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440061;
        bh=hvrLauVFWh743EloqAaqUKrqb2UFuN2LrjXSfW90LLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMis4a6Su3JwDKqH6JjN4sM6TTX1GWPneXMS7XLVPCbxX7GcIpHHtyaxN0Dxgnotf
         Q6Ufh4LncEHhZH5DSzMtz682gBgrN0lI3Q6xSIz2XvfBh5f6BE5UyFHQHFx4lSJzQZ
         xK+whfrIOg/DJ5NllWccZLx78dAEgVlXDbSFlFYU2RkLvbtdXLLYO8mlkQgchc6cql
         eigZAikjoUo3BpGBxny3j59pJ3EGOMc/R38TnMgn5bx8ui/6fGDUpYrYGZ6XnbXFLF
         LWy+9NBWuhT7kSh15qL5q7TVQSQ8H85D1pwGvnwtSMD180JxsYWDtkzNN6ooBgH188
         ijPQi3KJH5vpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 63/80] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Sun,  4 Jul 2021 19:05:59 -0400
Message-Id: <20210704230616.1489200-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit d96b1b8c9f79b6bb234a31c80972a6f422079376 ]

ddr_perf_probe() misses to call ida_simple_remove() in an error path.
Jump to cpuhp_state_err to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20210617122614.166823-1-jingxiangfeng@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/fsl_imx8_ddr_perf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/fsl_imx8_ddr_perf.c b/drivers/perf/fsl_imx8_ddr_perf.c
index be1f26b62ddb..4a56849f0400 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -706,8 +706,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
 	name = devm_kasprintf(&pdev->dev, GFP_KERNEL, DDR_PERF_DEV_NAME "%d",
 			      num);
-	if (!name)
-		return -ENOMEM;
+	if (!name) {
+		ret = -ENOMEM;
+		goto cpuhp_state_err;
+	}
 
 	pmu->devtype_data = of_device_get_match_data(&pdev->dev);
 
-- 
2.30.2

