Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011DB2AA60B
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 15:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgKGO4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 09:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:32894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKGO4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 09:56:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD9AB20702;
        Sat,  7 Nov 2020 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604760978;
        bh=Wx6YNjVA49p8fmvTkIpe+4fFXnYd7gJMMzc4gNqyS/Q=;
        h=Subject:To:From:Date:From;
        b=w4ZL5AYTTFbcAGbbFK6m6vVllXxheCHkT5kJRGToEfXF18sjvV7GEHnsk80HvHID/
         +WtD5w9qxWREHJvwoPgbbSVFg2+fW+HYtgCFCUPG1bLUkQS7cZlWixo83poFowuRmx
         XRwqCLKR0XDCgYJOTEUgm6v/w/cO0B05nTHfjNuc=
Subject: patch "USB: serial: cyberjack: fix write-URB completion race" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 07 Nov 2020 15:56:54 +0100
Message-ID: <1604761014154245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: cyberjack: fix write-URB completion race

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 985616f0457d9f555fff417d0da56174f70cc14f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 26 Oct 2020 09:25:48 +0100
Subject: USB: serial: cyberjack: fix write-URB completion race

The write-URB busy flag was being cleared before the completion handler
was done with the URB, something which could lead to corrupt transfers
due to a racing write request if the URB is resubmitted.

Fixes: 507ca9bc0476 ("[PATCH] USB: add ability for usb-serial drivers to determine if their write urb is currently being used.")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/cyberjack.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/cyberjack.c b/drivers/usb/serial/cyberjack.c
index 821970609695..2e40908963da 100644
--- a/drivers/usb/serial/cyberjack.c
+++ b/drivers/usb/serial/cyberjack.c
@@ -357,11 +357,12 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 	struct device *dev = &port->dev;
 	int status = urb->status;
 	unsigned long flags;
+	bool resubmitted = false;
 
-	set_bit(0, &port->write_urbs_free);
 	if (status) {
 		dev_dbg(dev, "%s - nonzero write bulk status received: %d\n",
 			__func__, status);
+		set_bit(0, &port->write_urbs_free);
 		return;
 	}
 
@@ -394,6 +395,8 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 			goto exit;
 		}
 
+		resubmitted = true;
+
 		dev_dbg(dev, "%s - priv->wrsent=%d\n", __func__, priv->wrsent);
 		dev_dbg(dev, "%s - priv->wrfilled=%d\n", __func__, priv->wrfilled);
 
@@ -410,6 +413,8 @@ static void cyberjack_write_bulk_callback(struct urb *urb)
 
 exit:
 	spin_unlock_irqrestore(&priv->lock, flags);
+	if (!resubmitted)
+		set_bit(0, &port->write_urbs_free);
 	usb_serial_port_softint(port);
 }
 
-- 
2.29.2


