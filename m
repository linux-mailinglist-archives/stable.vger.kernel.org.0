Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF495941F7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiHOU6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiHOU4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868D5018C;
        Mon, 15 Aug 2022 12:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC544B810A3;
        Mon, 15 Aug 2022 19:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C2EC433C1;
        Mon, 15 Aug 2022 19:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590742;
        bh=ePW528SVfYKGDNpr7t/sdRXzJL6pdywABBAB/yNipAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7lVgBxX40CioK9bP/9adZJq8Yca4jRlyrg2rJLX/yCdgO0rgGUr1dsW0uKlpARvV
         SU3PEwW4DYkNH8WPA8dqOt6Hwzwo/J1Gcr4qyozL73ARoGDsJFPtGjJ/ivjObQCfwP
         AZPeakRk63+vnny07Tpwc9dWZktWyWbMQ1KJg6CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0356/1095] media: imx-jpeg: Handle source change in a function
Date:   Mon, 15 Aug 2022 19:55:55 +0200
Message-Id: <20220815180444.465933786@linuxfoundation.org>
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

[ Upstream commit 831f87424dd3973612782983ef7352789795b4df ]

Refine code to support dynamic resolution change

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 114 ++++++++++--------
 1 file changed, 65 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index ece53821859c..07eed00ca5e0 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -315,6 +315,9 @@ struct mxc_jpeg_src_buf {
 	/* mxc-jpeg specific */
 	bool			dht_needed;
 	bool			jpeg_parse_error;
+	const struct mxc_jpeg_fmt	*fmt;
+	int			w;
+	int			h;
 };
 
 static inline struct mxc_jpeg_src_buf *vb2_to_mxc_buf(struct vb2_buffer *vb)
@@ -327,6 +330,9 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-3)");
 
