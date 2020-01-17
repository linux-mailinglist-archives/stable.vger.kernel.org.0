Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B03FE141106
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgAQSn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:36038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQSn4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:43:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA4C02083E;
        Fri, 17 Jan 2020 18:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286635;
        bh=q+uypK3ArII+3jtWt9DN/+zlalokc5EDSjDlZzLFYmc=;
        h=Subject:To:From:Date:From;
        b=bh7YQqP6feNbl1KroFSMGXBuDtThBAWdA0o/oaXHUnrMSKdMVjO9vPklMlZ9M0VYe
         9KdXbIsswO/OF14wCREd/vH6hKXaVGbqJHMr0eLkpVy3iufBHSXYX8VGtdqwXXylNC
         cgTTo+cJY0t4HbvDhzeUPyUMxjuaSj0ZXn2bH4qA=
Subject: patch "USB: serial: io_edgeport: add missing active-port sanity check" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:40 +0100
Message-ID: <15792866201842@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: io_edgeport: add missing active-port sanity check

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1568c58d11a7c851bd09341aeefd6a1c308ac40d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:24 +0100
Subject: USB: serial: io_edgeport: add missing active-port sanity check

The driver receives the active port number from the device, but never
made sure that the port number was valid. This could lead to a
NULL-pointer dereference or memory corruption in case a device sends
data for an invalid port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 0582d78bdb1d..5737add6a2a4 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1725,7 +1725,8 @@ static void edge_break(struct tty_struct *tty, int break_state)
 static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				unsigned char *buffer, __u16 bufferLength)
 {
-	struct device *dev = &edge_serial->serial->dev->dev;
+	struct usb_serial *serial = edge_serial->serial;
+	struct device *dev = &serial->dev->dev;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
 	__u16 lastBufferLength;
@@ -1821,9 +1822,8 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 
 			/* spit this data back into the tty driver if this
 			   port is open */
-			if (rxLen) {
-				port = edge_serial->serial->port[
-							edge_serial->rxPort];
+			if (rxLen && edge_serial->rxPort < serial->num_ports) {
+				port = serial->port[edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
 				if (edge_port && edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
@@ -1833,8 +1833,8 @@ static void process_rcvd_data(struct edgeport_serial *edge_serial,
 							rxLen);
 					edge_port->port->icount.rx += rxLen;
 				}
-				buffer += rxLen;
 			}
+			buffer += rxLen;
 			break;
 
 		case EXPECT_HDR3:	/* Expect 3rd byte of status header */
@@ -1869,6 +1869,8 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 	__u8 code = edge_serial->rxStatusCode;
 
 	/* switch the port pointer to the one being currently talked about */
+	if (edge_serial->rxPort >= edge_serial->serial->num_ports)
+		return;
 	port = edge_serial->serial->port[edge_serial->rxPort];
 	edge_port = usb_get_serial_port_data(port);
 	if (edge_port == NULL) {
-- 
2.25.0


