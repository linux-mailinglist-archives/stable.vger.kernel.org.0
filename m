Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFE11C5A38
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgEEO5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 10:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgEEO5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 10:57:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B189A206B9;
        Tue,  5 May 2020 14:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588690668;
        bh=ANLUBQ9MsdN2ljU55kYAyOZmO27gOvI8pJTYjtwPqOc=;
        h=Subject:To:From:Date:From;
        b=DrKQ7nI5D2BTrMswiGLdB3fdK/uexCKXC6Tv9dKRDEeFRyXS/mA853hpKeBcy1Dhj
         cZyZYTDhurOibjyXwi8//Pw168yRiZd6V+HJ0jHIHXCAmHoUABT86ndah6RLz3djPP
         jAU7tf9zRkn4mP6b2fL0Hu+iYthNm1a0ArEnL0is=
Subject: patch "mei: me: disable mei interface on LBG servers." added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 May 2020 16:57:46 +0200
Message-ID: <1588690666203210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: me: disable mei interface on LBG servers.

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d76bc8200f9cf8b6746e66b37317ba477eda25c4 Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Wed, 29 Apr 2020 00:12:00 +0300
Subject: mei: me: disable mei interface on LBG servers.

Disable the MEI driver on LBG SPS (server) platforms, some corner
flows such as recovery mode does not work, and the driver
doesn't have working use cases.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200428211200.12200-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me.c  | 8 ++++++++
 drivers/misc/mei/hw-me.h  | 4 ++++
 drivers/misc/mei/pci-me.c | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 668418d7ea77..f620442addf5 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1465,6 +1465,13 @@ static const struct mei_cfg mei_me_pch12_cfg = {
 	MEI_CFG_DMA_128,
 };
 
+/* LBG with quirk for SPS Firmware exclusion */
+static const struct mei_cfg mei_me_pch12_sps_cfg = {
+	MEI_CFG_PCH8_HFS,
+	MEI_CFG_FW_VER_SUPP,
+	MEI_CFG_FW_SPS,
+};
+
 /* Tiger Lake and newer devices */
 static const struct mei_cfg mei_me_pch15_cfg = {
 	MEI_CFG_PCH8_HFS,
@@ -1487,6 +1494,7 @@ static const struct mei_cfg *const mei_cfg_list[] = {
 	[MEI_ME_PCH8_CFG] = &mei_me_pch8_cfg,
 	[MEI_ME_PCH8_SPS_CFG] = &mei_me_pch8_sps_cfg,
 	[MEI_ME_PCH12_CFG] = &mei_me_pch12_cfg,
+	[MEI_ME_PCH12_SPS_CFG] = &mei_me_pch12_sps_cfg,
 	[MEI_ME_PCH15_CFG] = &mei_me_pch15_cfg,
 };
 
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 4a8d4dcd5a91..b6b94e211464 100644
--- a/drivers/misc/mei/hw-me.h
+++ b/drivers/misc/mei/hw-me.h
@@ -80,6 +80,9 @@ struct mei_me_hw {
  *                         servers platforms with quirk for
  *                         SPS firmware exclusion.
  * @MEI_ME_PCH12_CFG:      Platform Controller Hub Gen12 and newer
+ * @MEI_ME_PCH12_SPS_CFG:  Platform Controller Hub Gen12 and newer
+ *                         servers platforms with quirk for
+ *                         SPS firmware exclusion.
  * @MEI_ME_PCH15_CFG:      Platform Controller Hub Gen15 and newer
  * @MEI_ME_NUM_CFG:        Upper Sentinel.
  */
@@ -93,6 +96,7 @@ enum mei_cfg_idx {
 	MEI_ME_PCH8_CFG,
 	MEI_ME_PCH8_SPS_CFG,
 	MEI_ME_PCH12_CFG,
+	MEI_ME_PCH12_SPS_CFG,
 	MEI_ME_PCH15_CFG,
 	MEI_ME_NUM_CFG,
 };
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 0c390fe421ad..a1ed375fed37 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -70,7 +70,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_2, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H, MEI_ME_PCH8_SPS_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H_2, MEI_ME_PCH8_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_BXT_M, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_APL_I, MEI_ME_PCH8_CFG)},
-- 
2.26.2


