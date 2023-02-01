Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD546863D3
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbjBAKQ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjBAKQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24DA4F86D;
        Wed,  1 Feb 2023 02:16:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D365DB82159;
        Wed,  1 Feb 2023 10:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64F6C43335;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=JZ8Di4CzHKn16RcSbx8LP5dTbxPMPcpqLRNP1ZpuGGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vn1HFGVf1GAUTFcDCThdyvv6IHi6lO71eQTmwJBKVGgav8zteruUU9TSwhFHumKhX
         3S7b07Ph+A5au0m2gtIe490ppkXc436Rk7/d0MVjWJk5sTvpBQ3ybMithQ69RSbmqg
         hu2was/8X4btp97sAK9Efz4SOCrYpKz51hB9bgh67ewmesJ0XrxrDB3tMt5QqgBVw3
         +ui/cF6i9ucFzGHeITYOEASwkNccGa6gZsWS3corWPKGC54JR0c0T+IWv7komicUAv
         xqzvgNZMFr5WfK3DvbWIO/l4pkFK/srEwjIRiLkag/XpaVPqGgsxW0aDPmn1c3JOsz
         2fWd8T4wxjQvA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-000444-SC; Wed, 01 Feb 2023 11:16:53 +0100
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
Subject: [PATCH 10/23] interconnect: qcom: rpmh: fix registration race
Date:   Wed,  1 Feb 2023 11:15:46 +0100
Message-Id: <20230201101559.15529-11-johan+linaro@kernel.org>
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
can specifically cause racing DT lookups to fail.

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Cc: stable@vger.kernel.org      # 5.7
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/icc-rpmh.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index 5168bbf3d92f..fdb5e58e408b 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -192,9 +192,10 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	provider->pre_aggregate = qcom_icc_pre_aggregate;
 	provider->aggregate = qcom_icc_aggregate;
 	provider->xlate_extended = qcom_icc_xlate_extended;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
+	icc_provider_init(provider);
+
 	qp->dev = dev;
 	qp->bcms = desc->bcms;
 	qp->num_bcms = desc->num_bcms;
@@ -203,10 +204,6 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	if (IS_ERR(qp->voter))
 		return PTR_ERR(qp->voter);
 
-	ret = icc_provider_add(provider);
-	if (ret)
-		return ret;
-
 	for (i = 0; i < qp->num_bcms; i++)
 		qcom_icc_bcm_init(qp->bcms[i], dev);
 
@@ -218,7 +215,7 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 		node = icc_node_create(qn->id);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
-			goto err;
+			goto err_remove_nodes;
 		}
 
 		node->name = qn->name;
@@ -232,19 +229,27 @@ int qcom_icc_rpmh_probe(struct platform_device *pdev)
 	}
 
 	data->num_nodes = num_nodes;
+
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
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_rpmh_probe);
@@ -253,8 +258,8 @@ int qcom_icc_rpmh_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
-- 
2.39.1

