Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA377387F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbfGXTaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388256AbfGXTaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE06E20659;
        Wed, 24 Jul 2019 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996601;
        bh=2hx8cUTZuWP+77yvfyByCSbaY1wI1oEe9aok1bEUhzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6U5fTiwZ0a5NK7UnOEFm0Znb02RUJyXEiVP4FmZt4ZlzL6OGX5pYAjrdKizM9ydo
         YV1IXOvwTxlE5k/598s7wvJ0ZVYCGRU4bV4fC8EdrA3en1iJfb9qX+yUoTPiFRlGmW
         HUaOIBTQdQjeXq30G9Y+TZn85WNrxPLQ6X+kSQqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keith Pyle <kpyle@austin.rr.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 152/413] media: hdpvr: fix locking and a missing msleep
Date:   Wed, 24 Jul 2019 21:17:23 +0200
Message-Id: <20190724191745.870999790@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
index 7580fc5f2f12..6a6405b80797 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -435,7 +435,7 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 	/* wait for the first buffer */
 	if (!(file->f_flags & O_NONBLOCK)) {
 		if (wait_event_interruptible(dev->wait_data,
-					     hdpvr_get_next_buffer(dev)))
+					     !list_empty_careful(&dev->rec_buff_list)))
 			return -ERESTARTSYS;
 	}
 
@@ -461,10 +461,17 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
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
@@ -1127,9 +1134,7 @@ static void hdpvr_device_release(struct video_device *vdev)
 	struct hdpvr_device *dev = video_get_drvdata(vdev);
 
 	hdpvr_delete(dev);
-	mutex_lock(&dev->io_mutex);
 	flush_work(&dev->worker);
-	mutex_unlock(&dev->io_mutex);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
 	v4l2_ctrl_handler_free(&dev->hdl);
-- 
2.20.1



