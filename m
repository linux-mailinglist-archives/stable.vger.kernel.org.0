Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF02CCD710
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfJFRvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbfJFRu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:50:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B8E521835;
        Sun,  6 Oct 2019 17:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383927;
        bh=2wb1uq+QHh0LuGSRjL9ECKM78xBue/wLBVnlI1ciBn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0SESXCO031fTDNSBiebgGzDXmCnXug+/tZCjQyDD57R6Bp5+KgKbP5Wh8njUzX7g
         41lUArrKNEVJtuE4PAAVpl09q/ozAX+4s935NDuHVXQNefDKBZBDmQe/Yk1xPa5QGl
         76OFvAXFstbbaa17RLztIvrq1pprKXl/Na7EdUGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 130/166] hso: fix NULL-deref on tty open
Date:   Sun,  6 Oct 2019 19:21:36 +0200
Message-Id: <20191006171224.182792306@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8353da9fa69722b54cba82b2ec740afd3d438748 ]

Fix NULL-pointer dereference on tty open due to a failure to handle a
missing interrupt-in endpoint when probing modem ports:

	BUG: kernel NULL pointer dereference, address: 0000000000000006
	...
	RIP: 0010:tiocmget_submit_urb+0x1c/0xe0 [hso]
	...
	Call Trace:
	hso_start_serial_device+0xdc/0x140 [hso]
	hso_serial_open+0x118/0x1b0 [hso]
	tty_open+0xf1/0x490

Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2620,14 +2620,18 @@ static struct hso_device *hso_create_bul
 		 */
 		if (serial->tiocmget) {
 			tiocmget = serial->tiocmget;
+			tiocmget->endp = hso_get_ep(interface,
+						    USB_ENDPOINT_XFER_INT,
+						    USB_DIR_IN);
+			if (!tiocmget->endp) {
+				dev_err(&interface->dev, "Failed to find INT IN ep\n");
+				goto exit;
+			}
+
 			tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
 			if (tiocmget->urb) {
 				mutex_init(&tiocmget->mutex);
 				init_waitqueue_head(&tiocmget->waitq);
-				tiocmget->endp = hso_get_ep(
-					interface,
-					USB_ENDPOINT_XFER_INT,
-					USB_DIR_IN);
 			} else
 				hso_free_tiomget(serial);
 		}


