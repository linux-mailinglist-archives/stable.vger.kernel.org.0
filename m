Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C08B204960
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 07:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbgFWF4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 01:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgFWF4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 01:56:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C10D20771;
        Tue, 23 Jun 2020 05:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592891778;
        bh=AIARezm8EVtSPLjcyWLTGtpkxEkqQpnhVZ/txQTHjho=;
        h=Subject:To:From:Date:From;
        b=M9NpQS8CWJE6Z7qVCueLqMb7cyJZ+6GVF7R2BytMjiL4uwTpstAHhdpX5b1qRCICk
         wf69gXN1VYPquUbSCKjM/+Ae95lCIwgqi/Cvx6efGFOAt/7OoOqoMzBnLn1k0jQbxX
         etQs3CBpDlHw3o4dWSjdK5oodX5X19rFrmyUS6fE=
Subject: patch "mei: me: disable mei interface on Mehlow server platforms" added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 07:56:04 +0200
Message-ID: <1592891764250240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: disable mei interface on Mehlow server platforms

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f76d77f50b343bc7f7d01e4c2771d43fb074f617 Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Fri, 19 Jun 2020 19:51:15 +0300
Subject: mei: me: disable mei interface on Mehlow server platforms

For SPS firmware versions 5.0 and newer the way detection has changed.
The detection is done now via PCI_CFG_HFS_3 register.
To prevent conflict the previous method will get sps_4 suffix
Disable both CNP_H and CNP_H_3 interfaces. CNP_H_3 requires
a separate configuration as it doesn't support DMA.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200619165121.2145330-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |  2 ++
 drivers/misc/mei/hw-me.c      | 60 +++++++++++++++++++++++++++++++----
 drivers/misc/mei/hw-me.h      | 13 +++++---
 drivers/misc/mei/pci-me.c     | 16 +++++-----
 4 files changed, 73 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 9392934e3a06..01b1bf74f262 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -107,6 +107,8 @@
 #  define PCI_CFG_HFS_1_D0I3_MSK     0x80000000
 #define PCI_CFG_HFS_2         0x48
 #define PCI_CFG_HFS_3         0x60
+#  define PCI_CFG_HFS_3_FW_SKU_MSK   0x00000070
+#  define PCI_CFG_HFS_3_FW_SKU_SPS   0x00000060
 #define PCI_CFG_HFS_4         0x64
 #define PCI_CFG_HFS_5         0x68
 #define PCI_CFG_HFS_6         0x6C
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index f620442addf5..f8155c1e811d 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1366,7 +1366,7 @@ static bool mei_me_fw_type_nm(struct pci_dev *pdev)
 #define MEI_CFG_FW_NM                           \
 	.quirk_probe = mei_me_fw_type_nm
 
-static bool mei_me_fw_type_sps(struct pci_dev *pdev)
+static bool mei_me_fw_type_sps_4(struct pci_dev *pdev)
 {
 	u32 reg;
 	unsigned int devfn;
@@ -1382,7 +1382,36 @@ static bool mei_me_fw_type_sps(struct pci_dev *pdev)
 	return (reg & 0xf0000) == 0xf0000;
 }
 
-#define MEI_CFG_FW_SPS                           \
+#define MEI_CFG_FW_SPS_4                          \
+	.quirk_probe = mei_me_fw_type_sps_4
+
+/**
+ * mei_me_fw_sku_sps() - check for sps sku
+ *
+ * Read ME FW Status register to check for SPS Firmware.
+ * The SPS FW is only signaled in pci function 0
+ *
+ * @pdev: pci device
+ *
+ * Return: true in case of SPS firmware
+ */
+static bool mei_me_fw_type_sps(struct pci_dev *pdev)
+{
+	u32 reg;
+	u32 fw_type;
+	unsigned int devfn;
+
+	devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+	pci_bus_read_config_dword(pdev->bus, devfn, PCI_CFG_HFS_3, &reg);
+	trace_mei_pci_cfg_read(&pdev->dev, "PCI_CFG_HFS_3", PCI_CFG_HFS_3, reg);
+	fw_type = (reg & PCI_CFG_HFS_3_FW_SKU_MSK);
+
+	dev_dbg(&pdev->dev, "fw type is %d\n", fw_type);
+
+	return fw_type == PCI_CFG_HFS_3_FW_SKU_SPS;
+}
+
+#define MEI_CFG_FW_SPS                          \
 	.quirk_probe = mei_me_fw_type_sps
 
 #define MEI_CFG_FW_VER_SUPP                     \
@@ -1452,10 +1481,17 @@ static const struct mei_cfg mei_me_pch8_cfg = {
 };
 
 /* PCH8 Lynx Point with quirk for SPS Firmware exclusion */
