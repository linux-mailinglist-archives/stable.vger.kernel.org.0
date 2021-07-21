Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32403D0F40
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 15:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237196AbhGUM3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 08:29:30 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:40114 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S236534AbhGUM33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 08:29:29 -0400
X-UUID: f92424eb53414540ae85891240b53b3b-20210721
X-UUID: f92424eb53414540ae85891240b53b3b-20210721
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1488483621; Wed, 21 Jul 2021 21:10:02 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 21 Jul 2021 21:10:01 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 21:10:01 +0800
From:   Deren Wu <Deren.Wu@mediatek.com>
To:     <stable@vger.kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Jimmy Hu <Jimmy.Hu@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>
Subject: [PATCH] mt76: mt7921: fix the insmod hangs
Date:   Wed, 21 Jul 2021 21:09:18 +0800
Message-ID: <20210721130918.4491-1-Deren.Wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 49897c529f85504139a6e54417a65f26a07492d2 ]

Fix the second insert module causing the device hangs after remove module.

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=49897c529f85504139a6e54417a65f26a07492d2
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Cc: <stable@vger.kernel.org> # 5.12
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |  2 --
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  3 +--
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    | 13 +------------
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  1 +
 4 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 262c9d150bf0..9046bbfc0690 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -273,8 +273,6 @@ void mt7921_unregister_device(struct mt7921_dev *dev)
 {
 	mt76_unregister_device(&dev->mt76);
 	mt7921_mcu_exit(dev);
-	mt7921_dma_cleanup(dev);
-
 	mt7921_tx_token_put(dev);
 
 	tasklet_disable(&dev->irq_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
index f3a537c6e3c8..36eaa9d97f64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mac.c
@@ -1207,8 +1207,7 @@ void mt7921_update_channel(struct mt76_dev *mdev)
 	mt76_connac_power_save_sched(&dev->mphy, &dev->pm);
 }
 
-static int
-mt7921_wfsys_reset(struct mt7921_dev *dev)
+int mt7921_wfsys_reset(struct mt7921_dev *dev)
 {
 	mt76_set(dev, 0x70002600, BIT(0));
 	msleep(200);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 353877f1c762..b233b12860ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -960,18 +960,7 @@ int mt7921_mcu_init(struct mt7921_dev *dev)
 
 void mt7921_mcu_exit(struct mt7921_dev *dev)
 {
-	u32 reg = mt7921_reg_map_l1(dev, MT_TOP_MISC);
-
-	__mt76_mcu_restart(&dev->mt76);
-	if (!mt76_poll_msec(dev, reg, MT_TOP_MISC_FW_STATE,
-			    FIELD_PREP(MT_TOP_MISC_FW_STATE,
-				       FW_STATE_FW_DOWNLOAD), 1000)) {
-		dev_err(dev->mt76.dev, "Failed to exit mcu\n");
-		return;
-	}
-
-	reg = mt7921_reg_map_l1(dev, MT_TOP_LPCR_HOST_BAND0);
-	mt76_wr(dev, reg, MT_TOP_LPCR_HOST_FW_OWN);
+	mt7921_wfsys_reset(dev);
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index ebe51017dd55..e4211b049040 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -351,4 +351,5 @@ void mt7921_coredump_work(struct work_struct *work);
 int mt7921_mcu_update_arp_filter(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info);
+int mt7921_wfsys_reset(struct mt7921_dev *dev);
 #endif
-- 
2.25.1

