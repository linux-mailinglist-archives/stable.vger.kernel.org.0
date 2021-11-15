Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E524510E4
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243068AbhKOS4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:56:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243230AbhKOSxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:53:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7468632A6;
        Mon, 15 Nov 2021 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999859;
        bh=3bGhPLCAAexDg0qLJqH+ZCkrkeJs893UNudMTBsm7Bc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQVL/lCKlKiXOnIssmQ3vaVig4Rt3sOpWb8eEZsd3lEE/zsuAO6MfkmNlnt8YC+iO
         uVmFrgN6PIEUWmck+9wLySQDDzuXa7baDQ8xfchAf2ETZkFNZ6/d5CxJMT1qZ0XK5S
         GnzeQrv4/FeXML+XPit+1kUU+79xy5G25Y8mNStc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 449/849] mt76: mt7921: fix endianness in mt7921_mcu_tx_done_event
Date:   Mon, 15 Nov 2021 17:58:52 +0100
Message-Id: <20211115165435.477031849@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit df040215c077de0c13aab12c222bd0360a0d3988 ]

Fix endianness in mt7921_mcu_tx_done_event event reported by the
firmware.

Fixes: 3cce2b98e0241 ("mt76: mt7921: introduce mac tx done handling")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h | 10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 9fbaacc67cfad..68840e55ede7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -532,7 +532,8 @@ mt7921_mcu_tx_done_event(struct mt7921_dev *dev, struct sk_buff *skb)
 		peer.g8 = !!(sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_80);
 		peer.g16 = !!(sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_160);
 		mt7921_mcu_tx_rate_parse(mphy->mt76, &peer,
-					 &msta->stats.tx_rate, event->tx_rate);
+					 &msta->stats.tx_rate,
+					 le16_to_cpu(event->tx_rate));
 
 		spin_lock_bh(&dev->sta_poll_lock);
 		break;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index de3c091f67368..42e7271848956 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -296,11 +296,11 @@ struct mt7921_txpwr_event {
 struct mt7921_mcu_tx_done_event {
 	u8 pid;
 	u8 status;
-	u16 seq;
+	__le16 seq;
 
 	u8 wlan_idx;
 	u8 tx_cnt;
-	u16 tx_rate;
+	__le16 tx_rate;
 
 	u8 flag;
 	u8 tid;
@@ -312,9 +312,9 @@ struct mt7921_mcu_tx_done_event {
 	u8 reason;
 	u8 rsv0[1];
 
-	u32 delay;
-	u32 timestamp;
-	u32 applied_flag;
+	__le32 delay;
+	__le32 timestamp;
+	__le32 applied_flag;
 
 	u8 txs[28];
 
-- 
2.33.0



