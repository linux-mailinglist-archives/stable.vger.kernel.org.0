Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3D0432EFC
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 09:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhJSHLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 03:11:19 -0400
Received: from www.linuxtv.org ([130.149.80.248]:59504 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhJSHLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Oct 2021 03:11:18 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mcjFA-008jHV-5Y; Tue, 19 Oct 2021 07:09:04 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 19 Oct 2021 07:08:39 +0000
Subject: [git:media_stage/master] media: rkvdec: Support dynamic resolution changes
To:     linuxtv-commits@linuxtv.org
Cc:     Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mcjFA-008jHV-5Y@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rkvdec: Support dynamic resolution changes
Author:  Chen-Yu Tsai <wenst@chromium.org>
Date:    Fri Oct 8 11:04:23 2021 +0100

The mem-to-mem stateless decoder API specifies support for dynamic
resolution changes. In particular, the decoder should accept format
changes on the OUTPUT queue even when buffers have been allocated,
as long as it is not streaming.

Relax restrictions for S_FMT as described in the previous paragraph,
and as long as the codec format remains the same. This aligns it with
the Hantro and Cedrus decoders. This change was mostly based on commit
ae02d49493b5 ("media: hantro: Fix s_fmt for dynamic resolution changes").

Since rkvdec_s_fmt() is now just a wrapper around the output/capture
variants without any additional shared functionality, drop the wrapper
and call the respective functions directly.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/rkvdec/rkvdec.c | 40 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

---

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index bf00fe6534a3..4fd4a2907da7 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -280,31 +280,20 @@ static int rkvdec_try_output_fmt(struct file *file, void *priv,
 	return 0;
 }
 
-static int rkvdec_s_fmt(struct file *file, void *priv,
-			struct v4l2_format *f,
-			int (*try_fmt)(struct file *, void *,
-				       struct v4l2_format *))
+static int rkvdec_s_capture_fmt(struct file *file, void *priv,
+				struct v4l2_format *f)
 {
 	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
 	struct vb2_queue *vq;
+	int ret;
 
-	if (!try_fmt)
-		return -EINVAL;
-
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
+	/* Change not allowed if queue is busy */
+	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+			     V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 	if (vb2_is_busy(vq))
 		return -EBUSY;
 
-	return try_fmt(file, priv, f);
-}
-
-static int rkvdec_s_capture_fmt(struct file *file, void *priv,
-				struct v4l2_format *f)
-{
-	struct rkvdec_ctx *ctx = fh_to_rkvdec_ctx(priv);
-	int ret;
-
-	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_capture_fmt);
+	ret = rkvdec_try_capture_fmt(file, priv, f);
 	if (ret)
 		return ret;
 
@@ -319,9 +308,20 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
 	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
 	const struct rkvdec_coded_fmt_desc *desc;
 	struct v4l2_format *cap_fmt;
-	struct vb2_queue *peer_vq;
+	struct vb2_queue *peer_vq, *vq;
 	int ret;
 
+	/*
+	 * In order to support dynamic resolution change, the decoder admits
+	 * a resolution change, as long as the pixelformat remains. Can't be
+	 * done if streaming.
+	 */
+	vq = v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
+	if (vb2_is_streaming(vq) ||
+	    (vb2_is_busy(vq) &&
+	     f->fmt.pix_mp.pixelformat != ctx->coded_fmt.fmt.pix_mp.pixelformat))
+		return -EBUSY;
+
 	/*
 	 * Since format change on the OUTPUT queue will reset the CAPTURE
 	 * queue, we can't allow doing so when the CAPTURE queue has buffers
@@ -331,7 +331,7 @@ static int rkvdec_s_output_fmt(struct file *file, void *priv,
 	if (vb2_is_busy(peer_vq))
 		return -EBUSY;
 
-	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_output_fmt);
+	ret = rkvdec_try_output_fmt(file, priv, f);
 	if (ret)
 		return ret;
 
