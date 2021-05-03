Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CE5371CD5
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhECQ5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhECQxx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:53:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54B9B61466;
        Mon,  3 May 2021 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060131;
        bh=jFWwtTE5bvOh7Wi21Gb39v5DHA/gpFqzU5H/FeuTnxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jgcADf6iD62d/gMAW7GfGHSglMHrA+rqRLcN6MTT/eFXW7EoyFVaFZmgFNnXsGljp
         QN4NeOa7O9cmXS+N93btzaN3m5NeiBwZYJ0/R7kTiUh8HJ0fUSH5YlwNrnFN/t+ntE
         ckEH0o3GBEraZ3RzIcSiEt5SUfPwIVGKJOkTLt4At2rmvpGNS29W+7zSthLMSOu2lL
         FA9Ea6uGExa+toBnMzbyA6mvLvEE9dWGkOn6XmqnB9IDfpq8nDPBkZO+TAq7CXnhf6
         jo6Yyty8YD0rVsK5pfnBB+vM0d8XWoY4k6KmOyuzJ0Wk2c2N34J4blowF16PeSOpyC
         IpIcPt9mdnmJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/31] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:41:37 -0400
Message-Id: <20210503164204.2854178-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
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
index 65e104c7ddfc..c7eea16225e7 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -285,8 +285,14 @@ static irqreturn_t ite_cir_isr(int irq, void *data)
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

