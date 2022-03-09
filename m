Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868574D3108
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 15:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiCIOet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 09:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiCIOes (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 09:34:48 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B87C3BA60;
        Wed,  9 Mar 2022 06:33:50 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q189so2803127oia.9;
        Wed, 09 Mar 2022 06:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2XrzvV53Hq99R7iC1cFXjuoe4N7fIB4/waYIPl8IPw=;
        b=BpV5fqjXq5es6c97DPQfjqmyvEdTvSRdTfHQt1wUvS/994UGM2pMJbWLddMFpsbLeH
         xYJ7vaRrakk0Pc7qve626tjtUbl/1nx2SFZcGGoJLfpONTiLfoikR8ECuNM+Xkp546ZY
         rr9C6qcfSd9e+/vG1omKz5aUSMzkgKxqc9SXA4OX79/glKW5MGRgBoGwYrvEYbRTUCXw
         Gg6Ohx1R6VCZk5eUPhYsdOMP8LrQ0FTSfj0CStZ2aC0nyP5RkHlluEf6b2N3qqh0EYso
         Zev56GVb5fUonybt0t5wTEvtuXypUK/hjE2FgvUZlhxIKyv3AIauu31+cv2Wa9g6J9e3
         wvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=t2XrzvV53Hq99R7iC1cFXjuoe4N7fIB4/waYIPl8IPw=;
        b=U81Mko5jUfiSaoG5LSPBtCwRTvVPLeGWoPJOIxKR7yAx25lcAG3Lw8JJHekg4KOa6U
         q74LDMhS/fvYXpC07q2VT0VKaIZovz+tQjSI9/9hJflV72nN5XJgWlS/w9JRKAWJgU9S
         7T8Jx0RJelFatYS6MILViU++SH981I7O8lTjMH5/ARCuS+OWf1TeVLbYsi5IqYBatcpe
         MCAXxnaFqlBqkff+r59iJUR/aszdGxWzV+ZF+8oO+K2e5Q6cqSPNUfKqyOKNw+plLRSD
         NWVHtTgctxRDVIZU+5ncww6TAM0EfPQgsxp6p8O0SQvHhUH0v1ucCS9pyMd2TVvc/9WN
         bJDw==
X-Gm-Message-State: AOAM5307GtjGJfI/3Cz5pAa/NpGMgBRMRIpCWnPyKjDa2qMcpZJye638
        ffwISjJ9+S0RATuYFEWAk3ge7xUh6L0=
X-Google-Smtp-Source: ABdhPJwt26KommPJT+5b9UKMFX7xZAKHpxjko3GjWgEpoDs/sffCt+3Rz7emim2bvYd7vCahNxPrgA==
X-Received: by 2002:a05:6808:10c6:b0:2d9:a01a:4bbc with SMTP id s6-20020a05680810c600b002d9a01a4bbcmr6284246ois.227.1646836429347;
        Wed, 09 Mar 2022 06:33:49 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:9f7c:9178:2645:4362])
        by smtp.gmail.com with ESMTPSA id j25-20020a4ad199000000b003171dfeb5bfsm1007362oor.15.2022.03.09.06.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 06:33:48 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     hverkuil-cisco@xs4all.nl
Cc:     p.zabel@pengutronix.de, linux-media@vger.kernel.org,
        nicolas.dufresne@collabora.com, ezequiel@collabora.com,
        kernel@iktek.de, stable@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2 1/2] media: coda: Fix reported H264 profile
Date:   Wed,  9 Mar 2022 11:33:21 -0300
Message-Id: <20220309143322.1755281-1-festevam@gmail.com>
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
---
Changes since v1:
- Followed Phillip's suggestion to change the commit message to say that
ASO/FMO features are unsupported for the encoder and untested for the
decoder because there is no userspace support.
https://patchwork.kernel.org/project/linux-media/patch/20200717034923.219524-1-ezequiel@collabora.com/
- Added Pascal's Tested-by tag.

 drivers/media/platform/coda/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index a57822b05070..53b2dd1b268c 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
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

