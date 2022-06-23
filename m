Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439B85584DC
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiFWRuD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbiFWRtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F83C9E349;
        Thu, 23 Jun 2022 10:11:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AFF261D55;
        Thu, 23 Jun 2022 17:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCCEDC3411B;
        Thu, 23 Jun 2022 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004313;
        bh=A7Qyuav7/4QCk8yiYqOpEFwrTTt+uEPJ1DpRCfOL1tM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=donfl92MtU0OoucV3e07ZBFn8CQ1airBuHUg9jns8us7K2No/S8UG5Wy1qcCW39T3
         9thTtkGXpCfdgqJAgO2gIgSLgrDjAN91mfWhrGeTwzuMZdPB1mKs1Y9nkiXXp+u2c6
         LI5i9hXVoHZjLLFPDyI6LOgICuhNa5qoTPLTvNLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.10 10/11] serial: core: Initialize rs485 RTS polarity already on probe
Date:   Thu, 23 Jun 2022 18:44:43 +0200
Message-Id: <20220623164322.599123949@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
References: <20220623164322.296526800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 2dd8a74fddd21b95dcc60a2d3c9eaec993419d69 upstream.

RTS polarity of rs485-enabled ports is currently initialized on uart
open via:

tty_port_open()
  tty_port_block_til_ready()
    tty_port_raise_dtr_rts()  # if (C_BAUD(tty))
      uart_dtr_rts()
        uart_port_dtr_rts()

There's at least three problems here:

First, if no baud rate is set, RTS polarity is not initialized.
That's the right thing to do for rs232, but not for rs485, which
requires that RTS is deasserted unconditionally.

Second, if the DeviceTree property "linux,rs485-enabled-at-boot-time" is
present, RTS should be deasserted as early as possible, i.e. on probe.
Otherwise it may remain asserted until first open.

Third, even though RTS is deasserted on open and close, it may
subsequently be asserted by uart_throttle(), uart_unthrottle() or
uart_set_termios() because those functions aren't rs485-aware.
(Only uart_tiocmset() is.)

To address these issues, move RTS initialization from uart_port_dtr_rts()
to uart_configure_port().  Prevent subsequent modification of RTS
polarity by moving the existing rs485 check from uart_tiocmget() to
uart_update_mctrl().

That way, RTS is initialized on probe and then remains unmodified unless
the uart transmits data.  If rs485 is enabled at runtime (instead of at
boot) through a TIOCSRS485 ioctl(), RTS is initialized by the uart
driver's ->rs485_config() callback and then likewise remains unmodified.

The PL011 driver initializes RTS on uart open and prevents subsequent
modification in its ->set_mctrl() callback.  That code is obsoleted by
the present commit, so drop it.

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Su Bao Cheng <baocheng.su@siemens.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/2d2acaf3a69e89b7bf687c912022b11fd29dfa1e.1642909284.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -144,6 +144,11 @@ uart_update_mctrl(struct uart_port *port
 	unsigned long flags;
 	unsigned int old;
 
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		set &= ~TIOCM_RTS;
+		clear &= ~TIOCM_RTS;
+	}
+
 	spin_lock_irqsave(&port->lock, flags);
 	old = port->mctrl;
 	port->mctrl = (old & ~clear) | set;
@@ -157,23 +162,10 @@ uart_update_mctrl(struct uart_port *port
 
 static void uart_port_dtr_rts(struct uart_port *uport, int raise)
 {
-	int rs485_on = uport->rs485_config &&
-		(uport->rs485.flags & SER_RS485_ENABLED);
-	int RTS_after_send = !!(uport->rs485.flags & SER_RS485_RTS_AFTER_SEND);
-
-	if (raise) {
-		if (rs485_on && RTS_after_send) {
-			uart_set_mctrl(uport, TIOCM_DTR);
-			uart_clear_mctrl(uport, TIOCM_RTS);
-		} else {
-			uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
-		}
-	} else {
-		unsigned int clear = TIOCM_DTR;
-
-		clear |= (!rs485_on || RTS_after_send) ? TIOCM_RTS : 0;
-		uart_clear_mctrl(uport, clear);
-	}
+	if (raise)
+		uart_set_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
+	else
+		uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 }
 
 /*
@@ -1116,11 +1108,6 @@ uart_tiocmset(struct tty_struct *tty, un
 		goto out;
 
 	if (!tty_io_error(tty)) {
-		if (uport->rs485.flags & SER_RS485_ENABLED) {
-			set &= ~TIOCM_RTS;
-			clear &= ~TIOCM_RTS;
-		}
-
 		uart_update_mctrl(uport, set, clear);
 		ret = 0;
 	}
@@ -2429,6 +2416,9 @@ uart_configure_port(struct uart_driver *
 		 */
 		spin_lock_irqsave(&port->lock, flags);
 		port->mctrl &= TIOCM_DTR;
+		if (port->rs485.flags & SER_RS485_ENABLED &&
+		    !(port->rs485.flags & SER_RS485_RTS_AFTER_SEND))
+			port->mctrl |= TIOCM_RTS;
 		port->ops->set_mctrl(port, port->mctrl);
 		spin_unlock_irqrestore(&port->lock, flags);
 


