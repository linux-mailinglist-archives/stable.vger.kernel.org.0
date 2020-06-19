Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4221200FB6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392753AbgFSPUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392747AbgFSPUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:20:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8799D20B80;
        Fri, 19 Jun 2020 15:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580048;
        bh=lpX2+wur1t1gEsxx2uAp+EdCAOVN3IOjp4QxKK+GMt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj6dEw6BsQ1TjqepZhMoWmZav/iSC8r8PZe+wQlBKczS3yBW7Xgi9o91m9kIjzevd
         mZ9T8/dHtBLucJtuayHtpSDzyCgciv1iDd1Ya9NsHcI7hj/mTA1jLckmV74eT2JWO5
         Jf/t4wMVGnuj/xYVMEq0e9H5sqTjcEivgl3NwFKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 102/376] media: imx: utils: fix media bus format enumeration
Date:   Fri, 19 Jun 2020 16:30:20 +0200
Message-Id: <20200619141715.174125846@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 1df2148fdfc036c9350d41ae81b09b3f8897c9b6 ]

Iterate over all media bus formats, not just over the first format in
each imx_media_pixfmt entry.

Before:

  $ v4l2-ctl -d $(media-ctl -e ipu1_csi0) --list-subdev-mbus-codes 0
  ioctl: VIDIOC_SUBDEV_ENUM_MBUS_CODE (pad=0)
	0x2006: MEDIA_BUS_FMT_UYVY8_2X8
	0x2008: MEDIA_BUS_FMT_YUYV8_2X8
	0x1008: MEDIA_BUS_FMT_RGB565_2X8_LE
	0x100a: MEDIA_BUS_FMT_RGB888_1X24
	0x100d: MEDIA_BUS_FMT_ARGB8888_1X32
	0x3001: MEDIA_BUS_FMT_SBGGR8_1X8
	0x3013: MEDIA_BUS_FMT_SGBRG8_1X8
	0x3002: MEDIA_BUS_FMT_SGRBG8_1X8
	0x3014: MEDIA_BUS_FMT_SRGGB8_1X8
	0x3007: MEDIA_BUS_FMT_SBGGR10_1X10
	0x300e: MEDIA_BUS_FMT_SGBRG10_1X10
	0x300a: MEDIA_BUS_FMT_SGRBG10_1X10
	0x300f: MEDIA_BUS_FMT_SRGGB10_1X10
	0x2001: MEDIA_BUS_FMT_Y8_1X8
	0x200a: MEDIA_BUS_FMT_Y10_1X10

After:

  $ v4l2-ctl -d $(media-ctl -e ipu1_csi0) --list-subdev-mbus-codes 0
  ioctl: VIDIOC_SUBDEV_ENUM_MBUS_CODE (pad=0)
	0x2006: MEDIA_BUS_FMT_UYVY8_2X8
	0x200f: MEDIA_BUS_FMT_UYVY8_1X16
	0x2008: MEDIA_BUS_FMT_YUYV8_2X8
	0x2011: MEDIA_BUS_FMT_YUYV8_1X16
	0x1008: MEDIA_BUS_FMT_RGB565_2X8_LE
	0x100a: MEDIA_BUS_FMT_RGB888_1X24
	0x100c: MEDIA_BUS_FMT_RGB888_2X12_LE
	0x100d: MEDIA_BUS_FMT_ARGB8888_1X32
	0x3001: MEDIA_BUS_FMT_SBGGR8_1X8
	0x3013: MEDIA_BUS_FMT_SGBRG8_1X8
	0x3002: MEDIA_BUS_FMT_SGRBG8_1X8
	0x3014: MEDIA_BUS_FMT_SRGGB8_1X8
	0x3007: MEDIA_BUS_FMT_SBGGR10_1X10
	0x3008: MEDIA_BUS_FMT_SBGGR12_1X12
	0x3019: MEDIA_BUS_FMT_SBGGR14_1X14
	0x301d: MEDIA_BUS_FMT_SBGGR16_1X16
	0x300e: MEDIA_BUS_FMT_SGBRG10_1X10
	0x3010: MEDIA_BUS_FMT_SGBRG12_1X12
	0x301a: MEDIA_BUS_FMT_SGBRG14_1X14
	0x301e: MEDIA_BUS_FMT_SGBRG16_1X16
	0x300a: MEDIA_BUS_FMT_SGRBG10_1X10
	0x3011: MEDIA_BUS_FMT_SGRBG12_1X12
	0x301b: MEDIA_BUS_FMT_SGRBG14_1X14
	0x301f: MEDIA_BUS_FMT_SGRBG16_1X16
	0x300f: MEDIA_BUS_FMT_SRGGB10_1X10
	0x3012: MEDIA_BUS_FMT_SRGGB12_1X12
	0x301c: MEDIA_BUS_FMT_SRGGB14_1X14
	0x3020: MEDIA_BUS_FMT_SRGGB16_1X16
	0x2001: MEDIA_BUS_FMT_Y8_1X8
	0x200a: MEDIA_BUS_FMT_Y10_1X10
	0x2013: MEDIA_BUS_FMT_Y12_1X12

[laurent.pinchart@ideasonboard.com: Decrement index to replace loop counter k]
[laurent.pinchart@ideasonboard.com: Return directly from within the loops]

Fixes: e130291212df5 ("[media] media: Add i.MX media core driver")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/imx/imx-media-utils.c | 22 +++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 39469031e510..00a71f01786c 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -269,6 +269,7 @@ static int enum_format(u32 *fourcc, u32 *code, u32 index,
 	for (i = 0; i < ARRAY_SIZE(pixel_formats); i++) {
 		const struct imx_media_pixfmt *fmt = &pixel_formats[i];
 		enum codespace_sel fmt_cs_sel;
+		unsigned int j;
 
 		fmt_cs_sel = (fmt->cs == IPUV3_COLORSPACE_YUV) ?
 			CS_SEL_YUV : CS_SEL_RGB;
@@ -278,15 +279,24 @@ static int enum_format(u32 *fourcc, u32 *code, u32 index,
 		    (!allow_bayer && fmt->bayer))
 			continue;
 
-		if (index == 0) {
-			if (fourcc)
-				*fourcc = fmt->fourcc;
-			if (code)
-				*code = fmt->codes[0];
+		if (fourcc && index == 0) {
+			*fourcc = fmt->fourcc;
 			return 0;
 		}
 
-		index--;
+		if (!code) {
+			index--;
+			continue;
+		}
+
+		for (j = 0; j < ARRAY_SIZE(fmt->codes) && fmt->codes[j]; j++) {
+			if (index == 0) {
+				*code = fmt->codes[j];
+				return 0;
+			}
+
+			index--;
+		}
 	}
 
 	return -EINVAL;
-- 
2.25.1



