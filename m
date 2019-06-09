Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88B653A87E
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732850AbfFIRBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387977AbfFIRBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9EF7204EC;
        Sun,  9 Jun 2019 17:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099665;
        bh=q9DT7E2hEWC+QTIvUN7fwvH/GC0dUAlOfDHYjUaAZCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLPG7Tx5fOnBdC4LBKZwWYwm3SgsUz104XQ7a+24u0aQzZ48NM4Lm/cCwAq88gA2Z
         JT8frJzIXt3yK1HjQ1a7LKvlYWYN5nbSOzLILzeK9YakDN/DWt3S6ZH8cliEW4S9JD
         w1Jc17pKj2jGNcgOGzbgCsEO2j06MwGwEzeQ+9cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Shuah Khan <shuah@kernel.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 120/241] media: au0828: stop video streaming only when last user stops
Date:   Sun,  9 Jun 2019 18:41:02 +0200
Message-Id: <20190609164151.264901801@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 7b2fe1b56039e..1ff66e7e26a81 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -799,9 +799,9 @@ int au0828_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
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
@@ -821,10 +821,11 @@ static void au0828_stop_streaming(struct vb2_queue *vq)
 
 	dprintk(1, "au0828_stop_streaming called %d\n", dev->streaming_users);
 
-	if (dev->streaming_users-- == 1)
+	if (dev->streaming_users-- == 1) {
 		au0828_uninit_isoc(dev);
+		v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
+	}
 
-	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
 	dev->vid_timeout_running = 0;
 	del_timer_sync(&dev->vid_timeout);
 
@@ -853,8 +854,10 @@ void au0828_stop_vbi_streaming(struct vb2_queue *vq)
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



