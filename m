Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73629594854
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiHOXc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353509AbiHOXbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:31:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4A7150147;
        Mon, 15 Aug 2022 13:08:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7DF360DE3;
        Mon, 15 Aug 2022 20:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF442C433C1;
        Mon, 15 Aug 2022 20:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594096;
        bh=j8eHhZUi006HU7xk2wsUSTgcfGXp+vV0fSTggQvgcAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUgvPXeiFpcqAliaRoILQYuO2oYQ67P/HAet+lQH5l/qEXEE6p1qSM9VlvxNkJLdm
         G++me1WgPJ+2h+bGByq8jDVrS4FcijqdoO3kIAqnGCjCOHtXMVLCVRjQP7/vi/6b1t
         cB+mEEgrJaYSuvomzqQEjUCyyADnL1s1F812gQpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0378/1157] media: imx-jpeg: Align upwards buffer size
Date:   Mon, 15 Aug 2022 19:55:34 +0200
Message-Id: <20220815180454.846940656@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 9e7aa76cdb02923ee23a0ddd48f38bdc3512f92b ]

The hardware can support any image size WxH,
with arbitrary W (image width) and H (image height) dimensions.

Align upwards buffer size for both encoder and decoder.
and leave the picture resolution unchanged.

For decoder, the risk of memory out of bounds can be avoided.
For both encoder and decoder, the driver will lift the limitation of
resolution alignment.

For example, the decoder can support jpeg whose resolution is 227x149
the encoder can support nv12 1080P, won't change it to 1920x1072.

Fixes: 2db16c6ed72ce ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 88 ++++++++-----------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index dd264b82d0dd..9b8451b56657 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -894,8 +894,8 @@ static void mxc_jpeg_config_enc_desc(struct vb2_buffer *out_buf,
 	jpeg->slot_data[slot].cfg_stream_size =
 			mxc_jpeg_setup_cfg_stream(cfg_stream_vaddr,
 						  q_data->fmt->fourcc,
-						  q_data->w_adjusted,
-						  q_data->h_adjusted);
+						  q_data->w,
+						  q_data->h);
 
 	/* chain the config descriptor with the encoding descriptor */
 	cfg_desc->next_descpt_ptr = desc_handle | MXC_NXT_DESCPT_EN;
@@ -977,7 +977,7 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 				      &q_data_cap->h_adjusted,
 				      q_data_cap->h_adjusted, /* adjust up */
 				      MXC_JPEG_MAX_HEIGHT,
-				      q_data_cap->fmt->v_align,
+				      0,
 				      0);
 
 		/* setup bytesperline/sizeimage for capture queue */
