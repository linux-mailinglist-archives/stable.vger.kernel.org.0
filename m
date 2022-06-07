Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41613540F1B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352717AbiFGTBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353739AbiFGTAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:00:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4B5150A31;
        Tue,  7 Jun 2022 11:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3A26618FE;
        Tue,  7 Jun 2022 18:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDA8C385A5;
        Tue,  7 Jun 2022 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625072;
        bh=8vZKfXai4OCPKtIGxrgBFOVUVu2qKtQk1KA+AD/xiQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owHzVgP9gYfFeZegERT1Q79/EQbsLZV3oUzlymijP5aF4N56DFk4MY1+j2+KvB/nB
         cQAvoEDVbS166e85jkGTnUGwh3alJuKVQYw84q+KqEPaukVy+FyX8wAocB74RLHQBh
         22slkSy0qh60sQYzGWakIR2KU9sY+/NypeoLT5Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 555/667] PCI: qcom: Fix runtime PM imbalance on probe errors
Date:   Tue,  7 Jun 2022 19:03:40 +0200
Message-Id: <20220607164951.344404851@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 87d83b96c8d6c6c2d2096bd0bdba73bcf42b8ef0 upstream.

Drop the leftover pm_runtime_disable() calls from the late probe error
paths that would, for example, prevent runtime PM from being reenabled
after a probe deferral.

Link: https://lore.kernel.org/r/20220401133854.10421-2-johan+linaro@kernel.org
Fixes: 6e5da6f7d824 ("PCI: qcom: Fix error handling in runtime PM support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: stable@vger.kernel.org      # 4.20
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1521,17 +1521,14 @@ static int qcom_pcie_probe(struct platfo
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
 


