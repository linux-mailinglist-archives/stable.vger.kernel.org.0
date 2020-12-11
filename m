Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E661F2D78F6
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437776AbgLKPRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406591AbgLKPQz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:16:55 -0500
Subject: patch "USB: serial: keyspan_pda: fix write deadlock" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607699775;
        bh=1sUm0OOxoU8m4tAxSJKkn1bcFOPUIaZXelwJUAQiCDo=;
        h=To:From:Date:From;
        b=p7dvJYtDqzKSLK4/nMupKVrSARb7o9/Re/zhUgGy+ByfhUm5TUSKNmskO/IfQnNMP
         iQNig988lln8n7CZaUqQq4QlXEri9UCzRokRYfGAuaS/rnJWr+CRpYyShiT6wDfEKC
         JemNDm5h1jUwHHdzK8wzUNE8s3A0zKAGFEOQjcBM=
To:     johan@kernel.org, bigeasy@linutronix.de,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 16:17:17 +0100
Message-ID: <160769983747193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan_pda: fix write deadlock

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7353cad7ee4deaefc16e94727e69285563e219f6 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Sun, 25 Oct 2020 18:45:48 +0100
Subject: USB: serial: keyspan_pda: fix write deadlock

The write() callback can be called in interrupt context (e.g. when used
as a console) so interrupts must be disabled while holding the port lock
to prevent a possible deadlock.

Fixes: e81ee637e4ae ("usb-serial: possible irq lock inversion (PPP vs. usb/serial)")
Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan_pda.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 2d5ad579475a..17b60e5a9f1f 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -443,6 +443,7 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	int request_unthrottle = 0;
 	int rc = 0;
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
 
 	priv = usb_get_serial_port_data(port);
 	/* guess how much room is left in the device's ring buffer, and if we
@@ -462,13 +463,13 @@ static int keyspan_pda_write(struct tty_struct *tty,
 	   the TX urb is in-flight (wait until it completes)
 	   the device is full (wait until it says there is room)
 	*/
-	spin_lock_bh(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
 	if (!test_bit(0, &port->write_urbs_free) || priv->tx_throttled) {
-		spin_unlock_bh(&port->lock);
+		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
 	clear_bit(0, &port->write_urbs_free);
-	spin_unlock_bh(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
 
 	/* At this point the URB is in our control, nobody else can submit it
 	   again (the only sudden transition was the one from EINPROGRESS to
-- 
2.29.2


