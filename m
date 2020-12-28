Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307A62E412E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439746AbgL1OL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439728AbgL1OL5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A292C20715;
        Mon, 28 Dec 2020 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164676;
        bh=QzUb8k2L9ZU+aPkQhH4a7riCme34oUXh+tm3u8vGmlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KXIZ2LRSiLqKfpyraJGFA2SmFGI71o/DyKEoRsUM3q3gjunvzMnKIHrez/hqlBFw6
         zIDdyoanTpRwwwo5MLLILr1ScD7O/9yOrUzeFMuNn2lOaIR8DB7O+8gio59iCcFWZD
         wdaBGDHdPOC4ZrisXcTJiRntVRTN3ZsN5HwK+SmA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/717] media: i2c: imx219: Selection compliance fixes
Date:   Mon, 28 Dec 2020 13:44:17 +0100
Message-Id: <20201228125033.404681857@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 1ed36ecd1459b653cced8929bfb37dba94b64c5d ]

To comply with the intended usage of the V4L2 selection target when
used to retrieve a sensor image properties, adjust the rectangles
returned by the imx219 driver.

The top/left crop coordinates of the TGT_CROP rectangle were set to
(0, 0) instead of (8, 8) which is the offset from the larger physical
pixel array rectangle. This was also a mismatch with the default values
crop rectangle value, so this is corrected. Found with v4l2-compliance.

While at it, add V4L2_SEL_TGT_CROP_BOUNDS support: CROP_DEFAULT and
CROP_BOUNDS have the same size as the non-active pixels are not readable
using the selection API. Found with v4l2-compliance.

[reword commit message, use macros for pixel offsets]

Fixes: e6d4ef7d58aa7 ("media: i2c: imx219: Implement get_selection")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 1cee45e353554..0ae66091a6962 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -473,8 +473,8 @@ static const struct imx219_mode supported_modes[] = {
 		.width = 3280,
 		.height = 2464,
 		.crop = {
-			.left = 0,
-			.top = 0,
+			.left = IMX219_PIXEL_ARRAY_LEFT,
+			.top = IMX219_PIXEL_ARRAY_TOP,
 			.width = 3280,
 			.height = 2464
 		},
@@ -489,8 +489,8 @@ static const struct imx219_mode supported_modes[] = {
 		.width = 1920,
 		.height = 1080,
 		.crop = {
-			.left = 680,
-			.top = 692,
+			.left = 688,
+			.top = 700,
 			.width = 1920,
 			.height = 1080
 		},
@@ -505,8 +505,8 @@ static const struct imx219_mode supported_modes[] = {
 		.width = 1640,
 		.height = 1232,
 		.crop = {
-			.left = 0,
-			.top = 0,
+			.left = IMX219_PIXEL_ARRAY_LEFT,
+			.top = IMX219_PIXEL_ARRAY_TOP,
 			.width = 3280,
 			.height = 2464
 		},
@@ -521,8 +521,8 @@ static const struct imx219_mode supported_modes[] = {
 		.width = 640,
 		.height = 480,
 		.crop = {
-			.left = 1000,
-			.top = 752,
+			.left = 1008,
+			.top = 760,
 			.width = 1280,
 			.height = 960
 		},
@@ -1008,6 +1008,7 @@ static int imx219_get_selection(struct v4l2_subdev *sd,
 		return 0;
 
 	case V4L2_SEL_TGT_CROP_DEFAULT:
+	case V4L2_SEL_TGT_CROP_BOUNDS:
 		sel->r.top = IMX219_PIXEL_ARRAY_TOP;
 		sel->r.left = IMX219_PIXEL_ARRAY_LEFT;
 		sel->r.width = IMX219_PIXEL_ARRAY_WIDTH;
-- 
2.27.0



