Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581F937C5E6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhELPoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhELPjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:39:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09F166199D;
        Wed, 12 May 2021 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832844;
        bh=LEaZT3EiD4UMYxzYaA95qpiTWHa5aj373qv2v1yWGGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdpNhxN046l56h1HIEk9c6/w4h2C8ov1G37bcLxMyqg0WBL4ZI980EPZDX/fxmWrY
         PF1xxVfkW+QnaPfQKHYSXeratjWKoMcVpX7QLUmCTOM0em35AUTVE5y6N5dCmEspPl
         hPiW7btsD6Rr9a2ezRzSLyEmQwckpfS+JgFQDH8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/530] mt76: mt7615: fix tx skb dma unmap
Date:   Wed, 12 May 2021 16:48:42 +0200
Message-Id: <20210512144833.302509577@linuxfoundation.org>
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
index 8c66ad943b4d..f479012ab52c 100644
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



