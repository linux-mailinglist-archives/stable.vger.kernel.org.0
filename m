Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0620B2E3823
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgL1NF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:05:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgL1NF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:05:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E721F22A84;
        Mon, 28 Dec 2020 13:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160716;
        bh=r9xCeAMs5iAVd1Tko00oM32AUvZdGbhJW/nO/a7uMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQlswl1pstoINSAHI67Ft712cJybMqQqRPr4oxIm4YkB43rD9i9jpK2rN9NGixY/O
         chLORpgEjEL1t7GpJrR8t0/9v03HhrGdEnvCS+uPWtkUOqvf52DeV5Sr323v+DXGce
         rUecUDrB419bVSSBIBSZ1ZPbV3alJOD+pWIN9rWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 146/175] USB: serial: keyspan_pda: fix write deadlock
Date:   Mon, 28 Dec 2020 13:49:59 +0100
Message-Id: <20201228124900.327629405@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 7353cad7ee4deaefc16e94727e69285563e219f6 upstream.

The write() callback can be called in interrupt context (e.g. when used
as a console) so interrupts must be disabled while holding the port lock
to prevent a possible deadlock.

Fixes: e81ee637e4ae ("usb-serial: possible irq lock inversion (PPP vs. usb/serial)")
Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -447,6 +447,7 @@ static int keyspan_pda_write(struct tty_
 	int request_unthrottle = 0;
 	int rc = 0;
 	struct keyspan_pda_private *priv;
+	unsigned long flags;
 
 	priv = usb_get_serial_port_data(port);
 	/* guess how much room is left in the device's ring buffer, and if we
@@ -466,13 +467,13 @@ static int keyspan_pda_write(struct tty_
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


