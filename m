Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3986150DC4
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730230AbgBCQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:46:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729500AbgBCQ2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:28:10 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F08A02080C;
        Mon,  3 Feb 2020 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747289;
        bh=OYhRKsrZdpXPoMn4YGg/2jHoYhmW/8OmBmtQ7ugCHHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtGvWVBOd0pFvPp1xu1VEIhc4zCdtKK8krN81rY1YcvoLoxU6q1TyKGd649KKfWZp
         aaT53mqfNFBFstJTKVucnIgNEh+uLK2ZHqcEWV+aW0Rrb96Bpnw+YFRRJ5tSKUyilR
         4Nr9n7Ht6pO6ukonmtXaO5FjbWhkqoGp3Iqw27QM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felipe Balbi <balbi@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 04/89] USB: serial: ir-usb: fix link-speed handling
Date:   Mon,  3 Feb 2020 16:18:49 +0000
Message-Id: <20200203161917.426212020@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 17a0184ca17e288decdca8b2841531e34d49285f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ir-usb.c |   20 ++++++++++----------
 include/linux/usb/irda.h    |   13 ++++++++++++-
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


