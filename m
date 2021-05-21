Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D6338C811
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbhEUNax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 09:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhEUNat (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 09:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4204F610CB;
        Fri, 21 May 2021 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621603766;
        bh=nZdXgVKs9PVCx2Vd8YxywHtcjM8I5V3b8sTE2T5rp+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrnbynxNKsLWtaywCHBqnEcZ2mYIFdCCz9B1HOxGAL5ccPv8HE7sKhW+zZ5i9WyyN
         99kqmJpGxFL+Y83jdsYu9NXznJ16eBNH3w1v12Gku1ftW33EQ9S3BRyQ3jZtLVyiJz
         czqwdlJqjmlYBgSS4k7o1rsHiL+QfUlmEI0a2Q5Ph/s9nXqELrIBgSXFWuniVIZIMr
         v9YX6uhfJgomjQ1o5PdvAjww4Sk2TXK/ik09MDDii4/3/ujz7gFb8WZx3hMjWKgx/Y
         XklYRykiqjVPuZHX0HCbzIB5VPJ3gZweexTEonTgW5ABkD9ZYk4P5XfLuiorm573pF
         PzTWPUiVN5ocQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1lk5DT-0004Tq-Ak; Fri, 21 May 2021 15:29:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] media: dtv5100: fix control-request directions
Date:   Fri, 21 May 2021 15:28:38 +0200
Message-Id: <20210521132839.17163-2-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210521132839.17163-1-johan@kernel.org>
References: <20210521132839.17163-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the control requests which erroneously used usb_rcvctrlpipe().

Fixes: 8466028be792 ("V4L/DVB (8734): Initial support for AME DTV-5100 USB2.0 DVB-T")
Cc: stable@vger.kernel.org      # 2.6.28
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/dvb-usb/dtv5100.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
-- 
2.26.3

