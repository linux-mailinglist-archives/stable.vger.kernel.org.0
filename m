Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15169141108
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAQSoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgAQSoF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:44:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4793E2082F;
        Fri, 17 Jan 2020 18:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286644;
        bh=0wdzweX2KYCqeQzZ3jMo4HOhY6oDIAh7VxhXsrQoNy8=;
        h=Subject:To:From:Date:From;
        b=CwdoblTU0Nxg+Rb8zlzmbHZfu5pKYEnXam4LFsP+wxPPtllcWHQ+SRGFuJ6LRWhHe
         ZaBmIg+zMCwljL97k1y53iOGtwLiXkvd7ys1bUaq1dcVXZn/CnJpFLpG3e2PCAkOe/
         jdlQLaCZMnXnBos0j8YxeNe/ds2ihq/SbARAyTDk=
Subject: patch "USB: serial: quatech2: handle unbound ports" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:41 +0100
Message-ID: <1579286621113140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: quatech2: handle unbound ports

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9715a43eea77e42678a1002623f2d9a78f5b81a1 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 15:35:26 +0100
Subject: USB: serial: quatech2: handle unbound ports

Check for NULL port data in the modem- and line-status handlers to avoid
dereferencing a NULL pointer in the unlikely case where a port device
isn't bound to a driver (e.g. after an allocation failure on port
probe).

Note that the other (stubbed) event handlers qt2_process_xmit_empty()
and qt2_process_flush() would need similar sanity checks in case they
are ever implemented.

Fixes: f7a33e608d9a ("USB: serial: add quatech2 usb to serial driver")
Cc: stable <stable@vger.kernel.org>     # 3.5
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/quatech2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index a62981ca7a73..f93b81a297d6 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -841,7 +841,10 @@ static void qt2_update_msr(struct usb_serial_port *port, unsigned char *ch)
 	u8 newMSR = (u8) *ch;
 	unsigned long flags;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	spin_lock_irqsave(&port_priv->lock, flags);
 	port_priv->shadowMSR = newMSR;
@@ -869,7 +872,10 @@ static void qt2_update_lsr(struct usb_serial_port *port, unsigned char *ch)
 	unsigned long flags;
 	u8 newLSR = (u8) *ch;
 
+	/* May be called from qt2_process_read_urb() for an unbound port. */
 	port_priv = usb_get_serial_port_data(port);
+	if (!port_priv)
+		return;
 
 	if (newLSR & UART_LSR_BI)
 		newLSR &= (u8) (UART_LSR_OE | UART_LSR_BI);
-- 
2.25.0


