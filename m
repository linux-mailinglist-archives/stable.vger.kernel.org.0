Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3C1546637
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347985AbiFJMEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 08:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347752AbiFJMEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:04:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D8F193E4;
        Fri, 10 Jun 2022 05:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A38B6B834E0;
        Fri, 10 Jun 2022 12:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FECC3411D;
        Fri, 10 Jun 2022 12:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654862661;
        bh=q29Sh8OaZZnjTZf4cfd9bieOC8BLYRFYnh2YtXknEQs=;
        h=From:To:Cc:Subject:Date:From;
        b=YHYc9HR0FWAu3R/i2PNgPZXqUoX/2Mv13LjYTzteYGKaiqmIdWGzdfiX/5l8szL39
         J1JxpDpN9bearnk8nZaOK39LmBiJbW/cc/JDRgqZ7ha6bxBdsYGdq+LiDTo9dLOovh
         v+nEfprR3nynbRN/ZEGdkZ+0/23GyGzB65rYLFGgjEUY5h5IVrTSDcmHsgv538lYit
         NDXZWg2gMnc3FJyfTezyMKsBKZjBDfN+1Qa3ANPN2uQ7vklE+ts0eOOD4AlURlnHwg
         M5qv5wGdExkSg/pEohXx2n2ln4hjflkJOHkTxFzz/ub3yoIZ0AaVGuW2OA52Coq6g7
         7vNT6JWOg/dhA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1nzdNB-0002li-B5; Fri, 10 Jun 2022 14:04:17 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH stable-4.9] PCI: qcom: Fix unbalanced PHY init on probe errors
Date:   Fri, 10 Jun 2022 14:04:11 +0200
Message-Id: <20220610120411.10619-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

commit 83013631f0f9961416abd812e228c8efbc2f6069 upstream.

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
[ johan: adjust context to 4.9 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/pci/host/pcie-qcom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/host/pcie-qcom.c b/drivers/pci/host/pcie-qcom.c
index aeb46f8c7087..4e21ca3c067e 100644
--- a/drivers/pci/host/pcie-qcom.c
+++ b/drivers/pci/host/pcie-qcom.c
@@ -562,10 +562,15 @@ static int qcom_pcie_probe(struct platform_device *pdev)
 	ret = dw_pcie_host_init(pp);
 	if (ret) {
 		dev_err(dev, "cannot initialize host\n");
-		return ret;
+		goto err_phy_exit;
 	}
 
 	return 0;
+
+err_phy_exit:
+	phy_exit(pcie->phy);
+
+	return ret;
 }
 
 static const struct of_device_id qcom_pcie_match[] = {
-- 
2.35.1

