Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1548E5A2
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237037AbiANITz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:19:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59862 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239757AbiANITL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:19:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AA76B823E6;
        Fri, 14 Jan 2022 08:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFBAC36AE9;
        Fri, 14 Jan 2022 08:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148348;
        bh=8S1hAOaCE0nuCTYKqPbrUYjfJ4XAy3sfQgAufqi6aas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/KsCbZw+kvoRWjthJ/x3CyOcFxcGwfqTP9bvui4kXjzQIitbIT5zpAzss2jTa0pj
         GF3VxQmE47FkgoFJPCt/DUyke7SxR1wIxnxdSkndKR9fWlih6XGogkgeFPi2OaS2vj
         X3gNss/2xUAVZCIvl7qPf8dwjpItpSMtSJJZdjZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 22/25] media: Revert "media: uvcvideo: Set unique vdev name based in type"
Date:   Fri, 14 Jan 2022 09:16:30 +0100
Message-Id: <20220114081543.457330482@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081542.698002137@linuxfoundation.org>
References: <20220114081542.698002137@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

commit f66dcb32af19faf49cc4a9222c3152b10c6ec84a upstream.

A lot of userspace depends on a descriptive name for vdev. Without this
patch, users have a hard time figuring out which camera shall they use
for their video conferencing.

This reverts commit e3f60e7e1a2b451f538f9926763432249bcf39c4.

Link: https://lore.kernel.org/linux-media/20211207003840.1212374-2-ribalda@chromium.org
Cc: <stable@vger.kernel.org>
Fixes: e3f60e7e1a2b ("media: uvcvideo: Set unique vdev name based in type")
Reported-by: Nicolas Dufresne <nicolas@ndufresne.ca>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2065,7 +2065,6 @@ int uvc_register_video_device(struct uvc
 			      const struct v4l2_file_operations *fops,
 			      const struct v4l2_ioctl_ops *ioctl_ops)
 {
-	const char *name;
 	int ret;
 
 	/* Initialize the video buffers queue. */
@@ -2094,20 +2093,16 @@ int uvc_register_video_device(struct uvc
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	default:
 		vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Video Capture";
 		break;
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
-		name = "Video Output";
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
-		name = "Metadata";
 		break;
 	}
 
-	snprintf(vdev->name, sizeof(vdev->name), "%s %u", name,
-		 stream->header.bTerminalLink);
+	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise


