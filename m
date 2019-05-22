Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BB26CD1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 21:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733188AbfEVTaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 15:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733178AbfEVTaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:30:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B134C21473;
        Wed, 22 May 2019 19:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553413;
        bh=WeJsRdSZVlFBrxd9T9tJ8zeLOk+9iaySj+649hQDRCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6D2jayMPyxHHKyGXIFmO1Vt61A5P3fGULFNpZi3ps2vm+dbA7DpByliFVi4Y8kiF
         ldEvll9Y2IUHy/Qw6KP05ytqIuPbpPxXy7jOP4WtPs0MZ2MIWmlcfmbc4vmxBQZcSJ
         ycIY+cUDRPqZrcdjeZMK52M3qjOYleI+BjnSBhJE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 060/167] media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
Date:   Wed, 22 May 2019 15:26:55 -0400
Message-Id: <20190522192842.25858-60-sashal@kernel.org>
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
 drivers/media/i2c/ov6650.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 768f2950ea361..965043578323e 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -822,9 +822,16 @@ static int ov6650_video_probe(struct i2c_client *client)
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
@@ -859,6 +866,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 
 done:
 	ov6650_s_power(&priv->subdev, 0);
+	if (!ret)
+		return 0;
+eclkput:
+	v4l2_clk_put(priv->clk);
+
 	return ret;
 }
 
@@ -1004,18 +1016,9 @@ static int ov6650_probe(struct i2c_client *client,
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

