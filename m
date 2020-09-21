Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031B0271D90
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 10:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIUIKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 04:10:40 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33157 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgIUIKk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 04:10:40 -0400
Received: by mail-lj1-f196.google.com with SMTP id k25so10315194ljk.0;
        Mon, 21 Sep 2020 01:10:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3CygNsSFlMGDX1HL+h8SA3ZRH/CYeOtIvEndgu4lcOE=;
        b=BnMMGWqBpCCEyapNF1FNaZAhHicTlyAPiptyiALUporaDf1WRh0626Zj40Kw37wA33
         BLn+QqrdFQdXbp6iAqAxR9xpZwSUMn+Lu2nMIkDlgYCEpyDAMtgrPjwalFRDKzBfdzqM
         HKYnCGwVgTtENXx0C1OwoiI82mhuWgwBDwoTj9qVrYvsEX/wP3kMJ9lGb1eB20mgPXDs
         8u58xtujOzqI7Lw4W5kaNghY/HKqSX1i3z+rVNr9nSj0tZEDVZZZX8Sq18mgEgZ3RRNC
         ptMhA+glrnWoeNkQ+OoMAkPsydxjZlYtNj0HAG0Kwngk5Llf85Vo6o9ssdc5Ws/DVkTA
         8CKQ==
X-Gm-Message-State: AOAM532z1fqEUmphydiim5cYylg0045aCUDQ0IlRhy6pZ3Ppw1TFO3YU
        pFlijqqLicT/FCn5TO/UfvTUuq766sE=
X-Google-Smtp-Source: ABdhPJy2nZ8stJfmxtCGJocu5kQtqf0i1K9xKBwSrFnkaqc6ebmKo0U/BY7ehT3Y3G4MA1N9bKbLkg==
X-Received: by 2002:a2e:8e61:: with SMTP id t1mr16631851ljk.175.1600675838192;
        Mon, 21 Sep 2020 01:10:38 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id t2sm2375790lff.157.2020.09.21.01.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 01:10:37 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kKGu5-0001ni-Ta; Mon, 21 Sep 2020 10:10:30 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] USB: cdc-acm: add Whistler radio scanners TRX series support
Date:   Mon, 21 Sep 2020 10:10:22 +0200
Message-Id: <20200921081022.6881-1-johan@kernel.org>
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

v2
 - use the right class define in the device-id table (not subclass with
   same value)


 drivers/usb/class/cdc-acm.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 7f6f3ab5b8a6..316203bab0b8 100644
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
 
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0010, USB_CLASS_COMM),	/* Whistler TRX-1 */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0011, USB_CLASS_COMM),	/* Whistler TRX-2 */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0012, USB_CLASS_COMM),	/* Whistler TRX-1e */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+	{ USB_DEVICE_INTERFACE_CLASS(0x2a59, 0x0013, USB_CLASS_COMM),	/* Whistler TRX-2e */
+	  .driver_info = NO_DATA_INTERFACE,
+	},
+
 	/* Nokia S60 phones expose two ACM channels. The first is
 	 * a modem and is picked up by the standard AT-command
 	 * information below. The second is 'vendor-specific' but
-- 
2.26.2

