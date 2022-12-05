Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113846433FE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234840AbiLETlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234848AbiLETlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:41:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC781FD0;
        Mon,  5 Dec 2022 11:38:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827C8B811E3;
        Mon,  5 Dec 2022 19:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5561C433C1;
        Mon,  5 Dec 2022 19:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269108;
        bh=l9MW/Gc9+ArnRwl2DRT7IsjnbxX0PY11C3AcQhaRJJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vweAv1uhlzM2P3xqlbOC7I8Z6fcLw0m/LcWnSkTVRsh1RtRwYMjJrhWBFx+gLKc91
         A2R67vF0ejSDxWilzb37I6IKNV+NsDgurK1SJ3E1KelTzDq7MwTmMF2VPg1p+qxYTK
         OQMzNP32vLNs04VDhOyKWASharm+zUsjqDRA/OKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, linux-serial@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Erwan Le Ray <erwan.leray@foss.st.com>,
        Jean Philippe Romain <jean-philippe.romain@foss.st.com>,
        Valentin Caron <valentin.caron@foss.st.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/120] serial: stm32: Factor out GPIO RTS toggling into separate function
Date:   Mon,  5 Dec 2022 20:10:51 +0100
Message-Id: <20221205190809.866241880@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 3bcea529b295a993b1b05db63f245ae8030c5acf ]

Pull out the GPIO RTS enable and disable handling into separate function.
Limit the scope of GPIO RTS toggling only to GPIO emulated RS485 too.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Erwan Le Ray <erwan.leray@foss.st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jean Philippe Romain <jean-philippe.romain@foss.st.com>
Cc: Valentin Caron <valentin.caron@foss.st.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-stm32@st-md-mailman.stormreply.com
To: linux-serial@vger.kernel.org
Link: https://lore.kernel.org/r/20220430162845.244655-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 61 ++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index fc166cc2c856..f2cef5f7ae5a 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -325,6 +325,42 @@ static void stm32_usart_tx_interrupt_disable(struct uart_port *port)
 		stm32_usart_clr_bits(port, ofs->cr1, USART_CR1_TXEIE);
 }
 
+static void stm32_usart_rs485_rts_enable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	}
+}
+
+static void stm32_usart_rs485_rts_disable(struct uart_port *port)
+{
+	struct stm32_port *stm32_port = to_stm32_port(port);
+	struct serial_rs485 *rs485conf = &port->rs485;
+
+	if (stm32_port->hw_flow_control ||
+	    !(rs485conf->flags & SER_RS485_ENABLED))
+		return;
+
+	if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl & ~TIOCM_RTS);
+	} else {
+		mctrl_gpio_set(stm32_port->gpios,
+			       stm32_port->port.mctrl | TIOCM_RTS);
+	}
+}
+
 static void stm32_usart_transmit_chars_pio(struct uart_port *port)
 {
 	struct stm32_port *stm32_port = to_stm32_port(port);
@@ -566,41 +602,20 @@ static void stm32_usart_disable_ms(struct uart_port *port)
 /* Transmit stop */
 static void stm32_usart_stop_tx(struct uart_port *port)
 {
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
-
 	stm32_usart_tx_interrupt_disable(port);
 
-	if (rs485conf->flags & SER_RS485_ENABLED) {
-		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl & ~TIOCM_RTS);
-		} else {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl | TIOCM_RTS);
-		}
-	}
+	stm32_usart_rs485_rts_disable(port);
 }
 
 /* There are probably characters waiting to be transmitted. */
 static void stm32_usart_start_tx(struct uart_port *port)
 {
-	struct stm32_port *stm32_port = to_stm32_port(port);
-	struct serial_rs485 *rs485conf = &port->rs485;
 	struct circ_buf *xmit = &port->state->xmit;
 
 	if (uart_circ_empty(xmit) && !port->x_char)
 		return;
 
-	if (rs485conf->flags & SER_RS485_ENABLED) {
-		if (rs485conf->flags & SER_RS485_RTS_ON_SEND) {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl | TIOCM_RTS);
-		} else {
-			mctrl_gpio_set(stm32_port->gpios,
-					stm32_port->port.mctrl & ~TIOCM_RTS);
-		}
-	}
+	stm32_usart_rs485_rts_enable(port);
 
 	stm32_usart_transmit_chars(port);
 }
-- 
2.35.1



