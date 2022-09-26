Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75DE25EA086
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbiIZKj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236171AbiIZKic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:38:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A8F52FCA;
        Mon, 26 Sep 2022 03:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04E90B80682;
        Mon, 26 Sep 2022 10:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39056C433D7;
        Mon, 26 Sep 2022 10:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187739;
        bh=+EO+0WMEX3fWugULxoV78K5efRFvXMMx8Wm17d97AM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzeiksPlJRO3EMKORpwZoT/VHvrt9uBoqhntsMS8LeRB8KwXKN78hkBe1Ul+wZPDq
         QhcvQzkuOBz5yHX39cK7or/zWCL65PDxOCKTmReGWSB40FP3vePLgjwmiG4q9Q5NfN
         G9/YjzBoWDiEGawF4geEwKH11N6OMSILWhHnjuVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/120] tty/serial: atmel: RS485 & ISO7816: wait for TXRDY before sending data
Date:   Mon, 26 Sep 2022 12:11:18 +0200
Message-Id: <20220926100752.382756365@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Codrin.Ciubotariu@microchip.com <Codrin.Ciubotariu@microchip.com>

[ Upstream commit 477b8383100023ea0769979cff67e9be3a720397 ]

At this moment, TXEMPTY is checked before sending data on RS485 and ISO7816
modes. However, TXEMPTY is risen when FIFO (if used) or the Transmit Shift
Register are empty, even though TXRDY might be up and controller is able to
receive data. Since the controller sends data only when TXEMPTY is ready,
on RS485, when DMA is not used, the RTS pin is driven low after each byte.
With this patch, the characters will be transmitted when TXRDY is up and
so, RTS pin will remain high between bytes.
The performance improvement on RS485 is about 8% with a baudrate of 300.

Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Link: https://lore.kernel.org/r/20200107111656.26308-1-codrin.ciubotariu@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 692a8ebcfc24 ("tty: serial: atmel: Preserve previous USART mode if RS485 disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/atmel_serial.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3b2c25bd2e06..e011f3d20224 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -313,7 +313,11 @@ static int atmel_config_rs485(struct uart_port *port,
 
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
+		if (port->rs485.flags & SER_RS485_RX_DURING_TX)
+			atmel_port->tx_done_mask = ATMEL_US_TXRDY;
+		else
+			atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
+
 		atmel_uart_writel(port, ATMEL_US_TTGR,
 				  rs485conf->delay_rts_after_send);
 		mode |= ATMEL_US_USMODE_RS485;
@@ -832,7 +836,7 @@ static void atmel_tx_chars(struct uart_port *port)
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (port->x_char &&
-	    (atmel_uart_readl(port, ATMEL_US_CSR) & atmel_port->tx_done_mask)) {
+	    (atmel_uart_readl(port, ATMEL_US_CSR) & ATMEL_US_TXRDY)) {
 		atmel_uart_write_char(port, port->x_char);
 		port->icount.tx++;
 		port->x_char = 0;
@@ -840,8 +844,7 @@ static void atmel_tx_chars(struct uart_port *port)
 	if (uart_circ_empty(xmit) || uart_tx_stopped(port))
 		return;
 
-	while (atmel_uart_readl(port, ATMEL_US_CSR) &
-	       atmel_port->tx_done_mask) {
+	while (atmel_uart_readl(port, ATMEL_US_CSR) & ATMEL_US_TXRDY) {
 		atmel_uart_write_char(port, xmit->buf[xmit->tail]);
 		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		port->icount.tx++;
@@ -852,10 +855,20 @@ static void atmel_tx_chars(struct uart_port *port)
 	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
 
-	if (!uart_circ_empty(xmit))
+	if (!uart_circ_empty(xmit)) {
+		/* we still have characters to transmit, so we should continue
+		 * transmitting them when TX is ready, regardless of
+		 * mode or duplexity
+		 */
+		atmel_port->tx_done_mask |= ATMEL_US_TXRDY;
+
 		/* Enable interrupts */
 		atmel_uart_writel(port, ATMEL_US_IER,
 				  atmel_port->tx_done_mask);
+	} else {
+		if (atmel_uart_is_half_duplex(port))
+			atmel_port->tx_done_mask &= ~ATMEL_US_TXRDY;
+	}
 }
 
 static void atmel_complete_tx_dma(void *arg)
@@ -2541,8 +2554,7 @@ static int atmel_init_port(struct atmel_uart_port *atmel_port,
 	 * Use TXEMPTY for interrupt when rs485 or ISO7816 else TXRDY or
 	 * ENDTX|TXBUFE
 	 */
-	if (port->rs485.flags & SER_RS485_ENABLED ||
-	    port->iso7816.flags & SER_ISO7816_ENABLED)
+	if (atmel_uart_is_half_duplex(port))
 		atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
 	else if (atmel_use_pdc_tx(port)) {
 		port->fifosize = PDC_BUFFER_SIZE;
-- 
2.35.1



