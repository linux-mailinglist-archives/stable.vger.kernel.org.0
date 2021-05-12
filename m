Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76B7337C9E3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhELQXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240555AbhELQSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC7E261C88;
        Wed, 12 May 2021 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834264;
        bh=T0FNLIQf9bBbHGt/Vjz6oz9d8EdUoM37fXZ8X1shiV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UrhrBb+KUHUv4iymtIay5+O/3n7b92aQ/FMVlIoUVC0KuZ/NmgP+D250MUNSRYkcb
         GOWSGW3q6KJm3hukxmzzunemXxs3LAN6HlgERNb13Xcfn9Dn4rhH2/gFOkepVYMMcZ
         Kifgvnda/VOdYG+4vpWLbU8ZYk4+EztYIaaTELYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 473/601] mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation
Date:   Wed, 12 May 2021 16:49:10 +0200
Message-Id: <20210512144843.426136315@linuxfoundation.org>
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
index 9fb506f2ace6..37fe65ced4fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -218,6 +218,7 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	int qid, err, nframes = 0, len = 0, pse_sz = 0, ple_sz = 0;
 	bool mcu = q == dev->q_mcu[MT_MCUQ_WM];
 	struct mt76_sdio *sdio = &dev->sdio;
+	u8 pad;
 
 	qid = mcu ? ARRAY_SIZE(sdio->xmit_buf) - 1 : q->qid;
 	while (q->first != q->head) {
@@ -234,7 +235,8 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, struct mt76_queue *q)
 			goto next;
 		}
 
-		if (len + e->skb->len + 4 > MT76S_XMIT_BUF_SZ)
+		pad = roundup(e->skb->len, 4) - e->skb->len;
+		if (len + e->skb->len + pad + 4 > MT76S_XMIT_BUF_SZ)
 			break;
 
 		if (mt7663s_tx_pick_quota(sdio, mcu, e->buf_sz, &pse_sz,
@@ -252,6 +254,11 @@ static int mt7663s_tx_run_queue(struct mt76_dev *dev, struct mt76_queue *q)
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



