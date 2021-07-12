Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D5F3C53F3
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348121AbhGLH4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351138AbhGLHv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:51:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5ED60FF1;
        Mon, 12 Jul 2021 07:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076121;
        bh=JE9SGRsuBF36v0ejZnZhPbrVxYG4p1R73NJXYsa1LOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDoYHknJ1YTbs38uLe8flMuKJqO7Y0t3GfUoZYgKhTGuXa9eiJ4MzlxK8dq44/PRT
         gV2s1G/Y7R38Zflq+HfGAPxHiaEZBl/ECn4QX8Znx4bN5sl8g2aIVKXojlDaEe412h
         PWIaPLyE6WP12lhiFjcBIHnGkOFFKLXBJPPuf56U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 506/800] mt76: mt7915: fix rx fcs error count in testmode
Date:   Mon, 12 Jul 2021 08:08:49 +0200
Message-Id: <20210712061021.025163263@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 89043529c8b833d87391f1844e9d1cc1643393eb ]

FCS error packets are filtered by default and won't be reported to
driver, so that RX fcs error and PER in testmode always show zero.
Fix this issue by reading fcs error count from hw counter.

We did't fix this issue by disabling fcs error rx filter since it may
let HW suffer some SER errors.

Fixes: 5d8a83f09941 ("mt76: mt7915: implement testmode rx support")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7915/testmode.c  | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index f9d81e36ef09..b220b334906b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -464,10 +464,17 @@ mt7915_tm_set_tx_frames(struct mt7915_phy *phy, bool en)
 static void
 mt7915_tm_set_rx_frames(struct mt7915_phy *phy, bool en)
 {
-	if (en)
+	mt7915_tm_set_trx(phy, TM_MAC_RX_RXV, false);
+
+	if (en) {
+		struct mt7915_dev *dev = phy->dev;
+
 		mt7915_tm_update_channel(phy);
 
-	mt7915_tm_set_trx(phy, TM_MAC_RX_RXV, en);
+		/* read-clear */
+		mt76_rr(dev, MT_MIB_SDR3(phy != &dev->phy));
+		mt7915_tm_set_trx(phy, TM_MAC_RX_RXV, en);
+	}
 }
 
 static int
@@ -690,7 +697,11 @@ static int
 mt7915_tm_dump_stats(struct mt76_phy *mphy, struct sk_buff *msg)
 {
 	struct mt7915_phy *phy = mphy->priv;
+	struct mt7915_dev *dev = phy->dev;
+	bool ext_phy = phy != &dev->phy;
+	enum mt76_rxq_id q;
 	void *rx, *rssi;
+	u16 fcs_err;
 	int i;
 
 	rx = nla_nest_start(msg, MT76_TM_STATS_ATTR_LAST_RX);
@@ -735,6 +746,12 @@ mt7915_tm_dump_stats(struct mt76_phy *mphy, struct sk_buff *msg)
 
 	nla_nest_end(msg, rx);
 
+	fcs_err = mt76_get_field(dev, MT_MIB_SDR3(ext_phy),
+				 MT_MIB_SDR3_FCS_ERR_MASK);
+	q = ext_phy ? MT_RXQ_EXT : MT_RXQ_MAIN;
+	mphy->test.rx_stats.packets[q] += fcs_err;
+	mphy->test.rx_stats.fcs_error[q] += fcs_err;
+
 	return 0;
 }
 
-- 
2.30.2



