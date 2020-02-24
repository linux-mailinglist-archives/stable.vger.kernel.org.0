Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1732F16A9CF
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 16:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBXPTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 10:19:54 -0500
Received: from www.linuxtv.org ([130.149.80.248]:38812 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbgBXPTy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 10:19:54 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6FUn-008x6M-Hs; Mon, 24 Feb 2020 15:18:09 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 15:13:26 +0000
Subject: [git:media_tree/master] media: usbtv: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     Johan Hovold <johan@kernel.org>, Lubomir Rintel <lkundrak@v3.sk>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6FUn-008x6M-Hs@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: usbtv: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Jan 13 18:18:18 2020 +0100

The driver was issuing synchronous uninterruptible control requests
without using a timeout. This could lead to the driver hanging on
various user requests due to a malfunctioning (or malicious) device
until the device is physically disconnected.

The USB upper limit of five seconds per request should be more than
enough.

Fixes: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber")
Fixes: c53a846c48f2 ("[media] usbtv: add video controls")
Cc: stable <stable@vger.kernel.org>     # 3.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/usbtv/usbtv-core.c  | 2 +-
 drivers/media/usb/usbtv/usbtv-video.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 5095c380b2c1..ee9c656d121f 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -56,7 +56,7 @@ int usbtv_set_regs(struct usbtv *usbtv, const u16 regs[][2], int size)
 
 		ret = usb_control_msg(usbtv->udev, pipe, USBTV_REQUEST_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, index, NULL, 0, 0);
+			value, index, NULL, 0, USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 3d9284a09ee5..b249f037900c 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -800,7 +800,8 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = usb_control_msg(usbtv->udev,
 			usb_rcvctrlpipe(usbtv->udev, 0), USBTV_CONTROL_REG,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, USBTV_BASE + 0x0244, (void *)data, 3, 0);
+			0, USBTV_BASE + 0x0244, (void *)data, 3,
+			USB_CTRL_GET_TIMEOUT);
 		if (ret < 0)
 			goto error;
 	}
@@ -851,7 +852,7 @@ static int usbtv_s_ctrl(struct v4l2_ctrl *ctrl)
 	ret = usb_control_msg(usbtv->udev, usb_sndctrlpipe(usbtv->udev, 0),
 			USBTV_CONTROL_REG,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0, index, (void *)data, size, 0);
+			0, index, (void *)data, size, USB_CTRL_SET_TIMEOUT);
 
 error:
 	if (ret < 0)
