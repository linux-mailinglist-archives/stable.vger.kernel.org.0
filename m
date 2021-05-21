Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC138C7E9
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbhEUN1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:27:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235214AbhEUN1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A6A5613EB;
        Fri, 21 May 2021 13:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603536;
        bh=+v0/KSHe8/QCCcMSvhEpsTDVCUNBQhlWaeoDCNnhHVI=;
        h=From:To:Cc:Subject:Date:From;
        b=iDnAlD1kScLtyQhrAR2eIQjeIzWAoIc0Ma5K1rLOSXxSLOfo9ULPxTAsGsbu/H765
         PbfBj5eSV0eESxg2x1rl6wB5mJyBKCbc4BT7Fwy7RT+ok6zPWJeLPgrKHbI92zcdnv
         HfVm2U9GmppkWDUHRZ6m+YJ1q94QoebMICIrzT+ylbkuXidQ+Csyjj5IP2dQDZ9X7J
         NT2DuXilo3N9b6536gYOQA0rf7Vj1gDfWKQvTmd/Zp3k0DqpqBfRHFovAUR1T1UXvc
         iaQUE3vblNp2w7zWkmNKZBXYd1KKUEp0p/BZ+zmfSGO1N6dD+lf0mtldWD1KuIA78o
         nF4p8QshezlXA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk59k-0004RA-QW; Fri, 21 May 2021 15:25:37 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] Input: usbtouchscreen - fix control-request directions
Date:   Fri, 21 May 2021 15:25:03 +0200
Message-Id: <20210521132503.17013-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the three control requests which erroneously used usb_rcvctrlpipe().

Fixes: 1d3e20236d7a ("[PATCH] USB: usbtouchscreen: unified USB touchscreen driver")
Fixes: 24ced062a296 ("usbtouchscreen: add support for DMC TSC-10/25 devices")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/input/touchscreen/usbtouchscreen.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index c847453a03c2..7c47fedd555d 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
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

