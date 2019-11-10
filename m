Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9F8F6A8A
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 18:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfKJRTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 12:19:40 -0500
Received: from www.linuxtv.org ([130.149.80.248]:36658 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfKJRTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 12:19:40 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTqsE-0001ny-A2; Sun, 10 Nov 2019 17:19:38 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sun, 10 Nov 2019 16:48:56 +0000
Subject: [git:media_tree/master] media: hantro: Fix s_fmt for dynamic resolution changes
To:     linuxtv-commits@linuxtv.org
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTqsE-0001ny-A2@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: hantro: Fix s_fmt for dynamic resolution changes
Author:  Ezequiel Garcia <ezequiel@collabora.com>
Date:    Mon Oct 7 19:45:02 2019 +0200

Commit 953aaa1492c53 ("media: rockchip/vpu: Prepare things to support decoders")
changed the conditions under S_FMT was allowed for OUTPUT
CAPTURE buffers.

However, and according to the mem-to-mem stateless decoder specification,
in order to support dynamic resolution changes, S_FMT should be allowed
even if OUTPUT buffers have been allocated.

Relax decoder S_FMT restrictions on OUTPUT buffers, allowing a
resolution modification, provided the pixel format stays the same.

Tested on RK3288 platforms using ChromiumOS Video Decode/Encode
Accelerator Unittests.

[hverkuil: fix typo: In other -> In order]

Fixes: 953aaa1492c53 ("media: rockchip/vpu: Prepare things to support decoders")
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Cc: <stable@vger.kernel.org>      # for v5.4 and up
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/staging/media/hantro/hantro_v4l2.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

---

diff --git a/drivers/staging/media/hantro/hantro_v4l2.c b/drivers/staging/media/hantro/hantro_v4l2.c
index 3dae52abb96c..fcf95c1d39ca 100644
--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -367,20 +367,27 @@ vidioc_s_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
 	struct hantro_ctx *ctx = fh_to_ctx(priv);
+	struct vb2_queue *vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
 	const struct hantro_fmt *formats;
 	unsigned int num_fmts;
-	struct vb2_queue *vq;
 	int ret;
 
-	/* Change not allowed if queue is busy. */
-	vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, f->type);
-	if (vb2_is_busy(vq))
-		return -EBUSY;
+	ret = vidioc_try_fmt_out_mplane(file, priv, f);
+	if (ret)
+		return ret;
 
 	if (!hantro_is_encoder_ctx(ctx)) {
 		struct vb2_queue *peer_vq;
 
 		/*
+		 * In order to support dynamic resolution change,
+		 * the decoder admits a resolution change, as long
+		 * as the pixelformat remains. Can't be done if streaming.
+		 */
+		if (vb2_is_streaming(vq) || (vb2_is_busy(vq) &&
+		    pix_mp->pixelformat != ctx->src_fmt.pixelformat))
+			return -EBUSY;
+		/*
 		 * Since format change on the OUTPUT queue will reset
 		 * the CAPTURE queue, we can't allow doing so
 		 * when the CAPTURE queue has buffers allocated.
@@ -389,12 +396,15 @@ vidioc_s_fmt_out_mplane(struct file *file, void *priv, struct v4l2_format *f)
 					  V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
 		if (vb2_is_busy(peer_vq))
 			return -EBUSY;
+	} else {
+		/*
+		 * The encoder doesn't admit a format change if
+		 * there are OUTPUT buffers allocated.
+		 */
+		if (vb2_is_busy(vq))
+			return -EBUSY;
 	}
 
-	ret = vidioc_try_fmt_out_mplane(file, priv, f);
-	if (ret)
-		return ret;
-
 	formats = hantro_get_formats(ctx, &num_fmts);
 	ctx->vpu_src_fmt = hantro_find_format(formats, num_fmts,
 					      pix_mp->pixelformat);
