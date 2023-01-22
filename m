Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FCE676F86
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjAVPWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjAVPWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5226722A18
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD78F60C6F
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CCDC433EF;
        Sun, 22 Jan 2023 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400939;
        bh=9t4KWhRidtAUYKMxtbqtwlQnzoEFCofYzqLF9b6JLOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNN6Dx7bbZ52YQHF1kJThxPgji4F6GbvIruuuLWc3uiQKQSfrlm8SqcIhSpaSE4gQ
         iCb+ZDtQ9eGj0qL2HB3VrxP5n8AIwIC3xLiDC5y0IPlDFIDfLvVc1PznBESrEBSboD
         TJNLXdgY9qa6DcSpDrVrG7YbDoO5RW2AhXuPhwEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Vasut <marex@denx.de>, Johan Hovold <johan@kernel.org>,
        Valentin Caron <valentin.caron@foss.st.com>
Subject: [PATCH 6.1 049/193] Revert "serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler"
Date:   Sun, 22 Jan 2023 16:02:58 +0100
Message-Id: <20230122150248.604912424@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 2cbafffbf69addd7509072f4be5917f81d238cf6 upstream.

This reverts commit f24771b62a83239f0dce816bddf0f6807f436235 as it is
reported to break the build.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202301200130.ttBiTzfO-lkp@intel.com
Fixes: f24771b62a83 ("serial: stm32: Merge hard IRQ and threaded IRQ handling into single IRQ handler")
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Valentin Caron <valentin.caron@foss.st.com> # V3
Cc: Marek Vasut <marex@denx.de>
Cc: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -798,9 +798,23 @@ static irqreturn_t stm32_usart_interrupt
 		spin_unlock(&port->lock);
 	}
 
+	if (stm32_usart_rx_dma_enabled(port))
+		return IRQ_WAKE_THREAD;
+	else
+		return IRQ_HANDLED;
+}
+
+static irqreturn_t stm32_usart_threaded_interrupt(int irq, void *ptr)
+{
+	struct uart_port *port = ptr;
+	struct tty_port *tport = &port->state->port;
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	unsigned int size;
+	unsigned long flags;
+
 	/* Receiver timeout irq for DMA RX */
-	if (stm32_usart_rx_dma_enabled(port) && !stm32_port->throttled) {
-		spin_lock(&port->lock);
+	if (!stm32_port->throttled) {
+		spin_lock_irqsave(&port->lock, flags);
 		size = stm32_usart_receive_chars(port, false);
 		uart_unlock_and_check_sysrq_irqrestore(port, flags);
 		if (size)
@@ -1002,8 +1016,10 @@ static int stm32_usart_startup(struct ua
 	u32 val;
 	int ret;
 
-	ret = request_irq(port->irq, stm32_usart_interrupt,
-			  IRQF_NO_SUSPEND, name, port);
+	ret = request_threaded_irq(port->irq, stm32_usart_interrupt,
+				   stm32_usart_threaded_interrupt,
+				   IRQF_ONESHOT | IRQF_NO_SUSPEND,
+				   name, port);
 	if (ret)
 		return ret;
 
@@ -1586,6 +1602,13 @@ static int stm32_usart_of_dma_rx_probe(s
 	struct dma_slave_config config;
 	int ret;
 
+	/*
+	 * Using DMA and threaded handler for the console could lead to
+	 * deadlocks.
+	 */
+	if (uart_console(port))
+		return -ENODEV;
+
 	stm32port->rx_buf = dma_alloc_coherent(dev, RX_BUF_L,
 					       &stm32port->rx_dma_buf,
 					       GFP_KERNEL);


