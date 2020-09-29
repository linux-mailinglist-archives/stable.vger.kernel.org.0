Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC9927C975
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgI2Lhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730110AbgI2Lh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FC623B27;
        Tue, 29 Sep 2020 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379237;
        bh=sqlLud8CEaAaBFbB3Brfhi39Fv7Pc8MrM/ur4dg+zwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qveqvEdW2V5Yz/6Y4rJm9Ty1a/+0VyTlu+gpIjS01o3gORLI146Ihj+zUrvt7rbZY
         huJMAU+4LbpwZHSXY9q6eEAfCgONJXHwuTE4JRTl15wmVP9WVBXdrccw2huZuaOCeL
         ftEVuzuoQHnsSNENW/DkC9dPYR1gcagXE9LrwaCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/388] mt76: add missing locking around ampdu action
Date:   Tue, 29 Sep 2020 12:56:27 +0200
Message-Id: <20200929110013.207210372@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 1a817fa73c3b27a593aadf0029de24db1bbc1a3e ]

This is needed primarily to avoid races in dealing with rx aggregation
related data structures

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/main.c  | 2 ++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c  | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 25d5b1608bc91..0a5695c3d9241 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -561,6 +561,7 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, ssn,
@@ -590,6 +591,7 @@ mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 87c748715b5d7..38183aef0eb92 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -455,6 +455,7 @@ mt7615_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, ssn,
@@ -485,6 +486,7 @@ mt7615_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index aec73a0295e86..de0d6f21c621c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -371,6 +371,7 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
 
+	mutex_lock(&dev->mt76.mutex);
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
 		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid,
@@ -400,6 +401,7 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	}
+	mutex_unlock(&dev->mt76.mutex);
 
 	return 0;
 }
-- 
2.25.1



