Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49664513C0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245557AbhKOTzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:55:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344009AbhKOTXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:23:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FFBB63600;
        Mon, 15 Nov 2021 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002214;
        bh=mCECLEOvgmaWwTo89ig9pWLh4ixvcg05NLEY0gQB7Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQ2D86NooXNFNvfc1sP3aMOKAH/qQ9g1TNTeLtJzXh5AoDcLP3xx5zPnHij9q6Kxs
         yZEMNXoJL7KGqfFGmxZmoBDUzAvrIC3ZxIPb/lnm0CrJ+4EKrjHAM39KvAmYCnr7Iv
         VETe3HSMIssO0X0GPXSYld+LxoVdB67hmne7hZO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ryder Lee <ryder.lee@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 480/917] mt76: mt7615: fix monitor mode tear down crash
Date:   Mon, 15 Nov 2021 17:59:35 +0100
Message-Id: <20211115165445.052227615@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit a6fdbdd1ac2996a58a84672ef37efb5cbb98fadf ]

[  103.451600] CPU 3 Unable to handle kernel paging request at virtual address 00000003, epc == 8576591c, ra == 857659f0
[  103.462226] Oops[#1]:
[  103.464499] CPU: 3 PID: 9247 Comm: ifconfig Tainted: G        W         5.4.143 #0
[  103.472031] $ 0   : 00000000 00000001 83be3854 00000000
[  103.477239] $ 4   : 8102a374 8102a374 8102f0b0 00000200
[  103.482444] $ 8   : 0000002d 000001e4 64373765 5d206337
[  103.487647] $12   : 00000000 00000005 00000000 0006d1df
[  103.492853] $16   : 83be3848 853838a8 8743d600 00010000
[  103.498059] $20   : 00000000 00000000 8553dec0 0000007f
[  103.503266] $24   : 00000003 80382084
[  103.508472] $28   : 831d4000 831d5bc0 00000001 857659f0
[  103.513678] Hi    : 00000122
[  103.516543] Lo    : d1768000
[  103.519452] epc   : 8576591c mt7615_mcu_add_bss+0xd0/0x3c0 [mt7615_common]
[  103.526306] ra    : 857659f0 mt7615_mcu_add_bss+0x1a4/0x3c0 [mt7615_common]
[  103.533232] Status: 11007c03 KERNEL EXL IE
[  103.537402] Cause : 40800008 (ExcCode 02)
[  103.541389] BadVA : 00000003
[  103.544253] PrId  : 0001992f (MIPS 1004Kc)
[  103.797086] Call Trace:
[  103.799562] [<8576591c>] mt7615_mcu_add_bss+0xd0/0x3c0 [mt7615_common]
[  103.806082] [<85760a14>] mt7615_remove_interface+0x74/0x1e0 [mt7615_common]
[  103.813280] [<85603fcc>] drv_remove_interface+0x2c/0xa0 [mac80211]
[  103.819612] [<8561a8e4>] ieee80211_del_virtual_monitor.part.22+0x74/0xe8 [mac80211]
[  103.827410] [<8561b7f0>] ieee80211_do_stop+0x4a4/0x8a0 [mac80211]
[  103.833671] [<8561bc00>] ieee80211_stop+0x14/0x24 [mac80211]
[  103.839405] [<8045a328>] __dev_close_many+0x9c/0x10c
[  103.844364] [<80463de4>] __dev_change_flags+0x16c/0x1e4
[  103.849569] [<80463e84>] dev_change_flags+0x28/0x70
[  103.854440] [<80521e54>] devinet_ioctl+0x280/0x774
[  103.859222] [<80526248>] inet_ioctl+0xa4/0x1c8
[  103.863674] [<80436830>] sock_ioctl+0x2d8/0x4bc
[  103.868201] [<801adbb4>] do_vfs_ioctl+0xb8/0x7c0
[  103.872804] [<801ae30c>] ksys_ioctl+0x50/0xb4
[  103.877156] [<80014598>] syscall_common+0x34/0x58

Fixes: 04b8e65922f63 ("mt76: add mac80211 driver for MT7615 PCIe-based chipsets")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index f8a09692d3e4c..4fed3afad67cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -808,7 +808,8 @@ mt7615_mcu_ctrl_pm_state(struct mt7615_dev *dev, int band, int state)
 
 static int
 mt7615_mcu_bss_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta, bool enable)
+			 struct ieee80211_sta *sta, struct mt7615_phy *phy,
+			 bool enable)
 {
 	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
 	u32 type = vif->p2p ? NETWORK_P2P : NETWORK_INFRA;
@@ -821,6 +822,7 @@ mt7615_mcu_bss_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	switch (vif->type) {
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_MONITOR:
 		break;
 	case NL80211_IFTYPE_STATION:
 		/* TODO: enable BSS_INFO_UAPSD & BSS_INFO_PM */
@@ -840,14 +842,19 @@ mt7615_mcu_bss_basic_tlv(struct sk_buff *skb, struct ieee80211_vif *vif,
 	}
 
 	bss = (struct bss_info_basic *)tlv;
-	memcpy(bss->bssid, vif->bss_conf.bssid, ETH_ALEN);
-	bss->bcn_interval = cpu_to_le16(vif->bss_conf.beacon_int);
 	bss->network_type = cpu_to_le32(type);
-	bss->dtim_period = vif->bss_conf.dtim_period;
 	bss->bmc_tx_wlan_idx = wlan_idx;
 	bss->wmm_idx = mvif->mt76.wmm_idx;
 	bss->active = enable;
 
+	if (vif->type != NL80211_IFTYPE_MONITOR) {
+		memcpy(bss->bssid, vif->bss_conf.bssid, ETH_ALEN);
+		bss->bcn_interval = cpu_to_le16(vif->bss_conf.beacon_int);
+		bss->dtim_period = vif->bss_conf.dtim_period;
+	} else {
+		memcpy(bss->bssid, phy->mt76->macaddr, ETH_ALEN);
+	}
+
 	return 0;
 }
 
@@ -863,6 +870,7 @@ mt7615_mcu_bss_omac_tlv(struct sk_buff *skb, struct ieee80211_vif *vif)
 	tlv = mt76_connac_mcu_add_tlv(skb, BSS_INFO_OMAC, sizeof(*omac));
 
 	switch (vif->type) {
+	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_AP:
 		if (vif->p2p)
@@ -929,7 +937,7 @@ mt7615_mcu_add_bss(struct mt7615_phy *phy, struct ieee80211_vif *vif,
 	if (enable)
 		mt7615_mcu_bss_omac_tlv(skb, vif);
 
-	mt7615_mcu_bss_basic_tlv(skb, vif, sta, enable);
+	mt7615_mcu_bss_basic_tlv(skb, vif, sta, phy, enable);
 
 	if (enable && mvif->mt76.omac_idx >= EXT_BSSID_START &&
 	    mvif->mt76.omac_idx < REPEATER_BSSID_START)
-- 
2.33.0



