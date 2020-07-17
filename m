Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86DB2231CA
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 05:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgGQDtm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 23:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgGQDtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 23:49:42 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2D9C061755;
        Thu, 16 Jul 2020 20:49:42 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 7DF782A528A
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Robert Beckett <bob.beckett@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        kernel@collabora.com, stable@vger.kernel.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 2/2] media: coda: Add more H264 levels for CODA960
Date:   Fri, 17 Jul 2020 00:49:23 -0300
Message-Id: <20200717034923.219524-2-ezequiel@collabora.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717034923.219524-1-ezequiel@collabora.com>
References: <20200717034923.219524-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

This add H264 level 4.1, 4.2 and 5.0 to the list of supported formats.
While the hardware does not fully support these levels, it do support
most of them. The constraints on frame size and pixel formats already
cover the limitation.

This fixes negotiation of level on GStreamer 1.17.1.

Cc: stable@vger.kernel.org
Fixes: 42a68012e67c2 ("media: coda: add read-only h.264 decoder profile/level controls")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/coda/coda-common.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index c641d1608825..d0fc573d6ed9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2355,7 +2355,10 @@ static void coda_encode_ctrls(struct coda_ctx *ctx)
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_0) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_1) |
 			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_3_2) |
-			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0)),
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_0) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_1) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_4_2) |
+			  (1 << V4L2_MPEG_VIDEO_H264_LEVEL_5_0)),
 			V4L2_MPEG_VIDEO_H264_LEVEL_4_0);
 	}
 	v4l2_ctrl_new_std(&ctx->ctrls, &coda_ctrl_ops,
@@ -2428,7 +2431,7 @@ static void coda_decode_ctrls(struct coda_ctx *ctx)
 	    ctx->dev->devtype->product == CODA_7541)
 		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_0;
 	else if (ctx->dev->devtype->product == CODA_960)
-		max = V4L2_MPEG_VIDEO_H264_LEVEL_4_1;
+		max = V4L2_MPEG_VIDEO_H264_LEVEL_5_0;
 	else
 		return;
 	ctx->h264_level_ctrl = v4l2_ctrl_new_std_menu(&ctx->ctrls,
-- 
2.27.0

