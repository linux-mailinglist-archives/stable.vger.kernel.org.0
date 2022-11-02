Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9343F6158C8
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiKBC6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiKBC6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:58:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9283D2F9
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4054B82063
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD6BC433C1;
        Wed,  2 Nov 2022 02:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357912;
        bh=1U1fbOu7QDKxhG+wFTJyPkD3M+OC0hsY6SlMz2jDoCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zH83gPhcr367mff0sAogH2+Ir6zMDKaOUwg+0yDaUGc1clqTKMlC3JDK0j+x6bNlg
         H+UPUsrIK1ZFmaV+oXz2nE8Uw7oX18rO7l1mrr0e52+4Ut+V6/J7c7AkKupUCIOpSR
         k8Qp7edrMW4P4Vfh5h8mpxs08lBHCUTBiDTZyiEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 010/132] usb: gadget: uvc: fix sg handling in error case
Date:   Wed,  2 Nov 2022 03:31:56 +0100
Message-Id: <20221102022059.890674891@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Vacura <w36195@motorola.com>

commit 0a0a2760b04814428800d48281a447a7522470ad upstream.

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
 drivers/usb/gadget/function/uvc_queue.c |    8 +++++---
 drivers/usb/gadget/function/uvc_video.c |   18 ++++++++++++++----
 2 files changed, 19 insertions(+), 7 deletions(-)

--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -313,6 +313,7 @@ int uvcg_queue_enable(struct uvc_video_q
 
 		queue->sequence = 0;
 		queue->buf_used = 0;
+		queue->flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
 	} else {
 		ret = vb2_streamoff(&queue->queue, queue->queue.type);
 		if (ret < 0)
@@ -338,10 +339,11 @@ int uvcg_queue_enable(struct uvc_video_q
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
 
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -59,6 +59,7 @@ uvc_video_encode_bulk(struct usb_request
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -84,13 +85,14 @@ uvc_video_encode_bulk(struct usb_request
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
@@ -151,7 +153,8 @@ uvc_video_encode_isoc_sg(struct usb_requ
 	req->length -= len;
 	video->queue.buf_used += req->length - header_len;
 
-	if (buf->bytesused == video->queue.buf_used || !buf->sg) {
+	if (buf->bytesused == video->queue.buf_used || !buf->sg ||
+			video->queue.flags & UVC_QUEUE_DROP_INCOMPLETE) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
@@ -166,6 +169,7 @@ uvc_video_encode_isoc(struct usb_request
 		struct uvc_buffer *buf)
 {
 	void *mem = req->buf;
+	struct uvc_request *ureq = req->context;
 	int len = video->req_size;
 	int ret;
 
@@ -180,12 +184,13 @@ uvc_video_encode_isoc(struct usb_request
 
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
 
@@ -222,6 +227,11 @@ uvc_video_complete(struct usb_ep *ep, st
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


