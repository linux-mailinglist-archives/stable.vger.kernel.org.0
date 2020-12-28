Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7412E66BB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393543AbgL1QPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387485AbgL1NSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FEB22B3B;
        Mon, 28 Dec 2020 13:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161460;
        bh=Pz2zIWjvEh3DiBLQ+yr1rEHHH9aNOv0BMrRb7EudNFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHBgJEHWhm3SksOdt09Y/QWd7YHtst+iWSIeM/LgdrEdaAJRdP1pkQbrt7JAAJHGy
         JjyLZgfsHh8mMtIVRnYgXDq07MT+117SkGK08QlXgk4vxdjKqP7Zq0wPXqqCaq95Zq
         iI7VcTJV3i7+mqrhuTG7pLcb4o4Z/zc/6ry6lORQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 203/242] USB: serial: keyspan_pda: fix write-wakeup use-after-free
Date:   Mon, 28 Dec 2020 13:50:08 +0100
Message-Id: <20201228124914.677696022@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
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
@@ -47,8 +47,7 @@
 struct keyspan_pda_private {
 	int			tx_room;
 	int			tx_throttled;
-	struct work_struct			wakeup_work;
-	struct work_struct			unthrottle_work;
+	struct work_struct	unthrottle_work;
 	struct usb_serial	*serial;
 	struct usb_serial_port	*port;
 };
@@ -101,15 +100,6 @@ static const struct usb_device_id id_tab
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
@@ -187,7 +177,7 @@ static void keyspan_pda_rx_interrupt(str
 		case 2: /* tx unthrottle interrupt */
 			priv->tx_throttled = 0;
 			/* queue up a wakeup at scheduler time */
-			schedule_work(&priv->wakeup_work);
+			usb_serial_port_softint(port);
 			break;
 		default:
 			break;
@@ -567,7 +557,7 @@ static void keyspan_pda_write_bulk_callb
 	priv = usb_get_serial_port_data(port);
 
 	/* queue up a wakeup at scheduler time */
-	schedule_work(&priv->wakeup_work);
+	usb_serial_port_softint(port);
 }
 
 
@@ -720,7 +710,6 @@ static int keyspan_pda_port_probe(struct
 	if (!priv)
 		return -ENOMEM;
 
-	INIT_WORK(&priv->wakeup_work, keyspan_pda_wakeup_write);
 	INIT_WORK(&priv->unthrottle_work, keyspan_pda_request_unthrottle);
 	priv->serial = port->serial;
 	priv->port = port;


