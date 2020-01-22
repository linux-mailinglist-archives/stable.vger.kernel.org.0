Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EECE1451D4
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgAVJ4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729917AbgAVJb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:31:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DB2924673;
        Wed, 22 Jan 2020 09:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685517;
        bh=R/hivULf9Rlgt4d9DReGdimTvR8R5RyaCUHZRSIki54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0G120Txq1lHzTfW/MV7plo8V8/syT7wLX4FDvc0l7/fp/zTLkP/RzWfGM85MOxT7
         u1ds8suN1/g5X7zfts8TJE++9kcBdv5bfwecUgsDFyI7oCYzrEDRJwVcF8CYZOASrq
         3/DwXwPX+M2tkLkrkSheSBZgXZayaAWWp0/CoRLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 47/76] USB: serial: io_edgeport: add missing active-port sanity check
Date:   Wed, 22 Jan 2020 10:29:03 +0100
Message-Id: <20200122092757.670006568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1568c58d11a7c851bd09341aeefd6a1c308ac40d upstream.

The driver receives the active port number from the device, but never
made sure that the port number was valid. This could lead to a
NULL-pointer dereference or memory corruption in case a device sends
data for an invalid port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_edgeport.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1666,7 +1666,8 @@ static void edge_break(struct tty_struct
 static void process_rcvd_data(struct edgeport_serial *edge_serial,
 				unsigned char *buffer, __u16 bufferLength)
 {
-	struct device *dev = &edge_serial->serial->dev->dev;
+	struct usb_serial *serial = edge_serial->serial;
+	struct device *dev = &serial->dev->dev;
 	struct usb_serial_port *port;
 	struct edgeport_port *edge_port;
 	__u16 lastBufferLength;
@@ -1771,9 +1772,8 @@ static void process_rcvd_data(struct edg
 
 			/* spit this data back into the tty driver if this
 			   port is open */
-			if (rxLen) {
-				port = edge_serial->serial->port[
-							edge_serial->rxPort];
+			if (rxLen && edge_serial->rxPort < serial->num_ports) {
+				port = serial->port[edge_serial->rxPort];
 				edge_port = usb_get_serial_port_data(port);
 				if (edge_port->open) {
 					dev_dbg(dev, "%s - Sending %d bytes to TTY for port %d\n",
@@ -1783,8 +1783,8 @@ static void process_rcvd_data(struct edg
 							rxLen);
 					edge_port->port->icount.rx += rxLen;
 				}
-				buffer += rxLen;
 			}
+			buffer += rxLen;
 			break;
 
 		case EXPECT_HDR3:	/* Expect 3rd byte of status header */
@@ -1819,6 +1819,8 @@ static void process_rcvd_status(struct e
 	__u8 code = edge_serial->rxStatusCode;
 
 	/* switch the port pointer to the one being currently talked about */
+	if (edge_serial->rxPort >= edge_serial->serial->num_ports)
+		return;
 	port = edge_serial->serial->port[edge_serial->rxPort];
 	edge_port = usb_get_serial_port_data(port);
 	if (edge_port == NULL) {


