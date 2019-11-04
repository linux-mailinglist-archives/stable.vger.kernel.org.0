Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66013EEFAC
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbfKDVzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387661AbfKDVzR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:17 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FD1F2053B;
        Mon,  4 Nov 2019 21:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904516;
        bh=DNPIpdozo26dNOXOnXgTOxy4GC8/wcGQjQLHdUo94HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jc/ewYQHrMZN30s1tXyX1NyiKR7Ld7XkzSsrApSWcrRH4sU7TAOzafbzwQwR9R1jh
         1o7gyfqNAcpASpky6/UelhuEJbFGmPGc1WrBqvm6RTBW+Q/9UEMQKnlVSH+/Q6Uner
         Bk0E0xgLVKMZPRLFFVdX+vNqde338D0PverH+j0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 73/95] USB: serial: whiteheat: fix line-speed endianness
Date:   Mon,  4 Nov 2019 22:45:11 +0100
Message-Id: <20191104212116.160620318@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
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
@@ -652,6 +652,7 @@ static void firm_setup_port(struct tty_s
 	struct device *dev = &port->dev;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
+	speed_t baud;
 
 	port_settings.port = port->port_number + 1;
 
@@ -712,11 +713,13 @@ static void firm_setup_port(struct tty_s
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
@@ -91,7 +91,7 @@ struct whiteheat_simple {
 
 struct whiteheat_port_settings {
 	__u8	port;		/* port number (1 to N) */
-	__u32	baud;		/* any value 7 - 460800, firmware calculates
+	__le32	baud;		/* any value 7 - 460800, firmware calculates
 				   best fit; arrives little endian */
 	__u8	bits;		/* 5, 6, 7, or 8 */
 	__u8	stop;		/* 1 or 2, default 1 (2 = 1.5 if bits = 5) */


