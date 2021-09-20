Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF541233F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378023AbhITSWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377690AbhITSUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0A3632AF;
        Mon, 20 Sep 2021 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158608;
        bh=mE7EIEW+taAQxeHWees9YNPxttkqa2pLS/yQgdb7P6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJyPs6rmjnMgG0WAKDPl8jROlD5/oSbBSqKlMVgj8zMX6RB5f4kp5vZ9CD3hT7Z/5
         4YnER9JPGw+7vLzaZZc/8/IeKBlvaLUprXQB1TEUpaWcNHGKaGvIhL5RBPi/ezYmkE
         ilRj2AjQxuQCZuyJebEslyq9L7FQ/3SqrPBPwFBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wasim Khan <wasim.khan@nxp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 235/260] PCI: Add ACS quirks for NXP LX2xx0 and LX2xx2 platforms
Date:   Mon, 20 Sep 2021 18:44:13 +0200
Message-Id: <20210920163939.106237706@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wasim Khan <wasim.khan@nxp.com>

[ Upstream commit d08c8b855140e9f5240b3ffd1b8b9d435675e281 ]

Root Ports in NXP LX2xx0 and LX2xx2, where each Root Port is a Root Complex
with unique segment numbers, do provide isolation features to disable peer
transactions and validate bus numbers in requests, but do not provide an
actual PCIe ACS capability.

Add ACS quirks for NXP LX2xx0 A/C/E/N and LX2xx2 A/C/E/N platforms.

  LX2xx0A : without security features + CAN-FD
    LX2160A (0x8d81) - 16 cores
    LX2120A (0x8da1) - 12 cores
    LX2080A (0x8d83) -  8 cores

  LX2xx0C : security features + CAN-FD
    LX2160C (0x8d80) - 16 cores
    LX2120C (0x8da0) - 12 cores
    LX2080C (0x8d82) -  8 cores

  LX2xx0E : security features + CAN
    LX2160E (0x8d90) - 16 cores
    LX2120E (0x8db0) - 12 cores
    LX2080E (0x8d92) -  8 cores

  LX2xx0N : without security features + CAN
    LX2160N (0x8d91) - 16 cores
    LX2120N (0x8db1) - 12 cores
    LX2080N (0x8d93) -  8 cores

  LX2xx2A : without security features + CAN-FD
    LX2162A (0x8d89) - 16 cores
    LX2122A (0x8da9) - 12 cores
    LX2082A (0x8d8b) -  8 cores

  LX2xx2C : security features + CAN-FD
    LX2162C (0x8d88) - 16 cores
    LX2122C (0x8da8) - 12 cores
    LX2082C (0x8d8a) -  8 cores

  LX2xx2E : security features + CAN
    LX2162E (0x8d98) - 16 cores
    LX2122E (0x8db8) - 12 cores
    LX2082E (0x8d9a) -  8 cores

  LX2xx2N : without security features + CAN
    LX2162N (0x8d99) - 16 cores
    LX2122N (0x8db9) - 12 cores
    LX2082N (0x8d9b) -  8 cores

[bhelgaas: put PCI_VENDOR_ID_NXP definition next to PCI_VENDOR_ID_FREESCALE
as a clue that they share the same Device ID namespace]
Link: https://lore.kernel.org/r/20210729121747.1823086-1-wasim.khan@oss.nxp.com
Link: https://lore.kernel.org/r/20210803180021.3252886-1-wasim.khan@oss.nxp.com
Signed-off-by: Wasim Khan <wasim.khan@nxp.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c    | 45 +++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_ids.h |  3 ++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 34c68a7313db..e230a7b5e70a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4684,6 +4684,18 @@ static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Each of these NXP Root Ports is in a Root Complex with a unique segment
+ * number and does provide isolation features to disable peer transactions
+ * and validate bus numbers in requests, but does not provide an ACS
+ * capability.
+ */
+static int pci_quirk_nxp_rp_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+}
+
 static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)
@@ -4930,6 +4942,39 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3038, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x3104, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_ZHAOXIN, 0x9083, pci_quirk_mf_endpoint_acs },
+	/* NXP root ports, xx=16, 12, or 08 cores */
+	/* LX2xx0A : without security features + CAN-FD */
+	{ PCI_VENDOR_ID_NXP, 0x8d81, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8da1, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d83, pci_quirk_nxp_rp_acs },
+	/* LX2xx0C : security features + CAN-FD */
+	{ PCI_VENDOR_ID_NXP, 0x8d80, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8da0, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d82, pci_quirk_nxp_rp_acs },
+	/* LX2xx0E : security features + CAN */
+	{ PCI_VENDOR_ID_NXP, 0x8d90, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8db0, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d92, pci_quirk_nxp_rp_acs },
+	/* LX2xx0N : without security features + CAN */
+	{ PCI_VENDOR_ID_NXP, 0x8d91, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8db1, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d93, pci_quirk_nxp_rp_acs },
+	/* LX2xx2A : without security features + CAN-FD */
+	{ PCI_VENDOR_ID_NXP, 0x8d89, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8da9, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d8b, pci_quirk_nxp_rp_acs },
+	/* LX2xx2C : security features + CAN-FD */
+	{ PCI_VENDOR_ID_NXP, 0x8d88, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8da8, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d8a, pci_quirk_nxp_rp_acs },
+	/* LX2xx2E : security features + CAN */
+	{ PCI_VENDOR_ID_NXP, 0x8d98, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8db8, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d9a, pci_quirk_nxp_rp_acs },
+	/* LX2xx2N : without security features + CAN */
+	{ PCI_VENDOR_ID_NXP, 0x8d99, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8db9, pci_quirk_nxp_rp_acs },
+	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
 	{ 0 }
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0ad57693f392..42588645478d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2476,7 +2476,8 @@
 #define PCI_VENDOR_ID_TDI               0x192E
 #define PCI_DEVICE_ID_TDI_EHCI          0x0101
 
-#define PCI_VENDOR_ID_FREESCALE		0x1957
+#define PCI_VENDOR_ID_FREESCALE		0x1957	/* duplicate: NXP */
+#define PCI_VENDOR_ID_NXP		0x1957	/* duplicate: FREESCALE */
 #define PCI_DEVICE_ID_MPC8308		0xc006
 #define PCI_DEVICE_ID_MPC8315E		0x00b4
 #define PCI_DEVICE_ID_MPC8315		0x00b5
-- 
2.30.2



