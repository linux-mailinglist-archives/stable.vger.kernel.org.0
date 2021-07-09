Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276043C24E9
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232881AbhGINZl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:25:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232976AbhGINZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB4126128A;
        Fri,  9 Jul 2021 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836967;
        bh=ON7AGJq+HtPMwLk5R49g8pBtr+Mr7GjiYIeDw/afL78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2t+CwNLIZJ7P/5MH+7oMstpJpekWXF7QJul2SPTsj2ZCX8kKB/FDlWTFw0MUrTY4A
         /YOhZTiN1ElNYYWbhzS73DVvkENTAP3RgnUJdV/u1ujBzF+0/1ciAvnin8fFuTNyYy
         Nk41/8KUv4ctkah1O77PhU6Dmpen7tTZdmgOUXMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Deren Wu <Deren.Wu@mediatek.com>
Subject: [PATCH 5.12 08/11] mt76: dma: export mt76_dma_rx_cleanup routine
Date:   Fri,  9 Jul 2021 15:21:45 +0200
Message-Id: <20210709131600.714623878@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131549.679160341@linuxfoundation.org>
References: <20210709131549.679160341@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit c001df978e4cb88975147ddd2c829c9e12a55076 upstream.

Export mt76_dma_rx_cleanup routine in mt76_queue_ops data structure.
This is a preliminary patch to introduce mt7921 chip reset support.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Cc: Deren Wu <Deren.Wu@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/dma.c  |    1 +
 drivers/net/wireless/mediatek/mt76/mt76.h |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -653,6 +653,7 @@ static const struct mt76_queue_ops mt76_
 	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
+	.rx_cleanup = mt76_dma_rx_cleanup,
 	.rx_reset = mt76_dma_rx_reset,
 	.kick = mt76_dma_kick_queue,
 };
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -190,6 +190,8 @@ struct mt76_queue_ops {
 	void (*tx_cleanup)(struct mt76_dev *dev, struct mt76_queue *q,
 			   bool flush);
 
+	void (*rx_cleanup)(struct mt76_dev *dev, struct mt76_queue *q);
+
 	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
 
 	void (*reset_q)(struct mt76_dev *dev, struct mt76_queue *q);
@@ -786,7 +788,8 @@ static inline u16 mt76_rev(struct mt76_d
 #define mt76_tx_queue_skb_raw(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb_raw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_tx_queue_skb(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
-#define mt76_queue_tx_cleanup(dev, ...)        (dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_rx_cleanup(dev, ...)	(dev)->mt76.queue_ops->rx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_reset(dev, ...)	(dev)->mt76.queue_ops->reset_q(&((dev)->mt76), __VA_ARGS__)
 


