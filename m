Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94265541E40
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbiFGW1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382467AbiFGWYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:24:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08BB26D37A;
        Tue,  7 Jun 2022 12:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5A24B823CC;
        Tue,  7 Jun 2022 19:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459A0C34115;
        Tue,  7 Jun 2022 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629755;
        bh=Oi1NSIjcbY9SuzHX20ZcJb9MNusOYrpRgA7ZUNRtZFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRqHkLIVe9EpQUgPEuFJqnVStF1eDW7u2egR3clA7Xcn0zeoL5cQI0HwkyenoK3+l
         ymSeIt9U4J7HEd2bvB61kNKl4mS6PKBfGIDTuNBrkj1mipflvcjxpd3+hEzar5uOD6
         jD+968HE7awNJXKm1CCOrGBXLI9t8hNxlNHbaLhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Fabio Estevam <festevam@denx.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.18 803/879] media: coda: Add more H264 levels for CODA960
Date:   Tue,  7 Jun 2022 19:05:21 +0200
Message-Id: <20220607165026.167855829@linuxfoundation.org>
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

commit eb2fd187abc878a2dfad46902becb74963473c7d upstream.

Add H264 level 1.0, 4.1, 4.2 to the list of supported formats.
While the hardware does not fully support these levels, it does support
most of them. The constraints on frame size and pixel formats already
cover the limitation.

This fixes negotiation of level on GStreamer 1.17.1.

Cc: stable@vger.kernel.org
Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/coda-common.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/chips-media/coda-common.c
+++ b/drivers/media/platform/chips-media/coda-common.c
@@ -2367,12 +2367,15 @@ static void coda_encode_ctrls(struct cod
 	if (ctx->dev->devtype->product == CODA_960) {
 		v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_H264_LEVEL,
-			V4L2_MPEG_VIDEO_H264_LEVEL_4_0,
-			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
+			V4L2_MPEG_VIDEO_H264_LEVEL_4_2,
+			~((1 << V4L2_MPEG_VIDEO_H264_LEVEL_1_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_2_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
-			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2)),
 			V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
 	}
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,


