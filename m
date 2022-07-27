Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81FA0582D90
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbiG0Q76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241260AbiG0Q7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:59:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4552067CAF;
        Wed, 27 Jul 2022 09:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25840B821B6;
        Wed, 27 Jul 2022 16:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA25C433D6;
        Wed, 27 Jul 2022 16:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939830;
        bh=hfbxyf/DUJ3IQqVUNeTv9mC8aZK0OZHI4xKyS0XTpjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7GEPPuyz47XWza4DJ1OjkR870T7yfBGuy/ClwfHjvxNMpe48bIP5wH+2svNcqKN5
         /qXViuAYXNjwFmO95B/jrDJKgApeqJUoXTfI5kcLLq17RCtkA6NXkUPk5tTQfzmpA5
         DCN1/eUpMdC+9g/zKWWGs65B19lcErHlJgI0pKNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.15 014/201] serial: mvebu-uart: correctly report configured baudrate value
Date:   Wed, 27 Jul 2022 18:08:38 +0200
Message-Id: <20220727161027.512869711@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 4f532c1e25319e42996ec18a1f473fd50c8e575d upstream.

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
---
 drivers/tty/serial/mvebu-uart.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -442,13 +442,13 @@ static void mvebu_uart_shutdown(struct u
 	}
 }
 
-static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
+static unsigned int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
 	unsigned int d_divisor, m_divisor;
 	u32 brdv, osamp;
 
 	if (!port->uartclk)
-		return -EOPNOTSUPP;
+		return 0;
 
 	/*
 	 * The baudrate is derived from the UART clock thanks to two divisors:
@@ -472,7 +472,7 @@ static int mvebu_uart_baud_rate_set(stru
 	osamp &= ~OSAMP_DIVISORS_MASK;
 	writel(osamp, port->membase + UART_OSAMP);
 
-	return 0;
+	return DIV_ROUND_CLOSEST(port->uartclk, d_divisor * m_divisor);
 }
 
 static void mvebu_uart_set_termios(struct uart_port *port,
@@ -509,15 +509,11 @@ static void mvebu_uart_set_termios(struc
 	max_baud = 230400;
 
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
@@ -528,6 +524,11 @@ static void mvebu_uart_set_termios(struc
 		termios->c_cflag |= CS8;
 	}
 
+	if (baud != 0) {
+		tty_termios_encode_baud_rate(termios, baud, baud);
+		uart_update_timeout(port, termios->c_cflag, baud);
+	}
+
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 