+static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q, u32 precision);
+static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q);
+
 static void _bswap16(u16 *a)
 {
 	*a = ((*a & 0x00FF) << 8) | ((*a & 0xFF00) >> 8);
@@ -929,6 +935,59 @@ static void mxc_jpeg_config_enc_desc(struct vb2_buffer *out_buf,
 	mxc_jpeg_set_desc(cfg_desc_handle, reg, slot);
 }
 
+static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
+				   struct mxc_jpeg_src_buf *jpeg_src_buf)
+{
+	struct device *dev = ctx->mxc_jpeg->dev;
+	struct mxc_jpeg_q_data *q_data_cap;
+	bool src_chg = false;
+
+	if (!jpeg_src_buf->fmt)
+		return src_chg;
+
+	q_data_cap = mxc_jpeg_get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	if (q_data_cap->w != jpeg_src_buf->w || q_data_cap->h != jpeg_src_buf->h) {
+		dev_dbg(dev, "Detected jpeg res=(%dx%d)->(%dx%d), pixfmt=%c%c%c%c\n",
+			q_data_cap->w, q_data_cap->h,
+			jpeg_src_buf->w, jpeg_src_buf->h,
+			(jpeg_src_buf->fmt->fourcc & 0xff),
+			(jpeg_src_buf->fmt->fourcc >>  8) & 0xff,
+			(jpeg_src_buf->fmt->fourcc >> 16) & 0xff,
+			(jpeg_src_buf->fmt->fourcc >> 24) & 0xff);
+
+		/*
+		 * set-up the capture queue with the pixelformat and resolution
+		 * detected from the jpeg output stream
+		 */
+		q_data_cap->w = jpeg_src_buf->w;
+		q_data_cap->h = jpeg_src_buf->h;
+		q_data_cap->fmt = jpeg_src_buf->fmt;
+		q_data_cap->w_adjusted = q_data_cap->w;
+		q_data_cap->h_adjusted = q_data_cap->h;
+
+		/*
+		 * align up the resolution for CAST IP,
+		 * but leave the buffer resolution unchanged
+		 */
+		v4l_bound_align_image(&q_data_cap->w_adjusted,
+				      q_data_cap->w_adjusted,  /* adjust up */
+				      MXC_JPEG_MAX_WIDTH,
+				      q_data_cap->fmt->h_align,
+				      &q_data_cap->h_adjusted,
+				      q_data_cap->h_adjusted, /* adjust up */
+				      MXC_JPEG_MAX_HEIGHT,
+				      q_data_cap->fmt->v_align,
+				      0);
+
+		/* setup bytesperline/sizeimage for capture queue */
+		mxc_jpeg_bytesperline(q_data_cap, jpeg_src_buf->fmt->precision);
+		mxc_jpeg_sizeimage(q_data_cap);
+		notify_src_chg(ctx);
+		src_chg = true;
+	}
+	return src_chg;
+}
+
 static void mxc_jpeg_device_run(void *priv)
 {
 	struct mxc_jpeg_ctx *ctx = priv;
@@ -1216,8 +1275,7 @@ static u32 mxc_jpeg_get_image_format(struct device *dev,
 	return fourcc;
 }
 
-static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q,
-				  u32 precision)
+static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q, u32 precision)
 {
 	/* Bytes distance between the leftmost pixels in two adjacent lines */
 	if (q->fmt->fourcc == V4L2_PIX_FMT_JPEG) {
@@ -1268,9 +1326,7 @@ static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q)
 static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 {
 	struct device *dev = ctx->mxc_jpeg->dev;
-	struct mxc_jpeg_q_data *q_data_out, *q_data_cap;
-	enum v4l2_buf_type cap_type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	bool src_chg = false;
+	struct mxc_jpeg_q_data *q_data_out;
 	u32 fourcc;
 	struct v4l2_jpeg_header header;
 	struct mxc_jpeg_sof *psof = NULL;
@@ -1338,51 +1394,11 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 	if (fourcc == 0)
 		return -EINVAL;
 
-	/*
-	 * set-up the capture queue with the pixelformat and resolution
-	 * detected from the jpeg output stream
-	 */
-	q_data_cap = mxc_jpeg_get_q_data(ctx, cap_type);
-	if (q_data_cap->w != header.frame.width ||
-	    q_data_cap->h != header.frame.height)
-		src_chg = true;
-	q_data_cap->w = header.frame.width;
-	q_data_cap->h = header.frame.height;
-	q_data_cap->fmt = mxc_jpeg_find_format(ctx, fourcc);
-	q_data_cap->w_adjusted = q_data_cap->w;
-	q_data_cap->h_adjusted = q_data_cap->h;
-	/*
-	 * align up the resolution for CAST IP,
-	 * but leave the buffer resolution unchanged
-	 */
-	v4l_bound_align_image(&q_data_cap->w_adjusted,
-			      q_data_cap->w_adjusted,  /* adjust up */
-			      MXC_JPEG_MAX_WIDTH,
-			      q_data_cap->fmt->h_align,
-			      &q_data_cap->h_adjusted,
-			      q_data_cap->h_adjusted, /* adjust up */
-			      MXC_JPEG_MAX_HEIGHT,
-			      q_data_cap->fmt->v_align,
-			      0);
-	dev_dbg(dev, "Detected jpeg res=(%dx%d)->(%dx%d), pixfmt=%c%c%c%c\n",
-		q_data_cap->w, q_data_cap->h,
-		q_data_cap->w_adjusted, q_data_cap->h_adjusted,
-		(fourcc & 0xff),
-		(fourcc >>  8) & 0xff,
-		(fourcc >> 16) & 0xff,
-		(fourcc >> 24) & 0xff);
-
-	/* setup bytesperline/sizeimage for capture queue */
-	mxc_jpeg_bytesperline(q_data_cap, q_data_cap->fmt->precision);
-	mxc_jpeg_sizeimage(q_data_cap);
+	jpeg_src_buf->fmt = mxc_jpeg_find_format(ctx, fourcc);
+	jpeg_src_buf->w = header.frame.width;
+	jpeg_src_buf->h = header.frame.height;
 
-	/*
-	 * if the CAPTURE format was updated with new values, regardless of
-	 * whether they match the values set by the client or not, signal
-	 * a source change event
-	 */
-	if (src_chg)
-		notify_src_chg(ctx);
+	mxc_jpeg_source_change(ctx, jpeg_src_buf);
 
 	return 0;
 }
-- 
2.35.1



