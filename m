Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4ECE6AB795
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCFH5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbjCFH5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4791F483;
        Sun,  5 Mar 2023 23:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C55E60C61;
        Mon,  6 Mar 2023 07:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBF1C43618;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=NeIGcrfnxzuEqQ2lYCaxM49qcQ7dNB/jhVmGyQIzKIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3hONoWWhbpyaoBBmlwVc/kR31DanI9Gi/uwvJBfG1l9yI2gdS7Dl9edRWmr8XFkn
         U49YdSaMMCoxRUxQMqQ6FNWcxLz0cnVR+F0su3OXOlBWUjc7xDnbDDi1OKjhb0kB4l
         MHbJDd9sAjNpxU3Jo4xXkWWD4tzKuvLcCxXaRnh8REQSbu2uiokzkS5LkgR2kr1K5m
         YVavmMbBtpqM87Azq01U9+Giz3m0lj4ujiarIKr/65Ama7IJKcs/6/jgX5wj55/Zcx
         OxgBvru6IwPOg9uhjzI13rPh8PVRe9KlzLx9WjpvX9F9kc6tY03G7PX1M3W1Lfw3fg
         UJ284z43LK39A==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jd-0000iT-02; Mon, 06 Mar 2023 08:58:17 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "Andy Gross" <agross@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        "Konrad Dybcio" <konrad.dybcio@linaro.org>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>,
        =?UTF-8?q?Artur=20=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski@linaro.org>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        "Jonathan Hunter" <jonathanh@nvidia.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 14/23] interconnect: exynos: fix node leak in probe PM QoS error path
Date:   Mon,  6 Mar 2023 08:56:42 +0100
Message-Id: <20230306075651.2449-15-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306075651.2449-1-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Make sure to add the newly allocated interconnect node to the provider
before adding the PM QoS request so that the node is freed on errors.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Cc: stable@vger.kernel.org      # 5.11
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index 6559d8cf8068..e70665899482 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -149,6 +149,9 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 				 &priv->bus_clk_ratio))
 		priv->bus_clk_ratio = EXYNOS_ICC_DEFAULT_BUS_CLK_RATIO;
 
+	icc_node->data = priv;
+	icc_node_add(icc_node, provider);
+
 	/*
 	 * Register a PM QoS request for the parent (devfreq) device.
 	 */
@@ -157,9 +160,6 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto err_node_del;
 
-	icc_node->data = priv;
-	icc_node_add(icc_node, provider);
-
 	icc_parent_node = exynos_icc_get_parent(bus_dev->of_node);
 	if (IS_ERR(icc_parent_node)) {
 		ret = PTR_ERR(icc_parent_node);
-- 
2.39.2

