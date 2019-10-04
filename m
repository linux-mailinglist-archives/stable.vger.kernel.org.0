Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A51ECBC8D
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388774AbfJDOCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 10:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388625AbfJDOCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 10:02:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64D220700;
        Fri,  4 Oct 2019 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570197723;
        bh=ZaIkPrNk07fsVmFtrC24SJjSXoemjdTrtsEGw//LBP0=;
        h=Subject:To:From:Date:From;
        b=xHD0PDUqWPb7210kt+pBBEHVAk1r0j6AT4Z3jeNgtryqWhEAal9D/Bi1Spv4lSpKN
         WiP1Sv8Ue2YCEBndIR9cqqTam42+an4aGd521In/JT2n4qkYdlX6LZ3uaUtT78+6rf
         VP4FDA684OnhxMUgKna4KBZpwL5jQ1RiC2qgUnuI=
Subject: patch "USB: serial: keyspan: fix NULL-derefs on open() and write()" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 16:01:51 +0200
Message-ID: <1570197711100241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: keyspan: fix NULL-derefs on open() and write()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7d7e21fafdbc7fcf0854b877bd0975b487ed2717 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 3 Oct 2019 15:49:58 +0200
Subject: USB: serial: keyspan: fix NULL-derefs on open() and write()

Fix NULL-pointer dereferences on open() and write() which can be
triggered by a malicious USB device.

The current URB allocation helper would fail to initialise the newly
allocated URB if the device has unexpected endpoint descriptors,
something which could lead NULL-pointer dereferences in a number of
open() and write() paths when accessing the URB. For example:

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:usb_clear_halt+0x11/0xc0
	...
	Call Trace:
	 ? tty_port_open+0x4d/0xd0
	 keyspan_open+0x70/0x160 [keyspan]
	 serial_port_activate+0x5b/0x80 [usbserial]
	 tty_port_open+0x7b/0xd0
	 ? check_tty_count+0x43/0xa0
	 tty_open+0xf1/0x490

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:keyspan_write+0x14e/0x1f3 [keyspan]
	...
	Call Trace:
	 serial_write+0x43/0xa0 [usbserial]
	 n_tty_write+0x1af/0x4f0
	 ? do_wait_intr_irq+0x80/0x80
	 ? process_echoes+0x60/0x60
	 tty_write+0x13f/0x2f0

	BUG: kernel NULL pointer dereference, address: 0000000000000000
	...
	RIP: 0010:keyspan_usa26_send_setup+0x298/0x305 [keyspan]
	...
	Call Trace:
	 keyspan_open+0x10f/0x160 [keyspan]
	 serial_port_activate+0x5b/0x80 [usbserial]
	 tty_port_open+0x7b/0xd0
	 ? check_tty_count+0x43/0xa0
	 tty_open+0xf1/0x490

Fixes: fdcba53e2d58 ("fix for bugzilla #7544 (keyspan USB-to-serial converter)")
Cc: stable <stable@vger.kernel.org>	# 2.6.21
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/keyspan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index d34779fe4a8d..e66a59ef43a1 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1741,8 +1741,8 @@ static struct urb *keyspan_setup_urb(struct usb_serial *serial, int endpoint,
 
 	ep_desc = find_ep(serial, endpoint);
 	if (!ep_desc) {
-		/* leak the urb, something's wrong and the callers don't care */
-		return urb;
+		usb_free_urb(urb);
+		return NULL;
 	}
 	if (usb_endpoint_xfer_int(ep_desc)) {
 		ep_type_name = "INT";
-- 
2.23.0


