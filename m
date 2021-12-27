Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7476847FF09
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbhL0PfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238288AbhL0Pe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E1BC061799;
        Mon, 27 Dec 2021 07:34:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5F331CE10B3;
        Mon, 27 Dec 2021 15:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52750C36AE7;
        Mon, 27 Dec 2021 15:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619263;
        bh=Z5NiYkRq4ZBuXOFNRazdnc+Px0Ijzu3yulWNHV0fxR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QI7N9YITJurmqvekL2sAsYp8so9HgN9sq8WEeVbGTJTqKOVs5NsZDcgxNljpnIvg+
         KWFbtnnx1yEnMIdn9WPBi8BZMU6vHRoa/xZO7OQRbtexgevkwYLmy/3Vmury8L0d8m
         Iy8DLPUQTmX3FVxJs2GZmtnkd2XZzWVu50G2x6wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Subject: [PATCH 5.4 02/47] serial: 8250_fintek: Fix garbled text for console
Date:   Mon, 27 Dec 2021 16:30:38 +0100
Message-Id: <20211227151320.880488226@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>

commit 6c33ff728812aa18792afffaf2c9873b898e7512 upstream.

Commit fab8a02b73eb ("serial: 8250_fintek: Enable high speed mode on Fintek F81866")
introduced support to use high baudrate with Fintek SuperIO UARTs. It'll
change clocksources when the UART probed.

But when user add kernel parameter "console=ttyS0,115200 console=tty0" to make
the UART as console output, the console will output garbled text after the
following kernel message.

[    3.681188] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled

The issue is occurs in following step:
	probe_setup_port() -> fintek_8250_goto_highspeed()

It change clocksource from 115200 to 921600 with wrong time, it should change
clocksource in set_termios() not in probed. The following 3 patches are
implemented change clocksource in fintek_8250_set_termios().

Commit 58178914ae5b ("serial: 8250_fintek: UART dynamic clocksource on Fintek F81216H")
Commit 195638b6d44f ("serial: 8250_fintek: UART dynamic clocksource on Fintek F81866")
Commit 423d9118c624 ("serial: 8250_fintek: Add F81966 Support")

Due to the high baud rate had implemented above 3 patches and the patch
Commit fab8a02b73eb ("serial: 8250_fintek: Enable high speed mode on Fintek F81866")
is bugged, So this patch will remove it.

Fixes: fab8a02b73eb ("serial: 8250_fintek: Enable high speed mode on Fintek F81866")
Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
Link: https://lore.kernel.org/r/20211215075835.2072-1-hpeter+linux_kernel@gmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_fintek.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -285,24 +285,6 @@ static void fintek_8250_set_max_fifo(str
 	}
 }
 
-static void fintek_8250_goto_highspeed(struct uart_8250_port *uart,
-			      struct fintek_8250 *pdata)
-{
-	sio_write_reg(pdata, LDN, pdata->index);
-
-	switch (pdata->pid) {
-	case CHIP_ID_F81866: /* set uart clock for high speed serial mode */
-		sio_write_mask_reg(pdata, F81866_UART_CLK,
-			F81866_UART_CLK_MASK,
-			F81866_UART_CLK_14_769MHZ);
-
-		uart->port.uartclk = 921600 * 16;
-		break;
-	default: /* leave clock speed untouched */
-		break;
-	}
-}
-
 static void fintek_8250_set_termios(struct uart_port *port,
 				    struct ktermios *termios,
 				    struct ktermios *old)
@@ -422,7 +404,6 @@ static int probe_setup_port(struct finte
 
 				fintek_8250_set_irq_mode(pdata, level_mode);
 				fintek_8250_set_max_fifo(pdata);
-				fintek_8250_goto_highspeed(uart, pdata);
 
 				fintek_8250_exit_key(addr[i]);
 


