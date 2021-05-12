Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D1337C5B3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbhELPmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236386AbhELPhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA8C61993;
        Wed, 12 May 2021 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832773;
        bh=CGO2sFoVdylIdaV4vRLZrGCCDcNNIkPwS96faCCOph0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SN8JIeQyNsT79ls6FMGTYKsh1a9IxxXHmvn0+wuqjcyLCw7APsIEjAXgRe1t2+/mw
         JskrslORQu5uovu9DfjFdCDb7kovTpI8Stw45uCrBKupfnOqOFXqcsxHJZoauKE0z4
         9/XNLXjuDqiWHrteVEJ053h9zrGYA02st+1nWJ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/530] mt76: mt7663s: fix the possible device hang in high traffic
Date:   Wed, 12 May 2021 16:48:48 +0200
Message-Id: <20210512144833.505772490@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 2c269fee8555..d7d61a5b66a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -201,6 +201,8 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, enum mt76_txq_id qid)
 		struct mt76_queue_entry *e = &q->entry[q->first];
 		struct sk_buff *iter;
 
+		smp_rmb();
+
 		if (!test_bit(MT76_STATE_MCU_RUNNING, &dev->phy.state)) {
 			__skb_put_zero(e->skb, 4);
 			err = __mt7663s_xmit_queue(dev, e->skb->data,
diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 9a4d95a2a707..439ea4158260 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -215,6 +215,9 @@ mt76s_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 
 	q->entry[q->head].skb = tx_info.skb;
 	q->entry[q->head].buf_sz = len;
+
+	smp_wmb();
+
 	q->head = (q->head + 1) % q->ndesc;
 	q->queued++;
 
-- 
2.30.2



