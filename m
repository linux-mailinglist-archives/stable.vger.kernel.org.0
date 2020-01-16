Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB9113FD69
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388540AbgAPXZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:55386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388212AbgAPXZh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDF7820684;
        Thu, 16 Jan 2020 23:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217137;
        bh=f5K9Qz9G83MgDNny780J8X4HB03TXt8kgb7x4eSj1JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yz31yV3sF+s2khjVmqh+6WUG9gqdcx7WCTZkJMYwZa+M3AYvrYRrDEJksZkRO1nzp
         Jc4wPbmigrzH/z8IUBneeRnb0lGGm2WYlPTRhs/GMxEwrPHvatlCmmgV05WOP502Z4
         J8UOvGlUK+TFxEGH2gRSqydcUgl6c/33xvSeiLTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 146/203] media: ov6650: Fix incorrect use of JPEG colorspace
Date:   Fri, 17 Jan 2020 00:17:43 +0100
Message-Id: <20200116231757.695720616@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit 12500731895ef09afc5b66b86b76c0884fb9c7bf upstream.

Since its initial submission, the driver selects V4L2_COLORSPACE_JPEG
for supported formats other than V4L2_MBUS_FMT_SBGGR8_1X8.  According
to v4l2-compliance test program, V4L2_COLORSPACE_JPEG applies
exclusively to V4L2_PIX_FMT_JPEG.  Since the sensor does not support
JPEG format, fix it to always select V4L2_COLORSPACE_SRGB.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov6650.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -201,7 +201,6 @@ struct ov6650 {
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_frame_interval */
 	u32 code;
-	enum v4l2_colorspace	colorspace;
 };
 
 
@@ -517,7 +516,7 @@ static int ov6650_get_fmt(struct v4l2_su
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
-	mf->colorspace	= priv->colorspace;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -624,11 +623,6 @@ static int ov6650_s_fmt(struct v4l2_subd
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
@@ -663,7 +657,6 @@ static int ov6650_s_fmt(struct v4l2_subd
 		priv->code = code;
 
 	if (!ret) {
-		mf->colorspace	= priv->colorspace;
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}
@@ -686,6 +679,7 @@ static int ov6650_set_fmt(struct v4l2_su
 				&mf->height, 2, H_CIF, 1, 0);
 
 	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
@@ -696,13 +690,11 @@ static int ov6650_set_fmt(struct v4l2_su
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
 
@@ -1008,7 +1000,6 @@ static int ov6650_probe(struct i2c_clien
 	priv->rect.height = H_CIF;
 	priv->half_scale  = false;
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
-	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	/* Hardware default frame interval */
 	priv->tpf.numerator   = GET_CLKRC_DIV(DEF_CLKRC);


