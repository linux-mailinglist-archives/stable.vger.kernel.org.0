Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A85F33B680
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCON57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231955AbhCON5W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24EC864F23;
        Mon, 15 Mar 2021 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816642;
        bh=EKtIuy4eeUOiHRfT7UaTpUYKs9fNuUweBxtdgRGO6yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fbo1/6QjkjpdKoJqKzo/Htz1ZLOGfOmHo0pqncnMSu/NIZPA6g2xg8Bs4h78p2saM
         ae3CO/CUaUbqg4Jjex53iJ/XeCLFfcrgOBQ30uzlmolTo43iqY0boT7po7EndFD4MZ
         ZRuMs/HbkTD+v0O1Pv6KjfoX+eEcl08GqXPVGPFI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.10 029/290] mt76: dma: do not report truncated frames to mac80211
Date:   Mon, 15 Mar 2021 14:52:02 +0100
Message-Id: <20210315135542.910378015@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit d0bd52c591a1070c54dc428e926660eb4f981099 upstream.

Commit b102f0c522cf6 ("mt76: fix array overflow on receiving too many
fragments for a packet") fixes a possible OOB access but it introduces a
memory leak since the pending frame is not released to page_frag_cache
if the frag array of skb_shared_info is full. Commit 93a1d4791c10
("mt76: dma: fix a possible memory leak in mt76_add_fragment()") fixes
the issue but does not free the truncated skb that is forwarded to
mac80211 layer. Fix the leftover issue discarding even truncated skbs.

Fixes: 93a1d4791c10 ("mt76: dma: fix a possible memory leak in mt76_add_fragment()")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/a03166fcc8214644333c68674a781836e0f57576.1612697217.git.lorenzo@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -521,13 +521,13 @@ mt76_add_fragment(struct mt76_dev *dev,
 {
 	struct sk_buff *skb = q->rx_head;
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
+	int nr_frags = shinfo->nr_frags;
 
-	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
+	if (nr_frags < ARRAY_SIZE(shinfo->frags)) {
 		struct page *page = virt_to_head_page(data);
 		int offset = data - page_address(page) + q->buf_offset;
 
-		skb_add_rx_frag(skb, shinfo->nr_frags, page, offset, len,
-				q->buf_size);
+		skb_add_rx_frag(skb, nr_frags, page, offset, len, q->buf_size);
 	} else {
 		skb_free_frag(data);
 	}
@@ -536,7 +536,10 @@ mt76_add_fragment(struct mt76_dev *dev,
 		return;
 
 	q->rx_head = NULL;
-	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+	if (nr_frags < ARRAY_SIZE(shinfo->frags))
+		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+	else
+		dev_kfree_skb(skb);
 }
 
 static int


