Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB34B6527
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 09:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiBOIFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 03:05:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiBOIE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 03:04:59 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A6F2654E;
        Tue, 15 Feb 2022 00:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644912290; x=1676448290;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=J2aPIxHkPt7CQ39Q+4Y+kmdrTWxBvdaiEZS2aBpap2A=;
  b=nErw1dThFvhTUPgA2Nn9QfTr2ruhnTJIAG23xWrNi5eGwn4pXLyVQvC5
   IcYozrCQwyd9xFTnJoXbOsqiRzeGnXuql0Wr/kxnp/isihS1q5quztDTh
   DT/C7C59WxOV9uWN329A6wvCyPI3l2msH+KM9rcGnuQVGd5pgnqxfD12f
   Y05Pgf2hyL/jpxtod9j7mG0CQQos+NPi4pvUC/16ZfPtYT4LFoA8invqG
   Wan+bj1UF+h4ZdbLEoHHi5Nhcy4Ppv5QdhV9K6PTg5Q/eKpdpDLOEfRLx
   gMg+a+lKf/JfW0/OHy5LsIeUGiZ3AcA33zG1sRaZ0FQiONoAPI35jZnTj
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10258"; a="336703227"
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="336703227"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 00:04:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,370,1635231600"; 
   d="scan'208";a="703498873"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.43])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 00:04:47 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Vitaly Lubart <vitaly.lubart@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 1/4] mei: me: disable driver on the ign firmware
Date:   Tue, 15 Feb 2022 10:04:35 +0200
Message-Id: <20220215080438.264876-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add a quirk to disable MEI interface on Intel PCH Ignition (IGN)
as the IGN firmware doesn't support the protocol.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
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
2.34.1

