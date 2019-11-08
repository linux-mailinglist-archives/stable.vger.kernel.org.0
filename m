Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59BBF5687
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403797AbfKHTJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:41050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391792AbfKHTJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 947CA20673;
        Fri,  8 Nov 2019 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240163;
        bh=8qsdJ47uQfrB7A5Ki3q409/MXPdNkeR+L2SHHSL7maA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9+RQI+2o5cwuIuafAkfcbO3RrnUQGGCbb/tPfFCO13c84GDB+8KHe09ifFM01B5o
         YB+JznuX+/bdV9yTvQQNdO1bnjZlZhkwKwQ9LjQFVgcFdXJotAb/5ns01gfjamSpUX
         l/cm5LrFH2zt+tF+F//nP/Q9BSa6n7aExYzeDrbg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabrice Gasnier <fabrice.gasnier@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 073/140] i2c: stm32f7: fix a race in slave mode with arbitration loss irq
Date:   Fri,  8 Nov 2019 19:50:01 +0100
Message-Id: <20191108174909.738013388@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 6d6b0d0d5afc8c4c84b08261260ba11dfa5206f2 ]

When in slave mode, an arbitration loss (ARLO) may be detected before the
slave had a chance to detect the stop condition (STOPF in ISR).
This is seen when two master + slave adapters switch their roles. It
provokes the i2c bus to be stuck, busy as SCL line is stretched.
- the I2C_SLAVE_STOP event is never generated due to STOPF flag is set but
  don't generate an irq (race with ARLO irq, STOPIE is masked). STOPF flag
  remains set until next master xfer (e.g. when STOPIE irq get unmasked).
  In this case, completion is generated too early: immediately upon new
  transfer request (then it doesn't send all data).
- Some data get stuck in TXDR register. As a consequence, the controller
  stretches the SCL line: the bus gets busy until a future master transfer
  triggers the bus busy / recovery mechanism (this can take time... and
  may never happen at all)

So choice is to let the STOPF being detected by the slave isr handler,
to properly handle this stop condition. E.g. don't mask IRQs in error
handler, when the slave is running.

Fixes: 60d609f30de2 ("i2c: i2c-stm32f7: Add slave support")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index 0af9219e45f79..82705deef7bff 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1503,7 +1503,7 @@ static irqreturn_t stm32f7_i2c_isr_error(int irq, void *data)
 	void __iomem *base = i2c_dev->base;
 	struct device *dev = i2c_dev->dev;
 	struct stm32_i2c_dma *dma = i2c_dev->dma;
-	u32 mask, status;
+	u32 status;
 
 	status = readl_relaxed(i2c_dev->base + STM32F7_I2C_ISR);
 
@@ -1528,12 +1528,15 @@ static irqreturn_t stm32f7_i2c_isr_error(int irq, void *data)
 		f7_msg->result = -EINVAL;
 	}
 
-	/* Disable interrupts */
-	if (stm32f7_i2c_is_slave_registered(i2c_dev))
-		mask = STM32F7_I2C_XFER_IRQ_MASK;
-	else
-		mask = STM32F7_I2C_ALL_IRQ_MASK;
-	stm32f7_i2c_disable_irq(i2c_dev, mask);
+	if (!i2c_dev->slave_running) {
+		u32 mask;
+		/* Disable interrupts */
+		if (stm32f7_i2c_is_slave_registered(i2c_dev))
+			mask = STM32F7_I2C_XFER_IRQ_MASK;
+		else
+			mask = STM32F7_I2C_ALL_IRQ_MASK;
+		stm32f7_i2c_disable_irq(i2c_dev, mask);
+	}
 
 	/* Disable dma */
 	if (i2c_dev->use_dma) {
-- 
2.20.1



