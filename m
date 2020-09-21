Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B7D271C5E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 09:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgIUHzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 03:55:02 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40346 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgIUHzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 03:55:02 -0400
Received: by mail-lf1-f66.google.com with SMTP id m5so12936163lfp.7;
        Mon, 21 Sep 2020 00:55:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sgYf2rrS6Tdw6ckm4NYU0buOfZirWPWrDIDx4bQPYM8=;
        b=TsY10nNKVH56lG7qX7SEFYDpWvjqoINscE6NsFUB8byJHbSKqDXLLCljVSM9KJKawe
         TB/8nK2pGErKm604my0gaktQYRCTl5x253TliRJBNyFBNqrER3McOZTQxv8Ba7fn9/3k
         SPIyTmeIHgAn52nKtLnHEvWPdDgMwrNxYTUlxAMhLvPqJ8XU+LNF6fYSfsbMFu+As7iq
         GU/dG95hAgDfU3nM2fmb5tW7Bip8vexLQ16iG6fjFKmFWcW4bgGLXZAlTOvB2h48ARH1
         y7LAZ+YaT/3e77gETPK3FHb1VUEDSmBsKpWaXjJN6i8h4HlIPNJ3N0sT2r1NwFqeYk2X
         67tw==
X-Gm-Message-State: AOAM531nHsOzUdC5N+OUjLBBCOzYGPBT1kwo6f42ndneY/hqFChq9b89
        gCWX+OrXuRLkt/lC/3s0sPw=
X-Google-Smtp-Source: ABdhPJyYRRo3u8kdi68BC9dlGbtAlb1AuusVjD0jn1U5mgOBNfmvb1DukTvdByCUlaiJJMEQXVGvgQ==
X-Received: by 2002:a19:89d7:: with SMTP id l206mr16709423lfd.110.1600674900336;
        Mon, 21 Sep 2020 00:55:00 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id r7sm2358142lfn.84.2020.09.21.00.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 00:54:59 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kKGey-0008TD-0Z; Mon, 21 Sep 2020 09:54:52 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] USB: cdc-acm: add Whistler radio scanners TRX series support
Date:   Mon, 21 Sep 2020 09:51:01 +0200
Message-Id: <20200921075101.32426-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add support for Whistler radio scanners TRX series, which have a union
descriptor that designates a mass-storage interface as master. Handle
that by generalising the NO_DATA_INTERFACE quirk to allow us to fall
back to using the combined-interface detection.

Note that the NO_DATA_INTERFACE quirk was added by commit fd5054c169d2
("USB: cdc_acm: Fix oops when Droids MuIn LCD is connected") to handle a
combined-interface-type device with a broken call-management descriptor
by hardcoding the "data" interface number.

Link: https://lore.kernel.org/r/5f4ca4f8.1c69fb81.a4487.0f5f@mx.google.com
Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7f6f3ab5b8a6..816bb4859bfd 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1220,27 +1220,26 @@ static int acm_probe(struct usb_interface *intf,
 	if (cmgmd)
 		call_intf_num = cmgmd->bDataInterface;
 
-	if (!union_header) {
-		if (call_intf_num > 0) {
+	combined_interfaces = (quirks & NO_DATA_INTERFACE) != 0;
+
+	if (!union_header || combined_interfaces) {
+		if (call_intf_num > 0 && !combined_interfaces) {
 			dev_dbg(&intf->dev, "No union descriptor, using call management descriptor\n");
-			/* quirks for Droids MuIn LCD */
-			if (quirks & NO_DATA_INTERFACE) {
-				data_interface = usb_ifnum_to_if(usb_dev, 0);
-			} else {
-				data_intf_num = call_intf_num;
-				data_interface = usb_ifnum_to_if(usb_dev, data_intf_num);
-			}
+			data_intf_num = call_intf_num;
+			data_interface = usb_ifnum_to_if(usb_dev, data_intf_num);
 			control_interface = intf;
 		} else {
 			if (intf->cur_altsetting->desc.bNumEndpoints != 3) {
 				dev_dbg(&intf->dev,"No union descriptor, giving up\n");
 				return -ENODEV;
-			} else {
+			}
+
+			if (!combined_interfaces) {
 				dev_warn(&intf->dev,"No union descriptor, testing for castrated device\n");
 				combined_interfaces = 1;
-				control_interface = data_interface = intf;
-				goto look_for_collapsed_interface;
 			}
+			control_interface = data_interface = intf;
+			goto look_for_collapsed_interface;
 		}
 	} else {
 		data_intf_num = union_header->bSlaveInterface0;
@@ -1807,6 +1806,19 @@ static const struct usb_device_id acm_ids[] = {
 	.driver_info = CLEAR_HALT_CONDITIONS,
 	},
 
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0010, USB_CDC_SUBCLASS_ACM),	/* Whistler TRX-1 */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0011, USB_CDC_SUBCLASS_ACM),	/* Whistler TRX-2 */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0012, USB_CDC_SUBCLASS_ACM),	/* Whistler TRX-1e */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0013, USB_CDC_SUBCLASS_ACM),	/* Whistler TRX-2e */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+
 	/* Nokia S60 phones expose two ACM channels. The first is
 	 * a modem and is picked up by the standard AT-command
 	 * information below. The second is 'vendor-specific' but
-- 
2.26.2

