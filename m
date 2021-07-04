Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C84E3BB37F
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhGDXSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233783AbhGDXOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF9CB6199D;
        Sun,  4 Jul 2021 23:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440227;
        bh=kgtaJvA+7EPrqT0AesDI5to2E+p7OCd4wpqdTFGSVQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nzanktGNi8a282K5Nr24oSiYwouGQfd18s4D9wFuGC0N1JZsHLIAce6Fo2uZDEUyM
         GbYoN8g1o+nHTXM6goN3vaXtxt6jCdddswYh6gt5ddbb3AYfLs0shLmpAyCjyfE/qY
         A7UFN6n7I9yUGRl7L41hIJoy69fLw6HmPUFzzFWJFp2qfg4P+VQmFibYYMMmJPPvpe
         yNDFtl16xCzFHRyzUqX5Q2PWNIKvssfMDbsjvyYR2Kmzfz3MEzIvT92AYhtGX4AJ17
         GvFr/+it8nUc0KQ6alr7rSZxC4W3uckSdCK5lbJzpVD8AS817UmsdNOieDLAFhwx77
         4/2hqIbEoDLPQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 38/50] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Sun,  4 Jul 2021 19:09:26 -0400
Message-Id: <20210704230938.1490742-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index 09f44c6e2eaf..726ed8f59868 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -562,8 +562,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
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

