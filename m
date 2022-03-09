Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D624D3578
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiCIRhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbiCIRhp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 12:37:45 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41CD4C88;
        Wed,  9 Mar 2022 09:36:46 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id z9-20020a05683020c900b005b22bf41872so2236760otq.13;
        Wed, 09 Mar 2022 09:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PgK1M8J0dVJ6RVTqlqMCHnwEvT6e6UBM7IaZoLPjgsw=;
        b=R/iKkOGPfQEa7dGp1dXqRfsUoJxSvotbvMPJ+Lk6EheV5BHYUHoXUUkEIK4OhYd9Za
         /ge5CEnG/Sxx9vpX0y2fdiK7NtqgoEoyiEmQUDPolKykTXVB/JCkncQlsApGWZbzf9YI
         qd/vL1czM2knHDETRhQz0FAuLazJzJvm4zHnQR6Sf5hNkFokdfpYHK+yI5h3XY4JBVKl
         sxsX9SH3DdrKvl7i7csc4vRnPHrKhGDPFHV/WgbD5ENS3KmEIntrkHyHzr2LE18jXrfa
         rv9wreRPfvzM7NYpW/rG3dFvAlc9UICcMrSIY0IC7iqo23E6dBp4opRWxNQ9Ee6KUdFS
         DLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PgK1M8J0dVJ6RVTqlqMCHnwEvT6e6UBM7IaZoLPjgsw=;
        b=cp1yOC3iOH0W8Ycm9iSxyNptPw2fOK2icdIRoNhvd88jDeW8ZvG3cpisSTpqO4XTXv
         GW3DZ633y32oyafwCeYWU2kH+UOp12sXByN9MF5fp6BBJc73yD4KmAPbeFJGIcTPcLmJ
         xSYEp9PgyQBplZ2l7F4k3gyH3ch5skH4S3gzLLns2Nft7UUxVvUzmhONpWcN+MsCOot3
         OpEIGfqhDldCujtxYdNfKlDwiTqs9K4X5/Z2+t9ItgkCif+r9jU8BCEd9xk0ovOG9BW6
         Hzxf4iaQARtCeUSXtp0GiqSe9tWw/3q/vHKGLecaBxRvjK6/a5a8S9uk9eY4oyVxygVX
         HQqQ==
X-Gm-Message-State: AOAM5312F13Gd2/pIbZBUpcmsqnmp8xj+RRQ7KDnxsDjqA5E5mxVUG5b
        Ii7eq43UnCCIEnwHOYzu4TY=
X-Google-Smtp-Source: ABdhPJyX4dDmHXW52QFwQ4mJAKy0pSjJXDjod5GzY9hG+QdInHCnmf9zqckuFJHWxIvsSDrfNmuyig==
X-Received: by 2002:a05:6830:1deb:b0:5b2:308f:e5b7 with SMTP id b11-20020a0568301deb00b005b2308fe5b7mr442871otj.332.1646847405880;
        Wed, 09 Mar 2022 09:36:45 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:34e1:d0f:6368:c8ce])
        by smtp.gmail.com with ESMTPSA id o17-20020a9d5c11000000b005b2611a13edsm1220891otk.61.2022.03.09.09.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:36:45 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, ezequiel@collabora.com,
        kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v3 1/2] media: coda: Fix reported H264 profile
Date:   Wed,  9 Mar 2022 14:36:35 -0300
Message-Id: <20220309173636.1879419-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

The CODA960 manual states that ASO/FMO features of baseline are not
supported, so for this reason this driver should only report
constrained baseline support.

This fixes negotiation issue with constrained baseline content
on GStreamer 1.17.1.

ASO/FMO features are unsupported for the encoder and untested for the
decoder because there is currently no userspace support. Neither GStreamer
parsers nor FFMPEG parsers support ASO/FMO.

Cc: stable@vger.kernel.org
Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Tested-by: Pascal Speck <kernel@iktek.de>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
- None. Only addded Philipp' Reviewed-by tag.

 drivers/media/platform/coda/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 1eed69d29149..280d77f1567c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2334,8 +2334,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 		V4L2_CID_MPEG_VIDEO_H264_CHROMA_QP_INDEX_OFFSET, -12, 12, 1, 0);
 	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_H264_PROFILE,
-		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE, 0x0,
-		V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE);
+		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE, 0x0,
+		V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE);
 	if (ctx->dev->devtype->product == CODA_HX4 ||
 	    ctx->dev->devtype->product == CODA_7541) {
 		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
@@ -2416,7 +2416,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
 	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
 		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
-		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
-- 
2.25.1

