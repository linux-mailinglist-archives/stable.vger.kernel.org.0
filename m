Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22B21144F43
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731638AbgAVJgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731634AbgAVJgI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:36:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49CDF2467A;
        Wed, 22 Jan 2020 09:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685767;
        bh=tBqdpAMMkV29Q/s1tH+suMTJHE0eP4HIV/Cod+Jo7Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMbCjDV2mA7c2MDAYuMGHTYFfzsW157QEf6l9WuDyNY0tP9nTV7+pQ2YxQbFhNFsB
         P/aohSPnZ5kCXmvS5rsdLfXgdodna4Ngw94nIpzDhqAh+A30fBFgtOz1ZJuLjNPmE0
         u6f6em7dG/EzFMlRYbuZ1k3IZUNBbBI9MlNVQ/eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Ogness <john.ogness@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 71/97] USB: serial: io_edgeport: use irqsave() in USBs complete callback
Date:   Wed, 22 Jan 2020 10:29:15 +0100
Message-Id: <20200122092807.822542059@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
References: <20200122092755.678349497@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit dd1fae527612543e560e84f2eba4f6ef2006ac55 ]

The USB completion callback does not disable interrupts while acquiring
the lock. We want to remove the local_irq_disable() invocation from
__usb_hcd_giveback_urb() and therefore it is required for the callback
handler to disable the interrupts while acquiring the lock.
The callback may be invoked either in IRQ or BH context depending on the
USB host controller.
Use the _irqsave() variant of the locking primitives.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/io_edgeport.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 61671e277bb4..b9b56ec6ff24 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -572,6 +572,7 @@ static void edge_interrupt_callback(struct urb *urb)
 	struct usb_serial_port *port;
 	unsigned char *data = urb->transfer_buffer;
 	int length = urb->actual_length;
+	unsigned long flags;
 	int bytes_avail;
 	int position;
 	int txCredits;
@@ -603,7 +604,7 @@ static void edge_interrupt_callback(struct urb *urb)
 		if (length > 1) {
 			bytes_avail = data[0] | (data[1] << 8);
 			if (bytes_avail) {
-				spin_lock(&edge_serial->es_lock);
+				spin_lock_irqsave(&edge_serial->es_lock, flags);
 				edge_serial->rxBytesAvail += bytes_avail;
 				dev_dbg(dev,
 					"%s - bytes_avail=%d, rxBytesAvail=%d, read_in_progress=%d\n",
@@ -626,7 +627,8 @@ static void edge_interrupt_callback(struct urb *urb)
 						edge_serial->read_in_progress = false;
 					}
 				}
-				spin_unlock(&edge_serial->es_lock);
+				spin_unlock_irqrestore(&edge_serial->es_lock,
+						       flags);
 			}
 		}
 		/* grab the txcredits for the ports if available */
@@ -639,9 +641,11 @@ static void edge_interrupt_callback(struct urb *urb)
 				port = edge_serial->serial->port[portNumber];
 				edge_port = usb_get_serial_port_data(port);
 				if (edge_port->open) {
-					spin_lock(&edge_port->ep_lock);
+					spin_lock_irqsave(&edge_port->ep_lock,
+							  flags);
 					edge_port->txCredits += txCredits;
-					spin_unlock(&edge_port->ep_lock);
+					spin_unlock_irqrestore(&edge_port->ep_lock,
+							       flags);
 					dev_dbg(dev, "%s - txcredits for port%d = %d\n",
 						__func__, portNumber,
 						edge_port->txCredits);
@@ -682,6 +686,7 @@ static void edge_bulk_in_callback(struct urb *urb)
 	int			retval;
 	__u16			raw_data_length;
 	int status = urb->status;
+	unsigned long flags;
 
 	if (status) {
 		dev_dbg(&urb->dev->dev, "%s - nonzero read bulk status received: %d\n",
@@ -701,7 +706,7 @@ static void edge_bulk_in_callback(struct urb *urb)
 
 	usb_serial_debug_data(dev, __func__, raw_data_length, data);
 
-	spin_lock(&edge_serial->es_lock);
+	spin_lock_irqsave(&edge_serial->es_lock, flags);
 
 	/* decrement our rxBytes available by the number that we just got */
 	edge_serial->rxBytesAvail -= raw_data_length;
@@ -725,7 +730,7 @@ static void edge_bulk_in_callback(struct urb *urb)
 		edge_serial->read_in_progress = false;
 	}
 
-	spin_unlock(&edge_serial->es_lock);
+	spin_unlock_irqrestore(&edge_serial->es_lock, flags);
 }
 
 
-- 
2.20.1



