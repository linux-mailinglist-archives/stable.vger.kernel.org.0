Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27DF2D1915
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 20:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgLGTGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 14:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbgLGTGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 14:06:17 -0500
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
Subject: [PATCH v2 2/4] soc: samsung: exynos-asv: handle reading revision register error
Date:   Mon,  7 Dec 2020 20:05:15 +0100
Message-Id: <20201207190517.262051-3-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201207190517.262051-1-krzk@kernel.org>
References: <20201207190517.262051-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If regmap_read() fails, the product_id local variable will contain
random value from the stack.  Do not try to parse such value and fail
the ASV driver probe.

Fixes: 5ea428595cc5 ("soc: samsung: Add Exynos Adaptive Supply Voltage driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/soc/samsung/exynos-asv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/samsung/exynos-asv.c b/drivers/soc/samsung/exynos-asv.c
index f653e3533f0f..5daeadc36382 100644
--- a/drivers/soc/samsung/exynos-asv.c
+++ b/drivers/soc/samsung/exynos-asv.c
@@ -129,7 +129,13 @@ static int exynos_asv_probe(struct platform_device *pdev)
 		return PTR_ERR(asv->chipid_regmap);
 	}
 
-	regmap_read(asv->chipid_regmap, EXYNOS_CHIPID_REG_PRO_ID, &product_id);
+	ret = regmap_read(asv->chipid_regmap, EXYNOS_CHIPID_REG_PRO_ID,
+			  &product_id);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Cannot read revision from ChipID: %d\n",
+			ret);
+		return -ENODEV;
+	}
 
 	switch (product_id & EXYNOS_MASK) {
 	case 0xE5422000:
-- 
2.25.1

