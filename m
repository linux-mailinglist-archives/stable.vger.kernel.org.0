Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50323BB095
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhGDXI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhGDXI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F5EC611ED;
        Sun,  4 Jul 2021 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439952;
        bh=GZThXBkEDJrPkBQ6gYuFdb3WkyY1+rD+VFNgn18u+z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCgQr/5V/6thl2FbtWFfp1K4lguGpU84+xutcAAw2iRkFwsvisCT+0SFz/RN7kQsJ
         4OVJYFMfyIsaEUM6Y6jkC3oEszPNb9VtNmnjjVE9Lg+D94zf2m8jfwnKZOwW3rZ//p
         nFhX3KOUo2/NvAn2LPlfO/77jDNWKJi+3xBj1oZpQY1Z3BhT31vFjGtdbUGSsPyok6
         i7eAY1j21purXaRtcRmEAU0wnFAi52nS1yYm2pn8+fVODBbgDnYg/Q5o6HRLywG7SU
         FxOGw13Fqj5O2edb5lmnE5n+cUQ3Qtkvt/Gc1BdVjMjWIKgjYMDcBJWWhlc61upm8g
         9TxMsg4frkjiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 67/85] drivers/perf: fix the missed ida_simple_remove() in ddr_perf_probe()
Date:   Sun,  4 Jul 2021 19:04:02 -0400
Message-Id: <20210704230420.1488358-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index 2bbb93188064..7b87aaf267d5 100644
--- a/drivers/perf/fsl_imx8_ddr_perf.c
+++ b/drivers/perf/fsl_imx8_ddr_perf.c
@@ -705,8 +705,10 @@ static int ddr_perf_probe(struct platform_device *pdev)
 
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

