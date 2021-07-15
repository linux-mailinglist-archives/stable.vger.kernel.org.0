Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 107F73CA890
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhGOTBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240617AbhGOTAz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2137561158;
        Thu, 15 Jul 2021 18:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375463;
        bh=sJtv/WdN+bUh2CGo+fSl+5fnkGlbnS7mWPAyvRD7Z1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgIqmy2PrzJJJ9HARHyKJvHs5dW13niO+YEZac1DiPBzlQ7hAoIRGEEpjW+9FelOC
         C4Qg9T4CAy8Q01A9/NxtV6bDBAn1t6nvKQpVefvu1k1CKBsU4m2yTbd8iDK5M0JQPI
         j875Hh00Tf0/GL4QFpOHz25O6LwJ3YbJiQqMeXXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 097/242] mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails
Date:   Thu, 15 Jul 2021 20:37:39 +0200
Message-Id: <20210715182610.162715896@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 94e4f5794627a80ce036c35b32a9900daeb31be3 ]

Fixes AQL issues on full queues, especially with 802.3 encap offload

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 426787f4b2ae..ee0acde53a60 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -349,6 +349,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		      struct sk_buff *skb, struct mt76_wcid *wcid,
 		      struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -360,11 +363,9 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	u8 *txwi;
 
 	t = mt76_get_txwi(dev);
-	if (!t) {
-		hw = mt76_tx_status_get_hw(dev, skb);
-		ieee80211_free_txskb(hw, skb);
-		return -ENOMEM;
-	}
+	if (!t)
+		goto free_skb;
+
 	txwi = mt76_get_txwi_ptr(dev, t);
 
 	skb->prev = skb->next = NULL;
@@ -427,8 +428,13 @@ free:
 	}
 #endif
 
-	dev_kfree_skb(tx_info.skb);
 	mt76_put_txwi(dev, t);
+
+free_skb:
+	status.skb = tx_info.skb;
+	hw = mt76_tx_status_get_hw(dev, tx_info.skb);
+	ieee80211_tx_status_ext(hw, &status);
+
 	return ret;
 }
 
-- 
2.30.2



