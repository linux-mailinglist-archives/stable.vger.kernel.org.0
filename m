Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FBF537CFA
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbiE3Nhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbiE3NgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:36:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE9985EC6;
        Mon, 30 May 2022 06:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D56AB80DA8;
        Mon, 30 May 2022 13:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062D0C3411F;
        Mon, 30 May 2022 13:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917378;
        bh=XCIo5oBjPhUPMtJO6VtGpo5T64/wBIlRjbYu4ZudoSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ibqdi2V+5gsRbUlNzL7nU51jooMtJcvXKoeg6mVwjjjWg5P4cRMpWPcOaU8Gb6Dyc
         94kInndnTjJFzc0atIaApDZeCe9jAh4aQMWmcwVWuNmFE8vhNr8zbUDyAr8W7tJUWS
         beOZngTOI7dRQ8TA6hcAsSyEwwggi9WzqLGYOOUc73q/qlqiCcJP1bcBvX6ktqZ5Ze
         RNftJqh+7SLM5wYw0RmNAUxJxemutwcQuRX3UubaSbhwcNOEw/iF+55A5ZMnDRvsfe
         S/XiCplGYlcydEzl8XpUIvEgASJK9xMyxY7djY6WZGxuyw3o+8l6Bu6j+0p21J8kaU
         lBC7/ku8JSe6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 113/159] media: coda: limit frame interval enumeration to supported encoder frame sizes
Date:   Mon, 30 May 2022 09:23:38 -0400
Message-Id: <20220530132425.1929512-113-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
 .../media/platform/chips-media/coda-common.c  | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-common.c b/drivers/media/platform/chips-media/coda-common.c
index a57822b05070..a2cad1830318 100644
--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -1324,7 +1324,8 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
 				    struct v4l2_frmivalenum *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
-	int i;
+	struct coda_q_data *q_data;
+	const struct coda_codec *codec;
 
 	if (f->index)
 		return -EINVAL;
@@ -1333,12 +1334,19 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
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

