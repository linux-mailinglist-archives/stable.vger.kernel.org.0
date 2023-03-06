Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233436AB7CC
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCFH6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCFH5j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E33A1F483;
        Sun,  5 Mar 2023 23:57:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DFC60C36;
        Mon,  6 Mar 2023 07:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23DC43328;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=41sHnm8Gk66gNaueab+0gD7hJ3ZMMZErdrBEJqMHwTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNxpMUaorJMhr0+2zcZBGfNrOq7pCVxYxqfEzLa+aKxgRrq6Qe8c5roWNb0n0vbku
         HCLSOSHCtF8zhJ7PFt7YyXAckIJlLZR2Qmi6AcNL5UOYUx8Auu4mm+SlKgz8LZqYfx
         4oQtYQFwoKhXmOtuVQfGdpdQGNlDmqDYKgVeBdNdHzbZYuYAwLyccRPXyWeOG140Ro
         t9jkXcmNw5IoWGPsCakFpIgtL9c9+u4KUE/n3Pv+scOANswbLQrRGurd8Ve9N7fbew
         fiVHUZn7pAdwA2oJ6/DMzuyoXCTFt3bLLxz3kA9QbeodxAkGK/+SlTgw8qBf1s+Z6I
         zY5zM8nH9c5Hw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jc-0000iI-NI; Mon, 06 Mar 2023 08:58:16 +0100
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
        Brian Masney <bmasney@redhat.com>
Subject: [PATCH v2 11/23] interconnect: qcom: msm8974: fix registration race
Date:   Mon,  6 Mar 2023 08:56:39 +0100
Message-Id: <20230306075651.2449-12-johan+linaro@kernel.org>
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

Fixes: 4e60a9568dc6 ("interconnect: qcom: add msm8974 driver")
Cc: stable@vger.kernel.org      # 5.5
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/msm8974.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/interconnect/qcom/msm8974.c b/drivers/interconnect/qcom/msm8974.c
index 5ea192f1141d..1828deaca443 100644
--- a/drivers/interconnect/qcom/msm8974.c
+++ b/drivers/interconnect/qcom/msm8974.c
@@ -692,7 +692,6 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		return ret;
 
 	provider = &qp->provider;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->dev = dev;
 	provider->set = msm8974_icc_set;
 	provider->aggregate = icc_std_aggregate;
@@ -700,11 +699,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	provider->data = data;
 	provider->get_bw = msm8974_get_bw;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		goto err_disable_clks;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -712,7 +707,7 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 		node = icc_node_create(qnodes[i]->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err_del_icc;
+			goto err_remove_nodes;
 		}
 
 		node->name = qnodes[i]->name;
@@ -729,15 +724,16 @@ static int msm8974_icc_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err_remove_nodes;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 
-err_del_icc:
+err_remove_nodes:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
-
-err_disable_clks:
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
 	return ret;
@@ -747,9 +743,9 @@ static int msm8974_icc_remove(struct platform_device *pdev)
 {
 	struct msm8974_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
 	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
-- 
2.39.2

