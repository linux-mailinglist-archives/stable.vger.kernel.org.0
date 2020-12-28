Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEC62E3BF8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406605AbgL1N4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:56:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406678AbgL1N4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:56:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0938820782;
        Mon, 28 Dec 2020 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163794;
        bh=HgdXahm1Zzqe7TN4Ff96NVdu2PDMzEhyVy3av+zvSio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA4YHMeJ9sBNkpsUy37HZaS9SsDmc76g7k94SYPpKp+dGSKSHdsFiaNgQgEAtscZn
         kO56yx4i7j/h81GlhzPENpAWnlOQRxMBRYH3ESsxhrf/BPSyH0K8boNWkXQ3JYv22D
         OetY0zXZOORDux+ajWUdX8OXS4yVWG1fUpUbgF78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 369/453] USB: serial: keyspan_pda: fix write-wakeup use-after-free
Date:   Mon, 28 Dec 2020 13:50:05 +0100
Message-Id: <20201228124954.967508343@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 37faf50615412947868c49aee62f68233307f4e4 upstream.

The driver's deferred write wakeup was never flushed on disconnect,
something which could lead to the driver port data being freed while the
wakeup work is still scheduled.

Fix this by using the usb-serial write wakeup which gets cancelled
properly on disconnect.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan_pda.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -43,8 +43,7 @@
 struct keyspan_pda_private {
 	int			tx_room;
 	int			tx_throttled;
-	struct work_struct			wakeup_work;
-	struct work_struct			unthrottle_work;
+	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 };
@@ -97,15 +96,6 @@ static const struct usb_device_id id_tab
 };
 #endif
 
-static void keyspan_pda_wakeup_write(struct work_struct *work)
-{
-	struct keyspan_pda_private *priv =
-		container_of(work, struct keyspan_pda_private, wakeup_work);
-	struct usb_serial_port *port = priv->port;
-
-	tty_port_tty_wakeup(&port->port);
-}
-
 static void keyspan_pda_request_unthrottle(struct work_struct *work)
 {
 	struct keyspan_pda_private *priv =
@@ -183,7 +173,7 @@ static void keyspan_pda_rx_interrupt(str
 		case 2: /* tx unthrottle interrupt */
 			priv->tx_throttled = 0;
 			/* queue up a wakeup at scheduler time */
-			schedule_work(&priv->wakeup_work);
+			usb_serial_port_softint(port);
 			break;
 		default:
 			break;
@@ -563,7 +553,7 @@ static void keyspan_pda_write_bulk_callb
 	priv = usb_get_serial_port_data(port);
 
 	/* queue up a wakeup at scheduler time */
-	schedule_work(&priv->wakeup_work);
+	usb_serial_port_softint(port);
 }
 
 
@@ -716,7 +706,6 @@ static int keyspan_pda_port_probe(struct
 	if (!priv)
 		return -ENOMEM;
 
-	INIT_WORK(&priv->wakeup_work, keyspan_pda_wakeup_write);
 	INIT_WORK(&priv->unthrottle_work, keyspan_pda_request_unthrottle);
 	priv->serial = port->serial;
 	priv->port = port;


