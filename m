Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44652A5446
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387838AbgKCVJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388547AbgKCVJj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1AA020757;
        Tue,  3 Nov 2020 21:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437778;
        bh=ZuFTrDOuM+pycEPjXPSqbaKXZzqr9qUyI4TYfI8Bb2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uo6P/UMoo+ENfqI3iI5ZoJiWj/u26NlfoBBcxfGBZYsyqwjBWqTMjS1jeW4IyFRyd
         35u4Z1ufSRpJtg7/jKhxR+1aM1U9nEeBKdj1z9vTfUGrnr/bXsjnA9Ha73d5kiqt6Q
         eQn/5DSTxj/LrsxTP+S7VBTvYiQOIH0OmL202mMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 029/125] media: videodev2.h: RGB BT2020 and HSV are always full range
Date:   Tue,  3 Nov 2020 21:36:46 +0100
Message-Id: <20201103203200.929914040@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit b305dfe2e93434b12d438434461b709641f62af4 ]

The default RGB quantization range for BT.2020 is full range (just as for
all the other RGB pixel encodings), not limited range.

Update the V4L2_MAP_QUANTIZATION_DEFAULT macro and documentation
accordingly.

Also mention that HSV is always full range and cannot be limited range.

When RGB BT2020 was introduced in V4L2 it was not clear whether it should
be limited or full range, but full range is the right (and consistent)
choice.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/uapi/v4l/colorspaces-defs.rst         |  9 ++++-----
 .../media/uapi/v4l/colorspaces-details.rst      |  5 ++---
 include/uapi/linux/videodev2.h                  | 17 ++++++++---------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
index f24615544792b..16e46bec80934 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
@@ -29,8 +29,7 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
 :c:type:`v4l2_hsv_encoding` specifies which encoding is used.
 
 .. note:: The default R'G'B' quantization is full range for all
-   colorspaces except for BT.2020 which uses limited range R'G'B'
-   quantization.
+   colorspaces. HSV formats are always full range.
 
 .. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
 
@@ -162,8 +161,8 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
       - Details
     * - ``V4L2_QUANTIZATION_DEFAULT``
       - Use the default quantization encoding as defined by the
-	colorspace. This is always full range for R'G'B' (except for the
-	BT.2020 colorspace) and HSV. It is usually limited range for Y'CbCr.
+	colorspace. This is always full range for R'G'B' and HSV.
+	It is usually limited range for Y'CbCr.
     * - ``V4L2_QUANTIZATION_FULL_RANGE``
       - Use the full range quantization encoding. I.e. the range [0…1] is
 	mapped to [0…255] (with possible clipping to [1…254] to avoid the
@@ -173,4 +172,4 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
     * - ``V4L2_QUANTIZATION_LIM_RANGE``
       - Use the limited range quantization encoding. I.e. the range [0…1]
 	is mapped to [16…235]. Cb and Cr are mapped from [-0.5…0.5] to
-	[16…240].
+	[16…240]. Limited Range cannot be used with HSV.
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index 09fabf4cd4126..ca7176cae8dd8 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -370,9 +370,8 @@ Colorspace BT.2020 (V4L2_COLORSPACE_BT2020)
 The :ref:`itu2020` standard defines the colorspace used by Ultra-high
 definition television (UHDTV). The default transfer function is
 ``V4L2_XFER_FUNC_709``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_BT2020``. The default R'G'B' quantization is limited
-range (!), and so is the default Y'CbCr quantization. The chromaticities
-of the primary colors and the white reference are:
+``V4L2_YCBCR_ENC_BT2020``. The default Y'CbCr quantization is limited range.
+The chromaticities of the primary colors and the white reference are:
 
 
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1c095b5a99c58..b773e96b4a286 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -362,9 +362,9 @@ enum v4l2_hsv_encoding {
 
 enum v4l2_quantization {
 	/*
-	 * The default for R'G'B' quantization is always full range, except
-	 * for the BT2020 colorspace. For Y'CbCr the quantization is always
-	 * limited range, except for COLORSPACE_JPEG: this is full range.
+	 * The default for R'G'B' quantization is always full range.
+	 * For Y'CbCr the quantization is always limited range, except
+	 * for COLORSPACE_JPEG: this is full range.
 	 */
 	V4L2_QUANTIZATION_DEFAULT     = 0,
 	V4L2_QUANTIZATION_FULL_RANGE  = 1,
@@ -373,14 +373,13 @@ enum v4l2_quantization {
 
 /*
  * Determine how QUANTIZATION_DEFAULT should map to a proper quantization.
- * This depends on whether the image is RGB or not, the colorspace and the
- * Y'CbCr encoding.
+ * This depends on whether the image is RGB or not, the colorspace.
+ * The Y'CbCr encoding is not used anymore, but is still there for backwards
+ * compatibility.
  */
 #define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb_or_hsv, colsp, ycbcr_enc) \
-	(((is_rgb_or_hsv) && (colsp) == V4L2_COLORSPACE_BT2020) ? \
-	 V4L2_QUANTIZATION_LIM_RANGE : \
-	 (((is_rgb_or_hsv) || (colsp) == V4L2_COLORSPACE_JPEG) ? \
-	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
+	(((is_rgb_or_hsv) || (colsp) == V4L2_COLORSPACE_JPEG) ? \
+	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE)
 
 enum v4l2_priority {
 	V4L2_PRIORITY_UNSET       = 0,  /* not initialized */
-- 
2.27.0



