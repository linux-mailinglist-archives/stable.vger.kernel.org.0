Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA863C24E5
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGINZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhGINZX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75FF608FE;
        Fri,  9 Jul 2021 13:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836960;
        bh=q9OITXgE5DD4CSGE8C+bUhcQFUh8Ze3LmF+CEYKwoBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W476csIodyGrmIO/x5NLHc0MpTi+ilHkQkrTn9ac3JRH2SCDVjMJZ8iQCJhRHYKxG
         GThNbbPG3LNqvwOcgh3JxAMNV1+y0nOOngz9N8e7KujoVy5HgGoLuY71EtTgVgvQBD
         SOcxQV63hIZtPsmzIFGqvF4DNtOeRs17rKQahbaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 05/11] mt76: mt7921: introduce mt7921_run_firmware utility routine.
Date:   Fri,  9 Jul 2021 15:21:42 +0200
Message-Id: <20210709131556.746312654@linuxfoundation.org>
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

commit d32464e68ffc9cbec4960cd06f05bf48b3b3703f upstream.

This is a preliminary patch to introduce chip reset for mt7921 devices.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   32 ++++++++++++---------
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    1 
 2 files changed, 20 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -927,6 +927,24 @@ int mt7921_mcu_fw_log_2_host(struct mt79
 				 sizeof(data), false);
 }
 
+int mt7921_run_firmware(struct mt7921_dev *dev)
+{
+	int err;
+
+	err = mt7921_driver_own(dev);
+	if (err)
+		return err;
+
+	err = mt7921_load_firmware(dev);
+	if (err)
+		return err;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
+	mt7921_mcu_fw_log_2_host(dev, 1);
+
+	return 0;
+}
+
 int mt7921_mcu_init(struct mt7921_dev *dev)
 {
 	static const struct mt76_mcu_ops mt7921_mcu_ops = {
@@ -935,22 +953,10 @@ int mt7921_mcu_init(struct mt7921_dev *d
 		.mcu_parse_response = mt7921_mcu_parse_response,
 		.mcu_restart = mt7921_mcu_restart,
 	};
-	int ret;
 
 	dev->mt76.mcu_ops = &mt7921_mcu_ops;
 
-	ret = mt7921_driver_own(dev);
-	if (ret)
-		return ret;
-
-	ret = mt7921_load_firmware(dev);
-	if (ret)
-		return ret;
-
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
-	mt7921_mcu_fw_log_2_host(dev, 1);
-
-	return 0;
+	return mt7921_run_firmware(dev);
 }
 
 void mt7921_mcu_exit(struct mt7921_dev *dev)
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -220,6 +220,7 @@ void mt7921_eeprom_init_sku(struct mt792
 int mt7921_dma_init(struct mt7921_dev *dev);
 void mt7921_dma_prefetch(struct mt7921_dev *dev);
 void mt7921_dma_cleanup(struct mt7921_dev *dev);
+int mt7921_run_firmware(struct mt7921_dev *dev);
 int mt7921_mcu_init(struct mt7921_dev *dev);
 int mt7921_mcu_add_bss_info(struct mt7921_phy *phy,
 			    struct ieee80211_vif *vif, int enable);


