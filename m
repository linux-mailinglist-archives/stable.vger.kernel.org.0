Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC215299EEF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395124AbgJ0AKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:10:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439131AbgJ0AKE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 20:10:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B8FA20791;
        Tue, 27 Oct 2020 00:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757404;
        bh=wNjrpoPByKmGM1pKMhLwEeB1fFFK5Z3qMZXzoqDcn2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2/HP8kuYqWuhk5IqnjzCdHSINxI+kvdQJ3fa0F+noGx4HXGlTCOHAuRgw5IyCpHF
         doZhJ68abWI8eWaothnzeqKEn46A2JY8+JVi3ZMEWwW2lj84KcYCzrDvGfLXrHfEwJ
         80vyPsT2+CP87GPMNJbbA8DfbCBUmBXTQHzjnEjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/46] media: videodev2.h: RGB BT2020 and HSV are always full range
Date:   Mon, 26 Oct 2020 20:09:13 -0400
Message-Id: <20201027000946.1026923-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000946.1026923-1-sashal@kernel.org>
References: <20201027000946.1026923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.25.1

