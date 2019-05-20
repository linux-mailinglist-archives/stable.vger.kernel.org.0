Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21231243A6
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727270AbfETWuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:40 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38502 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfETWuj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:39 -0400
Received: by mail-lf1-f68.google.com with SMTP id y19so11538680lfy.5;
        Mon, 20 May 2019 15:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RYk0UCgs+ZosBF8arGOOqtc7IYws3tQQshELX+XWdys=;
        b=WLgBLLmy0fN//F+fKtASz4bdx/EAZ5EceIApTB4uAe25K4p93YmfHrI6cBQ9dLzAI5
         PCxS6FfJPEjD/+XtRvHTP7o2se1FzmxvCrPme3nQkf1mfrJ82DLHSYCufTVBV9jWIRR8
         7J/qS3Ar1V/+B3zQc3A12BFo71KFS48zpQEXbFZKvYJUorS86yi4eBN0/+eJfW/AaMEk
         kgFNA3KCeEoYSZ88F9eHxLJjMUwk47AwwlDqDaOIylo0hJUrCElbu/enCNA2cwWkqWJi
         9LlJOTgcZ3QQkcyH5rI3jzSRu54qLHZq1gtrISuk6S+vTLHA25wGU91IJSRQ3ItYgKzo
         1Vsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYk0UCgs+ZosBF8arGOOqtc7IYws3tQQshELX+XWdys=;
        b=hkBg6AyZfIYkV+8p1XzCp24aYy/MgHxoQL9yf1MK6dlkuFRTF2dDu9OSfL9c+Tjz15
         SnUI8fCLswFFuyNrbaj9ixGOZXc007TCR8ISCxM1Ld1cDLMKQaOskGIOTKSEKs8NogOe
         IeAdUkUsGyu3i21D2uOfkEX1mNfyVwZp6/M28wrKlIei0r1XAjkqpVrpi3U25HrK68Ej
         GbsmHYGXrprIZaNk9fXHWevljYVvp0iZwM2M2Q5VXCAtB9dqgeD7Nr0nc/xPQVM2ujba
         Fi7PHp6aCM2jf0HMOPtHFdoOsOaMUaI+QyyyJZZ1f7zKx3plCJT4T5SJKw48A4E0F5bV
         smUw==
X-Gm-Message-State: APjAAAXlY9Me+CK4EnsxH/6M2bpspS6b+SYVzWjntcM+Xaw9VPClpEl/
        rNlZR+GpLVPoItRTFkEDdWw=
X-Google-Smtp-Source: APXvYqzMNxdRx54BoJGNHRTK4217Jq6j30+FO2Q21HDQtUU/D+HykVofAwdpR42vjBSsmi3zVRM+tA==
X-Received: by 2002:a19:9e47:: with SMTP id h68mr34930682lfe.91.1558392636196;
        Mon, 20 May 2019 15:50:36 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:35 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 5/9] media: ov6650: Fix some format attributes not under control
Date:   Tue, 21 May 2019 00:50:03 +0200
Message-Id: <20190520225007.2308-6-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
fill the response with the default frame format updated with updated
pad config format code and frame size.

Fixes: 11ff030c7365 ("[media] v4l2-mediabus: improve colorspace support")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 51 +++++++++++++++++++++++++++++---------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index e7790e9b8887..731b03bef7a5 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
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
@@ -513,11 +524,13 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
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
@@ -653,10 +666,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	if (!ret)
 		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
 
-	if (!ret) {
-		mf->width = priv->rect.width >> half_scale;
-		mf->height = priv->rect.height >> half_scale;
-	}
 	return ret;
 }
 
@@ -675,9 +684,6 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 		v4l_bound_align_image(&mf->width, 2, W_CIF, 1,
 				&mf->height, 2, H_CIF, 1, 0);
 
-	mf->field = V4L2_FIELD_NONE;
-	mf->colorspace = V4L2_COLORSPACE_SRGB;
-
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
 		mf->code = MEDIA_BUS_FMT_Y8_1X8;
@@ -695,10 +701,31 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
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
2.21.0

