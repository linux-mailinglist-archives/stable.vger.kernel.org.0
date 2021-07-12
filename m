Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17A93C53DB
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348846AbhGLH4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350743AbhGLHvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40F2761167;
        Mon, 12 Jul 2021 07:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076083;
        bh=adHwr12YBfm53L3ZqnccegRPdUy3fkX16ErK4OS7KSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMNXT5VKa8RfLz9pxx5W8N6tfhyZsOFNLxiHt7kZ0Ro99j44wMacyp1sUCMQa8vUx
         d9EOf0JT+0pxiBXHbaHMXb1bcUyFs2dOlriY4Ba+pJZ4SyOSJnFdSCknbBrkCBAFgi
         4INRSqfFXg1RKemsoeQbWsmNwwTmREiQHzCXe0W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 491/800] mt76: mt7921: fix mt7921_wfsys_reset sequence
Date:   Mon, 12 Jul 2021 08:08:34 +0200
Message-Id: <20210712061019.399074628@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 20eb83c749609199443972cf80fb6004fc36afc6 ]

WiFi subsytem reset should control MT_WFSYS_SW_RST_B and then poll the
same register until the bit WFSYS_SW_INIT_DONE bit is set.

Fixes: 0c1ce9884607 ("mt76: mt7921: add wifi reset support")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index 71e664ee7652..bd9143dc865f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -313,9 +313,9 @@ static int mt7921_dma_reset(struct mt7921_dev *dev, bool force)
 
 int mt7921_wfsys_reset(struct mt7921_dev *dev)
 {
-	mt76_set(dev, 0x70002600, BIT(0));
-	msleep(200);
-	mt76_clear(dev, 0x70002600, BIT(0));
+	mt76_clear(dev, MT_WFSYS_SW_RST_B, WFSYS_SW_RST_B);
+	msleep(50);
+	mt76_set(dev, MT_WFSYS_SW_RST_B, WFSYS_SW_RST_B);
 
 	if (!__mt76_poll_msec(&dev->mt76, MT_WFSYS_SW_RST_B,
 			      WFSYS_SW_INIT_DONE, WFSYS_SW_INIT_DONE, 500))
-- 
2.30.2



