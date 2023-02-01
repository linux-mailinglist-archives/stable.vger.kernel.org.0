Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0186863E0
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjBAKRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbjBAKQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF524ED3E;
        Wed,  1 Feb 2023 02:16:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02D0661757;
        Wed,  1 Feb 2023 10:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235EDC4361B;
        Wed,  1 Feb 2023 10:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246593;
        bh=0nF8bFxY3P5D9tTctpmyCeHRuEBYqHVlVkGhiXKBwvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sz/RSIN67O56ujGi0CSF/0DVIJH32aKT1O15exs+nQ7Qbiz3JZaX8YQnhqQOhcVYF
         IExipRlxc1qw0prEIMH9jsgFFHERR0sGSJ/DKvik0ImXY+wpwX7uoUTUKbGSsU73YT
         VmDA17WCjEzSZ7JUu8WsIxEubtswYy/r5+pDsbncIfSCheRmzfbtlm2nQz1/XVOiIP
         Ep4+nEojXdkXUNdPmdULXeyPfiJ0EYWHvbQiN2PLftsmWMX8HmezLS+JfbLeEI5OjQ
         tU8X3ffKs8YfJAaz0uCXpc5t7NgbHZj9zOBCS+g+zU00yngr5ek6MDRNxTUeQRdrPP
         UPLkdGa4aY6Aw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAg-00044K-Am; Wed, 01 Feb 2023 11:16:54 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        =?UTF-8?q?Artur=20=C5=9Awigo=C5=84?= <a.swigon@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 15/23] interconnect: exynos: fix registration race
Date:   Wed,  1 Feb 2023 11:15:51 +0100
Message-Id: <20230201101559.15529-16-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201101559.15529-1-johan+linaro@kernel.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
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
2.39.1

