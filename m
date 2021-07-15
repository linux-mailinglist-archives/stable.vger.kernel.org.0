Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F63CA8D3
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241694AbhGOTDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243238AbhGOTBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:01:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7714561404;
        Thu, 15 Jul 2021 18:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375517;
        bh=u8Ivap6Yz4KRmQsyQWImKIcEhtJI8QScwssbNbl8UkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pO5cRRVRSaYvivihq89xeN53KI55uSJra8GK1v3AogrequZwT6wjoN+8qL1iy9lcU
         jfss9gmdgFBRTe/sa8IrUEPnCl0Eo+OT+z+wCaxK/kQi42peAp2rMy7j180aJQstWH
         kTll0dL9SbKZ7W7r9AQyLaOOJI9p6L05uZSsIIgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Szabo <psz2036@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 122/242] rtw88: add quirks to disable pci capabilities
Date:   Thu, 15 Jul 2021 20:38:04 +0200
Message-Id: <20210715182614.539447350@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 956c6d4f20c5446727e0c912dd8f527f2dc7b779 ]

8821CE with ASPM cannot work properly on Protempo Ltd L116HTN6SPW. Add a
quirk to disable the cap.

The reporter describes the symptom is that this module (driver) causes
frequent freezes, randomly but usually within a few minutes of running
(thus very soon after boot): screen display remains frozen, no response
to either keyboard or mouse input. All I can do is to hold the power
button to power off, then reboot.

Reported-by: Paul Szabo <psz2036@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210607012254.6306-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 6b5c885798a4..e5110d2cbc1d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1598,6 +1599,36 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 	netif_napi_del(&rtwpci->napi);
 }
 
+enum rtw88_quirk_dis_pci_caps {
+	QUIRK_DIS_PCI_CAP_MSI,
+	QUIRK_DIS_PCI_CAP_ASPM,
+};
+
+static int disable_pci_caps(const struct dmi_system_id *dmi)
+{
+	uintptr_t dis_caps = (uintptr_t)dmi->driver_data;
+
+	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
+		rtw_disable_msi = true;
+	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_ASPM))
+		rtw_pci_disable_aspm = true;
+
+	return 1;
+}
+
+static const struct dmi_system_id rtw88_pci_quirks[] = {
+	{
+		.callback = disable_pci_caps,
+		.ident = "Protempo Ltd L116HTN6SPW",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
+	},
+	{}
+};
+
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
@@ -1648,6 +1679,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
+	dmi_check_system(rtw88_pci_quirks);
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
-- 
2.30.2



