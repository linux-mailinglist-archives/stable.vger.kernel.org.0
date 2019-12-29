Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B3912C321
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 16:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfL2PqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 10:46:05 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:57793 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfL2PqF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 10:46:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id E0087413;
        Sun, 29 Dec 2019 10:46:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 10:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=o40N+w
        fXGbrb0yF82jTbrspHxNZ9gaNA1dG9BRg26A0=; b=RoirDwvWATJ/eaQQ+eT+5K
        JsCBAE7SkbseGh1sGGUfGk2BALZ6DGEJppANOefOxH1chB/9Y4biSAnuYgVTH+ot
        3mTsTsbY5VAhPQHRQWq7v6ge/4DfDuJUFl9455rHoa+w9vbTi+JAGCWXTyhgqONY
        skeHAnJUEu7l5yQ9LckbEddn4kkTjYKFg318DdfqkTSjLOCFjf63DC0X1nh2SKhi
        Yg7dObjCFDjCS62wF91kXwUD8Agh+anAsvyf2yof9Xp+padLi3AfhakqpPoF9mkQ
        FmdNcxWqLKlIQV/u4WFN+ClqD4Iuo2sQcoPLg21D1KITuJyvtlwmvcId8ShpQF7w
        ==
X-ME-Sender: <xms:OsoIXmleIJ2HhAlTiO4j6AyrZT6Ip-LzIjq1ZBFNA8YmTt9cTstB1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OsoIXmjW1YSmBQBBiNC1qihdjkt8N_1xD12fdQgvrSRoj8yeCBoQqg>
    <xmx:OsoIXklPE3lG3TR6t3AV95mIR83FTRC12YMhyf4TT_wI4PG1Hv1M_g>
    <xmx:OsoIXnFQIhkfBxFUNw1G5hSO4b5MfutpNnmo7RNS3vkZdrOZ4mCHZw>
    <xmx:O8oIXnnnGkeu3RJbbevh_ZdUVy9krcxR7goVpQaYlsqPDFXp_-DieQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B6078005B;
        Sun, 29 Dec 2019 10:46:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] tty/serial: atmel: fix out of range clock divider handling" failed to apply to 4.19-stable tree
To:     david.engraf@sysgo.com, gregkh@linuxfoundation.org,
        ludovic.desroches@microchip.com, richard.genoud@gmail.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 16:45:59 +0100
Message-ID: <1577634359228165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb47b9f8630ae3fa3f5fbd0c7003faba7abdf711 Mon Sep 17 00:00:00 2001
From: David Engraf <david.engraf@sysgo.com>
Date: Mon, 16 Dec 2019 09:54:03 +0100
Subject: [PATCH] tty/serial: atmel: fix out of range clock divider handling

Use MCK_DIV8 when the clock divider is > 65535. Unfortunately the mode
register was already written thus the clock selection is ignored.

Fix by doing the baud rate calulation before setting the mode.

Fixes: 5bf5635ac170 ("tty/serial: atmel: add fractional baud rate support")
Signed-off-by: David Engraf <david.engraf@sysgo.com>
Acked-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Acked-by: Richard Genoud <richard.genoud@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191216085403.17050-1-david.engraf@sysgo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a8dc8af83f39..1ba9bc667e13 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2270,27 +2270,6 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 		mode |= ATMEL_US_USMODE_NORMAL;
 	}
 
-	/* set the mode, clock divisor, parity, stop bits and data size */
-	atmel_uart_writel(port, ATMEL_US_MR, mode);
-
-	/*
-	 * when switching the mode, set the RTS line state according to the
-	 * new mode, otherwise keep the former state
-	 */
-	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
-		unsigned int rts_state;
-
-		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
-			/* let the hardware control the RTS line */
-			rts_state = ATMEL_US_RTSDIS;
-		} else {
-			/* force RTS line to low level */
-			rts_state = ATMEL_US_RTSEN;
-		}
-
-		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
-	}
-
 	/*
 	 * Set the baud rate:
 	 * Fractional baudrate allows to setup output frequency more
@@ -2317,6 +2296,28 @@ static void atmel_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (!(port->iso7816.flags & SER_ISO7816_ENABLED))
 		atmel_uart_writel(port, ATMEL_US_BRGR, quot);
+
+	/* set the mode, clock divisor, parity, stop bits and data size */
+	atmel_uart_writel(port, ATMEL_US_MR, mode);
+
+	/*
+	 * when switching the mode, set the RTS line state according to the
+	 * new mode, otherwise keep the former state
+	 */
+	if ((old_mode & ATMEL_US_USMODE) != (mode & ATMEL_US_USMODE)) {
+		unsigned int rts_state;
+
+		if ((mode & ATMEL_US_USMODE) == ATMEL_US_USMODE_HWHS) {
+			/* let the hardware control the RTS line */
+			rts_state = ATMEL_US_RTSDIS;
+		} else {
+			/* force RTS line to low level */
+			rts_state = ATMEL_US_RTSEN;
+		}
+
+		atmel_uart_writel(port, ATMEL_US_CR, rts_state);
+	}
+
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
 	atmel_uart_writel(port, ATMEL_US_CR, ATMEL_US_TXEN | ATMEL_US_RXEN);
 	atmel_port->tx_stopped = false;

