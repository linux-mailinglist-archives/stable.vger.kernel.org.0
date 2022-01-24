Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8027B49975D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448568AbiAXVND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32966 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376690AbiAXVI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:08:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CC29611C8;
        Mon, 24 Jan 2022 21:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7A8C340E5;
        Mon, 24 Jan 2022 21:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058534;
        bh=U34xLw7vLnMhPRMLE74VQLXUltGjNNpQh3KyPaDdGas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzJxtWuo27T+EZ7/viY6Ar9I30cr9zYw454CLRTuVQDuRgznNcKMOMd3RSkDti/9q
         f2K0ukNLp999jMnMsCKnbOgrJkkTbkkyrSPwXdr3CQ7c3gjdTKU4y+YXkKY/p+xDUd
         VH9oNbK7/l2ea/YY8GViZXU+7qLZl9MWpthpjFWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0320/1039] mt76: connac: align MCU_EXT definitions with 7915 driver
Date:   Mon, 24 Jan 2022 19:35:09 +0100
Message-Id: <20220124184136.051857288@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 9d8d136cf0b6d5578442f38ea9eefdf67cc84fc4 ]

Align MCU_EXT and MCU_FW definitions between mt76_connac and mt7915
driver. This is a preliminary patch to reuse mt76_connac in mt7915
driver.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 16 ++++++-------
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 24 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  2 +-
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 397a8bb67ffbf..2232afed72912 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -176,7 +176,7 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	if (cmd == MCU_CMD_PATCH_SEM_CONTROL) {
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
-	} else if (cmd == MCU_EXT_CMD(GET_TEMP)) {
+	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
@@ -2095,8 +2095,8 @@ int mt7615_mcu_set_fcc5_lpn(struct mt7615_dev *dev, int val)
 		.min_lpn = cpu_to_le16(val),
 	};
 
-	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RDD_TH), &req,
-				 sizeof(req), true);
+	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RADAR_TH),
+				 &req, sizeof(req), true);
 }
 
 int mt7615_mcu_set_pulse_th(struct mt7615_dev *dev,
@@ -2124,8 +2124,8 @@ int mt7615_mcu_set_pulse_th(struct mt7615_dev *dev,
 #undef  __req_field
 	};
 
-	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RDD_TH), &req,
-				 sizeof(req), true);
+	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RADAR_TH),
+				 &req, sizeof(req), true);
 }
 
 int mt7615_mcu_set_radar_th(struct mt7615_dev *dev, int index,
@@ -2171,8 +2171,8 @@ int mt7615_mcu_set_radar_th(struct mt7615_dev *dev, int index,
 #undef __req_field_u32
 	};
 
-	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RDD_TH), &req,
-				 sizeof(req), true);
+	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(SET_RADAR_TH),
+				 &req, sizeof(req), true);
 }
 
 int mt7615_mcu_rdd_send_pattern(struct mt7615_dev *dev)
@@ -2372,7 +2372,7 @@ int mt7615_mcu_get_temperature(struct mt7615_dev *dev)
 		u8 rsv[3];
 	} req = {};
 
