Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D981E603F78
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiJSJb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233904AbiJSJ3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:29:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2873C4DB9;
        Wed, 19 Oct 2022 02:13:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E5061753;
        Wed, 19 Oct 2022 09:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A30C433C1;
        Wed, 19 Oct 2022 09:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170096;
        bh=JsDx77DlKx59+hH1YurFER2oKGhdjNdket3/uH/5OJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5n3cPBGYmPgYdg5YUBnpKGCuMW0D604mkOTev61dKuOPx3X2JmFFeCssoTtE4jM0
         FGBm6aOnS3VSHqHYbqn9Kv4Qj5Weq2sPSeVZytP4rhalG71IePTItnCZptrf55mZXR
         B/QrY1cBl3u4+ncyFjzqc3oUKe4CcfNzNbvQORe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hirokazu Honda <hiroh@chromium.org>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 489/862] media: mediatek: vcodec: Skip non CBR bitrate mode
Date:   Wed, 19 Oct 2022 10:29:36 +0200
Message-Id: <20221019083311.591055410@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit e7bfdf0a854037e8c0597f1f44f72651869c424d ]

V4L2_MPEG_VIDEO_BITRATE_MODE_CBR is the only bitrate mode supported
by the mediatek driver. The other bitrates must be skipped in
QUERY_MENU.

Fixes: d8e8aa866ed8 ("media: mediatek: vcodec: Report supported bitrate modes")
Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
index 25e816863597..27c5fdaabed4 100644
--- a/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mediatek/vcodec/mtk_vcodec_enc.c
@@ -1403,7 +1403,8 @@ int mtk_vcodec_enc_ctrls_setup(struct mtk_vcodec_ctx *ctx)
 			       V4L2_MPEG_VIDEO_VP8_PROFILE_0, 0, V4L2_MPEG_VIDEO_VP8_PROFILE_0);
 	v4l2_ctrl_new_std_menu(handler, ops, V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
 			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR,
-			       0, V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
+			       ~(1 << V4L2_MPEG_VIDEO_BITRATE_MODE_CBR),
+			       V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
 
 
 	if (handler->error) {
-- 
2.35.1



