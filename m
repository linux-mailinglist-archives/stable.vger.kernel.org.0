Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021B5371B04
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhECQnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232145AbhECQkk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95AA961466;
        Mon,  3 May 2021 16:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059857;
        bh=M8Fw1kys6+G6wwPjb5qVzyUf6hZGtRAEXQedwGOyilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qs6h88Nkk+kMj3FezHfxhBcZe65eru13slaW/65+wb0qnvkYKz/tSfkZ6y+Fn9zbn
         8oiHJjIl8sbN6lmUNiT4+5evGT7pQwL7/Y78vZQnwrKPEgZy+K9MMz1Invk77M2j3r
         B8JKqgcWohOEyqqgphSL1LrcxrH2cxEsu/Sz6esQSw2mQTMTWu/QrV1TzQXmwY26OG
         2G8eyMfPa4yrchHO8RruhRf2RtCVXXh2hc4JyPYaWqum1Jgh1CJckQDSPNpGzGBbnY
         iSwZ81K7MKCUicxhA4+p+G2SX9plEUOUE1tW49ccBauwTHoN/aUvajr2RHS3cj0eds
         MYdZq4b9RNkIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 024/115] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:35:28 -0400
Message-Id: <20210503163700.2852194-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 28c7afb07ccfc0a939bb06ac1e7afe669901c65a ]

It's best if this condition is reported.

Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ite-cir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 0c6229592e13..e5c4a6941d26 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -276,8 +276,14 @@ static irqreturn_t ite_cir_isr(int irq, void *data)
 	/* read the interrupt flags */
 	iflags = dev->params.get_irq_causes(dev);
 
+	/* Check for RX overflow */
+	if (iflags & ITE_IRQ_RX_FIFO_OVERRUN) {
+		dev_warn(&dev->rdev->dev, "receive overflow\n");
+		ir_raw_event_reset(dev->rdev);
+	}
+
 	/* check for the receive interrupt */
-	if (iflags & (ITE_IRQ_RX_FIFO | ITE_IRQ_RX_FIFO_OVERRUN)) {
+	if (iflags & ITE_IRQ_RX_FIFO) {
 		/* read the FIFO bytes */
 		rx_bytes =
 			dev->params.get_rx_bytes(dev, rx_buf,
-- 
2.30.2

