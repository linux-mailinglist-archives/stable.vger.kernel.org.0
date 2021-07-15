Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAFEA3CA7DD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbhGOS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:60956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241626AbhGOS4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1348C610C7;
        Thu, 15 Jul 2021 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375195;
        bh=wgMUYY297IOhQDEnEC/T2HWG2Zw/r1nI75OPaBAx6P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mh1/7GL7Edhp0mK5BPtOMpOCB9BMlMTEGiK39Vea7ohrurG1Kz4DYBdqM3bd2hnlv
         DHR0REHwNkAUDYMf8jVwN/l+rIZj/1/mOdg9goH2IyAYzMX++M9lMSsOZwvL9iHr9M
         2O8sg9qpwjFmSqOevZMiQQoYgsl3ufCXLAqES2ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 201/215] media: subdev: disallow ioctl for saa6588/davinci
Date:   Thu, 15 Jul 2021 20:39:33 +0200
Message-Id: <20210715182634.698132638@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 0a7790be182d32b9b332a37cb4206e24fe94b728 upstream.

The saa6588_ioctl() function expects to get called from other kernel
functions with a 'saa6588_command' pointer, but I found nothing stops it
from getting called from user space instead, which seems rather dangerous.

The same thing happens in the davinci vpbe driver with its VENC_GET_FLD
command.

As a quick fix, add a separate .command() callback pointer for this
driver and change the two callers over to that.  This change can easily
get backported to stable kernels if necessary, but since there are only
two drivers, we may want to eventually replace this with a set of more
specialized callbacks in the long run.

Fixes: c3fda7f835b0 ("V4L/DVB (10537): saa6588: convert to v4l2_subdev.")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/saa6588.c                   |    4 ++--
 drivers/media/pci/bt8xx/bttv-driver.c         |    6 +++---
 drivers/media/pci/saa7134/saa7134-video.c     |    6 +++---
 drivers/media/platform/davinci/vpbe_display.c |    2 +-
 drivers/media/platform/davinci/vpbe_venc.c    |    6 ++----
 include/media/v4l2-subdev.h                   |    4 ++++
 6 files changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -380,7 +380,7 @@ static void saa6588_configure(struct saa
 
 /* ---------------------------------------------------------------------- */
 
-static long saa6588_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+static long saa6588_command(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	struct saa6588 *s = to_saa6588(sd);
 	struct saa6588_command *a = arg;
@@ -433,7 +433,7 @@ static int saa6588_s_tuner(struct v4l2_s
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa6588_core_ops = {
-	.ioctl = saa6588_ioctl,
+	.command = saa6588_command,
 };
 
 static const struct v4l2_subdev_tuner_ops saa6588_tuner_ops = {
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3187,7 +3187,7 @@ static int radio_release(struct file *fi
 
 	btv->radio_user--;
 
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_CLOSE, &cmd);
 
 	if (btv->radio_user == 0)
 		btv->has_radio_tuner = 0;
@@ -3268,7 +3268,7 @@ static ssize_t radio_read(struct file *f
 	cmd.result = -ENODEV;
 	radio_enable(btv);
 
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_READ, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_READ, &cmd);
 
 	return cmd.result;
 }
@@ -3289,7 +3289,7 @@ static __poll_t radio_poll(struct file *
 	cmd.instance = file;
 	cmd.event_list = wait;
 	cmd.poll_mask = res;
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_POLL, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_POLL, &cmd);
 
 	return cmd.poll_mask;
 }
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1178,7 +1178,7 @@ static int video_release(struct file *fi
 
 	saa_call_all(dev, tuner, standby);
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
-		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
+		saa_call_all(dev, core, command, SAA6588_CMD_CLOSE, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return 0;
@@ -1197,7 +1197,7 @@ static ssize_t radio_read(struct file *f
 	cmd.result = -ENODEV;
 
 	mutex_lock(&dev->lock);
-	saa_call_all(dev, core, ioctl, SAA6588_CMD_READ, &cmd);
+	saa_call_all(dev, core, command, SAA6588_CMD_READ, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return cmd.result;
@@ -1213,7 +1213,7 @@ static __poll_t radio_poll(struct file *
 	cmd.event_list = wait;
 	cmd.poll_mask = 0;
 	mutex_lock(&dev->lock);
-	saa_call_all(dev, core, ioctl, SAA6588_CMD_POLL, &cmd);
+	saa_call_all(dev, core, command, SAA6588_CMD_POLL, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return rc | cmd.poll_mask;
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -47,7 +47,7 @@ static int venc_is_second_field(struct v
 
 	ret = v4l2_subdev_call(vpbe_dev->venc,
 			       core,
-			       ioctl,
+			       command,
 			       VENC_GET_FLD,
 			       &val);
 	if (ret < 0) {
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -521,9 +521,7 @@ static int venc_s_routing(struct v4l2_su
 	return ret;
 }
 
-static long venc_ioctl(struct v4l2_subdev *sd,
-			unsigned int cmd,
-			void *arg)
+static long venc_command(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	u32 val;
 
@@ -542,7 +540,7 @@ static long venc_ioctl(struct v4l2_subde
 }
 
 static const struct v4l2_subdev_core_ops venc_core_ops = {
-	.ioctl      = venc_ioctl,
+	.command      = venc_command,
 };
 
 static const struct v4l2_subdev_video_ops venc_video_ops = {
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -162,6 +162,9 @@ struct v4l2_subdev_io_pin_config {
  * @s_gpio: set GPIO pins. Very simple right now, might need to be extended with
  *	a direction argument if needed.
  *
+ * @command: called by in-kernel drivers in order to call functions internal
+ *	   to subdev drivers driver that have a separate callback.
+ *
  * @ioctl: called at the end of ioctl() syscall handler at the V4L2 core.
  *	   used to provide support for private ioctls used on the driver.
  *
@@ -193,6 +196,7 @@ struct v4l2_subdev_core_ops {
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);
 	int (*s_gpio)(struct v4l2_subdev *sd, u32 val);
+	long (*command)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 	long (*ioctl)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
 #ifdef CONFIG_COMPAT
 	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd,


