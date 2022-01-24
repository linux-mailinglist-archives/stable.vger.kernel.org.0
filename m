Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75525499FEC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842375AbiAXXBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839865AbiAXWwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:52:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF3FC0EE120;
        Mon, 24 Jan 2022 13:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 330BB611C8;
        Mon, 24 Jan 2022 21:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3904C340E5;
        Mon, 24 Jan 2022 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058497;
        bh=Zgw5tDOkd3pkJSgwNk1Z+umTFmDwlMzDGAgBtsl77Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGxOI0XDtp/vwkS5QmdjjNQ1T4IDd7nkLVjhCSroSXhoIiZr+qGnHqe/Dgrb7k7RS
         jmKsL/qYml4vyF8egNsLCrrxprTLcRnuALst218XczChf29DsQtxdrTBik/3bvwgZV
         qRtqmZZEl4c0Za+IgnzsF+Dz+FOvAcyfQQJUytH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YN Chen <YN.Chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0309/1039] mt76: mt7921: fix MT7921E reset failure
Date:   Mon, 24 Jan 2022 19:34:58 +0100
Message-Id: <20220124184135.695052739@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 0efaf31dec572d3aac4316c6d952e06d1c33adc4 ]

There is a missing mt7921e_driver_own in the MT7921E reset procedure
since the mt7921 mcu.c has been refactored for MT7921S, that will
result in MT7921E reset failure, so add it back now.

Fixes: dfc7743de1eb ("mt76: mt7921: refactor mcu.c to be bus independent")
Reported-by: YN Chen <YN.Chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h  | 1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c | 2 +-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index e9c7c3a195076..d6b823713ba33 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -446,6 +446,7 @@ int mt7921_mcu_restart(struct mt76_dev *dev);
 
 void mt7921e_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
+int mt7921e_driver_own(struct mt7921_dev *dev);
 int mt7921e_mac_reset(struct mt7921_dev *dev);
 int mt7921e_mcu_init(struct mt7921_dev *dev);
 int mt7921s_wfsys_reset(struct mt7921_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index f9547d27356e1..85286cc9add14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -321,6 +321,10 @@ int mt7921e_mac_reset(struct mt7921_dev *dev)
 		MT_INT_MCU_CMD);
 	mt76_wr(dev, MT_PCIE_MAC_INT_ENABLE, 0xff);
 
+	err = mt7921e_driver_own(dev);
+	if (err)
+		return err;
+
 	err = mt7921_run_firmware(dev);
 	if (err)
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
index 583a89a34734a..7b34c7f2ab3a6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
@@ -4,7 +4,7 @@
 #include "mt7921.h"
 #include "mcu.h"
 
-static int mt7921e_driver_own(struct mt7921_dev *dev)
+int mt7921e_driver_own(struct mt7921_dev *dev)
 {
 	u32 reg = mt7921_reg_map_l1(dev, MT_TOP_LPCR_HOST_BAND0);
 
-- 
2.34.1



