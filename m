Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03733608C55
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJVLLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbiJVLLI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:11:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736232E7B88
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 03:31:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0742E60BC9
        for <stable@vger.kernel.org>; Sat, 22 Oct 2022 10:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A81BC433D6;
        Sat, 22 Oct 2022 10:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666434660;
        bh=H/Ttkx8LSiDCyy2HQ27sDAavWQzOFtoEjAY9u3IXaNk=;
        h=Subject:To:From:Date:From;
        b=kzJjN/AUTYx5qedE0YCyN5Dorwxma8xF/MR4XJYBClbbkkFwjhdzHPdEGMzdTLION
         8kbLHx/yWnZ/us2RABswXANwCp3vWj4VWZTY4avWObxdHf2mW5lKFWoPDWji/pY5qq
         GiWaVe0w1XMSNYbaKT0A2ZFW/KB75V45RKE175XY=
Subject: patch "usb: gadget: uvc: fix sg handling in error case" added to usb-linus
To:     w36195@motorola.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 22 Oct 2022 12:30:47 +0200
Message-ID: <1666434647169229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: uvc: fix sg handling in error case

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 0a0a2760b04814428800d48281a447a7522470ad Mon Sep 17 00:00:00 2001
From: Dan Vacura <w36195@motorola.com>
Date: Tue, 18 Oct 2022 16:50:39 -0500
Subject: usb: gadget: uvc: fix sg handling in error case

If there is a transmission error the buffer will be returned too early,
causing a memory fault as subsequent requests for that buffer are still
queued up to be sent. Refactor the error handling to wait for the final
request to come in before reporting back the buffer to userspace for all
transfer types (bulk/isoc/isoc_sg). This ensures userspace knows if the
frame was successfully sent.

Fixes: e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Vacura <w36195@motorola.com>
Link: https://lore.kernel.org/r/20221018215044.765044-4-w36195@motorola.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_queue.c |  8 +++++---
 drivers/usb/gadget/function/uvc_video.c | 18 ++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_queue.c b/drivers/usb/gadget/function/uvc_queue.c
index ec500ee499ee..0aa3d7e1f3cc 100644
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -304,6 +304,7 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
@@ -329,10 +330,11 @@ int uvcg_queue_enable(struct uvc_video_queue *queue, int enable)
 void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf)
 {
-	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
-	     buf->length != buf->bytesused) {
-		buf->state = UVC_BUF_STATE_QUEUED;
+	if (queue->flags & UVC_QUEUE_DROP_INCOMPLETE) {
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
+		buf->state = UVC_BUF_STATE_ERROR;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
+		vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_ERROR);
 		return;
 	}
 
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 323977716f5a..5993e083819c 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -88,6 +88,7 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -113,13 +114,14 @@ uvc_video_encode_bulk(struct usb_request *req, struct uvc_video *video,
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 
 		video->payload_size = 0;
 	}
 
 	if (video->payload_size == video->max_payload_size ||
+	    video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE ||
 	    buf->bytesused == video->queue.buf_used)
 		video->payload_size = 0;
 }
@@ -180,7 +182,8 @@ uvc_video_encode_isoc_sg(struct usb_request *req, struct uvc_video *video,
 	req->length -= len;
 	video->queue.buf_used += req->length - header_len;
 
-	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
+	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
@@ -195,6 +198,7 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -209,12 +213,13 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
 
 	req->length = video->req_size - len;
 
-	if (buf->bytesused == video->queue.buf_used) {
+	if (buf->bytesused == video->queue.buf_used ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		list_del(&buf->queue);
-		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 	}
 }
 
@@ -255,6 +260,11 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	case 0:
 		break;
 
+	case -EXDEV:
+		uvcg_dbg(&video->uvc->func, "VS request missed xfer.\n");
+		queue->flags |= UVC_QUEUE_DROP_INCOMPLETE;
+		break;
+
 	case -ESHUTDOWN:	/* disconnect from host. */
 		uvcg_dbg(&video->uvc->func, "VS request cancelled.\n");
 		uvcg_queue_cancel(queue, 1);
-- 
2.38.1


