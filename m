Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0C1B6844
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgDWXNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:13:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49944 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728472AbgDWXGu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:50 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvY-0004lg-K2; Fri, 24 Apr 2020 00:06:40 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvX-00E6xe-RA; Fri, 24 Apr 2020 00:06:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:07:04 +0100
Message-ID: <lsq.1587683028.421274354@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 197/245] USB: serial: quatech2: handle unbound ports
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 9715a43eea77e42678a1002623f2d9a78f5b81a1 upstream.

Check for NULL port data in the modem- and line-status handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe).

Note that the other (stubbed) event handlers qt2_process_xmit_empty()
and qt2_process_flush() would need similar sanity checks in case they
are ever implemented.

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/quatech2.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -872,7 +872,10 @@ static void qt2_update_msr(struct usb_se
 	u8 newMSR = (u8) *ch;
 	unsigned long flags;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	spin_lock_irqsave(&port_priv->lock, flags);
 	port_priv->shadowMSR = newMSR;
@@ -900,7 +903,10 @@ static void qt2_update_lsr(struct usb_se
 	unsigned long flags;
 	u8 newLSR = (u8) *ch;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	if (newLSR & UART_LSR_BI)
 		newLSR &= (u8) (UART_LSR_OE | UART_LSR_BI);

