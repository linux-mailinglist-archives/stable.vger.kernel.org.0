Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2939D69752
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbfGON4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732785AbfGON4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:56:07 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCCD82086C;
        Mon, 15 Jul 2019 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198966;
        bh=uMXwY+utQlYgUVFfRs3t6FU1guKx6DjSmDsESwfCTEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttKFG2NWcJcCeFaUvc/DTUSBeLdXuL+a8ytyNdnVXoAT2IEizjzcHBgI5A5Iokesz
         kKFP8Jvko6HNpLWWmxuN7WlM+RDqSx9bE1ncMK80ayNi7AWdSxwG55ciUfprEfQUgk
         X6g7XoOrr/UJBaVMxNaLP8fuBKReY4WzUflpyZ9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Keith Pyle <kpyle@austin.rr.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 155/249] media: hdpvr: fix locking and a missing msleep
Date:   Mon, 15 Jul 2019 09:45:20 -0400
Message-Id: <20190715134655.4076-155-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

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

