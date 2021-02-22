Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BE83215EF
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBVMPL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230261AbhBVMOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD8760C3E;
        Mon, 22 Feb 2021 12:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996029;
        bh=tu95Ey8D12jZg/R9mceQ2cio8kmJ7Gfw3dkobEdymms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CqUOEKuTsAmJHF5zBGgJfQ4HQjEQOhxyu/MY8N6ZfBwcoQ/imKbOD4JizreWVIaST
         BSse6XsIaqUgXcoHvueWK+UnabmOaKhuME4bn5Su3kiIO7P9a3JxugNReH03LyPGWY
         d0Es+NJ8PWZq0s3RMg8+9WaZQw/thDBK7AO5CTVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 10/29] mt76: mt7915: fix endian issues
Date:   Mon, 22 Feb 2021 13:13:04 +0100
Message-Id: <20210222121021.741215487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit cee236e1489ecca9d23d6ce6f60d126cc651a5ba ]

Multiple MCU messages were using u16/u32 fields without endian annotations
or conversions

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Fixes: 5517f78b0063 ("mt76: mt7915: enable firmware module debug support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 87 +++++++++++++++----
 1 file changed, 68 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index a3ccc17856615..ea71409751519 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2835,7 +2835,7 @@ int mt7915_mcu_fw_dbg_ctrl(struct mt7915_dev *dev, u32 module, u8 level)
 	struct {
 		u8 ver;
 		u8 pad;
-		u16 len;
+		__le16 len;
 		u8 level;
 		u8 rsv[3];
 		__le32 module_idx;
@@ -3070,12 +3070,12 @@ int mt7915_mcu_rdd_cmd(struct mt7915_dev *dev,
 int mt7915_mcu_set_fcc5_lpn(struct mt7915_dev *dev, int val)
 {
 	struct {
-		u32 tag;
-		u16 min_lpn;
+		__le32 tag;
+		__le16 min_lpn;
 		u8 rsv[2];
 	} __packed req = {
-		.tag = 0x1,
-		.min_lpn = val,
+		.tag = cpu_to_le32(0x1),
+		.min_lpn = cpu_to_le16(val),
 	};
 
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
@@ -3086,14 +3086,29 @@ int mt7915_mcu_set_pulse_th(struct mt7915_dev *dev,
 			    const struct mt7915_dfs_pulse *pulse)
 {
 	struct {
-		u32 tag;
-		struct mt7915_dfs_pulse pulse;
+		__le32 tag;
+
+		__le32 max_width;		/* us */
+		__le32 max_pwr;			/* dbm */
+		__le32 min_pwr;			/* dbm */
+		__le32 min_stgr_pri;		/* us */
+		__le32 max_stgr_pri;		/* us */
+		__le32 min_cr_pri;		/* us */
+		__le32 max_cr_pri;		/* us */
 	} __packed req = {
-		.tag = 0x3,
+		.tag = cpu_to_le32(0x3),
+
+#define __req_field(field) .field = cpu_to_le32(pulse->field)
+		__req_field(max_width),
+		__req_field(max_pwr),
+		__req_field(min_pwr),
+		__req_field(min_stgr_pri),
+		__req_field(max_stgr_pri),
+		__req_field(min_cr_pri),
+		__req_field(max_cr_pri),
+#undef __req_field
 	};
 
-	memcpy(&req.pulse, pulse, sizeof(*pulse));
-
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
 				   &req, sizeof(req), true);
 }
@@ -3102,16 +3117,50 @@ int mt7915_mcu_set_radar_th(struct mt7915_dev *dev, int index,
 			    const struct mt7915_dfs_pattern *pattern)
 {
 	struct {
-		u32 tag;
-		u16 radar_type;
-		struct mt7915_dfs_pattern pattern;
+		__le32 tag;
+		__le16 radar_type;
+
+		u8 enb;
+		u8 stgr;
+		u8 min_crpn;
+		u8 max_crpn;
+		u8 min_crpr;
+		u8 min_pw;
+		u32 min_pri;
+		u32 max_pri;
+		u8 max_pw;
+		u8 min_crbn;
+		u8 max_crbn;
+		u8 min_stgpn;
+		u8 max_stgpn;
+		u8 min_stgpr;
+		u8 rsv[2];
+		u32 min_stgpr_diff;
 	} __packed req = {
-		.tag = 0x2,
-		.radar_type = index,
+		.tag = cpu_to_le32(0x2),
+		.radar_type = cpu_to_le16(index),
+
+#define __req_field_u8(field) .field = pattern->field
+#define __req_field_u32(field) .field = cpu_to_le32(pattern->field)
+		__req_field_u8(enb),
+		__req_field_u8(stgr),
+		__req_field_u8(min_crpn),
+		__req_field_u8(max_crpn),
+		__req_field_u8(min_crpr),
+		__req_field_u8(min_pw),
+		__req_field_u32(min_pri),
+		__req_field_u32(max_pri),
+		__req_field_u8(max_pw),
+		__req_field_u8(min_crbn),
+		__req_field_u8(max_crbn),
+		__req_field_u8(min_stgpn),
+		__req_field_u8(max_stgpn),
+		__req_field_u8(min_stgpr),
+		__req_field_u32(min_stgpr_diff),
+#undef __req_field_u8
+#undef __req_field_u32
 	};
 
-	memcpy(&req.pattern, pattern, sizeof(*pattern));
-
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
 				   &req, sizeof(req), true);
 }
@@ -3342,12 +3391,12 @@ int mt7915_mcu_add_obss_spr(struct mt7915_dev *dev, struct ieee80211_vif *vif,
 		u8 drop_tx_idx;
 		u8 sta_idx;	/* 256 sta */
 		u8 rsv[2];
-		u32 val;
+		__le32 val;
 	} __packed req = {
 		.action = MT_SPR_ENABLE,
 		.arg_num = 1,
 		.band_idx = mvif->band_idx,
-		.val = enable,
+		.val = cpu_to_le32(enable),
 	};
 
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_SPR,
-- 
2.27.0



