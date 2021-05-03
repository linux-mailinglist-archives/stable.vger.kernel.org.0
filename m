Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD07371B80
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbhECQqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:46:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:50734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233087AbhECQoh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:44:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFD8C61581;
        Mon,  3 May 2021 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059935;
        bh=M8Fw1kys6+G6wwPjb5qVzyUf6hZGtRAEXQedwGOyilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfGwfp47KpOYpCHas2DvgPgYkwV3h5BLGf+fy3ssx+aLKdLETu4pLUdovkV6VrdIq
         Q+DhKNgEAWcZJznb17shlrysME5wwiccY8om5J7L47BZERWsqvX/quWEUGCkJxIWDz
         n04ZklGMuMMWcH3ZWm2eDThbZ8CtCBXkYBNuWTAi0z2s4WSKx6K6NYD4vq2yRv+aup
         YugLzztDDeirbqYMLkrd3qx9AadiP8XgwOc51OaLjS6VBQ7n63eWd2hnYHlvYUH6P/
         amlWg96tjSKSX/rnmB9Lvek6f27hmTmNhRtIU8oEb09kKvO9XIJZYZVnroJI54pmtO
         4qBK2UBBkHJzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 017/100] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:37:06 -0400
Message-Id: <20210503163829.2852775-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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

