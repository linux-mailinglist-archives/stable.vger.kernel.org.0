Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B4F529117
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346450AbiEPTzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347411AbiEPTwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3D841636;
        Mon, 16 May 2022 12:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE1960ABE;
        Mon, 16 May 2022 19:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C5DC34100;
        Mon, 16 May 2022 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730442;
        bh=fzks7WI8O+mQ6j0a4KfPHdek8uYlCK58xmGYLIuucWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCEd6DLAJPTHPXw7+gaUqxU70iTZjJudNNGeCJ1eyShNuCSawfX51ZIUw0JpCpTRw
         UOTnqVfCdrnu3jyCKFkb/s23dpSaWXN554zJ/hVL9KtD7HHSEAr5eJ7O//PHXoFkqy
         eeTtNHeVfEw+FXpdm3r/77OLXOlSJZMEk5smv+Os=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.10 66/66] usb: gadget: uvc: allow for application to cleanly shutdown
Date:   Mon, 16 May 2022 21:37:06 +0200
Message-Id: <20220516193621.319828998@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Dan Vacura <w36195@motorola.com>

commit b81ac4395bbeaf36e078dea1a48c02dd97b76235 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c    |   25 +++++++++++++++++++++++++
 drivers/usb/gadget/function/uvc.h      |    2 ++
 drivers/usb/gadget/function/uvc_v4l2.c |    3 ++-
 3 files changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -888,13 +888,37 @@ static void uvc_function_unbind(struct u
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
 
@@ -913,6 +937,7 @@ static struct usb_function *uvc_alloc(st
 
 	mutex_init(&uvc->video.mutex);
 	uvc->state = UVC_STATE_DISCONNECTED;
+	init_waitqueue_head(&uvc->func_connected_queue);
 	opts = fi_to_f_uvc_opts(fi);
 
 	mutex_lock(&opts->lock);
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/usb/composite.h>
 #include <linux/videodev2.h>
+#include <linux/wait.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
@@ -118,6 +119,7 @@ struct uvc_device {
 	struct usb_function func;
 	struct uvc_video video;
 	bool func_connected;
+	wait_queue_head_t func_connected_queue;
 
 	/* Descriptors */
 	struct {
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -252,10 +252,11 @@ uvc_v4l2_subscribe_event(struct v4l2_fh
 
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


