Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF2F593FE4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiHOU7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244227AbiHOU7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:59:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A7CC2282;
        Mon, 15 Aug 2022 12:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49B49B81106;
        Mon, 15 Aug 2022 19:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D45CC433C1;
        Mon, 15 Aug 2022 19:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590755;
        bh=70UNMZmwj9/cpoYO9G9gm5YNrbNmoVNq33d2vYMZeWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8hw/74/lPPIdTfs9u0+9+plEfrjfWwohllYDgo2hKWH2Wno1IVO6na0eWrADynF7
         qri1LQcDDlnYb5Pyp4LXm0EBKhE2F5exrHYTAPA+tImjxqBqbBYNpRWq9UNgI3TBmZ
         jAfhmQbMJV3j7pVv1BulTySudpGJ+5sfSz5iNr4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0359/1095] media: imx-jpeg: Implement drain using v4l2-mem2mem helpers
Date:   Mon, 15 Aug 2022 19:55:58 +0200
Message-Id: <20220815180444.586169641@linuxfoundation.org>
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

[ Upstream commit 4911c5acf9351c4caf692895c7cf6a4fa46c26b0 ]

v4l2 m2m has supplied some helper function to handle drain,
so the driver can use the helper function directly.

Fixes: d8ebe298d008c ("media: imx-jpeg: Set V4L2_BUF_FLAG_LAST at eos")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 155 +++++++++---------
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |   2 -
 2 files changed, 73 insertions(+), 84 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 04617bf40c51..8c0bd8b75b00 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -559,6 +559,18 @@ static void mxc_jpeg_free_slot_data(struct mxc_jpeg_dev *jpeg,
 	jpeg->slot_data[slot].used = false;
 }
 
+static void mxc_jpeg_check_and_set_last_buffer(struct mxc_jpeg_ctx *ctx,
+					       struct vb2_v4l2_buffer *src_buf,
+					       struct vb2_v4l2_buffer *dst_buf)
+{
+	if (v4l2_m2m_is_last_draining_src_buf(ctx->fh.m2m_ctx, src_buf)) {
+		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
+		v4l2_m2m_mark_stopped(ctx->fh.m2m_ctx);
+		notify_eos(ctx);
+		ctx->header_parsed = false;
+	}
+}
+
 static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 {
 	struct mxc_jpeg_dev *jpeg = priv;
@@ -633,6 +645,7 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 		dev_dbg(dev, "Decoder DHT cfg finished. Start decoding...\n");
 		goto job_unlock;
 	}
+
 	if (jpeg->mode == MXC_JPEG_ENCODE) {
 		payload = readl(reg + MXC_SLOT_OFFSET(slot, SLOT_BUF_PTR));
 		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, payload);
@@ -661,6 +674,7 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 
 buffers_done:
 	jpeg->slot_data[slot].used = false; /* unused, but don't free */
+	mxc_jpeg_check_and_set_last_buffer(ctx, src_buf, dst_buf);
 	v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	v4l2_m2m_buf_done(src_buf, buf_state);
@@ -1034,6 +1048,7 @@ static void mxc_jpeg_device_run(void *priv)
 		jpeg_src_buf->jpeg_parse_error = true;
 	}
 	if (jpeg_src_buf->jpeg_parse_error) {
+		mxc_jpeg_check_and_set_last_buffer(ctx, src_buf, dst_buf);
 		v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
@@ -1084,45 +1099,33 @@ static void mxc_jpeg_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
 }
 
