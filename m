Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EFF1016D9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731940AbfKSFwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731891AbfKSFwg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:52:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E41920862;
        Tue, 19 Nov 2019 05:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142756;
        bh=cWDR+bK9eieHFdL6aHLtdxeVnto+yzXb3nykupc4aDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6WJiWmZfuEPR9HnPmIVDz+QOnpuuh+eeK5LgKQ/CpicJoYyRnQkKLdOyEOwU2enh
         w0xjSjvIbmgaAZQUYVdqMX3DRdhFWxH06l2MInKzswkkqQyHYPO3o99PbWKuqcXcXm
         8BNjRZGmbecaYwFOfGoPl5aHdG6LPKvUtTxtUPgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 189/239] usb: gadget: uvc: Factor out video USB request queueing
Date:   Tue, 19 Nov 2019 06:19:49 +0100
Message-Id: <20191119051335.384312441@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 9d1ff5dcb3cd3390b1e56f1c24ae42c72257c4a3 ]

USB requests for video data are queued from two different locations in
the driver, with the same code block occurring twice. Factor it out to a
function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Tested-by: Paul Elder <paul.elder@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_video.c | 30 ++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
index 0f01c04d7cbd8..540917f54506a 100644
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -129,6 +129,19 @@ uvc_video_encode_isoc(struct usb_request *req, struct uvc_video *video,
  * Request handling
  */
 
+static int uvcg_video_ep_queue(struct uvc_video *video, struct usb_request *req)
+{
+	int ret;
+
+	ret = usb_ep_queue(video->ep, req, GFP_ATOMIC);
+	if (ret < 0) {
+		printk(KERN_INFO "Failed to queue request (%d).\n", ret);
+		usb_ep_set_halt(video->ep);
+	}
+
+	return ret;
+}
+
 /*
  * I somehow feel that synchronisation won't be easy to achieve here. We have
  * three events that control USB requests submission:
@@ -193,14 +206,13 @@ uvc_video_complete(struct usb_ep *ep, struct usb_request *req)
 
 	video->encode(req, video, buf);
 
-	if ((ret = usb_ep_queue(ep, req, GFP_ATOMIC)) < 0) {
-		printk(KERN_INFO "Failed to queue request (%d).\n", ret);
-		usb_ep_set_halt(ep);
-		spin_unlock_irqrestore(&video->queue.irqlock, flags);
+	ret = uvcg_video_ep_queue(video, req);
+	spin_unlock_irqrestore(&video->queue.irqlock, flags);
+
+	if (ret < 0) {
 		uvcg_queue_cancel(queue, 0);
 		goto requeue;
 	}
-	spin_unlock_irqrestore(&video->queue.irqlock, flags);
 
 	return;
 
@@ -320,15 +332,13 @@ int uvcg_video_pump(struct uvc_video *video)
 		video->encode(req, video, buf);
 
 		/* Queue the USB request */
-		ret = usb_ep_queue(video->ep, req, GFP_ATOMIC);
+		ret = uvcg_video_ep_queue(video, req);
+		spin_unlock_irqrestore(&queue->irqlock, flags);
+
 		if (ret < 0) {
-			printk(KERN_INFO "Failed to queue request (%d)\n", ret);
-			usb_ep_set_halt(video->ep);
-			spin_unlock_irqrestore(&queue->irqlock, flags);
 			uvcg_queue_cancel(queue, 0);
 			break;
 		}
-		spin_unlock_irqrestore(&queue->irqlock, flags);
 	}
 
 	spin_lock_irqsave(&video->req_lock, flags);
-- 
2.20.1



