Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449EA14A09C
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 10:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbgA0JWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 04:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:40192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA0JWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 04:22:19 -0500
Received: from localhost (unknown [84.241.194.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BF4821569;
        Mon, 27 Jan 2020 09:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580116938;
        bh=lJ54nY6zGmCv2gCghZxwcgcFPHpRF0uwwQRCYPaluyU=;
        h=Subject:To:From:Date:From;
        b=Bul0GFeleRqLlEhglSqAXQ+vnH7Tb68sKgFkmERHNoQaqkFhFeG8lP4IMEz9Ydr0C
         y0xD5gHfG057ukLBcdF39EdfrSw9ROy3HNaZLd7UyD4+ka9WLf5NowjSWjC6qJvM7C
         g+E7C5im1eST+Jzbg4rP7wDXx7OwTM2FAIVCcQDE=
Subject: patch "USB: serial: ir-usb: fix link-speed handling" added to usb-testing
To:     johan@kernel.org, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jan 2020 10:22:10 +0100
Message-ID: <158011693086110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: ir-usb: fix link-speed handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 17a0184ca17e288decdca8b2841531e34d49285f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 22 Jan 2020 11:15:27 +0100
Subject: USB: serial: ir-usb: fix link-speed handling

Commit e0d795e4f36c ("usb: irda: cleanup on ir-usb module") added a USB
IrDA header with common defines, but mistakingly switched to using the
class-descriptor baud-rate bitmask values for the outbound header.

This broke link-speed handling for rates above 9600 baud, but a device
would also be able to operate at the default 9600 baud until a
link-speed request was issued (e.g. using the TCGETS ioctl).

Fixes: e0d795e4f36c ("usb: irda: cleanup on ir-usb module")
Cc: stable <stable@vger.kernel.org>     # 2.6.27
Cc: Felipe Balbi <balbi@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ir-usb.c | 20 ++++++++++----------
 include/linux/usb/irda.h    | 13 ++++++++++++-
 2 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index c3b06fc5a7f0..26eab1307165 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -335,34 +335,34 @@ static void ir_set_termios(struct tty_struct *tty,
 
 	switch (baud) {
 	case 2400:
-		ir_baud = USB_IRDA_BR_2400;
+		ir_baud = USB_IRDA_LS_2400;
 		break;
 	case 9600:
-		ir_baud = USB_IRDA_BR_9600;
+		ir_baud = USB_IRDA_LS_9600;
 		break;
 	case 19200:
-		ir_baud = USB_IRDA_BR_19200;
+		ir_baud = USB_IRDA_LS_19200;
 		break;
 	case 38400:
-		ir_baud = USB_IRDA_BR_38400;
+		ir_baud = USB_IRDA_LS_38400;
 		break;
 	case 57600:
-		ir_baud = USB_IRDA_BR_57600;
+		ir_baud = USB_IRDA_LS_57600;
 		break;
 	case 115200:
-		ir_baud = USB_IRDA_BR_115200;
+		ir_baud = USB_IRDA_LS_115200;
 		break;
 	case 576000:
-		ir_baud = USB_IRDA_BR_576000;
+		ir_baud = USB_IRDA_LS_576000;
 		break;
 	case 1152000:
-		ir_baud = USB_IRDA_BR_1152000;
+		ir_baud = USB_IRDA_LS_1152000;
 		break;
 	case 4000000:
-		ir_baud = USB_IRDA_BR_4000000;
+		ir_baud = USB_IRDA_LS_4000000;
 		break;
 	default:
-		ir_baud = USB_IRDA_BR_9600;
+		ir_baud = USB_IRDA_LS_9600;
 		baud = 9600;
 	}
 
diff --git a/include/linux/usb/irda.h b/include/linux/usb/irda.h
index 396d2b043e64..556a801efce3 100644
--- a/include/linux/usb/irda.h
+++ b/include/linux/usb/irda.h
@@ -119,11 +119,22 @@ struct usb_irda_cs_descriptor {
  * 6 - 115200 bps
  * 7 - 576000 bps
  * 8 - 1.152 Mbps
- * 9 - 5 mbps
+ * 9 - 4 Mbps
  * 10..15 - Reserved
  */
 #define USB_IRDA_STATUS_LINK_SPEED	0x0f
 
+#define USB_IRDA_LS_NO_CHANGE		0
+#define USB_IRDA_LS_2400		1
+#define USB_IRDA_LS_9600		2
+#define USB_IRDA_LS_19200		3
+#define USB_IRDA_LS_38400		4
+#define USB_IRDA_LS_57600		5
+#define USB_IRDA_LS_115200		6
+#define USB_IRDA_LS_576000		7
+#define USB_IRDA_LS_1152000		8
+#define USB_IRDA_LS_4000000		9
+
 /* The following is a 4-bit value used only for
  * outbound header:
  *
-- 
2.25.0


