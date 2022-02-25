Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0819C4C432B
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 12:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiBYLOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 06:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiBYLOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 06:14:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEBA21DF06
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 03:14:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89717617FE
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 11:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EEAC340E7;
        Fri, 25 Feb 2022 11:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645787659;
        bh=cpq6hXfclHJ0QUOn0KPOi7Eu/iLc1/eqySAyf8vBYAY=;
        h=Subject:To:From:Date:From;
        b=sKLxgjic9uMBSM8DhXW1emG73qjXT9JlYpJj90Qxi6KSASQ6wpBcMTpI03ZnIICPL
         FlDz8VZiZSAaSCT2kBN/t+iOR23ixnLj/Xa05IvrEhfRrK/qMLP+Lh6Jjlsg0DsPbW
         N28UWbV/WwzZgheDhCgzaWcGQsKpWIR0lDpYrTUg=
Subject: patch "mei: me: disable driver on the ign firmware" added to char-misc-testing
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 25 Feb 2022 12:14:16 +0100
Message-ID: <1645787656220188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


This is a note to let you know that I've just added the patch titled

    mei: me: disable driver on the ign firmware

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the char-misc-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From ccdf6f806fbf559f7c29ed9302a7c1b4da7fd37f Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Tue, 15 Feb 2022 10:04:35 +0200
Subject: mei: me: disable driver on the ign firmware

Add a quirk to disable MEI interface on Intel PCH Ignition (IGN)
as the IGN firmware doesn't support the protocol.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220215080438.264876-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |  1 +
 drivers/misc/mei/hw-me.c      | 23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 67bb6a25fd0a..888c27bc3f1a 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -120,6 +120,7 @@
 #define PCI_CFG_HFS_2         0x48
 #define PCI_CFG_HFS_3         0x60
 #  define PCI_CFG_HFS_3_FW_SKU_MSK   0x00000070
+#  define PCI_CFG_HFS_3_FW_SKU_IGN   0x00000000
 #  define PCI_CFG_HFS_3_FW_SKU_SPS   0x00000060
 #define PCI_CFG_HFS_4         0x64
 #define PCI_CFG_HFS_5         0x68
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index d3a6c0728645..fbc4c9581864 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1405,16 +1405,16 @@ static bool mei_me_fw_type_sps_4(const struct pci_dev *pdev)
 	.quirk_probe = mei_me_fw_type_sps_4
 
 /**
- * mei_me_fw_type_sps() - check for sps sku
+ * mei_me_fw_type_sps_ign() - check for sps or ign sku
  *
- * Read ME FW Status register to check for SPS Firmware.
- * The SPS FW is only signaled in pci function 0
+ * Read ME FW Status register to check for SPS or IGN Firmware.
+ * The SPS/IGN FW is only signaled in pci function 0
  *
  * @pdev: pci device
  *
- * Return: true in case of SPS firmware
+ * Return: true in case of SPS/IGN firmware
  */
-static bool mei_me_fw_type_sps(const struct pci_dev *pdev)
+static bool mei_me_fw_type_sps_ign(const struct pci_dev *pdev)
 {
 	u32 reg;
 	u32 fw_type;
@@ -1427,14 +1427,15 @@ static bool mei_me_fw_type_sps(const struct pci_dev *pdev)
 
 	dev_dbg(&pdev->dev, "fw type is %d\n", fw_type);
 
-	return fw_type == PCI_CFG_HFS_3_FW_SKU_SPS;
+	return fw_type == PCI_CFG_HFS_3_FW_SKU_IGN ||
+	       fw_type == PCI_CFG_HFS_3_FW_SKU_SPS;
 }
 
 #define MEI_CFG_KIND_ITOUCH                     \
 	.kind = "itouch"
 
-#define MEI_CFG_FW_SPS                          \
-	.quirk_probe = mei_me_fw_type_sps
+#define MEI_CFG_FW_SPS_IGN                      \
+	.quirk_probe = mei_me_fw_type_sps_ign
 
 #define MEI_CFG_FW_VER_SUPP                     \
 	.fw_ver_supported = 1
@@ -1535,7 +1536,7 @@ static const struct mei_cfg mei_me_pch12_sps_cfg = {
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_DMA_128,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /* Cannon Lake itouch with quirk for SPS 5.0 and newer Firmware exclusion
@@ -1545,7 +1546,7 @@ static const struct mei_cfg mei_me_pch12_itouch_sps_cfg = {
 	MEI_CFG_KIND_ITOUCH,
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /* Tiger Lake and newer devices */
@@ -1562,7 +1563,7 @@ static const struct mei_cfg mei_me_pch15_sps_cfg = {
 	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_DMA_128,
 	MEI_CFG_TRC,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /*
-- 
2.35.1


