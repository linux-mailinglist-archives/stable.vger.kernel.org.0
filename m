Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879CE527F0C
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiEPH7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 03:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbiEPH7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 03:59:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCA72C649
        for <stable@vger.kernel.org>; Mon, 16 May 2022 00:59:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B30A5CE1128
        for <stable@vger.kernel.org>; Mon, 16 May 2022 07:59:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB29C385B8;
        Mon, 16 May 2022 07:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652687971;
        bh=UsUAAE2CEq97vN/R9EwwiPN6MghAOQUbeY7ahiLiwHY=;
        h=Subject:To:Cc:From:Date:From;
        b=bjc3W/1ILx+mGhpxMWZOjNd0UHwILP+NIbGy7uuR1K5OqGC3wTUw9pqmDKZVlNFt+
         ezPz5MxTdUvrXnA+29uu89a2er/3n6aaP0LFQGrxYJxkHwBAfcR721uI7yRValXeKk
         yKfaHK2cPNmznc/Ll/fqfWU1xYg3CKlNTNTE6Has=
Subject: FAILED: patch "[PATCH] usb: gadget: uvc: allow for application to cleanly shutdown" failed to apply to 5.15-stable tree
To:     w36195@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 09:59:28 +0200
Message-ID: <1652687968217202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b81ac4395bbeaf36e078dea1a48c02dd97b76235 Mon Sep 17 00:00:00 2001
From: Dan Vacura <w36195@motorola.com>
Date: Tue, 3 May 2022 15:10:38 -0500
Subject: [PATCH] usb: gadget: uvc: allow for application to cleanly shutdown

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

