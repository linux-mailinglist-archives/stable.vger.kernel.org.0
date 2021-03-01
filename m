Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3D532847C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhCAQgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:36:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:36930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhCAQaI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:30:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8D7964EE2;
        Mon,  1 Mar 2021 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615820;
        bh=/pQHnMuAejkyeUcMTUlha1OzfNW60oKJFy4c+C1WALA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoNEVPVe6GvpcYckiwxs9JWTZd0yll2D01Le7dE0xPcxweGr+YojIlEjfalZk6xV/
         81dLDL1CR3vwC+KGU/K9eOYmEMQknWLe/wGR2iUjz00QPV+yvD1quAE0lSnmtKVbVS
         a61jXcbXzHvo7fdGAJRlNPIhnW5WuEXTdCgIjAj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Till=20D=C3=B6rges?= <doerges@pre-sense.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 042/134] media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values
Date:   Mon,  1 Mar 2021 17:12:23 +0100
Message-Id: <20210301161015.640909840@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
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
index 5156c971c241c..6a19cf94705b1 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -258,7 +258,9 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		goto done;
 
 	/* After the probe, update fmt with the values returned from
-	 * negotiation with the device.
+	 * negotiation with the device. Some devices return invalid bFormatIndex
+	 * and bFrameIndex values, in which case we can only assume they have
+	 * accepted the requested format as-is.
 	 */
 	for (i = 0; i < stream->nformats; ++i) {
 		if (probe->bFormatIndex == stream->format[i].index) {
@@ -267,11 +269,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
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
@@ -280,11 +281,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
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



