Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2748E6863C8
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjBAKQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbjBAKQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CC22ED54;
        Wed,  1 Feb 2023 02:16:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF031B82156;
        Wed,  1 Feb 2023 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589F1C4339B;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=phHoojYppOTL0BiqO+RWcjhDeLQFCJqdWQpamIw1UYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ultdZ0aUrQ4K3ppR/0jvADGGZ6Yt7OnPldEhMZ7fcTrfod0KotahBnoqUEkXZjoQf
         0ldGn30n6CXMrmVLNe2z1vle2vGUHBFscqqK7lMqVGKC0ZzXwlWCrX6njOchd45Oq4
         7Fsc+06f3T6XXMUczWAzBOp2827TZjEfU9lddcjtOyGeY6haoQuAn/odnj/H667skH
         w1YEjDeeqJOYpOGN/YIVHoFtu7O9RCTd52Td2hOpcvw8COiFRlbqw+JKZkBCLv5V7a
         3syM1X8JvkYNMbhK43LqYv7LGRywNFoMAz1fL1f4cMWpc9GmtIiY04HPlU2KseqKmM
         2p5k5jMzxb17g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-00043q-DP; Wed, 01 Feb 2023 11:16:53 +0100
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
Subject: [PATCH 05/23] interconnect: qcom: osm-l3: fix registration race
Date:   Wed,  1 Feb 2023 11:15:41 +0100
Message-Id: <20230201101559.15529-6-johan+linaro@kernel.org>
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
can specifically cause racing DT lookups to fail:

	of_icc_xlate_onecell: invalid index 0
	cpu cpu0: error -EINVAL: error finding src node
	cpu cpu0: dev_pm_opp_of_find_icc_paths: Unable to get path0: -22
	qcom-cpufreq-hw: probe of 18591000.cpufreq failed with error -22

Switch to using the new API where the provider is not registered until
after it has been fully initialised.

Fixes: 5bc9900addaf ("interconnect: qcom: Add OSM L3 interconnect provider support")
Cc: stable@vger.kernel.org      # 5.7
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/osm-l3.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 5fa171087425..3a1cbfe3e481 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -158,8 +158,8 @@ static int qcom_osm_l3_remove(struct platform_device *pdev)
 {
 	struct qcom_osm_l3_icc_provider *qp = platform_get_drvdata(pdev);
 
+	icc_provider_deregister(&qp->provider);
 	icc_nodes_remove(&qp->provider);
-	icc_provider_del(&qp->provider);
 
 	return 0;
 }
@@ -245,14 +245,9 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	provider->set = qcom_osm_l3_set;
 	provider->aggregate = icc_std_aggregate;
 	provider->xlate = of_icc_xlate_onecell;
-	INIT_LIST_HEAD(&provider->nodes);
 	provider->data = data;
 
-	ret = icc_provider_add(provider);
-	if (ret) {
-		dev_err(&pdev->dev, "error adding interconnect provider\n");
-		return ret;
-	}
+	icc_provider_init(provider);
 
 	for (i = 0; i < num_nodes; i++) {
 		size_t j;
@@ -275,12 +270,15 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	}
 	data->num_nodes = num_nodes;
 
+	ret = icc_provider_register(provider);
+	if (ret)
+		goto err;
+
 	platform_set_drvdata(pdev, qp);
 
 	return 0;
 err:
 	icc_nodes_remove(provider);
-	icc_provider_del(provider);
 
 	return ret;
 }
-- 
2.39.1

