Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BA60FE12
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbiJ0RB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbiJ0RBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26AD1911CB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:01:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F55B82716
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C87C4347C;
        Thu, 27 Oct 2022 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890106;
        bh=xWDW0Oa6SSsooFPdemw3qj0DAISfcn+1xnsCmLlDTlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1v2D6O750aBtIvEeGYGTwIYeWFNLOY9RtDMsOfBDY06i2c+C7cH/t9REQQq6wshLQ
         laqokCspgZLWhewfuyDUFMq4RWeRtxjTPXiXBCsxlEV1vs8EFJURF35tqruqoNXFaN
         ahmu2ze+0SspOcDykqmOvf+GEsZo+3mCFgjPMj1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 05/79] usb: gadget: uvc: rework uvcg_queue_next_buffer to uvcg_complete_buffer
Date:   Thu, 27 Oct 2022 18:55:03 +0200
Message-Id: <20221027165055.104863549@linuxfoundation.org>
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

commit 61aa709ca58a0dbeeb817bfa9230c1a92979f2c6 upstream.

The function uvcg_queue_next_buffer is used different than its name
suggests. The return value nextbuf is never used by any caller. This
patch reworks the function to its actual purpose, by removing the unused
code and renaming it. The function name uvcg_complete_buffer makes it
more clear that it is actually marking the current video buffer as
complete.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220402232744.3622565-2-m.grzeschik@pengutronix.de
Cc: Dan Vacura <w36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc_queue.c |   13 ++-----------
 drivers/usb/gadget/function/uvc_queue.h |    2 +-
 drivers/usb/gadget/function/uvc_video.c |    6 +++---
 3 files changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/usb/gadget/function/uvc_queue.c
+++ b/drivers/usb/gadget/function/uvc_queue.c
@@ -335,24 +335,17 @@ int uvcg_queue_enable(struct uvc_video_q
 }
 
 /* called with &queue_irqlock held.. */
-struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
+void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf)
 {
-	struct uvc_buffer *nextbuf;
-
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	     buf->length != buf->bytesused) {
 		buf->state = UVC_BUF_STATE_QUEUED;
 		vb2_set_plane_payload(&buf->buf.vb2_buf, 0, 0);
-		return buf;
+		return;
 	}
 
 	list_del(&buf->queue);
-	if (!list_empty(&queue->irqqueue))
-		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
-					   queue);
-	else
-		nextbuf = NULL;
 
 	buf->buf.field = V4L2_FIELD_NONE;
 	buf->buf.sequence = queue->sequence++;
@@ -360,8 +353,6 @@ struct uvc_buffer *uvcg_queue_next_buffe
 
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
-
-	return nextbuf;
 }
 
 struct uvc_buffer *uvcg_queue_head(struct uvc_video_queue *queue)
--- a/drivers/usb/gadget/function/uvc_queue.h
+++ b/drivers/usb/gadget/function/uvc_queue.h
@@ -93,7 +93,7 @@ void uvcg_queue_cancel(struct uvc_video_
 
 int uvcg_queue_enable(struct uvc_video_queue *queue, int enable);
 
-struct uvc_buffer *uvcg_queue_next_buffer(struct uvc_video_queue *queue,
+void uvcg_complete_buffer(struct uvc_video_queue *queue,
 					  struct uvc_buffer *buf);
 
 struct uvc_buffer *uvcg_queue_head(struct uvc_video_queue *queue);
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -83,7 +83,7 @@ uvc_video_encode_bulk(struct usb_request
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 
 		video->payload_size = 0;
@@ -154,7 +154,7 @@ uvc_video_encode_isoc_sg(struct usb_requ
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
 		buf->offset = 0;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 	}
 }
@@ -181,7 +181,7 @@ uvc_video_encode_isoc(struct usb_request
 	if (buf->bytesused == video->queue.buf_used) {
 		video->queue.buf_used = 0;
 		buf->state = UVC_BUF_STATE_DONE;
-		uvcg_queue_next_buffer(&video->queue, buf);
+		uvcg_complete_buffer(&video->queue, buf);
 		video->fid ^= UVC_STREAM_FID;
 	}
 }


