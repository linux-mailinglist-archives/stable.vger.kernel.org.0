Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5F3371D41
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhECQ6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235318AbhECQ4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 616336142E;
        Mon,  3 May 2021 16:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060213;
        bh=y1KZOimxnzrONNjyUcvByZsk2dyLGwJrGm9ar+YMXgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqCDvGx3SJW/aCiw47AmFUw6ID6u3taqGgt75c7IlHGcgaCPYEYs2lp+FEMrB7KCn
         5DruVD5Gr+OyuRVkF/eteHmtlqDK7l73Jfbg252T7cSPYwvdIsRW6mJzwjBlsLRIdn
         XE4GtZZ/DibZb9DAfgipk0Um3f2tqgZ09GQFxLwzeJRYiLvrZoMzO4KVvKiDjrzHY0
         JRr/g6lbZtWHs349qCXH1KBg6u0wQ1/MqqfMb1cj+gP4WOPdmCkmX5kZkAdVtwpKHN
         9qfD2q/0QxuAFcbye31dD8coWrNPWK7LqiUXtQpvUfphRaduhQJwOdK4f0G2+D8Oi2
         B3sWYkZ6+ouvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/16] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:43:15 -0400
Message-Id: <20210503164329.2854739-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
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
index 63165d324fff..7d3e50d94d86 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -292,8 +292,14 @@ static irqreturn_t ite_cir_isr(int irq, void *data)
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

