Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8C4594139
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243421AbiHOU6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347256AbiHOU4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E99C04D1;
        Mon, 15 Aug 2022 12:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A7136009B;
        Mon, 15 Aug 2022 19:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DAFC433C1;
        Mon, 15 Aug 2022 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590739;
        bh=q8DmXpApjTRhuYKV877tAEMr7eqPy0HS6qO4TMdtMGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2VPjK3hoSjUWuzD4v0dmQgXdRxIDARzhofF0rirYusyP3unM6jy82YshKlC81ZK5g
         SN38NsygxyXc5M802qsSlraeEGothj2XVYynuQ4FFTdK4TkWcNcMduLS3X2Zvhqno+
         bGL4Ge2lIO7zjSOmw6uMJq2hMhHHTZioA3itHVyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0355/1095] media: imx-jpeg: Identify and handle precision correctly
Date:   Mon, 15 Aug 2022 19:55:54 +0200
Message-Id: <20220815180444.421024205@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit bec0a3a67389ede106d0661a007edf832878d8b2 ]

The decoder will save the precision that was detected from jpeg header
and use it later, when choosing the pixel format and also calculate
bytesperline according to precision.

The 12bit jpeg is not supported yet,
but driver shouldn't led to serious problem if user enqueue a 12 bit jpeg.
And the 12bit jpeg is supported by hardware, driver may support it later.

[hverkuil: document the new precision field]

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 37 +++++++++++++------
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  2 +
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index d5a4d66b3998..ece53821859c 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -82,6 +82,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 3,
 		.v_align	= 3,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 	{
 		.name		= "ARGB", /* ARGBARGB packed format */
@@ -93,6 +94,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 3,
 		.v_align	= 3,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 	{
 		.name		= "YUV420", /* 1st plane = Y, 2nd plane = UV */
@@ -104,6 +106,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 4,
 		.v_align	= 4,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 	{
 		.name		= "YUV422", /* YUYV */
@@ -115,6 +118,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 4,
 		.v_align	= 3,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 	{
 		.name		= "YUV444", /* YUVYUV */
@@ -126,6 +130,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 3,
 		.v_align	= 3,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 	{
 		.name		= "Gray", /* Gray (Y8/Y12) or Single Comp */
@@ -137,6 +142,7 @@ static const struct mxc_jpeg_fmt mxc_formats[] = {
 		.h_align	= 3,
 		.v_align	= 3,
 		.flags		= MXC_JPEG_FMT_TYPE_RAW,
+		.precision	= 8,
 	},
 };
 
@@ -1182,14 +1188,17 @@ static u32 mxc_jpeg_get_image_format(struct device *dev,
 
 	for (i = 0; i < MXC_JPEG_NUM_FORMATS; i++)
 		if (mxc_formats[i].subsampling == header->frame.subsampling &&
-		    mxc_formats[i].nc == header->frame.num_components) {
+		    mxc_formats[i].nc == header->frame.num_components &&
+		    mxc_formats[i].precision == header->frame.precision) {
 			fourcc = mxc_formats[i].fourcc;
 			break;
 		}
 	if (fourcc == 0) {
-		dev_err(dev, "Could not identify image format nc=%d, subsampling=%d\n",
+		dev_err(dev,
+			"Could not identify image format nc=%d, subsampling=%d, precision=%d\n",
 			header->frame.num_components,
-			header->frame.subsampling);
+			header->frame.subsampling,
+			header->frame.precision);
 		return fourcc;
 	}
 	/*
@@ -1215,18 +1224,22 @@ static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q,
 		/* bytesperline unused for compressed formats */
 		q->bytesperline[0] = 0;
 		q->bytesperline[1] = 0;
-	} else if (q->fmt->fourcc == V4L2_PIX_FMT_NV12M) {
+	} else if (q->fmt->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_420) {
 		/* When the image format is planar the bytesperline value
 		 * applies to the first plane and is divided by the same factor
 		 * as the width field for the other planes
 		 */
-		q->bytesperline[0] = q->w * (precision / 8) *
-				     (q->fmt->depth / 8);
+		q->bytesperline[0] = q->w * DIV_ROUND_UP(precision, 8);
 		q->bytesperline[1] = q->bytesperline[0];
+	} else if (q->fmt->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_422) {
+		q->bytesperline[0] = q->w * DIV_ROUND_UP(precision, 8) * 2;
+		q->bytesperline[1] = 0;
+	} else if (q->fmt->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_444) {
+		q->bytesperline[0] = q->w * DIV_ROUND_UP(precision, 8) * q->fmt->nc;
+		q->bytesperline[1] = 0;
 	} else {
-		/* single plane formats */
-		q->bytesperline[0] = q->w * (precision / 8) *
-				     (q->fmt->depth / 8);
+		/* grayscale */
+		q->bytesperline[0] = q->w * DIV_ROUND_UP(precision, 8);
 		q->bytesperline[1] = 0;
 	}
 }
@@ -1360,7 +1373,7 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 		(fourcc >> 24) & 0xff);
 
 	/* setup bytesperline/sizeimage for capture queue */
-	mxc_jpeg_bytesperline(q_data_cap, header.frame.precision);
+	mxc_jpeg_bytesperline(q_data_cap, q_data_cap->fmt->precision);
 	mxc_jpeg_sizeimage(q_data_cap);
 
 	/*
@@ -1516,7 +1529,7 @@ static void mxc_jpeg_set_default_params(struct mxc_jpeg_ctx *ctx)
 		q[i]->h = MXC_JPEG_DEFAULT_HEIGHT;
 		q[i]->w_adjusted = MXC_JPEG_DEFAULT_WIDTH;
 		q[i]->h_adjusted = MXC_JPEG_DEFAULT_HEIGHT;
-		mxc_jpeg_bytesperline(q[i], 8);
+		mxc_jpeg_bytesperline(q[i], q[i]->fmt->precision);
 		mxc_jpeg_sizeimage(q[i]);
 	}
 }
@@ -1658,7 +1671,7 @@ static int mxc_jpeg_try_fmt(struct v4l2_format *f, const struct mxc_jpeg_fmt *fm
 	}
 
 	/* calculate bytesperline & sizeimage into the tmp_q */
-	mxc_jpeg_bytesperline(&tmp_q, 8);
+	mxc_jpeg_bytesperline(&tmp_q, fmt->precision);
 	mxc_jpeg_sizeimage(&tmp_q);
 
 	/* adjust user format according to our calculations */
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index f53f004ba851..2b4b30d01e51 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -49,6 +49,7 @@ enum mxc_jpeg_mode {
  * @h_align:	horizontal alignment order (align to 2^h_align)
  * @v_align:	vertical alignment order (align to 2^v_align)
  * @flags:	flags describing format applicability
+ * @precision:  jpeg sample precision
  */
 struct mxc_jpeg_fmt {
 	const char				*name;
@@ -60,6 +61,7 @@ struct mxc_jpeg_fmt {
 	int					h_align;
 	int					v_align;
 	u32					flags;
+	u8					precision;
 };
 
 struct mxc_jpeg_desc {
-- 
2.35.1



