Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9B04EEE4C
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 15:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346430AbiDANla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346421AbiDANl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 09:41:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137E2377EC;
        Fri,  1 Apr 2022 06:39:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C82A5B824FC;
        Fri,  1 Apr 2022 13:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C567C34111;
        Fri,  1 Apr 2022 13:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648820377;
        bh=d0HYYSzBFiO0QLVb9RS/N/6MxRm6wrny8ms762htYcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRC13yr1gIPBER1tskAq3wkJXADYdIKDycf5He/+4t3FGoVjKP2u9bmZEJW3G/lsa
         xP3rQFFhZEWj/YtPn6izHtNtDwKCVc60+pz1gpuTLsPZIlxV5nY1lv4faSqIwRNPQQ
         v9HoW2+/Jz4Nm4hjQDE44wZ8y1MGMN157XQDbgoJkE0P+a6accW/f4ao6ETSbazf/9
         RS6DAi9bsk42wM8bfqNA8dCGQlHFNntXcmBiP5vUwYdsDjftPighARN1xOZl/T3d1x
         P7QZctG4PTuGTaGFgyhmJfwksmP6N2IHnWpKo56YkDqdNqkFjr+Ue4gK+uFkxl/xSr
         9UtrKtYRb+kSw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1naHV3-0002kc-R7; Fri, 01 Apr 2022 15:39:37 +0200
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
Subject: [PATCH v2 2/2] PCI: qcom: Fix unbalanced PHY init on probe errors
Date:   Fri,  1 Apr 2022 15:38:54 +0200
Message-Id: <20220401133854.10421-3-johan+linaro@kernel.org>
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

Make sure to undo the PHY initialisation (e.g. balance runtime PM) in
case host initialisation fails during probe.

Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Cc: stable@vger.kernel.org      # 4.5
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 0b0bd71f1bd2..df47986bda29 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1624,11 +1624,13 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		goto err_pm_runtime_put;
+		goto err_phy_exit;
 	}
 
 	return 0;
 
+err_phy_exit:
+	phy_exit(pcie->phy);
 err_pm_runtime_put:
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
-- 
2.35.1

