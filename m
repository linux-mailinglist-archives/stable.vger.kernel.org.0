Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5203C24E6
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhGINZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhGINZ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2276A613C5;
        Fri,  9 Jul 2021 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836962;
        bh=9AVHih9IUu3qx2WhPzSKsM/xNQgOP5+1tn/e3byMiPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TV40BLgOiJr4VwyY7R99TapMPuoIoyCHh/eKIlZ0c1rI9Q7QQAO+obxTdISpD+Lq5
         vo+9ej3uPVcsdm1GykMGc/ah6QHBeHNNL/ePuhvOqjmLVlJkUaw2byUsbDdGa0IeeG
         lvuPp5v3L2gxMOMt+bHArDGbiyJeCzXmCfSj4egg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 06/11] mt76: mt7921: introduce __mt7921_start utility routine
Date:   Fri,  9 Jul 2021 15:21:43 +0200
Message-Id: <20210709131557.974264191@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 1f7396acfef4691b8cf4a3e631fd3f59d779c0f2 upstream.

This is a preliminary patch to introduce mt7921 chip reset support.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   35 ++++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    1 
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -168,33 +168,40 @@ void mt7921_set_stream_he_caps(struct mt
 	}
 }
 
-static int mt7921_start(struct ieee80211_hw *hw)
+int __mt7921_start(struct mt7921_phy *phy)
 {
-	struct mt7921_dev *dev = mt7921_hw_dev(hw);
-	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	struct mt76_phy *mphy = phy->mt76;
 	int err;
 
-	mt7921_mutex_acquire(dev);
-
-	err = mt76_connac_mcu_set_mac_enable(&dev->mt76, 0, true, false);
+	err = mt76_connac_mcu_set_mac_enable(mphy->dev, 0, true, false);
 	if (err)
-		goto out;
+		return err;
 
-	err = mt76_connac_mcu_set_channel_domain(phy->mt76);
+	err = mt76_connac_mcu_set_channel_domain(mphy);
 	if (err)
-		goto out;
+		return err;
 
 	err = mt7921_mcu_set_chan_info(phy, MCU_EXT_CMD_SET_RX_PATH);
 	if (err)
-		goto out;
+		return err;
 
 	mt7921_mac_reset_counters(phy);
-	set_bit(MT76_STATE_RUNNING, &phy->mt76->state);
+	set_bit(MT76_STATE_RUNNING, &mphy->state);
 
-	ieee80211_queue_delayed_work(hw, &phy->mt76->mac_work,
+	ieee80211_queue_delayed_work(mphy->hw, &mphy->mac_work,
 				     MT7921_WATCHDOG_TIME);
-out:
-	mt7921_mutex_release(dev);
+
+	return 0;
+}
+
+static int mt7921_start(struct ieee80211_hw *hw)
+{
+	struct mt7921_phy *phy = mt7921_hw_phy(hw);
+	int err;
+
+	mt7921_mutex_acquire(phy->dev);
+	err = __mt7921_start(phy);
+	mt7921_mutex_release(phy->dev);
 
 	return err;
 }
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -209,6 +209,7 @@ extern struct pci_driver mt7921_pci_driv
 
 u32 mt7921_reg_map(struct mt7921_dev *dev, u32 addr);
 
+int __mt7921_start(struct mt7921_phy *phy);
 int mt7921_register_device(struct mt7921_dev *dev);
 void mt7921_unregister_device(struct mt7921_dev *dev);
 int mt7921_eeprom_init(struct mt7921_dev *dev);


