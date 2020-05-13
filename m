Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED3F1D0D9D
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388094AbgEMJya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388102AbgEMJy3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:54:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF2D5205ED;
        Wed, 13 May 2020 09:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363668;
        bh=wfDPOwsVMlzcIDXAcbA6PHnmbspXvwVlZpAvciyZoFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u90cJODDSfM6dVpM6IarGt4OCq8aZPhv6TUHN8DY8uEf92Zq6klkzk5MqXWxO1TBE
         /RvH4gm4bXQO90SXMoZxs8sXEC4bVf+0Bq/B9/5BFnHgvSpMdMKjABTw6uUQQsdBGm
         aKNpo756gwuyEL7S2vilQXtVtU/cdujuJf+K5bVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.6 078/118] mei: me: disable mei interface on LBG servers.
Date:   Wed, 13 May 2020 11:44:57 +0200
Message-Id: <20200513094424.408115041@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094417.618129545@linuxfoundation.org>
References: <20200513094417.618129545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

commit d76bc8200f9cf8b6746e66b37317ba477eda25c4 upstream.

Disable the MEI driver on LBG SPS (server) platforms, some corner
flows such as recovery mode does not work, and the driver
doesn't have working use cases.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20200428211200.12200-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c  |    8 ++++++++
 drivers/misc/mei/hw-me.h  |    4 ++++
 drivers/misc/mei/pci-me.c |    2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -1465,6 +1465,13 @@ static const struct mei_cfg mei_me_pch12
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
@@ -1487,6 +1494,7 @@ static const struct mei_cfg *const mei_c
 	[MEI_ME_PCH8_CFG] = &mei_me_pch8_cfg,
 	[MEI_ME_PCH8_SPS_CFG] = &mei_me_pch8_sps_cfg,
 	[MEI_ME_PCH12_CFG] = &mei_me_pch12_cfg,
+	[MEI_ME_PCH12_SPS_CFG] = &mei_me_pch12_sps_cfg,
 	[MEI_ME_PCH15_CFG] = &mei_me_pch15_cfg,
 };
 
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
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -79,7 +79,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_2, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H, MEI_ME_PCH8_SPS_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_SPT_H_2, MEI_ME_PCH8_SPS_CFG)},
-	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LBG, MEI_ME_PCH12_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_BXT_M, MEI_ME_PCH8_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_APL_I, MEI_ME_PCH8_CFG)},


