Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C818F3CA088
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 16:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhGOOWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 10:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233076AbhGOOWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 10:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 941286127C;
        Thu, 15 Jul 2021 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626358759;
        bh=thWeGvCeEX5spRYujFBc+hVS+ro0A9/Rk3rvaAXTYA8=;
        h=Subject:To:Cc:From:Date:From;
        b=wS3TmLFk5gumxNYX6+WIKB6xpZWRQA5oPbzRDNNKzJwPHkO15D6+gJPJyE+Ta0aVn
         ZuSYaq/uNTPjRedbgI19WS5/gIR2QLyESG7s+afNzSYzjAXlwHfGPdaXS48uuZedgp
         r7+zPSU+tKwzsj1NihPE//pyYUnJttpUeKTt3krg=
Subject: FAILED: patch "[PATCH] media: dtv5100: fix control-request directions" failed to apply to 4.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 16:17:27 +0200
Message-ID: <162635864786232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c8b9a9be2afa8bd6a72ad1130532baab9fab89d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Fri, 21 May 2021 15:28:38 +0200
Subject: [PATCH] media: dtv5100: fix control-request directions

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the control requests which erroneously used usb_rcvctrlpipe().

Fixes: 8466028be792 ("V4L/DVB (8734): Initial support for AME DTV-5100 USB2.0 DVB-T")
Cc: stable@vger.kernel.org      # 2.6.28
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/dvb-usb/dtv5100.c b/drivers/media/usb/dvb-usb/dtv5100.c
index fba06932a9e0..1c13e493322c 100644
--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -26,6 +26,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 			   u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	struct dtv5100_state *st = d->priv;
+	unsigned int pipe;
 	u8 request;
 	u8 type;
 	u16 value;
@@ -34,6 +35,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 	switch (wlen) {
 	case 1:
 		/* write { reg }, read { value } */
+		pipe = usb_rcvctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_READ :
 							DTV5100_TUNER_READ);
 		type = USB_TYPE_VENDOR | USB_DIR_IN;
@@ -41,6 +43,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 		break;
 	case 2:
 		/* write { reg, value } */
+		pipe = usb_sndctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_WRITE :
 							DTV5100_TUNER_WRITE);
 		type = USB_TYPE_VENDOR | USB_DIR_OUT;
@@ -54,7 +57,7 @@ static int dtv5100_i2c_msg(struct dvb_usb_device *d, u8 addr,
 
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), request,
+	return usb_control_msg(d->udev, pipe, request,
 			       type, value, index, st->data, rlen,
 			       DTV5100_USB_TIMEOUT);
 }
@@ -141,7 +144,7 @@ static int dtv5100_probe(struct usb_interface *intf,
 
 	/* initialize non qt1010/zl10353 part? */
 	for (i = 0; dtv5100_init[i].request; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      dtv5100_init[i].request,
 				      USB_TYPE_VENDOR | USB_DIR_OUT,
 				      dtv5100_init[i].value,