-static const struct mei_cfg mei_me_pch8_sps_cfg = {
+static const struct mei_cfg mei_me_pch8_sps_4_cfg = {
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_4,
+};
+
+/* LBG with quirk for SPS (4.0) Firmware exclusion */
+static const struct mei_cfg mei_me_pch12_sps_4_cfg = {
+	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
+	MEI_CFG_FW_SPS_4,
 };
 
 /* Cannon Lake and newer devices */
@@ -1465,8 +1501,18 @@ static const struct mei_cfg mei_me_pch12_cfg = {
 	MEI_CFG_DMA_128,
 };
 
-/* LBG with quirk for SPS Firmware exclusion */
+/* Cannon Lake with quirk for SPS 5.0 and newer Firmware exclusion */
 static const struct mei_cfg mei_me_pch12_sps_cfg = {
+	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
+	MEI_CFG_DMA_128,
+	MEI_CFG_FW_SPS,
+};
+
+/* Cannon Lake with quirk for SPS 5.0 and newer Firmware exclusion
+ * w/o DMA support
+ */
+static const struct mei_cfg mei_me_pch12_nodma_sps_cfg = {
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_FW_SPS,
@@ -1492,9 +1538,11 @@ static const struct mei_cfg *const mei_cfg_list[] = {
 	[MEI_ME_PCH7_CFG] = &mei_me_pch7_cfg,
 	[MEI_ME_PCH_CPT_PBG_CFG] = &mei_me_pch_cpt_pbg_cfg,
 	[MEI_ME_PCH8_CFG] = &mei_me_pch8_cfg,
-	[MEI_ME_PCH8_SPS_CFG] = &mei_me_pch8_sps_cfg,
+	[MEI_ME_PCH8_SPS_4_CFG] = &mei_me_pch8_sps_4_cfg,
 	[MEI_ME_PCH12_CFG] = &mei_me_pch12_cfg,
+	[MEI_ME_PCH12_SPS_4_CFG] = &mei_me_pch12_sps_4_cfg,
 	[MEI_ME_PCH12_SPS_CFG] = &mei_me_pch12_sps_cfg,
+	[MEI_ME_PCH12_SPS_NODMA_CFG] = &mei_me_pch12_nodma_sps_cfg,
 	[MEI_ME_PCH15_CFG] = &mei_me_pch15_cfg,
 };
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index b6b94e211464..52e0c6d578f2 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright (c) 2012-2019, Intel Corporation. All rights reserved.
+ * Copyright (c) 2012-2020, Intel Corporation. All rights reserved.
  * Intel Management Engine Interface (Intel MEI) Linux driver
  */
 
@@ -76,11 +76,14 @@ struct mei_me_hw {
  *                         with quirk for Node Manager exclusion.
  * @MEI_ME_PCH8_CFG:       Platform Controller Hub Gen8 and newer
  *                         client platforms.
- * @MEI_ME_PCH8_SPS_CFG:   Platform Controller Hub Gen8 and newer
+ * @MEI_ME_PCH8_SPS_4_CFG: Platform Controller Hub Gen8 and newer
  *                         servers platforms with quirk for
  *                         SPS firmware exclusion.
  * @MEI_ME_PCH12_CFG:      Platform Controller Hub Gen12 and newer
- * @MEI_ME_PCH12_SPS_CFG:  Platform Controller Hub Gen12 and newer
+ * @MEI_ME_PCH12_SPS_4_CFG:Platform Controller Hub Gen12 up to 4.0
+ *                         servers platforms with quirk for
+ *                         SPS firmware exclusion.
+ * @MEI_ME_PCH12_SPS_CFG:  Platform Controller Hub Gen12 5.0 and newer
  *                         servers platforms with quirk for
  *                         SPS firmware exclusion.
  * @MEI_ME_PCH15_CFG:      Platform Controller Hub Gen15 and newer
@@ -94,9 +97,11 @@ enum mei_cfg_idx {
 	MEI_ME_PCH7_CFG,
 	MEI_ME_PCH_CPT_PBG_CFG,
 	MEI_ME_PCH8_CFG,
-	MEI_ME_PCH8_SPS_CFG,
+	MEI_ME_PCH8_SPS_4_CFG,
 	MEI_ME_PCH12_CFG,
+	MEI_ME_PCH12_SPS_4_CFG,
 	MEI_ME_PCH12_SPS_CFG,
+	MEI_ME_PCH12_SPS_NODMA_CFG,
 	MEI_ME_PCH15_CFG,
 	MEI_ME_NUM_CFG,
 };
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 71f795b510ce..1bcc724a18aa 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -59,18 +59,18 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, MEI_ME_PCH7_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, MEI_ME_PCH7_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, MEI_ME_PCH7_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, MEI_ME_PCH8_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, MEI_ME_PCH8_SPS_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, MEI_ME_PCH8_SPS_4_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, MEI_ME_PCH8_SPS_4_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, MEI_ME_PCH8_SPS_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, MEI_ME_PCH8_SPS_4_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, MEI_ME_PCH8_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_2, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H, MEI_ME_PCH8_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H_2, MEI_ME_PCH8_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_SPS_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H, MEI_ME_PCH8_SPS_4_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H_2, MEI_ME_PCH8_SPS_4_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_SPS_4_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_BXT_M, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_APL_I, MEI_ME_PCH8_CFG)},
@@ -84,8 +84,8 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_LP, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_LP_3, MEI_ME_PCH8_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H, MEI_ME_PCH12_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H_3, MEI_ME_PCH8_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H, MEI_ME_PCH12_SPS_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_CNP_H_3, MEI_ME_PCH12_SPS_NODMA_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP, MEI_ME_PCH12_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CMP_LP_3, MEI_ME_PCH8_CFG)},
-- 
2.27.0