@@ -1161,18 +1161,30 @@ static int mxc_jpeg_queue_setup(struct vb2_queue *q,
 {
 	struct mxc_jpeg_ctx *ctx = vb2_get_drv_priv(q);
 	struct mxc_jpeg_q_data *q_data = NULL;
+	struct mxc_jpeg_q_data tmp_q;
 	int i;
 
 	q_data = mxc_jpeg_get_q_data(ctx, q->type);
 	if (!q_data)
 		return -EINVAL;
 
+	tmp_q.fmt = q_data->fmt;
+	tmp_q.w = q_data->w_adjusted;
+	tmp_q.h = q_data->h_adjusted;
+	for (i = 0; i < MXC_JPEG_MAX_PLANES; i++) {
+		tmp_q.bytesperline[i] = q_data->bytesperline[i];
+		tmp_q.sizeimage[i] = q_data->sizeimage[i];
+	}
+	mxc_jpeg_sizeimage(&tmp_q);
+	for (i = 0; i < MXC_JPEG_MAX_PLANES; i++)
+		tmp_q.sizeimage[i] = max(tmp_q.sizeimage[i], q_data->sizeimage[i]);
+
 	/* Handle CREATE_BUFS situation - *nplanes != 0 */
 	if (*nplanes) {
 		if (*nplanes != q_data->fmt->colplanes)
 			return -EINVAL;
 		for (i = 0; i < *nplanes; i++) {
-			if (sizes[i] < q_data->sizeimage[i])
+			if (sizes[i] < tmp_q.sizeimage[i])
 				return -EINVAL;
 		}
 		return 0;
@@ -1181,7 +1193,7 @@ static int mxc_jpeg_queue_setup(struct vb2_queue *q,
 	/* Handle REQBUFS situation */
 	*nplanes = q_data->fmt->colplanes;
 	for (i = 0; i < *nplanes; i++)
-		sizes[i] = q_data->sizeimage[i];
+		sizes[i] = tmp_q.sizeimage[i];
 
 	return 0;
 }
@@ -1381,11 +1393,6 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 	}
 	q_data_out->w = header.frame.width;
 	q_data_out->h = header.frame.height;
-	if (header.frame.width % 8 != 0 || header.frame.height % 8 != 0) {
-		dev_err(dev, "JPEG width or height not multiple of 8: %dx%d\n",
-			header.frame.width, header.frame.height);
-		return -EINVAL;
-	}
 	if (header.frame.width > MXC_JPEG_MAX_WIDTH ||
 	    header.frame.height > MXC_JPEG_MAX_HEIGHT) {
 		dev_err(dev, "JPEG width or height should be <= 8192: %dx%d\n",
@@ -1691,22 +1698,17 @@ static int mxc_jpeg_try_fmt(struct v4l2_format *f, const struct mxc_jpeg_fmt *fm
 	pix_mp->num_planes = fmt->colplanes;
 	pix_mp->pixelformat = fmt->fourcc;
 
-	/*
-	 * use MXC_JPEG_H_ALIGN instead of fmt->v_align, for vertical
-	 * alignment, to loosen up the alignment to multiple of 8,
-	 * otherwise NV12-1080p fails as 1080 is not a multiple of 16
-	 */
+	pix_mp->width = w;
+	pix_mp->height = h;
 	v4l_bound_align_image(&w,
-			      MXC_JPEG_MIN_WIDTH,
-			      w, /* adjust downwards*/
+			      w, /* adjust upwards*/
+			      MXC_JPEG_MAX_WIDTH,
 			      fmt->h_align,
 			      &h,
-			      MXC_JPEG_MIN_HEIGHT,
-			      h, /* adjust downwards*/
-			      MXC_JPEG_H_ALIGN,
+			      h, /* adjust upwards*/
+			      MXC_JPEG_MAX_HEIGHT,
+			      0,
 			      0);
-	pix_mp->width = w; /* negotiate the width */
-	pix_mp->height = h; /* negotiate the height */
 
 	/* get user input into the tmp_q */
 	tmp_q.w = w;
@@ -1832,35 +1834,19 @@ static int mxc_jpeg_s_fmt(struct mxc_jpeg_ctx *ctx,
 
 	q_data->w_adjusted = q_data->w;
 	q_data->h_adjusted = q_data->h;
-	if (jpeg->mode == MXC_JPEG_DECODE) {
-		/*
-		 * align up the resolution for CAST IP,
-		 * but leave the buffer resolution unchanged
-		 */
-		v4l_bound_align_image(&q_data->w_adjusted,
-				      q_data->w_adjusted,  /* adjust upwards */
-				      MXC_JPEG_MAX_WIDTH,
-				      q_data->fmt->h_align,
-				      &q_data->h_adjusted,
-				      q_data->h_adjusted, /* adjust upwards */
-				      MXC_JPEG_MAX_HEIGHT,
-				      q_data->fmt->v_align,
-				      0);
-	} else {
-		/*
-		 * align down the resolution for CAST IP,
-		 * but leave the buffer resolution unchanged
-		 */
-		v4l_bound_align_image(&q_data->w_adjusted,
-				      MXC_JPEG_MIN_WIDTH,
-				      q_data->w_adjusted, /* adjust downwards*/
-				      q_data->fmt->h_align,
-				      &q_data->h_adjusted,
-				      MXC_JPEG_MIN_HEIGHT,
-				      q_data->h_adjusted, /* adjust downwards*/
-				      q_data->fmt->v_align,
-				      0);
-	}
+	/*
+	 * align up the resolution for CAST IP,
+	 * but leave the buffer resolution unchanged
+	 */
+	v4l_bound_align_image(&q_data->w_adjusted,
+			      q_data->w_adjusted,  /* adjust upwards */
+			      MXC_JPEG_MAX_WIDTH,
+			      q_data->fmt->h_align,
+			      &q_data->h_adjusted,
+			      q_data->h_adjusted, /* adjust upwards */
+			      MXC_JPEG_MAX_HEIGHT,
+			      q_data->fmt->v_align,
+			      0);
 
 	for (i = 0; i < pix_mp->num_planes; i++) {
 		q_data->bytesperline[i] = pix_mp->plane_fmt[i].bytesperline;
-- 
2.35.1



