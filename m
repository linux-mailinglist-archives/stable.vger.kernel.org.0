Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5674113FE60
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404216AbgAPXcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404211AbgAPXcv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:32:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FB5206D9;
        Thu, 16 Jan 2020 23:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217570;
        bh=8yemev6+kF5cxyN9+mx747D+Fbwq2G73e+UcVl4MgWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykeGTfNAAXWlWcCsiPjPHjLR3Y1l259/35EqB8soxkp0XyhkRsMv5Otaydfc93qeg
         hRa+Nxxr5oMqmKeYo/pkNfZWI4LIce6Attk2OO5qDmU2N+vkGzPGRoU/yCOrRCyBid
         2a/GJc2XC4R/UHfQveDrTab7QCLrD3rt7gGZVx5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.14 52/71] media: ov6650: Fix incorrect use of JPEG colorspace
Date:   Fri, 17 Jan 2020 00:18:50 +0100
Message-Id: <20200116231716.803871001@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
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
@@ -203,7 +203,6 @@ struct ov6650 {
 	unsigned long		pclk_max;	/* from resolution and format */
 	struct v4l2_fract	tpf;		/* as requested with s_parm */
 	u32 code;
-	enum v4l2_colorspace	colorspace;
 };
 
 
@@ -520,7 +519,7 @@ static int ov6650_get_fmt(struct v4l2_su
 	mf->width	= priv->rect.width >> priv->half_scale;
 	mf->height	= priv->rect.height >> priv->half_scale;
 	mf->code	= priv->code;
-	mf->colorspace	= priv->colorspace;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -627,11 +626,6 @@ static int ov6650_s_fmt(struct v4l2_subd
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
@@ -666,7 +660,6 @@ static int ov6650_s_fmt(struct v4l2_subd
 		priv->code = code;
 
 	if (!ret) {
-		mf->colorspace	= priv->colorspace;
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}
@@ -689,6 +682,7 @@ static int ov6650_set_fmt(struct v4l2_su
 				&mf->height, 2, H_CIF, 1, 0);
 
 	mf->field = V4L2_FIELD_NONE;
+	mf->colorspace = V4L2_COLORSPACE_SRGB;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
@@ -699,13 +693,11 @@ static int ov6650_set_fmt(struct v4l2_su
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
 
@@ -1020,7 +1012,6 @@ static int ov6650_probe(struct i2c_clien
 	priv->rect.height = H_CIF;
 	priv->half_scale  = false;
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
-	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
 	ret = ov6650_video_probe(client);
 	if (ret)


