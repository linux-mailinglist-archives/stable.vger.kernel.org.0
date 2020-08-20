Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2602D24BCF5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbgHTJlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgHTJls (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:41:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C38520724;
        Thu, 20 Aug 2020 09:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916508;
        bh=zYYp3C2CTnV6KL7DGFZEL0ktlMcY9rMHH+wVkETx7r8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jj7xngC8n1Vxtd8qlGx9s7s3vRBRtqNEwlcsM9CNOsQ3U4B49yTGvVvCpaGQMIe2v
         WwrBPREItbz/wmsj3VfAa+5juECcGrVk75Ah5YDIT2IZDjFpgnL6RH2qzaX1e42gI3
         Y3RZkSVYxCkRXB1dXF6YOjlqOTc+5BPMOm05kanA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/204] rtw88: pci: disable aspm for platform inter-op with module parameter
Date:   Thu, 20 Aug 2020 11:20:22 +0200
Message-Id: <20200820091612.534416503@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

[ Upstream commit 68aa716b7dd36f55e080da9e27bc594346334c41 ]

Some platforms cannot read the DBI register successfully for the
ASPM settings. After the read failed, the bus could be unstable,
and the device just became unavailable [1]. For those platforms,
the ASPM should be disabled. But as the ASPM can help the driver
to save the power consumption in power save mode, the ASPM is still
needed. So, add a module parameter for them to disable it, then
the device can still work, while others can benefit from the less
power consumption that brings by ASPM enabled.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=206411
[2] Note that my lenovo T430 is the same.

Fixes: 3dff7c6e3749 ("rtw88: allows to enable/disable HCI link PS mechanism")
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200605074703.32726-1-yhchuang@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index d735f3127fe8f..6c24ddc2a9751 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -14,8 +14,11 @@
 #include "debug.h"
 
 static bool rtw_disable_msi;
+static bool rtw_pci_disable_aspm;
 module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
+module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
 MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
+MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
 
 static u32 rtw_pci_tx_queue_idx_addr[] = {
 	[RTW_TX_QUEUE_BK]	= RTK_PCI_TXBD_IDX_BKQ,
@@ -1189,6 +1192,9 @@ static void rtw_pci_clkreq_set(struct rtw_dev *rtwdev, bool enable)
 	u8 value;
 	int ret;
 
+	if (rtw_pci_disable_aspm)
+		return;
+
 	ret = rtw_dbi_read8(rtwdev, RTK_PCIE_LINK_CFG, &value);
 	if (ret) {
 		rtw_err(rtwdev, "failed to read CLKREQ_L1, ret=%d", ret);
@@ -1208,6 +1214,9 @@ static void rtw_pci_aspm_set(struct rtw_dev *rtwdev, bool enable)
 	u8 value;
 	int ret;
 
+	if (rtw_pci_disable_aspm)
+		return;
+
 	ret = rtw_dbi_read8(rtwdev, RTK_PCIE_LINK_CFG, &value);
 	if (ret) {
 		rtw_err(rtwdev, "failed to read ASPM, ret=%d", ret);
-- 
2.25.1



