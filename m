Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33472C9B3B
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387651AbgLAJGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbgLAJGC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F4002224A;
        Tue,  1 Dec 2020 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813546;
        bh=z//7JeVCb8EzAnvPDC5wUpe0tLfUjr/1kiZZTgYCeYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SRx+bTilQbLQvLLlC5cAXcDTOgVphgZdMBnxNx41RxNYfYl5pvqCwRgnv6QuY0drD
         f4tZsP0prbLud9yyOs80mWvnWGa2UZ/8n8KHat7IE5wo+l2Be4lXt6Ba0798F9Jfas
         BwbkpqJtbG8I+9EF+smXg5QMSCOznX/GHJvuz+C4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Pankaj Sharma <pankj.sharma@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 76/98] can: m_can: m_can_open(): remove IRQF_TRIGGER_FALLING from request_threaded_irq()s flags
Date:   Tue,  1 Dec 2020 09:53:53 +0100
Message-Id: <20201201084658.783493642@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 865f5b671b48d0088ce981cff1e822d9f7da441f ]

The threaded IRQ handler is used for the tcan4x5x driver only. The IRQ pin of
the tcan4x5x controller is active low, so better not use IRQF_TRIGGER_FALLING
when requesting the IRQ. As this can result in missing interrupts.

Further, if the device tree specified the interrupt as "IRQ_TYPE_LEVEL_LOW",
unloading and reloading of the driver results in the following error during
ifup:

| irq: type mismatch, failed to map hwirq-31 for gpio@20a8000!
| tcan4x5x spi1.1: m_can device registered (irq=0, version=32)
| tcan4x5x spi1.1 can2: TCAN4X5X successfully initialized.
| tcan4x5x spi1.1 can2: failed to request interrupt

This patch fixes the problem by removing the IRQF_TRIGGER_FALLING from the
request_threaded_irq().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
Cc: Pankaj Sharma <pankj.sharma@samsung.com>
Link: https://lore.kernel.org/r/20201127093548.509253-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 246fa2657d744..eafdb4441d441 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1605,7 +1605,7 @@ static int m_can_open(struct net_device *dev)
 		INIT_WORK(&cdev->tx_work, m_can_tx_work_queue);
 
 		err = request_threaded_irq(dev->irq, NULL, m_can_isr,
-					   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
+					   IRQF_ONESHOT,
 					   dev->name, dev);
 	} else {
 		err = request_irq(dev->irq, m_can_isr, IRQF_SHARED, dev->name,
-- 
2.27.0



