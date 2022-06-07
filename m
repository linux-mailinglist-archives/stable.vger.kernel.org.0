Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084095412E7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357252AbiFGTzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358481AbiFGTwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A7715E62C;
        Tue,  7 Jun 2022 11:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26241B82182;
        Tue,  7 Jun 2022 18:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F13C385A2;
        Tue,  7 Jun 2022 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626044;
        bh=84IfR7RwwFTk8qrcm0SBcSTrKK/dW3sr/Vog+1TxXdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex1WZo1IbjO0MeMKIZaZ9g4vTZRTLtOeZNVzwcBeJdgcm1Uh4khPw/3pP/lbBJyDj
         JjXx7+93n5tC7Difo7kYbNjDoCXPlDqPY1m+EuDUAjlYke+9aR+rf99IxWYI0AVg79
         pLrnQHT5sD707dn2VX0rq+mUBRBkJ5V/qJPOwPSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parshuram Thombare <pthombar@cadence.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 210/772] PCI: cadence: Clear FLR in device capabilities register
Date:   Tue,  7 Jun 2022 18:56:42 +0200
Message-Id: <20220607164955.220995330@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Parshuram Thombare <pthombar@cadence.com>

[ Upstream commit 95b00f68209e2bc9f2ee9126afcebab451e0e9d8 ]

Clear FLR (Function Level Reset) from device capabilities
registers for all physical functions.

During FLR, the Margining Lane Status and Margining Lane Control
registers should not be reset, as per PCIe specification.
However, the controller incorrectly resets these registers upon FLR.
This causes PCISIG compliance FLR test to fail. Hence preventing
all functions from advertising FLR support if flag quirk_disable_flr
is set.

Link: https://lore.kernel.org/r/1635165075-89864-1-git-send-email-pthombar@cadence.com
Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c     |  3 +++
 .../pci/controller/cadence/pcie-cadence-ep.c   | 18 +++++++++++++++++-
 drivers/pci/controller/cadence/pcie-cadence.h  |  3 +++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 768d33f9ebc8..a82f845cc4b5 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -69,6 +69,7 @@ struct j721e_pcie_data {
 	enum j721e_pcie_mode	mode;
 	unsigned int		quirk_retrain_flag:1;
 	unsigned int		quirk_detect_quiet_flag:1;
+	unsigned int		quirk_disable_flr:1;
 	u32			linkdown_irq_regfield;
 	unsigned int		byte_access_allowed:1;
 };
@@ -307,6 +308,7 @@ static const struct j721e_pcie_data j7200_pcie_rc_data = {
 static const struct j721e_pcie_data j7200_pcie_ep_data = {
 	.mode = PCI_MODE_EP,
 	.quirk_detect_quiet_flag = true,
+	.quirk_disable_flr = true,
 };
 
 static const struct j721e_pcie_data am64_pcie_rc_data = {
@@ -405,6 +407,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 			return -ENOMEM;
 
 		ep->quirk_detect_quiet_flag = data->quirk_detect_quiet_flag;
+		ep->quirk_disable_flr = data->quirk_disable_flr;
 
 		cdns_pcie = &ep->pcie;
 		cdns_pcie->dev = dev;
diff --git a/drivers/pci/controller/cadence/pcie-cadence-ep.c b/drivers/pci/controller/cadence/pcie-cadence-ep.c
index 88e05b9c2e5b..4b1c4bc4e003 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-ep.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-ep.c
@@ -565,7 +565,8 @@ static int cdns_pcie_ep_start(struct pci_epc *epc)
 	struct cdns_pcie_ep *ep = epc_get_drvdata(epc);
 	struct cdns_pcie *pcie = &ep->pcie;
 	struct device *dev = pcie->dev;
-	int ret;
+	int max_epfs = sizeof(epc->function_num_map) * 8;
+	int ret, value, epf;
 
 	/*
 	 * BIT(0) is hardwired to 1, hence function 0 is always enabled
@@ -573,6 +574,21 @@ static int cdns_pcie_ep_start(struct pci_epc *epc)
 	 */
 	cdns_pcie_writel(pcie, CDNS_PCIE_LM_EP_FUNC_CFG, epc->function_num_map);
 
+	if (ep->quirk_disable_flr) {
+		for (epf = 0; epf < max_epfs; epf++) {
+			if (!(epc->function_num_map & BIT(epf)))
+				continue;
+
+			value = cdns_pcie_ep_fn_readl(pcie, epf,
+					CDNS_PCIE_EP_FUNC_DEV_CAP_OFFSET +
+					PCI_EXP_DEVCAP);
+			value &= ~PCI_EXP_DEVCAP_FLR;
+			cdns_pcie_ep_fn_writel(pcie, epf,
+					CDNS_PCIE_EP_FUNC_DEV_CAP_OFFSET +
+					PCI_EXP_DEVCAP, value);
+		}
+	}
+
 	ret = cdns_pcie_start_link(pcie);
 	if (ret) {
 		dev_err(dev, "Failed to start link\n");
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index c8a27b6290ce..d9c785365da3 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -123,6 +123,7 @@
 
 #define CDNS_PCIE_EP_FUNC_MSI_CAP_OFFSET	0x90
 #define CDNS_PCIE_EP_FUNC_MSIX_CAP_OFFSET	0xb0
+#define CDNS_PCIE_EP_FUNC_DEV_CAP_OFFSET	0xc0
 #define CDNS_PCIE_EP_FUNC_SRIOV_CAP_OFFSET	0x200
 
 /*
@@ -357,6 +358,7 @@ struct cdns_pcie_epf {
  *        minimize time between read and write
  * @epf: Structure to hold info about endpoint function
  * @quirk_detect_quiet_flag: LTSSM Detect Quiet min delay set as quirk
+ * @quirk_disable_flr: Disable FLR (Function Level Reset) quirk flag
  */
 struct cdns_pcie_ep {
 	struct cdns_pcie	pcie;
@@ -372,6 +374,7 @@ struct cdns_pcie_ep {
 	spinlock_t		lock;
 	struct cdns_pcie_epf	*epf;
 	unsigned int		quirk_detect_quiet_flag:1;
+	unsigned int		quirk_disable_flr:1;
 };
 
 
-- 
2.35.1



