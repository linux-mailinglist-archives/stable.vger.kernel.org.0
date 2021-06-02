Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2F398950
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 14:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhFBMWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 08:22:08 -0400
Received: from www.linuxtv.org ([130.149.80.248]:45876 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFBMWH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 08:22:07 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1loPrC-00GEug-HR; Wed, 02 Jun 2021 12:20:22 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 02 Jun 2021 12:09:51 +0000
Subject: [git:media_stage/master] media: dtv5100: fix control-request directions
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1loPrC-00GEug-HR@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: dtv5100: fix control-request directions
Author:  Johan Hovold <johan@kernel.org>
Date:    Fri May 21 15:28:38 2021 +0200

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the control requests which erroneously used usb_rcvctrlpipe().

Fixes: 8466028be792 ("V4L/DVB (8734): Initial support for AME DTV-5100 USB2.0 DVB-T")
Cc: stable@vger.kernel.org      # 2.6.28
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb/dtv5100.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

---

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
