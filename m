Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBC11406ED
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 10:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgAQJvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 04:51:10 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35245 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgAQJvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 04:51:09 -0500
Received: by mail-lj1-f196.google.com with SMTP id j1so25790821lja.2;
        Fri, 17 Jan 2020 01:51:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lItgM4AuMa7NuLq3vvovEJzVKMKt6bwUYNd3Nm8lyCg=;
        b=lbULAYYnLgDLU0gVvJNO7JanSkg1M4PeMI8AloL29z/doYFLVkoitD79QJVh9OiZlC
         xeIwVDMwRgRWUB4SVcxHJ26ddt6t2VB78SUFjIPDEar2JeLhVpBNLRVj4NzokkJKWbjt
         lfVH9FUZ842ZptuKG79dGoqNsIAlUn5kRXt2QOI/7yRvUbT1l6SD6GjP7K5LSVaTzUH0
         NMgUkpPp3/eJPVgixJsUxco4kT7hjpPHeaNzQlOV9EZ1XuHFLlqsdbhEnd7V2jPOvqwa
         WNhdrROlHcJY1ZIJrfqJB6DllnFEMQCX6hXkoc4qr3bWygCEDTlZ3SiJl3fpaRJWctA0
         LfuA==
X-Gm-Message-State: APjAAAWeLgYNIzACMsJ3970rWrhrydSwVIEfaA0bB6oG/zOZrL7AvyoU
        Q6yG7LrOx0a8nYkc+4mijEGs2Xeb
X-Google-Smtp-Source: APXvYqw8i7Z0U5J3jxJDNmJmWEUyKXwPWelWP1Q3u/ZOlydygzFADALS9eLeipGW4YvsAJ8T4DaffQ==
X-Received: by 2002:a2e:7a07:: with SMTP id v7mr5276698ljc.271.1579254666628;
        Fri, 17 Jan 2020 01:51:06 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id s9sm14012695ljh.90.2020.01.17.01.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 01:51:04 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1isOHQ-0007DO-FJ; Fri, 17 Jan 2020 10:51:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 3/5] USB: serial: io_edgeport: add missing active-port sanity check
Date:   Fri, 17 Jan 2020 10:50:24 +0100
Message-Id: <20200117095026.27655-4-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117095026.27655-1-johan@kernel.org>
References: <20200117095026.27655-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver receives the active port number from the device, but never
made sure that the port number was valid. This could lead to a
NULL-pointer dereference or memory corruption in case a device sends
data for an invalid port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
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
2.24.1

