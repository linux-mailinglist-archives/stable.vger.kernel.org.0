Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395A53719CE
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhECQh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231476AbhECQhE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:37:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84D3C613CB;
        Mon,  3 May 2021 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059756;
        bh=M8Fw1kys6+G6wwPjb5qVzyUf6hZGtRAEXQedwGOyilo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iDeA6FeSqWLKOytRWBkcIoapVQy56gYZqVSZVCbgg+P07FANmHz0iIR3abA2gW/Wv
         4QfpaszaNGqeRzqNalxg3ac0FMJICKn5DbDxsUpAdQYgC+0Qpdvlsz1LCYiCHvVj5Y
         5K1Wi9GeQb0KMwdLO2osXOncgqN6nltG54oqPvpU/PMSKhxsxNsM0b275hATSp0Let
         gTGfQW5BByKrPxJAcQgppTxmmu0zNshS2iurJjKzdwZ6ic6w6hCHZnwANr17Y1c79m
         JAQRAxJE2hbj1c0nhFF8ly37zu/FvkFPTG7fin576z2IOlgt441t/r48AkY7xzEdQf
         T+I7Wx1e5xZBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 027/134] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:33:26 -0400
Message-Id: <20210503163513.2851510-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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

