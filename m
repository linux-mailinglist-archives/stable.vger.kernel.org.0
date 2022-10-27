Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8065260FE0F
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiJ0RBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236832AbiJ0RBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:01:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC3F18A003
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF3D1B824DB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B88CC433D6;
        Thu, 27 Oct 2022 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890101;
        bh=KrRYlPGQynvcoD19wUnsGywiM7M3EFf5vrk88XWMTZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apyIRBrX+OVvqCxfN2QvIY8lfAYalrkPxklIBNngbnh0ysR7REzB0PkynOCT7bL/c
         OiWdMWOzcACHCjVCWA1gpNZo79s2bPoOpC6qe2Z9n4XHtDCCyO0ixACNOhY1OkPUaB
         +xS8Nf0PdkxEE4W9wjIrRUGYWEbigVhk7GtF9tEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dan Vacura <w36195@motorola.com>
Subject: [PATCH 5.15 03/79] usb: gadget: uvc: consistently use define for headerlen
Date:   Thu, 27 Oct 2022 18:55:01 +0200
Message-Id: <20221027165055.038620713@linuxfoundation.org>
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

commit 859c675d84d488e2f9b515c713ea890c9f045f0c upstream.

The uvc request headerlen of 2 was defined as UVCG_REQUEST_HEADER_LEN
in commit e81e7f9a0eb9 ("usb: gadget: uvc: add scatter gather support").
We missed to use it consistently. This patch fixes that.

Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20211018072059.11465-1-m.grzeschik@pengutronix.de
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dan Vacura <w36195@motorola.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/uvc.h       |    4 +++-
 drivers/usb/gadget/function/uvc_video.c |    6 +++---
 drivers/usb/gadget/function/uvc_video.h |    2 --
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -69,6 +69,8 @@ extern unsigned int uvc_gadget_trace_par
 #define UVC_MAX_REQUEST_SIZE			64
 #define UVC_MAX_EVENTS				4
 
+#define UVCG_REQUEST_HEADER_LEN			2
+
 /* ------------------------------------------------------------------------
  * Structures
  */
@@ -77,7 +79,7 @@ struct uvc_request {
 	u8 *req_buffer;
 	struct uvc_video *video;
 	struct sg_table sgt;
-	u8 header[2];
+	u8 header[UVCG_REQUEST_HEADER_LEN];
 };
 
 struct uvc_video {
--- a/drivers/usb/gadget/function/uvc_video.c
+++ b/drivers/usb/gadget/function/uvc_video.c
@@ -33,7 +33,7 @@ uvc_video_encode_header(struct uvc_video
 	if (buf->bytesused - video->queue.buf_used <= len - UVCG_REQUEST_HEADER_LEN)
 		data[1] |= UVC_STREAM_EOF;
 
-	return 2;
+	return UVCG_REQUEST_HEADER_LEN;
 }
 
 static int
@@ -302,8 +302,8 @@ uvc_video_alloc_requests(struct uvc_vide
 		list_add_tail(&video->ureq[i].req->list, &video->req_free);
 		/* req_size/PAGE_SIZE + 1 for overruns and + 1 for header */
 		sg_alloc_table(&video->ureq[i].sgt,
-			       DIV_ROUND_UP(req_size - 2, PAGE_SIZE) + 2,
-			       GFP_KERNEL);
+			       DIV_ROUND_UP(req_size - UVCG_REQUEST_HEADER_LEN,
+					    PAGE_SIZE) + 2, GFP_KERNEL);
 	}
 
 	video->req_size = req_size;
--- a/drivers/usb/gadget/function/uvc_video.h
+++ b/drivers/usb/gadget/function/uvc_video.h
@@ -12,8 +12,6 @@
 #ifndef __UVC_VIDEO_H__
 #define __UVC_VIDEO_H__
 
-#define UVCG_REQUEST_HEADER_LEN			2
-
 struct uvc_video;
 
 int uvcg_video_enable(struct uvc_video *video, int enable);


