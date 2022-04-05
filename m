Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90694F47E3
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346882AbiDEVWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443841AbiDEPkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:40:22 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DDF10E549;
        Tue,  5 Apr 2022 07:00:39 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t21so13460182oie.11;
        Tue, 05 Apr 2022 07:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HFMQgSR3Z2986CsvnsaxYCQAxCwwsfFViVfXTurYbuM=;
        b=c1d6GMnUCpuBiRYFYUMeSmkzMXbgvzFsmhNTEx5ALxlYDIIgEnDIC3KEYkk6w/FhpB
         TqVO5CZYMwkItnXKm6jAm5gJKI+LlTivA+RxswnPYXL/iqNzg6845SVJ73UQ688A8jcs
         oSrVMzCdB4Nn2/yrnVEoi3VY8cA3XL6SuQ81cLQRPYsQJBBqBjdVW+w5MGnrlaR75kCV
         1IdwIAJxCk/DkKh/Hhse2iBWJmL6f3VX2hw2m1so0+gyIuPgNsdSsoGKWgwDithk/bCU
         yQPKhif0qham54k/tTgXOhPtbKbz9MSqGWkUqmBHfi3GkMM3kMBPSPEPoURcYK/qg7Lv
         +dDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HFMQgSR3Z2986CsvnsaxYCQAxCwwsfFViVfXTurYbuM=;
        b=iGEAU/bcSb8f4htHiqicAPlAF4GziMejaZpi9/QWfId/jnv+Dt0IqvQgcIg6rjxN45
         LvoF2tvRbnKEw2/Rm71gkq2R0sXn5TvtuZt/HxKR7zgUpT+60Ww5FEoE+MAmnASOIYGH
         p/vv24o/X5BYLH6Xp56IlJzwhTwlq/b3yvwcn3gTWdCSkVKvhOnfYPgpVlenD1DFwGck
         KOlJ+rCmchHmg3ZPQQZNMHqMS6WSxfA3hw0+AWoCJA7zJKWbYsX+oZfvG0fyRhYD227K
         lAZ3RniQkcFxD75F9MHAu+zrOm0q6GbofoyaIxoFPlv1LmlJDvy3caem2f5O9LKGlPgG
         Vq5g==
X-Gm-Message-State: AOAM532ZmYoX1NwpPYMDmR3DTrRsyMCz+mgUwURqfm28C9dTLqA3Gtmr
        n8XuJg0Y8SfCCKiiJKA3wlc=
X-Google-Smtp-Source: ABdhPJyx+UrnCCCC/dq6VupZvYiQblLTfNZtdfBOgNWTKrCgoNVnGNSrcKZIjfn8KOCE1dlioTnWEw==
X-Received: by 2002:a05:6808:c:b0:2ef:8913:354 with SMTP id u12-20020a056808000c00b002ef89130354mr1429138oic.201.1649167238532;
        Tue, 05 Apr 2022 07:00:38 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:99d5:2af:ddde:2ce0])
        by smtp.gmail.com with ESMTPSA id c3-20020a056808138300b002f76b9a9ef6sm5537029oiw.10.2022.04.05.07.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 07:00:37 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     nicolas.dufresne@collabora.com, kernel@iktek.de,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v4 1/2] media: coda: Fix reported H264 profile
Date:   Tue,  5 Apr 2022 10:59:56 -0300
Message-Id: <20220405135957.3580343-1-festevam@gmail.com>
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
Changes since v3:
- Rebased against linux-next and took the coda->chips-media rename
in consideration.

 drivers/media/platform/chips-media/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/chips-media/coda-common.c b/drivers/media/platform/chips-media/coda-common.c
index a57822b05070..53b2dd1b268c 100644
--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -2344,8 +2344,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
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
@@ -2426,7 +2426,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
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

