Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F55FDAFE
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 11:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKOKRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 05:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727183AbfKOKRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 05:17:39 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C3D2075E;
        Fri, 15 Nov 2019 10:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573813058;
        bh=Mk1HzJRqWNxffmAuc1mNi7QJcAy0ZSUG12SKH50FdM8=;
        h=Subject:To:From:Date:From;
        b=knvzkWbUkMgmb6j0qNjoiERM5+FxvfjenG08ELMUi2mxC55S/G+aJSLGp4YxSI8Bs
         dheqAWQ3w/6UCX3zxn3eiweOwrvhNtdbGZHOedWfCcHxyYCB2PAtDnnDGd2J14Q351
         xLWjzBogRZVS4IFGzKHC5oYJTU60BCRstGfFp4NE=
Subject: patch "USB: serial: mos7720: fix remote wakeup" added to usb-testing
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Nov 2019 18:17:32 +0800
Message-ID: <157381305223054@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: mos7720: fix remote wakeup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From ea422312a462696093b5db59d294439796cba4ad Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 7 Nov 2019 14:21:18 +0100
Subject: USB: serial: mos7720: fix remote wakeup

The driver was setting the device remote-wakeup feature during probe in
violation of the USB specification (which says it should only be set
just prior to suspending the device). This could potentially waste
power during suspend as well as lead to spurious wakeups.

Note that USB core would clear the remote-wakeup feature at first
resume.

Fixes: 0f64478cbc7a ("USB: add USB serial mos7720 driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.19
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7720.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 18110225d506..2ec4eeacebc7 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1833,10 +1833,6 @@ static int mos7720_startup(struct usb_serial *serial)
 	product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	dev = serial->dev;
 
-	/* setting configuration feature to one */
-	usb_control_msg(serial->dev, usb_sndctrlpipe(serial->dev, 0),
-			(__u8)0x03, 0x00, 0x01, 0x00, NULL, 0x00, 5000);
-
 	if (product == MOSCHIP_DEVICE_ID_7715) {
 		struct urb *urb = serial->port[0]->interrupt_in_urb;
 
-- 
2.24.0


