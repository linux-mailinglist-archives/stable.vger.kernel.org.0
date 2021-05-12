Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D1D37C9D8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbhELQWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240377AbhELQR5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:17:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54D1B611AD;
        Wed, 12 May 2021 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834236;
        bh=Y1vP5lSmmKt2b5u1aN35SL+judL54ouvL5KIg6nQ3no=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1kITUmV3MC21kwQpQAz7BysO+132XLEj2dN/dYCSc7qZnDXt89U4H7mOT+jQx9Dx1
         wjT9T5PKyyzxiJkt9DduN4xqzyA4eVSe+KodZyhJA4WnJP1cYee55xZaeOKyulqXiS
         hoKk2/dsSiK3QH+6XhvSlaYRk5UrGJIEqPlnuOAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 463/601] mt76: mt7615: fix tx skb dma unmap
Date:   Wed, 12 May 2021 16:49:00 +0200
Message-Id: <20210512144843.087746085@linuxfoundation.org>
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

[ Upstream commit ebee7885bb12a8fe2c2f9bac87dbd87a05b645f9 ]

The first pointer in the txp needs to be unmapped as well, otherwise it will
leak DMA mapping entries

Fixes: 27d5c528a7ca ("mt76: fix double DMA unmap of the first buffer on 7615/7915")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index cb8bf6a29b52..34a88eab74ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -688,7 +688,7 @@ mt7615_txp_skb_unmap_fw(struct mt76_dev *dev, struct mt7615_fw_txp *txp)
 {
 	int i;
 
-	for (i = 1; i < txp->nbuf; i++)
+	for (i = 0; i < txp->nbuf; i++)
 		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
 				 le16_to_cpu(txp->len[i]), DMA_TO_DEVICE);
 }
-- 
2.30.2



