Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99ACE98D6
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 10:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfJ3JHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 05:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3JHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 05:07:30 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A23AC2083E;
        Wed, 30 Oct 2019 09:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572426448;
        bh=srbrmF0lTcygFSXUVGgE4s5lrWuXkZwrxB7yQoZ5y8U=;
        h=Subject:To:From:Date:From;
        b=d1SAgjCSOCPspb+J5SruIuM474uEOMD6cbWRfyEyBzSTnS1GRE24x/XV0FG6wz09r
         YBxYq1oVD3Vqbn8yyFlC6sX7xlnyu1WOVKFTlLNEEUxm/lqukpB2ITctdlBUE8UcBj
         bGJ4Ge/H8u8sZSXL6EnldTmYp0LLxFX6v7NvbL2c=
Subject: patch "USB: serial: whiteheat: fix line-speed endianness" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Oct 2019 10:07:17 +0100
Message-ID: <157242643715712@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: whiteheat: fix line-speed endianness

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 84968291d7924261c6a0624b9a72f952398e258b Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Tue, 29 Oct 2019 11:23:54 +0100
Subject: USB: serial: whiteheat: fix line-speed endianness

Add missing endianness conversion when setting the line speed so that
this driver might work also on big-endian machines.

Also use an unsigned format specifier in the corresponding debug
message.

Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191029102354.2733-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/whiteheat.c | 9 ++++++---
 drivers/usb/serial/whiteheat.h | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 76cabcb30d21..ca3bd58f2025 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -636,6 +636,7 @@ static void firm_setup_port(struct tty_struct *tty)
 	struct device *dev = &port->dev;
 	struct whiteheat_port_settings port_settings;
 	unsigned int cflag = tty->termios.c_cflag;
+	speed_t baud;
 
 	port_settings.port = port->port_number + 1;
 
@@ -696,11 +697,13 @@ static void firm_setup_port(struct tty_struct *tty)
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
 
diff --git a/drivers/usb/serial/whiteheat.h b/drivers/usb/serial/whiteheat.h
index 00398149cd8d..269e727a92f9 100644
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
-- 
2.23.0


