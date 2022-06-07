Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B56B6540737
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347661AbiFGRo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347828AbiFGRnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8060F12E31A;
        Tue,  7 Jun 2022 10:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23C97B80B66;
        Tue,  7 Jun 2022 17:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7744EC385A5;
        Tue,  7 Jun 2022 17:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623310;
        bh=p6G5k0aCFRddU257f0XJhVBR0jWO4D2xjWh9swVtrnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cisCLmrlcdFdSduEPK7nFLExORGaXsuaQuc5ksSWQFsaNG++s4/85Yhnsx6Fl6pBA
         nsJLoeg5JIaksa/Mb0sbpwV8EmCcGqhAGq/YN9UjF46DGTFVajLES7aWh/QVQZ899y
         LfJL8vAruIwAQ9IwszBVVbtYqbmY2A13UgsSCFq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 5.10 370/452] PCI: qcom: Fix unbalanced PHY init on probe errors
Date:   Tue,  7 Jun 2022 19:03:47 +0200
Message-Id: <20220607164919.590818828@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
@@ -1451,11 +1451,13 @@ static int qcom_pcie_probe(struct platfo
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


