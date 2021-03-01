Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5A6328B9E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbhCASiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239362AbhCAS3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:29:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAD846534C;
        Mon,  1 Mar 2021 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620677;
        bh=54KiUnhgH/gu9nF7H3ne4ivMcs82IRwTkSTLS8uXcek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SJNXE3yUqpwb2s9E4+ly8he7jvqWgrXPWvBn0gKIJAh0QVmuDB48BFWPFXXpTE8C
         c+9TLYz9rUtNLu1GrRKp07qENZeGppn5A7FO/+uVTw0mymJdQNWN0J5vz7Y8o3z8mR
         2HSsTkUgOt7I0tO5i3JO5bhvOowyLwq7qVoX/H/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Till=20D=C3=B6rges?= <doerges@pre-sense.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 232/775] media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values
Date:   Mon,  1 Mar 2021 17:06:40 +0100
Message-Id: <20210301161213.094236945@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit dc9455ffae02d7b7fb51ba1e007fffcb9dc5d890 ]

The Renkforce RF AC4K 300 Action Cam 4K reports invalid bFormatIndex and
bFrameIndex values when negotiating the video probe and commit controls.
The UVC descriptors report a single supported format and frame size,
with bFormatIndex and bFrameIndex both equal to 2, but the video probe
and commit controls report bFormatIndex and bFrameIndex set to 1.

The device otherwise operates correctly, but the driver rejects the
values and fails the format try operation. Fix it by ignoring the
invalid indices, and assuming that the format and frame requested by the
driver are accepted by the device.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210767

Fixes: 8a652a17e3c0 ("media: uvcvideo: Ensure all probed info is returned to v4l2")
Reported-by: Till Dörges <doerges@pre-sense.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index fa06bfa174ad3..c7172b8952a96 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -248,7 +248,9 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		goto done;
 
 	/* After the probe, update fmt with the values returned from
-	 * negotiation with the device.
+	 * negotiation with the device. Some devices return invalid bFormatIndex
+	 * and bFrameIndex values, in which case we can only assume they have
+	 * accepted the requested format as-is.
 	 */
 	for (i = 0; i < stream->nformats; ++i) {
 		if (probe->bFormatIndex == stream->format[i].index) {
@@ -257,11 +259,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		}
 	}
 
-	if (i == stream->nformats) {
-		uvc_trace(UVC_TRACE_FORMAT, "Unknown bFormatIndex %u\n",
+	if (i == stream->nformats)
+		uvc_trace(UVC_TRACE_FORMAT,
+			  "Unknown bFormatIndex %u, using default\n",
 			  probe->bFormatIndex);
-		return -EINVAL;
-	}
 
 	for (i = 0; i < format->nframes; ++i) {
 		if (probe->bFrameIndex == format->frame[i].bFrameIndex) {
@@ -270,11 +271,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		}
 	}
 
-	if (i == format->nframes) {
-		uvc_trace(UVC_TRACE_FORMAT, "Unknown bFrameIndex %u\n",
+	if (i == format->nframes)
+		uvc_trace(UVC_TRACE_FORMAT,
+			  "Unknown bFrameIndex %u, using default\n",
 			  probe->bFrameIndex);
-		return -EINVAL;
-	}
 
 	fmt->fmt.pix.width = frame->wWidth;
 	fmt->fmt.pix.height = frame->wHeight;
-- 
2.27.0



