Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D8138A5D3
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbhETKUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:20:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236167AbhETKSD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:18:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89912613F3;
        Thu, 20 May 2021 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504001;
        bh=jFWwtTE5bvOh7Wi21Gb39v5DHA/gpFqzU5H/FeuTnxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t61gXiA+AkcdPDgyXPF0vuo2wRHk6harH6qCYhtHol9UVNpAoCZhCAovA4TUvLXbv
         cIt+P+UBdLF5fMYobnmFDnzqdiUsN45KqBAFfB1iAMg9KipzWvb8iytVz9cLt/jccq
         I4OwPu0h0RVCoY3H/A5PmgSv9jxfr7Anmws73bLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/323] media: ite-cir: check for receive overflow
Date:   Thu, 20 May 2021 11:19:00 +0200
Message-Id: <20210520092121.758201695@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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



