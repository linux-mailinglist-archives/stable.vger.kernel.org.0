Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AB7C37C9D7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhELQWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240373AbhELQR4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC81E619A1;
        Wed, 12 May 2021 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834239;
        bh=yxWuWUXLICmglpa67NgIU1IjQoO4kS1LM+x4OlC3pNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0khfh/9lqr6jq98V3+8pVxsgj0qrktsDC1l9tfDyZw4xkBAiBPvpQj4xDkKKxAKP+
         JnIi7o6BFerjIYkX7UTc+jiWqijTckz+HUS4Pz1xFbOkHOFw2zzDkLBJBLQRZHDaxa
         /jnrBFrG9zpBWVah3ERgYu1rUR05lWKTL67+vdx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 464/601] mt76: mt7915: fix tx skb dma unmap
Date:   Wed, 12 May 2021 16:49:01 +0200
Message-Id: <20210512144843.118622831@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index c9dd6867e125..8a083304ab03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1082,7 +1082,7 @@ void mt7915_txp_skb_unmap(struct mt76_dev *dev,
 	int i;
 
 	txp = mt7915_txwi_to_txp(dev, t);
-	for (i = 1; i < txp->nbuf; i++)
+	for (i = 0; i < txp->nbuf; i++)
 		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
 				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
 }
-- 
2.30.2



