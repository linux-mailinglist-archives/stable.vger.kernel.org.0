Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064BE4EECEC
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 14:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345767AbiDAMNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 08:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245312AbiDAMNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 08:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669FE276FBA;
        Fri,  1 Apr 2022 05:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03D1F6198A;
        Fri,  1 Apr 2022 12:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76EC2BBE4;
        Fri,  1 Apr 2022 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648815120;
        bh=t9eGMpJUVEKROPnLz05s5+olV1a9bFHicuFFZxP+Qh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bjYoL2519OSX7II0irGkZbL3pB0mQvOFPQoFH1wKxZyh8XvIqHzgRUiT3sxcZxCGj
         7HHOqv41NYd6QJ/QjWaieSIK/yWPIrGcKpGxjbxUobDbwev1CB0GVjfaGT6w3QNetZ
         fYz3WMXjEle9UmXPCLcH3toKtinFE6WhBc0Zkr8x5/bbmiuyyyjZNzcqy41ii+3e2y
         +I8P5Av2VgHrBoXa3L4FE+FNKvgWP1DgheES/r2QAzekvJ8xKsTdWHbu/+FO2iQgjt
         9Us9kT99AnPoY41VKCem+BfAWZmxwSq+O1M80qd0msmCGo7jUSe1A7PfKwNbK6g6IZ
         OOvph/GG+JMUA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1naG8G-0001dM-Ad; Fri, 01 Apr 2022 14:12:00 +0200
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
Subject: [PATCH 1/2] PCI: qcom: fix runtime PM imbalance on probe errors
Date:   Fri,  1 Apr 2022 14:10:53 +0200
Message-Id: <20220401121054.6205-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401121054.6205-1-johan+linaro@kernel.org>
References: <20220401121054.6205-1-johan+linaro@kernel.org>
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

