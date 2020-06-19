Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B087A201218
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405216AbgFSPsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393021AbgFSPZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:25:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4BD421556;
        Fri, 19 Jun 2020 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580338;
        bh=wwX3oMSrctskPbGkvudSONYgRfHBUkGW7Urvxsugfos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoG9yocvOvvo7CPu3XhYvXCmfFZO4v5fCxo9OkPL7n2Rx1wHr/74w6Zz9/jrzLDMx
         ZeT/DY6sUuwthHWBn2O+MhOFRTgCGUdbfhZS5HzAPIZ7+vXYsisco8dgPokMX38+j2
         AzLri3GkbA0rohM/kix4gc2fGXpnTBYdVyj58WbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <soul.huang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 181/376] mt76: mt7663: fix DMA unmap length
Date:   Fri, 19 Jun 2020 16:31:39 +0200
Message-Id: <20200619141718.919294293@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 89829c9e65ab680f7e5a1658cb74bc6316ab036e ]

Fix DMA unmap length for mt7663e devices in mt7615_txp_skb_unmap_hw

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Soul Huang <soul.huang@mediatek.com>
Signed-off-by: Soul Huang <soul.huang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 20 +++++++++++++------
 .../net/wireless/mediatek/mt76/mt7615/mac.h   |  2 ++
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index b5249d08564c..f66b76ff2978 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -666,15 +666,18 @@ mt7615_txp_skb_unmap_fw(struct mt76_dev *dev, struct mt7615_fw_txp *txp)
 static void
 mt7615_txp_skb_unmap_hw(struct mt76_dev *dev, struct mt7615_hw_txp *txp)
 {
+	u32 last_mask;
 	int i;
 
+	last_mask = is_mt7663(dev) ? MT_TXD_LEN_LAST : MT_TXD_LEN_MSDU_LAST;
+
 	for (i = 0; i < ARRAY_SIZE(txp->ptr); i++) {
 		struct mt7615_txp_ptr *ptr = &txp->ptr[i];
 		bool last;
 		u16 len;
 
 		len = le16_to_cpu(ptr->len0);
-		last = len & MT_TXD_LEN_MSDU_LAST;
+		last = len & last_mask;
 		len &= MT_TXD_LEN_MASK;
 		dma_unmap_single(dev->dev, le32_to_cpu(ptr->buf0), len,
 				 DMA_TO_DEVICE);
@@ -682,7 +685,7 @@ mt7615_txp_skb_unmap_hw(struct mt76_dev *dev, struct mt7615_hw_txp *txp)
 			break;
 
 		len = le16_to_cpu(ptr->len1);
-		last = len & MT_TXD_LEN_MSDU_LAST;
+		last = len & last_mask;
 		len &= MT_TXD_LEN_MASK;
 		dma_unmap_single(dev->dev, le32_to_cpu(ptr->buf1), len,
 				 DMA_TO_DEVICE);
@@ -1098,21 +1101,26 @@ mt7615_write_hw_txp(struct mt7615_dev *dev, struct mt76_tx_info *tx_info,
 {
 	struct mt7615_hw_txp *txp = txp_ptr;
 	struct mt7615_txp_ptr *ptr = &txp->ptr[0];
-	int nbuf = tx_info->nbuf - 1;
-	int i;
+	int i, nbuf = tx_info->nbuf - 1;
+	u32 last_mask;
 
 	tx_info->buf[0].len = MT_TXD_SIZE + sizeof(*txp);
 	tx_info->nbuf = 1;
 
 	txp->msdu_id[0] = cpu_to_le16(id | MT_MSDU_ID_VALID);
 
+	if (is_mt7663(&dev->mt76))
+		last_mask = MT_TXD_LEN_LAST;
+	else
+		last_mask = MT_TXD_LEN_AMSDU_LAST |
+			    MT_TXD_LEN_MSDU_LAST;
+
 	for (i = 0; i < nbuf; i++) {
 		u16 len = tx_info->buf[i + 1].len & MT_TXD_LEN_MASK;
 		u32 addr = tx_info->buf[i + 1].addr;
 
 		if (i == nbuf - 1)
-			len |= MT_TXD_LEN_MSDU_LAST |
-			       MT_TXD_LEN_AMSDU_LAST;
+			len |= last_mask;
 
 		if (i & 1) {
 			ptr->buf1 = cpu_to_le32(addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
index 53ac184ab2d6..d3da40df7f32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -255,6 +255,8 @@ enum tx_phy_bandwidth {
 #define MT_TXD_LEN_MASK			GENMASK(11, 0)
 #define MT_TXD_LEN_MSDU_LAST		BIT(14)
 #define MT_TXD_LEN_AMSDU_LAST		BIT(15)
+/* mt7663 */
+#define MT_TXD_LEN_LAST			BIT(15)
 
 struct mt7615_txp_ptr {
 	__le32 buf0;
-- 
2.25.1



