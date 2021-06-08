Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017B3A0298
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhFHTHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233986AbhFHTDI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6403261450;
        Tue,  8 Jun 2021 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177917;
        bh=Vyr1d0rJzIbpJZ3II4PEuEoR740dGxvUs9XcOJQaOJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh4NNnyxrIw85Uy+xka3gO9LBVaLqVSutYygQ/ghvPAweoiFdDs1hiqwlkmgFIjpJ
         8N+JJzE1bErPlvHv3nH8ThrM8Z3jlxEA79tFhS25UFnncSI1C9Er20IIW2myLN4YNI
         JRWDyUvm3kQQWOiix7G4HxLXyiRcrBj5GBy3M8Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 002/161] mt76: mt7921: fix possible AOOB issue in mt7921_mcu_tx_rate_report
Date:   Tue,  8 Jun 2021 20:25:32 +0200
Message-Id: <20210608175945.557274871@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d874e6c06952382897d35bf4094193cd44ae91bd ]

Fix possible array out of bound access in mt7921_mcu_tx_rate_report.
Remove unnecessary varibable in mt7921_mcu_tx_rate_report

Fixes: 1c099ab44727c ("mt76: mt7921: add MCU support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/91a1e8f6b6a3e6a929de560ed68132f6eb421720.1619187875.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 9a140e4734b5..be88c9f5637a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -391,20 +391,22 @@ static void
 mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
 			  u16 wlan_idx)
 {
-	struct mt7921_mcu_wlan_info_event *wtbl_info =
-		(struct mt7921_mcu_wlan_info_event *)(skb->data);
-	struct rate_info rate = {};
-	u8 curr_idx = wtbl_info->rate_info.rate_idx;
-	u16 curr = le16_to_cpu(wtbl_info->rate_info.rate[curr_idx]);
-	struct mt7921_mcu_peer_cap peer = wtbl_info->peer_cap;
+	struct mt7921_mcu_wlan_info_event *wtbl_info;
 	struct mt76_phy *mphy = &dev->mphy;
 	struct mt7921_sta_stats *stats;
+	struct rate_info rate = {};
 	struct mt7921_sta *msta;
 	struct mt76_wcid *wcid;
+	u8 idx;
 
 	if (wlan_idx >= MT76_N_WCIDS)
 		return;
 
+	wtbl_info = (struct mt7921_mcu_wlan_info_event *)skb->data;
+	idx = wtbl_info->rate_info.rate_idx;
+	if (idx >= ARRAY_SIZE(wtbl_info->rate_info.rate))
+		return;
+
 	rcu_read_lock();
 
 	wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
@@ -415,7 +417,8 @@ mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
 	stats = &msta->stats;
 
 	/* current rate */
-	mt7921_mcu_tx_rate_parse(mphy, &peer, &rate, curr);
+	mt7921_mcu_tx_rate_parse(mphy, &wtbl_info->peer_cap, &rate,
+				 le16_to_cpu(wtbl_info->rate_info.rate[idx]));
 	stats->tx_rate = rate;
 out:
 	rcu_read_unlock();
-- 
2.30.2



