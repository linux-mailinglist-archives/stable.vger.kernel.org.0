Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6C52D9E64
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438242AbfJPV6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438234AbfJPV6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:42 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4343321925;
        Wed, 16 Oct 2019 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263121;
        bh=+L06x7cH/GvyDOZLPDnycUzXAwWQRzr/CvOedlMODvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuHNiQWrU8JeLJ7RAPf7TyKMtJ0331Q84d3Bh2VfyGWLrECt3dhh4pkIkNi2jbMds
         3fqpBPdYt3nC7t/nt7F26pO0O0TOuDrdP0ZUCG6YpjvqqPr8hRfRbudyrNEstyVAhL
         LZM2kSOnbybd8U/7AwPHCOUmDR0j7TVVtHUxZDqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.3 045/112] mei: avoid FW version request on Ibex Peak and earlier
Date:   Wed, 16 Oct 2019 14:50:37 -0700
Message-Id: <20191016214854.991242812@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit f8204f0ddd62966a0e79c2804963a21e3540dd82 upstream.

The fixed MKHI client on PCH 6 gen platforms
does not support fw version retrieval.
The error is not fatal, but it fills up the kernel logs and
slows down the driver start.
This patch disables requesting FW version on GEN6 and earlier platforms.

Fixes warning:
[   15.964298] mei mei::55213584-9a29-4916-badf-0fb7ed682aeb:01: Could not read FW version
[   15.964301] mei mei::55213584-9a29-4916-badf-0fb7ed682aeb:01: version command failed -5

Cc: <stable@vger.kernel.org> +v4.18
Cc: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20191004181722.31374-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/bus-fixup.c |   14 +++++++++++---
 drivers/misc/mei/hw-me.c     |   21 ++++++++++++++++++---
 drivers/misc/mei/hw-me.h     |    8 ++++++--
 drivers/misc/mei/mei_dev.h   |    4 ++++
 drivers/misc/mei/pci-me.c    |   10 +++++-----
 5 files changed, 44 insertions(+), 13 deletions(-)

