Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1302B49A477
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369507AbiAYAB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382508AbiAXX2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73851C01D7F2;
        Mon, 24 Jan 2022 13:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30823B81142;
        Mon, 24 Jan 2022 21:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC05C340E4;
        Mon, 24 Jan 2022 21:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059881;
        bh=yXNyj5w8WPn/dUWK5qhdWXLoj5pVBSY3hqJPXa2z4tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1iIRh4avFjF9wnxFq3Q24y9mSOwrA2KpE5juBvr6b7OYofqY4ZJnw61guiE2VmEs
         Xx1hKwmLBnlD7Pw4irZhplA2FSApxtM8wSR9v439RT+2oUbZdwNTdr7PrDUlZULcUB
         ZeWU+vz9Kxu+Qw5TLygbdem+ZJlQ0wUeexS0wl9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0733/1039] clk: samsung: exynos850: Register clocks early
Date:   Mon, 24 Jan 2022 19:42:02 +0100
Message-Id: <20220124184149.962049672@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sam Protsenko <semen.protsenko@linaro.org>

[ Upstream commit bcda841f9bf2cddcf2f000cba96f2e27f6f2bdbf ]

Some clocks must be registered before init calls. For example MCT clock
(from CMU_PERI) is needed for MCT timer driver, which is registered
with TIMER_OF_DECLARE(). By the time we get to core_initcall() used for
clk-exynos850 platform driver init, it's already too late. Inability to
get "mct" clock in MCT driver leads to kernel panic, as functions
registered with *_OF_DECLARE() can't do deferred calls. MCT timer driver
can't be fixed either, as it's acting as a clock source and it's
essential to register it in start_kernel() -> time_init().

Let's register CMU_PERI clocks early, using CLK_OF_DECLARE(). CMU_TOP
generates clocks needed for CMU_PERI, but it's already registered early.

While at it, let's cleanup the code a bit, by extracting everything
related to CMU initialization and registration to the separate function.

Similar issue was discussed at [1] and addressed in commit 1f7db7bbf031
("clk: renesas: cpg-mssr: Add early clock support"), as well as in
drivers/clk/mediatek/clk-mt2712.c.

[1] https://patchwork.kernel.org/project/linux-renesas-soc/patch/20180829132954.64862-2-chris.brandt@renesas.com/

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211122144206.23134-1-semen.protsenko@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos850.c | 70 ++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos850.c b/drivers/clk/samsung/clk-exynos850.c
index 2294989e244c5..79cce8ba88831 100644
--- a/drivers/clk/samsung/clk-exynos850.c
+++ b/drivers/clk/samsung/clk-exynos850.c
@@ -60,6 +60,43 @@ static void __init exynos850_init_clocks(struct device_node *np,
 	iounmap(reg_base);
 }
 
+/**
+ * exynos850_register_cmu - Register specified Exynos850 CMU domain
+ * @dev:	Device object; may be NULL if this function is not being
+ *		called from platform driver probe function
+ * @np:		CMU device tree node
+ * @cmu:	CMU data
+ *
+ * Register specified CMU domain, which includes next steps:
+ *
+ * 1. Enable parent clock of @cmu CMU
+ * 2. Set initial registers configuration for @cmu CMU clocks
+ * 3. Register @cmu CMU clocks using Samsung clock framework API
+ */
+static void __init exynos850_register_cmu(struct device *dev,
+		struct device_node *np, const struct samsung_cmu_info *cmu)
+{
+	/* Keep CMU parent clock running (needed for CMU registers access) */
+	if (cmu->clk_name) {
+		struct clk *parent_clk;
+
+		if (dev)
+			parent_clk = clk_get(dev, cmu->clk_name);
+		else
+			parent_clk = of_clk_get_by_name(np, cmu->clk_name);
+
+		if (IS_ERR(parent_clk)) {
+			pr_err("%s: could not find bus clock %s; err = %ld\n",
+			       __func__, cmu->clk_name, PTR_ERR(parent_clk));
+		} else {
+			clk_prepare_enable(parent_clk);
+		}
+	}
+
+	exynos850_init_clocks(np, cmu->clk_regs, cmu->nr_clk_regs);
+	samsung_cmu_register_one(np, cmu);
+}
+
 /* ---- CMU_TOP ------------------------------------------------------------- */
 
 /* Register Offset definitions for CMU_TOP (0x120e0000) */
@@ -347,10 +384,10 @@ static const struct samsung_cmu_info top_cmu_info __initconst = {
 
 static void __init exynos850_cmu_top_init(struct device_node *np)
 {
-	exynos850_init_clocks(np, top_clk_regs, ARRAY_SIZE(top_clk_regs));
-	samsung_cmu_register_one(np, &top_cmu_info);
+	exynos850_register_cmu(NULL, np, &top_cmu_info);
 }
 
+/* Register CMU_TOP early, as it's a dependency for other early domains */
 CLK_OF_DECLARE(exynos850_cmu_top, "samsung,exynos850-cmu-top",
 	       exynos850_cmu_top_init);
 
@@ -615,6 +652,15 @@ static const struct samsung_cmu_info peri_cmu_info __initconst = {
 	.clk_name		= "dout_peri_bus",
 };
 
+static void __init exynos850_cmu_peri_init(struct device_node *np)
+{
+	exynos850_register_cmu(NULL, np, &peri_cmu_info);
+}
+
+/* Register CMU_PERI early, as it's needed for MCT timer */
+CLK_OF_DECLARE(exynos850_cmu_peri, "samsung,exynos850-cmu-peri",
+	       exynos850_cmu_peri_init);
+
 /* ---- CMU_CORE ------------------------------------------------------------ */
 
 /* Register Offset definitions for CMU_CORE (0x12000000) */
@@ -779,24 +825,9 @@ static int __init exynos850_cmu_probe(struct platform_device *pdev)
 {
 	const struct samsung_cmu_info *info;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 
 	info = of_device_get_match_data(dev);
-	exynos850_init_clocks(np, info->clk_regs, info->nr_clk_regs);
-	samsung_cmu_register_one(np, info);
-
-	/* Keep bus clock running, so it's possible to access CMU registers */
-	if (info->clk_name) {
-		struct clk *bus_clk;
-
-		bus_clk = clk_get(dev, info->clk_name);
-		if (IS_ERR(bus_clk)) {
-			pr_err("%s: could not find bus clock %s; err = %ld\n",
-			       __func__, info->clk_name, PTR_ERR(bus_clk));
-		} else {
-			clk_prepare_enable(bus_clk);
-		}
-	}
+	exynos850_register_cmu(dev, dev->of_node, info);
 
 	return 0;
 }
@@ -806,9 +837,6 @@ static const struct of_device_id exynos850_cmu_of_match[] = {
 	{
 		.compatible = "samsung,exynos850-cmu-hsi",
 		.data = &hsi_cmu_info,
-	}, {
-		.compatible = "samsung,exynos850-cmu-peri",
-		.data = &peri_cmu_info,
 	}, {
 		.compatible = "samsung,exynos850-cmu-core",
 		.data = &core_cmu_info,
-- 
2.34.1



