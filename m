Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC51C538196
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240807AbiE3OU0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241399AbiE3ORe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFED690CCD;
        Mon, 30 May 2022 06:46:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71235B80D6B;
        Mon, 30 May 2022 13:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E5C3411C;
        Mon, 30 May 2022 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918369;
        bh=B5GNaQpb3YP1aqvByEDzMbFq8eopAP8XA9OqX5EGz9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BqtmBHzN2GXcL63Bakr/cXoudkiC1/NNtfIV7LL7Bxh772A3GvpmGxP3hWlhWYCSU
         em0uU5w/BHluTPrU/XD3W9Ipb5GgjIfa8AYfHYrXHuM91p8GJm/xPJlCOR1e5xtKQ4
         pPc2COGCfnyG82IVXc2/mxggxz0nTGPV/tGoDitHgHp0i662chGiutZm2CE8XXn0Oi
         tfBiThSIW8fmsRbvBgf9b0Qag7+rXNNAtmlhqPKkxxKOka6tF1mVuC0Nne8MuQ+euH
         ITvStH1+lQbYsJDaSTMehKjyfhRX0Ui1Vb5V94LNwtndL763Ruf8FWb03zz+cVPEyv
         +ExJ5UiXFhF1A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linmq006@gmail.com,
        martin.weber@br-automation.com, wsa+renesas@sang-engineering.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 56/76] media: coda: limit frame interval enumeration to supported encoder frame sizes
Date:   Mon, 30 May 2022 09:43:46 -0400
Message-Id: <20220530134406.1934928-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 67e33dd957880879e785cfea83a3aa24bd5c5577 ]

Let VIDIOC_ENUM_FRAMEINTERVALS return -EINVAL if userspace queries
frame intervals for frame sizes unsupported by the encoder. Fixes the
following v4l2-compliance failure:

		fail: v4l2-test-formats.cpp(123): found frame intervals for invalid size 47x16
		fail: v4l2-test-formats.cpp(282): node->codec_mask & STATEFUL_ENCODER
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL

[hverkuil: drop incorrect 'For decoder devices, return -ENOTTY.' in the commit log]

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/coda/coda-common.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2333079a83c7..99f6d22e0c3c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1318,7 +1318,8 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
 				    struct v4l2_frmivalenum *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
-	int i;
+	struct coda_q_data *q_data;
+	const struct coda_codec *codec;
 
 	if (f->index)
 		return -EINVAL;
@@ -1327,12 +1328,19 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
 	if (!ctx->vdoa && f->pixel_format == V4L2_PIX_FMT_YUYV)
 		return -EINVAL;
 
-	for (i = 0; i < CODA_MAX_FORMATS; i++) {
-		if (f->pixel_format == ctx->cvd->src_formats[i] ||
-		    f->pixel_format == ctx->cvd->dst_formats[i])
-			break;
+	if (coda_format_normalize_yuv(f->pixel_format) == V4L2_PIX_FMT_YUV420) {
+		q_data = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		codec = coda_find_codec(ctx->dev, f->pixel_format,
+					q_data->fourcc);
+	} else {
+		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
+					f->pixel_format);
 	}
-	if (i == CODA_MAX_FORMATS)
+	if (!codec)
+		return -EINVAL;
+
+	if (f->width < MIN_W || f->width > codec->max_w ||
+	    f->height < MIN_H || f->height > codec->max_h)
 		return -EINVAL;
 
 	f->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
-- 
2.35.1

