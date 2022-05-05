Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC3251CC21
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiEEWhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 18:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiEEWhc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 18:37:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C530453727
        for <stable@vger.kernel.org>; Thu,  5 May 2022 15:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78485B830E6
        for <stable@vger.kernel.org>; Thu,  5 May 2022 22:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B44C385A4;
        Thu,  5 May 2022 22:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651790028;
        bh=TxAsDDhNvh8E4z31tbNpUIu58hXvtEv2iE3dv/sW3kk=;
        h=Subject:To:From:Date:From;
        b=hD7GDzR99HZNHRzG3t5+yj/1abjkNYAtS/TVAwQbM3cT5mDqeIuaCQvRK9ej/bcqf
         P0bT3XMgAqbu0LNQDeuOxU/o8p6XGxAOTVbGrvN6So/VY/IiIJH+iW1NIz7xxcXWFB
         Kn9Leq5AAD8hf9bR7lPQUvplCJSQZc2s9ewJ4ePc=
Subject: patch "usb: gadget: uvc: allow for application to cleanly shutdown" added to usb-linus
To:     w36195@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 May 2022 22:18:23 +0200
Message-ID: <1651781903168204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: uvc: allow for application to cleanly shutdown

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b81ac4395bbeaf36e078dea1a48c02dd97b76235 Mon Sep 17 00:00:00 2001
From: Dan Vacura <w36195@motorola.com>
Date: Tue, 3 May 2022 15:10:38 -0500
Subject: usb: gadget: uvc: allow for application to cleanly shutdown

Several types of kernel panics can occur due to timing during the uvc
gadget removal. This appears to be a problem with gadget resources being
managed by both the client application's v4l2 open/close and the UDC
gadget bind/unbind. Since the concept of USB_GADGET_DELAYED_STATUS
doesn't exist for unbind, add a wait to allow for the application to
close out.

Some examples of the panics that can occur are:

<1>[ 1147.652313] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000028
<4>[ 1147.652510] Call trace:
<4>[ 1147.652514]  usb_gadget_disconnect+0x74/0x1f0
<4>[ 1147.652516]  usb_gadget_deactivate+0x38/0x168
<4>[ 1147.652520]  usb_function_deactivate+0x54/0x90
<4>[ 1147.652524]  uvc_function_disconnect+0x14/0x38
<4>[ 1147.652527]  uvc_v4l2_release+0x34/0xa0
<4>[ 1147.652537]  __fput+0xdc/0x2c0
<4>[ 1147.652540]  ____fput+0x10/0x1c
<4>[ 1147.652545]  task_work_run+0xe4/0x12c
<4>[ 1147.652549]  do_notify_resume+0x108/0x168

<1>[  282.950561][ T1472] Unable to handle kernel NULL pointer
dereference at virtual address 00000000000005b8
<6>[  282.953111][ T1472] Call trace:
<6>[  282.953121][ T1472]  usb_function_deactivate+0x54/0xd4
<6>[  282.953134][ T1472]  uvc_v4l2_release+0xac/0x1e4
<6>[  282.953145][ T1472]  v4l2_release+0x134/0x1f0
<6>[  282.953167][ T1472]  __fput+0xf4/0x428
<6>[  282.953178][ T1472]  ____fput+0x14/0x24
<6>[  282.953193][ T1472]  task_work_run+0xac/0x130

<3>[  213.410077][   T29] configfs-gadget gadget: uvc: Failed to queue
request (-108).
<1>[  213.410116][   T29] Unable to handle kernel NULL pointer
dereference at virtual address 0000000000000003
<6>[  213.413460][   T29] Call trace:
<6>[  213.413474][   T29]  uvcg_video_pump+0x1f0/0x384
<6>[  213.413489][   T29]  process_one_work+0x2a4/0x544
<6>[  213.413502][   T29]  worker_thread+0x350/0x784
<6>[  213.413515][   T29]  kthread+0x2ac/0x320
<6>[  213.413528][   T29]  ret_from_fork+0x10/0x30

Signed-off-by: Dan Vacura <w36195@motorola.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220503201039.71720-1-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c    | 25 +++++++++++++++++++++++++
 drivers/usb/gadget/function/uvc.h      |  2 ++
 drivers/usb/gadget/function/uvc_v4l2.c |  3 ++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 71bb5e477dba..d37965867b23 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -890,13 +890,37 @@ static void uvc_function_unbind(struct usb_configuration *c,
 {
 	struct usb_composite_dev *cdev = c->cdev;
 	struct uvc_device *uvc = to_uvc(f);
+	long wait_ret = 1;
 
 	uvcg_info(f, "%s()\n", __func__);
 
+	/* If we know we're connected via v4l2, then there should be a cleanup
+	 * of the device from userspace either via UVC_EVENT_DISCONNECT or
+	 * though the video device removal uevent. Allow some time for the
+	 * application to close out before things get deleted.
+	 */
+	if (uvc->func_connected) {
+		uvcg_dbg(f, "waiting for clean disconnect\n");
+		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
+				uvc->func_connected == false, msecs_to_jiffies(500));
+		uvcg_dbg(f, "done waiting with ret: %ld\n", wait_ret);
+	}
+
 	device_remove_file(&uvc->vdev.dev, &dev_attr_function_name);
 	video_unregister_device(&uvc->vdev);
 	v4l2_device_unregister(&uvc->v4l2_dev);
 
+	if (uvc->func_connected) {
+		/* Wait for the release to occur to ensure there are no longer any
+		 * pending operations that may cause panics when resources are cleaned
+		 * up.
+		 */
+		uvcg_warn(f, "%s no clean disconnect, wait for release\n", __func__);
+		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
+				uvc->func_connected == false, msecs_to_jiffies(1000));
+		uvcg_dbg(f, "done waiting for release with ret: %ld\n", wait_ret);
+	}
+
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
 	kfree(uvc->control_buf);
 
@@ -915,6 +939,7 @@ static struct usb_function *uvc_alloc(struct usb_function_instance *fi)
 
 	mutex_init(&uvc->video.mutex);
 	uvc->state = UVC_STATE_DISCONNECTED;
+	init_waitqueue_head(&uvc->func_connected_queue);
 	opts = fi_to_f_uvc_opts(fi);
 
 	mutex_lock(&opts->lock);
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index c3607a32b986..886103a1fe9b 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/usb/composite.h>
 #include <linux/videodev2.h>
+#include <linux/wait.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
@@ -129,6 +130,7 @@ struct uvc_device {
 	struct usb_function func;
 	struct uvc_video video;
 	bool func_connected;
+	wait_queue_head_t func_connected_queue;
 
 	/* Descriptors */
 	struct {
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index a2c78690c5c2..fd8f73bb726d 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -253,10 +253,11 @@ uvc_v4l2_subscribe_event(struct v4l2_fh *fh,
 
 static void uvc_v4l2_disable(struct uvc_device *uvc)
 {
-	uvc->func_connected = false;
 	uvc_function_disconnect(uvc);
 	uvcg_video_enable(&uvc->video, 0);
 	uvcg_free_buffers(&uvc->video.queue);
+	uvc->func_connected = false;
+	wake_up_interruptible(&uvc->func_connected_queue);
 }
 
 static int
-- 
2.36.0


