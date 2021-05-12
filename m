Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5B37CE61
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbhELRFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244295AbhELQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C15161D34;
        Wed, 12 May 2021 16:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835920;
        bh=puRKLj/Es+vBRGUJWVG62c51zUbliuaQk3+L9/9WopU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUdQAv3YRZgi84g+ZXJCtEFApzq1thbIpk5+oSfOrxY6tFV3xqLJiVFhfSRFENdjY
         jYuZHmjhCcKs7mhWIrAzj8sOfdmoJn1IY5tRoxv/W05AHWM067tzXnz66VcldD54iR
         D9a6XZs5J9xDsdeebp4tbLW2ZxRwF0IFCnJUd/Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 538/677] mt76: mt7663s: fix the possible device hang in high traffic
Date:   Wed, 12 May 2021 16:49:44 +0200
Message-Id: <20210512144855.244879288@linuxfoundation.org>
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

From: Sean Wang <sean.wang@mediatek.com>

[ Upstream commit 45247a85614b49b07b9dc59a4e6783b17e766ff2 ]

Use the additional memory barrier to ensure the skb list up-to-date
between the skb producer and consumer to avoid the invalid skb content
written into sdio controller and then cause device hang due to mcu assert
caught by WR_TIMEOUT_INT.

Fixes: 1522ff731f84 ("mt76: mt7663s: introduce sdio tx aggregation")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c | 2 ++
 drivers/net/wireless/mediatek/mt76/sdio.c             | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
index 37fe65ced4fd..4393dd21ebbb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -225,6 +225,8 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, struct mt76_queue *q)
 		struct mt76_queue_entry *e = &q->entry[q->first];
 		struct sk_buff *iter;
 
+		smp_rmb();
+
 		if (!test_bit(MT76_STATE_MCU_RUNNING, &dev->phy.state)) {
 			__skb_put_zero(e->skb, 4);
 			err = __mt7663s_xmit_queue(dev, e->skb->data,
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 0b6facb17ff7..a18d2896ee1f 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -256,6 +256,9 @@ mt76s_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 
 	q->entry[q->head].skb = tx_info.skb;
 	q->entry[q->head].buf_sz = len;
+
+	smp_wmb();
+
 	q->head = (q->head + 1) % q->ndesc;
 	q->queued++;
 
-- 
2.30.2



