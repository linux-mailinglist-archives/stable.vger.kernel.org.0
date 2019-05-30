Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271EA2F61E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbfE3ExR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728176AbfE3DKj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:39 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33EAA24476;
        Thu, 30 May 2019 03:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185839;
        bh=UmEJHAfWIK7VkVI/uteN4bC2ybQ8chuCJEsEv4rU13A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHCtpbgXPSfoumZgH32U7ahvgv4hzRNyaMYAIiD/3Zh5xZPhqEIj+uC/XXw5F3Tga
         UKJ2z+tkbkucLqwpbSQNYKv7zwsHkalBT0nXhHifZX7oJfMgP3MN9Id7TVbi6Qv5c5
         IasyRSkIW9foB7xPUSxTw6cI27l3jg8JSlWJm0ZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 154/405] media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
Date:   Wed, 29 May 2019 20:02:32 -0700
Message-Id: <20190530030548.941784142@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index f9359b11fa5cb..de7d9790f0542 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -810,9 +810,16 @@ static int ov6650_video_probe(struct i2c_client *client)
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
 
 	msleep(20);
 
@@ -849,6 +856,11 @@ static int ov6650_video_probe(struct i2c_client *client)
 
 done:
 	ov6650_s_power(&priv->subdev, 0);
+	if (!ret)
+		return 0;
+eclkput:
+	v4l2_clk_put(priv->clk);
+
 	return ret;
 }
 
@@ -991,18 +1003,9 @@ static int ov6650_probe(struct i2c_client *client,
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



