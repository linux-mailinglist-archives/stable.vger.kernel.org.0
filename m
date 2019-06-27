Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3BF4575EE
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfF0Ad4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbfF0Adx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:53 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F79A216E3;
        Thu, 27 Jun 2019 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595633;
        bh=If2G9GQvdAwhPPWjNUdvW+SrABwh/XflP0jCuvscpdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw5rbfCzlHptPgebGUyJpPvF1NXoGuvpy42zBQ+wrZDnKw/aB08dwvO/j+N9YMc3s
         qTJg3lCN6sXSpPBs55ZSq8axnvsSLRvjjvBNRMG+tQzqVFRCOxGOkaVOO1rJS+84yp
         7wTgfEo4t3IOjHBRC0OsFSGJl2GcWa3Y3lG8amlo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 61/95] gpu: ipu-v3: image-convert: Fix input bytesperline width/height align
Date:   Wed, 26 Jun 2019 20:29:46 -0400
Message-Id: <20190627003021.19867-61-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve Longerbeam <slongerbeam@gmail.com>

[ Upstream commit ff391ecd65a1b8324c49046c3db98d9c8ab29af9 ]

The output width and height alignment values were being used in the
input bytesperline calculation. Fix by separating local vars w_align
and h_align into w_align_in, h_align_in, w_align_out, and h_align_out.

Fixes: d966e23d61a2c ("gpu: ipu-v3: image-convert: fix bytesperline
adjustment")

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 32 +++++++++++++++++---------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 13103ab86050..0d971985f8c9 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -1885,7 +1885,8 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 			      enum ipu_rotate_mode rot_mode)
 {
 	const struct ipu_image_pixfmt *infmt, *outfmt;
-	u32 w_align, h_align;
+	u32 w_align_out, h_align_out;
+	u32 w_align_in, h_align_in;
 
 	infmt = get_format(in->pix.pixelformat);
 	outfmt = get_format(out->pix.pixelformat);
@@ -1917,22 +1918,31 @@ void ipu_image_convert_adjust(struct ipu_image *in, struct ipu_image *out,
 	}
 
 	/* align input width/height */
-	w_align = ilog2(tile_width_align(IMAGE_CONVERT_IN, infmt, rot_mode));
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_IN, infmt, rot_mode));
-	in->pix.width = clamp_align(in->pix.width, MIN_W, MAX_W, w_align);
-	in->pix.height = clamp_align(in->pix.height, MIN_H, MAX_H, h_align);
+	w_align_in = ilog2(tile_width_align(IMAGE_CONVERT_IN, infmt,
+					    rot_mode));
+	h_align_in = ilog2(tile_height_align(IMAGE_CONVERT_IN, infmt,
+					     rot_mode));
+	in->pix.width = clamp_align(in->pix.width, MIN_W, MAX_W,
+				    w_align_in);
+	in->pix.height = clamp_align(in->pix.height, MIN_H, MAX_H,
+				     h_align_in);
 
 	/* align output width/height */
-	w_align = ilog2(tile_width_align(IMAGE_CONVERT_OUT, outfmt, rot_mode));
-	h_align = ilog2(tile_height_align(IMAGE_CONVERT_OUT, outfmt, rot_mode));
-	out->pix.width = clamp_align(out->pix.width, MIN_W, MAX_W, w_align);
-	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H, h_align);
+	w_align_out = ilog2(tile_width_align(IMAGE_CONVERT_OUT, outfmt,
+					     rot_mode));
+	h_align_out = ilog2(tile_height_align(IMAGE_CONVERT_OUT, outfmt,
+					      rot_mode));
+	out->pix.width = clamp_align(out->pix.width, MIN_W, MAX_W,
+				     w_align_out);
+	out->pix.height = clamp_align(out->pix.height, MIN_H, MAX_H,
+				      h_align_out);
 
 	/* set input/output strides and image sizes */
 	in->pix.bytesperline = infmt->planar ?
-		clamp_align(in->pix.width, 2 << w_align, MAX_W, w_align) :
+		clamp_align(in->pix.width, 2 << w_align_in, MAX_W,
+			    w_align_in) :
 		clamp_align((in->pix.width * infmt->bpp) >> 3,
-			    2 << w_align, MAX_W, w_align);
+			    2 << w_align_in, MAX_W, w_align_in);
 	in->pix.sizeimage = infmt->planar ?
 		(in->pix.height * in->pix.bytesperline * infmt->bpp) >> 3 :
 		in->pix.height * in->pix.bytesperline;
-- 
2.20.1

