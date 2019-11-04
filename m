Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CB8EEDAB
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389050AbfKDWJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388158AbfKDWI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:08:59 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513DD214D8;
        Mon,  4 Nov 2019 22:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905339;
        bh=VQ2RHPzTeIuQcWi/Zg/CjUHQV9IT6SYsRvS4+5Ue/ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zgygy+0wfMKSNO0IEeo8hL4ywaG9CBCf+Kq3yMdxE1lWgYX0+Heqd9zlC/SW6v34v
         s7R2jaR0DYjxhDpLzZyPSYrcvDU+6TyRg9Js84hPq8qdHLnOrTGRc1U4OZH/cXQ5Zm
         npM9dwZnoHSDEj8xauYFrlnDZN5xdzCTlqRNkoLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.3 111/163] USB: serial: whiteheat: fix line-speed endianness
Date:   Mon,  4 Nov 2019 22:45:01 +0100
Message-Id: <20191104212148.291595521@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 84968291d7924261c6a0624b9a72f952398e258b upstream.

Add missing endianness conversion when setting the line speed so that
this driver might work also on big-endian machines.

Also use an unsigned format specifier in the corresponding debug
message.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/whiteheat.c |    9 ++++++---
 drivers/usb/serial/whiteheat.h |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -636,6 +636,7 @@ static void firm_setup_port(struct tty_s
 	struct device *dev = &port->dev;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
+	speed_t baud;
 
 	port_settings.port = port->port_number + 1;
 
@@ -696,11 +697,13 @@ static void firm_setup_port(struct tty_s
 	dev_dbg(dev, "%s - XON = %2x, XOFF = %2x\n", __func__, port_settings.xon, port_settings.xoff);
 
 	/* get the baud rate wanted */
-	port_settings.baud = tty_get_baud_rate(tty);
-	dev_dbg(dev, "%s - baud rate = %d\n", __func__, port_settings.baud);
+	baud = tty_get_baud_rate(tty);
+	port_settings.baud = cpu_to_le32(baud);
+	dev_dbg(dev, "%s - baud rate = %u\n", __func__, baud);
 
 	/* fixme: should set validated settings */
-	tty_encode_baud_rate(tty, port_settings.baud, port_settings.baud);
+	tty_encode_baud_rate(tty, baud, baud);
+
 	/* handle any settings that aren't specified in the tty structure */
 	port_settings.lloop = 0;
 
--- a/drivers/usb/serial/whiteheat.h
+++ b/drivers/usb/serial/whiteheat.h
@@ -87,7 +87,7 @@ struct whiteheat_simple {
 
 struct whiteheat_port_settings {
 	__u8	port;		/* port number (1 to N) */
-	__u32	baud;		/* any value 7 - 460800, firmware calculates
+	__le32	baud;		/* any value 7 - 460800, firmware calculates
 				   best fit; arrives little endian */
 	__u8	bits;		/* 5, 6, 7, or 8 */
 	__u8	stop;		/* 1 or 2, default 1 (2 = 1.5 if bits = 5) */


