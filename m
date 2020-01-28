Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185C514B759
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgA1ONh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729705AbgA1ONh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:13:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CAD024688;
        Tue, 28 Jan 2020 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220816;
        bh=3EV1cCEzNwQ85JcrY+MvFis796hLJ0RVZ2eLTWX5+8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eHsTRTKxtRbMgk4Ghuv3VlTLaf1svvyshGYhxXnI39w4D782f3LunyQ8JQm66Ir/C
         /T4Locexpt1BpE8kGfsZnacmh0j/rf+1azC6EYquNgzPVvIgfVChWxDLLlv8ju2Amv
         8/v894AcrQU4g2D79XMopZPOsIskKj030ffRwS1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 151/183] media: ov6650: Fix some format attributes not under control
Date:   Tue, 28 Jan 2020 15:06:10 +0100
Message-Id: <20200128135844.808139287@linuxfoundation.org>
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

[ Upstream commit 1c6a2b63095154bbf9e8f38d79487a728331bf65 ]

User arguments passed to .get/set_fmt() pad operation callbacks may
contain unsupported values.  The driver takes control over frame size
and pixel code as well as colorspace and field attributes but has never
cared for remainig format attributes, i.e., ycbcr_enc, quantization
and xfer_func, introduced by commit 11ff030c7365 ("[media]
v4l2-mediabus: improve colorspace support").  Fix it.

Set up a static v4l2_mbus_framefmt structure with attributes
initialized to reasonable defaults and use it for updating content of
user provided arguments.  In case of V4L2_SUBDEV_FORMAT_ACTIVE,
postpone frame size update, now performed from inside ov6650_s_fmt()
helper, util the user argument is first updated in ov6650_set_fmt() with
default frame format content.  For V4L2_SUBDEV_FORMAT_TRY, don't copy
all attributes to pad config, only those handled by the driver, then
fill the response with the default frame format updated with resulting
pad config format code and frame size.

Fixes: 11ff030c7365 ("[media] v4l2-mediabus: improve colorspace support")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/soc_camera/ov6650.c | 51 ++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov6650.c b/drivers/media/i2c/soc_camera/ov6650.c
index 7adbfc57cffa5..01f82c3fc1d1c 100644
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -215,6 +215,17 @@ static u32 ov6650_codes[] = {
 	MEDIA_BUS_FMT_Y8_1X8,
 };
 
+static const struct v4l2_mbus_framefmt ov6650_def_fmt = {
+	.width		= W_CIF,
+	.height		= H_CIF,
+	.code		= MEDIA_BUS_FMT_SBGGR8_1X8,
+	.colorspace	= V4L2_COLORSPACE_SRGB,
+	.field		= V4L2_FIELD_NONE,
+	.ycbcr_enc	= V4L2_YCBCR_ENC_DEFAULT,
+	.quantization	= V4L2_QUANTIZATION_DEFAULT,
+	.xfer_func	= V4L2_XFER_FUNC_DEFAULT,
+};
+
 /* read a register */
 static int ov6650_reg_read(struct i2c_client *client, u8 reg, u8 *val)
 {
@@ -509,11 +520,13 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
 	if (format->pad)
 		return -EINVAL;
 
+	/* initialize response with default media bus frame format */
+	*mf = ov6650_def_fmt;
+
+	/* update media bus format code and frame size */
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
-	mf->colorspace	= V4L2_COLORSPACE_SRGB;
-	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
@@ -677,10 +690,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	if (!ret)
 		priv->code = code;
 
-	if (!ret) {
-		mf->width = priv->rect.width >> half_scale;
-		mf->height = priv->rect.height >> half_scale;
-	}
 	return ret;
 }
 
@@ -699,9 +708,6 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
 				&mf->height, 2, H_CIF, 1, 0);
 
-	mf->field = V4L2_FIELD_NONE;
-	mf->colorspace = V4L2_COLORSPACE_SRGB;
-
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
 		mf->code = MEDIA_BUS_FMT_Y8_1X8;
@@ -717,10 +723,31 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 		break;
 	}
 
-	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		return ov6650_s_fmt(sd, mf);
-	cfg->try_fmt = *mf;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
+		/* store media bus format code and frame size in pad config */
+		cfg->try_fmt.width = mf->width;
+		cfg->try_fmt.height = mf->height;
+		cfg->try_fmt.code = mf->code;
 
+		/* return default mbus frame format updated with pad config */
+		*mf = ov6650_def_fmt;
+		mf->width = cfg->try_fmt.width;
+		mf->height = cfg->try_fmt.height;
+		mf->code = cfg->try_fmt.code;
+
+	} else {
+		/* apply new media bus format code and frame size */
+		int ret = ov6650_s_fmt(sd, mf);
+
+		if (ret)
+			return ret;
+
+		/* return default format updated with active size and code */
+		*mf = ov6650_def_fmt;
+		mf->width = priv->rect.width >> priv->half_scale;
+		mf->height = priv->rect.height >> priv->half_scale;
+		mf->code = priv->code;
+	}
 	return 0;
 }
 
-- 
2.20.1



