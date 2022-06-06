Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B65053E6CF
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236678AbiFFMXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236680AbiFFMXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:23:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544C92A278
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BA5B81920
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553BFC3411C;
        Mon,  6 Jun 2022 12:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654518190;
        bh=exZvUuXpOvASJBxAHBXg3k+wXSqYzQ2/6t5gbq3vkZ4=;
        h=Subject:To:Cc:From:Date:From;
        b=Tfeb/fZb/1lkta5b+xlAIPwKqTeaLvrGk83OUA2Dmy3Mkpl3WJUQiIte9/Ee/iAeH
         KHHRWUGUR7zZDWJWvvILar5xqpAzr8Z+CQDSFmv69L5Zb+hRk4ZcUHtPTfsfgMyt76
         KlTPmuHjxaAiXfSgzX1ogveVn/aVkt9353q3P8qU=
Subject: FAILED: patch "[PATCH] PCI: qcom: Fix unbalanced PHY init on probe errors" failed to apply to 4.9-stable tree
To:     johan+linaro@kernel.org, bhelgaas@google.com,
        lorenzo.pieralisi@arm.com, manivannan.sadhasivam@linaro.org,
        svarbanov@mm-sol.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:23:08 +0200
Message-ID: <165451818820319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83013631f0f9961416abd812e228c8efbc2f6069 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Fri, 1 Apr 2022 15:38:54 +0200
Subject: [PATCH] PCI: qcom: Fix unbalanced PHY init on probe errors

Undo the PHY initialisation (e.g. balance runtime PM) if host
initialisation fails during probe.

Link: https://lore.kernel.org/r/20220401133854.10421-3-johan+linaro@kernel.org
Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org      # 4.5

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 9191be96d627..2e5464edc36e 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1631,11 +1631,13 @@ static int qcom_pcie_probe(struct platform_device *pdev)
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

