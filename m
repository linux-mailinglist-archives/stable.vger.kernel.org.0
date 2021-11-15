Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B614512EF
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347584AbhKOTkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245205AbhKOTTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C780161041;
        Mon, 15 Nov 2021 18:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001016;
        bh=JqiDyWgxdTGY9yk21UUxFMl4N8SoqgNZtiLSIXLFRPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gPX7eFY8ZQ5nw1Ju+EIcyQ941sFzikTY50G5FPO2gqG5WP6fzuJisPI9o2staHeiQ
         YqEwP98GhDtYM8wDxYj/BStNlDu93JXLul/lXmqVHRv1epoy02TnNmUdu8zI5MDGLH
         tbKawfESDZUmAfqlcfL39wzw4a+l07ypH2reijX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 029/917] media: rkvdec: Support dynamic resolution changes
Date:   Mon, 15 Nov 2021 17:52:04 +0100
Message-Id: <20211115165429.748823236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 0887e9e152efbd3601d6c907e90033d25067277d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/rkvdec/rkvdec.c |   40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -280,31 +280,20 @@ static int rkvdec_try_output_fmt(struct
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
 
@@ -319,10 +308,21 @@ static int rkvdec_s_output_fmt(struct fi
 	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
 	const struct rkvdec_coded_fmt_desc *desc;
 	struct v4l2_format *cap_fmt;
-	struct vb2_queue *peer_vq;
+	struct vb2_queue *peer_vq, *vq;
 	int ret;
 
 	/*
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
+	/*
 	 * Since format change on the OUTPUT queue will reset the CAPTURE
 	 * queue, we can't allow doing so when the CAPTURE queue has buffers
 	 * allocated.
@@ -331,7 +331,7 @@ static int rkvdec_s_output_fmt(struct fi
 	if (vb2_is_busy(peer_vq))
 		return -EBUSY;
 
-	ret = rkvdec_s_fmt(file, priv, f, rkvdec_try_output_fmt);
+	ret = rkvdec_try_output_fmt(file, priv, f);
 	if (ret)
 		return ret;
 


