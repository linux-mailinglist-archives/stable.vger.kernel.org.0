Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BEC499684
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445689AbiAXVEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52044 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443200AbiAXU4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:56:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7740DB8123D;
        Mon, 24 Jan 2022 20:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7E2C340E5;
        Mon, 24 Jan 2022 20:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057788;
        bh=y68xxu8iMAtxJro7Nolt3iQzbp/6pcihsIFLmjlaUH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xuGeAlHbaWzLmhJeZt9zLtxIfOFYzY8NBMNXnbWnw/Rp7PjTJjdfuLOuyvduuvWtB
         4gOQkoJOPC/KjaMHkUyRZVIo5wJrq2hkIA3Vi5rRJyg4or1lElAXBxBu3UuC2CpSt3
         b6ruZ3RJyS23jcv7gdzSMYASweliDmOYmgTLTV90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        Jouni Malinen <quic_jouni@quicinc.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.16 0078/1039] ath11k: add string type to search board data in board-2.bin for WCN6855
Date:   Mon, 24 Jan 2022 19:31:07 +0100
Message-Id: <20220124184127.793504812@linuxfoundation.org>
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

From: Wen Gong <quic_wgong@quicinc.com>

commit fc95d10ac41d75c14a81afcc8722333d8b2cf80f upstream.

Currently ath11k only support string type with bus, chip id and board id
such as "bus=ahb,qmi-chip-id=1,qmi-board-id=4" for ahb bus chip and
"bus=pci,qmi-chip-id=0,qmi-board-id=255" for PCIe bus chip in
board-2.bin. For WCN6855, it is not enough to distinguish all different
chips.

This is to add a new string type which include bus, chip id, board id,
vendor, device, subsystem-vendor and subsystem-device for WCN6855.

ath11k will first load board-2.bin and search in it for the board data
with the above parameters, if matched one board data, then download it
to firmware, if not matched any one, then ath11k will download the file
board.bin to firmware.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Jouni Malinen <quic_jouni@quicinc.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211111065340.20187-1-quic_wgong@quicinc.com
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/core.c |   27 +++++++++++++++++++++------
 drivers/net/wireless/ath/ath11k/core.h |   13 +++++++++++++
 drivers/net/wireless/ath/ath11k/pci.c  |   10 ++++++++++
 3 files changed, 44 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -392,11 +392,26 @@ static int ath11k_core_create_board_name
 		scnprintf(variant, sizeof(variant), ",variant=%s",
 			  ab->qmi.target.bdf_ext);
 
-	scnprintf(name, name_len,
-		  "bus=%s,qmi-chip-id=%d,qmi-board-id=%d%s",
-		  ath11k_bus_str(ab->hif.bus),
-		  ab->qmi.target.chip_id,
-		  ab->qmi.target.board_id, variant);
+	switch (ab->id.bdf_search) {
+	case ATH11K_BDF_SEARCH_BUS_AND_BOARD:
+		scnprintf(name, name_len,
+			  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x,qmi-chip-id=%d,qmi-board-id=%d%s",
+			  ath11k_bus_str(ab->hif.bus),
+			  ab->id.vendor, ab->id.device,
+			  ab->id.subsystem_vendor,
+			  ab->id.subsystem_device,
+			  ab->qmi.target.chip_id,
+			  ab->qmi.target.board_id,
+			  variant);
+		break;
+	default:
+		scnprintf(name, name_len,
+			  "bus=%s,qmi-chip-id=%d,qmi-board-id=%d%s",
+			  ath11k_bus_str(ab->hif.bus),
+			  ab->qmi.target.chip_id,
+			  ab->qmi.target.board_id, variant);
+		break;
+	}
 
 	ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot using board name '%s'\n", name);
 
@@ -633,7 +648,7 @@ static int ath11k_core_fetch_board_data_
 	return 0;
 }
 
-#define BOARD_NAME_SIZE 100
+#define BOARD_NAME_SIZE 200
 int ath11k_core_fetch_bdf(struct ath11k_base *ab, struct ath11k_board_data *bd)
 {
 	char boardname[BOARD_NAME_SIZE];
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -47,6 +47,11 @@ enum ath11k_supported_bw {
 	ATH11K_BW_160	= 3,
 };
 
+enum ath11k_bdf_search {
+	ATH11K_BDF_SEARCH_DEFAULT,
+	ATH11K_BDF_SEARCH_BUS_AND_BOARD,
+};
+
 enum wme_ac {
 	WME_AC_BE,
 	WME_AC_BK,
@@ -759,6 +764,14 @@ struct ath11k_base {
 
 	struct completion htc_suspend;
 
+	struct {
+		enum ath11k_bdf_search bdf_search;
+		u32 vendor;
+		u32 device;
+		u32 subsystem_vendor;
+		u32 subsystem_device;
+	} id;
+
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1251,6 +1251,15 @@ static int ath11k_pci_probe(struct pci_d
 		goto err_free_core;
 	}
 
+	ath11k_dbg(ab, ATH11K_DBG_BOOT, "pci probe %04x:%04x %04x:%04x\n",
+		   pdev->vendor, pdev->device,
+		   pdev->subsystem_vendor, pdev->subsystem_device);
+
+	ab->id.vendor = pdev->vendor;
+	ab->id.device = pdev->device;
+	ab->id.subsystem_vendor = pdev->subsystem_vendor;
+	ab->id.subsystem_device = pdev->subsystem_device;
+
 	switch (pci_dev->device) {
 	case QCA6390_DEVICE_ID:
 		ath11k_pci_read_hw_version(ab, &soc_hw_version_major,
@@ -1273,6 +1282,7 @@ static int ath11k_pci_probe(struct pci_d
 		ab->hw_rev = ATH11K_HW_QCN9074_HW10;
 		break;
 	case WCN6855_DEVICE_ID:
+		ab->id.bdf_search = ATH11K_BDF_SEARCH_BUS_AND_BOARD;
 		ath11k_pci_read_hw_version(ab, &soc_hw_version_major,
 					   &soc_hw_version_minor);
 		switch (soc_hw_version_major) {


