Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6836E3215F9
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBVMP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:44746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhBVMOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C8864EEF;
        Mon, 22 Feb 2021 12:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996032;
        bh=xwsFBpM6iHt+NEyE51wmthC6JwKyFWxy3dga04cnfnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOpbrnv16JUUS93oVG0HKxlRsH60f0JD4yu9woMrUT6a56PrfALAauKkSKfid2kZL
         D1ycAzvnqb+MpgP4xagtjpPZz09VTNRnwO4T847RgF1T+ajQ2ZXM8Zmp+mmdifT8vO
         veHFHniHxhL3dU9UXm2CUiqRqth/B94IIE3eVCiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/29] mt76: mt7615: fix rdd mcu cmd endianness
Date:   Mon, 22 Feb 2021 13:13:05 +0100
Message-Id: <20210222121021.841044948@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0211c282bc8aaa15343aadbc6e23043e7057f77d ]

Similar to mt7915 driver, fix mt7615 radar mcu command endianness

Fixes: 2ce73efe0f8e5 ("mt76: mt7615: initialize radar specs from host driver")
Fixes: 70911d9638069 ("mt76: mt7615: add radar pattern test knob to debugfs")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 89 ++++++++++++++-----
 1 file changed, 66 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 31b40fb83f6c1..c31036f57aef8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -2718,11 +2718,11 @@ int mt7615_mcu_rdd_cmd(struct mt7615_dev *dev,
 int mt7615_mcu_set_fcc5_lpn(struct mt7615_dev *dev, int val)
 {
 	struct {
-		u16 tag;
-		u16 min_lpn;
+		__le16 tag;
+		__le16 min_lpn;
 	} req = {
-		.tag = 0x1,
-		.min_lpn = val,
+		.tag = cpu_to_le16(0x1),
+		.min_lpn = cpu_to_le16(val),
 	};
 
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
@@ -2733,14 +2733,27 @@ int mt7615_mcu_set_pulse_th(struct mt7615_dev *dev,
 			    const struct mt7615_dfs_pulse *pulse)
 {
 	struct {
-		u16 tag;
-		struct mt7615_dfs_pulse pulse;
+		__le16 tag;
+		__le32 max_width;	/* us */
+		__le32 max_pwr;		/* dbm */
+		__le32 min_pwr;		/* dbm */
+		__le32 min_stgr_pri;	/* us */
+		__le32 max_stgr_pri;	/* us */
+		__le32 min_cr_pri;	/* us */
+		__le32 max_cr_pri;	/* us */
 	} req = {
-		.tag = 0x3,
+		.tag = cpu_to_le16(0x3),
+#define __req_field(field) .field = cpu_to_le32(pulse->field)
+		__req_field(max_width),
+		__req_field(max_pwr),
+		__req_field(min_pwr),
+		__req_field(min_stgr_pri),
+		__req_field(max_stgr_pri),
+		__req_field(min_cr_pri),
+		__req_field(max_cr_pri),
+#undef  __req_field
 	};
 
-	memcpy(&req.pulse, pulse, sizeof(*pulse));
-
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
 				   &req, sizeof(req), true);
 }
@@ -2749,16 +2762,45 @@ int mt7615_mcu_set_radar_th(struct mt7615_dev *dev, int index,
 			    const struct mt7615_dfs_pattern *pattern)
 {
 	struct {
-		u16 tag;
-		u16 radar_type;
-		struct mt7615_dfs_pattern pattern;
+		__le16 tag;
+		__le16 radar_type;
+		u8 enb;
+		u8 stgr;
+		u8 min_crpn;
+		u8 max_crpn;
+		u8 min_crpr;
+		u8 min_pw;
+		u8 max_pw;
+		__le32 min_pri;
+		__le32 max_pri;
+		u8 min_crbn;
+		u8 max_crbn;
+		u8 min_stgpn;
+		u8 max_stgpn;
+		u8 min_stgpr;
 	} req = {
-		.tag = 0x2,
-		.radar_type = index,
+		.tag = cpu_to_le16(0x2),
+		.radar_type = cpu_to_le16(index),
+#define __req_field_u8(field) .field = pattern->field
+#define __req_field_u32(field) .field = cpu_to_le32(pattern->field)
+		__req_field_u8(enb),
+		__req_field_u8(stgr),
+		__req_field_u8(min_crpn),
+		__req_field_u8(max_crpn),
+		__req_field_u8(min_crpr),
+		__req_field_u8(min_pw),
+		__req_field_u8(max_pw),
+		__req_field_u32(min_pri),
+		__req_field_u32(max_pri),
+		__req_field_u8(min_crbn),
+		__req_field_u8(max_crbn),
+		__req_field_u8(min_stgpn),
+		__req_field_u8(max_stgpn),
+		__req_field_u8(min_stgpr),
+#undef __req_field_u8
+#undef __req_field_u32
 	};
 
-	memcpy(&req.pattern, pattern, sizeof(*pattern));
-
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_TH,
 				   &req, sizeof(req), true);
 }
@@ -2769,9 +2811,9 @@ int mt7615_mcu_rdd_send_pattern(struct mt7615_dev *dev)
 		u8 pulse_num;
 		u8 rsv[3];
 		struct {
-			u32 start_time;
-			u16 width;
-			s16 power;
+			__le32 start_time;
+			__le16 width;
+			__le16 power;
 		} pattern[32];
 	} req = {
 		.pulse_num = dev->radar_pattern.n_pulses,
@@ -2784,10 +2826,11 @@ int mt7615_mcu_rdd_send_pattern(struct mt7615_dev *dev)
 
 	/* TODO: add some noise here */
 	for (i = 0; i < dev->radar_pattern.n_pulses; i++) {
-		req.pattern[i].width = dev->radar_pattern.width;
-		req.pattern[i].power = dev->radar_pattern.power;
-		req.pattern[i].start_time = start_time +
-					    i * dev->radar_pattern.period;
+		u32 ts = start_time + i * dev->radar_pattern.period;
+
+		req.pattern[i].width = cpu_to_le16(dev->radar_pattern.width);
+		req.pattern[i].power = cpu_to_le16(dev->radar_pattern.power);
+		req.pattern[i].start_time = cpu_to_le32(ts);
 	}
 
 	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_RDD_PATTERN,
-- 
2.27.0



