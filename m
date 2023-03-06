Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7936AB7A3
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjCFH6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCFH5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355581F5E0;
        Sun,  5 Mar 2023 23:57:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA9DAB80CAD;
        Mon,  6 Mar 2023 07:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB27C433A1;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=Rngp6Jy2nDUmPtMi90PgWznpQX+Xr7VYE/JPsZohmAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cx51lNLwe6cHUaYqpx5KRqo8r7aJIyzTVmjprkzWV091z4qB3PA/cHn9W5KN3hwEe
         MFHpRke2YKcZ0M+Sm962LzpvvrEWXRWVlehO0UDpQYu7FfvO/pMEUhelJi0+8DZt5F
         BObl8q56NFY67/Zz4zzutuE+/ITVYM+/Jwte5/jdh2MpYZKDEuFGdDsDwLjls2tM/q
         khukH3i4pTyvf2nFi7LndFFf6yRFwAr/TlT7Yi1dOdBKeh3j5tN/zz/Ty9OwdLsYLZ
         mQZH9cSRWYTA5w6KpSWqWI5mv/96LliWxajFzQXpUs2sxXvS8Mij0EyDzjKhWY2OmF
         ztN48HqnspqBw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jc-0000hz-1Q; Mon, 06 Mar 2023 08:58:16 +0100
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
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Alexandre Bailon <abailon@baylibre.com>,
        Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: [PATCH v2 04/23] interconnect: imx: fix registration race
Date:   Mon,  6 Mar 2023 08:56:32 +0100
Message-Id: <20230306075651.2449-5-johan+linaro@kernel.org>
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

The current interconnect provider registration interface is inherently
racy as nodes are not added until the after adding the provider. This
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: f0d8048525d7 ("interconnect: Add imx core driver")
Cc: stable@vger.kernel.org      # 5.8
Cc: Alexandre Bailon <abailon@baylibre.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/imx/imx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/interconnect/imx/imx.c b/drivers/interconnect/imx/imx.c
index 823d9be9771a..979ed610f704 100644
--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -295,6 +295,9 @@ int imx_icc_register(struct platform_device *pdev,
 	provider->xlate = of_icc_xlate_onecell;
 	provider->data = data;
 	provider->dev = dev->parent;
+
+	icc_provider_init(provider);
+
 	platform_set_drvdata(pdev, imx_provider);
 
 	if (settings) {
@@ -306,20 +309,18 @@ int imx_icc_register(struct platform_device *pdev,
 		}
 	}
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
+	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	if (ret)
 		return ret;
-	}
 
-	ret = imx_icc_register_nodes(imx_provider, nodes, nodes_count, settings);
+	ret = icc_provider_register(provider);
 	if (ret)
-		goto provider_del;
+		goto err_unregister_nodes;
 
 	return 0;
 
-provider_del:
-	icc_provider_del(provider);
+err_unregister_nodes:
+	imx_icc_unregister_nodes(&imx_provider->provider);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(imx_icc_register);
@@ -328,9 +329,8 @@ void imx_icc_unregister(struct platform_device *pdev)
 {
 	struct imx_icc_provider *imx_provider = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&imx_provider->provider);
 	imx_icc_unregister_nodes(&imx_provider->provider);
-
-	icc_provider_del(&imx_provider->provider);
 }
 EXPORT_SYMBOL_GPL(imx_icc_unregister);
 
-- 
2.39.2

