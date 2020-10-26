Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB8229A030
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411615AbgJ0A2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:28:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409893AbgJZXww (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAAB220B1F;
        Mon, 26 Oct 2020 23:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756371;
        bh=PGWGpOnCecnGScX0XOsk0h7o5PYIxNdHUlTgmCA5Qk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/uolLXsXGpySPkMTY019Jr8EQqGNUR93X1J5H464AfRXx4ql8C1f4+1gU3op6o4O
         QQQj2ujYQzowm0Dtx/D+MF3J9ttwWOk/mJjgemR4Ffk3XJ6dPqTNfZqkAzdTp2+KZs
         s4mNvv9XcjSKdv5WGQKQNxFOBDPNAdUWbpVlXlrI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 038/132] media: videodev2.h: RGB BT2020 and HSV are always full range
Date:   Mon, 26 Oct 2020 19:50:30 -0400
Message-Id: <20201026235205.1023962-38-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
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
 .../media/v4l/colorspaces-defs.rst              |  9 ++++-----
 .../media/v4l/colorspaces-details.rst           |  5 ++---
 include/uapi/linux/videodev2.h                  | 17 ++++++++---------
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/colorspaces-defs.rst b/Documentation/userspace-api/media/v4l/colorspaces-defs.rst
index 01404e1f609a7..4089f426258d6 100644
--- a/Documentation/userspace-api/media/v4l/colorspaces-defs.rst
+++ b/Documentation/userspace-api/media/v4l/colorspaces-defs.rst
@@ -36,8 +36,7 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
 :c:type:`v4l2_hsv_encoding` specifies which encoding is used.
 
 .. note:: The default R'G'B' quantization is full range for all
-   colorspaces except for BT.2020 which uses limited range R'G'B'
-   quantization.
+   colorspaces. HSV formats are always full range.
 
 .. tabularcolumns:: |p{6.7cm}|p{10.8cm}|
 
@@ -169,8 +168,8 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
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
@@ -180,4 +179,4 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
     * - ``V4L2_QUANTIZATION_LIM_RANGE``
       - Use the limited range quantization encoding. I.e. the range [0…1]
 	is mapped to [16…235]. Cb and Cr are mapped from [-0.5…0.5] to
-	[16…240].
+	[16…240]. Limited Range cannot be used with HSV.
diff --git a/Documentation/userspace-api/media/v4l/colorspaces-details.rst b/Documentation/userspace-api/media/v4l/colorspaces-details.rst
index 79ed6f4f76eb3..fd9ddda4e0256 100644
--- a/Documentation/userspace-api/media/v4l/colorspaces-details.rst
+++ b/Documentation/userspace-api/media/v4l/colorspaces-details.rst
@@ -377,9 +377,8 @@ Colorspace BT.2020 (V4L2_COLORSPACE_BT2020)
 The :ref:`itu2020` standard defines the colorspace used by Ultra-high
 definition television (UHDTV). The default transfer function is
 ``V4L2_XFER_FUNC_709``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_BT2020``. The default R'G'B' quantization is limited
-range (!), and so is the default Y'CbCr quantization. The chromaticities
-of the primary colors and the white reference are:
+``V4L2_YCBCR_ENC_BT2020``. The default Y'CbCr quantization is limited range.
+The chromaticities of the primary colors and the white reference are:
 
 
 
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c3a1cf1c507f5..dd2f95c32e730 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -371,9 +371,9 @@ enum v4l2_hsv_encoding {
 
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
@@ -382,14 +382,13 @@ enum v4l2_quantization {
 
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
 
 /*
  * Deprecated names for opRGB colorspace (IEC 61966-2-5)
-- 
2.25.1

