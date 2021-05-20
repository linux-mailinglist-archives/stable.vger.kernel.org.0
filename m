Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAE338AA39
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhETLLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240147AbhETLJL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:09:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B7C961940;
        Thu, 20 May 2021 10:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505196;
        bh=y1KZOimxnzrONNjyUcvByZsk2dyLGwJrGm9ar+YMXgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MP/F9xv/8ETLjdQV/YX5HtQpO0NxF3hhKyHmHmGAQqpyhB11iAA0r5MMIoNkNX2d9
         5P/ePAoZ/wycIJOWPuwYPe7D0qt18BtK1VS52Ur+Xcc6p5OOmafxHttUdkhgexocJZ
         vDwzp1g8k4DG3Tj6AJmnDIzsqmCswLv5mXbqBbOg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 025/190] media: ite-cir: check for receive overflow
Date:   Thu, 20 May 2021 11:21:29 +0200
Message-Id: <20210520092103.007082724@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



