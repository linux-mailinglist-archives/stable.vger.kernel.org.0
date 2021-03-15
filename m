Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61A333B6D5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbhCON6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhCON6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A704364F34;
        Mon, 15 Mar 2021 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816692;
        bh=/MXVebiUsSQTlklZvgXeCiIsC9ubuyLXYbpwzzT86SU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeB5IO8xzx6zlSmhgwUsne64cpkn043b6T9lrlClplP+kOiY4x09MH2RBG++x4npk
         f6jBPqsalM0UM4HCl7Tkcsje/t0b+oBhuTs2GKOycT5Le3/QnJAaPx59HGe1jZBycv
         Tnxt8R8g0BbNnYbztoQp3OLlYj+PPcS9LQttuuz8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.19 010/120] mt76: dma: do not report truncated frames to mac80211
Date:   Mon, 15 Mar 2021 14:56:01 +0100
Message-Id: <20210315135720.353823572@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
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
@@ -395,13 +395,13 @@ mt76_add_fragment(struct mt76_dev *dev,
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
@@ -410,7 +410,10 @@ mt76_add_fragment(struct mt76_dev *dev,
 		return;
 
 	q->rx_head = NULL;
-	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+	if (nr_frags < ARRAY_SIZE(shinfo->frags))
+		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+	else
+		dev_kfree_skb(skb);
 }
 
 static int


