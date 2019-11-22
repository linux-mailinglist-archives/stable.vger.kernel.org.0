Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 826F6106EE2
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfKVLLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:49864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730868AbfKVK7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A528F20706;
        Fri, 22 Nov 2019 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420348;
        bh=urMkjndaCFT8P0B6YUlwM2kbeo3+BVId8Tiq7RtV6pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=df8cISyilpwZ5Trkg1pj1rU4BCijUM1Ds0XlA3dQU3bmxE+WsoXVAPx+M0Zznxymp
         lqgFO99cy4DLe6Yru5V7qpGBE5zWDo2xKkFPdFfpNi8t6slQqcomfE2DRQ56yBdYor
         uwXl8icW8JE/BIiJWDCvWDVIXStQJx7cKNSZfhLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 032/220] mt76x2: disable WLAN core before probe
Date:   Fri, 22 Nov 2019 11:26:37 +0100
Message-Id: <20191122100914.699320675@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 62e04f8a31fcc375c978b7f83b4229a10c3e746d ]

If the WLAN core is still active during initialization, it might cause
the MCU or DMA to hang. This can happen during soft reboot, so disable
the core + clock early to avoid this issue.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c         | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 324b2a4b8b67c..54a9e1dfaf7a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -72,6 +72,9 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 {
 	u32 val;
 
+	if (!enable)
+		goto out;
+
 	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
 
 	val &= ~MT_WLAN_FUN_CTRL_FRC_WL_ANT_SEL;
@@ -87,6 +90,7 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
 	udelay(20);
 
+out:
 	mt76x2_set_wlan_state(dev, enable);
 }
 EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
index e66f047ea4481..26cfda24ce085 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -53,6 +53,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+	mt76x2_reset_wlan(dev, false);
 
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
-- 
2.20.1



