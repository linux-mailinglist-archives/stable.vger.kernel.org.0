Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB194510DF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242686AbhKOSz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:55:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243241AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3239C633C5;
        Mon, 15 Nov 2021 18:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999867;
        bh=CZR8n49eweZd+DJCKiQsgB+iVDajs6LrgcId3WBiims=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTSWKfg0ewbN9qjh4XW8N6uaRUc4ay2Hzu18TM2Dxh8n07/k5ECcY4S/L1b+FMTZs
         JnmHOqQv1yanD/4fuTXkxE+LnQ4CmthdzCzH5ekageZVc/PJfxY6asR+2qwBaXQJ1j
         lfq/+Xp4T59lF6gnEPc5EsxmJJCb695gDDuGTTLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 452/849] mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi
Date:   Mon, 15 Nov 2021 17:58:55 +0100
Message-Id: <20211115165435.581682272@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d81bfb41e30c42531536c5d2baa4d275a8309715 ]

Fix the following sparse warning in mt7615_mac_write_txwi routine:
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:758:17:
	warning: incorrect type in assignment
	expected restricted __le32 [usertype]
	got unsigned long

Fixes: 04b8e65922f63 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Fixes: d4bf77bd74930 ("mt76: mt7615: introduce mt7663u support to mt7615_write_txwi")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index a83e48c07a71e..5455231f51881 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -755,12 +755,15 @@ int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
 		txwi[3] |= cpu_to_le32(MT_TXD3_NO_ACK);
 
-	txwi[7] = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
-		  FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype) |
-		  FIELD_PREP(MT_TXD7_SPE_IDX, 0x18);
-	if (!is_mmio)
-		txwi[8] = FIELD_PREP(MT_TXD8_L_TYPE, fc_type) |
-			  FIELD_PREP(MT_TXD8_L_SUB_TYPE, fc_stype);
+	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
+	      FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype) |
+	      FIELD_PREP(MT_TXD7_SPE_IDX, 0x18);
+	txwi[7] = cpu_to_le32(val);
+	if (!is_mmio) {
+		val = FIELD_PREP(MT_TXD8_L_TYPE, fc_type) |
+		      FIELD_PREP(MT_TXD8_L_SUB_TYPE, fc_stype);
+		txwi[8] = cpu_to_le32(val);
+	}
 
 	return 0;
 }
-- 
2.33.0



