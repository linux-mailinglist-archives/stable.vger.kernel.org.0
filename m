Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316B537563D
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhEFPJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 11:09:32 -0400
Received: from www.linuxtv.org ([130.149.80.248]:59678 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234888AbhEFPJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 11:09:32 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1lefc4-007Gll-33; Thu, 06 May 2021 15:08:28 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 06 May 2021 15:05:45 +0000
Subject: [git:media_stage/master] media: i2c: ccs-core: fix pm_runtime_get_sync() usage count
To:     linuxtv-commits@linuxtv.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1lefc4-007Gll-33@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: i2c: ccs-core: fix pm_runtime_get_sync() usage count
Author:  Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:    Fri Apr 23 17:19:11 2021 +0200

The pm_runtime_get_sync() internally increments the
dev->power.usage_count without decrementing it, even on errors.

There is a bug at ccs_pm_get_init(): when this function returns
an error, the stream is not started, and RPM usage_count
should not be incremented. However, if the calls to
v4l2_ctrl_handler_setup() return errors, it will be kept
incremented.

At ccs_suspend() the best is to replace it by the new
pm_runtime_resume_and_get(), introduced by:
commit dd8088d5a896 ("PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter")
in order to properly decrement the usage counter automatically,
in the case of errors.

Fixes: 96e3a6b92f23 ("media: smiapp: Avoid maintaining power state information")
Cc: stable@vger.kernel.org
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/i2c/ccs/ccs-core.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

---

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index b05f409014b2..4a848ac2d2cd 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -1880,21 +1880,33 @@ static int ccs_pm_get_init(struct ccs_sensor *sensor)
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
 	int rval;
 
+	/*
+	 * It can't use pm_runtime_resume_and_get() here, as the driver
+	 * relies at the returned value to detect if the device was already
+	 * active or not.
+	 */
 	rval = pm_runtime_get_sync(&client->dev);
-	if (rval < 0) {
-		pm_runtime_put_noidle(&client->dev);
+	if (rval < 0)
+		goto error;
 
-		return rval;
-	} else if (!rval) {
-		rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->
-					       ctrl_handler);
-		if (rval)
-			return rval;
+	/* Device was already active, so don't set controls */
+	if (rval == 1)
+		return 0;
 
-		return v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
-	}
+	/* Restore V4L2 controls to the previously suspended device */
+	rval = v4l2_ctrl_handler_setup(&sensor->pixel_array->ctrl_handler);
+	if (rval)
+		goto error;
 
+	rval = v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
+	if (rval)
+		goto error;
+
+	/* Keep PM runtime usage_count incremented on success */
 	return 0;
+error:
+	pm_runtime_put(&client->dev);
+	return rval;
 }
 
 static int ccs_set_stream(struct v4l2_subdev *subdev, int enable)