--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -218,13 +218,21 @@ static void mei_mkhi_fix(struct mei_cl_d
 {
 	int ret;
 
+	/* No need to enable the client if nothing is needed from it */
+	if (!cldev->bus->fw_f_fw_ver_supported &&
+	    !cldev->bus->hbm_f_os_supported)
+		return;
+
 	ret = mei_cldev_enable(cldev);
 	if (ret)
 		return;
 
-	ret = mei_fwver(cldev);
-	if (ret < 0)
-		dev_err(&cldev->dev, "FW version command failed %d\n", ret);
+	if (cldev->bus->fw_f_fw_ver_supported) {
+		ret = mei_fwver(cldev);
+		if (ret < 0)
+			dev_err(&cldev->dev, "FW version command failed %d\n",
+				ret);
+	}
 
 	if (cldev->bus->hbm_f_os_supported) {
 		ret = mei_osver(cldev);
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1355,6 +1355,8 @@ static bool mei_me_fw_type_sps(struct pc
 #define MEI_CFG_FW_SPS                           \
 	.quirk_probe = mei_me_fw_type_sps
 
+#define MEI_CFG_FW_VER_SUPP                     \
+	.fw_ver_supported = 1
 
 #define MEI_CFG_ICH_HFS                      \
 	.fw_status.count = 0
@@ -1392,31 +1394,41 @@ static const struct mei_cfg mei_me_ich10
 	MEI_CFG_ICH10_HFS,
 };
 
-/* PCH devices */
-static const struct mei_cfg mei_me_pch_cfg = {
+/* PCH6 devices */
+static const struct mei_cfg mei_me_pch6_cfg = {
 	MEI_CFG_PCH_HFS,
 };
 
+/* PCH7 devices */
+static const struct mei_cfg mei_me_pch7_cfg = {
+	MEI_CFG_PCH_HFS,
+	MEI_CFG_FW_VER_SUPP,
+};
+
 /* PCH Cougar Point and Patsburg with quirk for Node Manager exclusion */
 static const struct mei_cfg mei_me_pch_cpt_pbg_cfg = {
 	MEI_CFG_PCH_HFS,
+	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_FW_NM,
 };
 
 /* PCH8 Lynx Point and newer devices */
 static const struct mei_cfg mei_me_pch8_cfg = {
 	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
 };
 
 /* PCH8 Lynx Point with quirk for SPS Firmware exclusion */
 static const struct mei_cfg mei_me_pch8_sps_cfg = {
 	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_FW_SPS,
 };
 
 /* Cannon Lake and newer devices */
 static const struct mei_cfg mei_me_pch12_cfg = {
 	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
 	MEI_CFG_DMA_128,
 };
 
@@ -1428,7 +1440,8 @@ static const struct mei_cfg *const mei_c
 	[MEI_ME_UNDEF_CFG] = NULL,
 	[MEI_ME_ICH_CFG] = &mei_me_ich_cfg,
 	[MEI_ME_ICH10_CFG] = &mei_me_ich10_cfg,
-	[MEI_ME_PCH_CFG] = &mei_me_pch_cfg,
+	[MEI_ME_PCH6_CFG] = &mei_me_pch6_cfg,
+	[MEI_ME_PCH7_CFG] = &mei_me_pch7_cfg,
 	[MEI_ME_PCH_CPT_PBG_CFG] = &mei_me_pch_cpt_pbg_cfg,
 	[MEI_ME_PCH8_CFG] = &mei_me_pch8_cfg,
 	[MEI_ME_PCH8_SPS_CFG] = &mei_me_pch8_sps_cfg,
@@ -1473,6 +1486,8 @@ struct mei_device *mei_me_dev_init(struc
 	mei_device_init(dev, &pdev->dev, &mei_me_hw_ops);
 	hw->cfg = cfg;
 
+	dev->fw_f_fw_ver_supported = cfg->fw_ver_supported;
+
 	return dev;
 }
 
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -20,11 +20,13 @@
  * @fw_status: FW status
  * @quirk_probe: device exclusion quirk
  * @dma_size: device DMA buffers size
+ * @fw_ver_supported: is fw version retrievable from FW
  */
 struct mei_cfg {
 	const struct mei_fw_status fw_status;
 	bool (*quirk_probe)(struct pci_dev *pdev);
 	size_t dma_size[DMA_DSCR_NUM];
+	u32 fw_ver_supported:1;
 };
 
 
@@ -62,7 +64,8 @@ struct mei_me_hw {
  * @MEI_ME_UNDEF_CFG:      Lower sentinel.
  * @MEI_ME_ICH_CFG:        I/O Controller Hub legacy devices.
  * @MEI_ME_ICH10_CFG:      I/O Controller Hub platforms Gen10
- * @MEI_ME_PCH_CFG:        Platform Controller Hub platforms (Up to Gen8).
+ * @MEI_ME_PCH6_CFG:       Platform Controller Hub platforms (Gen6).
+ * @MEI_ME_PCH7_CFG:       Platform Controller Hub platforms (Gen7).
  * @MEI_ME_PCH_CPT_PBG_CFG:Platform Controller Hub workstations
  *                         with quirk for Node Manager exclusion.
  * @MEI_ME_PCH8_CFG:       Platform Controller Hub Gen8 and newer
@@ -77,7 +80,8 @@ enum mei_cfg_idx {
 	MEI_ME_UNDEF_CFG,
 	MEI_ME_ICH_CFG,
 	MEI_ME_ICH10_CFG,
-	MEI_ME_PCH_CFG,
+	MEI_ME_PCH6_CFG,
+	MEI_ME_PCH7_CFG,
 	MEI_ME_PCH_CPT_PBG_CFG,
 	MEI_ME_PCH8_CFG,
 	MEI_ME_PCH8_SPS_CFG,
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -426,6 +426,8 @@ struct mei_fw_version {
  *
  * @fw_ver : FW versions
  *
+ * @fw_f_fw_ver_supported : fw feature: fw version supported
+ *
  * @me_clients_rwsem: rw lock over me_clients list
  * @me_clients  : list of FW clients
  * @me_clients_map : FW clients bit map
@@ -506,6 +508,8 @@ struct mei_device {
 
 	struct mei_fw_version fw_ver[MEI_MAX_FW_VER_BLOCKS];
 
+	unsigned int fw_f_fw_ver_supported:1;
+
 	struct rw_semaphore me_clients_rwsem;
 	struct list_head me_clients;
 	DECLARE_BITMAP(me_clients_map, MEI_CLIENTS_MAX);
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -61,13 +61,13 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_3, MEI_ME_ICH10_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICH10_4, MEI_ME_ICH10_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_1, MEI_ME_PCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_2, MEI_ME_PCH_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_1, MEI_ME_PCH6_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_IBXPK_2, MEI_ME_PCH6_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_CPT_1, MEI_ME_PCH_CPT_PBG_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PBG_1, MEI_ME_PCH_CPT_PBG_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, MEI_ME_PCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, MEI_ME_PCH_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, MEI_ME_PCH_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_1, MEI_ME_PCH7_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_2, MEI_ME_PCH7_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PPT_3, MEI_ME_PCH7_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_H, MEI_ME_PCH8_SPS_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_W, MEI_ME_PCH8_SPS_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, MEI_ME_PCH8_CFG)},


