Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4934EEE4D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 15:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345206AbiDANl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 09:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346420AbiDANl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 09:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DA637A02;
        Fri,  1 Apr 2022 06:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFAC2B824FB;
        Fri,  1 Apr 2022 13:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F58AC34110;
        Fri,  1 Apr 2022 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648820377;
        bh=t9eGMpJUVEKROPnLz05s5+olV1a9bFHicuFFZxP+Qh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gKEdt5uH5NduAHIbRNvwF/dP1bYkSHqdU/1TDyhirTw7XfGmNB1z21U3VdbNF+eJQ
         BCNSqEITdJPgyhidk3cAv6A2SFQ3ArLUuLRgs7Zn7ntOpHFnQENoFk7wjHSVZvKR8L
         zSr6ukLQOG9WdHBq8gCnvyhyHAGmKQ9bNcbRFGDur1S6Fy16xrBMvbIfTF1hENF64r
         FhbP23Odc13W11IKNOYOeeOVpHn6rF5cOqEixatiIoLTLByxFfMwmbmEIkLxVWE0Zm
         GqWVose2KE6P76f64B9kFKD8s9/dOeMhIs5fi0a2BaLaxCCm+1PfReAtAYAJa/mTLv
         Zqedr9QtMUuMg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1naHV3-0002kQ-Od; Fri, 01 Apr 2022 15:39:37 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-pci@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] PCI: qcom: Fix runtime PM imbalance on probe errors
Date:   Fri,  1 Apr 2022 15:38:53 +0200
Message-Id: <20220401133854.10421-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401133854.10421-1-johan+linaro@kernel.org>
References: <20220401133854.10421-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Drop the leftover pm_runtime_disable() calls from the late probe error
paths that would, for example, prevent runtime PM from being reenabled
after a probe deferral.

Fixes: 6e5da6f7d824 ("PCI: qcom: Fix error handling in runtime PM support")
Cc: stable@vger.kernel.org      # 4.20
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 20a0e6533a1c..0b0bd71f1bd2 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1616,17 +1616,14 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	pp->ops = &qcom_pcie_dw_ops;
 
 	ret = phy_init(pcie->phy);
-	if (ret) {
-		pm_runtime_disable(&pdev->dev);
+	if (ret)
 		goto err_pm_runtime_put;
-	}
 
 	platform_set_drvdata(pdev, pcie);
 
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		pm_runtime_disable(&pdev->dev);
 		goto err_pm_runtime_put;
 	}
 
-- 
2.35.1

