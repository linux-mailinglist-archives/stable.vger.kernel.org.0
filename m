Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065772D1911
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 20:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgLGTGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 14:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgLGTGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 14:06:14 -0500
From:   Krzysztof Kozlowski <krzk@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sylwester Nawrocki <snawrocki@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] soc: samsung: exynos-asv: don't defer early on not-supported SoCs
Date:   Mon,  7 Dec 2020 20:05:14 +0100
Message-Id: <20201207190517.262051-2-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207190517.262051-1-krzk@kernel.org>
References: <20201207190517.262051-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

Check if the SoC is really supported before gathering the needed
resources. This fixes endless deferred probe on some SoCs other than
Exynos5422 (like Exynos5410).

Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/soc/samsung/exynos-asv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/samsung/exynos-asv.c b/drivers/soc/samsung/exynos-asv.c
index 8abf4dfaa5c5..f653e3533f0f 100644
--- a/drivers/soc/samsung/exynos-asv.c
+++ b/drivers/soc/samsung/exynos-asv.c
@@ -119,11 +119,6 @@ static int exynos_asv_probe(struct platform_device *pdev)
 	u32 product_id = 0;
 	int ret, i;
 
-	cpu_dev = get_cpu_device(0);
-	ret = dev_pm_opp_get_opp_count(cpu_dev);
-	if (ret < 0)
-		return -EPROBE_DEFER;
-
 	asv = devm_kzalloc(&pdev->dev, sizeof(*asv), GFP_KERNEL);
 	if (!asv)
 		return -ENOMEM;
@@ -144,6 +139,11 @@ static int exynos_asv_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	cpu_dev = get_cpu_device(0);
+	ret = dev_pm_opp_get_opp_count(cpu_dev);
+	if (ret < 0)
+		return -EPROBE_DEFER;
+
 	ret = of_property_read_u32(pdev->dev.of_node, "samsung,asv-bin",
 				   &asv->of_bin);
 	if (ret < 0)
-- 
2.25.1

