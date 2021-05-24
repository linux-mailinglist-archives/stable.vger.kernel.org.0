Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48F2F38E32F
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhEXJWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 05:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232396AbhEXJWX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 05:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 764E1610A5;
        Mon, 24 May 2021 09:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621848055;
        bh=C0KBuOweP0oMeWO7jZ/E760szJDDgstvTnUGvt0yHWA=;
        h=From:To:Cc:Subject:Date:From;
        b=Ya/vuiRdNbMFglqcGaSGWwrGgMJZeNO6vpJ65Gb+JpreHSSUHyOqwcZLqlmhh0oim
         TKIRJEJYIYzys7GksHNtNAtGIkk10BRx95UEEVUSUflDP3M/9na4i2w7V3KN0v/ccs
         nfDRcZgGCtWlh2CnVLioJpYEcMs6Zm6Ouk3LMcGOddtcw+Ggxj0U4Wnt6X2/nmEsXx
         d+OLb3geOo/SRTInTGBwgR9InvIbW5Sc2tz/U61+3X35Ty0a8Y2WLEbCsnI6NIaAle
         nWdBv7A50Vj56/k+ew+HAKB/ZRgPEFPokDLMgOiXs8bYpsDmBhyrn9wJc/0fdwAaP3
         1CgASWK1SXSnA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ll6lZ-0001AO-6Q; Mon, 24 May 2021 11:20:53 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] Input: usbtouchscreen - fix control-request directions
Date:   Mon, 24 May 2021 11:20:48 +0200
Message-Id: <20210524092048.4443-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the four control requests which erroneously used usb_rcvctrlpipe().

Fixes: 1d3e20236d7a ("[PATCH] USB: usbtouchscreen: unified USB touchscreen driver")
Fixes: 24ced062a296 ("usbtouchscreen: add support for DMC TSC-10/25 devices")
Fixes: 9e3b25837a20 ("Input: usbtouchscreen - add support for e2i touchscreen controller")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Changes in v2
 - include also the request in e2i_init which did not use USB_DIR_OUT

 drivers/input/touchscreen/usbtouchscreen.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index c847453a03c2..43c521f50c85 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -251,7 +251,7 @@ static int e2i_init(struct usbtouch_usb *usbtouch)
 	int ret;
 	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      0x01, 0x02, 0x0000, 0x0081,
 	                      NULL, 0, USB_CTRL_SET_TIMEOUT);
 
@@ -531,7 +531,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 	if (ret)
 		return ret;
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -543,7 +543,7 @@ static int mtouch_init(struct usbtouch_usb *usbtouch)
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -722,7 +722,7 @@ static int dmc_tsc10_init(struct usbtouch_usb *usbtouch)
 	}
 
 	/* start sending data */
-	ret = usb_control_msg(dev, usb_rcvctrlpipe (dev, 0),
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 	                      TSC10_CMD_DATA1,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      0, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
-- 
2.26.3

