Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92AD137C9DF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhELQXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240457AbhELQSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E332361C86;
        Wed, 12 May 2021 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834251;
        bh=s8xjR2WjAo2FaLJiFgMShCndqusZbZ0AFkLX09G/zhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIztqnd++LoBbBsZaN2/iLsVGBHs9fPd3sAqPXXgpdaVsCBzynKhp3iSguHzXIWdm
         zHtBQHi/4O0z0Iec8KtjAVjAbCr0W//cnsinSIj71bK17nUVyts8KNCPdZDs5MYMN6
         y2HEL69mZoeHpMa/jk0l5gWM69Z+RxBfuH/AdulQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 469/601] mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list
Date:   Wed, 12 May 2021 16:49:06 +0200
Message-Id: <20210512144843.289513811@linuxfoundation.org>
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
index d5953223d7cf..c678f3e01311 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -455,11 +455,11 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
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
@@ -491,11 +491,16 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
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