-static void mxc_jpeg_set_last_buffer_dequeued(struct mxc_jpeg_ctx *ctx)
-{
-	struct vb2_queue *q;
-
-	ctx->stopped = 1;
-	q = v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx);
-	if (!list_empty(&q->done_list))
-		return;
-
-	q->last_buffer_dequeued = true;
-	wake_up(&q->done_wq);
-	ctx->stopped = 0;
-	ctx->header_parsed = false;
-}
-
 static int mxc_jpeg_decoder_cmd(struct file *file, void *priv,
 				struct v4l2_decoder_cmd *cmd)
 {
 	struct v4l2_fh *fh = file->private_data;
 	struct mxc_jpeg_ctx *ctx = mxc_jpeg_fh_to_ctx(fh);
-	struct device *dev = ctx->mxc_jpeg->dev;
 	int ret;
 
 	ret = v4l2_m2m_ioctl_try_decoder_cmd(file, fh, cmd);
 	if (ret < 0)
 		return ret;
 
-	if (cmd->cmd == V4L2_DEC_CMD_STOP) {
-		dev_dbg(dev, "Received V4L2_DEC_CMD_STOP");
-		if (v4l2_m2m_num_src_bufs_ready(fh->m2m_ctx) == 0) {
-			/* No more src bufs, notify app EOS */
-			notify_eos(ctx);
-			mxc_jpeg_set_last_buffer_dequeued(ctx);
-		} else {
-			/* will send EOS later*/
-			ctx->stopping = 1;
-		}
+	if (!vb2_is_streaming(v4l2_m2m_get_src_vq(fh->m2m_ctx)))
+		return 0;
+
+	ret = v4l2_m2m_ioctl_decoder_cmd(file, priv, cmd);
+	if (ret < 0)
+		return ret;
+
+	if (cmd->cmd == V4L2_DEC_CMD_STOP &&
+	    v4l2_m2m_has_stopped(fh->m2m_ctx)) {
+		notify_eos(ctx);
+		ctx->header_parsed = false;
 	}
 
+	if (cmd->cmd == V4L2_DEC_CMD_START &&
+	    v4l2_m2m_has_stopped(fh->m2m_ctx))
+		vb2_clear_last_buffer_dequeued(&fh->m2m_ctx->cap_q_ctx.q);
 	return 0;
 }
 
@@ -1131,24 +1134,27 @@ static int mxc_jpeg_encoder_cmd(struct file *file, void *priv,
 {
 	struct v4l2_fh *fh = file->private_data;
 	struct mxc_jpeg_ctx *ctx = mxc_jpeg_fh_to_ctx(fh);
-	struct device *dev = ctx->mxc_jpeg->dev;
 	int ret;
 
 	ret = v4l2_m2m_ioctl_try_encoder_cmd(file, fh, cmd);
 	if (ret < 0)
 		return ret;
 
-	if (cmd->cmd == V4L2_ENC_CMD_STOP) {
-		dev_dbg(dev, "Received V4L2_ENC_CMD_STOP");
-		if (v4l2_m2m_num_src_bufs_ready(fh->m2m_ctx) == 0) {
-			/* No more src bufs, notify app EOS */
-			notify_eos(ctx);
-			mxc_jpeg_set_last_buffer_dequeued(ctx);
-		} else {
-			/* will send EOS later*/
-			ctx->stopping = 1;
-		}
-	}
+	if (!vb2_is_streaming(v4l2_m2m_get_src_vq(fh->m2m_ctx)) ||
+	    !vb2_is_streaming(v4l2_m2m_get_dst_vq(fh->m2m_ctx)))
+		return 0;
+
+	ret = v4l2_m2m_ioctl_encoder_cmd(file, fh, cmd);
+	if (ret < 0)
+		return 0;
+
+	if (cmd->cmd == V4L2_ENC_CMD_STOP &&
+	    v4l2_m2m_has_stopped(fh->m2m_ctx))
+		notify_eos(ctx);
+
+	if (cmd->cmd == V4L2_ENC_CMD_START &&
+	    v4l2_m2m_has_stopped(fh->m2m_ctx))
+		vb2_clear_last_buffer_dequeued(&fh->m2m_ctx->cap_q_ctx.q);
 
 	return 0;
 }
@@ -1202,6 +1208,8 @@ static int mxc_jpeg_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct mxc_jpeg_q_data *q_data = mxc_jpeg_get_q_data(ctx, q->type);
 	int ret;
 
+	v4l2_m2m_update_start_streaming_state(ctx->fh.m2m_ctx, q);
+
 	if (ctx->mxc_jpeg->mode == MXC_JPEG_DECODE && V4L2_TYPE_IS_CAPTURE(q->type))
 		ctx->source_change = 0;
 	dev_dbg(ctx->mxc_jpeg->dev, "Start streaming ctx=%p", ctx);
@@ -1233,11 +1241,15 @@ static void mxc_jpeg_stop_streaming(struct vb2_queue *q)
 			break;
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 	}
-	pm_runtime_put_sync(&ctx->mxc_jpeg->pdev->dev);
-	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
-		ctx->stopping = 0;
-		ctx->stopped = 0;
+
+	v4l2_m2m_update_stop_streaming_state(ctx->fh.m2m_ctx, q);
+	if (V4L2_TYPE_IS_OUTPUT(q->type) &&
+	    v4l2_m2m_has_stopped(ctx->fh.m2m_ctx)) {
+		notify_eos(ctx);
+		ctx->header_parsed = false;
 	}
+
+	pm_runtime_put_sync(&ctx->mxc_jpeg->pdev->dev);
 }
 
 static int mxc_jpeg_valid_comp_id(struct device *dev,
@@ -1436,6 +1448,20 @@ static void mxc_jpeg_buf_queue(struct vb2_buffer *vb)
 	struct mxc_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct mxc_jpeg_src_buf *jpeg_src_buf;
 
+	if (V4L2_TYPE_IS_CAPTURE(vb->vb2_queue->type) &&
+	    vb2_is_streaming(vb->vb2_queue) &&
+	    v4l2_m2m_dst_buf_is_last(ctx->fh.m2m_ctx)) {
+		struct mxc_jpeg_q_data *q_data;
+
+		q_data = mxc_jpeg_get_q_data(ctx, vb->vb2_queue->type);
+		vbuf->field = V4L2_FIELD_NONE;
+		vbuf->sequence = q_data->sequence++;
+		v4l2_m2m_last_buffer_done(ctx->fh.m2m_ctx, vbuf);
+		notify_eos(ctx);
+		ctx->header_parsed = false;
+		return;
+	}
+
 	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
 		goto end;
 
@@ -1485,24 +1511,11 @@ static int mxc_jpeg_buf_prepare(struct vb2_buffer *vb)
 		}
 		vb2_set_plane_payload(vb, i, sizeimage);
 	}
