Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9B626CD4
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbfEVThd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733194AbfEVTaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C0D8217D7;
        Wed, 22 May 2019 19:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553415;
        bh=sggYvIFTjVwlhubVJZzr4XZFhH5kkvKII9OXtKTlSPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V70evVROENHgfIw93Qr/C0tUiSGP0Gx6LK1eE4VeHRtmTjY/16WjVUKyfNR+SL5KN
         C6//ZE/sn3jFX1XYlV8gYbQ/43w7OBv6slmXUoVLh5LOs57967m2+tGgb0aIMP+IJM
         ++RyEOnLniwclgI4jGAHNLwoeHVMRA3Xdvgih3Y4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Shuah Khan <shuah@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 061/167] media: au0828: stop video streaming only when last user stops
Date:   Wed, 22 May 2019 15:26:56 -0400
Message-Id: <20190522192842.25858-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192842.25858-1-sashal@kernel.org>
References: <20190522192842.25858-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit f604f0f5afb88045944567f604409951b5eb6af8 ]

If the application was streaming from both videoX and vbiX, and streaming
from videoX was stopped, then the vbi streaming also stopped.

The cause being that stop_streaming for video stopped the subdevs as well,
instead of only doing that if dev->streaming_users reached 0.

au0828_stop_vbi_streaming was also wrong since it didn't stop the subdevs
at all when dev->streaming_users reached 0.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Tested-by: Shuah Khan <shuah@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/au0828/au0828-video.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 9342402b92f76..7cd2daf869895 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -839,9 +839,9 @@ int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 			return rc;
 		}
 
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 1);
+
 		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-			v4l2_device_call_all(&dev->v4l2_dev, 0, video,
-						s_stream, 1);
 			dev->vid_timeout_running = 1;
 			mod_timer(&dev->vid_timeout, jiffies + (HZ / 10));
 		} else if (vq->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
@@ -861,10 +861,11 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 
 	dprintk(1, "au0828_stop_streaming called %d\n", dev->streaming_users);
 
-	if (dev->streaming_users-- == 1)
+	if (dev->streaming_users-- == 1) {
 		au0828_uninit_isoc(dev);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	}
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
 	dev->vid_timeout_running = 0;
 	del_timer_sync(&dev->vid_timeout);
 
@@ -893,8 +894,10 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
 	dprintk(1, "au0828_stop_vbi_streaming called %d\n",
 		dev->streaming_users);
 
-	if (dev->streaming_users-- == 1)
+	if (dev->streaming_users-- == 1) {
 		au0828_uninit_isoc(dev);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	}
 
 	spin_lock_irqsave(&dev->slock, flags);
 	if (dev->isoc_ctl.vbi_buf != NULL) {
-- 
2.20.1

