Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A053FFFA7
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349049AbhICMSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 08:18:07 -0400
Received: from www.linuxtv.org ([130.149.80.248]:48256 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235119AbhICMSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 08:18:07 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mM880-00BdnU-8t; Fri, 03 Sep 2021 12:17:04 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 30 Jul 2021 10:59:18 +0000
Subject: [git:media_tree/fixes] media: rtl28xxu: fix zero-length control request
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, Eero Lehtinen <debiangamer2@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mM880-00BdnU-8t@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rtl28xxu: fix zero-length control request
Author:  Johan Hovold <johan@kernel.org>
Date:    Wed Jun 23 10:45:21 2021 +0200

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Control transfers without a data stage are treated as OUT requests by
the USB stack and should be using usb_sndctrlpipe(). Failing to do so
will now trigger a warning.

The driver uses a zero-length i2c-read request for type detection so
update the control-request code to use usb_sndctrlpipe() in this case.

Note that actually trying to read the i2c register in question does not
work as the register might not exist (e.g. depending on the demodulator)
as reported by Eero Lehtinen <debiangamer2@gmail.com>.

Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com
Reported-by: Eero Lehtinen <debiangamer2@gmail.com>
Tested-by: Eero Lehtinen <debiangamer2@gmail.com>
Fixes: d0f232e823af ("[media] rtl28xxu: add heuristic to detect chip type")
Cc: stable@vger.kernel.org      # 4.0
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

---

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0cbdb95f8d35..795a012d4020 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -37,7 +37,16 @@ static int rtl28xxu_ctrl_msg(struct dvb_usb_device *d, struct rtl28xxu_req *req)
 	} else {
 		/* read */
 		requesttype = (USB_TYPE_VENDOR | USB_DIR_IN);
-		pipe = usb_rcvctrlpipe(d->udev, 0);
+
+		/*
+		 * Zero-length transfers must use usb_sndctrlpipe() and
+		 * rtl28xxu_identify_state() uses a zero-length i2c read
+		 * command to determine the chip type.
+		 */
+		if (req->size)
+			pipe = usb_rcvctrlpipe(d->udev, 0);
+		else
+			pipe = usb_sndctrlpipe(d->udev, 0);
 	}
 
 	ret = usb_control_msg(d->udev, pipe, 0, requesttype, req->value,
