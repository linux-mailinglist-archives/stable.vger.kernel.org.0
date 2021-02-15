Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA831BCFC
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhBOPhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231318AbhBOPhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 178C664EDF;
        Mon, 15 Feb 2021 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403162;
        bh=d1CUVYk0SC2MJPPsLMtuThawV9TOFuQjU/XcEX12xzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tnI+SDvZ0hFGgfApVqxFZvpO6NzCP+EG6KKjI5aaXL135dxMrrf3Kix2CT2pOQNCz
         F+C/USR8dSUVp1TCuy0rJ3iMnG6hnSaotTfyLRY7vOjxO/yz7vV71HEIFAKE78BPMb
         Sw/bOgWt8rrHeIgco1H0DIDuHpzyb0hMuC0BL1zA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/104] mt76: dma: fix a possible memory leak in mt76_add_fragment()
Date:   Mon, 15 Feb 2021 16:27:05 +0100
Message-Id: <20210215152721.159111487@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 93a1d4791c10d443bc67044def7efee2991d48b7 ]

Fix a memory leak in mt76_add_fragment routine returning the buffer
to the page_frag_cache when we receive a new fragment and the
skb_shared_info frag array is full.

Fixes: b102f0c522cf6 ("mt76: fix array overflow on receiving too many fragments for a packet")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/4f9dd73407da88b2a552517ce8db242d86bf4d5c.1611616130.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 145e839fea4e5..917617aad8d3c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -519,15 +519,17 @@ static void
 mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 		  int len, bool more)
 {
-	struct page *page = virt_to_head_page(data);
-	int offset = data - page_address(page);
 	struct sk_buff *skb = q->rx_head;
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 
 	if (shinfo->nr_frags < ARRAY_SIZE(shinfo->frags)) {
-		offset += q->buf_offset;
+		struct page *page = virt_to_head_page(data);
+		int offset = data - page_address(page) + q->buf_offset;
+
 		skb_add_rx_frag(skb, shinfo->nr_frags, page, offset, len,
 				q->buf_size);
+	} else {
+		skb_free_frag(data);
 	}
 
 	if (more)
-- 
2.27.0



