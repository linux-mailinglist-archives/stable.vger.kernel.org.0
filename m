Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844346AB7A2
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjCFH6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCFH5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBA01F906;
        Sun,  5 Mar 2023 23:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5139C60C5F;
        Mon,  6 Mar 2023 07:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B50C43171;
        Mon,  6 Mar 2023 07:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089457;
        bh=hBUdifa7+pnr/sHWJAmdxMSvzTM7t1JrzJMWGFd1KkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i21cVcncrcjzg9hLcrlRSGEh7r43IvPgLh1BSphm2AYcNs0f+bHEcWf7gnFMoyKZn
         JnqiP0lE86efUdMEDSEDsNvojEDmRxyw+tz6cP/2C0SH4ltppTQR4Pss1ROpg1/7vE
         +hKdxPWYexzI7hljm1T/eo/fmuo0/3rv86ct0RyAzIFs4eR3QKw1iKskUQYQori2tU
         L7Hj8BFAVbQSqgH9I8KqOOOdiscuZkRmPivBAqmRY6y64Iw5EXJL+rmfBeTiw/RuIz
         eFMPbNSkrbLPZDHNvhJQM/WMWSoB4muxbqBqQpa/PDyVm95sUbG1rphT4F6le6C4tE
         6X+yFVRwTAOOQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jd-0000ii-BO; Mon, 06 Mar 2023 08:58:17 +0100
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
        Dmitry Osipenko <digetx@gmail.com>
Subject: [PATCH v2 18/23] memory: tegra124-emc: fix interconnect registration race
Date:   Mon,  6 Mar 2023 08:56:46 +0100
Message-Id: <20230306075651.2449-19-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306075651.2449-1-johan+linaro@kernel.org>
References: <20230306075651.2449-1-johan+linaro@kernel.org>
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

Fixes: 380def2d4cf2 ("memory: tegra124: Support interconnect framework")
Cc: stable@vger.kernel.org      # 5.12
Cc: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/memory/tegra/tegra124-emc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index 85bc936c02f9..00ed2b6a0d1b 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -1351,15 +1351,13 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	emc->provider.aggregate = soc->icc_ops->aggregate;
 	emc->provider.xlate_extended = emc_of_icc_xlate_extended;
 
-	err = icc_provider_add(&emc->provider);
-	if (err)
-		goto err_msg;
+	icc_provider_init(&emc->provider);
 
 	/* create External Memory Controller node */
 	node = icc_node_create(TEGRA_ICC_EMC);
 	if (IS_ERR(node)) {
 		err = PTR_ERR(node);
-		goto del_provider;
+		goto err_msg;
 	}
 
 	node->name = "External Memory Controller";
@@ -1380,12 +1378,14 @@ static int tegra_emc_interconnect_init(struct tegra_emc *emc)
 	node->name = "External Memory (DRAM)";
 	icc_node_add(node, &emc->provider);
 
+	err = icc_provider_register(&emc->provider);
+	if (err)
+		goto remove_nodes;
+
 	return 0;
 
 remove_nodes:
 	icc_nodes_remove(&emc->provider);
-del_provider:
-	icc_provider_del(&emc->provider);
 err_msg:
 	dev_err(emc->dev, "failed to initialize ICC: %d\n", err);
 
-- 
2.39.2

