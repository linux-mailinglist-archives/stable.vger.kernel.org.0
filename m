Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A998A2F4E6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfE3DMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbfE3DMH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:07 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F60C2452D;
        Thu, 30 May 2019 03:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185926;
        bh=b2FfiIFLax+t5DBMjGWUhK/t6nTUndNyCzFPq8pAh8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPDCBH0t5twEe4nZA0KPryhE/FKZOJifOpG1Z4npBhLjurXJGGDllcck/nUnljZ82
         Tw7fW53KIiHrLPF6mFu833Z9jUcSxIFwrBIyKU+ditsxl2jplvirImaebLEbA4gGTO
         fuS1COsIizC2G0+9S4/2ZqwJ9MXxvYeVeOC1sOAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 317/405] media: vicodec: bugfix - call v4l2_m2m_buf_copy_metadata also if decoding fails
Date:   Wed, 29 May 2019 20:05:15 -0700
Message-Id: <20190530030556.815667530@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 8eead25cbdf911e17cff321903bd3397bc6ea22c ]

The function 'v4l2_m2m_buf_copy_metadata' should
be called even if decoding/encoding ends with
status VB2_BUF_STATE_ERROR, so that the metadata
is copied from the source buffer to the dest buffer.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index d7636fe9e1749..6b618452700c4 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -159,12 +159,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *dst_vb)
 {
 	struct vicodec_dev *dev = ctx->dev;
-	struct vicodec_q_data *q_dst;
 	struct v4l2_fwht_state *state = &ctx->state;
 	u8 *p_src, *p_dst;
 	int ret;
 
-	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ctx->is_enc)
 		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
 	else
@@ -186,8 +184,10 @@ static int device_process(struct vicodec_ctx *ctx,
 			return ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
 	} else {
+		struct vicodec_q_data *q_dst;
 		unsigned int comp_frame_size = ntohl(ctx->state.header.size);
 
+		q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		if (comp_frame_size > ctx->comp_max_size)
 			return -EINVAL;
 		state->info = q_dst->info;
@@ -196,11 +196,6 @@ static int device_process(struct vicodec_ctx *ctx,
 			return ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
-
-	dst_vb->sequence = q_dst->sequence++;
-	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	v4l2_m2m_buf_copy_metadata(src_vb, dst_vb, !ctx->is_enc);
-
 	return 0;
 }
 
@@ -274,16 +269,22 @@ static void device_run(void *priv)
 	struct vicodec_ctx *ctx = priv;
 	struct vicodec_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
-	struct vicodec_q_data *q_src;
+	struct vicodec_q_data *q_src, *q_dst;
 	u32 state;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
 	state = VB2_BUF_STATE_DONE;
 	if (device_process(ctx, src_buf, dst_buf))
 		state = VB2_BUF_STATE_ERROR;
+	else
+		dst_buf->sequence = q_dst->sequence++;
+	dst_buf->flags &= ~V4L2_BUF_FLAG_LAST;
+	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, !ctx->is_enc);
+
 	ctx->last_dst_buf = dst_buf;
 
 	spin_lock(ctx->lock);
-- 
2.20.1



