Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3EF3CDE0B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344763AbhGSPBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345167AbhGSPAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7E060238;
        Mon, 19 Jul 2021 15:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709252;
        bh=UneAK/DRjDNfyR8fmzdC+wouinMrBxCTvyD8NB2tdLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pv2R2Eg8SMm1H6X+gW2dBYJ/JsBCxx+SGHWVI6byElaQOoywVHyzr3xFBlj2pttz
         235F4TiHQwmEjgk77ZfEK+hN3QKjWWBMvK9nfRyDZjcpq2at9CZK+wI2Bt/k+AkMos
         WLDtCyIkcS/PZqLen1ofletvUagNLQnqrgSmRCew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 309/421] media: dtv5100: fix control-request directions
Date:   Mon, 19 Jul 2021 16:52:00 +0200
Message-Id: <20210719144957.040287684@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -35,6 +35,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 			   u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
 {
 	struct dtv5100_state *st = d->priv;
+	unsigned int pipe;
 	u8 request;
 	u8 type;
 	u16 value;
@@ -43,6 +44,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 	switch (wlen) {
 	case 1:
 		/* write { reg }, read { value } */
+		pipe = usb_rcvctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_READ :
 							DTV5100_TUNER_READ);
 		type = USB_TYPE_VENDOR | USB_DIR_IN;
@@ -50,6 +52,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 		break;
 	case 2:
 		/* write { reg, value } */
+		pipe = usb_sndctrlpipe(d->udev, 0);
 		request = (addr == DTV5100_DEMOD_ADDR ? DTV5100_DEMOD_WRITE :
 							DTV5100_TUNER_WRITE);
 		type = USB_TYPE_VENDOR | USB_DIR_OUT;
@@ -63,7 +66,7 @@ static int dtv5100_i2c_msg(struct dvb_us
 
 	memcpy(st->data, rbuf, rlen);
 	msleep(1); /* avoid I2C errors */
-	return usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0), request,
+	return usb_control_msg(d->udev, pipe, request,
 			       type, value, index, st->data, rlen,
 			       DTV5100_USB_TIMEOUT);
 }
@@ -150,7 +153,7 @@ static int dtv5100_probe(struct usb_inte
 
 	/* initialize non qt1010/zl10353 part? */
 	for (i = 0; dtv5100_init[i].request; i++) {
-		ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+		ret = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				      dtv5100_init[i].request,
 				      USB_TYPE_VENDOR | USB_DIR_OUT,
 				      dtv5100_init[i].value,


