Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6188C73A65
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbfGXTtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:49:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403959AbfGXTth (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:49:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE7B5205C9;
        Wed, 24 Jul 2019 19:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997776;
        bh=A/rPlotiUBdd6Ut7xAxWild2wBPbAF4WhSQSnn43H4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kj1R0xhWt/XHxWBUqmI8nEL2ZkeESxWofZ4v1Nqqk1nxSXwhSc/wq/Ql5xb6fOxcr
         4kTfP9zT25/VCj2AwznKlofweqh0SnWdGDnPnhprzVYuJ2bnOHPE+A0a+arahkl1sB
         CvV1hvJULC5cgyc5O8s8VrPd0d09o3oyHjhCfBRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Pyle <kpyle@austin.rr.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 139/371] media: hdpvr: fix locking and a missing msleep
Date:   Wed, 24 Jul 2019 21:18:11 +0200
Message-Id: <20190724191735.432727354@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6bc5a4a1927556ff9adce1aa95ea408c95453225 ]

This driver has three locking issues:

- The wait_event_interruptible() condition calls hdpvr_get_next_buffer(dev)
  which uses a mutex, which is not allowed. Rewrite with list_empty_careful()
  that doesn't need locking.

- In hdpvr_read() the call to hdpvr_stop_streaming() didn't lock io_mutex,
  but it should have since stop_streaming expects that.

- In hdpvr_device_release() io_mutex was locked when calling flush_work(),
  but there it shouldn't take that mutex since the work done by flush_work()
  also wants to lock that mutex.

There are also two other changes (suggested by Keith):

- msecs_to_jiffies(4000); (a NOP) should have been msleep(4000).
- Change v4l2_dbg to v4l2_info to always log if streaming had to be restarted.

Reported-by: Keith Pyle <kpyle@austin.rr.com>
Suggested-by: Keith Pyle <kpyle@austin.rr.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index e082086428a4..ae6609716347 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -439,7 +439,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 	/* wait for the first buffer */
 	if (!(file->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(dev->wait_data,
-					     hdpvr_get_next_buffer(dev)))
+					     !list_empty_careful(&dev->rec_buff_list)))
 			return -ERESTARTSYS;
 	}
 
@@ -465,10 +465,17 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 				goto err;
 			}
 			if (!err) {
-				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-					"timeout: restart streaming\n");
+				v4l2_info(&dev->v4l2_dev,
+					  "timeout: restart streaming\n");
+				mutex_lock(&dev->io_mutex);
 				hdpvr_stop_streaming(dev);
-				msecs_to_jiffies(4000);
+				mutex_unlock(&dev->io_mutex);
+				/*
+				 * The FW needs about 4 seconds after streaming
+				 * stopped before it is ready to restart
+				 * streaming.
+				 */
+				msleep(4000);
 				err = hdpvr_start_streaming(dev);
 				if (err) {
 					ret = err;
@@ -1133,9 +1140,7 @@ static void hdpvr_device_release(struct video_device *vdev)
 	struct hdpvr_device *dev = video_get_drvdata(vdev);
 
 	hdpvr_delete(dev);
-	mutex_lock(&dev->io_mutex);
 	flush_work(&dev->worker);
-	mutex_unlock(&dev->io_mutex);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	v4l2_ctrl_handler_free(&dev->hdl);
-- 
2.20.1



