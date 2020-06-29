Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A35C20E7EA
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgF2WBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2477C241A6;
        Mon, 29 Jun 2020 15:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443958;
        bh=gnsYxH96Bjz9snSuLZhMaPlkC3GQAaOV3NO/+KV8V38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f97gPBUDXv6wDc++ONGoUdKUcjNT3ivYzIJsfITvGVYrBMEDvKmFMUAHWnT9bVoa+
         Rhm3O7FNhNu2hfxXh4LfZswMh8MUni8iPK0T7TOunKAgxOovUBfSDcMOILyykqHpyO
         No6SE8PU18B72rz2mHbVFsxYQSXL23tGarJYEgnc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 061/265] mei: me: add tiger lake point device ids for H platforms.
Date:   Mon, 29 Jun 2020 11:14:54 -0400
Message-Id: <20200629151818.2493727-62-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8c289ea064165237891a7b4be77b74d5cba8fa99 upstream.

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
index 01b1bf74f2626..7becfc768bbcc 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -94,6 +94,7 @@
 #define MEI_DEV_ID_JSP_N      0x4DE0  /* Jasper Lake Point N */
 
 #define MEI_DEV_ID_TGP_LP     0xA0E0  /* Tiger Lake Point LP */
+#define MEI_DEV_ID_TGP_H      0x43E0  /* Tiger Lake Point H */
 
 #define MEI_DEV_ID_MCC        0x4B70  /* Mule Creek Canyon (EHL) */
 #define MEI_DEV_ID_MCC_4      0x4B75  /* Mule Creek Canyon 4 (EHL) */
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index f8155c1e811d7..7649710a2ab9e 100644
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
index 52e0c6d578f27..6a8973649c490 100644
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
index f74c6113812d6..81e759674c1b5 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -96,6 +96,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ICP_LP, MEI_ME_PCH12_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_LP, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_TGP_H, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_JSP_N, MEI_ME_PCH15_CFG)},
 
-- 
2.25.1

