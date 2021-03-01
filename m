Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8E43283CB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhCAQYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235503AbhCAQVx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:21:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7973764EEF;
        Mon,  1 Mar 2021 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615525;
        bh=pHxPrlLkpEe6QqNK97i8KU4fsdrIu4fensom1O6PuaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5TjsqVSDl5ljG8668uCyVn1+QbT6ZUn6mjIrisHcPhfPlfU2JDZUhAcnv2xss7bo
         g7qmEVn6l7SApkhkb7QgSxProapGGbAV8tzZpxBieyqKpzRcazEVSl17bGK79ROi9x
         um7WHCXrVkWNXVKle4mF1DQEC/cETb6Pj/MGq1FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Till=20D=C3=B6rges?= <doerges@pre-sense.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 30/93] media: uvcvideo: Accept invalid bFormatIndex and bFrameIndex values
Date:   Mon,  1 Mar 2021 17:12:42 +0100
Message-Id: <20210301161008.393239605@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
index a0a544628053d..154f5bd45940e 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -243,7 +243,9 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 		goto done;
 
 	/* After the probe, update fmt with the values returned from
-	 * negotiation with the device.
+	 * negotiation with the device. Some devices return invalid bFormatIndex
+	 * and bFrameIndex values, in which case we can only assume they have
+	 * accepted the requested format as-is.
 	 */
 	for (i = 0; i < stream->nformats; ++i) {
 		if (probe->bFormatIndex == stream->format[i].index) {
@@ -252,11 +254,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
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
@@ -265,11 +266,10 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
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



