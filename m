Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABE7608C6B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiJVLQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbiJVLQi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:16:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9679C4363A;
        Sat, 22 Oct 2022 03:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B854B82D9F;
        Sat, 22 Oct 2022 08:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C147AC433C1;
        Sat, 22 Oct 2022 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425928;
        bh=ZLE1CSNMbyO4wlg97VRaWaPwROidpEs6zu78zaQFPic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebRoYM1IKJPxyhb58wdm6yWzlDwLvofDOxzmA/RHs1PcJq6ICbXNHfwLqpflMy0o/
         xQsIwwh8oBl76ms9P7v1cbk8Lkiq+aSv7UXW1HL1uB6WdIU5FD6UzeGsi4aZ4wa/1W
         86mjoxP6ATs9Pj21/m1kS0CBCgnjjpKqk32GkWXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 662/717] usb: gadget: uvc: increase worker prio to WQ_HIGHPRI
Date:   Sat, 22 Oct 2022 09:29:01 +0200
Message-Id: <20221022072527.671569804@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit 9b91a65230784a9ef644b8bdbb82a79ba4ae9456 ]

This patch is changing the simple workqueue in the gadget driver to be
allocated as async_wq with a higher priority. The pump worker, that is
filling the usb requests, will have a higher priority and will not be
scheduled away so often while the video stream is handled. This will
lead to fewer streaming underruns.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20220907215818.2670097-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uvc.c     | 4 ++++
 drivers/usb/gadget/function/uvc.h       | 1 +
 drivers/usb/gadget/function/uvc_v4l2.c  | 2 +-
 drivers/usb/gadget/function/uvc_video.c | 9 +++++++--
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 86bb0098fb66..7ec223849d94 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -897,10 +897,14 @@ static void uvc_function_unbind(struct usb_configuration *c,
 {
 	struct usb_composite_dev *cdev = c->cdev;
 	struct uvc_device *uvc = to_uvc(f);
+	struct uvc_video *video = &uvc->video;
 	long wait_ret = 1;
 
 	uvcg_info(f, "%s()\n", __func__);
 
+	if (video->async_wq)
+		destroy_workqueue(video->async_wq);
+
 	/*
 	 * If we know we're connected via v4l2, then there should be a cleanup
 	 * of the device from userspace either via UVC_EVENT_DISCONNECT or
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index 58e383afdd44..1a31e6c6a5ff 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -88,6 +88,7 @@ struct uvc_video {
 	struct usb_ep *ep;
 
 	struct work_struct pump;
+	struct workqueue_struct *async_wq;
 
 	/* Frame parameters */
 	u8 bpp;
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index fd8f73bb726d..fddc392b8ab9 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -170,7 +170,7 @@ uvc_v4l2_qbuf(struct file *file, void *fh, struct v4l2_buffer *b)
 		return ret;
 
 	if (uvc->state == UVC_STATE_STREAMING)
-		schedule_work(&video->pump);
+		queue_work(video->async_wq, &video->pump);
 
 	return ret;
 }
diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index c00ce0e91f5d..bb037fcc90e6 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -277,7 +277,7 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 	spin_unlock_irqrestore(&video->req_lock, flags);
 
 	if (uvc->state == UVC_STATE_STREAMING)
-		schedule_work(&video->pump);
+		queue_work(video->async_wq, &video->pump);
 }
 
 static int
@@ -485,7 +485,7 @@ int uvcg_video_enable(struct uvc_video *video, int enable)
 
 	video->req_int_count = 0;
 
-	schedule_work(&video->pump);
+	queue_work(video->async_wq, &video->pump);
 
 	return ret;
 }
@@ -499,6 +499,11 @@ int uvcg_video_init(struct uvc_video *video, struct uvc_device *uvc)
 	spin_lock_init(&video->req_lock);
 	INIT_WORK(&video->pump, uvcg_video_pump);
 
+	/* Allocate a work queue for asynchronous video pump handler. */
+	video->async_wq = alloc_workqueue("uvcgadget", WQ_UNBOUND | WQ_HIGHPRI, 0);
+	if (!video->async_wq)
+		return -EINVAL;
+
 	video->uvc = uvc;
 	video->fcc = V4L2_PIX_FMT_YUYV;
 	video->bpp = 16;
-- 
2.35.1



