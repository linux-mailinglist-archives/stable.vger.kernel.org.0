Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09887469EC9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391045AbhLFPoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390059AbhLFPlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:41:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B77C0698CA;
        Mon,  6 Dec 2021 07:25:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACB94B810AC;
        Mon,  6 Dec 2021 15:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CCFC34900;
        Mon,  6 Dec 2021 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804330;
        bh=mO05Mb/XMh9wHsZNKHvYDU6EaaMdcQEMLV8+CcewdCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpEpSxcxv8cd5zYXA7CazX1WE2YQWLRTTfsXFjuXm1KzmbXdQWYxvuJgFIBos3h12
         8+snXX+f8/+W7hOrCJ/WI0jK2Egn/gcT83pVEmpSDcQqy+knCad5gwW8wBEbAcRuD+
         SgtetfvxbEUICq48mAYttw9W3z5wW23LyqKCSc3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@foss.st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.15 101/207] i2c: stm32f7: stop dma transfer in case of NACK
Date:   Mon,  6 Dec 2021 15:55:55 +0100
Message-Id: <20211206145613.735802147@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@foss.st.com>

commit 31b90a95ccbbb4b628578ac17e3b3cc8eeacfe31 upstream.

In case of receiving a NACK, the dma transfer should be stopped
to avoid feeding data into the FIFO.
Also ensure to properly return the proper error code and avoid
waiting for the end of the dma completion in case of
error happening during the transmission.

Fixes: 7ecc8cfde553 ("i2c: i2c-stm32f7: Add DMA support")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1493,6 +1493,7 @@ static irqreturn_t stm32f7_i2c_isr_event
 {
 	struct stm32f7_i2c_dev *i2c_dev = data;
 	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
+	struct stm32_i2c_dma *dma = i2c_dev->dma;
 	void __iomem *base = i2c_dev->base;
 	u32 status, mask;
 	int ret = IRQ_HANDLED;
@@ -1518,6 +1519,10 @@ static irqreturn_t stm32f7_i2c_isr_event
 		dev_dbg(i2c_dev->dev, "<%s>: Receive NACK (addr %x)\n",
 			__func__, f7_msg->addr);
 		writel_relaxed(STM32F7_I2C_ICR_NACKCF, base + STM32F7_I2C_ICR);
+		if (i2c_dev->use_dma) {
+			stm32f7_i2c_disable_dma_req(i2c_dev);
+			dmaengine_terminate_all(dma->chan_using);
+		}
 		f7_msg->result = -ENXIO;
 	}
 
@@ -1533,7 +1538,7 @@ static irqreturn_t stm32f7_i2c_isr_event
 		/* Clear STOP flag */
 		writel_relaxed(STM32F7_I2C_ICR_STOPCF, base + STM32F7_I2C_ICR);
 
-		if (i2c_dev->use_dma) {
+		if (i2c_dev->use_dma && !f7_msg->result) {
 			ret = IRQ_WAKE_THREAD;
 		} else {
 			i2c_dev->master_mode = false;
@@ -1546,7 +1551,7 @@ static irqreturn_t stm32f7_i2c_isr_event
 		if (f7_msg->stop) {
 			mask = STM32F7_I2C_CR2_STOP;
 			stm32f7_i2c_set_bits(base + STM32F7_I2C_CR2, mask);
-		} else if (i2c_dev->use_dma) {
+		} else if (i2c_dev->use_dma && !f7_msg->result) {
 			ret = IRQ_WAKE_THREAD;
 		} else if (f7_msg->smbus) {
 			stm32f7_i2c_smbus_rep_start(i2c_dev);


