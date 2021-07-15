Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416DE3CAB78
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbhGOTUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242779AbhGOTSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A603961405;
        Thu, 15 Jul 2021 19:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376386;
        bh=nA0u2vSnDAToGgwNOLeswbRytUAFyY7uC47mcXzBRyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9KfGH4k8y/LoAUUvVga3cIodNnngi1o2wZfUUfkyvDf21KVuNiAgfvUU5akN5ybs
         pHkUG5/peZXUcIZwqvX8YBaGakAKvdgxzPzRZLNeurSOOKaaXMWfNc+grRh4rwpcGB
         u87T6TDlwxIdZQSTzsKK5/yuhnFRHWD+cRiAnLpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.13 247/266] media: dtv5100: fix control-request directions
Date:   Thu, 15 Jul 2021 20:40:02 +0200
Message-Id: <20210715182651.763605884@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 8c8b9a9be2afa8bd6a72ad1130532baab9fab89d upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the control requests which erroneously used usb_rcvctrlpipe().

Fixes: 8466028be792 ("V4L/DVB (8734): Initial support for AME DTV-5100 USB2.0 DVB-T")
Cc: stable@vger.kernel.org      # 2.6.28
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/dvb-usb/dtv5100.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/usb/dvb-usb/dtv5100.c
+++ b/drivers/media/usb/dvb-usb/dtv5100.c
@@ -26,6 +26,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 			   u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	struct dtv5100_state *st = d->priv;
+	unsigned int pipe;
 	u8 request;
 	u8 type;
 	u16 value;
@@ -34,6 +35,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 	switch (wlen) {
 	case 1:
 		/* write { reg }, read { value } */
+		pipe = usb_rcvctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_READ :
 							DTV5100_TUNER_READ);
 		type = USB_TYPE_VENDOR | USB_DIR_IN;
@@ -41,6 +43,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 		break;
 	case 2:
 		/* write { reg, value } */
+		pipe = usb_sndctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_WRITE :
 							DTV5100_TUNER_WRITE);
 		type = USB_TYPE_VENDOR | USB_DIR_OUT;
@@ -54,7 +57,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), request,
+	return usb_control_msg(d->udev, pipe, request,
 			       type, value, index, st->data, rlen,
 			       DTV5100_USB_TIMEOUT);
 }
@@ -141,7 +144,7 @@ static int dtv5100_probe(struct usb_inte
 
 	/* initialize non qt1010/zl10353 part? */
 	for (i = 0; dtv5100_init[i].request; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      dtv5100_init[i].request,
 				      USB_TYPE_VENDOR | USB_DIR_OUT,
 				      dtv5100_init[i].value,


