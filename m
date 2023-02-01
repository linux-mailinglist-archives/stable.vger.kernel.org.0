Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426116863BA
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 11:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbjBAKQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 05:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjBAKQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 05:16:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41EF3EFD5;
        Wed,  1 Feb 2023 02:16:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80AFB61751;
        Wed,  1 Feb 2023 10:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0EFC4332D;
        Wed,  1 Feb 2023 10:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675246592;
        bh=3ZA4545fQI8S0sUIbvtn7IX3oT84gFcfHkjp0CW1z7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnusNns8+ekGRz4eU3QdosvcxStBjz1nldTspeKVFXVxeH8ttnwipe47M45dIUapq
         XxeZhkwuZReM+XE1jUKbvMh0DLijmPNKTftg54EFrc3sawKeP9YvMdsv+6EKP/+Zlx
         3AUCcFpI5YKCQB4JbpcaaXgPEbJ9fq730UuwwF9jtgSMZJNhtU0XDBybCqN6YBWcD5
         1CP8dFvHNrjiNbVJLzIqXKnQ+bebDtyCFdW26szebi7VotkJzJsaVhhGlXpsh+xIM1
         tmpU45HuuAjT/BMBFl4B3IHuS1lESaJaBU0EC3uMeOOyepQ1Dkb9+atWoLt2xEMXEs
         rL/KdXfaisSvw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pNAAf-00043u-JB; Wed, 01 Feb 2023 11:16:53 +0100
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
        Yassine Oudjana <y.oudjana@protonmail.com>
Subject: [PATCH 07/23] interconnect: qcom: rpm: fix probe PM domain error handling
Date:   Wed,  1 Feb 2023 11:15:43 +0100
Message-Id: <20230201101559.15529-8-johan+linaro@kernel.org>
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

Make sure to disable clocks also in case attaching the power domain
fails.

Fixes: 7de109c0abe9 ("interconnect: icc-rpm: Add support for bus power domain")
Cc: stable@vger.kernel.org      # 5.17
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
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
2.39.1

