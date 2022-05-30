Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1055382ED
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240283AbiE3O3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242005AbiE3OSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:18:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B41B19D078;
        Mon, 30 May 2022 06:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F64B80DBB;
        Mon, 30 May 2022 13:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420E2C36AE3;
        Mon, 30 May 2022 13:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918528;
        bh=NYXfqZ1HeJVoDcZHWihxR8rS6ByUyPeh1j4e3NSlOOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3JtxWzI6fEl1w2TRfGv+GSrOHscMuRlssAdOX+/21KxW3MqQoAb+HVDlZy8t5Jcl
         XF0IN5FWogHUxqh3YxWUMIU3NH4S8jJUaoMmf27hQASXSADE+BbDlUUSt8SJnx+GFH
         HcCbhYYZ5bAY9ZNUNiZ/oD4PTvJVL51auQ1CuuLkSlje8HXlYAD7LhC4407iJb/oGr
         BuMntNlPxcu/aypwUPGqCypOZ0U0l4w/+Wc42rjwQ1uz32WwmfxAxHJtFRb1IKUv5O
         Hi23MuClPf7lNB7LOhP4im+e2YcOD3noUYvDu6C4mfH2keUGRe0gftKul4S/HHtDl7
         NJiFRdf0EFjlg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linmq006@gmail.com,
        wsa+renesas@sang-engineering.com, martin.weber@br-automation.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 42/55] media: coda: limit frame interval enumeration to supported encoder frame sizes
Date:   Mon, 30 May 2022 09:46:48 -0400
Message-Id: <20220530134701.1935933-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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
index 0adc54832657..fb469340634b 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1192,7 +1192,8 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
 				    struct v4l2_frmivalenum *f)
 {
 	struct coda_ctx *ctx = fh_to_ctx(fh);
-	int i;
+	struct coda_q_data *q_data;
+	const struct coda_codec *codec;
 
 	if (f->index)
 		return -EINVAL;
@@ -1201,12 +1202,19 @@ static int coda_enum_frameintervals(struct file *file, void *fh,
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

