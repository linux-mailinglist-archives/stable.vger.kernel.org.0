Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2D60FE19
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236852AbiJ0RCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbiJ0RBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A88189C30
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05AD8623F0
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:01:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1606FC433D6;
        Thu, 27 Oct 2022 17:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890109;
        bh=zS5k3/UprKf5mBDf9QBqnVyc14GqV0RVvuudxcSV6+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xo6LaeStn83elSmfEc8E5LuufshMuUjlByn3VD+3B+fCAW19AeCxNMXZKzqBOOBjs
         YoddOwF+21RC6D/16upZcF7Yy20DUCXbW7BN9xQBc1eT8uS7vVzWWPOKVsJPGyQN5n
         edYcmyTMWpA7vMUL+DLkDWtkqVpi2IPd/mBJWnMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 06/79] usb: gadget: uvc: giveback vb2 buffer on req complete
Date:   Thu, 27 Oct 2022 18:55:04 +0200
Message-Id: <20221027165055.148384042@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 9b969f93bcef9b3d9e92f1810e22bbd6c344a0e5 upstream.

On uvc_video_encode_isoc_sg the mapped vb2 buffer is returned
to early. Only after the last usb_request worked with the buffer
it is allowed to give it back to vb2. This patch fixes that.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220402232744.3622565-3-m.grzeschik@pengutronix.de
Cc: Dan Vacura <w36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc.h       |    1 +
 drivers/usb/gadget/function/uvc_queue.c |    2 --
 drivers/usb/gadget/function/uvc_video.c |   11 ++++++++++-
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -80,6 +80,7 @@ struct uvc_request {
 	struct uvc_video *video;
 	struct sg_table sgt;
 	u8 header[UVCG_REQUEST_HEADER_LEN];
+	struct uvc_buffer *last_buf;
 };
 
 struct uvc_video {
--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -345,8 +345,6 @@ void uvcg_complete_buffer(struct uvc_vid
 		return;
 	}
 
-	list_del(&buf->queue);
-
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = queue->sequence++;
 	buf->buf.vb2_buf.timestamp = ktime_get_ns();
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -83,6 +83,7 @@ uvc_video_encode_bulk(struct usb_request
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
+		list_del(&buf->queue);
 		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 
@@ -154,8 +155,9 @@ uvc_video_encode_isoc_sg(struct usb_requ
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
-		uvcg_complete_buffer(&video->queue, buf);
+		list_del(&buf->queue);
 		video->fid ^= UVC_STREAM_FID;
+		ureq->last_buf = buf;
 	}
 }
 
@@ -181,6 +183,7 @@ uvc_video_encode_isoc(struct usb_request
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
+		list_del(&buf->queue);
 		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 	}
@@ -231,6 +234,11 @@ uvc_video_complete(struct usb_ep *ep, st
 		uvcg_queue_cancel(queue, 0);
 	}
 
+	if (ureq->last_buf) {
+		uvcg_complete_buffer(&video->queue, ureq->last_buf);
+		ureq->last_buf = NULL;
+	}
+
 	spin_lock_irqsave(&video->req_lock, flags);
 	list_add_tail(&req->list, &video->req_free);
 	spin_unlock_irqrestore(&video->req_lock, flags);
@@ -298,6 +306,7 @@ uvc_video_alloc_requests(struct uvc_vide
 		video->ureq[i].req->complete = uvc_video_complete;
 		video->ureq[i].req->context = &video->ureq[i];
 		video->ureq[i].video = video;
+		video->ureq[i].last_buf = NULL;
 
 		list_add_tail(&video->ureq[i].req->list, &video->req_free);
 		/* req_size/PAGE_SIZE + 1 for overruns and + 1 for header */


