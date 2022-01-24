Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B516499780
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448623AbiAXVNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446702AbiAXVJQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:09:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D42EA6147D;
        Mon, 24 Jan 2022 21:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9564C340E5;
        Mon, 24 Jan 2022 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058553;
        bh=JRhg2ihMM98ffXlxRr3jbRB4CO+4DG9nSjwHNStzLd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2g2fEjaDOfmoAvKNYfyuk8oB4tN/Zw03Cnhvu3wUqeu8EvLclT6H7Z5yu9NSwZDe7
         KgBMz8+H2R6P+OCkgluCg7mDLD6ZJi3LLFVL9jrFmh82poaamYFnqKWyZeecQwoJDr
         MWnDi64pbG/Hj23R0dGERPRCZezISDRuC+FWFuGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jian-Hong Pan <jhp@endlessos.org>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0326/1039] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Date:   Mon, 24 Jan 2022 19:35:15 +0100
Message-Id: <20220124184136.265278530@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 24f5e38a13b5ae2b6105cda8bb47c19108e62a9a ]

Many Intel based platforms face system random freeze after commit
9e2fd29864c5 ("rtw88: add napi support").

The commit itself shouldn't be the culprit. My guess is that the 8821CE
only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
extremely slow. Eventually the RX ring becomes messed up:
[ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status

Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
the driver to resolve the issue.

Fixes: 9e2fd29864c5 ("rtw88: add napi support")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
BugLink: https://bugs.launchpad.net/bugs/1927808
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Acked-by: Jian-Hong Pan <jhp@endlessos.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20211215114635.333767-1-kai.heng.feng@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 70 +++++++-----------------
 drivers/net/wireless/realtek/rtw88/pci.h |  2 +
 2 files changed, 21 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 3b367c9085eba..08cf66141889b 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
-#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1409,7 +1408,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 	 * throughput. This is probably because the ASPM behavior slightly
 	 * varies from different SOC.
 	 */
-	if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
+	if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
+		return;
+
+	if ((enter && atomic_dec_if_positive(&rtwpci->link_usage) == 0) ||
+	    (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
 		rtw_pci_aspm_set(rtwdev, enter);
 }
 
@@ -1658,6 +1661,9 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 					      priv);
 	int work_done = 0;
 
+	if (rtwpci->rx_no_aspm)
+		rtw_pci_link_ps(rtwdev, false);
+
 	while (work_done < budget) {
 		u32 work_done_once;
 
@@ -1681,6 +1687,8 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
 			napi_schedule(napi);
 	}
+	if (rtwpci->rx_no_aspm)
+		rtw_pci_link_ps(rtwdev, true);
 
 	return work_done;
 }
@@ -1702,59 +1710,13 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 	netif_napi_del(&rtwpci->napi);
 }
 
-enum rtw88_quirk_dis_pci_caps {
-	QUIRK_DIS_PCI_CAP_MSI,
-	QUIRK_DIS_PCI_CAP_ASPM,
-};
-
-static int disable_pci_caps(const struct dmi_system_id *dmi)
-{
-	uintptr_t dis_caps = (uintptr_t)dmi->driver_data;
-
-	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
-		rtw_disable_msi = true;
-	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_ASPM))
-		rtw_pci_disable_aspm = true;
-
-	return 1;
-}
-
-static const struct dmi_system_id rtw88_pci_quirks[] = {
-	{
-		.callback = disable_pci_caps,
-		.ident = "Protempo Ltd L116HTN6SPW",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{
-		.callback = disable_pci_caps,
-		.ident = "HP HP Pavilion Laptop 14-ce0xxx",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Laptop 14-ce0xxx"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{
-		.callback = disable_pci_caps,
-		.ident = "HP HP 250 G7 Notebook PC",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP 250 G7 Notebook PC"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{}
-};
-
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
 	struct ieee80211_hw *hw;
 	struct rtw_dev *rtwdev;
+	struct rtw_pci *rtwpci;
 	int drv_data_size;
 	int ret;
 
@@ -1772,6 +1734,9 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	rtwdev->hci.ops = &rtw_pci_ops;
 	rtwdev->hci.type = RTW_HCI_TYPE_PCIE;
 
+	rtwpci = (struct rtw_pci *)rtwdev->priv;
+	atomic_set(&rtwpci->link_usage, 1);
+
 	ret = rtw_core_init(rtwdev);
 	if (ret)
 		goto err_release_hw;
@@ -1800,7 +1765,10 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
-	dmi_check_system(rtw88_pci_quirks);
+	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
+	if (pdev->device == 0xc821 && bridge->vendor == PCI_VENDOR_ID_INTEL)
+		rtwpci->rx_no_aspm = true;
+
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 66f78eb7757c5..0c37efd8c66fa 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -223,6 +223,8 @@ struct rtw_pci {
 	struct rtw_pci_tx_ring tx_rings[RTK_MAX_TX_QUEUE_NUM];
 	struct rtw_pci_rx_ring rx_rings[RTK_MAX_RX_QUEUE_NUM];
 	u16 link_ctrl;
+	atomic_t link_usage;
+	bool rx_no_aspm;
 	DECLARE_BITMAP(flags, NUM_OF_RTW_PCI_FLAGS);
 
 	void __iomem *mmap;
-- 
2.34.1



