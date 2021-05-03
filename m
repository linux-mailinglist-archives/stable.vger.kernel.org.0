Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0679371C00
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhECQvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233379AbhECQru (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9F0B61410;
        Mon,  3 May 2021 16:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059994;
        bh=EwRdCm8Hl3BFXJn9n8iyfgOP7JAJSRXxpKGlNTCg6eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HfiSQ82Pk9MtDZ+jFuy7BfVGOGBadTSImn0YmdFUdnldZBwkGvhYdzOHV36cNdhIo
         xiK9jdstuvV7+ZUIaKT8HoDjNMyKVT7wkkS6ACRzmLrkMIvPcwSlZxe73zMeULqzXB
         O8AaS24Ve4pF6fDOnfTyRFO4FQjcJ5aE8cTQb6LRbZpGPjPxg5eIADGNvsyleOzOyZ
         2yKQYqt8MS0TlvTm48apfz/BTh+u6ICWCUNuTv8bsOSBbRP2RQBKXZ4Vig8uAMli/1
         qtjYhIB2SY8Av5l+1FhRkawvkHcC+cfatR5cwCjwpIR87N/ZjQ5bFimuZGLph1ZqiK
         5Q1HEZlYTYvDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/57] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:38:52 -0400
Message-Id: <20210503163941.2853291-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
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
index 3ab6cec0dc3b..4b8aee390518 100644
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

