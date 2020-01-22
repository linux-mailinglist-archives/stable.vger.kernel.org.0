Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B667F145251
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 11:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgAVKPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 05:15:55 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37408 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbgAVKPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 05:15:53 -0500
Received: by mail-lf1-f65.google.com with SMTP id b15so4887733lfc.4;
        Wed, 22 Jan 2020 02:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gaD1PJgTIue46yFrsImoNhaoR4zNTqSz3mLICXSlQz0=;
        b=U8K971BtgMbnQVUBoPZcv5LmnS6MTRYTioHFO81mpxhbaT6guapoQRoAKZRatcOVGp
         pV0leffqLjAhtgirtMCeliIrl8+bh2tfHCE+9JASWMR3Zs6dVtLK2/d1lDP/mpeH8V1a
         DVN/wuioScOsMJnXiyGd4GVTQXn47vS/0KG9837hAKUf41Xj6DpArRsOYmQysu6Iaei0
         9dgvKKGlhzR0LacAkEE2K/wZg+ncVFM1oBCCDwVS2dOg8W48z6OYVmX32MdY5TQe94xD
         CjW1uKFBjpGv8ilEh91gnvPR5nNrWbBRr6wmVf03Jtfe4GbSfSka5yeHRqcZlrw62V4p
         nyzA==
X-Gm-Message-State: APjAAAVE4Fj7L9PWCBPshnFPfVNnz+u0mznfipWkl9GLVpY9H2Y7j3zz
        Q0VoFG4j9RMZuQ3IyxKhnBzvuC5r
X-Google-Smtp-Source: APXvYqyS6C8uDI8D+1BXprQMSyZVf4xfMwLPeBPqWEn8cIqZ3HfMWXQxisL/OUlbwliE5H/rN6oByQ==
X-Received: by 2002:ac2:54b5:: with SMTP id w21mr1382203lfk.175.1579688151438;
        Wed, 22 Jan 2020 02:15:51 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id 14sm6592612lfz.47.2020.01.22.02.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:15:50 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iuD34-0007bZ-A0; Wed, 22 Jan 2020 11:15:46 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 2/5] USB: serial: ir-usb: fix link-speed handling
Date:   Wed, 22 Jan 2020 11:15:27 +0100
Message-Id: <20200122101530.29176-3-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122101530.29176-1-johan@kernel.org>
References: <20200122101530.29176-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit e0d795e4f36c ("usb: irda: cleanup on ir-usb module") added a USB
IrDA header with common defines, but mistakingly switched to using the
class-descriptor baud-rate bitmask values for the outbound header.

This broke link-speed handling for rates above 9600 baud, but a device
would also be able to operate at the default 9600 baud until a
link-speed request was issued (e.g. using the TCGETS ioctl).

Fixes: e0d795e4f36c ("usb: irda: cleanup on ir-usb module")
Cc: stable <stable@vger.kernel.org>     # 2.6.27
Cc: Felipe Balbi <balbi@kernel.org>
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
2.24.1

