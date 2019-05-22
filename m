Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F02F326C67
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387505AbfEVTbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbfEVTbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:31:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0AB20675;
        Wed, 22 May 2019 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553483;
        bh=225Y7Vtr5DPI6TB0HSY161Ttc/DawvEBG9GJQsH31aM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=je53LQMtTCMNtvBKOv/6z2kRJR/9C1/ZuYwVJfiqfaeaKV8ap6u3ZX/HNOoR9MVCb
         j4NonLdklb51b6QJRQmGIgxVVRoxt1B/jUfC4648RPE5/RQGWaRPMEyUUq+hLGdRaX
         mBlprgaVgr3lzv4mDVdRR3V9JJyHVcEa2iq+ZQBc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 041/114] media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
Date:   Wed, 22 May 2019 15:29:04 -0400
Message-Id: <20190522193017.26567-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit ccdd85d518d8b9320ace1d87271f0ba2175f21fa ]

In preparation for adding asynchronous subdevice support to the driver,
don't acquire v4l2_clk from the driver .probe() callback as that may
fail if the clock is provided by a bridge driver which may be not yet
initialized.  Move the v4l2_clk_get() to ov6650_video_probe() helper
which is going to be converted to v4l2_subdev_internal_ops.registered()
callback, executed only when the bridge driver is ready.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/ov6650.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 8f85910eda5df..39f6d068dc0b7 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -840,9 +840,16 @@ static int ov6650_video_probe(struct i2c_client *client)
 	u8		pidh, pidl, midh, midl;
 	int		ret;
 
+	priv->clk = v4l2_clk_get(&client->dev, NULL);
+	if (IS_ERR(priv->clk)) {
+		ret = PTR_ERR(priv->clk);
+		dev_err(&client->dev, "v4l2_clk request err: %d\n", ret);
+		return ret;
+	}
+
 	ret = ov6650_s_power(&priv->subdev, 1);
 	if (ret < 0)
-		return ret;
+		goto eclkput;
 
 	/*
 	 * check and show product ID and manufacturer ID
@@ -877,6 +884,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 
 done:
 	ov6650_s_power(&priv->subdev, 0);
+	if (!ret)
+		return 0;
+eclkput:
+	v4l2_clk_put(priv->clk);
+
 	return ret;
 }
 
@@ -1033,18 +1045,9 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
-	priv->clk = v4l2_clk_get(&client->dev, NULL);
-	if (IS_ERR(priv->clk)) {
-		ret = PTR_ERR(priv->clk);
-		goto eclkget;
-	}
-
 	ret = ov6650_video_probe(client);
-	if (ret) {
-		v4l2_clk_put(priv->clk);
-eclkget:
+	if (ret)
 		v4l2_ctrl_handler_free(&priv->hdl);
-	}
 
 	return ret;
 }
-- 
2.20.1

