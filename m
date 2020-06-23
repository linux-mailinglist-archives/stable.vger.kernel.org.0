Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE8204961
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 07:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730447AbgFWF4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 01:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728800AbgFWF4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 01:56:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D712420772;
        Tue, 23 Jun 2020 05:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592891781;
        bh=vN33FPbmqZ07gt/oXxckTcw7fc9uCyYHEqKMFVV2nWM=;
        h=Subject:To:From:Date:From;
        b=wg+/GbCEpt34IK6kyYUDC2qxlauIzLyYUFj5YOmtWg0mV2mgk6ggBgx6M4RMiOxBo
         dshfXfIW1lrw9VixNvihP2pbbuwFSb48mFmjq2Imcvb3iemTT2bboKxFW4WOATvGhL
         uyOUlHfGU7H6m2rXp+Tmsbr0M6nROTdHS4L6wgB0=
Subject: patch "mei: me: add tiger lake point device ids for H platforms." added to char-misc-linus
To:     alexander.usyskin@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tomas.winkler@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 07:56:05 +0200
Message-ID: <159289176514106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: add tiger lake point device ids for H platforms.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8c289ea064165237891a7b4be77b74d5cba8fa99 Mon Sep 17 00:00:00 2001
From: Alexander Usyskin <alexander.usyskin@intel.com>
Date: Fri, 19 Jun 2020 19:51:21 +0300
Subject: mei: me: add tiger lake point device ids for H platforms.

Add Tiger Lake device ids H for HECI1.
TGH_H is also used in Tatlow SPS platform we need to
disable the mei interface there.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200619165121.2145330-7-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |  1 +
 drivers/misc/mei/hw-me.c      | 10 ++++++++++
 drivers/misc/mei/hw-me.h      |  4 ++++
 drivers/misc/mei/pci-me.c     |  1 +
 4 files changed, 16 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 01b1bf74f262..7becfc768bbc 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -94,6 +94,7 @@
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+#define MEI_DEV_ID_TGP_H      0x43E0  /* Tiger Lake Point H */
 
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index f8155c1e811d..7649710a2ab9 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1526,6 +1526,15 @@ static const struct mei_cfg mei_me_pch15_cfg = {
 	MEI_CFG_TRC,
 };
 
+/* Tiger Lake with quirk for SPS 5.0 and newer Firmware exclusion */
+static const struct mei_cfg mei_me_pch15_sps_cfg = {
+	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
+	MEI_CFG_DMA_128,
+	MEI_CFG_TRC,
+	MEI_CFG_FW_SPS,
+};
+
 /*
  * mei_cfg_list - A list of platform platform specific configurations.
  * Note: has to be synchronized with  enum mei_cfg_idx.
@@ -1544,6 +1553,7 @@ static const struct mei_cfg *const mei_cfg_list[] = {
 	[MEI_ME_PCH12_SPS_CFG] = &mei_me_pch12_sps_cfg,
 	[MEI_ME_PCH12_SPS_NODMA_CFG] = &mei_me_pch12_nodma_sps_cfg,
 	[MEI_ME_PCH15_CFG] = &mei_me_pch15_cfg,
+	[MEI_ME_PCH15_SPS_CFG] = &mei_me_pch15_sps_cfg,
 };
 
 const struct mei_cfg *mei_me_get_cfg(kernel_ulong_t idx)
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 52e0c6d578f2..6a8973649c49 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -87,6 +87,9 @@ struct mei_me_hw {
  *                         servers platforms with quirk for
  *                         SPS firmware exclusion.
  * @MEI_ME_PCH15_CFG:      Platform Controller Hub Gen15 and newer
+ * @MEI_ME_PCH15_SPS_CFG:  Platform Controller Hub Gen15 and newer
+ *                         servers platforms with quirk for
+ *                         SPS firmware exclusion.
  * @MEI_ME_NUM_CFG:        Upper Sentinel.
  */
 enum mei_cfg_idx {
@@ -103,6 +106,7 @@ enum mei_cfg_idx {
 	MEI_ME_PCH12_SPS_CFG,
 	MEI_ME_PCH12_SPS_NODMA_CFG,
 	MEI_ME_PCH15_CFG,
+	MEI_ME_PCH15_SPS_CFG,
 	MEI_ME_NUM_CFG,
 };
 
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 1bcc724a18aa..2a3f2fd5df50 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -96,6 +96,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_JSP_N, MEI_ME_PCH15_CFG)},
 
-- 
2.27.0


