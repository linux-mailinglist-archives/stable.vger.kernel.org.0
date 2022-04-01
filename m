Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C174EECEA
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345758AbiDAMNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 08:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345596AbiDAMNv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 08:13:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96388277942;
        Fri,  1 Apr 2022 05:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29236619A3;
        Fri,  1 Apr 2022 12:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75431C34113;
        Fri,  1 Apr 2022 12:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648815120;
        bh=d0HYYSzBFiO0QLVb9RS/N/6MxRm6wrny8ms762htYcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDmZfqd32cjmkFbdHYnUqt6WfaCkfG4YZLT01LPwPrV+Xoe/nHmKZiJkFEyh0Pz9j
         2Sa3CXG9kAeyGZZ2GQKd4eS6HS1H9BbyU7eBbAYPXANO1jO0Tn5/R4t0bH5EpBwemr
         296B4sa1LqArG6LQncXsb6vONSBr9GujVQiWkhSnH2Vf/Z5lUWwemdod4s4cD3Mz2m
         tDjxQlHFib5P/4Bcwx8usAP2/vlLg6NqxKVlUMJp/nKfx3uzeqzI2cPTKxjlB828RL
         0jY8nd+q7ksSnBW4bwOuMgT4ZpvtsFbjyZxjKborUKq/30Y5Au/A9XJnnaeuWLUoQc
         HQZcU9ARguwaw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1naG8G-0001dO-Da; Fri, 01 Apr 2022 14:12:00 +0200
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
Subject: [PATCH 2/2] PCI: qcom: fix unbalanced phy init on probe errors
Date:   Fri,  1 Apr 2022 14:10:54 +0200
Message-Id: <20220401121054.6205-3-johan+linaro@kernel.org>
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

