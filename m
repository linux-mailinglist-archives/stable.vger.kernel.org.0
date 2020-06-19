Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA23A2018B8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405782AbgFSQvu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:51:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:45058 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405910AbgFSQvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 12:51:37 -0400
IronPort-SDR: 7DKuKs9BsgC8bYgozX1V6+zelYjTlTy8WFTR7gf6/sYvqg2MhhA/MFKe16WX0eYl1/DsIQPFnl
 d+Io5sLvTvCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9657"; a="130381973"
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="130381973"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 09:51:37 -0700
IronPort-SDR: fQesdqXoj5f565eSwQ8n6HMPiCcEIjPzQpRYqRgx7weOGCWlMRLgjGeOkechWvNS21adpbJ/3c
 mWeUOgP/pXnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="318165176"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2020 09:51:35 -0700
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 7/7] mei: me: add tiger lake point device ids for H platforms.
Date:   Fri, 19 Jun 2020 19:51:21 +0300
Message-Id: <20200619165121.2145330-7-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619165121.2145330-1-tomas.winkler@intel.com>
References: <20200619165121.2145330-1-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add Tiger Lake device ids H for HECI1.
TGH_H is also used in Tatlow SPS platform we need to
disable the mei interface there.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h |  1 +
 drivers/misc/mei/hw-me.c      | 10 ++++++++++
 drivers/misc/mei/hw-me.h      |  4 ++++
 drivers/misc/mei/pci-me.c     |  1 +
 4 files changed, 16 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index b86ce504fdd3..9cf8d8f60cfe 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -96,6 +96,7 @@
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+#define MEI_DEV_ID_TGP_H      0x43E0  /* Tiger Lake Point H */
 
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index e476995e4c56..c51d3da8f333 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1545,6 +1545,15 @@ static const struct mei_cfg mei_me_pch15_cfg = {
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
@@ -1563,6 +1572,7 @@ static const struct mei_cfg *const mei_cfg_list[] = {
 	[MEI_ME_PCH12_SPS_CFG] = &mei_me_pch12_sps_cfg,
 	[MEI_ME_PCH12_SPS_NODMA_CFG] = &mei_me_pch12_nodma_sps_cfg,
 	[MEI_ME_PCH15_CFG] = &mei_me_pch15_cfg,
+	[MEI_ME_PCH15_SPS_CFG] = &mei_me_pch15_sps_cfg,
 };
 
 const struct mei_cfg *mei_me_get_cfg(kernel_ulong_t idx)
diff --git a/drivers/misc/mei/hw-me.h b/drivers/misc/mei/hw-me.h
index 4df51cb8fa4b..560c8ebb17be 100644
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
index 188f59a94118..159e40a2505d 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -98,6 +98,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_JSP_N, MEI_ME_PCH15_CFG)},
 
-- 
2.25.4

