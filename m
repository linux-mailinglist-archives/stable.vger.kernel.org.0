Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF1E1DB6AD
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgETO0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:26:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33018 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgETOW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:22:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbx-00037H-Pu; Wed, 20 May 2020 15:22:21 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPbw-007DTZ-4W; Wed, 20 May 2020 15:22:20 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Felipe Balbi" <balbi@kernel.org>
Date:   Wed, 20 May 2020 15:14:31 +0100
Message-ID: <lsq.1589984008.317348641@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 63/99] USB: serial: ir-usb: fix link-speed handling
In-Reply-To: <lsq.1589984008.673931885@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.84-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 17a0184ca17e288decdca8b2841531e34d49285f upstream.

Commit e0d795e4f36c ("usb: irda: cleanup on ir-usb module") added a USB
IrDA header with common defines, but mistakingly switched to using the
class-descriptor baud-rate bitmask values for the outbound header.

This broke link-speed handling for rates above 9600 baud, but a device
would also be able to operate at the default 9600 baud until a
link-speed request was issued (e.g. using the TCGETS ioctl).

Fixes: e0d795e4f36c ("usb: irda: cleanup on ir-usb module")
Cc: Felipe Balbi <balbi@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ir-usb.c | 20 ++++++++++----------
 include/linux/usb/irda.h    | 13 ++++++++++++-
 2 files changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -339,34 +339,34 @@ static void ir_set_termios(struct tty_st
 
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
 
--- a/include/linux/usb/irda.h
+++ b/include/linux/usb/irda.h
@@ -118,11 +118,22 @@ struct usb_irda_cs_descriptor {
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

