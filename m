Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69FFDF7D68
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfKKS4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbfKKS4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:56:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF2DD21925;
        Mon, 11 Nov 2019 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498585;
        bh=7lfFxI0gTmDMXslUWLK2Z7X6F1C9aD2HkNE8li4/iXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X90kUMXf2GkeYPG/aUgHq+n6hrwZKJSHas5YkShkQb7iCLi/Qtz/RXc9Un0m7Tz1A
         ziw8NHGKqxD4/4mratJv/O+M2WdxUs+fbDqyxr7zKeUUvtiO7nRJzf2WVXMOO0d1BR
         wIfq/VcjNc/RKNFuG/dSAiLfpTnsBr/CIUtrm/28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 163/193] mt76: dma: fix buffer unmap with non-linear skbs
Date:   Mon, 11 Nov 2019 19:29:05 +0100
Message-Id: <20191111181513.152220867@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 7bd0650be63cbb9e45e394d689c81365fe48e495 ]

mt76 dma layer is supposed to unmap skb data buffers while keep txwi
mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
not unmap data fragments in even positions for non-linear skbs. This
issue may result in hw hangs with A-MSDU if the system relies on IOMMU
or SWIOTLB. Fix this behaviour properly unmapping data fragments on
non-linear skbs.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index d8f61e540bfd3..ed744cd19819c 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -64,8 +64,10 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	u32 ctrl;
 	int i, idx = -1;
 
-	if (txwi)
+	if (txwi) {
 		q->entry[q->head].txwi = DMA_DUMMY_DATA;
+		q->entry[q->head].skip_buf0 = true;
+	}
 
 	for (i = 0; i < nbufs; i += 2, buf += 2) {
 		u32 buf0 = buf[0].addr, buf1 = 0;
@@ -108,7 +110,7 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
 	u32 ctrl = le32_to_cpu(__ctrl);
 
-	if (!e->txwi || !e->skb) {
+	if (!e->skip_buf0) {
 		__le32 addr = READ_ONCE(q->desc[idx].buf0);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 989386ecb5e4e..e98859ab480b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -102,8 +102,9 @@ struct mt76_queue_entry {
 		struct urb *urb;
 	};
 	enum mt76_txq_id qid;
-	bool schedule;
-	bool done;
+	bool skip_buf0:1;
+	bool schedule:1;
+	bool done:1;
 };
 
 struct mt76_queue_regs {
-- 
2.20.1



