Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD1F122068
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbfLQAyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35300 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727047AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mz-3l; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005bk-19; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Tue, 17 Dec 2019 00:47:20 +0000
Message-ID: <lsq.1576543535.117821082@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 106/136] USB: serial: whiteheat: fix line-speed
 endianness
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 84968291d7924261c6a0624b9a72f952398e258b upstream.

Add missing endianness conversion when setting the line speed so that
this driver might work also on big-endian machines.

Also use an unsigned format specifier in the corresponding debug
message.

Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/whiteheat.c | 9 ++++++---
 drivers/usb/serial/whiteheat.h | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -681,6 +681,7 @@ static void firm_setup_port(struct tty_s
 	struct device *dev = &port->dev;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
+	speed_t baud;
 
 	port_settings.port = port->port_number + 1;
 
@@ -741,11 +742,13 @@ static void firm_setup_port(struct tty_s
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

