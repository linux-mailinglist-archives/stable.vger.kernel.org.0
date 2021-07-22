Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3793D2310
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhGVLV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 07:21:56 -0400
Received: from www.linuxtv.org ([130.149.80.248]:42586 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231773AbhGVLVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 07:21:51 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1m6XPB-000aZN-Gy; Thu, 22 Jul 2021 12:02:21 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 22 Jul 2021 12:01:55 +0000
Subject: [git:media_stage/master] media: stkwebcam: fix memory leak in stk_camera_probe
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1m6XPB-000aZN-Gy@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: stkwebcam: fix memory leak in stk_camera_probe
Author:  Pavel Skripkin <paskripkin@gmail.com>
Date:    Wed Jul 7 19:54:30 2021 +0200

My local syzbot instance hit memory leak in usb_set_configuration().
The problem was in unputted usb interface. In case of errors after
usb_get_intf() the reference should be putted to correclty free memory
allocated for this interface.

Fixes: ec16dae5453e ("V4L/DVB (7019): V4L: add support for Syntek DC1125 webcams")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/stkwebcam/stk-webcam.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index a45d464427c4..0e231e576dc3 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -1346,7 +1346,7 @@ static int stk_camera_probe(struct usb_interface *interface,
 	if (!dev->isoc_ep) {
 		pr_err("Could not find isoc-in endpoint\n");
 		err = -ENODEV;
-		goto error;
+		goto error_put;
 	}
 	dev->vsettings.palette = V4L2_PIX_FMT_RGB565;
 	dev->vsettings.mode = MODE_VGA;
@@ -1359,10 +1359,12 @@ static int stk_camera_probe(struct usb_interface *interface,
 
 	err = stk_register_video_device(dev);
 	if (err)
-		goto error;
+		goto error_put;
 
 	return 0;
 
+error_put:
+	usb_put_intf(interface);
 error:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_device_unregister(&dev->v4l2_dev);
