Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9323BB3F5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhGDXUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232239AbhGDXNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:13:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C074A61978;
        Sun,  4 Jul 2021 23:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440159;
        bh=QiVwjBDQpS5h5yj0aobhQO95uHFRJAx89puXFYzrUko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPzY/WFliq7/uMI894UBARH7Fuq71UXBk/DDJLyAQj3+eiJkMc96rJdFM4zq7mtZ0
         F6zqM1KfsS8wxSE5dxYXRg/olrhlOOPPZ9xNHakeZ1uco1sSd2PLnJANIPCp0Qtyja
         DRZBblmjdyXji+e+CV3oxwsGOthDobLIDYC4C1d8dWFzW0SmGbZ8/0K3UgMUvFV6MU
         lYfhNhHMM3rymzIQJQnB51VLXxE2Z6LZjpE4rNK/4IUZi+4Da9eCRUUFhRVu1VwBos
         JnqZKzBld2VkDVTLyzIhF8Hm7dxPUAA12OQssNHcoflVeiDM6tIq5zWhz3q6VFrt+A
         J8rgwCrdoSjEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 56/70] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Sun,  4 Jul 2021 19:07:49 -0400
Message-Id: <20210704230804.1490078-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
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
index 397540a4b799..7f7bc0993670 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -623,8 +623,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
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

