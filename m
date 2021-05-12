Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD34137C929
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbhELQPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235911AbhELQIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C3B61C56;
        Wed, 12 May 2021 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833942;
        bh=W7sRdJja8u8Y1em2AhWUheojl7Jevo4JmX+eVWGe+qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xm1BD60dz+DTUYzsRw5R6g1t1QzY0B08/4opCooqXAQEcpw0ZsXXyIA8E7RtilNES
         BSCXCGVxrx8f6cybiho/Iq+NggWhQ/j3QktmgVnOtmn3+n3rk/PWIeP32S1cgj1jtt
         ZC5VECZTWvroWC8PqisxrXFKh+D7ihtLoI1FAwT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 348/601] media: i2c: imx219: Balance runtime PM use-count
Date:   Wed, 12 May 2021 16:47:05 +0200
Message-Id: <20210512144839.259172197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit dd90caa0111e178b52b21e56364bc2244a3973b3 ]

Move incrementing/decrementing runtime PM count to
imx219_start_streaming()/imx219_stop_streaming() functions respectively.

This fixes an issue of unbalanced runtime PM count in resume callback
error path where streaming is stopped and runtime PM count is left
unbalanced.

Fixes: 1283b3b8f82b9 ("media: i2c: Add driver for Sony IMX219 sensor")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 98f0a13a7382..ad5cdbfd1d75 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -1024,37 +1024,47 @@ static int imx219_start_streaming(struct imx219 *imx219)
 	const struct imx219_reg_list *reg_list;
 	int ret;
 
+	ret = pm_runtime_get_sync(&client->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(&client->dev);
+		return ret;
+	}
+
 	/* Apply default values of current mode */
 	reg_list = &imx219->mode->reg_list;
 	ret = imx219_write_regs(imx219, reg_list->regs, reg_list->num_of_regs);
 	if (ret) {
 		dev_err(&client->dev, "%s failed to set mode\n", __func__);
-		return ret;
+		goto err_rpm_put;
 	}
 
 	ret = imx219_set_framefmt(imx219);
 	if (ret) {
 		dev_err(&client->dev, "%s failed to set frame format: %d\n",
 			__func__, ret);
-		return ret;
+		goto err_rpm_put;
 	}
 
 	/* Apply customized values from user */
 	ret =  __v4l2_ctrl_handler_setup(imx219->sd.ctrl_handler);
 	if (ret)
-		return ret;
+		goto err_rpm_put;
 
 	/* set stream on register */
 	ret = imx219_write_reg(imx219, IMX219_REG_MODE_SELECT,
 			       IMX219_REG_VALUE_08BIT, IMX219_MODE_STREAMING);
 	if (ret)
-		return ret;
+		goto err_rpm_put;
 
 	/* vflip and hflip cannot change during streaming */
 	__v4l2_ctrl_grab(imx219->vflip, true);
 	__v4l2_ctrl_grab(imx219->hflip, true);
 
 	return 0;
+
+err_rpm_put:
+	pm_runtime_put(&client->dev);
+	return ret;
 }
 
 static void imx219_stop_streaming(struct imx219 *imx219)
@@ -1070,12 +1080,13 @@ static void imx219_stop_streaming(struct imx219 *imx219)
 
 	__v4l2_ctrl_grab(imx219->vflip, false);
 	__v4l2_ctrl_grab(imx219->hflip, false);
+
+	pm_runtime_put(&client->dev);
 }
 
 static int imx219_set_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct imx219 *imx219 = to_imx219(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int ret = 0;
 
 	mutex_lock(&imx219->mutex);
@@ -1085,22 +1096,15 @@ static int imx219_set_stream(struct v4l2_subdev *sd, int enable)
 	}
 
 	if (enable) {
-		ret = pm_runtime_get_sync(&client->dev);
-		if (ret < 0) {
-			pm_runtime_put_noidle(&client->dev);
-			goto err_unlock;
-		}
-
 		/*
 		 * Apply default & customized values
 		 * and then start streaming.
 		 */
 		ret = imx219_start_streaming(imx219);
 		if (ret)
-			goto err_rpm_put;
+			goto err_unlock;
 	} else {
 		imx219_stop_streaming(imx219);
-		pm_runtime_put(&client->dev);
 	}
 
 	imx219->streaming = enable;
@@ -1109,8 +1113,6 @@ static int imx219_set_stream(struct v4l2_subdev *sd, int enable)
 
 	return ret;
 
-err_rpm_put:
-	pm_runtime_put(&client->dev);
 err_unlock:
 	mutex_unlock(&imx219->mutex);
 
-- 
2.30.2



