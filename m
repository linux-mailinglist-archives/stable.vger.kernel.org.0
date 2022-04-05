Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D554F2BEA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343858AbiDEKjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiDEJci (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:32:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254EEBB;
        Tue,  5 Apr 2022 02:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61B366144D;
        Tue,  5 Apr 2022 09:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AC2C385A3;
        Tue,  5 Apr 2022 09:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150384;
        bh=03Ws9qQgvQwf9mtv7tPWt+LryrlarzUFcRPDufIyokE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcdD+oVd0LEWalWL4NgL8YUfmHBI/bWNc1lv3iFGWf+lvij6O/jxo6iiDhW7hw078
         2/T9dLrQF5cRfh2jaqu/1MInCG8XtJf+3dYDJgg1dAetMK7eCeWia1B/YXRj2Boo6V
         8LgRZlQYfpw79w9d/Ui4HpGL60VCFFZ0YadZ3RJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 037/913] mei: me: disable driver on the ign firmware
Date:   Tue,  5 Apr 2022 09:18:19 +0200
Message-Id: <20220405070340.928706468@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit ccdf6f806fbf559f7c29ed9302a7c1b4da7fd37f upstream.

Add a quirk to disable MEI interface on Intel PCH Ignition (IGN)
as the IGN firmware doesn't support the protocol.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20220215080438.264876-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/hw-me.c      |   23 ++++++++++++-----------
 2 files changed, 13 insertions(+), 11 deletions(-)

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
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1405,16 +1405,16 @@ static bool mei_me_fw_type_sps_4(const s
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
@@ -1427,14 +1427,15 @@ static bool mei_me_fw_type_sps(const str
 
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
@@ -1535,7 +1536,7 @@ static const struct mei_cfg mei_me_pch12
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_DMA_128,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /* Cannon Lake itouch with quirk for SPS 5.0 and newer Firmware exclusion
@@ -1545,7 +1546,7 @@ static const struct mei_cfg mei_me_pch12
 	MEI_CFG_KIND_ITOUCH,
 	MEI_CFG_PCH8_HFS,
 	MEI_CFG_FW_VER_SUPP,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /* Tiger Lake and newer devices */
@@ -1562,7 +1563,7 @@ static const struct mei_cfg mei_me_pch15
 	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_DMA_128,
 	MEI_CFG_TRC,
-	MEI_CFG_FW_SPS,
+	MEI_CFG_FW_SPS_IGN,
 };
 
 /*


