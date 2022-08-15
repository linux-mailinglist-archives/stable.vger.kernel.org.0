Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1301A5940BF
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245080AbiHOU67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiHOU5a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:57:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD61DC0E5E;
        Mon, 15 Aug 2022 12:12:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD96B81113;
        Mon, 15 Aug 2022 19:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBC7C433D6;
        Mon, 15 Aug 2022 19:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590745;
        bh=RDqPj1c2xIHj5AP3Up1tac/9WN9yr7QGN8JP2/eJzOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WI7dRc8tOQV4du1AF69huOdN8Cb26kmfDj50R4itSQS/yGcoefLHRXBF+NuBGNqe2
         JDrdfHQ5t3ZlG9xi3lCBHwSPgY54PAPrBTRuxRCEeKklFqL7WqMzf3ABUSERmo+0OD
         hCS4WSUqzzjHY0stfAYjgXD5B/YKvwnRjHelQCwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0357/1095] media: imx-jpeg: Support dynamic resolution change
Date:   Mon, 15 Aug 2022 19:55:56 +0200
Message-Id: <20220815180444.513412725@linuxfoundation.org>
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

[ Upstream commit b4e1fb8643daabba850e97df532191acffc23e6a ]

To support dynamic resolution change,
driver should meet the following conditions:
1. the previous pictures are all decoded before source change event.
2. prevent decoding new resolution pictures with incorrect capture
   buffer, until user handle source change event and setup capture.
3. report correct fmt and resolution during source change.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 69 ++++++++++++++-----
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  2 +
 2 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 07eed00ca5e0..eea03556bec7 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -940,13 +940,14 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 {
 	struct device *dev = ctx->mxc_jpeg->dev;
 	struct mxc_jpeg_q_data *q_data_cap;
-	bool src_chg = false;
 
 	if (!jpeg_src_buf->fmt)
-		return src_chg;
+		return false;
 
 	q_data_cap = mxc_jpeg_get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	if (q_data_cap->w != jpeg_src_buf->w || q_data_cap->h != jpeg_src_buf->h) {
+	if (q_data_cap->fmt != jpeg_src_buf->fmt ||
+	    q_data_cap->w != jpeg_src_buf->w ||
+	    q_data_cap->h != jpeg_src_buf->h) {
 		dev_dbg(dev, "Detected jpeg res=(%dx%d)->(%dx%d), pixfmt=%c%c%c%c\n",
 			q_data_cap->w, q_data_cap->h,
 			jpeg_src_buf->w, jpeg_src_buf->h,
@@ -983,9 +984,16 @@ static bool mxc_jpeg_source_change(struct mxc_jpeg_ctx *ctx,
 		mxc_jpeg_bytesperline(q_data_cap, jpeg_src_buf->fmt->precision);
 		mxc_jpeg_sizeimage(q_data_cap);
 		notify_src_chg(ctx);
-		src_chg = true;
+		ctx->source_change = 1;
 	}
-	return src_chg;
+	return ctx->source_change ? true : false;
+}
+
+static int mxc_jpeg_job_ready(void *priv)
+{
+	struct mxc_jpeg_ctx *ctx = priv;
+
+	return ctx->source_change ? 0 : 1;
 }
 
 static void mxc_jpeg_device_run(void *priv)
@@ -1035,6 +1043,13 @@ static void mxc_jpeg_device_run(void *priv)
 
 		return;
 	}
+	if (ctx->mxc_jpeg->mode == MXC_JPEG_DECODE) {
+		if (ctx->source_change || mxc_jpeg_source_change(ctx, jpeg_src_buf)) {
+			spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
+			v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
+			return;
+		}
+	}
 
 	mxc_jpeg_enable(reg);
 	mxc_jpeg_set_l_endian(reg, 1);
@@ -1081,6 +1096,7 @@ static void mxc_jpeg_set_last_buffer_dequeued(struct mxc_jpeg_ctx *ctx)
 	q->last_buffer_dequeued = true;
 	wake_up(&q->done_wq);
 	ctx->stopped = 0;
+	ctx->header_parsed = false;
 }
 
 static int mxc_jpeg_decoder_cmd(struct file *file, void *priv,
@@ -1174,6 +1190,8 @@ static int mxc_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct mxc_jpeg_q_data *q_data = mxc_jpeg_get_q_data(ctx, q->type);
 	int ret;
 
+	if (ctx->mxc_jpeg->mode == MXC_JPEG_DECODE && V4L2_TYPE_IS_CAPTURE(q->type))
+		ctx->source_change = 0;
 	dev_dbg(ctx->mxc_jpeg->dev, "Start streaming ctx=%p", ctx);
 	q_data->sequence = 0;
 
@@ -1352,16 +1370,15 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 		dev_warn(dev, "Invalid user resolution 0x0");
 		dev_warn(dev, "Keeping resolution from JPEG: %dx%d",
 			 header.frame.width, header.frame.height);
-		q_data_out->w = header.frame.width;
-		q_data_out->h = header.frame.height;
 	} else if (header.frame.width != q_data_out->w ||
 		   header.frame.height != q_data_out->h) {
 		dev_err(dev,
 			"Resolution mismatch: %dx%d (JPEG) versus %dx%d(user)",
 			header.frame.width, header.frame.height,
 			q_data_out->w, q_data_out->h);
-		return -EINVAL;
 	}
+	q_data_out->w = header.frame.width;
+	q_data_out->h = header.frame.height;
 	if (header.frame.width % 8 != 0 || header.frame.height % 8 != 0) {
 		dev_err(dev, "JPEG width or height not multiple of 8: %dx%d\n",
 			header.frame.width, header.frame.height);
@@ -1397,8 +1414,10 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 	jpeg_src_buf->fmt = mxc_jpeg_find_format(ctx, fourcc);
 	jpeg_src_buf->w = header.frame.width;
 	jpeg_src_buf->h = header.frame.height;
+	ctx->header_parsed = true;
 
-	mxc_jpeg_source_change(ctx, jpeg_src_buf);
+	if (!v4l2_m2m_num_src_bufs_ready(ctx->fh.m2m_ctx))
+		mxc_jpeg_source_change(ctx, jpeg_src_buf);
 
 	return 0;
 }
@@ -1475,6 +1494,7 @@ static void mxc_jpeg_buf_finish(struct vb2_buffer *vb)
 	if (list_empty(&q->done_list)) {
 		vbuf->flags |= V4L2_BUF_FLAG_LAST;
 		ctx->stopped = 0;
+		ctx->header_parsed = false;
 	}
 }
 
