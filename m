Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B018111F62
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfLCXHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbfLCWq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82BF020684;
        Tue,  3 Dec 2019 22:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413216;
        bh=L4XOYS3b/3flJVtxje65XySINl6P8L3mSzV9zxODNIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=druYHK3dwtZCEeZNwVZgAbHu9OPr8ifiCSyeq1Q6ppV2oAzQjHGdLZx+X5BNWqdl6
         E/umfMO2CsFaiSanMS8XHwnoVz+97VVPrnxSpQoA0ctoHa9nlLZI4kN+4AHYm+9TAy
         K+kPhiTLskx2sGHiQcLwL3SWpKeQW9tBpMAAMLbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        kbuild test robot <lkp@intel.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/321] clk: samsung: exynos5433: Fix error paths
Date:   Tue,  3 Dec 2019 23:31:12 +0100
Message-Id: <20191203223427.452305159@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit faac3604d05e8015567124e5ee79edc3f1568a89 ]

Add checking the value returned by samsung_clk_alloc_reg_dump() and
devm_kcalloc(). While fixing this, also release all gathered clocks.

Fixes: 523d3de41f02 ("clk: samsung: exynos5433: Add support for runtime PM")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
[s.nawrocki: squashed patch from K. Kozlowski adding missing slab.h header]
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5433.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5433.c b/drivers/clk/samsung/clk-exynos5433.c
index 426980514e679..302596dc79a2c 100644
--- a/drivers/clk/samsung/clk-exynos5433.c
+++ b/drivers/clk/samsung/clk-exynos5433.c
@@ -16,6 +16,7 @@
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <dt-bindings/clock/exynos5433.h>
 
@@ -5527,6 +5528,8 @@ static int __init exynos5433_cmu_probe(struct platform_device *pdev)
 
 	data->clk_save = samsung_clk_alloc_reg_dump(info->clk_regs,
 						    info->nr_clk_regs);
+	if (!data->clk_save)
+		return -ENOMEM;
 	data->nr_clk_save = info->nr_clk_regs;
 	data->clk_suspend = info->suspend_regs;
 	data->nr_clk_suspend = info->nr_suspend_regs;
@@ -5535,12 +5538,19 @@ static int __init exynos5433_cmu_probe(struct platform_device *pdev)
 	if (data->nr_pclks > 0) {
 		data->pclks = devm_kcalloc(dev, sizeof(struct clk *),
 					   data->nr_pclks, GFP_KERNEL);
-
+		if (!data->pclks) {
+			kfree(data->clk_save);
+			return -ENOMEM;
+		}
 		for (i = 0; i < data->nr_pclks; i++) {
 			struct clk *clk = of_clk_get(dev->of_node, i);
 
-			if (IS_ERR(clk))
+			if (IS_ERR(clk)) {
+				kfree(data->clk_save);
+				while (--i >= 0)
+					clk_put(data->pclks[i]);
 				return PTR_ERR(clk);
+			}
 			data->pclks[i] = clk;
 		}
 	}
-- 
2.20.1



