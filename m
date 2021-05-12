Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0237C9E4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236909AbhELQXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240572AbhELQSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B4661D76;
        Wed, 12 May 2021 15:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834269;
        bh=0crU0swUpVbJ5YZC4AXLCdisuFWGaTi/yA704myJhi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YftvdULdaWXgi2KprxU6+9E7ykk6CToM1Jnsh0QjDxLfgnFOTH3yOBE6smKkHSsMj
         CkYGz5/77jepHQNe9Ntg5W0gAfXR9GraJ0VRI9u6nXfyFsafXDF6plUzpWDzUebrdk
         DoIOG5irtYT66siPlseiJNAEckSkLRaPJD4+/G0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 475/601] mt76: mt7615: cleanup mcu tx queue in mt7615_dma_reset()
Date:   Wed, 12 May 2021 16:49:12 +0200
Message-Id: <20210512144843.491046301@linuxfoundation.org>
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

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 69e74d7f23d515fb559b2e0bebfdf4c458d9507d ]

With this patch, mt7615_mac_reset_work() can recover system back.

Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index 052d96f6fd66..2cb24c26a074 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -2032,15 +2032,17 @@ void mt7615_dma_reset(struct mt7615_dev *dev)
 	mt76_clear(dev, MT_WPDMA_GLO_CFG,
 		   MT_WPDMA_GLO_CFG_RX_DMA_EN | MT_WPDMA_GLO_CFG_TX_DMA_EN |
 		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+
 	usleep_range(1000, 2000);
 
-	mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[MT_MCUQ_WM], true);
 	for (i = 0; i < __MT_TXQ_MAX; i++)
 		mt76_queue_tx_cleanup(dev, dev->mphy.q_tx[i], true);
 
-	mt76_for_each_q_rx(&dev->mt76, i) {
+	for (i = 0; i < __MT_MCUQ_MAX; i++)
+		mt76_queue_tx_cleanup(dev, dev->mt76.q_mcu[i], true);
+
+	mt76_for_each_q_rx(&dev->mt76, i)
 		mt76_queue_rx_reset(dev, i);
-	}
 
 	mt76_set(dev, MT_WPDMA_GLO_CFG,
 		 MT_WPDMA_GLO_CFG_RX_DMA_EN | MT_WPDMA_GLO_CFG_TX_DMA_EN |
-- 
2.30.2



