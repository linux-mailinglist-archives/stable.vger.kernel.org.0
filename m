Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4156541462
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358322AbiFGURh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359667AbiFGUP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CB91C9251;
        Tue,  7 Jun 2022 11:28:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6FB3612EC;
        Tue,  7 Jun 2022 18:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32EBC385A5;
        Tue,  7 Jun 2022 18:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626512;
        bh=rFUmO2eCpiuWmXjiSQBqGcHExDGAR+qKjNun3mFwazE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvEcfC68uDL1D+JePx6rCpmU3D05GwlFk2CJqKmRnW7xlhQv33TfICgf5JRn4hjd2
         toenAoUiMR5Nybhs4zjMBy/gRxxkriAzYls9iXSFDF7yBQoNqRUQCoro/FrtNy5t9F
         xB8TvZdkrNMCDbAn6GmOXR5ohhnuX1cDE4kXbjfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 405/772] media: rkvdec: h264: Fix dpb_valid implementation
Date:   Tue,  7 Jun 2022 18:59:57 +0200
Message-Id: <20220607165000.944176093@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

[ Upstream commit 7ab889f09dfa70e8097ec1b9186fd228124112cb ]

The ref builder only provided references that are marked as valid in the
dpb. Thus the current implementation of dpb_valid would always set the
flag to 1. This is not representing missing frames (this is called
'non-existing' pictures in the spec). In some context, these non-existing
pictures still need to occupy a slot in the reference list according to
the spec.

Fixes: cd33c830448ba ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec-h264.c | 33 ++++++++++++++++------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec-h264.c b/drivers/staging/media/rkvdec/rkvdec-h264.c
index 951e19231da2..f5d8c6cb740b 100644
--- a/drivers/staging/media/rkvdec/rkvdec-h264.c
+++ b/drivers/staging/media/rkvdec/rkvdec-h264.c
@@ -112,6 +112,7 @@ struct rkvdec_h264_run {
 	const struct v4l2_ctrl_h264_sps *sps;
 	const struct v4l2_ctrl_h264_pps *pps;
 	const struct v4l2_ctrl_h264_scaling_matrix *scaling_matrix;
+	int ref_buf_idx[V4L2_H264_NUM_DPB_ENTRIES];
 };
 
 struct rkvdec_h264_ctx {
@@ -725,6 +726,26 @@ static void assemble_hw_pps(struct rkvdec_ctx *ctx,
 	}
 }
 
+static void lookup_ref_buf_idx(struct rkvdec_ctx *ctx,
+			       struct rkvdec_h264_run *run)
+{
+	const struct v4l2_ctrl_h264_decode_params *dec_params = run->decode_params;
+	u32 i;
+
+	for (i = 0; i < ARRAY_SIZE(dec_params->dpb); i++) {
+		struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
+		const struct v4l2_h264_dpb_entry *dpb = run->decode_params->dpb;
+		struct vb2_queue *cap_q = &m2m_ctx->cap_q_ctx.q;
+		int buf_idx = -1;
+
+		if (dpb[i].flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE)
+			buf_idx = vb2_find_timestamp(cap_q,
+						     dpb[i].reference_ts, 0);
+
+		run->ref_buf_idx[i] = buf_idx;
+	}
+}
+
 static void assemble_hw_rps(struct rkvdec_ctx *ctx,
 			    struct rkvdec_h264_run *run)
 {
@@ -762,7 +783,7 @@ static void assemble_hw_rps(struct rkvdec_ctx *ctx,
 
 	for (j = 0; j < RKVDEC_NUM_REFLIST; j++) {
 		for (i = 0; i < h264_ctx->reflists.num_valid; i++) {
-			u8 dpb_valid = 0;
+			bool dpb_valid = run->ref_buf_idx[i] >= 0;
 			u8 idx = 0;
 
 			switch (j) {
@@ -779,8 +800,6 @@ static void assemble_hw_rps(struct rkvdec_ctx *ctx,
 
 			if (idx >= ARRAY_SIZE(dec_params->dpb))
 				continue;
-			dpb_valid = !!(dpb[idx].flags &
-				       V4L2_H264_DPB_ENTRY_FLAG_ACTIVE);
 
 			set_ps_field(hw_rps, DPB_INFO(i, j),
 				     idx | dpb_valid << 4);
@@ -859,13 +878,8 @@ get_ref_buf(struct rkvdec_ctx *ctx, struct rkvdec_h264_run *run,
 	    unsigned int dpb_idx)
 {
 	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
-	const struct v4l2_h264_dpb_entry *dpb = run->decode_params->dpb;
 	struct vb2_queue *cap_q = &m2m_ctx->cap_q_ctx.q;
-	int buf_idx = -1;
-
-	if (dpb[dpb_idx].flags & V4L2_H264_DPB_ENTRY_FLAG_ACTIVE)
-		buf_idx = vb2_find_timestamp(cap_q,
-					     dpb[dpb_idx].reference_ts, 0);
+	int buf_idx = run->ref_buf_idx[dpb_idx];
 
 	/*
 	 * If a DPB entry is unused or invalid, address of current destination
@@ -1102,6 +1116,7 @@ static int rkvdec_h264_run(struct rkvdec_ctx *ctx)
 
 	assemble_hw_scaling_list(ctx, &run);
 	assemble_hw_pps(ctx, &run);
+	lookup_ref_buf_idx(ctx, &run);
 	assemble_hw_rps(ctx, &run);
 	config_registers(ctx, &run);
 
-- 
2.35.1



