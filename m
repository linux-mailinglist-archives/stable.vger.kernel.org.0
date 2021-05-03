Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87555371C76
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhECQwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231906AbhECQuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A01216192D;
        Mon,  3 May 2021 16:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060076;
        bh=KkJLWJR/icDzq06kTCIfwSPB4B9uo9pQ4NbCczthCE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdQO0k7djXKbOx7tf480GkhrxP8w+ZIyvivrJMjWxKkd7pDKtISi2RYME6s5SdIwQ
         8fR+Wy+50nnqSTEpiBB+HAF0W1pwPSN7oSelry739dD4+UZxtf+t6VYMiT61jXJPez
         w7hIMi2Xe6RfU3JnBDPdh2G1r1vV191lzUIbd6i+eRDMyj8QsUVPcqrKibogC1kluE
         SBrGef7GgWdMrzOd9vVXxZ70ChYg7r8+qbcxdaz0b9RXqGgUzg3Dh6CLlFuarkKeAh
         e7EIfukyHwuHNrMOvwTcVpiwTuj1nMI10nLgPHOwEnIMz34ubXihUUv0czTlSV4vvG
         YRu+KmiawdHIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/35] media: ite-cir: check for receive overflow
Date:   Mon,  3 May 2021 12:40:38 -0400
Message-Id: <20210503164109.2853838-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164109.2853838-1-sashal@kernel.org>
References: <20210503164109.2853838-1-sashal@kernel.org>
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
index de77d22c30a7..18f3718315a8 100644
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

