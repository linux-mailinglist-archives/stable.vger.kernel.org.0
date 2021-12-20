Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE96547AE66
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239283AbhLTPBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37212 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239439AbhLTO7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0B53B80ED3;
        Mon, 20 Dec 2021 14:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008C4C36AE8;
        Mon, 20 Dec 2021 14:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012337;
        bh=vRZkm1a4q47YJvEqn2uc1GNEdWpxtHwei1ERi2mNqA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naud94eDwdocxXsx3Wi1xsxN4oMGmw3Hiacg7Xqjm2nSt6Ngq92UIZUbPzRScBkIQ
         n5EYpUplRxP4Iyq/oz4kB0k1rqs6NJEbBcxEfeketYWc2zOdND4uBXvw1H7QIjYIKo
         Pms5YYcrMy0a6SU+uCZFxKnWu8zvYBe3jYBWw20I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Subject: [PATCH 5.15 138/177] serial: 8250_fintek: Fix garbled text for console
Date:   Mon, 20 Dec 2021 15:34:48 +0100
Message-Id: <20211220143044.733708335@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
 drivers/tty/serial/8250/8250_fintek.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -290,25 +290,6 @@ static void fintek_8250_set_max_fifo(str
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
@@ -430,7 +411,6 @@ static int probe_setup_port(struct finte
 
 				fintek_8250_set_irq_mode(pdata, level_mode);
 				fintek_8250_set_max_fifo(pdata);
-				fintek_8250_goto_highspeed(uart, pdata);
 
 				fintek_8250_exit_key(addr[i]);
 