@@ -1620,26 +1640,42 @@ static int mxc_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
 	struct mxc_jpeg_ctx *ctx = mxc_jpeg_fh_to_ctx(priv);
+	struct mxc_jpeg_q_data *q_data = mxc_jpeg_get_q_data(ctx, f->type);
 
-	if (ctx->mxc_jpeg->mode == MXC_JPEG_ENCODE)
+	if (ctx->mxc_jpeg->mode == MXC_JPEG_ENCODE) {
 		return enum_fmt(mxc_formats, MXC_JPEG_NUM_FORMATS, f,
 			MXC_JPEG_FMT_TYPE_ENC);
-	else
+	} else if (!ctx->header_parsed) {
 		return enum_fmt(mxc_formats, MXC_JPEG_NUM_FORMATS, f,
 			MXC_JPEG_FMT_TYPE_RAW);
+	} else {
+		/* For the decoder CAPTURE queue, only enumerate the raw formats
+		 * supported for the format currently active on OUTPUT
+		 * (more precisely what was propagated on capture queue
+		 * after jpeg parse on the output buffer)
+		 */
+		if (f->index)
+			return -EINVAL;
+		f->pixelformat = q_data->fmt->fourcc;
+		strscpy(f->description, q_data->fmt->name, sizeof(f->description));
+		return 0;
+	}
 }
 
 static int mxc_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
 				     struct v4l2_fmtdesc *f)
 {
 	struct mxc_jpeg_ctx *ctx = mxc_jpeg_fh_to_ctx(priv);
+	u32 type = ctx->mxc_jpeg->mode == MXC_JPEG_DECODE ?  MXC_JPEG_FMT_TYPE_ENC :
+							     MXC_JPEG_FMT_TYPE_RAW;
+	int ret;
 
+	ret = enum_fmt(mxc_formats, MXC_JPEG_NUM_FORMATS, f, type);
+	if (ret)
+		return ret;
 	if (ctx->mxc_jpeg->mode == MXC_JPEG_DECODE)
-		return enum_fmt(mxc_formats, MXC_JPEG_NUM_FORMATS, f,
-				MXC_JPEG_FMT_TYPE_ENC);
-	else
-		return enum_fmt(mxc_formats, MXC_JPEG_NUM_FORMATS, f,
-				MXC_JPEG_FMT_TYPE_RAW);
+		f->flags = V4L2_FMT_FLAG_DYN_RESOLUTION;
+	return 0;
 }
 
 static int mxc_jpeg_try_fmt(struct v4l2_format *f, const struct mxc_jpeg_fmt *fmt,
@@ -1997,6 +2033,7 @@ static const struct v4l2_file_operations mxc_jpeg_fops = {
 };
 
 static const struct v4l2_m2m_ops mxc_jpeg_m2m_ops = {
+	.job_ready      = mxc_jpeg_job_ready,
 	.device_run	= mxc_jpeg_device_run,
 };
 
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index 2b4b30d01e51..6913ae087e44 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -95,6 +95,8 @@ struct mxc_jpeg_ctx {
 	unsigned int			stopping;
 	unsigned int			stopped;
 	unsigned int			slot;
+	unsigned int			source_change;
+	bool				header_parsed;
 };
 
 struct mxc_jpeg_slot_data {
-- 
2.35.1



