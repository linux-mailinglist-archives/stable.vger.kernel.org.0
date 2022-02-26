Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB14C4C5485
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 08:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiBZHwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 02:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiBZHwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 02:52:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FA120E59D
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 23:52:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C61DCB81201
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 07:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C2AC340E8;
        Sat, 26 Feb 2022 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645861922;
        bh=25g/mHmOk5YwELRXfxe2NDUwhOYWCixw3MS1SUMEaQo=;
        h=Subject:To:From:Date:From;
        b=gvCOAN3WcEpgF4t8tobjYgS/1cRYXQwHnz/a4mz9p7XzSHjatAYn21AGpjUYOahBf
         1+qNkXfVAdUHCKkoby7hprjvbX2ww0s9jF77y1UX0YXQr9ybPyYqiTyFeSpqnF8Ib3
         bRwthK+fUEK5oSLIAYm+mmit0wLMV53SdG6o2hsc=
Subject: patch "mei: me: disable driver on the ign firmware" added to char-misc-next
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 26 Feb 2022 08:50:26 +0100
Message-ID: <164586182659102@kroah.com>
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
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


