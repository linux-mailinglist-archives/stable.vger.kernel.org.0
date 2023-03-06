Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC106AB799
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCFH54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCFH5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6861F915;
        Sun,  5 Mar 2023 23:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E046CB80CAE;
        Mon,  6 Mar 2023 07:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF842C43613;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=FWxTZ1RqwVoujtqnJ/DHFooDHNoVoslTBxHPXwHinZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rb98aC/USRF/Y/JkuE/QfcURA1eAUgT93VlR7oRB9fIW6LTsoJZ+ysppaHYnfnWFS
         JUo4ip+MDmAGqm3Qi4xS5sZfVPh6TGaKNm5t4uUpZWZiqRM7WGIsLJoeIMLEvFVYGN
         1ex8LZf6yrBHihzSG0DXn4MyCQJi+y8DfSlN4EfsS72rhpRhDtBWg8MY0FdjoRpcs4
         +sfTFxLHx9gl/KqyX2TA8o28BTrBEV067U0ulefeRLls36NP27QnimPaXNaXbbhpFA
         T/s+QbTaKD6kThWnDslBBc+Cm+V+i3jkHNX0TTvEFBnV3bcyahpekDhSkdmOlM1/HM
         1UEeB1kxc2Xbw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jd-0000iZ-2h; Mon, 06 Mar 2023 08:58:17 +0100
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
Subject: [PATCH v2 15/23] interconnect: exynos: fix registration race
Date:   Mon,  6 Mar 2023 08:56:43 +0100
Message-Id: <20230306075651.2449-16-johan+linaro@kernel.org>
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
can specifically cause racing DT lookups to trigger a NULL-pointer
deference when either a NULL pointer or not fully initialised node is
returned from exynos_generic_icc_xlate().

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 2f95b9d5cf0b ("interconnect: Add generic interconnect driver for Exynos SoCs")
Cc: stable@vger.kernel.org      # 5.11
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/samsung/exynos.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/interconnect/samsung/exynos.c b/drivers/interconnect/samsung/exynos.c
index e70665899482..72e42603823b 100644
--- a/drivers/interconnect/samsung/exynos.c
+++ b/drivers/interconnect/samsung/exynos.c
@@ -98,12 +98,13 @@ static int exynos_generic_icc_remove(struct platform_device *pdev)
 	struct exynos_icc_priv *priv = platform_get_drvdata(pdev);
 	struct icc_node *parent_node, *node = priv->node;
 
+	icc_provider_deregister(&priv->provider);
+
 	parent_node = exynos_icc_get_parent(priv->dev->parent->of_node);
 	if (parent_node && !IS_ERR(parent_node))
 		icc_link_destroy(node, parent_node);
 
 	icc_nodes_remove(&priv->provider);
-	icc_provider_del(&priv->provider);
 
 	return 0;
 }
@@ -132,15 +133,11 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 	provider->inter_set = true;
 	provider->data = priv;
 
-	ret = icc_provider_add(provider);
-	if (ret < 0)
-		return ret;
+	icc_provider_init(provider);
 
 	icc_node = icc_node_create(pdev->id);
-	if (IS_ERR(icc_node)) {
-		ret = PTR_ERR(icc_node);
-		goto err_prov_del;
-	}
+	if (IS_ERR(icc_node))
+		return PTR_ERR(icc_node);
 
 	priv->node = icc_node;
 	icc_node->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "%pOFn",
@@ -171,14 +168,17 @@ static int exynos_generic_icc_probe(struct platform_device *pdev)
 			goto err_pmqos_del;
 	}
 
+	ret = icc_provider_register(provider);
+	if (ret < 0)
+		goto err_pmqos_del;
+
 	return 0;
 
 err_pmqos_del:
 	dev_pm_qos_remove_request(&priv->qos_req);
 err_node_del:
 	icc_nodes_remove(provider);
-err_prov_del:
-	icc_provider_del(provider);
+
 	return ret;
 }
 
-- 
2.39.2

