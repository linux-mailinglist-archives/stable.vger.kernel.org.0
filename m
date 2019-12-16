Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD31216D5
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfLPSK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbfLPSK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:10:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F6B21582;
        Mon, 16 Dec 2019 18:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519825;
        bh=NeQzpFfclPtsz87k4W3jeo/1VKJIkBRQNsBK1c9e4cU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKjNIeDvP0vb3i/ZeDfn7/MvQFaa7R0hf32tL1IBw+2oWIk2cGUe/yb2MPjD2dHSe
         LMpFrvZyj7x2v54qBjvqJsVPTMuXG+L5aMsb1mmh4pOjb2vAeuw13clDGrMWF2G1Sk
         +556mh1+RmlRAtRRVgIqzvuYTSERsnMFfVt8gOmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.3 085/180] media: hantro: Fix s_fmt for dynamic resolution changes
Date:   Mon, 16 Dec 2019 18:48:45 +0100
Message-Id: <20191216174832.318953840@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

commit ae02d49493b5d32bb3e035fdeb1655346f5e1ea5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_v4l2.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/staging/media/hantro/hantro_v4l2.c
+++ b/drivers/staging/media/hantro/hantro_v4l2.c
@@ -356,20 +356,27 @@ vidioc_s_fmt_out_mplane(struct file *fil
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
@@ -378,12 +385,15 @@ vidioc_s_fmt_out_mplane(struct file *fil
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


