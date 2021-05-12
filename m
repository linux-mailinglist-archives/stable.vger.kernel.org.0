Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5CB37CDD2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237856AbhELQ6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244274AbhELQmv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0040061D3B;
        Wed, 12 May 2021 16:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835930;
        bh=97lRBl8qYFbRlz7al5/xxCOv+4YFLZQEHDMuErLVL+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg0MFgB923MCrfXYnawx3xIC9yTdlL17TfhFEdlwiFoQrRK8k66A6OqUtnQIYVQyO
         297FthVzZiTRJUP/3FcNL7E07LdPnHcpDr/G2sYJI2MH1oClh2BHEIDi/2hxWzOW+Z
         6hLr+hyjIJq0TKuQEGXXr3ZdZ23eD+mAYk2VjCZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 542/677] mt76: mt7921: fix inappropriate WoW setup with the missing ARP informaiton
Date:   Wed, 12 May 2021 16:49:48 +0200
Message-Id: <20210512144855.372084810@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 9c9d83213424679b087267600d53a35acfa0201f ]

Fix the Wake-on-WoWLAN failure should rely on ARP Information is being
updated in time to the firmware.

Fixes: ffa1bf97425b ("mt76: mt7921: introduce PM support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7921/main.c  |  3 ++
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 44 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt7921/mt7921.h    |  3 ++
 3 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 166c9c0eb5fd..cd9fd0e24e3e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -587,6 +587,9 @@ static void mt7921_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_PS)
 		mt7921_mcu_uni_bss_ps(dev, vif);
 
+	if (changed & BSS_CHANGED_ARP_FILTER)
+		mt7921_mcu_update_arp_filter(hw, vif, info);
+
 	mt7921_mutex_release(dev);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index b5cc72e7e81c..62afbad77596 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1304,3 +1304,47 @@ mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		mt76_clear(dev, MT_WF_RFCR(0), MT_WF_RFCR_DROP_OTHER_BEACON);
 	}
 }
+
+int mt7921_mcu_update_arp_filter(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_bss_conf *info)
+{
+	struct mt7921_vif *mvif = (struct mt7921_vif *)vif->drv_priv;
+	struct mt7921_dev *dev = mt7921_hw_dev(hw);
+	struct sk_buff *skb;
+	int i, len = min_t(int, info->arp_addr_cnt,
+			   IEEE80211_BSS_ARP_ADDR_LIST_LEN);
+	struct {
+		struct {
+			u8 bss_idx;
+			u8 pad[3];
+		} __packed hdr;
+		struct mt76_connac_arpns_tlv arp;
+	} req_hdr = {
+		.hdr = {
+			.bss_idx = mvif->mt76.idx,
+		},
+		.arp = {
+			.tag = cpu_to_le16(UNI_OFFLOAD_OFFLOAD_ARP),
+			.len = cpu_to_le16(sizeof(struct mt76_connac_arpns_tlv)),
+			.ips_num = len,
+			.mode = 2,  /* update */
+			.option = 1,
+		},
+	};
+
+	skb = mt76_mcu_msg_alloc(&dev->mt76, NULL,
+				 sizeof(req_hdr) + len * sizeof(__be32));
+	if (!skb)
+		return -ENOMEM;
+
+	skb_put_data(skb, &req_hdr, sizeof(req_hdr));
+	for (i = 0; i < len; i++) {
+		u8 *addr = (u8 *)skb_put(skb, sizeof(__be32));
+
+		memcpy(addr, &info->arp_addr_list[i], sizeof(__be32));
+	}
+
+	return mt76_mcu_skb_send_msg(&dev->mt76, skb, MCU_UNI_CMD_OFFLOAD,
+				     true);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 2979d06ee0ad..25a1a6acb6ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -339,4 +339,7 @@ int mt7921_mac_set_beacon_filter(struct mt7921_phy *phy,
 				 bool enable);
 void mt7921_pm_interface_iter(void *priv, u8 *mac, struct ieee80211_vif *vif);
 void mt7921_coredump_work(struct work_struct *work);
+int mt7921_mcu_update_arp_filter(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_bss_conf *info);
 #endif
-- 
2.30.2



