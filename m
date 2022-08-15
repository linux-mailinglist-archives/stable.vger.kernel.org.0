Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A098F594747
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354291AbiHOXrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354667AbiHOXqJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0CF399DD;
        Mon, 15 Aug 2022 13:14:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3279B60F60;
        Mon, 15 Aug 2022 20:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23545C43142;
        Mon, 15 Aug 2022 20:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594475;
        bh=99SkzNp1RE2bYCkTf34S9/NejKtflzhF9K4wThqABYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fG+g53JhVD6oeICSGKM2+qQ0gzvyUReC5Hg0vlZlmxfWoXwLpTgoV+ZdqUMNCMHuG
         w1lFVWQcvBJrutJiOILJEErR/yUFDQaUBGqZmOvuww814eeA5QyeAj9bWtZlvzwaUc
         iOxL42XdrBwfixOxgD+n+vlq/+TLvRnAwyE/b3gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0459/1157] media: mediatek: vcodec: decoder: Fix resolution clamping in TRY_FMT
Date:   Mon, 15 Aug 2022 19:56:55 +0200
Message-Id: <20220815180457.965588337@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit d7abd054201377aa441411ca081bd903fba82ce0 ]

In commit b018be06f3c7 ("media: mediatek: vcodec: Read max resolution
from dec_capability"), TRY_FMT clamps the resolution to the maximum
that was previously set either by default 1080p or the limit set by a
previous S_FMT call. This does not make sense when doing TRY_FMT for
the output side, which may have different capabilities.

Instead, for the output side, find the maximum resolution based on the
pixel format requested. For the capture side, find the maximum
resolution based on the currently set output format.

The maximum resolution is found from the list of per-format frame
sizes, so the patch "media: mediatek: vcodec: dec: Fix 4K frame size
enumeration" is needed.

Fixes: b018be06f3c7 ("media: mediatek: vcodec: Read max resolution from dec_capability")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/mediatek/vcodec/mtk_vcodec_dec.c | 48 ++++++++++++++-----
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
index 393b127138f3..42b29f0a7436 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_dec.c
@@ -211,17 +211,44 @@ static int vidioc_vdec_subscribe_evt(struct v4l2_fh *fh,
 	}
 }
 
+static const struct v4l2_frmsize_stepwise *mtk_vdec_get_frmsize(struct mtk_vcodec_ctx *ctx,
+								u32 pixfmt)
+{
+	const struct mtk_vcodec_dec_pdata *dec_pdata = ctx->dev->vdec_pdata;
+	int i;
+
+	for (i = 0; i < *dec_pdata->num_framesizes; ++i)
+		if (pixfmt == dec_pdata->vdec_framesizes[i].fourcc)
+			return &dec_pdata->vdec_framesizes[i].stepwise;
+
+	/*
+	 * This should never happen since vidioc_try_fmt_vid_out_mplane()
+	 * always passes through a valid format for the output side, and
+	 * for the capture side, a valid output format should already have
+	 * been set.
+	 */
+	WARN_ONCE(1, "Unsupported format requested.\n");
+	return &dec_pdata->vdec_framesizes[0].stepwise;
+}
+
 static int vidioc_try_fmt(struct mtk_vcodec_ctx *ctx, struct v4l2_format *f,
 			  const struct mtk_video_fmt *fmt)
 {
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	const struct v4l2_frmsize_stepwise *frmsize;
+	u32 fourcc;
 
 	pix_fmt_mp->field = V4L2_FIELD_NONE;
 
-	pix_fmt_mp->width =
-		clamp(pix_fmt_mp->width, MTK_VDEC_MIN_W, ctx->max_width);
-	pix_fmt_mp->height =
-		clamp(pix_fmt_mp->height, MTK_VDEC_MIN_H, ctx->max_height);
+	/* Always apply frame size constraints from the coded side */
+	if (V4L2_TYPE_IS_OUTPUT(f->type))
+		fourcc = f->fmt.pix_mp.pixelformat;
+	else
+		fourcc = ctx->q_data[MTK_Q_DATA_SRC].fmt->fourcc;
+
+	frmsize = mtk_vdec_get_frmsize(ctx, fourcc);
+	pix_fmt_mp->width = clamp(pix_fmt_mp->width, MTK_VDEC_MIN_W, frmsize->max_width);
+	pix_fmt_mp->height = clamp(pix_fmt_mp->height, MTK_VDEC_MIN_H, frmsize->max_height);
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		pix_fmt_mp->num_planes = 1;
@@ -237,18 +264,15 @@ static int vidioc_try_fmt(struct mtk_vcodec_ctx *ctx, struct v4l2_format *f,
 		 */
 		tmp_w = pix_fmt_mp->width;
 		tmp_h = pix_fmt_mp->height;
-		v4l_bound_align_image(&pix_fmt_mp->width,
-					MTK_VDEC_MIN_W,
-					ctx->max_width, 6,
-					&pix_fmt_mp->height,
-					MTK_VDEC_MIN_H,
-					ctx->max_height, 6, 9);
+		v4l_bound_align_image(&pix_fmt_mp->width, MTK_VDEC_MIN_W, frmsize->max_width, 6,
+				      &pix_fmt_mp->height, MTK_VDEC_MIN_H, frmsize->max_height, 6,
+				      9);
 
 		if (pix_fmt_mp->width < tmp_w &&
-			(pix_fmt_mp->width + 64) <= ctx->max_width)
+		    (pix_fmt_mp->width + 64) <= frmsize->max_width)
 			pix_fmt_mp->width += 64;
 		if (pix_fmt_mp->height < tmp_h &&
-			(pix_fmt_mp->height + 64) <= ctx->max_height)
+		    (pix_fmt_mp->height + 64) <= frmsize->max_height)
 			pix_fmt_mp->height += 64;
 
 		mtk_v4l2_debug(0,
-- 
2.35.1



