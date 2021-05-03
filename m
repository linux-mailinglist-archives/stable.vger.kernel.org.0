Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1639371C26
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhECQvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233847AbhECQtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898976192F;
        Mon,  3 May 2021 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060026;
        bh=tDBr1YL/om3BA+QjbMhSLmv9DZ+RSwDryarvMp7Ab2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryN2woFTjvY6dGfLsBJg7n+B0So43GjijR7z33JNfvNfHCoqH2R6RUKF3v4W9876m
         0fFsJ7OqVD/w1AqSbzwg9CJ67DkHkLGLtAieKQlT/bWbtEybm3mtAxA8uNmdTxOYnP
         bN9C2lUFMoqX67H1LVJcQ0uUXVsi6QttYgW83RwKi4rcQiTCWRQm/wFv3mb1DdWkb0
         Cr88go6Y0FdYPYXmNDaotLG6xWpqRH+fkAbI5U73UhB0eZMR78kxB3+l1KW38N0OQl
         twELKZSQp+3vawB5jJvq3s8eYyLA2yWmXEZnuTWroLaNk3R75xbJ/L/YJPo8+emNx7
         yX0nH79cKv/+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xingui Yang <yangxingui@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 29/57] ata: ahci: Disable SXS for Hisilicon Kunpeng920
Date:   Mon,  3 May 2021 12:39:13 -0400
Message-Id: <20210503163941.2853291-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index d33528033042..8beb418ce167 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1728,6 +1728,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index 9ef62e647cd2..732912cd4e08 100644
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

