Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CD537C5B7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhELPmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236362AbhELPhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F018E61492;
        Wed, 12 May 2021 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832761;
        bh=ToiDdiDBDkoLSvyW7lUKVeyTxFCHYMNWxtJ4Bru9NhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbfeSP4QqxxOyGv28SjZDeJvYRFA3W9eLlQ0wFmn8192DSmIUFd65LcKO17He9BYS
         A+gDP9d+31HpsZ4FgjesEnKK6Po+QmGWZ7wHbZT1tALn7t0D4PQyQ3rueyxIxaPTAI
         Maoc/S8m+NaMpRKzGCwh8J5jDB3fcwGysH/nDnO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/530] mt76: mt7915: fix tx skb dma unmap
Date:   Wed, 12 May 2021 16:48:43 +0200
Message-Id: <20210512144833.335935301@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
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
index 6f159d99a596..dd5793004989 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -856,7 +856,7 @@ void mt7915_txp_skb_unmap(struct mt76_dev *dev,
 	int i;
 
 	txp = mt7915_txwi_to_txp(dev, t);
-	for (i = 1; i < txp->nbuf; i++)
+	for (i = 0; i < txp->nbuf; i++)
 		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
 				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
 }
-- 
2.30.2