-	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(GET_TEMP),
+	return mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD(THERMAL_CTRL),
 				 &req, sizeof(req), true);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index 1c7a99bc26261..9dbb6ae9f21da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -516,17 +516,21 @@ enum {
 enum {
 	MCU_EXT_CMD_EFUSE_ACCESS = 0x01,
 	MCU_EXT_CMD_RF_REG_ACCESS = 0x02,
+	MCU_EXT_CMD_RF_TEST = 0x04,
 	MCU_EXT_CMD_PM_STATE_CTRL = 0x07,
 	MCU_EXT_CMD_CHANNEL_SWITCH = 0x08,
 	MCU_EXT_CMD_SET_TX_POWER_CTRL = 0x11,
 	MCU_EXT_CMD_FW_LOG_2_HOST = 0x13,
+	MCU_EXT_CMD_TXBF_ACTION = 0x1e,
 	MCU_EXT_CMD_EFUSE_BUFFER_MODE = 0x21,
+	MCU_EXT_CMD_THERMAL_PROT = 0x23,
 	MCU_EXT_CMD_STA_REC_UPDATE = 0x25,
 	MCU_EXT_CMD_BSS_INFO_UPDATE = 0x26,
 	MCU_EXT_CMD_EDCA_UPDATE = 0x27,
 	MCU_EXT_CMD_DEV_INFO_UPDATE = 0x2A,
-	MCU_EXT_CMD_GET_TEMP = 0x2c,
+	MCU_EXT_CMD_THERMAL_CTRL = 0x2c,
 	MCU_EXT_CMD_WTBL_UPDATE = 0x32,
+	MCU_EXT_CMD_SET_DRR_CTRL = 0x36,
 	MCU_EXT_CMD_SET_RDD_CTRL = 0x3a,
 	MCU_EXT_CMD_ATE_CTRL = 0x3d,
 	MCU_EXT_CMD_PROTECT_CTRL = 0x3e,
@@ -535,13 +539,28 @@ enum {
 	MCU_EXT_CMD_RX_HDR_TRANS = 0x47,
 	MCU_EXT_CMD_MUAR_UPDATE = 0x48,
 	MCU_EXT_CMD_BCN_OFFLOAD = 0x49,
+	MCU_EXT_CMD_RX_AIRTIME_CTRL = 0x4a,
 	MCU_EXT_CMD_SET_RX_PATH = 0x4e,
+	MCU_EXT_CMD_EFUSE_FREE_BLOCK = 0x4f,
 	MCU_EXT_CMD_TX_POWER_FEATURE_CTRL = 0x58,
 	MCU_EXT_CMD_RXDCOC_CAL = 0x59,
+	MCU_EXT_CMD_GET_MIB_INFO = 0x5a,
 	MCU_EXT_CMD_TXDPD_CAL = 0x60,
 	MCU_EXT_CMD_CAL_CACHE = 0x67,
-	MCU_EXT_CMD_SET_RDD_TH = 0x7c,
+	MCU_EXT_CMD_SET_RADAR_TH = 0x7c,
 	MCU_EXT_CMD_SET_RDD_PATTERN = 0x7d,
+	MCU_EXT_CMD_MWDS_SUPPORT = 0x80,
+	MCU_EXT_CMD_SET_SER_TRIGGER = 0x81,
+	MCU_EXT_CMD_SCS_CTRL = 0x82,
+	MCU_EXT_CMD_TWT_AGRT_UPDATE = 0x94,
+	MCU_EXT_CMD_FW_DBG_CTRL = 0x95,
+	MCU_EXT_CMD_OFFCH_SCAN_CTRL = 0x9a,
+	MCU_EXT_CMD_SET_RDD_TH = 0x9d,
+	MCU_EXT_CMD_MURU_CTRL = 0x9f,
+	MCU_EXT_CMD_SET_SPR = 0xa8,
+	MCU_EXT_CMD_GROUP_PRE_CAL_INFO = 0xab,
+	MCU_EXT_CMD_DPD_PRE_CAL_INFO = 0xac,
+	MCU_EXT_CMD_PHY_STAT_INFO = 0xad,
 };
 
 enum {
@@ -561,6 +580,7 @@ enum {
 	MCU_CMD_PATCH_START_REQ = MCU_FW_PREFIX | 0x05,
 	MCU_CMD_PATCH_FINISH_REQ = MCU_FW_PREFIX | 0x07,
 	MCU_CMD_PATCH_SEM_CONTROL = MCU_FW_PREFIX | 0x10,
+	MCU_CMD_WA_PARAM = 0xc4,
 	MCU_CMD_EXT_CID = 0xed,
 	MCU_CMD_FW_SCATTER = MCU_FW_PREFIX | 0xee,
 	MCU_CMD_RESTART_DL_REQ = MCU_FW_PREFIX | 0xef,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 50f0c13f1c41e..51650e9e1845a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -182,7 +182,7 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	if (cmd == MCU_CMD_PATCH_SEM_CONTROL) {
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
-	} else if (cmd == MCU_EXT_CMD(GET_TEMP)) {
+	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
 		skb_pull(skb, sizeof(*rxd) + 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_CMD(EFUSE_ACCESS)) {
-- 
2.34.1



