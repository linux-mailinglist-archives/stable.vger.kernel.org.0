Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF96F247610
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730248AbgHQPa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:30:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbgHQPay (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:30:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD3423B41;
        Mon, 17 Aug 2020 15:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678254;
        bh=FxuRQYNDNmFiRNu306TerMqt9Xc35aX8v98qTFSR68s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpFDB9a0oj60uqWgeP84Du+3Leg2tBntm8Zke5FKWz/Vz3+2t8GhAE7+PZfG0W/ZB
         IIBSk7RwD+eGd7yseorXOH5L3zyDIxwp6zYKQ/q/gK4yFLiopEhdopl+m4Ew07vOh0
         mzAWt/OXhzHtBlPv0XJWuLI3fbGs+w3z53ySW9MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 270/464] mt76: mt7915: potential array overflow in mt7915_mcu_tx_rate_report()
Date:   Mon, 17 Aug 2020 17:13:43 +0200
Message-Id: <20200817143846.713668196@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit eb744e5df86cf7e377d0acc4e686101b0fd9663a ]

Smatch complains that "wcidx" value comes from the network and thus
cannot be trusted.  In this case, it actually seems to come from the
firmware.  If your wireless firmware is malicious then probably no
amount of carefulness can protect you.

On the other hand, these days we still try to check the firmware as much
as possible.  Verifying that the index is within bounds will silence a
static checker warning.  And it's harmless and a good exercise in kernel
hardening.  So I suggest that we do add a bounds check.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index c8c12c740c1a0..8fb8255650a7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -505,15 +505,22 @@ static void
 mt7915_mcu_tx_rate_report(struct mt7915_dev *dev, struct sk_buff *skb)
 {
 	struct mt7915_mcu_ra_info *ra = (struct mt7915_mcu_ra_info *)skb->data;
-	u16 wcidx = le16_to_cpu(ra->wlan_idx);
-	struct mt76_wcid *wcid = rcu_dereference(dev->mt76.wcid[wcidx]);
-	struct mt7915_sta *msta = container_of(wcid, struct mt7915_sta, wcid);
-	struct mt7915_sta_stats *stats = &msta->stats;
-	struct mt76_phy *mphy = &dev->mphy;
 	struct rate_info rate = {}, prob_rate = {};
+	u16 probe = le16_to_cpu(ra->prob_up_rate);
 	u16 attempts = le16_to_cpu(ra->attempts);
 	u16 curr = le16_to_cpu(ra->curr_rate);
-	u16 probe = le16_to_cpu(ra->prob_up_rate);
+	u16 wcidx = le16_to_cpu(ra->wlan_idx);
+	struct mt76_phy *mphy = &dev->mphy;
+	struct mt7915_sta_stats *stats;
+	struct mt7915_sta *msta;
+	struct mt76_wcid *wcid;
+
+	if (wcidx >= MT76_N_WCIDS)
+		return;
+
+	wcid = rcu_dereference(dev->mt76.wcid[wcidx]);
+	msta = container_of(wcid, struct mt7915_sta, wcid);
+	stats = &msta->stats;
 
 	if (msta->wcid.ext_phy && dev->mt76.phy2)
 		mphy = dev->mt76.phy2;
-- 
2.25.1



