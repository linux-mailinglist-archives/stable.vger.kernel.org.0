Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC99530C010
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhBBNsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:48:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhBBNq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:46:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5971364F87;
        Tue,  2 Feb 2021 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273290;
        bh=V3XM6lEt8E5jdw7TOOgP+we7qy/6CB6wYWYu8djUeQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lm29kpXhD22pBmIloW5fyU4OnpSpqLFhkpIFkFZuUixoGExNnhecN8McYjQPCbT1b
         9xLOt7yHHFu1NmicJ77WVqPJvaCiIwLRXEMv948biFqBvsUpP/RjWAk4Z8BXbAtFWN
         FzPiDLRms9P+6817EaqhCRCt4vQ15jr/luz2Oyy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 052/142] mt76: mt7663s: fix rx buffer refcounting
Date:   Tue,  2 Feb 2021 14:36:55 +0100
Message-Id: <20210202132959.873461128@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit 952de419b6179ad1424f512d52ec7122662fdf63 upstream.

Similar to mt7601u driver, fix erroneous rx page refcounting

Fixes: a66cbdd6573d ("mt76: mt7615: introduce mt7663s support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/dca19c9d445156201bc41f7cbb6e894bbc9a678c.1610644945.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/sdio_txrx.c
@@ -85,7 +85,7 @@ static int mt7663s_rx_run_queue(struct m
 {
 	struct mt76_queue *q = &dev->q_rx[qid];
 	struct mt76_sdio *sdio = &dev->sdio;
-	int len = 0, err, i, order;
+	int len = 0, err, i;
 	struct page *page;
 	u8 *buf;
 
@@ -98,8 +98,7 @@ static int mt7663s_rx_run_queue(struct m
 	if (len > sdio->func->cur_blksize)
 		len = roundup(len, sdio->func->cur_blksize);
 
-	order = get_order(len);
-	page = __dev_alloc_pages(GFP_KERNEL, order);
+	page = __dev_alloc_pages(GFP_KERNEL, get_order(len));
 	if (!page)
 		return -ENOMEM;
 
@@ -111,7 +110,7 @@ static int mt7663s_rx_run_queue(struct m
 
 	if (err < 0) {
 		dev_err(dev->dev, "sdio read data failed:%d\n", err);
-		__free_pages(page, order);
+		put_page(page);
 		return err;
 	}
 
@@ -128,7 +127,7 @@ static int mt7663s_rx_run_queue(struct m
 		if (q->queued + i + 1 == q->ndesc)
 			break;
 	}
-	__free_pages(page, order);
+	put_page(page);
 
 	spin_lock_bh(&q->lock);
 	q->head = (q->head + i) % q->ndesc;


