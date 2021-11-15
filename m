Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539F451130
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243673AbhKOTCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:02:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243491AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 650FF63496;
        Mon, 15 Nov 2021 18:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999993;
        bh=GIS4dWSat5ix/XbA6CG/bbdKbloFOS5TzJLSV9zhxJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaBIUHNCQss9Y6IJLFZOxoOMxzHydiEbzxiDbfWHwXE65+H/Q/UUts92HNI/OATNp
         cs8HFT3edHBCtIRQArlDHrR5OzuK2tgENW5bmvVvdfzRHWWE7q7c+b9ndCtMPanNd2
         T84KMO1F0cUvyrLpsg7ZrEFI6sIIMjMmU+g49Rxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 466/849] mt76: mt7921: fix kernel warning from cfg80211_calculate_bitrate
Date:   Mon, 15 Nov 2021 17:59:09 +0100
Message-Id: <20211115165436.046516128@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 8e695328a1006b7bab2d972e7d0111fa6e6faf51 ]

Fix the kernel warning from cfg80211_calculate_bitrate
due to the legacy rate is not parsed well in the current driver.

Also, zeros struct rate_info before we fill it out to avoid the old value
is kept such as rate->legacy.

[  790.921560] WARNING: CPU: 7 PID: 970 at net/wireless/util.c:1298 cfg80211_calculate_bitrate+0x354/0x35c [cfg80211]
[  790.987738] Hardware name: MediaTek Asurada rev1 board (DT)
[  790.993298] pstate: a0400009 (NzCv daif +PAN -UAO)
[  790.998104] pc : cfg80211_calculate_bitrate+0x354/0x35c [cfg80211]
[  791.004295] lr : cfg80211_calculate_bitrate+0x180/0x35c [cfg80211]
[  791.010462] sp : ffffffc0129c3880
[  791.013765] x29: ffffffc0129c3880 x28: ffffffd38305bea8
[  791.019065] x27: ffffffc0129c3970 x26: 0000000000000013
[  791.024364] x25: 00000000000003ca x24: 000000000000002f
[  791.029664] x23: 00000000000000d0 x22: ffffff8d108bc000
[  791.034964] x21: ffffff8d108bc0d0 x20: ffffffc0129c39a8
[  791.040264] x19: ffffffc0129c39a8 x18: 00000000ffff0a10
[  791.045563] x17: 0000000000000050 x16: 00000000000000ec
[  791.050910] x15: ffffffd3f9ebed9c x14: 0000000000000006
[  791.056211] x13: 00000000000b2eea x12: 0000000000000000
[  791.061511] x11: 00000000ffffffff x10: 0000000000000000
[  791.066811] x9 : 0000000000000000 x8 : 0000000000000000
[  791.072110] x7 : 0000000000000000 x6 : ffffffd3fafa5a7b
[  791.077409] x5 : 0000000000000000 x4 : 0000000000000000
[  791.082708] x3 : 0000000000000000 x2 : 0000000000000000
[  791.088008] x1 : ffffff8d3f79c918 x0 : 0000000000000000
[  791.093308] Call trace:
[  791.095770]  cfg80211_calculate_bitrate+0x354/0x35c [cfg80211]
[  791.101615]  nl80211_put_sta_rate+0x6c/0x2c0 [cfg80211]
[  791.106853]  nl80211_send_station+0x980/0xaa4 [cfg80211]
[  791.112178]  nl80211_get_station+0xb4/0x134 [cfg80211]
[  791.117308]  genl_rcv_msg+0x3a0/0x440
[  791.120960]  netlink_rcv_skb+0xcc/0x118
[  791.124785]  genl_rcv+0x34/0x48
[  791.127916]  netlink_unicast+0x144/0x1dc

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 8ced55501d373..3cb53c642d242 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -320,11 +320,13 @@ mt7921_mcu_tx_rate_parse(struct mt76_phy *mphy,
 			 struct rate_info *rate, u16 r)
 {
 	struct ieee80211_supported_band *sband;
-	u16 flags = 0;
+	u16 flags = 0, rate_idx;
 	u8 txmode = FIELD_GET(MT_WTBL_RATE_TX_MODE, r);
 	u8 gi = 0;
 	u8 bw = 0;
+	bool cck = false;
 
+	memset(rate, 0, sizeof(*rate));
 	rate->mcs = FIELD_GET(MT_WTBL_RATE_MCS, r);
 	rate->nss = FIELD_GET(MT_WTBL_RATE_NSS, r) + 1;
 
@@ -349,13 +351,18 @@ mt7921_mcu_tx_rate_parse(struct mt76_phy *mphy,
 
 	switch (txmode) {
 	case MT_PHY_TYPE_CCK:
+		cck = true;
+		fallthrough;
 	case MT_PHY_TYPE_OFDM:
 		if (mphy->chandef.chan->band == NL80211_BAND_5GHZ)
 			sband = &mphy->sband_5g.sband;
 		else
 			sband = &mphy->sband_2g.sband;
 
-		rate->legacy = sband->bitrates[rate->mcs].bitrate;
+		rate_idx = FIELD_GET(MT_TX_RATE_IDX, r);
+		rate_idx = mt76_get_rate(mphy->dev, sband, rate_idx,
+					 cck);
+		rate->legacy = sband->bitrates[rate_idx].bitrate;
 		break;
 	case MT_PHY_TYPE_HT:
 	case MT_PHY_TYPE_HT_GF:
-- 
2.33.0



