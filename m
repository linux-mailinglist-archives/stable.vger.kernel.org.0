Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580E051EBE1
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 07:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiEHFGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 01:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiEHFGx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 01:06:53 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E35210FC3
        for <stable@vger.kernel.org>; Sat,  7 May 2022 22:03:04 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nnZ4P-0027tW-AC; Sun, 08 May 2022 05:03:01 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sun, 24 Apr 2022 07:48:49 +0000
Subject: [git:media_tree/master] media: coda: Fix reported H264 profile
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Fabio Estevam <festevam@denx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>, stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Pascal Speck <kernel@iktek.de>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nnZ4P-0027tW-AC@www.linuxtv.org>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: coda: Fix reported H264 profile
Author:  Nicolas Dufresne <nicolas.dufresne@collabora.com>
Date:    Wed Apr 6 21:23:42 2022 +0100

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/chips-media/coda-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

---

diff --git a/drivers/media/platform/chips-media/coda-common.c b/drivers/media/platform/chips-media/coda-common.c
index 7b4942bb6c2c..36ec5a50a491 100644
--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -2332,8 +2332,8 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
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
@@ -2414,7 +2414,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
 	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
 		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
-		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);
