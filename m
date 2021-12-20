Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF1247A74C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhLTJiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:38:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57670 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhLTJiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:38:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F75AB80E30
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 09:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B5CC36AE2;
        Mon, 20 Dec 2021 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639993130;
        bh=CcHGx/82Ulf93CRtwS5ZNZB/lUJxCLofPR3DqhBCoGM=;
        h=Subject:To:Cc:From:Date:From;
        b=vvt/zyKJQaS13nSKcnmbrBWH9A6dyYn457/NXK/5D8RqPwyTjZfBIibsL+5xFXyFa
         qvTbg2520DLZUwIlPby2jKtPT9HwwRsZqX9TOKt1vGY9aNCF5gbHbGEFVvxNsrmovb
         lGxTnt/oShWLP2yF2gpJI/0A83QMpUNogBcMFuvs=
Subject: FAILED: patch "[PATCH] serial: 8250_fintek: Fix garbled text for console" failed to apply to 5.4-stable tree
To:     hpeter@gmail.com, gregkh@linuxfoundation.org,
        hpeter+linux_kernel@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 10:38:47 +0100
Message-ID: <16399931271082@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6c33ff728812aa18792afffaf2c9873b898e7512 Mon Sep 17 00:00:00 2001
From: "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
Date: Wed, 15 Dec 2021 15:58:35 +0800
Subject: [PATCH] serial: 8250_fintek: Fix garbled text for console

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

diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
index 31c9e83ea3cb..251f0018ae8c 100644
--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -290,25 +290,6 @@ static void fintek_8250_set_max_fifo(struct fintek_8250 *pdata)
 	}
 }
 
-static void fintek_8250_goto_highspeed(struct uart_8250_port *uart,
-			      struct fintek_8250 *pdata)
-{
-	sio_write_reg(pdata, LDN, pdata->index);
-
-	switch (pdata->pid) {
-	case CHIP_ID_F81966:
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
@@ -430,7 +411,6 @@ static int probe_setup_port(struct fintek_8250 *pdata,
 
 				fintek_8250_set_irq_mode(pdata, level_mode);
 				fintek_8250_set_max_fifo(pdata);
-				fintek_8250_goto_highspeed(uart, pdata);
 
 				fintek_8250_exit_key(addr[i]);
 

