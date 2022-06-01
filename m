Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C292353A77E
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354124AbiFAOCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354363AbiFAOAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C81A3090;
        Wed,  1 Jun 2022 06:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B26B81AE6;
        Wed,  1 Jun 2022 13:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D6C36AE2;
        Wed,  1 Jun 2022 13:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091730;
        bh=84IfR7RwwFTk8qrcm0SBcSTrKK/dW3sr/Vog+1TxXdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KD7A1BQj0Znb0a+Qz+G0D565/InzpnzruRaISypvksWt0j036JtDt+Cw4TJ/eWUa8
         PoeF4+KykuUoR92W+80dLabV8lMLL4Z2v2K/IqpZiwK2lI+lUbV02a9W7MnAxSyBUf
         JDlNaTRGFCRgvz+hhAX99hGqWhubVB9B9YqI+8TtdqvjljdWTxYxu8QQa7Bp3+2jY2
         zbn+yrnJKhDhTT/VNoHj/64L8fnRk9yL/oAMjbyy8UCs6iclBOWRwokpAreRf1iRlz
         cFXkw2MDRpH6XnIlGpthDU3wq8Vi+aVLIzL8OR+T7CvkWBIz9/zt8p566qnbVu8ssc
         iimLsParL0cTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Parshuram Thombare <pthombar@cadence.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>, kishon@ti.com,
        tjoseph@cadence.com, bhelgaas@google.com,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 31/48] PCI: cadence: Clear FLR in device capabilities register
Date:   Wed,  1 Jun 2022 09:54:04 -0400
Message-Id: <20220601135421.2003328-31-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

