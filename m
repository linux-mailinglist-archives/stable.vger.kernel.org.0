Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50ECA90AD
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390222AbfIDSLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389078AbfIDSLF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:11:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB9B23401;
        Wed,  4 Sep 2019 18:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620665;
        bh=GCIkHpnTuD4C09Cw4jJmBv6F6eHMlnrCVJ4JE7VG5qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJkxSkpTKkzJjomULZb8DcPXiNex+IUC1HUhZi358n4M2x6DndWfEzrOhVEsfh43G
         5SNV4qWAkRiVkQ0dJalPS3bwf1C2K/xhI2BDzk1O6xnDQAt2wVPryjX1qpOxbdvT1M
         xEolTR3UIDzN4ar6rcYry+Wx3zPEeqkQdSV8+pdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 048/143] mt76: usb: fix rx A-MSDU support
Date:   Wed,  4 Sep 2019 19:53:11 +0200
Message-Id: <20190904175315.950630952@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2a92b08b18553c101115423bd34963b1a59a45a3 ]

Commit f8f527b16db5 ("mt76: usb: use EP max packet aligned buffer sizes
for rx") breaks A-MSDU support. When A-MSDU is enable the device can
receive frames up to q->buf_size but they will be discarded in
mt76u_process_rx_entry since there is no enough room for
skb_shared_info. Fix the issue reallocating the skb and copying in the
linear area the first 128B of the received frames and in the frag_list
the remaining part

Fixes: f8f527b16db5 ("mt76: usb: use EP max packet aligned buffer sizes for rx")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c  | 46 ++++++++++++++++++-----
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 8ecbf81a906f5..889b76deb7037 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -30,6 +30,7 @@
 #define MT_TX_RING_SIZE     256
 #define MT_MCU_RING_SIZE    32
 #define MT_RX_BUF_SIZE      2048
+#define MT_SKB_HEAD_LEN     128
 
 struct mt76_dev;
 struct mt76_wcid;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index bbaa1365bbda2..dd90427b2d672 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -429,6 +429,42 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 	return dma_len;
 }
 
+static struct sk_buff *
+mt76u_build_rx_skb(void *data, int len, int buf_size)
+{
+	struct sk_buff *skb;
+
+	if (SKB_WITH_OVERHEAD(buf_size) < MT_DMA_HDR_LEN + len) {
+		struct page *page;
+
+		/* slow path, not enough space for data and
+		 * skb_shared_info
+		 */
+		skb = alloc_skb(MT_SKB_HEAD_LEN, GFP_ATOMIC);
+		if (!skb)
+			return NULL;
+
+		skb_put_data(skb, data + MT_DMA_HDR_LEN, MT_SKB_HEAD_LEN);
+		data += (MT_DMA_HDR_LEN + MT_SKB_HEAD_LEN);
+		page = virt_to_head_page(data);
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				page, data - page_address(page),
+				len - MT_SKB_HEAD_LEN, buf_size);
+
+		return skb;
+	}
+
+	/* fast path */
+	skb = build_skb(data, buf_size);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+	__skb_put(skb, len);
+
+	return skb;
+}
+
 static int
 mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 {
@@ -446,19 +482,11 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 		return 0;
 
 	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
-	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size)) {
-		dev_err_ratelimited(dev->dev, "rx data too big %d\n", data_len);
-		return 0;
-	}
-
-	skb = build_skb(data, q->buf_size);
+	skb = mt76u_build_rx_skb(data, data_len, q->buf_size);
 	if (!skb)
 		return 0;
 
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-	__skb_put(skb, data_len);
 	len -= data_len;
-
 	while (len > 0 && nsgs < urb->num_sgs) {
 		data_len = min_t(int, len, urb->sg[nsgs].length);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
-- 
2.20.1



