Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0250E37CDC5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbhELQ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244154AbhELQmj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64B1561D2E;
        Wed, 12 May 2021 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835873;
        bh=pYbO0cgf4ZVfIMcnnVJrfz9Qoa08KnoITO20rhXRsXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=trtjlhEzzSqK0L1wqND68mUwrGiuArSPu9kA7Y1RNqdHWolFnrw14OT0OnxY6LVBj
         q8HVyLOisl9UoYgb88WzK9RITIFDOuutt2+f0zhK+Ns+TTptpNELgimTFBS3pWV5pH
         w+cnSHGHeUG9UwjMiZne4R6kBE0lUdYjVaKO3tic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 518/677] mt76: mt7915: fix tx skb dma unmap
Date:   Wed, 12 May 2021 16:49:24 +0200
Message-Id: <20210512144854.595338865@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 7dcf3c04f0aca746517a77433b33d40868ca4749 ]

The first pointer in the txp needs to be unmapped as well, otherwise it will
leak DMA mapping entries

Reported-by: Ben Greear <greearb@candelatech.com>
Fixes: 27d5c528a7ca ("mt76: fix double DMA unmap of the first buffer on 7615/7915")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index e5a258958ac9..b79d614aaad9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1091,7 +1091,7 @@ void mt7915_txp_skb_unmap(struct mt76_dev *dev,
 	int i;
 
 	txp = mt7915_txwi_to_txp(dev, t);
-	for (i = 1; i < txp->nbuf; i++)
+	for (i = 0; i < txp->nbuf; i++)
 		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
 				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
 }
-- 
2.30.2



