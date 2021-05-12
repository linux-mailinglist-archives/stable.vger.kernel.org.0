Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6865F37C9F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhELQX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240577AbhELQSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F261261D77;
        Wed, 12 May 2021 15:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834271;
        bh=s3bfPF3oHxBiUjwM5Vv+Oy2OVq6HW7wgTAH5gF//9Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucUeC1NOFv2Iep2Xo1HdYFXp9iNau9yrURKlgeEodAI3+/jzVdLgvbM0cupHqHw6M
         cVG5Mo/LFbGMhqfFxCxIFZGE2pwQxNPCGY1pVFZ4J/t90U3071Mg41Hgh5H0gQlyI6
         iwzzX1WV2P23xDUTYYgThIl/ff0ANAW+gBevu5Gc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 476/601] mt76: mt7915: bring up the WA event rx queue for band1
Date:   Wed, 12 May 2021 16:49:13 +0200
Message-Id: <20210512144843.521147903@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 76027f40f5ee04bf15cde3a83af9b873c2affa28 ]

This is needed for DBDC cards to work correctly on both bands simultaneously

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 1 +
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    | 8 ++++++++
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h | 1 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   | 3 ++-
 5 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 3e496a188bf0..5da6b74687ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -81,6 +81,7 @@ enum mt76_rxq_id {
 	MT_RXQ_MCU,
 	MT_RXQ_MCU_WA,
 	MT_RXQ_EXT,
+	MT_RXQ_EXT_WA,
 	__MT_RXQ_MAX
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index 8c1f9c77b14f..d47d8f4376c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -286,6 +286,14 @@ int mt7915_dma_init(struct mt7915_dev *dev)
 				       rx_buf_size, MT_RX_DATA_RING_BASE);
 		if (ret)
 			return ret;
+
+		/* event from WA */
+		ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_EXT_WA],
+				       MT7915_RXQ_MCU_WA_EXT,
+				       MT7915_RX_MCU_RING_SIZE,
+				       rx_buf_size, MT_RX_EVENT_RING_BASE);
+		if (ret)
+			return ret;
 	}
 
 	ret = mt76_init_queues(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
index fe88ff24f241..6bfb6f1bb878 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h
@@ -61,6 +61,7 @@ enum mt7915_rxq_id {
 	MT7915_RXQ_BAND1,
 	MT7915_RXQ_MCU_WM = 0,
 	MT7915_RXQ_MCU_WA,
+	MT7915_RXQ_MCU_WA_EXT,
 };
 
 struct mt7915_sta_stats {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
index aeb86fbea41c..99f11588601d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/pci.c
@@ -26,6 +26,7 @@ mt7915_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
 		[MT_RXQ_EXT] = MT_INT_RX_DONE_DATA1,
 		[MT_RXQ_MCU] = MT_INT_RX_DONE_WM,
 		[MT_RXQ_MCU_WA] = MT_INT_RX_DONE_WA,
+		[MT_RXQ_EXT_WA] = MT_INT_RX_DONE_WA_EXT,
 	};
 
 	mt7915_irq_enable(dev, rx_irq_mask[q]);
@@ -67,6 +68,9 @@ static irqreturn_t mt7915_irq_handler(int irq, void *dev_instance)
 	if (intr & MT_INT_RX_DONE_WA)
 		napi_schedule(&dev->mt76.napi[MT_RXQ_MCU_WA]);
 
+	if (intr & MT_INT_RX_DONE_WA_EXT)
+		napi_schedule(&dev->mt76.napi[MT_RXQ_EXT_WA]);
+
 	if (intr & MT_INT_MCU_CMD) {
 		u32 val = mt76_rr(dev, MT_MCU_CMD);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index 848703e6eb7c..294cc0769331 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -342,7 +342,8 @@
 #define MT_INT_RX_DONE_DATA1		BIT(17)
 #define MT_INT_RX_DONE_WM		BIT(0)
 #define MT_INT_RX_DONE_WA		BIT(1)
-#define MT_INT_RX_DONE_ALL		(BIT(0) | BIT(1) | GENMASK(17, 16))
+#define MT_INT_RX_DONE_WA_EXT		BIT(2)
+#define MT_INT_RX_DONE_ALL		(GENMASK(2, 0) | GENMASK(17, 16))
 #define MT_INT_TX_DONE_MCU_WA		BIT(15)
 #define MT_INT_TX_DONE_FWDL		BIT(26)
 #define MT_INT_TX_DONE_MCU_WM		BIT(27)
-- 
2.30.2



