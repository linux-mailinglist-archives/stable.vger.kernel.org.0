Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFB237C9DC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbhELQW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240461AbhELQSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F75613DA;
        Wed, 12 May 2021 15:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834249;
        bh=EqjC9HtodbINCnVzPNUd9DCzsFf7prLXFWtGLrfEhDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HD8eHdkZOGZyvsxqZlpf5AIK/vZKWTxsauSSisdh/ruFSzpJ+SLIGUvFl9ubUkPB
         byXNJhyx24i1WhbkTKt5O+d8x594Bf9Gm95W0uOb7ZExhj/fHZiSjApMXi0NLJQKyV
         Jpkgij9e6WrTd1UQOznbreC805nfE9QVmtRheCKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 468/601] mt76: reduce q->lock hold time
Date:   Wed, 12 May 2021 16:49:05 +0200
Message-Id: <20210512144843.256900301@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 2fbcdb4386dda0a911b5485b33468540716251f8 ]

Instead of holding it for the duration of an entire station schedule run,
which can block out competing tasks for a significant amount of time,
only hold it for scheduling one batch of packets for one station.
Improves responsiveness under load

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 25627e70bdad..d5953223d7cf 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -454,7 +454,6 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 	struct mt76_wcid *wcid;
 	int ret = 0;
 
-	spin_lock_bh(&q->lock);
 	while (1) {
 		if (test_bit(MT76_STATE_PM, &phy->state) ||
 		    test_bit(MT76_RESET, &phy->state)) {
@@ -464,14 +463,9 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
-			spin_unlock_bh(&q->lock);
 			dev->queue_ops->tx_cleanup(dev, q, false);
-			spin_lock_bh(&q->lock);
 		}
 
-		if (mt76_txq_stopped(q))
-			break;
-
 		txq = ieee80211_next_txq(phy->hw, qid);
 		if (!txq)
 			break;
@@ -481,6 +475,8 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		if (wcid && test_bit(MT_WCID_FLAG_PS, &wcid->flags))
 			continue;
 
+		spin_lock_bh(&q->lock);
+
 		if (mtxq->send_bar && mtxq->aggr) {
 			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 			struct ieee80211_sta *sta = txq->sta;
@@ -494,10 +490,13 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			spin_lock_bh(&q->lock);
 		}
 
-		ret += mt76_txq_send_burst(phy, q, mtxq);
+		if (!mt76_txq_stopped(q))
+			ret += mt76_txq_send_burst(phy, q, mtxq);
+
+		spin_unlock_bh(&q->lock);
+
 		ieee80211_return_txq(phy->hw, txq, false);
 	}
-	spin_unlock_bh(&q->lock);
 
 	return ret;
 }
-- 
2.30.2



