Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D793863428
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 12:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfGIKWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 06:22:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41625 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfGIKWF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 06:22:05 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so9065753pff.8
        for <stable@vger.kernel.org>; Tue, 09 Jul 2019 03:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHn7sh6ZYwvh5+D/h2PrSTgVx9fde1Yu4h3Dr05pCsY=;
        b=S6x8jcHvKJGfpw+Yld/kbXFq1TShqWb7H9Z+ZjTW7WXiQJY0xIFNau7xT+ZDdNqeNe
         07H063fJx/xr2fqRFg+7gKq6ZfH9r1EzHTVrgJYwTZnQ79yv+mWP9P6vK2Dso8w9j+Fv
         nP3mNJa/v/zaokDhy4yTfby3sgmKvu0R4hb0tMTPB8iG678pMO1ypho2UPvDZM4aPtac
         YXZntBd9k5dQwwmnjHbpIFGowGjkhYiS8pzutGE9v6WXFeBwteBRmXrOdJYRQNEEkUl4
         r73M7fho8QHRPAUrbSuG0UVKeYRPvS6adMCzBnDyqbCDRNdBfNZDeJK2j3LhcxaJmM+m
         3Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHn7sh6ZYwvh5+D/h2PrSTgVx9fde1Yu4h3Dr05pCsY=;
        b=QPrZS89CooI0ykyj2Pts6eeSmW8rCEjmGfSq4sHYfnrXWjVyEr3aSoqnGzAOmuB6vD
         6O2+XZLV00V3N12AjMYZvc1xt1M5mZHVgAZAgAIxHpAPXpjPIH9I68O0hPApsMxHL3v6
         A6fmqEaCWKJZt4plmpky8BuSi5mquNuwqtz1ZfzRHN2JZHO0stSyhRdtm/nwJYjq+vHD
         +qjaKjVgkcI0TVAg9/v7CXaiVxGajYldogYRq/CesI02Dc8sAgq903cK5kzllrnjIMCw
         cgH3Fi8cfANL7tJT1wctreAVsQ3rDPU7obO3d5WW0iYEErTX+FZLVkIXVu/YDUcL1UaW
         6vzg==
X-Gm-Message-State: APjAAAW+ubUHH3AUQi1PzQQqw7Y+gWW90ADrJHoUO9ISD91ZejyBYu/P
        0A4t9jmu4Y2GXh+eWKYYHxrXAw==
X-Google-Smtp-Source: APXvYqz2/A/8B3slXasDnqD46Tev0tlgqKN64vJiTn2jpY0EC4bOeSPI7mVKDxxtvIet/NlRgbVpyQ==
X-Received: by 2002:a17:90a:2228:: with SMTP id c37mr32162607pje.9.1562667724503;
        Tue, 09 Jul 2019 03:22:04 -0700 (PDT)
Received: from localhost.localdomain (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id j1sm40161849pgl.12.2019.07.09.03.22.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 03:22:03 -0700 (PDT)
From:   Jian-Hong Pan <jian-hong@endlessm.com>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] rtw88: pci: Rearrange the memory usage for skb in RX ISR
Date:   Tue,  9 Jul 2019 18:20:59 +0800
Message-Id: <20190709102059.7036-1-jian-hong@endlessm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708063252.4756-1-jian-hong@endlessm.com>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Testing with RTL8822BE hardware, when available memory is low, we
frequently see a kernel panic and system freeze.

First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):

rx routine starvation
WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:822 rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
[ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]

Then we see a variety of different error conditions and kernel panics,
such as this one (trimmed):

rtw_pci 0000:02:00.0: pci bus timeout, check dma status
skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:00000000d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
------------[ cut here ]------------
kernel BUG at net/core/skbuff.c:105!
invalid opcode: 0000 [#1] SMP NOPTI
RIP: 0010:skb_panic+0x43/0x45

When skb allocation fails and the "rx routine starvation" is hit, the
function returns immediately without updating the RX ring. At this
point, the RX ring may continue referencing an old skb which was already
handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
bad things happen.

This patch allocates a new, data-sized skb first in RX ISR. After
copying the data in, we pass it to the upper layers. However, if skb
allocation fails, we effectively drop the frame. In both cases, the
original, full size ring skb is reused.

In addition, to fixing the kernel crash, the RX routine should now
generally behave better under low memory conditions.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 49 +++++++++++-------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index cfe05ba7280d..e9fe3ad896c8 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -763,6 +763,7 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 	u32 pkt_offset;
 	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
 	u32 buf_desc_sz = chip->rx_buf_desc_sz;
+	u32 new_len;
 	u8 *rx_desc;
 	dma_addr_t dma;
 
@@ -790,40 +791,34 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, struct rtw_pci *rtwpci,
 		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
 			     pkt_stat.shift;
 
-		if (pkt_stat.is_c2h) {
-			/* keep rx_desc, halmac needs it */
-			skb_put(skb, pkt_stat.pkt_len + pkt_offset);
+		/* discard current skb if the new skb cannot be allocated as a
+		 * new one in rx ring later
+		 */
+		new_len = pkt_stat.pkt_len + pkt_offset;
+		new = dev_alloc_skb(new_len);
+		if (WARN_ONCE(!new, "rx routine starvation\n"))
+			goto next_rp;
+
+		/* put the DMA data including rx_desc from phy to new skb */
+		skb_put_data(new, skb->data, new_len);
 
-			/* pass offset for further operation */
-			*((u32 *)skb->cb) = pkt_offset;
-			skb_queue_tail(&rtwdev->c2h_queue, skb);
+		if (pkt_stat.is_c2h) {
+			 /* pass rx_desc & offset for further operation */
+			*((u32 *)new->cb) = pkt_offset;
+			skb_queue_tail(&rtwdev->c2h_queue, new);
 			ieee80211_queue_work(rtwdev->hw, &rtwdev->c2h_work);
 		} else {
-			/* remove rx_desc, maybe use skb_pull? */
-			skb_put(skb, pkt_stat.pkt_len);
-			skb_reserve(skb, pkt_offset);
-
-			/* alloc a smaller skb to mac80211 */
-			new = dev_alloc_skb(pkt_stat.pkt_len);
-			if (!new) {
-				new = skb;
-			} else {
-				skb_put_data(new, skb->data, skb->len);
-				dev_kfree_skb_any(skb);
-			}
-			/* TODO: merge into rx.c */
-			rtw_rx_stats(rtwdev, pkt_stat.vif, skb);
+			/* remove rx_desc */
+			skb_pull(new, pkt_offset);
+
+			rtw_rx_stats(rtwdev, pkt_stat.vif, new);
 			memcpy(new->cb, &rx_status, sizeof(rx_status));
 			ieee80211_rx_irqsafe(rtwdev->hw, new);
 		}
 
-		/* skb delivered to mac80211, alloc a new one in rx ring */
-		new = dev_alloc_skb(RTK_PCI_RX_BUF_SIZE);
-		if (WARN(!new, "rx routine starvation\n"))
-			return;
-
-		ring->buf[cur_rp] = new;
-		rtw_pci_reset_rx_desc(rtwdev, new, ring, cur_rp, buf_desc_sz);
+next_rp:
+		/* new skb delivered to mac80211, re-enable original skb DMA */
+		rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc_sz);
 
 		/* host read next element in ring */
 		if (++cur_rp >= ring->r.len)
-- 
2.22.0

