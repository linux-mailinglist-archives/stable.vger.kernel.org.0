Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6C09141102
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 19:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgAQSnq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 13:43:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgAQSnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jan 2020 13:43:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBC922083E;
        Fri, 17 Jan 2020 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579286625;
        bh=Eqh//VT3iMNo9nABUp/sLL5XmyL3OlCJ6qnl4cSi9mw=;
        h=Subject:To:From:Date:From;
        b=ZiVadN0SsItmKDJCRLWAkXSyj8Kh3BBHPhsSS6b2OKuLTHQoyh4fSkIgN4MyP9p77
         jnmvxjhBWGgnXgNZHDc11BhlvlKh6a7vlo19fQIUgAeaW1qNMQWF86y6jM0RT+Y5nx
         FK2GWDYEKoLMjxqmfdC7Aa0SM7FvrHlKQFmyWuB8=
Subject: patch "USB: serial: suppress driver bind attributes" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 Jan 2020 19:43:39 +0100
Message-ID: <15792866191535@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: suppress driver bind attributes

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fdb838efa31e1ed9a13ae6ad0b64e30fdbd00570 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 16 Jan 2020 17:07:05 +0100
Subject: USB: serial: suppress driver bind attributes

USB-serial drivers must not be unbound from their ports before the
corresponding USB driver is unbound from the parent interface so
suppress the bind and unbind attributes.

Unbinding a serial driver while it's port is open is a sure way to
trigger a crash as any driver state is released on unbind while port
hangup is handled on the parent USB interface level. Drivers for
multiport devices where ports share a resource such as an interrupt
endpoint also generally cannot handle individual ports going away.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/usb-serial.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 8f066bb55d7d..dc7a65b9ec98 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -1317,6 +1317,9 @@ static int usb_serial_register(struct usb_serial_driver *driver)
 		return -EINVAL;
 	}
 
+	/* Prevent individual ports from being unbound. */
+	driver->driver.suppress_bind_attrs = true;
+
 	usb_serial_operations_init(driver);
 
 	/* Add this device to our list of devices */
-- 
2.25.0


