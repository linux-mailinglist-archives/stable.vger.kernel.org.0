Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B825936AB
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbiHOSrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243588AbiHOSow (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:44:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2523C30540;
        Mon, 15 Aug 2022 11:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DB9BB8107D;
        Mon, 15 Aug 2022 18:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA10C433D6;
        Mon, 15 Aug 2022 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588044;
        bh=YZkmjwX7Z1FgL8qC8zGujWuyNfh/J5kjf4QiARB3t4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDtKmhIOaLmI9l/7mFm/bX9viVc/CDlz5zKvBk8vCgWjHknPV3hu71ilmFHtAF/QU
         Iq0Mf5BmgxSZTFR9sHYXAwbJWDxRPGPVXwbSKofnAq3ghP9huCmWBh00b9HumGNrfh
         NnDclh9ExMQytP2uaZF41NimL/FPnHs4mO0pzcwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/779] media: imx-jpeg: Align upwards buffer size
Date:   Mon, 15 Aug 2022 19:58:41 +0200
Message-Id: <20220815180349.152856750@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 88 +++++++++-------------
 1 file changed, 37 insertions(+), 51 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 52732fbb2664..e043023836e3 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -875,8 +875,8 @@ static void mxc_jpeg_config_enc_desc(struct vb2_buffer *out_buf,
 	jpeg->slot_data[slot].cfg_stream_size =
 			mxc_jpeg_setup_cfg_stream(cfg_stream_vaddr,
 						  q_data->fmt->fourcc,
-						  q_data->w_adjusted,
-						  q_data->h_adjusted);
+						  q_data->w,
+						  q_data->h);
 
 	/* chain the config descriptor with the encoding descriptor */
 	cfg_desc->next_descpt_ptr = desc_handle | MXC_NXT_DESCPT_EN;
@@ -956,7 +956,7 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 				      &q_data_cap->h_adjusted,
 				      q_data_cap->h_adjusted, /* adjust up */
 				      MXC_JPEG_MAX_HEIGHT,
-				      q_data_cap->fmt->v_align,
+				      0,
 				      0);
 
 		/* setup bytesperline/sizeimage for capture queue */
@@ -1145,16 +1145,28 @@ static int mxc_jpeg_queue_setup(struct vb2_queue *q,
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
 		for (i = 0; i < *nplanes; i++) {
-			if (sizes[i] < q_data->sizeimage[i])
+			if (sizes[i] < tmp_q.sizeimage[i])
 				return -EINVAL;
 		}
 		return 0;
@@ -1163,7 +1175,7 @@ static int mxc_jpeg_queue_setup(struct vb2_queue *q,
 	/* Handle REQBUFS situation */
 	*nplanes = q_data->fmt->colplanes;
 	for (i = 0; i < *nplanes; i++)
-		sizes[i] = q_data->sizeimage[i];
+		sizes[i] = tmp_q.sizeimage[i];
 
 	return 0;
 }
@@ -1363,11 +1375,6 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
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
@@ -1679,22 +1686,17 @@ static int mxc_jpeg_try_fmt(struct v4l2_format *f, const struct mxc_jpeg_fmt *fm
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
@@ -1820,35 +1822,19 @@ static int mxc_jpeg_s_fmt(struct mxc_jpeg_ctx *ctx,
 
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



