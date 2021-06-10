Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFD3A3657
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 23:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhFJVrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 17:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhFJVrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 17:47:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0FCD613F1;
        Thu, 10 Jun 2021 21:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361513;
        bh=U2SlJFPjqiJGJhDgRDNbHFUEIsyVZohfiDYFhhApgy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQLTil0vvNlutEUpG12Ikto3B2DhHcmKtVokI6XgKkjxs/PCDysbczW+heGUqq0LT
         4VKprgunCKQSnh18vP3892sum7LizfE+a3Q9/6JLmshAuDbXIy6uzfao2RC0dgIYX+
         lMdF4vTiILcUoHMvmL/o/isR1WY9wsP6/0YciqTB8kIYkiSRskSEPkZRs/UkSsymJG
         qUJ1Oajr8CFiYbxZZi/ETq7oI8cUCnG1/lPF4J2oKJfMuLQtkBzkk5Uotv19qNwid+
         tYsXaQrXsG/AFfWnEDP9aJcXeGEjrSOuF1ZiL/4l8uYPPbqVLzxCA+ifXVDpUzNzNZ
         r/7PFr8FTJSdw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev, stable@vger.kernel.org
Subject: [PATCH v2 7/7] media: subdev: disallow ioctl for saa6588/davinci
Date:   Thu, 10 Jun 2021 23:43:05 +0200
Message-Id: <20210610214305.4170835-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210610214305.4170835-1-arnd@kernel.org>
References: <20210610214305.4170835-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
---
 drivers/media/i2c/saa6588.c                   | 4 ++--
 drivers/media/pci/bt8xx/bttv-driver.c         | 6 +++---
 drivers/media/pci/saa7134/saa7134-video.c     | 6 +++---
 drivers/media/platform/davinci/vpbe_display.c | 2 +-
 drivers/media/platform/davinci/vpbe_venc.c    | 6 ++----
 include/media/v4l2-subdev.h                   | 4 ++++
 6 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/saa6588.c b/drivers/media/i2c/saa6588.c
index ecb491d5f2ab..d1e0716bdfff 100644
--- a/drivers/media/i2c/saa6588.c
+++ b/drivers/media/i2c/saa6588.c
@@ -380,7 +380,7 @@ static void saa6588_configure(struct saa6588 *s)
 
 /* ---------------------------------------------------------------------- */
 
-static long saa6588_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+static long saa6588_command(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	struct saa6588 *s = to_saa6588(sd);
 	struct saa6588_command *a = arg;
@@ -433,7 +433,7 @@ static int saa6588_s_tuner(struct v4l2_subdev *sd, const struct v4l2_tuner *vt)
 /* ----------------------------------------------------------------------- */
 
 static const struct v4l2_subdev_core_ops saa6588_core_ops = {
-	.ioctl = saa6588_ioctl,
+	.command = saa6588_command,
 };
 
 static const struct v4l2_subdev_tuner_ops saa6588_tuner_ops = {
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 1f62a9d8ea1d..0e9df8b35ac6 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3179,7 +3179,7 @@ static int radio_release(struct file *file)
 
 	btv->radio_user--;
 
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_CLOSE, &cmd);
 
 	if (btv->radio_user == 0)
 		btv->has_radio_tuner = 0;
@@ -3260,7 +3260,7 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	cmd.result = -ENODEV;
 	radio_enable(btv);
 
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_READ, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_READ, &cmd);
 
 	return cmd.result;
 }
@@ -3281,7 +3281,7 @@ static __poll_t radio_poll(struct file *file, poll_table *wait)
 	cmd.instance = file;
 	cmd.event_list = wait;
 	cmd.poll_mask = res;
-	bttv_call_all(btv, core, ioctl, SAA6588_CMD_POLL, &cmd);
+	bttv_call_all(btv, core, command, SAA6588_CMD_POLL, &cmd);
 
 	return cmd.poll_mask;
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 0f9d6b9edb90..374c8e1087de 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1181,7 +1181,7 @@ static int video_release(struct file *file)
 
 	saa_call_all(dev, tuner, standby);
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
-		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
+		saa_call_all(dev, core, command, SAA6588_CMD_CLOSE, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return 0;
@@ -1200,7 +1200,7 @@ static ssize_t radio_read(struct file *file, char __user *data,
 	cmd.result = -ENODEV;
 
 	mutex_lock(&dev->lock);
-	saa_call_all(dev, core, ioctl, SAA6588_CMD_READ, &cmd);
+	saa_call_all(dev, core, command, SAA6588_CMD_READ, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return cmd.result;
@@ -1216,7 +1216,7 @@ static __poll_t radio_poll(struct file *file, poll_table *wait)
 	cmd.event_list = wait;
 	cmd.poll_mask = 0;
 	mutex_lock(&dev->lock);
-	saa_call_all(dev, core, ioctl, SAA6588_CMD_POLL, &cmd);
+	saa_call_all(dev, core, command, SAA6588_CMD_POLL, &cmd);
 	mutex_unlock(&dev->lock);
 
 	return rc | cmd.poll_mask;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index d19bad997f30..bf3c3e76b921 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -47,7 +47,7 @@ static int venc_is_second_field(struct vpbe_display *disp_dev)
 
 	ret = v4l2_subdev_call(vpbe_dev->venc,
 			       core,
-			       ioctl,
+			       command,
 			       VENC_GET_FLD,
 			       &val);
 	if (ret < 0) {
diff --git a/drivers/media/platform/davinci/vpbe_venc.c b/drivers/media/platform/davinci/vpbe_venc.c
index 8caa084e5704..bde241c26d79 100644
--- a/drivers/media/platform/davinci/vpbe_venc.c
+++ b/drivers/media/platform/davinci/vpbe_venc.c
@@ -521,9 +521,7 @@ static int venc_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
 	return ret;
 }
 
-static long venc_ioctl(struct v4l2_subdev *sd,
-			unsigned int cmd,
-			void *arg)
+static long venc_command(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
 {
 	u32 val;
 
@@ -542,7 +540,7 @@ static long venc_ioctl(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_core_ops venc_core_ops = {
-	.ioctl      = venc_ioctl,
+	.command      = venc_command,
 };
 
 static const struct v4l2_subdev_video_ops venc_video_ops = {
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 42aa1f6c7c3f..115b1e41e933 100644
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
 	long (*compat_ioctl32)(struct v4l2_subdev *sd, unsigned int cmd, void *arg);
-- 
2.29.2

