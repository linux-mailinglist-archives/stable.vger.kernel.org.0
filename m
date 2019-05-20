Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0A8243B1
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 00:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfETWu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 18:50:59 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43346 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727216AbfETWuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 18:50:37 -0400
Received: by mail-lf1-f67.google.com with SMTP id u27so11518175lfg.10;
        Mon, 20 May 2019 15:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3jHxB8duCj+jbQe+ZqNgSRRod5UW1aP5fbdBNwkwFrY=;
        b=KUOjHiVMHmYRkyB/aLuy9C15Jnu5JkkhDDOw7E67mWL4I+kP2Oji7txCc/c1kzkjMP
         WwFdOeSSB9gtuGXpwFDqyXzKKAYtmCkq3lNoI6mP9cJLVfWEHQLc++1tXlVQYHytOyzL
         gVr+TES6mNLzs2n5LB680ZCPh/ae0SesCDsWsX5faLTIf6fPeH03nfKR3YHZVaejdP6C
         TK7gECkp4y/l8krqS2JXOYp3XCSKLAcS9yhG4BBszA1NzWoO+FcAjQwxUl45EcitgwjJ
         aktVPfusPJORTSP6jmuQ4lLlOcEeIUfD98IHN91zfqi/t79Mo+YFwAhga8nQePs8d9jO
         x70w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3jHxB8duCj+jbQe+ZqNgSRRod5UW1aP5fbdBNwkwFrY=;
        b=V0s9YXnCPEmpIfx10VjwyseDM/FRKzAvoiS9WYhpzTXIi0ObC9eLQt3i/10T1F5v9e
         VO7gffPnxk2LFkgERH8mAWTYgsEDFCjdWiJ2BiHP0Hh5PBqMLQ2CYWeTdyPjtvslCmAm
         6CuXyISHc7xhuidmqQ4FoUecq6igpcu8dnPLalEKC56JpiO51p+EdaHrNLk6z/gGpNnm
         Krgm1hRbLjv6tVPppV8ZJ9qHfIHnpmrfUSYVhDZWX6mHDz4AAVE1wUmL0gUY7l7x/3NA
         k4ZHKKtFjuiT9Gtuyyl4PweifqBrReS7+oRKKX6kKNfoe4wrgO21jFSWxEHOJpObPqJP
         Pavg==
X-Gm-Message-State: APjAAAXeHtTw41PGlm+J8ngyQklqTO/GyD1sgnmdxK6RGLW0XxJL4VgE
        xdauk9apvzE1udm8mHif5hc=
X-Google-Smtp-Source: APXvYqzwMqOZ3xcLWq0gozdYg+4zcMPcyZdgPAi8J+Ywl5QjLme6CTbQdeCChZxua6hMAIIJA3736A==
X-Received: by 2002:a19:4811:: with SMTP id v17mr31503545lfa.10.1558392635041;
        Mon, 20 May 2019 15:50:35 -0700 (PDT)
Received: from z50.gdansk-morena.vectranet.pl (109241207190.gdansk.vectranet.pl. [109.241.207.190])
        by smtp.gmail.com with ESMTPSA id t13sm2371646lji.47.2019.05.20.15.50.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 15:50:34 -0700 (PDT)
From:   Janusz Krzysztofik <jmkrzyszt@gmail.com>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 4/9] media: ov6650: Fix incorrect use of JPEG colorspace
Date:   Tue, 21 May 2019 00:50:02 +0200
Message-Id: <20190520225007.2308-5-jmkrzyszt@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520225007.2308-1-jmkrzyszt@gmail.com>
References: <20190520225007.2308-1-jmkrzyszt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since its initial submission, the driver selects V4L2_COLORSPACE_JPEG
for supported formats other than V4L2_MBUS_FMT_SBGGR8_1X8.  According
to v4l2-compliance test program, V4L2_COLORSPACE_JPEG applies
exclusively to V4L2_PIX_FMT_JPEG.  Since the sensor does not support
JPEG format, fix it to always select V4L2_COLORSPACE_SRGB.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/media/i2c/ov6650.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 751b48483f27..e7790e9b8887 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -203,7 +203,6 @@ struct ov6650 {
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_frame_interval */
 	u32 code;
-	enum v4l2_colorspace	colorspace;
 };
 
 
@@ -517,7 +516,7 @@ static int ov6650_get_fmt(struct v4l2_subdev *sd,
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
-	mf->colorspace	= priv->colorspace;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -625,11 +624,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
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
@@ -660,7 +654,6 @@ static int ov6650_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
 
 	if (!ret) {
-		mf->colorspace	= priv->colorspace;
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}
@@ -683,6 +676,7 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 				&mf->height, 2, H_CIF, 1, 0);
 
 	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
@@ -693,13 +687,11 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
-		mf->colorspace = V4L2_COLORSPACE_JPEG;
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
 		/* fall through */
 	case MEDIA_BUS_FMT_SBGGR8_1X8:
-		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	}
 
@@ -1007,7 +999,6 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->rect.height = H_CIF;
 	priv->half_scale  = false;
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
-	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	priv->subdev.internal_ops = &ov6650_internal_ops;
 	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-- 
2.21.0

