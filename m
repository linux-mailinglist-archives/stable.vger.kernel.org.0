Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AAA141104
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgAQSnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:43:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgAQSnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:43:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4E0C2083E;
        Fri, 17 Jan 2020 18:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286630;
        bh=uIUGsXFD967/x2iqBrwAu3vFwlp/5XlL5m40TuGYSa0=;
        h=Subject:To:From:Date:From;
        b=i1gBmINva/Vm4uh5/uVQYdCcAgg0xw043N7liPrV816tYF3jT0qg2EArO4oY0V7Bs
         xpKyiWg5/PUlr/A3c4RrhNAtfMemUSEnz+B/zhiJHQMSFBF4ubjaIgfNFdWsizb3rT
         x0rxFQdgsbZytW/Z0cqRXmGLolsbrd+OkJbJQVew=
Subject: patch "USB: serial: ch341: handle unbound port at reset_resume" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:39 +0100
Message-ID: <1579286619208197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ch341: handle unbound port at reset_resume

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4d5ef53f75c22d28f490bcc5c771fcc610a9afa4 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 17 Jan 2020 10:50:22 +0100
Subject: USB: serial: ch341: handle unbound port at reset_resume

Check for NULL port data in reset_resume() to avoid dereferencing a NULL
pointer in case the port device isn't bound to a driver (e.g. after a
failed control request at port probe).

Fixes: 1ded7ea47b88 ("USB: ch341 serial: fix port number changed after resume")
Cc: stable <stable@vger.kernel.org>     # 2.6.30
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ch341.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index df582fe855f0..d3f420f3a083 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -642,9 +642,13 @@ static int ch341_tiocmget(struct tty_struct *tty)
 static int ch341_reset_resume(struct usb_serial *serial)
 {
 	struct usb_serial_port *port = serial->port[0];
-	struct ch341_private *priv = usb_get_serial_port_data(port);
+	struct ch341_private *priv;
 	int ret;
 
+	priv = usb_get_serial_port_data(port);
+	if (!priv)
+		return 0;
+
 	/* reconfigure ch341 serial port after bus-reset */
 	ch341_configure(serial->dev, priv);
 
-- 
2.25.0


