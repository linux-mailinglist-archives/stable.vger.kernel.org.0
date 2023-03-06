Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB536AB79D
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbjCFH55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCFH5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:57:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0E9193E6;
        Sun,  5 Mar 2023 23:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED4F960C24;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431BFC4339C;
        Mon,  6 Mar 2023 07:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678089456;
        bh=x7c24nw5EsIIq8C+xhEW9SJzZNdBgRpXVyxPgn2uGaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVoRdwHGmeMtMPQ5TjivD9CJFhUo4FyjgJ2AVZn2Q7Ow2PgektAAVOa68GROZsOFy
         KD2PyEtCXnorEv56biJX1Cbb5swuj6QHkmSatqlDTnz7Cd2lQXOuDDVKCbzZrhTd+F
         vMx+MP3RAFT4MfHY+ZogmNvwakF4yI7kH3TgKAuMpyM1cbWYPZDIIDij/gAxxvA70E
         Ed5OMQ5MfyVvBxNzB1VG58DODM9OEd7wNQpY2vOJll6d+3piWYQP8P2Ew+cn6YKlnG
         aZ45BA9wOVOTCyxa0S89b3ZbXsqTzL+7JDSaPJAS+NLvsnII/Tt+a+gM22cjeHF8W5
         6PLmvYqBb8w4w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pZ5jc-0000i5-9y; Mon, 06 Mar 2023 08:58:16 +0100
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
        Yassine Oudjana <y.oudjana@protonmail.com>
Subject: [PATCH v2 07/23] interconnect: qcom: rpm: fix probe PM domain error handling
Date:   Mon,  6 Mar 2023 08:56:35 +0100
Message-Id: <20230306075651.2449-8-johan+linaro@kernel.org>
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

Make sure to disable clocks also in case attaching the power domain
fails.

Fixes: 7de109c0abe9 ("interconnect: icc-rpm: Add support for bus power domain")
Cc: stable@vger.kernel.org      # 5.17
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/interconnect/qcom/icc-rpm.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpm.c b/drivers/interconnect/qcom/icc-rpm.c
index 91778cfcbc65..da595059cafd 100644
--- a/drivers/interconnect/qcom/icc-rpm.c
+++ b/drivers/interconnect/qcom/icc-rpm.c
@@ -498,8 +498,7 @@ int qnoc_probe(struct platform_device *pdev)
 
 	if (desc->has_bus_pd) {
 		ret = dev_pm_domain_attach(dev, true);
-		if (ret)
-			return ret;
+		goto err_disable_clks;
 	}
 
 	provider = &qp->provider;
@@ -514,8 +513,7 @@ int qnoc_probe(struct platform_device *pdev)
 	ret = icc_provider_add(provider);
 	if (ret) {
 		dev_err(dev, "error adding interconnect provider: %d\n", ret);
-		clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
-		return ret;
+		goto err_disable_clks;
 	}
 
 	for (i = 0; i < num_nodes; i++) {
@@ -550,8 +548,9 @@ int qnoc_probe(struct platform_device *pdev)
 	return 0;
 err:
 	icc_nodes_remove(provider);
-	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 	icc_provider_del(provider);
+err_disable_clks:
+	clk_bulk_disable_unprepare(qp->num_clks, qp->bus_clks);
 
 	return ret;
 }
-- 
2.39.2

