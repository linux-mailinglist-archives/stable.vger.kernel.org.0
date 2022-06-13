Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449BD549264
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352799AbiFMLWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353953AbiFMLUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BB53BBFB;
        Mon, 13 Jun 2022 03:42:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B20E1B80E94;
        Mon, 13 Jun 2022 10:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AB9C34114;
        Mon, 13 Jun 2022 10:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116917;
        bh=XIh2g1nuffDH/ZtwYf71FH0zjt5fA2pQREW7lsH2zU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9eR81LLH/vtDBe59OGicUn1afzL9MgsjlL6b1G3MwQSAEGEU27AoDfWCwVaNj+0p
         CUlDFOe2u2pRcHKnnqfLPljNqO9Oul37Z9R2L/CSCnnRPVrQTk5VXvfzpuR4phTQoe
         EL1kRo/rlYzBsFG/WbWXQHsUUu/FnBcx6SyPFJb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5.4 232/411] PCI: qcom: Fix unbalanced PHY init on probe errors
Date:   Mon, 13 Jun 2022 12:08:25 +0200
Message-Id: <20220613094935.743751300@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1351,11 +1351,13 @@ static int qcom_pcie_probe(struct platfo
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


