Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F28206863E6
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbjBAKRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjBAKQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78872E0E1;
        Wed,  1 Feb 2023 02:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A5DEB8212E;
        Wed,  1 Feb 2023 10:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCD7C43332;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=2R+fnciVEwp0KqBrx0Fp6TNbAF2jqwTGLSoOGZwTVrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mbw/yUWsL3YcDVf8XPq0Q3FXVNmLL+zLSbsUMy3uymroe9vCUA6YbQOqesAFToMey
         r5AIhYn7CjMLbOLXLCjC0WGFokIhMB78zxFQshPMBgu/j+DBQ0I37uNGXh38HoaQwY
         dPfhccKjXidnXA86gOHwE9mcx063wUM8HD7L0JphVjG5GK2L1kpwwGKSDNiw1qVf56
         1vRJ3t0KFgPn2S2yE1USNcYS5aUEDjpP/QwoNh00B6bRKrSNnWs7XZip60pt0QiOen
         Zq/8xw+rh47+I/IqCNXwSt9O/BgXt94dOvWqoRLpCgslDNeYGl8zWAM07vgxs3d5wG
         z8X7Y7e9JJTCQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-00043y-MP; Wed, 01 Feb 2023 11:16:53 +0100
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
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Jun Nie <jun.nie@linaro.org>,
        Georgi Djakov <georgi.djakov@linaro.org>
Subject: [PATCH 08/23] interconnect: qcom: rpm: fix registration race
Date:   Wed,  1 Feb 2023 11:15:44 +0100
Message-Id: <20230201101559.15529-9-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230201101559.15529-1-johan+linaro@kernel.org>
References: <20230201101559.15529-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Fixes: 62feb14ee8a3 ("interconnect: qcom: Consolidate interconnect RPM support")
Fixes: 30c8fa3ec61a ("interconnect: qcom: Add MSM8916 interconnect provider driver")
Cc: stable@vger.kernel.org	# 5.7
Cc: Jun Nie <jun.nie@linaro.org>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index da595059cafd..4d0997b210f7 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -502,7 +502,6 @@ int qnoc_probe(struct platform_device *pdev)
 	}
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = qcom_icc_set;
 	provider->pre_aggregate = qcom_icc_pre_bw_aggregate;
@@ -510,11 +509,7 @@ int qnoc_probe(struct platform_device *pdev)
 	provider->xlate_extended = qcom_icc_xlate_extended;
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		goto err_disable_clks;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -522,7 +517,7 @@ int qnoc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -536,19 +531,25 @@ int qnoc_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	/* Populate child NoC devices if any */
 	if (of_get_child_count(dev->of_node) > 0) {
 		ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
 		if (ret)
-			goto err;
+			goto err_deregister_provider;
 	}
 
 	return 0;
-err:
+
+err_deregister_provider:
+	icc_provider_deregister(provider);
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
 err_disable_clks:
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
@@ -560,9 +561,9 @@ int qnoc_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
-- 
2.39.1

