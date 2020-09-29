Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C09127C8D7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgI2Lhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730259AbgI2Lhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A022823BC8;
        Tue, 29 Sep 2020 11:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379419;
        bh=StopoSPyCs7EocPsq1Gp2kQ/vfNkfLuq7EPGBHDEt7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZUyMEhWf8atYdmSgdeiJ9/8W5R2ENs3czaDOUhd/46gMCv5uv3NAqz7+rv0Yyg8Q
         CSJVWt0tAI6NiIzVhOezSHmh4yK7UqqrDQjHobCekv/cCazK9RkqtjIpHac/AD5QNp
         G1TZxynz2oaqEWfg4DVqF0iI/hsygx/40HARhzh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/388] mt76: fix handling full tx queues in mt76_dma_tx_queue_skb_raw
Date:   Tue, 29 Sep 2020 12:57:35 +0200
Message-Id: <20200929110016.470522701@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 93eaec7625f13cffb593b471405b017c7e64d4ee ]

Fixes a theoretical issue where it could potentially overwrite an existing
descriptor entry (and leaking its skb)

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 6249a46c19762..026d996612fbe 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -261,10 +261,13 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 
+	if (q->queued + 1 >= q->ndesc - 1)
+		goto error;
+
 	addr = dma_map_single(dev->dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev->dev, addr)))
-		return -ENOMEM;
+		goto error;
 
 	buf.addr = addr;
 	buf.len = skb->len;
@@ -275,6 +278,10 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	spin_unlock_bh(&q->lock);
 
 	return 0;
+
+error:
+	dev_kfree_skb(skb);
+	return -ENOMEM;
 }
 
 static int
-- 
2.25.1



