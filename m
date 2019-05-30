Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6142F369
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbfE3DOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729720AbfE3DOH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:14:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7515C24547;
        Thu, 30 May 2019 03:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186046;
        bh=8LbZlu4aAZcQS7+yzBAlGBKmeC07lrdmWYrukn3OSSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOlAoHXIAnc3f3l0gVUGfc4+4MAVhhWzkhSo/dB/quVP14swIjgc7xfbtVeYofNzH
         0vy5g0kMa3Oq2H631omr1y1Q3IpMYDr86gcYN2J7Qc+Qs5WckfjFcvqmL39y8Ol2Of
         sj6/B1sLq1m6jxrBzDH7S7dvPzDOx/Eyr1+OJ/7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 139/346] media: ov6650: Move v4l2_clk_get() to ov6650_video_probe() helper
Date:   Wed, 29 May 2019 20:03:32 -0700
Message-Id: <20190530030548.177486458@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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
index 2d3f7e00b129c..ba54ceb0b7266 100644
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



