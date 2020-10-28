Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A59E29DE5C
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 01:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731843AbgJ1WTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731688AbgJ1WRl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:41 -0400
Received: from kozik-lap.proceq-device.com (unknown [194.230.155.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF9FB2468F;
        Wed, 28 Oct 2020 09:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603876799;
        bh=C+i9hSG3DC7PYTlPO4OOMAUq70uMqJhl4BFFF/S06X4=;
        h=From:To:Cc:Subject:Date:From;
        b=RM7TbMkLhzXq4/+CiVWwwhRX47sqvNzIlBi1osRLRkrdgFVTIQiFT+vkcSt9woh3O
         Ty7Obt2tA3yjv9dw9ZlmRBw+nHfRwEr7EBWdhx9CLhGz8DDlk5YoPrgLhF45L43hYw
         n2LfQopbnC1CEPTAuLhWEW71z6y2+RB30bqq+q/U=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Jason Chen <jasonx.z.chen@intel.com>,
        Andy Yeh <andy.yeh@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] media: i2c: imx258: correct mode to GBGB/RGRG
Date:   Wed, 28 Oct 2020 10:19:47 +0100
Message-Id: <20201028091947.93097-1-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The IMX258 sensor outputs pixels in GBGB/RGRG mode.  This is described
explicitly in datasheet and was actually mentioned in a comment inside
the driver.  Using other - wrong mode - leads to pinkish pictures.

Fixes: e4802cb00bfe ("media: imx258: Add imx258 camera sensor driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/media/i2c/imx258.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/imx258.c b/drivers/media/i2c/imx258.c
index ef069333a969..bf75d4e597af 100644
--- a/drivers/media/i2c/imx258.c
+++ b/drivers/media/i2c/imx258.c
@@ -715,7 +715,7 @@ static int imx258_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	/* Initialize try_fmt */
 	try_fmt->width = supported_modes[0].width;
 	try_fmt->height = supported_modes[0].height;
-	try_fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	try_fmt->code = MEDIA_BUS_FMT_SGBRG10_1X10;
 	try_fmt->field = V4L2_FIELD_NONE;
 
 	return 0;
@@ -827,7 +827,7 @@ static int imx258_enum_mbus_code(struct v4l2_subdev *sd,
 	if (code->index > 0)
 		return -EINVAL;
 
-	code->code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	code->code = MEDIA_BUS_FMT_SGBRG10_1X10;
 
 	return 0;
 }
@@ -839,7 +839,7 @@ static int imx258_enum_frame_size(struct v4l2_subdev *sd,
 	if (fse->index >= ARRAY_SIZE(supported_modes))
 		return -EINVAL;
 
-	if (fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
+	if (fse->code != MEDIA_BUS_FMT_SGBRG10_1X10)
 		return -EINVAL;
 
 	fse->min_width = supported_modes[fse->index].width;
@@ -855,7 +855,7 @@ static void imx258_update_pad_format(const struct imx258_mode *mode,
 {
 	fmt->format.width = mode->width;
 	fmt->format.height = mode->height;
-	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->format.code = MEDIA_BUS_FMT_SGBRG10_1X10;
 	fmt->format.field = V4L2_FIELD_NONE;
 }
 
@@ -902,7 +902,7 @@ static int imx258_set_pad_format(struct v4l2_subdev *sd,
 	mutex_lock(&imx258->mutex);
 
 	/* Only one raw bayer(GBRG) order is supported */
-	fmt->format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
+	fmt->format.code = MEDIA_BUS_FMT_SGBRG10_1X10;
 
 	mode = v4l2_find_nearest_size(supported_modes,
 		ARRAY_SIZE(supported_modes), width, height,
-- 
2.25.1

