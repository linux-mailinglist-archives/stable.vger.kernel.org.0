Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE3C24BEFC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728498AbgHTNd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:33:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgHTJa4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:30:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA15520855;
        Thu, 20 Aug 2020 09:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915855;
        bh=9iIh+itXFCiJpzJCgY8kQPXUYNArH99tHwymyYCggEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwW5SyXurM9WvGh0eF2jJDf+2Y5wa8Kmp0n78OV++HPiDX/R3FsdoeONWJqHVCYqy
         EJFo43fpFu/l0P+1CnvrGO3q9vcU2sxalh1ZNq5d77ofPMcAny0KG4mvCUT5lfCjEN
         TlcjsFUP6QakrPM2c1MG8scrIrr4FJwKEg9rNzco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 128/232] media: rockchip: rga: Only set output CSC mode for RGB input
Date:   Thu, 20 Aug 2020 11:19:39 +0200
Message-Id: <20200820091619.015926855@linuxfoundation.org>
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

[ Upstream commit 0f879bab72f47e8ba2421a984e7acfa763d3e84e ]

Setting the output CSC mode is required for a YUV output, but must not
be set when the input is also YUV. Doing this (as tested with a YUV420P
to YUV420P conversion) results in wrong colors.

Adapt the logic to only set the output CSC mode when the output is YUV and
the input is RGB. Also add a comment to clarify the rationale.

Fixes: f7e7b48e6d79 ("[media] rockchip/rga: v4l2 m2m support")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rga/rga-hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rga/rga-hw.c b/drivers/media/platform/rockchip/rga/rga-hw.c
index 5607ee8d19176..aaa96f256356b 100644
--- a/drivers/media/platform/rockchip/rga/rga-hw.c
+++ b/drivers/media/platform/rockchip/rga/rga-hw.c
@@ -200,6 +200,11 @@ static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
 	dst_info.data.format = ctx->out.fmt->hw_format;
 	dst_info.data.swap = ctx->out.fmt->color_swap;
 
+	/*
+	 * CSC mode must only be set when the colorspace families differ between
+	 * input and output. It must remain unset (zeroed) if both are the same.
+	 */
+
 	if (RGA_COLOR_FMT_IS_YUV(ctx->in.fmt->hw_format) &&
 	    RGA_COLOR_FMT_IS_RGB(ctx->out.fmt->hw_format)) {
 		switch (ctx->in.colorspace) {
@@ -212,7 +217,8 @@ static void rga_cmd_set_trans_info(struct rga_ctx *ctx)
 		}
 	}
 
-	if (RGA_COLOR_FMT_IS_YUV(ctx->out.fmt->hw_format)) {
+	if (RGA_COLOR_FMT_IS_RGB(ctx->in.fmt->hw_format) &&
+	    RGA_COLOR_FMT_IS_YUV(ctx->out.fmt->hw_format)) {
 		switch (ctx->out.colorspace) {
 		case V4L2_COLORSPACE_REC709:
 			dst_info.data.csc_mode = RGA_SRC_CSC_MODE_BT709_R0;
-- 
2.25.1



