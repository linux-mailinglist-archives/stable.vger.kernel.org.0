Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4056590022
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiHKPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 11:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiHKPhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 11:37:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641C49F188;
        Thu, 11 Aug 2022 08:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3664615FD;
        Thu, 11 Aug 2022 15:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B007FC433B5;
        Thu, 11 Aug 2022 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232021;
        bh=xizQ1FcyAgy3xUVeDsDcPWFhWdEEzYl0CwRjLQCek1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMVw7Tkg1oyV7qv71PPsbFLm947vNv9LkY47OqE4B6P8/iD8FH5pvOKUQFjuCGxTM
         63Re0Qd6UahsI+jLchAsZzDUKU2Ng65+8PYjZUYDv2Sf1KJzYGkP3nRO1szBpLTyvv
         xIL5I2g1V2gMDO+5Cso0As21AoSzdyYs25Y/pH1N22PoyjFJuZnkGXy7nW/GsbcFcG
         DOMn7DybooO43QqF+M6go8786FwNOM4cjrZCJbKlgzat7jFpWkxhNUjvDOY3H1sIzt
         y3hSf1Zxc3EdGRekpGKVuWL+ITGLnkVLGFrlQLDZxCfQvjvlLGe8ZjjUf+qpplfQQN
         tFFec03oxFFBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hirokazu Honda <hiroh@chromium.org>,
        Irui Wang <irui.wang@mediatek.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, matthias.bgg@gmail.com,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 049/105] media: mediatek: vcodec: Report supported bitrate modes
Date:   Thu, 11 Aug 2022 11:27:33 -0400
Message-Id: <20220811152851.1520029-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit d8e8aa866ed8636fd6c1017c3d9453eab2922496 ]

The media driver supports constant bitrate mode only.
The supported rate control mode is reported through querymenu() and
s_ctrl() fails if non constant bitrate mode (e.g. VBR) is requested.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Irui Wang <irui.wang@mediatek.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/mtk_vcodec_enc.c   | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
index c21367038c34..98d451ce2545 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
@@ -50,6 +50,14 @@ static int vidioc_venc_s_ctrl(struct v4l2_ctrl *ctrl)
 	int ret = 0;
 
 	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_BITRATE_MODE:
+		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_BITRATE_MODE val= %d",
+			       ctrl->val);
+		if (ctrl->val != V4L2_MPEG_VIDEO_BITRATE_MODE_CBR) {
+			mtk_v4l2_err("Unsupported bitrate mode =%d", ctrl->val);
+			ret = -EINVAL;
+		}
+		break;
 	case V4L2_CID_MPEG_VIDEO_BITRATE:
 		mtk_v4l2_debug(2, "V4L2_CID_MPEG_VIDEO_BITRATE val = %d",
 			       ctrl->val);
@@ -1373,6 +1381,9 @@ int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
 			       0, V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
 	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_VP8_PROFILE,
 			       V4L2_MPEG_VIDEO_VP8_PROFILE_0, 0, V4L2_MPEG_VIDEO_VP8_PROFILE_0);
+	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
+			       0, V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
 
 
 	if (handler->error) {
-- 
2.35.1

