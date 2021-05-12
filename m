Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7BB37CB14
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbhELQeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241445AbhELQ1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B44261DD3;
        Wed, 12 May 2021 15:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834753;
        bh=8Vx+9HdAGP+X7D/doo6hdDJmZvgRwKFwJ3VY2Mt689Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHMX+Ndee8THLfYIuKfh/Z7byqJwLBWH1tNDk/5Vyaicyd15xzRJnURnPzoRWuxj/
         38rD4PHDYAGoqyIGb4RmlXtNYA8VIrHALEc1haGYIRyTV/NpLzgY8oPudzAemkGi/i
         KmjN1BGkONpkabhhJYX0l26RrhT91d+sH+n7LVxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 5.12 069/677] mt76: fix potential DMA mapping leak
Date:   Wed, 12 May 2021 16:41:55 +0200
Message-Id: <20210512144839.515451558@linuxfoundation.org>
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
@@ -309,7 +309,7 @@ static int
 mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, u32 tx_info)
 {
-	struct mt76_queue_buf buf;
+	struct mt76_queue_buf buf = {};
 	dma_addr_t addr;
 
 	if (q->queued + 1 >= q->ndesc - 1)


