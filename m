Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9399E37C5B2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhELPmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236383AbhELPhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A53086198D;
        Wed, 12 May 2021 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832771;
        bh=Iuj9liknWKOtP4UbPNW9qRgos7GzblhTtIiJ3GyAzGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLY2Gt2AZcDJ63989qsHNdMAJl1LxUupaGpDm1En4JINOehZpxfn89tVyozePC3io
         XGchKlVVBh9vu/29z3BtbgjOrQHta0/oNYOu5IzYn68B/BUJ8aPG4R0k8xK4Y/R131
         SjUHlRZyZBrH+/S4U52nsZ1I+wTIZPE+wA3L8+CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 417/530] mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation
Date:   Wed, 12 May 2021 16:48:47 +0200
Message-Id: <20210512144833.475146182@linuxfoundation.org>
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

[ Upstream commit 455ae5aabcc72fed7e5c803d59d122415500dc08 ]

Each packet should be padded with the additional zero to become 4-bytes
alignment in sdio tx aggregation.

Fixes: 1522ff731f84 ("mt76: mt7663s: introduce sdio tx aggregation")
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
index 595519c58255..2c269fee8555 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -195,6 +195,7 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, enum mt76_txq_id qid)
 	int err, nframes = 0, len = 0, pse_sz = 0, ple_sz = 0;
 	struct mt76_queue *q = dev->q_tx[qid];
 	struct mt76_sdio *sdio = &dev->sdio;
+	u8 pad;
 
 	while (q->first != q->head) {
 		struct mt76_queue_entry *e = &q->entry[q->first];
@@ -210,7 +211,8 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, enum mt76_txq_id qid)
 			goto next;
 		}
 
-		if (len + e->skb->len + 4 > MT76S_XMIT_BUF_SZ)
+		pad = roundup(e->skb->len, 4) - e->skb->len;
+		if (len + e->skb->len + pad + 4 > MT76S_XMIT_BUF_SZ)
 			break;
 
 		if (mt7663s_tx_pick_quota(sdio, qid, e->buf_sz, &pse_sz,
@@ -228,6 +230,11 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, enum mt76_txq_id qid)
 			len += iter->len;
 			nframes++;
 		}
+
+		if (unlikely(pad)) {
+			memset(sdio->xmit_buf[qid] + len, 0, pad);
+			len += pad;
+		}
 next:
 		q->first = (q->first + 1) % q->ndesc;
 		e->done = true;
-- 
2.30.2



