Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B762541E37
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357651AbiFGW1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383427AbiFGWXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:23:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40B526D365;
        Tue,  7 Jun 2022 12:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E86DB823CE;
        Tue,  7 Jun 2022 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849E0C385A2;
        Tue,  7 Jun 2022 19:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629752;
        bh=+IfqOCzwaOrmz8FUKlrazyobBxrUXzibkiJetByMUS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXhMIz7SPIlM1xk3LzP3uUEF5mjxGbrWrHZIc52O5HLkI+Mndt8vsTvSKjRDO2RTH
         0sZ0Jzv2kbh6x43uRQL2xznyMPJgXciQ+v1gkGxnV8xxNtIxbH0ltvXNcGvwm3hEw8
         nJQYB5cFn5atqcKpflqIunwaIEqvueLRiQ09ydRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Pascal Speck <kernel@iktek.de>,
        Fabio Estevam <festevam@denx.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.18 802/879] media: coda: Fix reported H264 profile
Date:   Tue,  7 Jun 2022 19:05:20 +0200
Message-Id: <20220607165026.138177337@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit 7110c08ea71953a7fc342f0b76046f72442cf26c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/coda-common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -2352,8 +2352,8 @@ static void coda_encode_ctrls(struct cod
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
@@ -2434,7 +2434,7 @@ static void coda_decode_ctrls(struct cod
 	ctx->h264_profile_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
 		&coda_ctrl_ops, V4L2_CID_MPEG_VIDEO_H264_PROFILE,
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
-		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE) |
+		~((1 << V4L2_MPEG_VIDEO_H264_PROFILE_CONSTRAINED_BASELINE) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_MAIN) |
 		  (1 << V4L2_MPEG_VIDEO_H264_PROFILE_HIGH)),
 		V4L2_MPEG_VIDEO_H264_PROFILE_HIGH);


