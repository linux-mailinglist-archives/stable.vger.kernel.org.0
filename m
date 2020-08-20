Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9535B24BEFA
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgHTNd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgHTJax (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F18207FB;
        Thu, 20 Aug 2020 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915852;
        bh=fjrrMDfBO1Mz4mhFZZuxpgLz4SiHw1f/z7NFYaXekAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qlxbSdj16q3OdeeXphEsG9KgP1l9p85D/rLi3fWjcN2n5h4Cyt4F9u+dQNS4gIBA
         rQpX9vzX1YcO7F6zQ6t7jOBl5/VRsddmM+ey+vg47JUyD9zA+h4vFB7JSJQx+OQexZ
         N9L5TyL5UOVJ1M/VDyCfAihgr8QKWxmT6dBnztro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 127/232] media: rockchip: rga: Introduce color fmt macros and refactor CSC mode logic
Date:   Thu, 20 Aug 2020 11:19:38 +0200
Message-Id: <20200820091618.966502131@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit ded874ece29d3fe2abd3775810a06056067eb68c ]

This introduces two macros: RGA_COLOR_FMT_IS_YUV and RGA_COLOR_FMT_IS_RGB
which allow quick checking of the colorspace familily of a RGA color format.

These macros are then used to refactor the logic for CSC mode selection.
The two nested tests for input colorspace are simplified into a single one,
with a logical and, making the whole more readable.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 23 +++++++++-----------
 drivers/media/platform/rockchip/rga/rga-hw.h |  5 +++++
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index 4be6dcf292fff..5607ee8d19176 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -200,22 +200,19 @@ static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
 	dst_info.data.format = ctx->out.fmt->hw_format;
 	dst_info.data.swap = ctx->out.fmt->color_swap;
 
-	if (ctx->in.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP) {
-		if (ctx->out.fmt->hw_format < RGA_COLOR_FMT_YUV422SP) {
-			switch (ctx->in.colorspace) {
-			case V4L2_COLORSPACE_REC709:
-				src_info.data.csc_mode =
-					RGA_SRC_CSC_MODE_BT709_R0;
-				break;
-			default:
-				src_info.data.csc_mode =
-					RGA_SRC_CSC_MODE_BT601_R0;
-				break;
-			}
+	if (RGA_COLOR_FMT_IS_YUV(ctx->in.fmt->hw_format) &&
+	    RGA_COLOR_FMT_IS_RGB(ctx->out.fmt->hw_format)) {
+		switch (ctx->in.colorspace) {
+		case V4L2_COLORSPACE_REC709:
+			src_info.data.csc_mode = RGA_SRC_CSC_MODE_BT709_R0;
+			break;
+		default:
+			src_info.data.csc_mode = RGA_SRC_CSC_MODE_BT601_R0;
+			break;
 		}
 	}
 
-	if (ctx->out.fmt->hw_format >= RGA_COLOR_FMT_YUV422SP) {
+	if (RGA_COLOR_FMT_IS_YUV(ctx->out.fmt->hw_format)) {
 		switch (ctx->out.colorspace) {
 		case V4L2_COLORSPACE_REC709:
 			dst_info.data.csc_mode = RGA_SRC_CSC_MODE_BT709_R0;
diff --git a/drivers/media/platform/rockchip/rga/rga-hw.h b/drivers/media/platform/rockchip/rga/rga-hw.h
index 96cb0314dfa70..e8917e5630a48 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.h
+++ b/drivers/media/platform/rockchip/rga/rga-hw.h
@@ -95,6 +95,11 @@
 #define RGA_COLOR_FMT_CP_8BPP 15
 #define RGA_COLOR_FMT_MASK 15
 
+#define RGA_COLOR_FMT_IS_YUV(fmt) \
+	(((fmt) >= RGA_COLOR_FMT_YUV422SP) && ((fmt) < RGA_COLOR_FMT_CP_1BPP))
+#define RGA_COLOR_FMT_IS_RGB(fmt) \
+	((fmt) < RGA_COLOR_FMT_YUV422SP)
+
 #define RGA_COLOR_NONE_SWAP 0
 #define RGA_COLOR_RB_SWAP 1
 #define RGA_COLOR_ALPHA_SWAP 2
-- 
2.25.1



