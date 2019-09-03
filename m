Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9C9A6FCD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730953AbfICQ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:27:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730944AbfICQ1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095252343A;
        Tue,  3 Sep 2019 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528066;
        bh=sSeRt6p8HhSAsd59d96a0VCNoOTrr83ZilQQZ+iDj84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mv3rJM/vgQA2E0imytNrAcX/LgT4tUPdYYO3Nw4HeR+xJBC+kM3Sd1WLlucCq4sO9
         aAnYneEyMwTZC6HRClXXdEuYOPbskFPSSJpAdaZVu4WyOReopctMkmmrMdzSXiTLhf
         Fv8Vh7iJ+3s7ZecrDqK2Dm18YYoc1IvbY6AqTs3I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 081/167] PCI: qcom: Fix error handling in runtime PM support
Date:   Tue,  3 Sep 2019 12:23:53 -0400
Message-Id: <20190903162519.7136-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 6e5da6f7d82474e94c2d4a38cf9ca4edbb3e03a0 ]

The driver does not cope with the fact that probe can fail in a number
of cases after enabling runtime PM on the device; this results in
warnings about "Unbalanced pm_runtime_enable". Furthermore if probe
fails after invoking qcom_pcie_host_init() the power-domain will be left
referenced.

As it is not possible for the error handling in qcom_pcie_host_init() to
handle errors happening after returning from that function the
pm_runtime_get_sync() is moved to qcom_pcie_probe() as well.

Fixes: 854b69efbdd2 ("PCI: qcom: add runtime pm support to pcie_port")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
[lorenzo.pieralisi@arm.com: updated commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 56 ++++++++++++++++++--------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 87a8887fd4d3e..79f06c76ae071 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1091,7 +1091,6 @@ static int qcom_pcie_host_init(struct pcie_port *pp)
 	struct qcom_pcie *pcie = to_qcom_pcie(pci);
 	int ret;
 
-	pm_runtime_get_sync(pci->dev);
 	qcom_ep_reset_assert(pcie);
 
 	ret = pcie->ops->init(pcie);
@@ -1128,7 +1127,6 @@ static int qcom_pcie_host_init(struct pcie_port *pp)
 	phy_power_off(pcie->phy);
 err_deinit:
 	pcie->ops->deinit(pcie);
-	pm_runtime_put(pci->dev);
 
 	return ret;
 }
@@ -1218,6 +1216,12 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	pm_runtime_enable(dev);
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0) {
+		pm_runtime_disable(dev);
+		return ret;
+	}
+
 	pci->dev = dev;
 	pci->ops = &dw_pcie_ops;
 	pp = &pci->pp;
@@ -1227,44 +1231,56 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	pcie->ops = of_device_get_match_data(dev);
 
 	pcie->reset = devm_gpiod_get_optional(dev, "perst", GPIOD_OUT_LOW);
-	if (IS_ERR(pcie->reset))
-		return PTR_ERR(pcie->reset);
+	if (IS_ERR(pcie->reset)) {
+		ret = PTR_ERR(pcie->reset);
+		goto err_pm_runtime_put;
+	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "parf");
 	pcie->parf = devm_ioremap_resource(dev, res);
-	if (IS_ERR(pcie->parf))
-		return PTR_ERR(pcie->parf);
+	if (IS_ERR(pcie->parf)) {
+		ret = PTR_ERR(pcie->parf);
+		goto err_pm_runtime_put;
+	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dbi");
 	pci->dbi_base = devm_pci_remap_cfg_resource(dev, res);
-	if (IS_ERR(pci->dbi_base))
-		return PTR_ERR(pci->dbi_base);
+	if (IS_ERR(pci->dbi_base)) {
+		ret = PTR_ERR(pci->dbi_base);
+		goto err_pm_runtime_put;
+	}
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "elbi");
 	pcie->elbi = devm_ioremap_resource(dev, res);
-	if (IS_ERR(pcie->elbi))
-		return PTR_ERR(pcie->elbi);
+	if (IS_ERR(pcie->elbi)) {
+		ret = PTR_ERR(pcie->elbi);
+		goto err_pm_runtime_put;
+	}
 
 	pcie->phy = devm_phy_optional_get(dev, "pciephy");
-	if (IS_ERR(pcie->phy))
-		return PTR_ERR(pcie->phy);
+	if (IS_ERR(pcie->phy)) {
+		ret = PTR_ERR(pcie->phy);
+		goto err_pm_runtime_put;
+	}
 
 	ret = pcie->ops->get_resources(pcie);
 	if (ret)
-		return ret;
+		goto err_pm_runtime_put;
 
 	pp->ops = &qcom_pcie_dw_ops;
 
 	if (IS_ENABLED(CONFIG_PCI_MSI)) {
 		pp->msi_irq = platform_get_irq_byname(pdev, "msi");
-		if (pp->msi_irq < 0)
-			return pp->msi_irq;
+		if (pp->msi_irq < 0) {
+			ret = pp->msi_irq;
+			goto err_pm_runtime_put;
+		}
 	}
 
 	ret = phy_init(pcie->phy);
 	if (ret) {
 		pm_runtime_disable(&pdev->dev);
-		return ret;
+		goto err_pm_runtime_put;
 	}
 
 	platform_set_drvdata(pdev, pcie);
@@ -1273,10 +1289,16 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
 		pm_runtime_disable(&pdev->dev);
-		return ret;
+		goto err_pm_runtime_put;
 	}
 
 	return 0;
+
+err_pm_runtime_put:
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
+
+	return ret;
 }
 
 static const struct of_device_id qcom_pcie_match[] = {
-- 
2.20.1

