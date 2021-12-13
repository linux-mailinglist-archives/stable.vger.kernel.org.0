Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FCB47260F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhLMJsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60684 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236264AbhLMJqa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:46:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66502B80E1D;
        Mon, 13 Dec 2021 09:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96555C00446;
        Mon, 13 Dec 2021 09:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388787;
        bh=sdT9iJJ3Ok34Fio02uyDvkVlQ4LGyZzVKWRwnIkWQmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AgGVUaYzB8L40kj/4x8/ujf7SZ1DPVr1fTeEBYzO8YHn7TytrqzRxHicUqFPV5Lkb
         6nKNJD8uWu+IxChcNuvnjSGoqhduTr6Z/DcrCCaqFFyKM7XHloG/GEJa+RgL2UlxvN
         BiY8zt/iH/i8bWEyBntjx8gYJ3CEEnKEjNzepSyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Tretter <m.tretter@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Haemmerle <thomas.haemmerle@wolfvision.net>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Felipe Balbi <balbi@kernel.org>,
        Dan Vacura <W36195@motorola.com>
Subject: [PATCH 5.10 001/132] usb: gadget: uvc: fix multiple opens
Date:   Mon, 13 Dec 2021 10:29:02 +0100
Message-Id: <20211213092939.124772704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>

commit 72ee48ee8925446eaeda8e4ef3f2eb16b4a93d2a upstream.

Currently, the UVC function is activated when open on the corresponding
v4l2 device is called.  On another open the activation of the function
fails since the deactivation counter in `usb_function_activate` equals
0. However the error is not returned to userspace since the open of the
v4l2 device is successful.

On a close the function is deactivated (since deactivation counter still
equals 0) and the video is disabled in `uvc_v4l2_release`, although the
UVC application potentially is streaming.

Move activation of UVC function to subscription on UVC_EVENT_SETUP
because there we can guarantee for a userspace application utilizing
UVC.  Block subscription on UVC_EVENT_SETUP while another application
already is subscribed to it, indicated by `bool func_connected` in
`struct uvc_device`.  Extend the `struct uvc_file_handle` with member
`bool is_uvc_app_handle` to tag it as the handle used by the userspace
UVC application.

With this a process is able to check capabilities of the v4l2 device
without deactivating the function for the actual UVC application.

Reviewed-By: Michael Tretter <m.tretter@pengutronix.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Acked-by: Felipe Balbi <balbi@kernel.org>
Link: https://lore.kernel.org/r/20211003201355.24081-1-m.grzeschik@pengutronix.de
Cc: Dan Vacura <W36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc.h      |    2 +
 drivers/usb/gadget/function/uvc_v4l2.c |   49 ++++++++++++++++++++++++++++-----
 2 files changed, 44 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -117,6 +117,7 @@ struct uvc_device {
 	enum uvc_state state;
 	struct usb_function func;
 	struct uvc_video video;
+	bool func_connected;
 
 	/* Descriptors */
 	struct {
@@ -147,6 +148,7 @@ static inline struct uvc_device *to_uvc(
 struct uvc_file_handle {
 	struct v4l2_fh vfh;
 	struct uvc_video *device;
+	bool is_uvc_app_handle;
 };
 
 #define to_uvc_file_handle(handle) \
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -227,17 +227,55 @@ static int
 uvc_v4l2_subscribe_event(struct v4l2_fh *fh,
 			 const struct v4l2_event_subscription *sub)
 {
+	struct uvc_device *uvc = video_get_drvdata(fh->vdev);
+	struct uvc_file_handle *handle = to_uvc_file_handle(fh);
+	int ret;
+
 	if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
 		return -EINVAL;
 
-	return v4l2_event_subscribe(fh, sub, 2, NULL);
+	if (sub->type == UVC_EVENT_SETUP && uvc->func_connected)
+		return -EBUSY;
+
+	ret = v4l2_event_subscribe(fh, sub, 2, NULL);
+	if (ret < 0)
+		return ret;
+
+	if (sub->type == UVC_EVENT_SETUP) {
+		uvc->func_connected = true;
+		handle->is_uvc_app_handle = true;
+		uvc_function_connect(uvc);
+	}
+
+	return 0;
+}
+
+static void uvc_v4l2_disable(struct uvc_device *uvc)
+{
+	uvc->func_connected = false;
+	uvc_function_disconnect(uvc);
+	uvcg_video_enable(&uvc->video, 0);
+	uvcg_free_buffers(&uvc->video.queue);
 }
 
 static int
 uvc_v4l2_unsubscribe_event(struct v4l2_fh *fh,
 			   const struct v4l2_event_subscription *sub)
 {
-	return v4l2_event_unsubscribe(fh, sub);
+	struct uvc_device *uvc = video_get_drvdata(fh->vdev);
+	struct uvc_file_handle *handle = to_uvc_file_handle(fh);
+	int ret;
+
+	ret = v4l2_event_unsubscribe(fh, sub);
+	if (ret < 0)
+		return ret;
+
+	if (sub->type == UVC_EVENT_SETUP && handle->is_uvc_app_handle) {
+		uvc_v4l2_disable(uvc);
+		handle->is_uvc_app_handle = false;
+	}
+
+	return 0;
 }
 
 static long
@@ -292,7 +330,6 @@ uvc_v4l2_open(struct file *file)
 	handle->device = &uvc->video;
 	file->private_data = &handle->vfh;
 
-	uvc_function_connect(uvc);
 	return 0;
 }
 
@@ -304,11 +341,9 @@ uvc_v4l2_release(struct file *file)
 	struct uvc_file_handle *handle = to_uvc_file_handle(file->private_data);
 	struct uvc_video *video = handle->device;
 
-	uvc_function_disconnect(uvc);
-
 	mutex_lock(&video->mutex);
-	uvcg_video_enable(video, 0);
-	uvcg_free_buffers(&video->queue);
+	if (handle->is_uvc_app_handle)
+		uvc_v4l2_disable(uvc);
 	mutex_unlock(&video->mutex);
 
 	file->private_data = NULL;


