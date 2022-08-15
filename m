Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B591B59396B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243328AbiHOSo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243330AbiHOSnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03362B63C;
        Mon, 15 Aug 2022 11:27:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98AC6B8107B;
        Mon, 15 Aug 2022 18:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF56C433C1;
        Mon, 15 Aug 2022 18:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588025;
        bh=s6hE0dcnfjRm35xl0ubYTMLoz5IO6Zpumb/khgzk3bk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1l+n3fBRBxgolpTG5vljKLLskcNfcvuDAW1AEzkGrJbtJ0waFbWS/Z021OJ2VWsZV
         GVmkEMQ3M7onp45OsDkkfLlJKNSTdET6oxzjgHIuNPMptTUGuiw82II5eMryB0cJr3
         cbJHXMQqnukqIF7x9HVJi4o96b2qvTZWB3A8p3cs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Mirela Rabulea <mirela.rabulea@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/779] media: imx-jpeg: Set V4L2_BUF_FLAG_LAST at eos
Date:   Mon, 15 Aug 2022 19:58:36 +0200
Message-Id: <20220815180348.943426094@linuxfoundation.org>
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

[ Upstream commit d8ebe298d008ccbae3011cbeb139707f01a730c8 ]

The V4L2_EVENT_EOS event is a deprecated behavior,
the V4L2_BUF_FLAG_LAST buffer flag should be used instead.

Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Mirela Rabulea <mirela.rabulea@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imx-jpeg/mxc-jpeg.c | 41 ++++++++++++++++++++--
 drivers/media/platform/imx-jpeg/mxc-jpeg.h |  1 +
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 1ec60f54d5a1..2d0c1307180f 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -988,6 +988,20 @@ static void mxc_jpeg_device_run(void *priv)
 	spin_unlock_irqrestore(&ctx->mxc_jpeg->hw_lock, flags);
 }
 
+static void mxc_jpeg_set_last_buffer_dequeued(struct mxc_jpeg_ctx *ctx)
+{
+	struct vb2_queue *q;
+
+	ctx->stopped = 1;
+	q = v4l2_m2m_get_dst_vq(ctx->fh.m2m_ctx);
+	if (!list_empty(&q->done_list))
+		return;
+
+	q->last_buffer_dequeued = true;
+	wake_up(&q->done_wq);
+	ctx->stopped = 0;
+}
+
 static int mxc_jpeg_decoder_cmd(struct file *file, void *priv,
 				struct v4l2_decoder_cmd *cmd)
 {
@@ -1005,6 +1019,7 @@ static int mxc_jpeg_decoder_cmd(struct file *file, void *priv,
 		if (v4l2_m2m_num_src_bufs_ready(fh->m2m_ctx) == 0) {
 			/* No more src bufs, notify app EOS */
 			notify_eos(ctx);
+			mxc_jpeg_set_last_buffer_dequeued(ctx);
 		} else {
 			/* will send EOS later*/
 			ctx->stopping = 1;
@@ -1031,6 +1046,7 @@ static int mxc_jpeg_encoder_cmd(struct file *file, void *priv,
 		if (v4l2_m2m_num_src_bufs_ready(fh->m2m_ctx) == 0) {
 			/* No more src bufs, notify app EOS */
 			notify_eos(ctx);
+			mxc_jpeg_set_last_buffer_dequeued(ctx);
 		} else {
 			/* will send EOS later*/
 			ctx->stopping = 1;
@@ -1107,6 +1123,10 @@ static void mxc_jpeg_stop_streaming(struct vb2_queue *q)
 		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
 	}
 	pm_runtime_put_sync(&ctx->mxc_jpeg->pdev->dev);
+	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
+		ctx->stopping = 0;
+		ctx->stopped = 0;
+	}
 }
 
 static int mxc_jpeg_valid_comp_id(struct device *dev,
@@ -1398,12 +1418,29 @@ static int mxc_jpeg_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
+static void mxc_jpeg_buf_finish(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct mxc_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_queue *q = vb->vb2_queue;
+
+	if (V4L2_TYPE_IS_OUTPUT(vb->type))
+		return;
+	if (!ctx->stopped)
+		return;
+	if (list_empty(&q->done_list)) {
+		vbuf->flags |= V4L2_BUF_FLAG_LAST;
+		ctx->stopped = 0;
+	}
+}
+
 static const struct vb2_ops mxc_jpeg_qops = {
 	.queue_setup		= mxc_jpeg_queue_setup,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
 	.buf_out_validate	= mxc_jpeg_buf_out_validate,
 	.buf_prepare		= mxc_jpeg_buf_prepare,
+	.buf_finish             = mxc_jpeg_buf_finish,
 	.start_streaming	= mxc_jpeg_start_streaming,
 	.stop_streaming		= mxc_jpeg_stop_streaming,
 	.buf_queue		= mxc_jpeg_buf_queue,
@@ -1839,14 +1876,14 @@ static int mxc_jpeg_dqbuf(struct file *file, void *priv,
 	int ret;
 
 	dev_dbg(dev, "DQBUF type=%d, index=%d", buf->type, buf->index);
-	if (ctx->stopping == 1	&& num_src_ready == 0) {
+	if (ctx->stopping == 1 && num_src_ready == 0) {
 		/* No more src bufs, notify app EOS */
 		notify_eos(ctx);
 		ctx->stopping = 0;
+		mxc_jpeg_set_last_buffer_dequeued(ctx);
 	}
 
 	ret = v4l2_m2m_dqbuf(file, fh->m2m_ctx, buf);
-
 	return ret;
 }
 
diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
index 9fb2a5aaa941..f53f004ba851 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
@@ -91,6 +91,7 @@ struct mxc_jpeg_ctx {
 	struct v4l2_fh			fh;
 	enum mxc_jpeg_enc_state		enc_state;
 	unsigned int			stopping;
+	unsigned int			stopped;
 	unsigned int			slot;
 };
 
-- 
2.35.1



