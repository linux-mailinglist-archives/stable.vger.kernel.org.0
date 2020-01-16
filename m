Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B6813FF80
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbgAPXnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388511AbgAPXZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:25:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 930B02072E;
        Thu, 16 Jan 2020 23:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217108;
        bh=iy/FhOwW8i7hvAPIZkBeCbhX0fNxYuc3TkzeIZDcIrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twTKR57NNkoev+iZEVwk8Tr166APDrorqBdrnVsiZ8Rd5KzRo2BTvodhbhNvVK7i7
         9rMx81mob2DeHYyqsOWqLa2SU6rWpH4w4XJ2tZr1vY44DO3x4V+8JOcMCMzmbQsTeA
         j3gB5cPk6Zffk2ergJOgf7RqQWbPtP96OZlzRvnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francois Buergisser <fbuergisser@google.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Francois Buergisser <fbuergisser@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.4 151/203] media: hantro: h264: Fix the frame_num wraparound case
Date:   Fri, 17 Jan 2020 00:17:48 +0100
Message-Id: <20200116231758.077259817@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Brezillon <boris.brezillon@collabora.com>

commit 9db5f87f6723678a7e7e5e3165439c5c4378edbb upstream.

Step '8.2.4.1 Decoding process for picture numbers' was missing in the
reflist creation logic, leading to invalid P reflists when a
->frame_num wraparound happens.

Fixes: a9471e25629b ("media: hantro: Add core bits to support H264 decoding")
Reported-by: Francois Buergisser <fbuergisser@google.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Francois Buergisser <fbuergisser@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/media/hantro/hantro_h264.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/staging/media/hantro/hantro_h264.c
+++ b/drivers/staging/media/hantro/hantro_h264.c
@@ -271,6 +271,7 @@ struct hantro_h264_reflist_builder {
 	const struct v4l2_h264_dpb_entry *dpb;
 	s32 pocs[HANTRO_H264_DPB_SIZE];
 	u8 unordered_reflist[HANTRO_H264_DPB_SIZE];
+	int frame_nums[HANTRO_H264_DPB_SIZE];
 	s32 curpoc;
 	u8 num_valid;
 };
@@ -294,13 +295,20 @@ static void
 init_reflist_builder(struct hantro_ctx *ctx,
 		     struct hantro_h264_reflist_builder *b)
 {
+	const struct v4l2_ctrl_h264_slice_params *slice_params;
 	const struct v4l2_ctrl_h264_decode_params *dec_param;
+	const struct v4l2_ctrl_h264_sps *sps;
 	struct vb2_v4l2_buffer *buf = hantro_get_dst_buf(ctx);
 	const struct v4l2_h264_dpb_entry *dpb = ctx->h264_dec.dpb;
 	struct vb2_queue *cap_q = &ctx->fh.m2m_ctx->cap_q_ctx.q;
+	int cur_frame_num, max_frame_num;
 	unsigned int i;
 
 	dec_param = ctx->h264_dec.ctrls.decode;
+	slice_params = &ctx->h264_dec.ctrls.slices[0];
+	sps = ctx->h264_dec.ctrls.sps;
+	max_frame_num = 1 << (sps->log2_max_frame_num_minus4 + 4);
+	cur_frame_num = slice_params->frame_num;
 
 	memset(b, 0, sizeof(*b));
 	b->dpb = dpb;
@@ -318,6 +326,18 @@ init_reflist_builder(struct hantro_ctx *
 			continue;
 
 		buf = to_vb2_v4l2_buffer(vb2_get_buffer(cap_q, buf_idx));
+
+		/*
+		 * Handle frame_num wraparound as described in section
+		 * '8.2.4.1 Decoding process for picture numbers' of the spec.
+		 * TODO: This logic will have to be adjusted when we start
+		 * supporting interlaced content.
+		 */
+		if (dpb[i].frame_num > cur_frame_num)
+			b->frame_nums[i] = (int)dpb[i].frame_num - max_frame_num;
+		else
+			b->frame_nums[i] = dpb[i].frame_num;
+
 		b->pocs[i] = get_poc(buf->field, dpb[i].top_field_order_cnt,
 				     dpb[i].bottom_field_order_cnt);
 		b->unordered_reflist[b->num_valid] = i;
@@ -353,7 +373,7 @@ static int p_ref_list_cmp(const void *pt
 	 * ascending order.
 	 */
 	if (!(a->flags & V4L2_H264_DPB_ENTRY_FLAG_LONG_TERM))
-		return b->frame_num - a->frame_num;
+		return builder->frame_nums[idxb] - builder->frame_nums[idxa];
 
 	return a->pic_num - b->pic_num;
 }


