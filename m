Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9323C4B3D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240726AbhGLG4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239919AbhGLGzs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:55:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFF4A61242;
        Mon, 12 Jul 2021 06:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072779;
        bh=A29uD9TBdOrxuQCtmEDMiw/lcIFpE7XKAb7R6qb5EG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqH3jckTTe0wGHkelQ05ZjNAAOV07q6oB3GgQ3v96Jx0HK151M0vEkC4V/q1tM/jQ
         ns0TZgi8X26/mvubkCKWge3dg1ZkWuTgGeegrNHau6Fc1qjwCK/1GfTW/ZJTP+sW07
         DzXCPKFuVm/E0izdEKE/3Flik1p4uqx9ZQ7yqvPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.12 019/700] Input: usbtouchscreen - fix control-request directions
Date:   Mon, 12 Jul 2021 08:01:42 +0200
Message-Id: <20210712060927.457438284@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 41e81022a04a0294c55cfa7e366bc14b9634c66e upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the four control requests which erroneously used usb_rcvctrlpipe().

Fixes: 1d3e20236d7a ("[PATCH] USB: usbtouchscreen: unified USB touchscreen driver")
Fixes: 24ced062a296 ("usbtouchscreen: add support for DMC TSC-10/25 devices")
Fixes: 9e3b25837a20 ("Input: usbtouchscreen - add support for e2i touchscreen controller")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org      # 2.6.17
Link: https://lore.kernel.org/r/20210524092048.4443-1-johan@kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/usbtouchscreen.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -251,7 +251,7 @@ static int e2i_init(struct usbtouch_usb
 	int ret;
 	struct usb_device *udev = interface_to_usbdev(usbtouch->interface);
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      0x01, 0x02, 0x0000, 0x0081,
 	                      NULL, 0, USB_CTRL_SET_TIMEOUT);
 
@@ -531,7 +531,7 @@ static int mtouch_init(struct usbtouch_u
 	if (ret)
 		return ret;
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 	                      MTOUCHUSB_RESET,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      1, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -543,7 +543,7 @@ static int mtouch_init(struct usbtouch_u
 	msleep(150);
 
 	for (i = 0; i < 3; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      MTOUCHUSB_ASYNC_REPORT,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				      1, 1, NULL, 0, USB_CTRL_SET_TIMEOUT);
@@ -722,7 +722,7 @@ static int dmc_tsc10_init(struct usbtouc
 	}
 
 	/* start sending data */
-	ret = usb_control_msg(dev, usb_rcvctrlpipe (dev, 0),
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
 	                      TSC10_CMD_DATA1,
 	                      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 	                      0, 0, NULL, 0, USB_CTRL_SET_TIMEOUT);


