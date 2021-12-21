Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E48647BC67
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 10:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhLUJFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 04:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhLUJFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 04:05:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBEEC061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 01:05:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so1945223pja.1
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 01:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Ttfb1LBVIVCdfk+zLhZRksCBNfowlouwVYucgbIF6Uo=;
        b=i3WY/dK2lRhg0HzXkvo87rRAMas7idFBfDlbVTZfe0ABomQKaFm4q9wef4zXLQk/PY
         saeoYqIuGYHG1uK83YhyEhkYGX2DQC+l8f6CAYtOQPXuiZtayRBuHLOH+UFiZOPUroBb
         qO8YBNj/NnO5VffI2iGSfjMU5A0IZaJYYicL3PV77qX5vmpB5mM1y8xB76xziiCiB6zZ
         iQZ2G8SHPXtio1GrO7rnIPmidDFXwygPs10E5wUiAbDcjZrqz4HaZQsBx+QGlEJ2Q/0J
         C7Rxf6BYw/boC2+PBcwLj/BFiFO3z6yhbkGZZpwshw3XM5L8Ro5ioWHw9ieFyesVeDfy
         7YNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ttfb1LBVIVCdfk+zLhZRksCBNfowlouwVYucgbIF6Uo=;
        b=MmppE7b7B9To528qO6Nd8FCagDh5xcUOQ25KOVequwQZsqm1x0E7qCcJ57FupjJzCy
         smbLaGeLb6DjgdU5r8/3M+dy3p/jwDNjXAMq8GtvcARu+vKMii2pCIRfjfp9yEN6L7cN
         5JiP3k8XsseYv1yVVxvUeP/GkkBUuyN2ZS9IFzTzLkFsx0Xrjwtk0B/XELMSj1opiSHB
         hsrNynGrCcnWKYiUhtrMx1VY3V6e74gKzc2NxLDTyjQ6N3HAiH1wS+tl/QSzAHUzaDJV
         qgBLqEZjI8NNMwtiJKCbU8uMpIQCrGomh/Ec/gw4Knvy4hrIcsKxoh7JHuCd9qFePyZi
         UnuQ==
X-Gm-Message-State: AOAM530IYwBpWa3kOPMejV+yXFKZKMUR9E++CZzyI1mTTCKlzlHHaX2e
        7koMp3IeIL65qlzgacb1Rr8=
X-Google-Smtp-Source: ABdhPJw9G6ms6tGuF7mjz7owfoJulqL+cemQpu1G5BuWSqHefTiyUJCCkqlJkvT3/Uehhgc2Uk9zcg==
X-Received: by 2002:a17:902:dac7:b0:148:ef58:10d5 with SMTP id q7-20020a170902dac700b00148ef5810d5mr2405982plx.124.1640077500696;
        Tue, 21 Dec 2021 01:05:00 -0800 (PST)
Received: from localhost (59-120-186-245.hinet-ip.hinet.net. [59.120.186.245])
        by smtp.gmail.com with ESMTPSA id n6sm20832423pfa.28.2021.12.21.01.04.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Dec 2021 01:05:00 -0800 (PST)
From:   "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>
X-Google-Original-From: "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org,
        peter_hong@fintek.com.tw
Cc:     "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Subject: [PATCH V1 1/1] serial: 8250_fintek: Fix garbled text for console
Date:   Tue, 21 Dec 2021 17:04:20 +0800
Message-Id: <20211221090420.19387-1-hpeter+linux_kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch is modified and fix conflict for kernel 5.4 from below patch.
Commit 6c33ff728812 ("serial: 8250_fintek: Fix garbled text for console")

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
---
 drivers/tty/serial/8250/8250_fintek.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
index 31c91c2f8c6e..e24161004ddc 100644
--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -285,24 +285,6 @@ static void fintek_8250_set_max_fifo(struct fintek_8250 *pdata)
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
@@ -422,7 +404,6 @@ static int probe_setup_port(struct fintek_8250 *pdata,
 
 				fintek_8250_set_irq_mode(pdata, level_mode);
 				fintek_8250_set_max_fifo(pdata);
-				fintek_8250_goto_highspeed(uart, pdata);
 
 				fintek_8250_exit_key(addr[i]);
 
-- 
2.17.1

