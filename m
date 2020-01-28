Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3036314BAA7
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729996AbgA1OO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:37352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729544AbgA1OO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D588524693;
        Tue, 28 Jan 2020 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220898;
        bh=y83nSCzChg6Ffr61oGQvsf0CK7r4OghBnwbXodIF+jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xgukurDpYfAxx5dHVWfty1xuHY17yewnY36R8dh3W0utI8G65fY/Aua1oKl1dfkZm
         rWHIgedJu166mdR2MFatfmS/4rYv1GT7CvoOWaFTZIjTi/+22PZ/Cw3MKsNvb53xcO
         zj0NADH2ObgoByv5h12S1qWMxHP/WgN15jp825/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 150/183] media: ov6650: Fix incorrect use of JPEG colorspace
Date:   Tue, 28 Jan 2020 15:06:09 +0100
Message-Id: <20200128135844.708622394@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 12500731895ef09afc5b66b86b76c0884fb9c7bf ]

Since its initial submission, the driver selects V4L2_COLORSPACE_JPEG
for supported formats other than V4L2_MBUS_FMT_SBGGR8_1X8.  According
to v4l2-compliance test program, V4L2_COLORSPACE_JPEG applies
exclusively to V4L2_PIX_FMT_JPEG.  Since the sensor does not support
JPEG format, fix it to always select V4L2_COLORSPACE_SRGB.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/ov6650.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index bb55ddfbf7337..7adbfc57cffa5 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -203,7 +203,6 @@ struct ov6650 {
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_parm */
 	u32 code;
-	enum v4l2_colorspace	colorspace;
 };
 
 
@@ -513,7 +512,7 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
-	mf->colorspace	= priv->colorspace;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -623,11 +622,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		priv->pclk_max = 8000000;
 	}
 
-	if (code == MEDIA_BUS_FMT_SBGGR8_1X8)
-		priv->colorspace = V4L2_COLORSPACE_SRGB;
-	else if (code != 0)
-		priv->colorspace = V4L2_COLORSPACE_JPEG;
-
 	if (half_scale) {
 		dev_dbg(&client->dev, "max resolution: QCIF\n");
 		coma_set |= COMA_QCIF;
@@ -684,7 +678,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		priv->code = code;
 
 	if (!ret) {
-		mf->colorspace	= priv->colorspace;
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}
@@ -707,6 +700,7 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 				&mf->height, 2, H_CIF, 1, 0);
 
 	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
@@ -716,12 +710,10 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
-		mf->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
 	case MEDIA_BUS_FMT_SBGGR8_1X8:
-		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	}
 
@@ -1048,7 +1040,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.height = H_CIF;
 	priv->half_scale  = false;
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
-	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(client);
 	if (ret)
-- 
2.20.1



