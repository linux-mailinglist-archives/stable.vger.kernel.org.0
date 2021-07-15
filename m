Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691B13CAAAF
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbhGOTPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243279AbhGOTMj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:12:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DD08613D6;
        Thu, 15 Jul 2021 19:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376141;
        bh=LrqA3Q5ctTV6K0harTnES9skPEHmU3d24hQ7WI8iNiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuGkTvF6K7+sUbYNPfaTTjIFBchy0wh+JnRAy4xiuJ4SaPjQ35iqsLqPj18HGk5G0
         vEcB2NsD3rAcEmcevjSLDBcG88ND2OiqP3rRnN4IoZ3mqVsf/b1tw3VIquv+jSTNhJ
         b0tBQsutU+gSYYvudzYB7bSkS+Sfpnp1NiPVqy/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Szabo <psz2036@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 144/266] rtw88: add quirks to disable pci capabilities
Date:   Thu, 15 Jul 2021 20:38:19 +0200
Message-Id: <20210715182639.085551726@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
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
index f59a4c462e3b..e7d17ab8f113 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1673,6 +1674,36 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
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
@@ -1723,6 +1754,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
+	dmi_check_system(rtw88_pci_quirks);
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
-- 
2.30.2