-	return 0;
-}
-
-static void mxc_jpeg_buf_finish(struct vb2_buffer *vb)
-{
-	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
-	struct mxc_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
-	struct vb2_queue *q = vb->vb2_queue;
-
-	if (V4L2_TYPE_IS_OUTPUT(vb->type))
-		return;
-	if (!ctx->stopped)
-		return;
-	if (list_empty(&q->done_list)) {
-		vbuf->flags |= V4L2_BUF_FLAG_LAST;
-		ctx->stopped = 0;
-		ctx->header_parsed = false;
+	if (V4L2_TYPE_IS_CAPTURE(vb->vb2_queue->type)) {
+		vb2_set_plane_payload(vb, 0, 0);
+		vb2_set_plane_payload(vb, 1, 0);
 	}
+	return 0;
 }
 
 static const struct vb2_ops mxc_jpeg_qops = {
@@ -1511,7 +1524,6 @@ static const struct vb2_ops mxc_jpeg_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 	.buf_out_validate	= mxc_jpeg_buf_out_validate,
 	.buf_prepare		= mxc_jpeg_buf_prepare,
-	.buf_finish             = mxc_jpeg_buf_finish,
 	.start_streaming	= mxc_jpeg_start_streaming,
 	.stop_streaming		= mxc_jpeg_stop_streaming,
 	.buf_queue		= mxc_jpeg_buf_queue,
@@ -1932,27 +1944,6 @@ static int mxc_jpeg_subscribe_event(struct v4l2_fh *fh,
 	}
 }
 
-static int mxc_jpeg_dqbuf(struct file *file, void *priv,
-			  struct v4l2_buffer *buf)
-{
-	struct v4l2_fh *fh = file->private_data;
-	struct mxc_jpeg_ctx *ctx = mxc_jpeg_fh_to_ctx(priv);
-	struct device *dev = ctx->mxc_jpeg->dev;
-	int num_src_ready = v4l2_m2m_num_src_bufs_ready(fh->m2m_ctx);
-	int ret;
-
-	dev_dbg(dev, "DQBUF type=%d, index=%d", buf->type, buf->index);
-	if (ctx->stopping == 1 && num_src_ready == 0) {
-		/* No more src bufs, notify app EOS */
-		notify_eos(ctx);
-		ctx->stopping = 0;
-		mxc_jpeg_set_last_buffer_dequeued(ctx);
-	}
-
-	ret = v4l2_m2m_dqbuf(file, fh->m2m_ctx, buf);
-	return ret;
-}
-
 static const struct v4l2_ioctl_ops mxc_jpeg_ioctl_ops = {
 	.vidioc_querycap		= mxc_jpeg_querycap,
 	.vidioc_enum_fmt_vid_cap	= mxc_jpeg_enum_fmt_vid_cap,
@@ -1976,7 +1967,7 @@ static const struct v4l2_ioctl_ops mxc_jpeg_ioctl_ops = {
 	.vidioc_encoder_cmd		= mxc_jpeg_encoder_cmd,
 
 	.vidioc_qbuf			= v4l2_m2m_ioctl_qbuf,
-	.vidioc_dqbuf			= mxc_jpeg_dqbuf,
+	.vidioc_dqbuf			= v4l2_m2m_ioctl_dqbuf,
 
 	.vidioc_create_bufs		= v4l2_m2m_ioctl_create_bufs,
 	.vidioc_prepare_buf		= v4l2_m2m_ioctl_prepare_buf,
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index 6913ae087e44..542993eb8d5b 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -92,8 +92,6 @@ struct mxc_jpeg_ctx {
 	struct mxc_jpeg_q_data		cap_q;
 	struct v4l2_fh			fh;
 	enum mxc_jpeg_enc_state		enc_state;
-	unsigned int			stopping;
-	unsigned int			stopped;
 	unsigned int			slot;
 	unsigned int			source_change;
 	bool				header_parsed;
-- 
2.35.1



