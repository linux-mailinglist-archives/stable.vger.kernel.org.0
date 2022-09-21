Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F445C0316
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbiIUQAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiIUP7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96359C2FF;
        Wed, 21 Sep 2022 08:52:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FDA5B830C0;
        Wed, 21 Sep 2022 15:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6819C43470;
        Wed, 21 Sep 2022 15:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775494;
        bh=kzCNxv+kLufdcqXotvyEBwyGJdVv5iQKf9LnXXFoGVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6yJdWeuULlr46rlSe9upNLIolH+bvmqU5hGopk9c3/m22CGIK0lQ1wKyLIQLnud1
         8CPSVXwRSI1s1HAdUNw/LvbsAwcZoGgzKl/IgUvJTyncMqTWQMOknjurTDCyqI+i+S
         ISDII03llVI0wcU34o/kvDUrgNvzZPBQzZEKWoks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 25/39] Revert "serial: 8250: Fix reporting real baudrate value in c_ospeed field"
Date:   Wed, 21 Sep 2022 17:46:30 +0200
Message-Id: <20220921153646.560456712@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit d02b006b29de14968ba4afa998bede0d55469e29 upstream.

This reverts commit 32262e2e429cdb31f9e957e997d53458762931b7.

The commit in question claims to determine the inverse of
serial8250_get_divisor() but failed to notice that some drivers override
the default implementation using a get_divisor() callback.

This means that the computed line-speed values can be completely wrong
and results in regular TCSETS requests failing (the incorrect values
would also be passed to any overridden set_divisor() callback).

Similarly, it also failed to honour the old (deprecated) ASYNC_SPD_FLAGS
and would break applications relying on those when re-encoding the
actual line speed.

There are also at least two quirks, UART_BUG_QUOT and an OMAP1510
workaround, which were happily ignored and that are now broken.

Finally, even if the offending commit were to be implemented correctly,
this is a new feature and not something which should be backported to
stable.

Cc: Pali Rohár <pali@kernel.org>
Fixes: 32262e2e429c ("serial: 8250: Fix reporting real baudrate value in c_ospeed field")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20211007133146.28949-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_port.c |   17 -----------------
 1 file changed, 17 deletions(-)

--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -2547,19 +2547,6 @@ static unsigned int serial8250_get_divis
 	return serial8250_do_get_divisor(port, baud, frac);
 }
 
-static unsigned int serial8250_compute_baud_rate(struct uart_port *port,
-						 unsigned int quot)
-{
-	if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8001)
-		return port->uartclk / 4;
-	else if ((port->flags & UPF_MAGIC_MULTIPLIER) && quot == 0x8002)
-		return port->uartclk / 8;
-	else if (port->type == PORT_NPCM)
-		return DIV_ROUND_CLOSEST(port->uartclk - 2 * (quot + 2), 16 * (quot + 2));
-	else
-		return DIV_ROUND_CLOSEST(port->uartclk, 16 * quot);
-}
-
 static unsigned char serial8250_compute_lcr(struct uart_8250_port *up,
 					    tcflag_t c_cflag)
 {
@@ -2701,14 +2688,11 @@ void serial8250_update_uartclk(struct ua
 
 	baud = serial8250_get_baud_rate(port, termios, NULL);
 	quot = serial8250_get_divisor(port, baud, &frac);
-	baud = serial8250_compute_baud_rate(port, quot);
 
 	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
 	uart_update_timeout(port, termios->c_cflag, baud);
-	if (tty_termios_baud_rate(termios))
-		tty_termios_encode_baud_rate(termios, baud, baud);
 
 	serial8250_set_divisor(port, baud, quot, frac);
 	serial_port_out(port, UART_LCR, up->lcr);
@@ -2742,7 +2726,6 @@ serial8250_do_set_termios(struct uart_po
 
 	baud = serial8250_get_baud_rate(port, termios, old);
 	quot = serial8250_get_divisor(port, baud, &frac);
-	baud = serial8250_compute_baud_rate(port, quot);
 
 	/*
 	 * Ok, we're now changing the port state.  Do it with


