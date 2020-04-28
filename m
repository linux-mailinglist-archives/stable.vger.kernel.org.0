Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82BC1BCE3F
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 23:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD1VMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 17:12:10 -0400
Received: from mga18.intel.com ([134.134.136.126]:22927 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgD1VMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 17:12:09 -0400
IronPort-SDR: 0a4K5CDIDSssRM8LbKm0bXSlFi+fHanRkL1fVBEPy/47OtWY6oP93QULHzrgFNePK1ub2iWBZC
 NN8OqwUbwpdQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2020 14:12:09 -0700
IronPort-SDR: 3INkQOgdolFGme8Res26guqO3hCdfEYxWfUT/B1aiHCYXpHTGnqYcdAMs33ilqDUQ+Cuk1Q5Q1
 QG9sJdBGznbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,328,1583222400"; 
   d="scan'208";a="261226601"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.155])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2020 14:12:07 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [char-misc] mei: me: disable mei interface on LBG servers.
Date:   Wed, 29 Apr 2020 00:12:00 +0300
Message-Id: <20200428211200.12200-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Disable the MEI driver on LBG SPS (server) platforms, some corner
flows such as recovery mode does not work, and the driver
doesn't have working use cases.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
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
index 3d21c38e2dbb..d4899a430e9d 100644
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
2.21.1

