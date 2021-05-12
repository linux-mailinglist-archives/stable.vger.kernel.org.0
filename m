Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B14437C352
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhELPST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233880AbhELPPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02CBD61457;
        Wed, 12 May 2021 15:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831892;
        bh=9rxD0KXRvMQeIDDku1o8NgLrHq3G4M/dCwx147CEUWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibsZMS6ZvbOut5wAZLqdrWDuA7eL5EydroDEKt1abVFa+btW689DcMCWMkr2amB8s
         iYZ2e6HNehrJ67RrBrSPb996bmGCJkNVhM7aBk+84YNmcdnuZZQa9NBPclnX89L7jB
         pCiBoCfNWlpfRoPeRf9n6jRfUYTV9NA20wrerl1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.10 057/530] mt76: fix potential DMA mapping leak
Date:   Wed, 12 May 2021 16:42:47 +0200
Message-Id: <20210512144821.605251052@linuxfoundation.org>
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

commit b4403cee6400c5f679e9c4a82b91d61aa961eccf upstream.

With buf uninitialized in mt76_dma_tx_queue_skb_raw, its field skip_unmap
could potentially inherit a non-zero value from stack garbage.
If this happens, it will cause DMA mappings for MCU command frames to not be
unmapped after completion

Fixes: 27d5c528a7ca ("mt76: fix double DMA unmap of the first buffer on 7615/7915")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -318,7 +318,7 @@ mt76_dma_tx_queue_skb_raw(struct mt76_de
 			  struct sk_buff *skb, u32 tx_info)
 {
 	struct mt76_queue *q = dev->q_tx[qid];
-	struct mt76_queue_buf buf;
+	struct mt76_queue_buf buf = {};
 	dma_addr_t addr;
 
 	if (q->queued + 1 >= q->ndesc - 1)


