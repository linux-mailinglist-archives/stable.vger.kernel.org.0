Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2A62A579B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgKCVoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:44:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731797AbgKCUyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:54:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD99223BF;
        Tue,  3 Nov 2020 20:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436853;
        bh=SIPuJkqwq2Pg8RInx1dUG+PO9Wdj7XY4/3sehasBHrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRE/JuskNP2GHgZmXqImBuneOw5PgVaptX4nn3zJwvJwTy5GKdxDURlzu6t48dsGp
         xma8u2jRONwUDw7uz7shW9LafguH1KNrqIO/fZZkkF1pj8IsZBVbdtedEmDXowq9SE
         FfAfkFCgG+tD+fN7AA2pBRLT+dh+XcQjaE+vGwlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/214] media: videodev2.h: RGB BT2020 and HSV are always full range
Date:   Tue,  3 Nov 2020 21:34:48 +0100
Message-Id: <20201103203253.844746516@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
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
index e122bbe3d799d..aabb08130354a 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
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
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index 8b0ba3668101d..fd0cf57691d87 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
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
index 530638dffd934..3210b3c82a4a2 100644
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
2.27.0



