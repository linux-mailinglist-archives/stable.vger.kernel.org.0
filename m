Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3B64F6CA1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiDFV3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiDFV1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:27:22 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B733CC5B;
        Wed,  6 Apr 2022 13:23:59 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-d39f741ba0so4145329fac.13;
        Wed, 06 Apr 2022 13:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NFwRpN+axU2fGIRhuO/Nuug9sEEFRFzukZI+AiuZOds=;
        b=WhXgnCGPoRqJbX85ZWbjJuYGLaztt+bQldNU+pncfTNdX8JwNuyHXVlmTEfw2iaffE
         CQujLbbD0oPcJCwd1sJsorDeojA+fjwzl2uvooV07R1PjkD1Pu518HgyksWMQvLhOMuV
         s3wTDCKOUyBewzigkeNexPPew0lD5T8myF9GwrMH4/1UGuMA/QsFh7NYSUC/Y3RSGjA9
         TV+gmLR2K2nXXzXOz/rQC4LRf8YyPDd1dkFDJvvBidXjzxuhO3hfbn2OHScHwwF/5WX2
         eKuYXPyOTAx0GMIj3OutdBs2U+lVusm65ciCmhxerHCbddqj3V+1Gc7j7LbPsuGI9gOS
         sWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NFwRpN+axU2fGIRhuO/Nuug9sEEFRFzukZI+AiuZOds=;
        b=rG+e11fs8WeYzEJJ9rgstivTcwwqXQu54o8lvu1hS8haHtRVc5FvJwTtqfTmQHV9TZ
         9JFmiNfm74CGNR44jAwGDvGSu/LWI7VnVBsoxDtBtDzLdNMdv5fgMjXa992AsyLPbJho
         hw26yJ2KnTLVF09yMWSYGcDEqF8SqPmz9ME8iJMcdLDFSFZwAS5O8rmqYJ5+XV6MyNia
         mWZP/MagN94F6bxyTnIz10hs9SWUFPlEKzcDKsEOyKdvoPNHtLx0K8d5O0grH+ZHxLwZ
         SjKdALTsyPZTP43sHfsmf3REExFhusONOWGmer6k7W9QoLQUuDgykITtH7Vs+bAcWo5B
         a+1A==
X-Gm-Message-State: AOAM530rImJ9DDp8VuMTDkqoOFn3Zkwowxw2cMWK/ejxxCN5XjNO2XxQ
        4icicT1lo2pOFDEhZs5TJng=
X-Google-Smtp-Source: ABdhPJyxZ/OEKdgOgCma1s+cWeIQMp/yodeOiisndZILS7EP9ws5PnYdbc+6B0ZM7xM6kCKfNGXa/g==
X-Received: by 2002:a05:6870:9693:b0:de:e86c:8808 with SMTP id o19-20020a056870969300b000dee86c8808mr4753561oaq.278.1649276638206;
        Wed, 06 Apr 2022 13:23:58 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:d779:c3b1:bb03:19d1])
        by smtp.gmail.com with ESMTPSA id r23-20020a056830237700b005b2610517c8sm7497894oth.56.2022.04.06.13.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:23:57 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     nicolas.dufresne@collabora.com, kernel@iktek.de,
        p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v5 1/2] media: coda: Fix reported H264 profile
Date:   Wed,  6 Apr 2022 17:23:42 -0300
Message-Id: <20220406202343.139638-1-festevam@gmail.com>
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
Changes since v4:
- None

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

