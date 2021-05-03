Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944E1371B65
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhECQpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232363AbhECQne (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:43:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788B2613CC;
        Mon,  3 May 2021 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059906;
        bh=2NP5te+jZbVJI9Ngj88cWMuWA5RVvd7pvJ2s2BY2Bss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6IYAni00QihauiffYeX6E0I9tadEonZGlYqqACaxGAEnb5CKIdilcuxwZRrqiNfu
         /XYQdaEebngWnDHez+9tfYOOtOCKfk2NpPP9Nd9AaiUN+c9nJ3rDyviFMj29XxziCw
         bxJizly3Cd2XBINrZtxA9KSXXy9bo9JX559Popj0Sw/vGrE2x2RUrcQ+tyRsEfwYgI
         battUkq8qMGSP2DSpgsMdhfye+GoKrijQ5ofjJAVQfLB94OV8qeSF+0wEEhwvS3pbk
         OyusEwL5dHvDRprbPMmnj5yinIweErkWZpum+VIHXC7Uo5zrXNurjJX0jwUiXLZDE5
         LuZkv/+B7kfmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xingui Yang <yangxingui@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 056/115] ata: ahci: Disable SXS for Hisilicon Kunpeng920
Date:   Mon,  3 May 2021 12:36:00 -0400
Message-Id: <20210503163700.2852194-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 234e6d2c18f5b080cde874483c4c361f3ae7cffe ]

On Hisilicon Kunpeng920, ESP is set to 1 by default for all ports of
SATA controller. In some scenarios, some ports are not external SATA ports,
and it cause disks connected to these ports to be identified as removable
disks. So disable the SXS capability on the software side to prevent users
from mistakenly considering non-removable disks as removable disks and
performing related operations.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1615544676-61926-1-git-send-email-luojiaxing@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c    | 5 +++++
 drivers/ata/ahci.h    | 1 +
 drivers/ata/libahci.c | 5 +++++
 3 files changed, 11 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 00ba8e5a1ccc..33192a8f687d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1772,6 +1772,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		hpriv->flags |= AHCI_HFLAG_NO_DEVSLP;
 
 #ifdef CONFIG_ARM64
+	if (pdev->vendor == PCI_VENDOR_ID_HUAWEI &&
+	    pdev->device == 0xa235 &&
+	    pdev->revision < 0x30)
+		hpriv->flags |= AHCI_HFLAG_NO_SXS;
+
 	if (pdev->vendor == 0x177d && pdev->device == 0xa01c)
 		hpriv->irq_handler = ahci_thunderx_irq_handler;
 #endif
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 98b8baa47dc5..d1f284f0c83d 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -242,6 +242,7 @@ enum {
 							suspend/resume */
 	AHCI_HFLAG_IGN_NOTSUPP_POWER_ON	= (1 << 27), /* ignore -EOPNOTSUPP
 							from phy_power_on() */
+	AHCI_HFLAG_NO_SXS		= (1 << 28), /* SXS not supported */
 
 	/* ap->flags bits */
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index ea5bf5f4cbed..fec2e9754aed 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -493,6 +493,11 @@ void ahci_save_initial_config(struct device *dev, struct ahci_host_priv *hpriv)
 		cap |= HOST_CAP_ALPM;
 	}
 
+	if ((cap & HOST_CAP_SXS) && (hpriv->flags & AHCI_HFLAG_NO_SXS)) {
+		dev_info(dev, "controller does not support SXS, disabling CAP_SXS\n");
+		cap &= ~HOST_CAP_SXS;
+	}
+
 	if (hpriv->force_port_map && port_map != hpriv->force_port_map) {
 		dev_info(dev, "forcing port_map 0x%x -> 0x%x\n",
 			 port_map, hpriv->force_port_map);
-- 
2.30.2

