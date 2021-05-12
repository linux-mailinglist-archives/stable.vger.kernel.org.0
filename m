Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D362B37CE56
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240068AbhELRFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237844AbhELQnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:43:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2129E61D55;
        Wed, 12 May 2021 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835992;
        bh=hwQp0zQZBFhMyjS5FQ0xU66fcd85faf4QsaQ5dKCQ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHbuBKwsYnV0jGpTBE1y1GbCA/loBz5tTLFjX3einX+HZ/0N7XSn7nwGtoV9HrP/K
         ZMZ/19RLE1INi/CimASe752H5XzpQyOh0o/ZHd7Rk2cBqIO0TO6qOcJ8cDx243z0Nd
         clSFvi00zTOksJ6UuwhYjrgmarV1prFUAJRa/lUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 531/677] mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list
Date:   Wed, 12 May 2021 16:49:37 +0200
Message-Id: <20210512144855.020066806@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 57b8b57516c5108b0078051a31c68dc9dfcbf68f ]

Since mt76_txq_send_burst routine can report a negative error code,
check the returned value before incrementing the number of transmitted
frames in mt76_txq_schedule_list routine.
Return -EBUSY directly if the device is in reset or in power management.

Fixes: 90fdc1717b186 ("mt76: use mac80211 txq scheduling")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b8fe8adc43a3..451ed60c6296 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -461,11 +461,11 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 	int ret = 0;
 
 	while (1) {
+		int n_frames = 0;
+
 		if (test_bit(MT76_STATE_PM, &phy->state) ||
-		    test_bit(MT76_RESET, &phy->state)) {
-			ret = -EBUSY;
-			break;
-		}
+		    test_bit(MT76_RESET, &phy->state))
+			return -EBUSY;
 
 		if (dev->queue_ops->tx_cleanup &&
 		    q->queued + 2 * MT_TXQ_FREE_THR >= q->ndesc) {
@@ -497,11 +497,16 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		}
 
 		if (!mt76_txq_stopped(q))
-			ret += mt76_txq_send_burst(phy, q, mtxq);
+			n_frames = mt76_txq_send_burst(phy, q, mtxq);
 
 		spin_unlock_bh(&q->lock);
 
 		ieee80211_return_txq(phy->hw, txq, false);
+
+		if (unlikely(n_frames < 0))
+			return n_frames;
+
+		ret += n_frames;
 	}
 
 	return ret;
-- 
2.30.2



