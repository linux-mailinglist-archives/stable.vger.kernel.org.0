Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324275936D4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbiHOSrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243519AbiHOSom (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:44:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0D2FFE7;
        Mon, 15 Aug 2022 11:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62E24B8107B;
        Mon, 15 Aug 2022 18:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9495DC433D6;
        Mon, 15 Aug 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588038;
        bh=hlUezt4dDe5NSypX1nefqTVbi2t5LWEChRAf2JC1sIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+t/oMifAe1S47VKneEAstlcIgWcoC8Oyc5Ip9e2lf0KNp5PF24yOOtdmNsqfDja4
         h/Jhz8ujZO7bPL3ac3IfWJbdHnGMZEtR7uZA6CmUCBj1oDF/5WwuvbVwtKsvIp/zx2
         l5VJCjaFdEbYcEReHvKTXFTGEA9taZUQffCFDCy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 275/779] media: imx-jpeg: Handle source change in a function
Date:   Mon, 15 Aug 2022 19:58:39 +0200
Message-Id: <20220815180349.062957517@linuxfoundation.org>
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

[ Upstream commit 831f87424dd3973612782983ef7352789795b4df ]

Refine code to support dynamic resolution change

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 114 ++++++++++++---------
 1 file changed, 65 insertions(+), 49 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 718de999987e..6289fec6e2a0 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -301,6 +301,9 @@ struct mxc_jpeg_src_buf {
 	/* mxc-jpeg specific */
 	bool			dht_needed;
 	bool			jpeg_parse_error;
+	const struct mxc_jpeg_fmt	*fmt;
+	int			w;
+	int			h;
 };
 
 static inline struct mxc_jpeg_src_buf *vb2_to_mxc_buf(struct vb2_buffer *vb)
@@ -313,6 +316,9 @@ static unsigned int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-3)");
 
+static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q, u32 precision);
+static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q);
+
 static void _bswap16(u16 *a)
 {
 	*a = ((*a & 0x00FF) << 8) | ((*a & 0xFF00) >> 8);
@@ -908,6 +914,59 @@ static void mxc_jpeg_config_enc_desc(struct vb2_buffer *out_buf,
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
@@ -1200,8 +1259,7 @@ static u32 mxc_jpeg_get_image_format(struct device *dev,
 	return fourcc;
 }
 
-static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q,
-				  u32 precision)
+static void mxc_jpeg_bytesperline(struct mxc_jpeg_q_data *q, u32 precision)
 {
 	/* Bytes distance between the leftmost pixels in two adjacent lines */
 	if (q->fmt->fourcc == V4L2_PIX_FMT_JPEG) {
@@ -1252,9 +1310,7 @@ static void mxc_jpeg_sizeimage(struct mxc_jpeg_q_data *q)
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
@@ -1322,51 +1378,11 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
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



