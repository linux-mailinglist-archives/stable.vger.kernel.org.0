Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8B462FF4
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240335AbhK3JqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:46:02 -0500
Received: from www.linuxtv.org ([130.149.80.248]:49590 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240338AbhK3JqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 04:46:01 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mrzeq-0004qz-82; Tue, 30 Nov 2021 09:42:40 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 06:03:51 +0000
Subject: [git:media_tree/master] media: mceusb: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mrzeq-0004qz-82@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: mceusb: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Oct 25 13:16:34 2021 +0100

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 66e89522aff7 ("V4L/DVB: IR: add mceusb IR receiver driver")
Cc: stable@vger.kernel.org      # 2.6.36
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/mceusb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index d09bee82c04c..2dc810f5a73f 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1430,7 +1430,7 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	 */
 	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, HZ * 3);
+			      data, USB_CTRL_MSG_SZ, 3000);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
@@ -1438,20 +1438,20 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 	/* set feature: bit rate 38400 bps */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, HZ * 3);
+			      0xc04e, 0x0000, NULL, 0, 3000);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, HZ * 3);
+			      0x0808, 0x0000, NULL, 0, 3000);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
 	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
 			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, HZ * 3);
+			      0x0000, 0x0100, NULL, 0, 3000);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
