Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478845938E0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344062AbiHOTTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344665AbiHOTRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD00E3C8D5;
        Mon, 15 Aug 2022 11:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0620C61024;
        Mon, 15 Aug 2022 18:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56CBC433D6;
        Mon, 15 Aug 2022 18:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588713;
        bh=zQsLFdj2P+OSam3i5qL4NMoAljPhyjGZE2whu/cO+EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7bjfWJyzpoq/dMS2yTUYfOt+NnQhllx1lvhXN2cKV2YD/wcimsfp2Y4PErqlRf4a
         w92bVE2kuhd8NjZg4nXn284JOLtR6Sy18o+nuUEuLDW6COLeanp+RtpCHa9mO70PU2
         fpltHwaS2YW/mXDKxzh37+4FOe3Go6albetBRN68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/779] PCI: dwc: Disable outbound windows only for controllers using iATU
Date:   Mon, 15 Aug 2022 20:01:45 +0200
Message-Id: <20220815180356.999594058@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit d60a2e281e9de2b2f67343b2e39417ca0f4fd54e ]

Some DWC-based controllers (e.g., pcie-al.c and pci-keystone.c, identified
by the fact that they override the default dw_child_pcie_ops) use their own
address translation approach instead of the DWC internal ATU (iATU).  For
those controllers, skip disabling the iATU outbound windows.

[bhelgaas: commit log, update multiple window comment]
Fixes: 458ad06c4cdd ("PCI: dwc: Ensure all outbound ATU windows are reset")
Link: https://lore.kernel.org/r/20220624143428.8334-4-Sergey.Semin@baikalelectronics.ru
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware-host.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 3200e906bcda..7cd4593ad12f 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -536,7 +536,6 @@ static struct pci_ops dw_pcie_ops = {
 
 void dw_pcie_setup_rc(struct pcie_port *pp)
 {
-	int i;
 	u32 val, ctrl, num_ctrls;
 	struct dw_pcie *pci = to_dw_pcie_from_pp(pp);
 
@@ -588,19 +587,22 @@ void dw_pcie_setup_rc(struct pcie_port *pp)
 		PCI_COMMAND_MASTER | PCI_COMMAND_SERR;
 	dw_pcie_writel_dbi(pci, PCI_COMMAND, val);
 
-	/* Ensure all outbound windows are disabled so there are multiple matches */
-	for (i = 0; i < pci->num_ob_windows; i++)
-		dw_pcie_disable_atu(pci, i, DW_PCIE_REGION_OUTBOUND);
-
 	/*
 	 * If the platform provides its own child bus config accesses, it means
 	 * the platform uses its own address translation component rather than
 	 * ATU, so we should not program the ATU here.
 	 */
 	if (pp->bridge->child_ops == &dw_child_pcie_ops) {
-		int atu_idx = 0;
+		int i, atu_idx = 0;
 		struct resource_entry *entry;
 
+		/*
+		 * Disable all outbound windows to make sure a transaction
+		 * can't match multiple windows.
+		 */
+		for (i = 0; i < pci->num_ob_windows; i++)
+			dw_pcie_disable_atu(pci, i, DW_PCIE_REGION_OUTBOUND);
+
 		/* Get last memory resource entry */
 		resource_list_for_each_entry(entry, &pp->bridge->windows) {
 			if (resource_type(entry->res) != IORESOURCE_MEM)
-- 
2.35.1



