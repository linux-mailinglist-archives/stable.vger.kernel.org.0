Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D68B3C53E3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348816AbhGLH4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350757AbhGLHvQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DCF761208;
        Mon, 12 Jul 2021 07:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076090;
        bh=inc0Uk3zblv6TtM7Xnzo5/hT/4lj96On+fupRqGKR3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ACpPZ5rwtiTxA3I8QBzvXXFP7ilv04Bp63HN7NGQr6ARkzAG3oqKxPN6WDBnQ6inT
         ZwDgSOg8EvXhDfL01apPJG2CHc6MwZPb1axj9L53n8cK4sa0+awTyJrn775ciLTRSx
         8V5TE3QB8t04EWeloCXVk8eUKHmknbFKsmOPmKxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        YN Chen <yn.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 494/800] mt76: connac: fix WoW with disconnetion and bitmap pattern
Date:   Mon, 12 Jul 2021 08:08:37 +0200
Message-Id: <20210712061019.728826243@linuxfoundation.org>
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

From: YN Chen <yn.chen@mediatek.com>

[ Upstream commit 193e5f22eeb2a9661bff8bc0d8519e6ded48c807 ]

Update MCU command usage to fix WoW configuration with disconnection
and bitmap pattern and to avoid magic number.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Reviewed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: YN Chen <yn.chen@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 11 +++++++----
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h |  8 ++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 619561606f96..eb19721f9d79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1939,7 +1939,7 @@ mt76_connac_mcu_set_wow_pattern(struct mt76_dev *dev,
 	ptlv->index = index;
 
 	memcpy(ptlv->pattern, pattern->pattern, pattern->pattern_len);
-	memcpy(ptlv->mask, pattern->mask, pattern->pattern_len / 8);
+	memcpy(ptlv->mask, pattern->mask, DIV_ROUND_UP(pattern->pattern_len, 8));
 
 	return mt76_mcu_skb_send_msg(dev, skb, MCU_UNI_CMD_SUSPEND, true);
 }
@@ -1974,14 +1974,17 @@ mt76_connac_mcu_set_wow_ctrl(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	};
 
 	if (wowlan->magic_pkt)
-		req.wow_ctrl_tlv.trigger |= BIT(0);
+		req.wow_ctrl_tlv.trigger |= UNI_WOW_DETECT_TYPE_MAGIC;
 	if (wowlan->disconnect)
-		req.wow_ctrl_tlv.trigger |= BIT(2);
+		req.wow_ctrl_tlv.trigger |= (UNI_WOW_DETECT_TYPE_DISCONNECT |
+					     UNI_WOW_DETECT_TYPE_BCN_LOST);
 	if (wowlan->nd_config) {
 		mt76_connac_mcu_sched_scan_req(phy, vif, wowlan->nd_config);
-		req.wow_ctrl_tlv.trigger |= BIT(5);
+		req.wow_ctrl_tlv.trigger |= UNI_WOW_DETECT_TYPE_SCH_SCAN_HIT;
 		mt76_connac_mcu_sched_scan_enable(phy, vif, suspend);
 	}
+	if (wowlan->n_patterns)
+		req.wow_ctrl_tlv.trigger |= UNI_WOW_DETECT_TYPE_BITMAP;
 
 	if (mt76_is_mmio(dev))
 		req.wow_ctrl_tlv.wakeup_hif = WOW_PCIE;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
index a1096861d04a..3bcae732872e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.h
@@ -590,6 +590,14 @@ enum {
 	UNI_OFFLOAD_OFFLOAD_BMC_RPY_DETECT,
 };
 
+#define UNI_WOW_DETECT_TYPE_MAGIC		BIT(0)
+#define UNI_WOW_DETECT_TYPE_ANY			BIT(1)
+#define UNI_WOW_DETECT_TYPE_DISCONNECT		BIT(2)
+#define UNI_WOW_DETECT_TYPE_GTK_REKEY_FAIL	BIT(3)
+#define UNI_WOW_DETECT_TYPE_BCN_LOST		BIT(4)
+#define UNI_WOW_DETECT_TYPE_SCH_SCAN_HIT	BIT(5)
+#define UNI_WOW_DETECT_TYPE_BITMAP		BIT(6)
+
 enum {
 	UNI_SUSPEND_MODE_SETTING,
 	UNI_SUSPEND_WOW_CTRL,
-- 
2.30.2



