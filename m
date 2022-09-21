Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107E35C032E
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiIUQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiIUP7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692EFA2235;
        Wed, 21 Sep 2022 08:53:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77C6B6312C;
        Wed, 21 Sep 2022 15:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735F6C433D6;
        Wed, 21 Sep 2022 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775499;
        bh=dFE3C9ghUTZrYZYjoc5fWsVgl4ell7HANJEgLZfMXtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0neogc8ALkdodamaftvcG6sd7g7AIWa5fOE7NQntT3M7OamEUxPsIoIrBDEKJncYS
         0XqKaB6EH5N+YxokiwLl7b0lyR639NudYD3f5JoWcI1vk5YiIt5KOCbeKZEDPHNJh4
         JKaLZfKxBSdZwSP6ZDaxGJI0ckA5dSiOY8W6KCkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/39] serial: 8250: Fix reporting real baudrate value in c_ospeed field
Date:   Wed, 21 Sep 2022 17:46:08 +0200
Message-Id: <20220921153645.815577016@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 32262e2e429cdb31f9e957e997d53458762931b7 ]

In most cases it is not possible to set exact baudrate value to hardware.

So fix reporting real baudrate value which was set to hardware via c_ospeed
termios field. It can be retrieved by ioctl(TCGETS2) from userspace.

Real baudrate value is calculated from chosen hardware divisor and base
clock. It is implemented in a new function serial8250_compute_baud_rate()
which is inverse of serial8250_get_divisor() function.

With this change is fixed also UART timeout value (it is updated via
uart_update_timeout() function), which is calculated from the now fixed
baudrate value too.

Cc: stable@vger.kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20210927093704.19768-1-pali@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 9d60418e4adb..eaf4eb33a78d 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2547,6 +2547,19 @@ static unsigned int serial8250_get_divisor(struct uart_port *port,
 	return serial8250_do_get_divisor(port, baud, frac);
 }
 
+static unsigned int serial8250_compute_baud_rate(struct uart_port *port,
+						 unsigned int quot)
+{
+	if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8001)
+		return port->uartclk / 4;
+	else if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8002)
+		return port->uartclk / 8;
+	else if (port->type == PORT_NPCM)
+		return DIV_ROUND_CLOSEST(port->uartclk - 2 * (quot + 2), 16 * (quot + 2));
+	else
+		return DIV_ROUND_CLOSEST(port->uartclk, 16 * quot);
+}
+
 static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 					    tcflag_t c_cflag)
 {
@@ -2688,11 +2701,14 @@ void serial8250_update_uartclk(struct uart_port *port, unsigned int uartclk)
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
+	baud = serial8250_compute_baud_rate(port, quot);
 
 	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
@@ -2726,6 +2742,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	baud = serial8250_get_baud_rate(port, termios, old);
 	quot = serial8250_get_divisor(port, baud, &frac);
+	baud = serial8250_compute_baud_rate(port, quot);
 
 	/*
 	 * Ok, we're now changing the port state.  Do it with
-- 
2.35.1



