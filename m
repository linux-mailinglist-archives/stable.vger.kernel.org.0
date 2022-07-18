Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7761C5786AE
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbiGRPtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiGRPtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4871265D
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E228B8165A
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 15:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BBBC341C0;
        Mon, 18 Jul 2022 15:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658159350;
        bh=r72Rbnk1G4NMtRwv6j+nPPgMgWvgnTvY+HBeBVuLzUw=;
        h=Subject:To:Cc:From:Date:From;
        b=NP8MAlcvetOhuPfw/HRrITCqAASDGupkiYnMOqOx3l4AqSs0XAGqOWieMQwtypLFS
         bir5VCx2skUNnJt9z7PZo/zTahvIycu+zfpBukApi/z4mTMItlNlZmwkpZwLYnziII
         h8HNEaeRQSn4obczBrlh7LViPYZMGzQr9VGaR41E=
Subject: FAILED: patch "[PATCH] serial: mvebu-uart: correctly report configured baudrate" failed to apply to 5.15-stable tree
To:     pali@kernel.org, gregkh@linuxfoundation.org,
        ilpo.jarvinen@linux.intel.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 17:49:07 +0200
Message-ID: <16581593477499@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4f532c1e25319e42996ec18a1f473fd50c8e575d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Tue, 28 Jun 2022 12:09:22 +0200
Subject: [PATCH] serial: mvebu-uart: correctly report configured baudrate
 value
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Functions tty_termios_encode_baud_rate() and uart_update_timeout() should
be called with the baudrate value which was set to hardware. Linux then
report exact values via ioctl(TCGETS2) to userspace.

Change mvebu_uart_baud_rate_set() function to return baudrate value which
was set to hardware and propagate this value to above mentioned functions.

With this change userspace would see precise value in termios c_ospeed
field.

Fixes: 68a0db1d7da2 ("serial: mvebu-uart: add function to change baudrate")
Cc: stable <stable@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20220628100922.10717-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 0429c2a54290..93489fe334d0 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -470,14 +470,14 @@ static void mvebu_uart_shutdown(struct uart_port *port)
 	}
 }
 
-static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
+static unsigned int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
 	unsigned int d_divisor, m_divisor;
 	unsigned long flags;
 	u32 brdv, osamp;
 
 	if (!port->uartclk)
-		return -EOPNOTSUPP;
+		return 0;
 
 	/*
 	 * The baudrate is derived from the UART clock thanks to divisors:
@@ -548,7 +548,7 @@ static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 			(m_divisor << 16) | (m_divisor << 24);
 	writel(osamp, port->membase + UART_OSAMP);
 
-	return 0;
+	return DIV_ROUND_CLOSEST(port->uartclk, d_divisor * m_divisor);
 }
 
 static void mvebu_uart_set_termios(struct uart_port *port,
@@ -587,15 +587,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 	max_baud = port->uartclk / 80;
 
 	baud = uart_get_baud_rate(port, termios, old, min_baud, max_baud);
-	if (mvebu_uart_baud_rate_set(port, baud)) {
-		/* No clock available, baudrate cannot be changed */
-		if (old)
-			baud = uart_get_baud_rate(port, old, NULL,
-						  min_baud, max_baud);
-	} else {
-		tty_termios_encode_baud_rate(termios, baud, baud);
-		uart_update_timeout(port, termios->c_cflag, baud);
-	}
+	baud = mvebu_uart_baud_rate_set(port, baud);
+
+	/* In case baudrate cannot be changed, report previous old value */
+	if (baud == 0 && old)
+		baud = tty_termios_baud_rate(old);
 
 	/* Only the following flag changes are supported */
 	if (old) {
@@ -606,6 +602,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 		termios->c_cflag |= CS8;
 	}
 
+	if (baud != 0) {
+		tty_termios_encode_baud_rate(termios, baud, baud);
+		uart_update_timeout(port, termios->c_cflag, baud);
+	}
+
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 

