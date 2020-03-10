Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01DED17F8DF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgCJMv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgCJMvu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:51:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5909A2468E;
        Tue, 10 Mar 2020 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844709;
        bh=L/8bNz1ay2DsHD8v+WzxzOz1K+YBVsMdPN+L+Xvzoac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RIHIK4pIW/osYIq8NQ+q0qIZABTi3QX/GB599geB78wNgCZwnD4rnrlnm8zssz9Eq
         85PA7TnNVSeu97P9poyJDMVf0o2abxoGGjLKoPRGhFm4oBcJS7wYC8SqVQoYRIwgw3
         tlIuxhulETxjkrV83nGhb1JKyCLUFHstPGeNK434=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 090/168] media: vicodec: process all 4 components for RGB32 formats
Date:   Tue, 10 Mar 2020 13:38:56 +0100
Message-Id: <20200310123644.414885381@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 49a56266f96f2c6608373464af8755b431ef1513 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/vicodec/codec-v4l2-fwht.c |   34 ++++++-----------------
 1 file changed, 9 insertions(+), 25 deletions(-)

--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -27,17 +27,17 @@ static const struct v4l2_fwht_pixfmt_inf
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
 
@@ -175,22 +175,14 @@ static int prepare_raw_frame(struct fwht
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
@@ -198,10 +190,6 @@ static int prepare_raw_frame(struct fwht
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
@@ -209,10 +197,6 @@ static int prepare_raw_frame(struct fwht
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


