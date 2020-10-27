Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132F529C3AA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822085AbgJ0Rqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901747AbgJ0O0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:26:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8AB020780;
        Tue, 27 Oct 2020 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808776;
        bh=jzixibnVqADsXqp386tcfGlnYtondXrkH56p0NvQJIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8EhN4Zf2ZYkQezPbSrDJ+sT5c8a1RMaE2kYpDG4AGBwtVnJ23QxxZrxIfYriUCxj
         eUeNWkIE4Mkwh5Ri5YxWrGdclvHo0xF4mi/8K9wkMyWkXgBea7irmRkIJRBMAI0aYK
         aWoEd4eFNzYJWTqwaADRFfWvVcH2CFj+1AeWZdto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Goode <agoode@google.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 220/264] media: uvcvideo: Ensure all probed info is returned to v4l2
Date:   Tue, 27 Oct 2020 14:54:38 +0100
Message-Id: <20201027135441.013473726@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Goode <agoode@google.com>

[ Upstream commit 8a652a17e3c005dcdae31b6c8fdf14382a29cbbe ]

bFrameIndex and bFormatIndex can be negotiated by the camera during
probing, resulting in the camera choosing a different format than
expected. v4l2 can already accommodate such changes, but the code was
not updating the proper fields.

Without such a change, v4l2 would potentially interpret the payload
incorrectly, causing corrupted output. This was happening on the
Elgato HD60 S+, which currently always renegotiates to format 1.

As an aside, the Elgato firmware is buggy and should not be renegotating,
but it is still a valid thing for the camera to do. Both macOS and Windows
will properly probe and read uncorrupted images from this camera.

With this change, both qv4l2 and chromium can now read uncorrupted video
from the Elgato HD60 S+.

[Add blank lines, remove periods at the of messages]

Signed-off-by: Adam Goode <agoode@google.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 18a7384b50ee9..0921c95a1dca5 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -252,11 +252,41 @@ static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	if (ret < 0)
 		goto done;
 
+	/* After the probe, update fmt with the values returned from
+	 * negotiation with the device.
+	 */
+	for (i = 0; i < stream->nformats; ++i) {
+		if (probe->bFormatIndex == stream->format[i].index) {
+			format = &stream->format[i];
+			break;
+		}
+	}
+
+	if (i == stream->nformats) {
+		uvc_trace(UVC_TRACE_FORMAT, "Unknown bFormatIndex %u\n",
+			  probe->bFormatIndex);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < format->nframes; ++i) {
+		if (probe->bFrameIndex == format->frame[i].bFrameIndex) {
+			frame = &format->frame[i];
+			break;
+		}
+	}
+
+	if (i == format->nframes) {
+		uvc_trace(UVC_TRACE_FORMAT, "Unknown bFrameIndex %u\n",
+			  probe->bFrameIndex);
+		return -EINVAL;
+	}
+
 	fmt->fmt.pix.width = frame->wWidth;
 	fmt->fmt.pix.height = frame->wHeight;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = uvc_v4l2_get_bytesperline(format, frame);
 	fmt->fmt.pix.sizeimage = probe->dwMaxVideoFrameSize;
+	fmt->fmt.pix.pixelformat = format->fcc;
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
 
-- 
2.25.1



