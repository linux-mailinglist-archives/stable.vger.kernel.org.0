Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD916A80A
	for <lists+stable@lfdr.de>; Mon, 24 Feb 2020 15:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgBXOOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Feb 2020 09:14:15 -0500
Received: from www.linuxtv.org ([130.149.80.248]:46500 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727281AbgBXOOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Feb 2020 09:14:15 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1j6ETG-008tSd-R6; Mon, 24 Feb 2020 14:12:30 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 24 Feb 2020 14:08:18 +0000
Subject: [git:media_tree/fixes] media: vicodec: process all 4 components for RGB32 formats
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1j6ETG-008tSd-R6@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: vicodec: process all 4 components for RGB32 formats
Author:  Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:    Tue Feb 4 13:45:04 2020 +0100

Only ARGB32-type pixelformat were assumed to have 4 components, which is
wrong since RGB32-type pixelformats may have an alpha channel, so they
should also assume 4 color components.

The XRGB32-type pixelformats really have only 3 color components, but this
complicated matters since that creates strides that are sometimes width * 3
and sometimes width * 4, and in fact this can result in buffer overflows.

Keep things simple by just always processing all 4 color components.

In the future we might want to optimize this again for the XRGB32-type
pixelformats, but for now keep it simple and robust.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/platform/vicodec/codec-v4l2-fwht.c | 34 +++++++-----------------
 1 file changed, 9 insertions(+), 25 deletions(-)

---

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 3c93d9232c3c..b6e39fbd8ad5 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -27,17 +27,17 @@ static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
 	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
-	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_BGRX32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_BGRX32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_BGRA32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_RGBX32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
+	{ V4L2_PIX_FMT_RGBX32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
 	{ V4L2_PIX_FMT_RGBA32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
-	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
+	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_HSV},
 	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1, FWHT_FL_PIXENC_RGB},
 };
 
@@ -175,22 +175,14 @@ static int prepare_raw_frame(struct fwht_raw_frame *rf,
 	case V4L2_PIX_FMT_RGB32:
 	case V4L2_PIX_FMT_XRGB32:
 	case V4L2_PIX_FMT_HSV32:
-		rf->cr = rf->luma + 1;
-		rf->cb = rf->cr + 2;
-		rf->luma += 2;
-		break;
-	case V4L2_PIX_FMT_BGR32:
-	case V4L2_PIX_FMT_XBGR32:
-		rf->cb = rf->luma;
-		rf->cr = rf->cb + 2;
-		rf->luma++;
-		break;
 	case V4L2_PIX_FMT_ARGB32:
 		rf->alpha = rf->luma;
 		rf->cr = rf->luma + 1;
 		rf->cb = rf->cr + 2;
 		rf->luma += 2;
 		break;
+	case V4L2_PIX_FMT_BGR32:
+	case V4L2_PIX_FMT_XBGR32:
 	case V4L2_PIX_FMT_ABGR32:
 		rf->cb = rf->luma;
 		rf->cr = rf->cb + 2;
@@ -198,10 +190,6 @@ static int prepare_raw_frame(struct fwht_raw_frame *rf,
 		rf->alpha = rf->cr + 1;
 		break;
 	case V4L2_PIX_FMT_BGRX32:
-		rf->cb = rf->luma + 1;
-		rf->cr = rf->cb + 2;
-		rf->luma += 2;
-		break;
 	case V4L2_PIX_FMT_BGRA32:
 		rf->alpha = rf->luma;
 		rf->cb = rf->luma + 1;
@@ -209,10 +197,6 @@ static int prepare_raw_frame(struct fwht_raw_frame *rf,
 		rf->luma += 2;
 		break;
 	case V4L2_PIX_FMT_RGBX32:
-		rf->cr = rf->luma;
-		rf->cb = rf->cr + 2;
-		rf->luma++;
-		break;
 	case V4L2_PIX_FMT_RGBA32:
 		rf->alpha = rf->luma + 3;
 		rf->cr = rf->luma;
